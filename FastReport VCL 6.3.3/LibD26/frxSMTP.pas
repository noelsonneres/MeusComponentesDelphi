
{******************************************}
{                                          }
{              FastReport v5.0             }
{        SMTP connection client unit       }
{                                          }
{         Copyright (c) 2006-2008          }
{         by Alexander Fediachov,          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxSMTP;

interface

{$I frx.inc}

uses
  Windows, SysUtils, Classes, ScktComp, frxNetUtils, frxUtils, frxProgress
{$IFDEF Delphi6}, Variants {$ENDIF}, frxMD5, frxUnicodeUtils;


type
  TfrxSMTPClientThread = class;

  TfrxSMTPClient = class(TComponent)
  private
    FActive: Boolean;
    FBreaked: Boolean;
    FErrors: TStrings;
    FHost: String;
    FPort: Integer;
    FThread: TfrxSMTPClientThread;
    FTimeOut: Integer;
    FPassword: String;
    FMailTo: WideString;
    FUser: String;
    FMailFiles: TStringList;
    FMailFrom: WideString;
    FMailSubject: WideString;
    FMailText: WideString;
    FAnswer: AnsiString;
    FAccepted: Boolean;
    FAuth: String;
    FCode: Integer;
    FSending: Boolean;
    FProgress: TfrxProgress;
    FShowProgress: Boolean;
    FLogFile: String;
    FLog: TStringList;
    FAnswerList: TStringList;
    F200Flag: Boolean;
    F210Flag: Boolean;
    F215Flag: Boolean;
    FOrganization: WideString;
    FMailCc: WideString;
    FMailBcc: WideString;
    FRcptList: TStringList;
    FConfirmReading: boolean;
    FStartCommand: String;
    procedure DoConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DoDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DoError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DoRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure SetActive(const Value: Boolean);
    procedure AddLogIn(const s: String);
    procedure AddLogOut(const s: String);
    //function DomainByEmail(const addr: String): String;
    function UnicodeField(const Field_Str: String): AnsiString;
    function UnicodeString(const Str: WideString): AnsiString;
    function GetEmailAddress(const Str: String): String;
    procedure PrepareRcpt;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    procedure Open;
    procedure Close;
    property Breaked: Boolean read FBreaked;
    property Errors: TStrings read FErrors write Ferrors;
    property LogFile: String read FLogFile write FLogFile;
  published
    property Active: Boolean read FActive write SetActive;
    property Host: String read FHost write FHost;
    property Port: Integer read FPort write FPort;
    property TimeOut: Integer read FTimeOut write FTimeOut;
    property User: String read FUser write FUser;
    property Password: String read FPassword write FPassword;
    property MailFrom: WideString read FMailFrom write FMailFrom;
    property MailTo: WideString read FMailTo write FMailTo;
    property MailCc: WideString read FMailCc write FMailCc;
    property MailBcc: WideString read FMailBcc write FMailBcc;
    property MailSubject: WideString read FMailSubject write FMailSubject;
    property MailText: WideString read FMailText write FMailText;
    property MailFiles: TStringList read FMailFiles write FMailFiles;
    property ShowProgress: Boolean read FShowProgress write FShowProgress;
    property Organization: WideString read FOrganization write FOrganization;
    property ConfirmReading: boolean read FConfirmReading write FConfirmReading;
    property StartCommand: String read FStartCommand write FStartCommand;
  end;

  TfrxSMTPClientThread = class (TThread)
  protected
    FClient: TfrxSMTPClient;
    procedure DoOpen;
    procedure Execute; override;
  public
    FSocket: TClientSocket;
    constructor Create(Client: TfrxSMTPClient);
    destructor Destroy; override;
  end;

implementation

uses frxRes, frxrcExports{$IFDEF Delphi7}, StrUtils{$ENDIF};

const
  MIME_STRING_SIZE = 57;
  boundary = '----------';

type
  THackThread = class(TThread);


{ TfrxSMTPClient }

constructor TfrxSMTPClient.Create(AOwner: TComponent);
begin
  inherited;
  FErrors := TStringList.Create;
  FHost := '127.0.0.1';
  FPort := 25;
  FActive := False;
  FTimeOut := 60;
  FBreaked := False;
  FThread := TfrxSMTPClientThread.Create(Self);
  FThread.FSocket.OnConnect := DoConnect;
  FThread.FSocket.OnRead := DoRead;
  FThread.FSocket.OnDisconnect := DoDisconnect;
  FThread.FSocket.OnError := DoError;
  FShowProgress := False;
  FLogFile := '';
  FLog := TStringList.Create;
  FAnswerList := TStringList.Create;
  FMailFiles := TStringList.Create;
  FRcptList := TStringList.Create;
  FStartCommand := 'HELO';
end;

destructor TfrxSMTPClient.Destroy;
begin
  FRcptList.Free;
  FMailFiles.Free;
  Close;
  while FActive do
    Sleep(1);
//    PMessages;
  FThread.Free;
  FErrors.Free;
  FLog.Free;
  FAnswerList.Free;
  inherited;
end;

procedure TfrxSMTPClient.Connect;
var
  ticks: Cardinal;
begin
  FLog.Clear;
  if (FLogFile <> '') and FileExists(LogFile) then
    FLog.LoadFromFile(LogFile);
  FLog.Add(DateTimeToStr(Now));
  FErrors.Clear;
  FActive := True;
  FThread.FSocket.Host := FHost;
  FThread.FSocket.Address := FHost;
  FThread.FSocket.Port := FPort;
  FThread.FSocket.ClientType := ctNonBlocking;
  F200Flag := False;
  F210Flag := False;
  F215Flag := False;
  if FShowProgress then
  begin
    FProgress := TfrxProgress.Create(nil);
    FProgress.Execute(100, frxGet(8924) + ' ' + FMailTo, False, True);
  end;
  FThread.Execute;
  try
    ticks := GetTickCount;
    while FActive and (not FBreaked) do
    begin
      if FShowProgress then
        FProgress.Tick
      else
        PMessages;
      if ((GetTickCount - ticks) > Cardinal(FTimeOut * 1000)) then
      begin
        Errors.Add(frxResources.Get('expMtm') + ' (' + IntToStr(FTimeOut) + ')');
        break;
      end;
      if FSending then
        ticks := GetTickCount;
      Sleep(100);
    end;
  finally
    if FShowProgress then
      FProgress.Free;
    Disconnect;
  end;
  FLog.Add('---' + DateTimeToStr(Now));
  FLog.AddStrings(FErrors);
  if FLogFile <> '' then
    FLog.SaveToFile(FLogFile);
end;

procedure TfrxSMTPClient.Disconnect;
begin
  FThread.FSocket.Close;
  FThread.Terminate;
  FActive := False;
end;

procedure TfrxSMTPClient.DoConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  s: string;
  i: integer;
begin
  PrepareRcpt;

  { Fix RFC violation found by Sergey Spirin }
  for i := 1 to 20 do
  begin
    if Socket.ReceiveLength <> 0 then break;
    Sleep(1000);
  end;

  { RFC 2821 section 4.1.1.1 says that
    client SMTP SHOULD start an SMTP session
    by issuing the EHLO command }

  s := StartCommand + ' [' + Socket.LocalAddress + ']' + #13#10;
  //s := StartCommand + DomainByEmail(FMailFrom) + #13#10;
  Socket.SendText(AnsiString(s));

  AddLogOut(s);
  FCode := 0;
  FAuth := FUser;
  FAccepted := False;
  FSending := False;
end;

procedure TfrxSMTPClient.DoDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if Pos(AnsiString('221'), FAnswer) = 0 then
    Errors.Add(String(FAnswer));
  FActive := False;
  FSending := False;
end;

procedure TfrxSMTPClient.DoError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  if FAnswer <> '' then
    Errors.Add(String(FAnswer));
  Errors.Add(GetSocketErrorText(ErrorCode));
  FActive := False;
  ErrorCode := 0;
  FSending := False;
end;

{$IFNDEF Delphi12}
function TranslateString(s: String): WideString;
var
  Dest: Pointer;
  L: Integer;
begin
  L := Length(s);
  Dest := AllocMem((L+1)*SizeOf(WideChar));
  MultiByteToWideChar(GetACP, 0, Pointer(s), L, Pointer(Dest), (L+1)*SizeOf(WideChar) );
  Result := LPCWSTR(Dest);
  FreeMem(Dest);
end;
{$ENDIF}


procedure TfrxSMTPClient.DoRead(Sender: TObject; Socket: TCustomWinSocket);
var
  buf: PAnsiChar;
  i, j, k: Integer;
  Stream: TMemoryStream;
  fbuf: PAnsiChar;
  FStream: TFileStream;
  s, s1, s2: String;
//{$IFDEF Delphi12}
  sa: AnsiString;
//{$ELSE}
//{$ENDIF}
  s1a: AnsiString;
  bound: String;

  procedure OutStream(const S: String);{$IFDEF Delphi12} overload;{$ENDIF}
{$IFDEF Delphi12}
  var
    TempStr: AnsiString;
{$ENDIF}
  begin
{$IFDEF Delphi12}
    TempStr := AnsiString(S);
    Stream.Write(TempStr[1], Length(TempStr));
    Stream.Write(AnsiString(#13#10), 2);
{$ELSE}
    Stream.Write(S[1], Length(S));
    Stream.Write(#13#10, 2);
{$ENDIF}
{$IFDEF FR_DEBUG}
    FLog.Add(s);
{$ENDIF}
  end;

{$IFDEF Delphi12}
  procedure OutStream(const S: AnsiString); overload;
  begin
    Stream.Write(S[1], Length(S));
    Stream.Write(AnsiString(#13#10), 2);
{$IFDEF FR_DEBUG}
    FLog.Add(s);
{$ENDIF}
  end;
{$ENDIF}

begin
  i := Socket.ReceiveLength;
  GetMem(buf, i);
  try
    try
      i := Socket.ReceiveBuf(buf^, i);
      SetLength(FAnswer, i);
      CopyMemory(PAnsiChar(FAnswer), buf, i);
       FAnswerList.Text := String(FAnswer);

      for k := 0 to FAnswerList.Count - 1 do
      begin
        FAnswer := AnsiString(FAnswerList[k]);
        FCode := StrToInt(Copy(String(FAnswer), 1, 3));
        AddLogIn(String(FAnswer));
        if (FCode = 235) then
        begin
          FCode := 220;
          FAccepted := True;
        end;
        if (FUser <> '') and (not FAccepted) and (FCode = 220) then
        begin
          s := 'AUTH LOGIN'#13#10;
          Socket.SendText(AnsiString(s));
          AddLogOut(s);
        end
        else if FCode = 334 then
        begin
          Socket.SendText(Base64Encode(AnsiString(FAuth)) + #13#10);
          FAuth := FPassword;
          AddLogOut('****');
        end
        else if (FCode = 220) then
        begin
          s := 'MAIL FROM: <' + GetEmailAddress(FMailFrom) + '>'#13#10;
          Socket.SendText(AnsiString(s));
          AddLogOut(s);
          F210Flag := True;
        end
        else if (FCode = 250) and F210Flag then
        begin
          for j := 0 to FRcptList.Count - 1 do
          begin
            s := 'RCPT TO: <' + GetEmailAddress(FRcptList[j]) + '>'#13#10;
            Socket.SendText(AnsiString(s));
            AddLogOut(s);
          end;
          F210Flag := False;
          F215Flag := True;
        end
        else if (FCode = 250) and F215Flag then
        begin
          s := 'DATA'#13#10;
          Socket.SendText(AnsiString(s));
          AddLogOut(s);
          F215Flag := False;
        end
        else if (FCode = 250) and F200Flag then
        begin
          s := 'QUIT'#13#10;
          Socket.SendText(AnsiString(s));
          AddLogOut(s);
          F200Flag := False;
        end
        else if (FCode = 354) then
        begin
          FSending := True;
          Stream := TMemoryStream.Create;
          try
            OutStream('Date: ' + DateTimeToRFCDateTime(Now));
            OutStream('From: ' + UnicodeField(FMailFrom));
            OutStream('Reply-To: ' + UnicodeField(FMailFrom));
            if FOrganization <> '' then
              OutStream('Organization: ' + UnicodeString(FOrganization));
            OutStream('X-Priority: 3 (Normal)');
            if FConfirmReading then
            begin
              OutStream('X-Confirm-Reading-To: ' + UnicodeField(FMailFrom));
              OutStream('Return-Receipt-To: ' + UnicodeField(FMailFrom));
              OutStream('Disposition-Notification-To: ' + UnicodeField(FMailFrom));
            end;
            i := Pos('@', FMailFrom);
            j := PosEx('>', FMailFrom, i);
            if j = 0 then
              j := Length(FMailFrom);
            s := Copy(FMailFrom, i, j - i + 1);
            OutStream('Message-ID: <' + IntToStr(GetTickCount) + '.' + FormatDateTime('YYYYMMDDHHMMSS', Now) + s + '>');
//    {$IFDEF Delphi12}
            sa := 'To: ';
//    {$ELSE}
//            s := 'To: ';
//    {$ENDIF}
            for j := 0 to FRcptList.Count - 1 do
            begin
//    {$IFDEF Delphi12}
              sa := sa + UnicodeField(FRcptList[j]);
              if j <> FRcptList.Count - 1 then
                sa := sa + ',';
            end;
            OutStream(sa);
//    {$ELSE}
//              s := s + UnicodeField(FRcptList[j]);
//              if j <> FRcptList.Count - 1 then
//                s := s + ',';
//            end;
//            OutStream(s);
//    {$ENDIF}
            if FMailCc <> '' then
              OutStream('CC: ' + UnicodeField(FMailCc));
            if FMailBcc <> '' then
              OutStream('BCC: ' + UnicodeField(FMailBcc));
            OutStream('Subject: ' + UnicodeString(FMailSubject));
            bound := boundary + UpperCase(String(Copy(md5String(AnsiString(DateTimeToStr(Now))), 1, 14)));
            OutStream('MIME-Version: 1.0');
            OutStream('Content-Type: multipart/mixed; boundary="' + bound +'"');
            OutStream(#13#10'--' + bound);
            OutStream('Content-Type: text/plain; charset=utf-8');
            OutStream('Content-Transfer-Encoding: 8bit');
{$IFDEF Delphi12}
            OutStream(#13#10 + UTF8Encode(StringReplace(FMailText, #13#10'.'#13#10, #13#10'..'#13#10, [rfReplaceAll])));
{$ELSE}
            OutStream(#13#10 + UTF8Encode(TranslateString(StringReplace(FMailText, #13#10'.'#13#10, #13#10'..'#13#10, [rfReplaceAll]))));
{$ENDIF}
            for i := 0 to FMailFiles.Count - 1 do
            begin
              if FMailFiles.Names[i] <> '' then
                s2 := FMailFiles.Names[i]
              else
                s2 := FMailFiles[i];
              if FileExists(s2) then
              begin
                s := GetFileMIMEType(s2);
                if FMailFiles.Names[i] = '' then
                  s1 := ExtractFileName(s2)
                else
                  s1 := FMailFiles.Values[FMailFiles.Names[i]];
                OutStream('--' + bound);
{$IFDEF Delphi12}
                s1a := UnicodeString(s1);
                OutStream('Content-Type: ' + AnsiString(s) + '; name="' + s1a + '"');
                OutStream('Content-Transfer-Encoding: base64');
                OutStream('Content-Disposition: attachment; filename="' + s1a + '"'#13#10);
{$ELSE}
                s1a := UnicodeString(s1);
                OutStream('Content-Type: ' + s + '; name="' + s1a + '"');
                OutStream('Content-Transfer-Encoding: base64');
                OutStream('Content-Disposition: attachment; filename="' + s1a + '"'#13#10);
{$ENDIF}
                FStream := TFileStream.Create(s2, fmOpenRead + fmShareDenyWrite);
                GetMem(fbuf, MIME_STRING_SIZE);
                try
                  j := MIME_STRING_SIZE;
                  while j = MIME_STRING_SIZE do
                  begin
                    j := FStream.Read(fbuf^, j);
{$IFDEF Delphi12}
                    SetLength(sa, j);
                    CopyMemory(PAnsiChar(sa), fbuf, j);
                    sa := Base64Encode(sa);
                    OutStream(sa);
{$ELSE}
                    SetLength(s, j);
                    CopyMemory(PAnsiChar(s), fbuf, j);
                    s := Base64Encode(s);
                    OutStream(s);
{$ENDIF}
                  end;
                finally
                  FreeMem(fbuf);
                  FStream.Free;
                end;
              end;
            end;
            OutStream(#13#10 + '--' + bound + '--');
            OutStream('.');
{$IFNDEF FR_DEBUG}
            AddLogOut('message(skipped)');
{$ENDIF}
            Socket.SendBuf(Stream.Memory^, Stream.Size);
            F200Flag := True;
          finally
            FSending := False;
            Stream.Free;
          end;
        end;
      end;
    except
      on e: Exception do
        Errors.Add('Data receive error: ' + e.Message)
    end;
  finally
    FreeMem(buf);
  end;
end;

procedure TfrxSMTPClient.SetActive(const Value: Boolean);
begin
  if Value then Connect
  else Disconnect;
end;

procedure TfrxSMTPClient.Close;
begin
  FBreaked := True;
  Active := False;
end;

procedure TfrxSMTPClient.Open;
begin
  Active := True;
end;

{function TfrxSMTPClient.DomainByEmail(const addr: String): String;
var
  i: Integer;
begin
  i := Pos('@', addr);
  if i > 0 then
    Result := Copy(addr, i + 1, Length(addr) - i)
  else
    Result := addr;
end;}

procedure TfrxSMTPClient.AddLogIn(const s: String);
begin
  FLog.Add('<' + s);
end;

procedure TfrxSMTPClient.AddLogOut(const s: String);
begin
  FLog.Add('>' + s);
end;

function TfrxSMTPClient.UnicodeField(const Field_Str: String): AnsiString;
var
  i1, i2, i3, k: Integer;
  Str: WideString;
  ws1: WideString;
  ws2: AnsiString;
begin
{$IFNDEF Delphi12}
  Str := TranslateString(Field_Str);
{$ELSE}
  Str:=Field_Str;
{$ENDIF}
  i1 := Pos('<', Str);
  i2 := Pos('@', Str);
  i3 := Pos('>', Str);
  if (i1 <> 0) and (i1 < i2) and (i2 < i3) then
  begin
    ws1 := Copy(Str, 1, i1 - 1);
    ws2 := AnsiString(Copy(Str, i1, Length(Str) - i1 + 1));
  end
  else if i2 > 0 then
  begin
    k := i2;
    while (k > 0) and (Str[k] <> #32) do
      Dec(k);
    ws1 := Copy(Str, 1, k - 1);
    ws2 := '<' + AnsiString(Copy(Str, k, Length(Str) - k + 1)) + '>';
  end
  else
  begin
    ws1 := Str;
    ws2 := '';
  end;
  if ws1 <> '' then ws1 := '=?UTF-8?B?' + {$IFDEF Delphi12}WideString(Base64Encode(UTF8Encode(ws1))){$ELSE}Base64Encode(UTF8Encode(ws1)){$ENDIF} + '?=';
  Result := {$IFDEF Delphi12}AnsiString(ws1){$ELSE}ws1{$ENDIF} + ws2;
end;

function TfrxSMTPClient.UnicodeString(const Str: WideString): AnsiString;
begin
  if Str <> '' then
  begin
{$IFNDEF Delphi12}
    Result := '=?UTF-8?B?' + Base64Encode(UTF8Encode(TranslateString(Str))) + '?=';
{$ELSE}
    Result := '=?UTF-8?B?' + Base64Encode(UTF8Encode(Str)) + '?=';
{$ENDIF}
  end
  else
    Result := '';
end;

function TfrxSMTPClient.GetEmailAddress(const Str: String): String;
var
  i, j, k: Integer;
begin
  Result := '';
  i := Pos('@', Str);
  if i <> 0 then
  begin
    j := i;
    while (Str[j] <> '<') and (Str[j] <> ' ') and (j > 1) do
      Dec(j);
    if (Str[j] = '<') or (Str[j] = ' ') then
      Inc(j);
    k := i;
    while (Str[k] <> '>') and (Str[k] <> ' ') and (k < Length(Str)) do
      Inc(k);
    if (Str[k] = '>') or (Str[k] = ' ') then
      Dec(k);
    Result := Copy(Str, j, k - j + 1);
  end;
end;

procedure TfrxSMTPClient.PrepareRcpt;
{$IFNDEF Delphi6_NIFF}
var
  i, j: Integer;
  s, Rcpt: String;
{$ENDIF}
begin
  FRcptList.Clear;
{$IFDEF Delphi6_NIFF}
  FRcptList.Delimiter := ',';
  FRcptList.DelimitedText := FMailTo;
  if FMailCc <> '' then
    FRcptList.DelimitedText := FRcptList.DelimitedText + ',' + FMailCc;
  if FMailBCc <> '' then
    FRcptList.DelimitedText := FRcptList.DelimitedText + ',' + FMailBCc;
{$ELSE}
  i := 1;
  j := 1;
  Rcpt := FMailTo;
  if FMailCc <> '' then
    Rcpt := Rcpt + ',' + FMailCc;
  if FMailBCc <> '' then
    Rcpt := Rcpt + ',' + FMailBCc;
  while i <= Length(Rcpt) do
  begin
    if Rcpt[i] = ',' then
    begin
      s := Copy(Rcpt, j, i - j);
      FRcptList.Add(s);
      j := i + 1;
    end;
    Inc(i);
  end;
  s := Copy(Rcpt, j, i - j);
  FRcptList.Add(s);
{$ENDIF}
end;

{ TfrxSMTPClientThread }

constructor TfrxSMTPClientThread.Create(Client: TfrxSMTPClient);
begin
  inherited Create(True);
  FClient := Client;
  FreeOnTerminate := False;
  FSocket := TClientSocket.Create(nil);
end;

destructor TfrxSMTPClientThread.Destroy;
begin
  FSocket.Free;
  inherited;
end;

procedure TfrxSMTPClientThread.DoOpen;
begin
  FSocket.Open;
end;

procedure TfrxSMTPClientThread.Execute;
begin
  Synchronize(DoOpen);
end;

end.
