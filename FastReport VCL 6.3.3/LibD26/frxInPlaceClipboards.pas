{******************************************}
{                                          }
{             FastReport v6.0              }
{         Basic Clipboard Editors          }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxInPlaceClipboards;

{$I frx.inc}

interface

uses
{$IFDEF FPC}LazHelper{$ELSE}Windows{$ENDIF},
  Types, Classes, SysUtils,
  frxClass, frxUtils,
  frxUnicodeCtrls, frxUnicodeUtils, Clipbrd
{$IFDEF Delphi6}
    , Variants
{$ENDIF}
{$IFDEF Delphi10}
    , WideStrings
{$ENDIF};

type
  TfrxInPlaceBaseCopyPasteEditor = class(TfrxInPlaceEditor)
  private
    procedure SortObjets(ObjList: TList; SortedList: TStringList);
  public
    procedure CopyGoupContent(CopyFrom: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType = cptDefault); override;
    procedure PasteGoupContent(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType = cptDefault); override;
  end;

  TfrxInPlaceMemoCopyPasteEditor = class(TfrxInPlaceBaseCopyPasteEditor)
  public
    procedure CopyContent(CopyFrom: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType = cptDefault); override;
    procedure PasteContent(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType = cptDefault); override;
    function IsPasteAvailable(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; PasteAs: TfrxCopyPasteType = cptDefault): Boolean; override;
    function DefaultContentType: TfrxCopyPasteType; override;
  end;

  TfrxInPlacePictureCopyPasteEditor = class(TfrxInPlaceEditor)
  public
    procedure CopyContent(CopyFrom: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType = cptDefault); override;
    procedure PasteContent(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType = cptDefault); override;
    function IsPasteAvailable(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; PasteAs: TfrxCopyPasteType = cptDefault): Boolean; override;
  end;

implementation

uses Math;


type
  { InPlace editors }
  THackClipboard = class(TClipboard);

{ TfrxInPlaceMemoCopyPasteEditor }

procedure TfrxInPlaceMemoCopyPasteEditor.CopyContent(CopyFrom: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType);
var
  CB: WideString;
  // remove new lines for batch copy
  function BuildString(sLines: TWideStrings): WideString;
  var
    i: Integer;
  begin
    Result := '';
    for i := 0 to sLines.Count - 1 do
    begin
      Result := Result + sLines[i];
      if i < sLines.Count - 1  then
        Result := Result + ' ';
    end;
  end;

begin
  CB := '';
  if Assigned(CopyFrom) and (CopyAs = cptText) then
  begin
    CB := BuildString(TfrxCustomMemoView(CopyFrom).Memo);
    if Assigned(Buffer) then
      Buffer.Write(CB[1], Length(CB) * sizeof(WideChar))
    else
      Clipboard.AsText := TfrxCustomMemoView(CopyFrom).Text;
  end;
end;

function TfrxInPlaceMemoCopyPasteEditor.DefaultContentType: TfrxCopyPasteType;
begin
  Result := cptText;
end;

{$IFDEF FPC}
const
  CF_UNICODETEXT = 13;
{$ENDIF}

function TfrxInPlaceMemoCopyPasteEditor.IsPasteAvailable(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; PasteAs: TfrxCopyPasteType): Boolean;
begin
  Result := Clipboard.HasFormat(CF_UNICODETEXT) or Clipboard.HasFormat(CF_TEXT);
end;

procedure TfrxInPlaceMemoCopyPasteEditor.PasteContent(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType);
begin
  try
    if Assigned(Buffer) and not Assigned(EventParams.SelectionList) then
    begin
      Buffer.Position := 0;
      TfrxCustomMemoView(PasteTo).Memo.LoadFromStream(Buffer);
    end
    else
      TfrxCustomMemoView(PasteTo).Text := Clipboard.AsText;
  finally
    EventParams.Refresh := True;
    EventParams.Modified := True;
  end;
end;

{ TfrxInPlacePictureCopyPasteEditor }

procedure TfrxInPlacePictureCopyPasteEditor.CopyContent(CopyFrom: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType);
begin
  if CopyFrom is TfrxPictureView then
    Clipboard.Assign(TfrxPictureView(CopyFrom).Picture);
end;

function TfrxInPlacePictureCopyPasteEditor.IsPasteAvailable(
  PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams;
  PasteAs: TfrxCopyPasteType): Boolean;
begin
  Result := Clipboard.HasFormat(CF_PICTURE) or Clipboard.HasFormat(CF_BITMAP) or Clipboard.HasFormat(CF_METAFILEPICT);
end;

procedure TfrxInPlacePictureCopyPasteEditor.PasteContent(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType);
var
  i: Integer;
begin
  if PasteTo is TfrxPictureView then
  begin
    if Assigned(EventParams.SelectionList) and (EventParams.SelectionList.Count > 1) then
    begin
      for i := 0 to EventParams.SelectionList.Count - 1 do
        if TObject(EventParams.SelectionList[i]).InheritsFrom(TfrxPictureView) then
          THackClipboard(Clipboard).AssignTo(TfrxPictureView(EventParams.SelectionList[i]).Picture);
    end
    else
      THackClipboard(Clipboard).AssignTo(TfrxPictureView(PasteTo).Picture);
  end;
  EventParams.Refresh := True;
  EventParams.Modified := True;
end;

{ TfrxInPlaceBaseCopyPasteEditor }

procedure TfrxInPlaceBaseCopyPasteEditor.CopyGoupContent(CopyFrom: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType);
var
  i: Integer;
  c: TfrxComponent;
  aList: TfrxSelectedObjectsList;
  sl: TStringList;
  str: WideString;
  aTop, aLeft, aBottom, aRight: Extended;
  ContentStream: TStream;
  EditorsManager: TfrxComponentEditorsManager;
begin
  if not Assigned(EventParams.SelectionList) or
    (EventParams.SelectionList.Count < 2) or
    not Assigned(EventParams.EditorsList) then
  begin
    Inherited;
    Exit;
  end;
  aList := EventParams.SelectionList;
  sl := TStringList.Create;
  sl.Sorted := True;

  ContentStream := TMemoryStream.Create;
  try
    // sort objects by coords
    SortObjets(EventParams.SelectionList, sl);
    c := TfrxComponent(sl.Objects[0]);
    EditorsManager := frxGetInPlaceEditor(EventParams.EditorsList, c);
    EventParams.SelectionList := nil;
    aTop := c.AbsTop;
    aLeft := c.AbsLeft;
    aBottom := aTop + c.Height;
    aRight := aLeft + c.Width;
    if Assigned(EditorsManager) then
      EditorsManager.CopyContent(c, EventParams, ContentStream, cptText);
    // simple detection of row/column
    for i := 1 to sl.Count - 1 do
    begin
      c := TfrxComponent(sl.Objects[i]);
      if sl.Objects[i - 1].ClassType <> c.ClassType then
        EditorsManager := frxGetInPlaceEditor(EventParams.EditorsList, c);

      if not((c.AbsTop >= aTop) and (c.AbsTop < aBottom)) then
      begin
        aTop := c.AbsTop;
        aLeft := c.AbsLeft;
        aBottom := aTop + c.Height;
        aRight := aLeft + c.Width;
        ContentStream.Write(WideString(sLineBreak)[1],
            Length(sLineBreak) * sizeof(WideChar));
      end;
      if not((c.AbsLeft >= aLeft) and (c.AbsLeft < aRight)) then
      begin
        aLeft := c.AbsLeft;
        aRight := aLeft + c.Width;
        ContentStream.Write(WideString(#9)[1], sizeof(WideChar));
      end;
      if Assigned(EditorsManager) then
        EditorsManager.CopyContent(c, EventParams, ContentStream, cptText);
    end;
    ContentStream.Position := 0;
    SetLength(str, ContentStream.Size div sizeof(Char));
    ContentStream.Read(str[1], ContentStream.Size);
    Clipboard.AsText := str;

  finally
    ContentStream.Free;
    sl.Free;
    EventParams.SelectionList := aList;
  end;
end;

procedure TfrxInPlaceBaseCopyPasteEditor.PasteGoupContent(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType);
var
  ContentStream: TStream;
  sText: String;
  i, cStartPos, cStartValue: Integer;
  c: TfrxComponent;
  aList: TfrxSelectedObjectsList;
  sl: TStringList;
  aTop, aLeft, aBottom, aRight: Extended;
  EditorsManager: TfrxComponentEditorsManager;
  bColumnNext, bIsUnicode: Boolean;
  nCount: Integer;

  function GetValue(SkipColumn: Boolean): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := cStartPos to Length(sText) do
    begin
      Result := (sText[i] = #9);
      if Result or (sText[i] = #10) and (i > 1) and (sText[i - 1] = #13) then
      begin
        cStartValue := cStartPos;
        cStartPos := i + 1;
        nCount := i - cStartValue;
        if not SkipColumn or not Result then
          Exit;
      end;
    end;
    if SkipColumn then
      nCount := 0
    else
      nCount := Length(sText) - cStartPos + 1;
    cStartValue := cStartPos;
    cStartPos := Length(sText) + 1;
  end;
begin
  if not Assigned(EventParams.SelectionList) or
    (EventParams.SelectionList.Count < 2) then
  begin
    Inherited;
    Exit;
  end;
  ContentStream := TMemoryStream.Create;
  aList := EventParams.SelectionList;
  sl := TStringList.Create;
  try
    SortObjets(EventParams.SelectionList, sl);
    EventParams.SelectionList := nil;
{$IFDEF DELPHI12}
    bIsUnicode := True;
{$ELSE}
    bIsUnicode := False;//Clipboard.HasFormat(CF_UNICODETEXT);
{$ENDIF}
    sText := Clipboard.AsText;
    c := TfrxComponent(sl.Objects[0]);
    aTop := c.AbsTop;
    aLeft := c.AbsLeft;
    aBottom := aTop + c.Height;
    aRight := aLeft + c.Width;
    EditorsManager := frxGetInPlaceEditor(EventParams.EditorsList, c);
    cStartPos := 1;
    nCount := 1;
    cStartValue := 1;
    bColumnNext := GetValue(False);
    if bIsUnicode then
      ContentStream.Write(AnsiString(#$FF#$FE)[1], 2);
    ContentStream.Write(sText[cStartValue], nCount * sizeof(Char));

    if Assigned(EditorsManager) then
      EditorsManager.PasteContent(c, EventParams, ContentStream, cptText);
    ContentStream.Size := 0;
    for i := 1 to sl.Count - 1 do
    begin
      c := TfrxComponent(sl.Objects[i]);
      if sl.Objects[i - 1].ClassType <> c.ClassType then
        EditorsManager := frxGetInPlaceEditor(EventParams.EditorsList, c);
      nCount := 0;
      if not((c.AbsTop >= aTop) and (c.AbsTop < aBottom)) then
      begin
        aTop := c.AbsTop;
        aLeft := c.AbsLeft;
        aBottom := aTop + c.Height;
        aRight := aLeft + c.Width;
        if bColumnNext then
          GetValue(bColumnNext);
        bColumnNext := GetValue(False);
      end
      else if not((c.AbsLeft >= aLeft) and (c.AbsLeft < aRight)) and bColumnNext
      then
      begin
        aLeft := c.AbsLeft;
        aRight := aLeft + c.Width;
        bColumnNext := GetValue(False);
      end;
      if Assigned(EditorsManager) and (nCount > 0) then
      begin
        if bIsUnicode then
          ContentStream.Write(AnsiString(#$FF#$FE)[1], 2);
        ContentStream.Write(sText[cStartValue], nCount * sizeof(Char));
        EditorsManager.PasteContent(c, EventParams, ContentStream, cptText);
        ContentStream.Size := 0;
      end;
    end;
  finally
    sl.Free;
    EventParams.SelectionList := aList;
    ContentStream.Free;
  end;
end;

procedure TfrxInPlaceBaseCopyPasteEditor.SortObjets(ObjList: TList;
  SortedList: TStringList);
var
  i: Integer;
  c: TfrxComponent;
  str: String;
begin
    SortedList.Sorted := True;
    for i := 0 to ObjList.Count - 1 do
    begin
      c := TfrxComponent(ObjList[i]);
      if c.AbsTop >= 0 then
        str := '1' + Format('%9.2f', [c.AbsTop])
      else
        str := '0' + Format('%9.2f', [-c.AbsTop]);
      if c.AbsLeft >= 0 then
        str := str + '1' + Format('%9.2f', [c.AbsLeft])
      else
        str := str + '0' + Format('%9.2f', [-c.AbsLeft]);
      SortedList.AddObject(str, c)
    end;
end;

initialization
  frxRegEditorsClasses.Register(TfrxMemoView, [TfrxInPlaceMemoCopyPasteEditor], [[evDesigner, evPreview]]);
  frxRegEditorsClasses.Register(TfrxPictureView, [TfrxInPlacePictureCopyPasteEditor], [[evDesigner, evPreview]]);

end.
