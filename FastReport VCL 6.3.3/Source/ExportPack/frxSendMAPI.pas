unit frxSendMAPI;
{$I frx.inc}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs;

type
  TMapiErrEvent = procedure(Sender: TObject; ErrCode: Integer) of object;

  TMapiControl = class(TComponent)
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    private
    FSubject: string;
    FMailtext: string;
    FFromName: string;
    FFromAdress: string;
    FTOAdr: TStrings;
    FCCAdr: TStrings;
    FBCCAdr: TStrings;
    FAttachedFileName: TStrings;
//    FDisplayFileName: TStrings;
    FShowDialog: Boolean;
    FUseAppHandle: Boolean;
    FMAPISendFlag: Integer;

    FOnUserAbort: TNotifyEvent;
    FOnMapiError: TMapiErrEvent;
    FOnSuccess: TNotifyEvent;

    procedure SetToAddr(newValue : TStrings);
    procedure SetCCAddr(newValue : TStrings);
    procedure SetBCCAddr(newValue : TStrings);
    procedure SetAttachedFileName(newValue : TStrings);
  protected
  public
    ApplicationHandle: THandle;
    function Sendmail( User, Passwd: String ): String;
    procedure Reset();
    function GetName(mailaddress: String): AnsiString;
    function GetAddress(mailaddress: String): AnsiString;
  published
    property Subject: string read FSubject write FSubject;
    property Body: string read FMailText write FMailText;
    property FromName: string read FFromName write FFromName;
    property FromAdress: string read FFromAdress write FFromAdress;
    property Recipients: TStrings read FTOAdr write SetTOAddr;
    property CopyTo: TStrings read FCCAdr write SetCCAddr;
    property BlindCopyTo: TStrings read FBCCAdr write SetBCCAddr;
    property AttachedFiles: TStrings read FAttachedFileName write SetAttachedFileName;
//    property DisplayFileName: TStrings read FDisplayFileName;
    property ShowDialog: Boolean read FShowDialog write FShowDialog;
    property UseAppHandle: Boolean read FUseAppHandle write FUseAppHandle;

    property OnUserAbort: TNotifyEvent read FOnUserAbort write FOnUserAbort;
    property OnMapiError: TMapiErrEvent read FOnMapiError write FOnMapiError;
    property OnSuccess: TNotifyEvent read FOnSuccess write FOnSuccess;
    property MAPISendFlag: Integer read FMAPISendFlag write FMAPISendFlag;
end;

implementation

uses Mapi;

{ TMapiControl }

constructor TMapiControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOnUserAbort := nil;
  FOnMapiError := nil;
  FOnSuccess := nil;
  FSubject := '';
  FMailtext := '';
  FFromName := '';
  FFromAdress := '';
  FTOAdr := TStringList.Create;
  FCCAdr := TStringList.Create;
  FBCCAdr := TStringList.Create;
  FAttachedFileName := TStringList.Create;
//  FDisplayFileName := TStringList.Create;
  FShowDialog := False;
  ApplicationHandle := Application.Handle;
end;

procedure TMapiControl.SetToAddr(newValue : TStrings);
begin
  FToAdr.Assign(newValue);
end;

procedure TMapiControl.SetCCAddr(newValue : TStrings);
begin
  FCCAdr.Assign(newValue);
end;

procedure TMapiControl.SetBCCAddr(newValue : TStrings);
begin
  FBCCAdr.Assign(newValue);
end;

procedure TMapiControl.SetAttachedFileName(newValue : TStrings);
begin
  FAttachedFileName.Assign(newValue);
end;

destructor TMapiControl.Destroy;
begin
  FTOAdr.Free;
  FCCAdr.Free;
  FBCCAdr.Free;
  FAttachedFileName.Free;
//  FDisplayFileName.Free;
  inherited destroy;
end;

procedure TMapiControl.Reset;
begin
  FSubject := '';
  FMailtext := '';
  FFromName := '';
  FFromAdress := '';
  FTOAdr.Clear;
  FCCAdr.Clear;
  FBCCAdr.Clear;
  FAttachedFileName.Clear;
//  FDisplayFileName.Clear;
end;

function TMapiControl.GetName(mailaddress: String): AnsiString;
var
  i: Integer;
begin
  for i:=1 to Length(mailaddress) do
  begin
    if mailaddress[i] = '<' then
    begin
      Result := AnsiString(Copy(mailaddress, 1, i - 1));
      break;
    end;
  end;
end;

function TMapiControl.GetAddress(mailaddress: String): AnsiString;
var
  b,e: Integer;
begin
  Result := AnsiString(mailaddress);
  b := LastDelimiter('<',mailaddress);
  e := LastDelimiter('>',mailaddress);
  if (b > 0) and (e > 0) and (b < e) then
    Result := AnsiString(Copy(mailaddress, b+1, e-b-1))
  else
    Result := AnsiString( mailaddress );
end;

{ Prepare and send E-mail via MAPI }
function TMapiControl.Sendmail( User, Passwd: String ): String;

  procedure PrepareAddress( rec: PMapiRecipDesc; dest: String; clas: Cardinal );
  var
    PName, PAddress: PAnsiChar;
    slen: Integer;
  begin
    PName := PAnsiChar(GetName(dest));
    slen := Length(PName) * 2;
    GetMem(rec^.lpszName, slen);
    CopyMemory( rec^.lpszName, PName, slen );
    PAddress := PAnsiChar('SMTP:' + GetAddress(dest));
    slen := Length(PAddress) * 2;
    GetMem(rec^.lpszAddress, slen);
    CopyMemory( rec^.lpszAddress, PAddress, slen );
    rec^.ulReserved := 0;
    rec^.ulEIDSize := 0;
    rec^.lpEntryID := nil;
    rec^.ulRecipClass := clas;
  end;

  function AddFileToThisMail( desc: PMapiFileDesc; name: String): PMapiFileDesc;
  var
    PPathName, PFileName: PAnsiChar;
    slen: Integer;
  begin
    PPathName := PAnsiChar(AnsiString(name));
    slen := Length(PPathName) * 2;
    GetMem(desc^.lpszPathName, slen);
    CopyMemory( desc^.lpszPathName, PPathName, slen );
    PFileName := PAnsiChar(AnsiString(ExtractFileName(name)));
    slen := Length(PFileName) * 2;
    GetMem(desc^.lpszFileName, slen);
    CopyMemory( desc^.lpszFileName, PFileName, slen );
    desc^.ulReserved := 0;
    desc^.flFlags := 0;
    desc^.nPosition := Cardinal(-1);
    desc^.lpFileType := nil;
    Inc(desc);
    Result := desc;
  end;

var
  MapiMessage: TMapiMessage;
  MStatus: Cardinal;
  Sender: TMapiRecipDesc;
  PRecip, Recipients: PMapiRecipDesc;
  PFiles, Attachments: PMapiFileDesc;
  i, RcpCount: Integer;
  AppHandle: THandle;
  MAPI_Session: Cardinal;
  DestinationAddress: String;

begin
  AppHandle := Application.Handle;
  MStatus := MapiLogon(AppHandle,
    {$IFDEF Delphi12} PAnsiChar(AnsiString(User)), PAnsiChar(AnsiString(Passwd))
    {$ELSE} PAnsiChar(User), PAnsiChar(Passwd)
    {$ENDIF},
    MAPI_NEW_SESSION, 0, @MAPI_Session);
  if MStatus = MAPI_E_LOGON_FAILURE then
  MStatus := MapiLogon(AppHandle,
    {$IFDEF Delphi12}PAnsiChar(AnsiString(User)), PAnsiChar(AnsiString(Passwd))
    {$ELSE} PAnsiChar(User), PAnsiChar(Passwd)
    {$ENDIF},
    MAPI_LOGON_UI, 0, @MAPI_Session);
  if MStatus <> SUCCESS_SUCCESS then
  begin
    Result := 'MAPI access denied';
    exit;
  end;

  MapiMessage.nRecipCount := FTOAdr.Count + FCCAdr.Count + FBCCAdr.Count;
  GetMem(Recipients, MapiMessage.nRecipCount * sizeof(TMapiRecipDesc));
  RcpCount := 0;
  PFiles := nil;

  try
    with MapiMessage do
    begin
      ulReserved := 0;

      lpszSubject := PAnsiChar(AnsiString(Self.FSubject));
      lpszNoteText := PAnsiChar(AnsiString(FMailText));

      lpszMessageType := nil;
      lpszDateReceived := nil;
      lpszConversationID := nil;
      flFlags := 0;

      Sender.ulReserved := 0;
      Sender.ulRecipClass := MAPI_ORIG;
      Sender.lpszName := PAnsiChar(GetName(FromName));
      Sender.lpszAddress := PAnsiChar(GetAddress(FromName));  // FromAdress
      Sender.ulEIDSize := 0;
      Sender.lpEntryID := nil;
      lpOriginator := @Sender;

      PRecip := Recipients;

      if nRecipCount > 0 then
      begin
        for i := 1 to FTOAdr.Count do
        begin
          DestinationAddress := FTOAdr.Strings[i - 1];
          PrepareAddress(PRecip, DestinationAddress, MAPI_TO);
          Inc( PRecip ) ;
          Inc( RcpCount );
        end;

        for i := 1 to FCCAdr.Count do
        begin
          DestinationAddress := FCCAdr.Strings[i - 1];
          PrepareAddress(PRecip, DestinationAddress, MAPI_CC);
          Inc(PRecip);
          Inc(RcpCount);
        end;

        for i := 1 to FBCCAdr.Count do
        begin
          DestinationAddress := FBCCAdr.Strings[i - 1];
          PrepareAddress(PRecip, DestinationAddress, MAPI_BCC);
          Inc(PRecip);
          Inc(RcpCount);
        end;
      end;
      lpRecips := Recipients;

      if FAttachedFileName.Count > 0 then
      begin
        nFileCount := FAttachedFileName.Count;
        GetMem(Attachments, MapiMessage.nFileCount * sizeof(TMapiFileDesc));
        PFiles := Attachments;
        if nFileCount > 0 then
        begin
          for i := 0 to FAttachedFileName.Count - 1 do
            Attachments :=  AddFileToThisMail( Attachments, FAttachedFileName[i] );
        end;
        lpFiles := PFiles;
      end
      else
      begin
        nFileCount := 0;
        lpFiles := nil;
      end;
    end;

    MStatus := MapiSendMail( MAPI_Session, AppHandle, MapiMessage, MAPISendFlag, 0 );

    case MStatus of
      MAPI_E_USER_ABORT:
      begin
        Result := 'Mail sending procedure aborted by user';
        if Assigned(FOnUserAbort) then
          FOnUserAbort(Self);
      end;
      SUCCESS_SUCCESS:
      begin
        Result := '';
        if Assigned(FOnSuccess) then
          FOnSuccess(Self);
      end
      else
      begin
        Result := 'MAPI error: ' + IntToStr(MStatus);
        if Assigned(FOnMapiError) then
          FOnMapiError(Self, MStatus);
      end;
    end;
  finally
    PRecip := Recipients;
    for i := 1 to RcpCount do
    begin
      FreeMem(PRecip^.lpszName);
      FreeMem(PRecip^.lpszAddress);
      Inc(PRecip);
    end;
    FreeMem(Recipients, MapiMessage.nRecipCount * sizeof(TMapiRecipDesc));

    if PFiles <> nil then
    begin
      Attachments :=  PFiles;
      if MapiMessage.nFileCount > 0 then
      for i := 0 to MapiMessage.nFileCount - 1 do
      begin
        FreeMem(PFiles^.lpszPathName);
        FreeMem(PFiles^.lpszFileName);
        Inc(PFiles);
      end;
      FreeMem(Attachments);
    end;
    MapiLogOff(MAPI_Session, AppHandle, 0, 0);
  end;
end;
end.



