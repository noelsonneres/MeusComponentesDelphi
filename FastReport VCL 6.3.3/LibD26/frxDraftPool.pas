{******************************************}
{                                          }
{             FastReport v5.0              }
{    Multithreaded Document Generating     }
{                                          }
{         Copyright (c) 1998-2010          }
{           by Anton Khayrudinov           }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxDraftPool;

interface

{$I frx.inc}

uses
  frxStorage, Windows, Classes;

type
  TDpThread = class;

  { Processing routine.
    This routine accepts a draft sheet and generates an actual
    document page. This routine is called within a thread context. }

  TDpProcessRoutine = procedure (Draft: TObject) of object;

  { Draft pool.
    This class performs parallel processing of document pages. }

  TDpDraftPool = class
  public

    { This list contains:

        • Matrix objects that need be converted to document sheets
        • Already created document sheets }

    Sheets: TObjList;

    { Count of currently added but not processed
      draft sheets. When threads will convert all
      draft sheets to document sheets, this value will
      become zero, and the event will become signalled. }

    DraftSheets: Integer;
    EvNoDraftSheets: THandle;

    { Lock for Sheets }

    CsSheets: TRTLCriticalSection;

    { Lock for DraftSheets }

    CsDraftSheets: TRTLCriticalSection;

    { This is a list of threads that generate document sheets. }

    Threads: TObjList {of TfrxExportThread};

    { Draft process routine }

    DraftProcess: TDpProcessRoutine;

    { Access to Sheets must be performed via these routines }

    procedure LockSheets;
    procedure UnlockSheets;

    { Acces to DraftSheets must be performed via these routines }

    procedure LockDraftSheets;
    procedure UnlockDraftSheets;

    { This routine adds a new draft matrix object to the list. }

    procedure AddDraft(Draft: TObject);

    { When a draft sheet has been converted to a document sheet,
      this routine must be called to inform the draft pool. }

    procedure DraftProcessed;

    { This routine waits for all threads that are generating
      document sheets from given drafts }

    procedure WaitForThreads;

    constructor Create(ThreadsCount, SheetsCount: LongInt;
      DraftProcRoutine: TDpProcessRoutine);

    destructor Destroy; override;

  end;

  { Export thread.
    The export thread performs two actions:

      • Waits for a draft matrix object
      • Converts the found matrix object to a document sheet

    The export thread will never stop. It must be terminated
    explicitly. }

  TDpThread = class(TThread)
  private

    FDraftSheets: TList {of TfrxDraftSheet};
    FEvNewDraft: THandle;
    FPool: TDpDraftPool;
    FCsDraftSheets: TRTLCriticalSection;
    FActiveDrafts: Integer;

    procedure LockDrafts;
    procedure UnlockDrafts;

  public

    ProcessedDrafts: Integer;
    MaxQueueLength: Integer;

    constructor Create(Pool: TDpDraftPool);
    destructor Destroy; override;

    procedure ForceStart;
    procedure PushDraft(Draft: TObject);
    function PopDraft: TObject;
    procedure Execute; override;

    property ActiveDrafts: Integer read FActiveDrafts write FActiveDrafts;

  end;

implementation

uses
  SysUtils;

{ TfrxDraftPool }

constructor TDpDraftPool.Create(ThreadsCount, SheetsCount: LongInt;
  DraftProcRoutine: TDpProcessRoutine);
var
  i: Integer;
begin
  InitializeCriticalSectionAndSpinCount(CsSheets, 4000);
  InitializeCriticalSectionAndSpinCount(CsDraftSheets, 4000);
  Sheets := TObjList.Create;
  Threads := TObjList.Create;
  EvNoDraftSheets := CreateEvent(nil, True, False, nil);
  DraftSheets := SheetsCount;
  DraftProcess := DraftProcRoutine;

  for i := 1 to ThreadsCount do
    Threads.Add(TDpThread.Create(Self));
end;

destructor TDpDraftPool.Destroy;
begin
  Threads.Free;
  Sheets.Free;
  Sheets := nil;
  DeleteCriticalSection(CsSheets);
  DeleteCriticalSection(CsDraftSheets);
  CloseHandle(EvNoDraftSheets);
end;

procedure TDpDraftPool.LockSheets;
begin
  EnterCriticalSection(CsSheets);
end;

procedure TDpDraftPool.UnlockSheets;
begin
  LeaveCriticalSection(CsSheets);
end;

procedure TDpDraftPool.LockDraftSheets;
begin
  EnterCriticalSection(CsDraftSheets);
end;

procedure TDpDraftPool.UnlockDraftSheets;
begin
  LeaveCriticalSection(CsDraftSheets);
end;

procedure TDpDraftPool.DraftProcessed;
begin
  LockDraftSheets;
  Dec(DraftSheets);
  UnlockDraftSheets;

  { When TfrxDraftPool is created, it accepts a
    count of sheets that will be processed. After creation,
    TfrxDraftPool accepts draft sheets and converts them
    to document sheets. The count of these draft sheets must
    be the same as specified at the creation time. }

  if DraftSheets < 0 then
    raise Exception.Create('Draft pool is performed to process more sheets' +
      ' that specified at its creation');

  if DraftSheets = 0 then
    SetEvent(EvNoDraftSheets);
end;

procedure TDpDraftPool.WaitForThreads;
var
  i: Integer;
begin
  for i := 0 to Threads.Count - 1 do
    TDpThread(Threads[i]).ForceStart;

  if DraftSheets > 0 then
    WaitForSingleObject(EvNoDraftSheets, INFINITE);
end;

procedure TDpDraftPool.AddDraft(Draft: TObject);
var
  i, j, n, m: Integer;
  t1, t2: TDpThread;
begin

  { Add a new draft sheet to the list of sheets }

  LockSheets;
  Sheets.Add(Draft);
  UnlockSheets;

  { Find a thread that has a minimum count of
    queued draft sheets }

  j := -1;
  n := 0;

  for i := 0 to Threads.Count - 1 do
  begin
    t1 := TDpThread(Threads[i]);
    m := t1.ActiveDrafts;

    if (j < 0) or (m < n) then
    begin
      n := m;
      j := i;
    end;
  end;

  t2 := TDpThread(Threads[j]);
  t2.PushDraft(Draft);
end;

{ TfrxExportThread }

constructor TDpThread.Create(Pool: TDpDraftPool);
begin
  FPool := Pool;
  FDraftSheets := TList.Create;
  InitializeCriticalSectionAndSpinCount(FCsDraftSheets, 4000);
  FEvNewDraft := CreateEvent(nil, True, False, nil);
  inherited Create(False);
end;

destructor TDpThread.Destroy;
begin
  { The thread code is waiting on this event,
    it waits for a new draft sheet. When the
    event becomes signalled, the thread
    will try to get a new draft sheet. If it will
    not find a new draft, it terminates the execution. }

  SetEvent(FEvNewDraft);

  { Wait until the thread termines
    the execution }

  WaitForSingleObject(Handle, INFINITE);

  DeleteCriticalSection(FCsDraftSheets);
  FDraftSheets.Free;
  CloseHandle(FEvNewDraft);
  inherited Destroy;
end;

procedure TDpThread.LockDrafts;
begin
  EnterCriticalSection(FCsDraftSheets);
end;

procedure TDpThread.UnlockDrafts;
begin
  LeaveCriticalSection(FCsDraftSheets);
end;

procedure TDpThread.PushDraft(Draft: TObject);
begin
  InterlockedIncrement(FActiveDrafts);

  LockDrafts;
  Inc(ProcessedDrafts);

  if FDraftSheets.Count > MaxQueueLength then
    MaxQueueLength := FDraftSheets.Count;

  { First: add the new draft to the list.
    Second: make the event signalled. This will mean
    that the list contains a new draft. }

  FDraftSheets.Add(Draft);
  if FDraftSheets.Count = 8 then
    SetEvent(FEvNewDraft);

  UnlockDrafts;
end;

function TDpThread.PopDraft: TObject;
var
  n: Integer;
begin
  LockDrafts;
  n := FDraftSheets.Count;

  if n = 0 then
    Result := nil
  else
  begin
    Result := TObject(FDraftSheets.Last);
    FDraftSheets.Count := n - 1;

    if n = 1 then
      ResetEvent(FEvNewDraft);
  end;

  UnlockDrafts;
end;

procedure TDpThread.ForceStart;
begin
  SetEvent(FEvNewDraft);
end;

procedure TDpThread.Execute;
var
  s: TObject;
begin
  repeat
    s := PopDraft;

    if s = nil then
    begin
      WaitForSingleObject(FEvNewDraft, INFINITE);
      s := PopDraft;
    end;

    if s = nil then
      Break;

    FPool.DraftProcess(s);
    InterlockedDecrement(FActiveDrafts);
    FPool.DraftProcessed;
  until False;
end;

end.