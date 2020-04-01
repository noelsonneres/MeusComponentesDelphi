
{******************************************}
{                                          }
{             FastReport v6.0              }
{        HTTP conector Indy wrapper        }
{                                          }
{         Copyright (c) 2006-2018          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxTransportIndyConnectorHTTP;

{$I frx.inc}
interface

uses
  SysUtils, Classes, frxBaseTransportConnection,
  frxTransportIndyConnector, IdTCPConnection, IdHTTP;

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxTransportIndyConnectorHTTP = class(TfrxTransportIndyConnector)
  protected
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
    function GetIdHTTP: TidHTTP;
    procedure SetDefaultParametersWithToken(AToken: String); override;
  end;

  procedure frxTestTokenIndy(const URL: String; var sToken: String; bUsePOST: Boolean);
  procedure IndyLog(LogFileName: String; IdTCPConnection: TIdTCPConnection);

implementation

uses
  StrUtils, IdSSLOpenSSL, IdLogFile
{$IFDEF DELPHI12}
  ,AnsiStrings
{$ENDIF};

procedure IndyLog(LogFileName: String; IdTCPConnection: TIdTCPConnection);
var
  IdLogFile: TIdLogFile;
begin
  DeleteFile(LogFileName);
  IdLogFile := TIdLogFile.Create(IdTCPConnection);
  IdLogFile.Filename := LogFileName;
  IdLogFile.Active := True;
{$IfNDef INDYPARAM_INT}
  IdTCPConnection.Intercept := IdLogFile;
{$ENDIF}
end;

procedure frxTestTokenIndy(const URL: String; var sToken: String; bUsePOST: Boolean);
var
  IdHttp: TIdHttp;
  Res: String;
  MemTmp: TMemoryStream;
begin
  if sToken = '' then Exit;
  IdHTTP := TIdHTTP.Create(nil);

  MemTmp := TMemoryStream.Create;
  try
{$IFDEF Indy9}
    IdHTTP.IOHandler := TIdSSLIOHandlerSocket.Create(IdHTTP);
    TIdSSLIOHandlerSocket(IdHTTP.IOHandler).SSLOptions.Method := sslvTLSv1;
    IdHTTP.Request.CustomHeaders.FoldLength := MaxInt;
{$ELSE}
    IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
{$ENDIF}
    IdHTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' +
      sToken;
    IdHTTP.Request.BasicAuthentication := False;
    try
      if bUsePOST then
        Res := IdHTTP.Post(URL, MemTmp)
      else
        Res := IdHTTP.Get(URL);
    except
      sToken := '';
    end;
  finally
    IdHTTP.Free;
    MemTmp.Free;
  end;
end;

{ TfrxTransportIndyConnectorHTTP }

constructor TfrxTransportIndyConnectorHTTP.Create(AOwner: TComponent);
var
  idHTTP: TidHTTP;
begin
  inherited;
  idHTTP := TidHTTP.Create(nil);
{$IFDEF Indy9}
  IdHTTP.IOHandler := TIdSSLIOHandlerSocket.Create(IdHTTP);
  TIdSSLIOHandlerSocket(IdHTTP.IOHandler).SSLOptions.Method := sslvTLSv1;
  IdHTTP.Request.CustomHeaders.FoldLength := MaxInt;
{$ELSE}
  IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
{$ENDIF}
  IdConnection := idHTTP;
end;

destructor TfrxTransportIndyConnectorHTTP.Destroy;
begin
  inherited;
  FreeAndNil(FIdConnection);
end;

function TfrxTransportIndyConnectorHTTP.GetIdHTTP: TidHTTP;
begin
  Result := TidHTTP(FIdConnection);
end;

function TfrxTransportIndyConnectorHTTP.GetProxyHost: String;
begin
  Result := GetIdHTTP.ProxyParams.ProxyServer;
end;

function TfrxTransportIndyConnectorHTTP.GetProxyLogin: String;
begin
  Result := GetIdHTTP.ProxyParams.ProxyUsername;
end;

function TfrxTransportIndyConnectorHTTP.GetProxyPassword: String;
begin
  Result := GetIdHTTP.ProxyParams.ProxyPassword;
end;

function TfrxTransportIndyConnectorHTTP.GetProxyPort: Integer;
begin
  Result := GetIdHTTP.ProxyParams.ProxyPort;
end;

procedure TfrxTransportIndyConnectorHTTP.SetDefaultParametersWithToken(
  AToken: String);
var
  idHTTP: TidHTTP;
begin
  idHTTP := TidHTTP(FIdConnection);
  IdHTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' +
    AToken;
  IdHTTP.Request.BasicAuthentication := False;
end;

procedure TfrxTransportIndyConnectorHTTP.SetProxyHost(const Value: String);
begin
  GetIdHTTP.ProxyParams.ProxyServer := Value;
end;

procedure TfrxTransportIndyConnectorHTTP.SetProxyLogin(const Value: String);
begin
  GetIdHTTP.ProxyParams.ProxyUsername := Value;
end;

procedure TfrxTransportIndyConnectorHTTP.SetProxyPassword(const Value: String);
begin
  GetIdHTTP.ProxyParams.ProxyPassword := Value;
end;

procedure TfrxTransportIndyConnectorHTTP.SetProxyPort(const Value: Integer);
begin
  GetIdHTTP.ProxyParams.ProxyPort := Value;
end;

end.
