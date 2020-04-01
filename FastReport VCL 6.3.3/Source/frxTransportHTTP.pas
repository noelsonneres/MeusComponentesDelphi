
{******************************************}
{                                          }
{             FastReport v6.0              }
{          HTTP connection client          }
{                                          }
{         Copyright (c) 2006-2018          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxTransportHTTP;

{$I frx.inc}
interface

uses
  Windows, Messages, SysUtils, Classes, ScktComp, frxServerUtils, frxNetUtils, Math,
  frxGzip, frxMD5, WinSock, frxBaseTransportConnection, frxBaseSocketIOHandler;

const
  HTTP_POST = 'POST';
  HTTP_GET = 'GET';
  HTTP_DELETE = 'DELETE';
  HTTP_VER1 = 'HTTP/1.0';
  HTTP_LINK_PREFIX: AnsiString = 'http://';
  HTTPS_LINK_PREFIX: AnsiString = 'https://';

type
  TfrxRequestType = (xrtPost, xrtGet, xrtDelete);
  TfrxHTTPContentType = (htcNone, hctDefaultHTML, htcDefaultXML, htcDefaultApp);

type
  TfrxHTTPRequest = class (TPersistent)
  private
    FURL: AnsiString;
    FContentType: AnsiString;
    FAuthorization: AnsiString;
    FReqType: TfrxRequestType;
    FSourceStream: TStream;
    FAcceptTypes: AnsiString;
    FDefAcceptTypes: TfrxHTTPContentType;
    FEncoding: AnsiString;
    FUserAgent: AnsiString;
    FPort: Integer;
    function GetText: AnsiString;
    procedure SetText(const Value: AnsiString);
  protected
    FRequest: TStringList;
    FCustomHeader: TStrings;
    procedure SureEmptyLineAtEnd;
  public
    constructor Create;
    destructor Destroy; override;
    procedure BuildRequest; virtual;
    procedure Redirect(const NewAddress: AnsiString);
    function IsValidAddress: Boolean;
    function Host(bTruncPort: Boolean = True): AnsiString;
    function GetPort: AnsiString;
    property Authorization: AnsiString read FAuthorization write FAuthorization;
    property ReqType: TfrxRequestType read FReqType write FReqType;
    property Port: Integer read FPort write FPort;
    property SourceStream: TStream read FSourceStream write FSourceStream;
    property AcceptTypes: AnsiString read FAcceptTypes write FAcceptTypes;
    property ContentType: AnsiString read FContentType write FContentType;
    property DefAcceptTypes: TfrxHTTPContentType read FDefAcceptTypes write FDefAcceptTypes;
    property CustomHeader: TStrings read FCustomHeader;
    property Encoding: AnsiString read FEncoding write FEncoding;
    property UserAgent: AnsiString read FUserAgent write FUserAgent;

    property URL: AnsiString read FURL write FURL;
    property Text: AnsiString read GetText write SetText;
  end;

  TfrxHTTPServerFields = class;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxTransportHTTP = class(TfrxBaseTransportConnection)
  private
    FActive: Boolean;
    FConnected: Boolean;
    FRequestString: AnsiString;
    FAnswer: TStrings;
    FBreaked: Boolean;
    FErrors: TStrings;
    FMIC: Boolean;
    FProxyHost: String;
    FProxyPort: Integer;
    FRetryCount: Integer;
    FRetryTimeOut: Integer;
    FServerFields: TfrxHTTPServerFields;
    FRequestStream: TMemoryStream;
    FRawDataStream: TMemoryStream;
    FTimeOut: Integer;
    FProxyLogin: String;
    FProxyPassword: String;
    FPort: Integer;
    FConnectDelay: Cardinal;
    FAnswerDelay: Cardinal;
    FIOHandler: TfrxCustomIOHandler;
    procedure ParseAnswer(aToDataStream: TStream);
//    procedure DoConnect(Sender: TObject; Socket: TCustomWinSocket);
//    procedure DoLookup(Sender: TObject; Socket: TCustomWinSocket);
    procedure DoDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DoError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);

    procedure SetActive(const Value: Boolean);
    procedure SetServerFields(const Value: TfrxHTTPServerFields);
    procedure SetIOHandler(const Value: TfrxCustomIOHandler);
  protected
    FHTTPRequest: TfrxHTTPRequest;
    FClientSocket: TClientSocket;
    StreamSize: Cardinal;
    procedure SetSocketDestination;
    function IsAnswerCodeIn(Answers: array of Integer): boolean;
    function GetProxyHost: String; override;
    function GetProxyLogin: String; override;
    function GetProxyPassword: String; override;
    function GetProxyPort: Integer; override;
    procedure SetProxyHost(const Value: String); override;
    procedure SetProxyLogin(const Value: String); override;
    procedure SetProxyPassword(const Value: String); override;
    procedure SetProxyPort(const Value: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect; override;
    procedure StartListening;
    procedure Disconnect; override;
    procedure Open;
    procedure Close;
    procedure DoWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure DoRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Send(aSource: TStream); // sync method does not return untill finish
    procedure SetDefaultParametersWithToken(AToken: String); override;
    procedure Receive(aSource: TStream); // sync method does not return untill finish
    function Post(aURL: AnsiString; aSource: TStream = nil): AnsiString; overload; // sync method does not return untill finish
    function Get(aURL: AnsiString; aSource: TStream = nil): AnsiString; overload; // sync method does not return untill finish
    function Post(aURL: WideString; aSource: TStream = nil): WideString; overload; // sync method does not return untill finish
    function Get(aURL: WideString; aSource: TStream = nil): WideString; overload; // sync method does not return untill finish
    function Delete(aURL: AnsiString): AnsiString; overload; // sync method does not return untill finish
    function Delete(aURL: WideString): WideString; overload; // sync method does not return untill finish
    property Answer: TStrings read FAnswer write FAnswer;
    property Errors: TStrings read FErrors write Ferrors;
    property RequestStream: TMemoryStream read FRequestStream;
    property IOHandler: TfrxCustomIOHandler read FIOHandler write SetIOHandler;
  published
    property Active: Boolean read FActive write SetActive;
    property RequestString: AnsiString read FRequestString write FRequestString;
    property HTTPRequest: TfrxHTTPRequest read FHTTPRequest;
    property ClientSocket: TClientSocket read FClientSocket;
    property MIC: Boolean read FMIC write FMIC;
    property Port: Integer read FPort write FPort;
    property ProxyHost;
    property ProxyPort;
    property ProxyLogin;
    property ProxyPassword;
    property RetryCount: Integer read FRetryCount write FRetryCount;
    property RetryTimeOut: Integer read FRetryTimeOut write FRetryTimeOut;
    property ServerFields: TfrxHTTPServerFields read FServerFields write SetServerFields;
    property TimeOut: Integer read FTimeOut write FTimeOut;
    property ConnectDelay: Cardinal read FConnectDelay;
    property AnswerDelay: Cardinal read FAnswerDelay;
    property OnWork;
    property OnWorkBegin;
    property OnWorkEnd;
  end;

  TfrxHTTPServerFields = class (TPersistent)
  private
    FAnswerCode: Integer;
    FContentEncoding: String;
    FContentMD5: String;
    FContentLength: Integer;
    FLocation: String;
    FSessionId: String;
    FCookie: String;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure ParseAnswer(st: AnsiString);
  published
    property AnswerCode: Integer read FAnswerCode write FAnswerCode;
    property ContentEncoding: String read FContentEncoding write FContentEncoding;
    property ContentMD5: String read FContentMD5 write FContentMD5;
    property ContentLength: Integer read FContentLength write FContentLength;
    property Location: String read FLocation write FLocation;
    property SessionId: String read FSessionId write FSessionId;
    property Cookie: String read FCookie write FCookie;
  end;

  procedure frxTestToken(const URL: String; var sToken: String; bUsePOST: Boolean = False);

  var
    msc: TFPUExceptionMask;

implementation

uses
  StrUtils,
  frxFileUtils, frxUtils, frxOpenSSL
{$IFDEF DELPHI12}
  ,AnsiStrings
{$ENDIF};

procedure frxTestToken(const URL: String; var sToken: String; bUsePOST: Boolean);
var
  tHttp: TfrxTransportHTTP;
  Res: AnsiString;
  MemTmp: TMemoryStream;
begin
  if sToken = '' then Exit;

  tHttp := TfrxTransportHTTP.Create(nil);
  MemTmp := TMemoryStream.Create;
  try
    tHttp.HTTPRequest.DefAcceptTypes := htcDefaultXML;
    tHttp.HTTPRequest.ContentType := '';
    tHttp.HTTPRequest.Authorization := 'Bearer ' + AnsiString(sToken);
    try
      if bUsePOST then
        Res := tHttp.Post(AnsiString(URL), MemTmp)
      else
        Res := tHttp.Get(AnsiString(URL));
    except
      sToken := '';
    end;
  finally
    tHttp.Free;
    MemTmp.Free;
  end;
end;

{ TfrxHTTPServerFields }

constructor TfrxHTTPServerFields.Create;
begin
  FAnswerCode := 0;
  FLocation := '';
  FContentEncoding := '';
  FContentMD5 := '';
  FContentLength := 0;
end;

procedure TfrxHTTPServerFields.ParseAnswer(st: AnsiString);

  function IsDigit(const c: AnsiChar): Boolean;
  begin
    Result := {$IFDEF Delphi12} CharInSet(c, ['0'..'9']);
              {$ELSE}           c in ['0'..'9'];
              {$ENDIF}
  end;

var
  i, j: Integer;
  s1, s2: AnsiString;
begin
  FAnswerCode := 0;
  i := Pos(AnsiString(#13#10), st);
  s1 := Copy(st, 1, i - 1);
  j := 0;
  s2 := '';
  for i := 1 to Length(s1) do
  begin
    if IsDigit(s1[i]) then
    begin
      s2 := s2 + s1[i];
      Inc(j);
    end else
    if j = 3 then
      break
    else
    begin
      j := 0;
      s2 := '';
    end;
  end;
  s1 := s2;
  if Length(s1) = 3 then
    FAnswerCode := StrToInt(String(s1));


  s1 := ParseHeaderField('Location: ', st);
  if (Length(s1) > 0) and (s1[1] = '/') then
    Delete(s1, 1, 1);
  Location := String(s1);

  ContentEncoding := LowerCase(String(ParseHeaderField('Content-Encoding: ', st)));

  ContentMD5 := String(ParseHeaderField('Content-MD5: ', st));

  Cookie := UpdateCookies(String(st), Cookie);

  s1 := ParseHeaderField('SessionId: ', st);
  SessionId := IfStr(s1 <> '', String(s1));

  s1 := ParseHeaderField('Content-length: ', st);
  if s1 <> '' then
    ContentLength := StrToInt(String(s1));
end;

procedure TfrxHTTPServerFields.Assign(Source: TPersistent);
begin
  if Source is TfrxHTTPServerFields then
  begin
    FAnswerCode := TfrxHTTPServerFields(Source).AnswerCode;
    FLocation := TfrxHTTPServerFields(Source).Location;
    FContentEncoding := TfrxHTTPServerFields(Source).ContentEncoding;
    FContentMD5 := TfrxHTTPServerFields(Source).ContentMD5;
    FContentLength := TfrxHTTPServerFields(Source).ContentLength;
  end;
end;

{ TfrxHTTP }

constructor TfrxTransportHTTP.Create(AOwner: TComponent);
begin
  inherited;
  FConnectDelay := 0;
  FAnswerDelay := 0;
  FAnswer := TStringList.Create;
  FRequestStream := TMemoryStream.Create;
  FRawDataStream := TMemoryStream.Create;
  FErrors := TStringList.Create;
  FProxyHost := '';
  FProxyPort := 80;
  FPort := 80;
  FActive := False;
  FServerFields := TfrxHTTPServerFields.Create;
  FRetryTimeOut := 5;
  FRetryCount := 3;
  FTimeOut := 20;
  FBreaked := False;
  FMIC := True;
  FClientSocket := TClientSocket.Create(nil);
  //FClientSocket.OnLookup := DoLookup;
  //FClientSocket.OnConnect := DoConnect;
  //FClientSocket.OnWrite := DoWrite;
  //FClientSocket.OnRead := DoRead;
  FClientSocket.OnDisconnect := DoDisconnect;
  FClientSocket.OnError := DoError;
  FClientSocket.ClientType := ctNonBlocking;
  FHTTPRequest := TfrxHTTPRequest.Create;
  FIOHandler := frxDefaultSocketIOHandlerClass.Create;
end;

procedure TfrxTransportHTTP.Close;
begin
  FBreaked := True;
  Active := False;
  FClientSocket.Close;
//  DoDisconnect(nil, nil);
end;

procedure TfrxTransportHTTP.Connect;
var
  ticks: Cardinal;
  i: Integer;
  bHandleInit, bSockBinded: Boolean;
begin
  i := FRetryCount;
  FBreaked := False;
  bHandleInit := False;
  if not FHTTPRequest.IsValidAddress then
    Errors.Add('There is no "http://" or "https://" in the request.')
  else
  begin
    SetSocketDestination;
    repeat
      FErrors.Clear;
      FRawDataStream.Clear;
      FConnectDelay := GetTickCount;
      FAnswerDelay := GetTickCount;
      FConnected := False;
      bSockBinded := False;
      try
        if not bHandleInit then
        begin
          bHandleInit := FIOHandler.InitializeHandler;
          if not bHandleInit then
            raise Exception.Create('Could not initialize IO Handler.');
        end;
        FClientSocket.Close;
        PMessages;
        FClientSocket.Open;
        PMessages;

        FActive := True;

        //if FClientSocket.Active then

        ticks := GetTickCount;
        while FActive and not FBreaked and not FConnected do
        begin
          if FClientSocket.Socket.Connected then
          begin
           if not bSockBinded then
           begin
             FIOHandler.BindSocket(FClientSocket.Socket);
             bSockBinded := True;
           end;
           PMessages;
           FConnected := FIOHandler.TryConnect;
          end;
          PMessages;
          if ((GetTickCount - ticks) > Cardinal(FTimeOut * 1000)) and not FClientSocket.Active then
          begin
            Errors.Add('Timeout expired (' + IntToStr(FTimeOut) + ')');
            Break;
          end;
        end;
      except
        on E:Exception do
          Errors.Add(E.Message);
      end;
        if not FConnected then
          Dec(i);
    until (i = 0) or FBreaked or FConnected;
  end;
end;

function TfrxTransportHTTP.Delete(aURL: AnsiString): AnsiString;
var
  ReqStream, AnswerStream: TMemoryStream;
begin
  Result := '';
  FHTTPRequest.ReqType := xrtDelete;
  FHTTPRequest.URL := aURL;
  FHTTPRequest.Port := FPort;
  FHTTPRequest.SourceStream := nil;
  FHTTPRequest.BuildRequest;
  ReqStream := TMemoryStream.Create;
  AnswerStream := TMemoryStream.Create;
  try
    Open;
    if not FConnected and (Errors.Count > 0) then
      raise Exception.Create(Errors[Errors.Count - 1]);
    if not FConnected then Exit;
    FHTTPRequest.FRequest.SaveToStream(ReqStream);
    Send(ReqStream);
    FRawDataStream.Clear;
    repeat
      Receive(FRawDataStream);
      ParseAnswer(AnswerStream);
    until (Errors.Count = 0) or (FServerFields.AnswerCode <> 100);
    Close;
    if AnswerStream.Size > 0 then
    begin
      AnswerStream.Position := 0;
      SetLength(Result, AnswerStream.Size);
      AnswerStream.Read(Result[1], AnswerStream.Size)
    end;
  finally
    AnswerStream.Free;
    ReqStream.Free;
  end;
end;

function TfrxTransportHTTP.Delete(aURL: WideString): WideString;
begin
  Result := WideString(Delete(AnsiString(aURL)));
end;

destructor TfrxTransportHTTP.Destroy;
begin
  Close;
  PMessages;
  while FActive do
    PMessages;
  FClientSocket.Close;

  FreeAndNil(FClientSocket);
  FreeAndNil(FHTTPRequest);
  FreeAndNil(FServerFields);
  FreeAndNil(FAnswer);
  FreeAndNil(FRequestStream);
  FreeAndNil(FRawDataStream);
  FreeAndNil(FIOHandler);
  FreeAndNil(FErrors);
  inherited;
end;

procedure TfrxTransportHTTP.Disconnect;
begin
  FIOHandler.Disconnect;
  FClientSocket.Close;
  FActive := False;
end;

//procedure TfrxTransportHTTP.DoConnect(Sender: TObject; Socket: TCustomWinSocket);
//begin
//  // not implimented
//  FConnectDelay := GetTickCount - FConnectDelay;
//  try
//    FRequestStream.Clear;
//
//  except
//    Errors.Add('Data send error');
//  end;
//end;

procedure TfrxTransportHTTP.DoDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  FActive := False;
  FConnected := False;
end;

procedure TfrxTransportHTTP.DoError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Errors.Add(GetSocketErrorText(ErrorCode));
  FActive := False;
  ErrorCode := 0;
end;

//procedure TfrxTransportHTTP.DoLookup(Sender: TObject; Socket: TCustomWinSocket);
//begin
//
//end;

procedure TfrxTransportHTTP.DoRead(Sender: TObject; Socket: TCustomWinSocket);
begin
// TODO
end;

procedure TfrxTransportHTTP.DoWrite(Sender: TObject; Socket: TCustomWinSocket);
begin
// TODO
end;

function TfrxTransportHTTP.Get(aURL: WideString; aSource: TStream): WideString;
begin
  Result := WideString(Get(AnsiString(aURL), aSource));
end;

function TfrxTransportHTTP.GetProxyHost: String;
begin
  Result := FProxyHost;
end;

function TfrxTransportHTTP.GetProxyLogin: String;
begin
  Result := FProxyLogin;
end;

function TfrxTransportHTTP.GetProxyPassword: String;
begin
  Result := FProxyPassword;
end;

function TfrxTransportHTTP.GetProxyPort: Integer;
begin
  Result := FProxyPort;
end;

function TfrxTransportHTTP.Get(aURL: AnsiString; aSource: TStream): AnsiString;
var
  ReqStream, AnswerStream: TMemoryStream;
begin
  Result := '';
  FHTTPRequest.URL := aURL;
  FHTTPRequest.SourceStream := aSource;
  FHTTPRequest.ReqType := xrtGet;
  FHTTPRequest.Port := FPort;
  FHTTPRequest.BuildRequest;
  AnswerStream := nil;
  ReqStream := TMemoryStream.Create;
  if not Assigned(aSource) then
  begin
    AnswerStream := TMemoryStream.Create;
    aSource := AnswerStream;
  end;
  try
    Open;
    if not FConnected and (Errors.Count > 0) then
      raise Exception.Create(Errors[Errors.Count - 1]);
    if not FConnected then Exit;
    FHTTPRequest.FRequest.SaveToStream(ReqStream);
    Send(ReqStream);
    FRawDataStream.Clear;
    repeat
      Receive(FRawDataStream);
      ParseAnswer(aSource);
    until (Errors.Count = 0) or (FServerFields.AnswerCode <> 100);
    Close;
    if Assigned(AnswerStream) and (AnswerStream.Size > 0) then
    begin
      AnswerStream.Position := 0;
      SetLength(Result, AnswerStream.Size);
      AnswerStream.Read(Result[1], AnswerStream.Size)
    end;
  finally
    if Assigned(AnswerStream) then
      AnswerStream.Free;
    ReqStream.Free;
  end;
end;

function TfrxTransportHTTP.IsAnswerCodeIn(Answers: array of Integer): boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to High(Answers) do
    if FServerFields.AnswerCode = Answers[i] then
      Exit;
  Result := False;
end;

procedure TfrxTransportHTTP.Open;
begin
  Active := True;
end;

procedure TfrxTransportHTTP.ParseAnswer(aToDataStream: TStream);
var
  i, Len: Integer;
  s, s1: AnsiString;
  MICStream: TMemoryStream;
begin
  FAnswer.Clear;
  if FRawDataStream.Size > 0 then
  begin
    FRawDataStream.Position := 0;
    i := StreamSearch(FRawDataStream, 0, #13#10#13#10);
    if i <> 0 then
    begin
      Len := i + 4;
      StreamSize := FRawDataStream.Size - Len;
      SetLength(s, Len);
      FRawDataStream.Position := 0;
      FRawDataStream.ReadBuffer(s[1], Len);
      FAnswer.Text := String(s);

      FServerFields.ParseAnswer(s);

      s1 := AnsiString(GetHTTPErrorText(FServerFields.AnswerCode));
      if s1 <> '' then
        Errors.Add(String(s1));

      if Errors.Count = 0 then
      begin
        if FServerFields.ContentLength > 0 then
          if ((FRawDataStream.Size - Len) <> FServerFields.ContentLength) and
                 IsAnswerCodeIn([200, 206]) then
            Errors.Add('Received data size mismatch');
        if (Length(FServerFields.ContentMD5) > 0) and FMIC and (Errors.Count = 0) then
        begin
          MICStream := TMemoryStream.Create;
          try
            MICStream.CopyFrom(FRawDataStream, FRawDataStream.Size - Len);
            if MD5Stream(MICStream) <> AnsiString(FServerFields.ContentMD5) then
              Errors.Add('Message integrity checksum (MIC) error');
          finally
            FRawDataStream.Position := Len;
            MICStream.Free;
          end;
        end;
        if Assigned(aToDataStream) and (Errors.Count = 0) then
          if Pos('gzip', FServerFields.ContentEncoding) > 0 then
          try
            frxDecompressStream(FRawDataStream, aToDataStream)
          except
            Errors.Add('Unpack data error')
          end
          else
            aToDataStream.CopyFrom(FRawDataStream, FRawDataStream.Size - Len);
      end
      else if Assigned(aToDataStream) then
        aToDataStream.CopyFrom(FRawDataStream, FRawDataStream.Size - Len);
    end
    else
      Errors.Add('Bad header');
    FRawDataStream.Clear;
  end
  else if Errors.Count = 0 then
    Errors.Add('Zero bytes received');
end;

function TfrxTransportHTTP.Post(aURL: WideString; aSource: TStream): WideString;
begin
  Result := WideString(Post(AnsiString(aURL), aSource));
end;

function TfrxTransportHTTP.Post(aURL: AnsiString; aSource: TStream): AnsiString;
var
  ReqStream, AnswerStream: TMemoryStream;
begin
  Result := '';
  FHTTPRequest.ReqType := xrtPost;
  FHTTPRequest.URL := aURL;
  FHTTPRequest.Port := FPort;
  FHTTPRequest.SourceStream := aSource;
  FHTTPRequest.BuildRequest;
  ReqStream := TMemoryStream.Create;
  AnswerStream := TMemoryStream.Create;
  try
    Open;
    if not FConnected and (Errors.Count > 0) then
      raise Exception.Create(Errors[Errors.Count - 1]);
    if not FConnected then Exit;    
    FHTTPRequest.FRequest.SaveToStream(ReqStream);
    Send(ReqStream);
    if Assigned(aSource) then
      Send(aSource);
    FRawDataStream.Clear;
    if not FConnected then Exit;
    repeat
      Receive(FRawDataStream);
      ParseAnswer(AnswerStream);
    until (Errors.Count = 0) or (FServerFields.AnswerCode <> 100);
    Close;
    if AnswerStream.Size > 0 then
    begin
      AnswerStream.Position := 0;
      SetLength(Result, AnswerStream.Size);
      AnswerStream.Read(Result[1], AnswerStream.Size)
    end;
  finally
    AnswerStream.Free;
    ReqStream.Free;
  end;
end;

procedure TfrxTransportHTTP.Receive(aSource: TStream);
var
  bTryRead: Boolean;
  s: String;
  OldSz: Int64;
begin
  if not FConnected then Exit;
  bTryRead := True;
  OldSz := 0;
  if Assigned(OnWorkBegin) then
    OnWorkBegin(Self, hwmRead, 0);
  while bTryRead and FConnected do
  begin
    bTryRead := FIOHandler.Read(aSource);
    if bTryRead and Assigned(OnWork) then
    begin      
      OnWork(Self, hwmRead, aSource.Size - OldSz);
      OldSz := aSource.Size;  
    end;
  end;
  if Assigned(OnWorkEnd) then
    OnWorkEnd(Self, hwmRead, 0);
  s := FIOHandler.GetLastError;
  if s <> '' then
    Errors.Add(s);
end;

procedure TfrxTransportHTTP.Send(aSource: TStream);
var
  bTryWrite: Boolean;
  s: String;
  sPos: Integer;
begin
  if not FConnected then Exit;
  aSource.Position := 0;
  bTryWrite := True;
  if Assigned(OnWorkBegin) then
    OnWorkBegin(Self, hwmWrite, 0);
///  FClientSocket.Socket.Disconnect(FClientSocket.Socket.SocketHandle);
  while (aSource.Position < aSource.Size) and bTryWrite and FConnected do
  begin
    sPos := aSource.Position;
    bTryWrite := FIOHandler.Write(aSource);
    if bTryWrite and Assigned(OnWork) then
      OnWork(Self, hwmWrite, aSource.Size - sPos);
  end;
  s := FIOHandler.GetLastError;
  if Assigned(OnWorkEnd) then
    OnWorkEnd(Self, hwmWrite, 0);
  if s <> '' then
    Errors.Add(s);
end;

procedure TfrxTransportHTTP.SetActive(const Value: Boolean);
begin
  if Value then
    Connect
  else
    Disconnect;
end;

procedure TfrxTransportHTTP.SetDefaultParametersWithToken(AToken: String);
begin
  HTTPRequest.DefAcceptTypes := htcDefaultXML;
  HTTPRequest.ContentType := '';
  HTTPRequest.Authorization := 'Bearer ' + AnsiString(AToken);
end;

procedure TfrxTransportHTTP.SetIOHandler(const Value: TfrxCustomIOHandler);
begin
  if Assigned(FIOHandler) then
    FIOHandler.Free;
  FIOHandler := Value;
end;

procedure TfrxTransportHTTP.SetProxyHost(const Value: String);
begin
  FProxyHost := Value;
end;

procedure TfrxTransportHTTP.SetProxyLogin(const Value: String);
begin
  FProxyLogin := Value;
end;

procedure TfrxTransportHTTP.SetProxyPassword(const Value: String);
begin
  FProxyPassword := Value;
end;

procedure TfrxTransportHTTP.SetProxyPort(const Value: Integer);
begin
  FProxyPort := Value;
end;

procedure TfrxTransportHTTP.SetServerFields(const Value: TfrxHTTPServerFields);
begin
  FServerFields.Assign(Value);
end;

procedure TfrxTransportHTTP.SetSocketDestination;
var
  sPort: AnsiString;
  iPort: integer;
begin
  if FProxyHost <> '' then
  begin
    FClientSocket.Host := FProxyHost;
    FClientSocket.Port := FProxyPort;
  end else
  begin
    FClientSocket.Host := String(FHTTPRequest.Host);
    sPort := FHTTPRequest.GetPort;
    iPort := -1;
    if (sPort <> '') then
      TryStrToInt(String(sPort), iPort);
    if iPort >= 0 then
      FClientSocket.Port := iPort
    else
      FClientSocket.Port := FPort;
  end;
  FClientSocket.Address := FClientSocket.Host;
end;

procedure TfrxTransportHTTP.StartListening;
begin
  // TODO: Listening mode
end;


{ TfrxHTTPRequest }

constructor TfrxHTTPRequest.Create;
begin
  inherited;
  FRequest := TStringList.Create;
  FCustomHeader := TStringList.Create;
  FSourceStream := nil;
  FUserAgent := 'User-Agent: Mozilla/3.0 (compatible; FastReport-Transport)';
  FEncoding := 'identity';
end;

destructor TfrxHTTPRequest.Destroy;
begin
  FreeAndNil(FRequest);
  FreeAndNil(FCustomHeader);
  inherited;
end;

function TfrxHTTPRequest.GetText: AnsiString;
begin
  SureEmptyLineAtEnd;
  Result := AnsiString(FRequest.Text);
end;

function TfrxHTTPRequest.Host(bTruncPort: Boolean = True): AnsiString;
var
  Slash: Integer;
begin
  if PosEx(HTTP_LINK_PREFIX, URL, 1) = 1 then
    Result := copy(URL, 8, Length(URL) - 7)
  else if PosEx(HTTPS_LINK_PREFIX, URL, 1) = 1 then
    Result := copy(URL, 9, Length(URL) - 8)
  else if URL[1] = '/' then
    Result := copy(URL, 2, Length(URL) - 1);

  Slash := PosEx(AnsiString('/'), Result, 1);
  if Slash <> 0 then
    Result := copy(Result, 1, Slash - 1);
  { check port }
  if not bTruncPort then Exit;
  Slash := PosEx(AnsiString(':'), Result, 1);
  if Slash <> 0 then
    Result := copy(Result, 1, Slash - 1);
end;

function TfrxHTTPRequest.IsValidAddress: Boolean;
begin
  Result := (PosEx(HTTP_LINK_PREFIX, FURL, 1) = 1) or
            (PosEx(HTTPS_LINK_PREFIX, FURL, 1) = 1);
end;

function TfrxHTTPRequest.GetPort: AnsiString;
var
  Index: Integer;
begin
  Result := Host(False);
  Index := PosEx(AnsiString(':'), Result, 1);
  if Index <> 0 then
    Result := Copy(Result, Index + 1, Length(Result) - (Index + 1))
  else if (PosEx(HTTP_LINK_PREFIX, FURL, 1) = 1) then
    Result := '80'
  else if (PosEx(HTTPS_LINK_PREFIX, FURL, 1) = 1) then
        Result := '443'
  else if FPort <> 0 then
    Result := AnsiString(IntToStr(FPort))
  else
    Result := '';
end;

procedure TfrxHTTPRequest.Redirect(const NewAddress: AnsiString);
begin
  FURL := NewAddress;
end;

procedure TfrxHTTPRequest.SetText(const Value: AnsiString);
begin
  FRequest.Text := String(Value);
end;

procedure TfrxHTTPRequest.SureEmptyLineAtEnd;
begin
  if (FRequest.Count > 0) and (FRequest[FRequest.Count - 1] <> '') then
    FRequest.Add('');
end;

procedure TfrxHTTPRequest.BuildRequest;
var
  ReqTyp, aHost, aPath, TempS: AnsiString;
  len: Integer;
  i: Integer;
begin
  FRequest.Clear;
  ReqTyp := HTTP_POST;
  aHost := Host;
  len := Pos(aHost, URL) + Length(aHost);
  aPath := Copy(URL, len, Length(URL) - len + 1);
  case ReqType of
    xrtPost: ReqTyp := HTTP_POST;
    xrtGet: ReqTyp := HTTP_GET;
    xrtDelete: ReqTyp := HTTP_DELETE;
  end;
  FRequest.Add(String(ReqTyp) + ' ' + String(aPath) + ' ' + HTTP_VER1);

  if ContentType <> '' then
    FRequest.Add('Content-Type: ' + String(ContentType));

  len := 0;
  if Assigned(SourceStream) then
    len := SourceStream.Size;
  if len >= 0 then
    FRequest.Add('Content-Length: ' + IntToStr(len));
  if Authorization <> '' then
    FRequest.Add('Authorization: ' + String(Authorization));
  FRequest.Add('Host: ' + String(aHost));
  { toDo something better }
  TempS := '';
  case DefAcceptTypes of
    htcNone: ;
    hctDefaultHTML: TempS := 'text/html,application/xhtml+xml,application/xml;q=0.9';
    htcDefaultXML: TempS := 'text/html,application/xhtml+xml,application/xml;q=0.9' ;
    htcDefaultApp: TempS := 'application/octet-stream' ;
  end;
  TempS := TempS + AcceptTypes;
  if TempS <> '' then
    TempS := TempS + ',';
  TempS := TempS + '*/*;q=0.8';
  if TempS <> '' then
    FRequest.Add('Accept: ' + String(TempS));

  if Encoding <> '' then
    FRequest.Add('Accept-Encoding: ' + String(Encoding));
  for i := 0 to FCustomHeader.Count - 1 do
    FRequest.Add(FCustomHeader[i]);
  if UserAgent <> '' then
    FRequest.Add('UserAgent: ' + String(UserAgent));
  FRequest.Add('');
end;

initialization
  msc := GetExceptionMask;

end.
