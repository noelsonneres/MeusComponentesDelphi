
{******************************************}
{                                          }
{             FastReport v6.0              }
{          HTTP base IO handler            }
{                                          }
{         Copyright (c) 2006-2018          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxBaseSocketIOHandler;

{$I frx.inc}
interface

uses
  Windows, SysUtils, Classes, ScktComp,
  WinSock;


type
  TfrxBaseSockErrors = (bseNone, bseSocketErr, bseWantRead, bseWantWrite, bseWantLookup, bseSYSCall, bseZeroRet, bseWantConnect, bseWantAccept, bseWantAsync);
  TfrxSecurityProtocol = (spNone, spSSLv2, spSSLv3, spSSLv23, spTLSv1, spTLSv1_1, spTLSv1_2);
  TfrxSecurityProtocols = set of TfrxSecurityProtocol;

  TfrxCustomIOHandler = class
  protected
    FLastError: Integer;
    FBuffer: PAnsiChar;
    FBuffSize: Integer;
    FStream: TMemoryStream;
    FConnected: Boolean;
    FSecurityProtocol: TfrxSecurityProtocol;
    function DoRead(var Buffer; Count: Longint): Integer; virtual; abstract;
    function DoWrite(var Buffer; Count: Longint): Integer; virtual; abstract;
    function GetErrorCode(ErrCode: Integer): Integer; virtual; abstract;
    procedure SetSecurityProtocol(const Value: TfrxSecurityProtocol); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function GetLastError: String; virtual;
    function InitializeHandler: Boolean; virtual;
    procedure BindSocket(Socket: TCustomWinSocket); virtual;
    function TryConnect: Boolean; virtual;
    procedure Disconnect; virtual;
    function Read(Stream: TStream): Boolean; virtual;
    function Write(Stream: TStream): Boolean; virtual;
    function ProcessIO: Boolean; virtual;
    procedure RunIO; virtual;
    function SupportedSecurityProtocol: TfrxSecurityProtocols; virtual;
    property SecurityProtocol: TfrxSecurityProtocol read FSecurityProtocol write SetSecurityProtocol;
  end;

  TfrxWinSockIOHandler = Class(TfrxCustomIOHandler)
  private
    FWinSock: TCustomWinSocket;
  protected
    function DoRead(var Buffer; Count: Longint): Integer; override;
    function DoWrite(var Buffer; Count: Longint): Integer; override;
    function GetErrorCode(ErrCode: Integer): Integer; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure BindSocket(Socket: TCustomWinSocket); override;
    procedure Connect;
    function TryConnect: Boolean; override;
    procedure Disconnect; override;
    function ProcessIO: Boolean; override;
  end;

  TfrxCustomIOHandlerClass = class of TfrxCustomIOHandler;

var
  frxDefaultSocketIOHandlerClass: TfrxCustomIOHandlerClass;

implementation

uses
  StrUtils,
  frxFileUtils, frxUtils;

{ TfrxCustomIOHandler }

procedure TfrxCustomIOHandler.BindSocket(Socket: TCustomWinSocket);
begin

end;

constructor TfrxCustomIOHandler.Create;
begin
  FBuffSize := 16384;
  GetMem(FBuffer, FBuffSize);
  FLastError := 0;
end;

destructor TfrxCustomIOHandler.Destroy;
begin
  FreeMem(FBuffer);
  inherited;
end;

procedure TfrxCustomIOHandler.Disconnect;
begin

end;

function TfrxCustomIOHandler.GetLastError: String;
begin
  Result := '';
end;

function TfrxCustomIOHandler.InitializeHandler: Boolean;
begin
  Result := True;
end;

function TfrxCustomIOHandler.Read(Stream: TStream): Boolean;
var
  i: Integer;
begin
  Result := False;
  if FLastError <> 0 then
    Exit;
  i := DoRead(FBuffer^, FBuffSize);
  if i > 0 then
  begin
    Stream.Write(FBuffer^, i);
    Result := True;
  end;

  if i < 0 then
  begin
    FLastError := GetErrorCode(i);
    Result := ProcessIO;
  end
  else if i = 0 then
    Result := False;
end;

function TfrxCustomIOHandler.Write(Stream: TStream): Boolean;
var
  i, ipos: Integer;
begin
  Result := False;
  if FLastError <> 0 then Exit;
  if Stream.Size > FBuffSize then
    i := FBuffSize
  else
    i := Stream.Size;
  ipos := Stream.Position;
  Stream.Read(FBuffer^, i);
  i := DoWrite(FBuffer^, i);
  if i <= 0 then
  begin
    Stream.Position := ipos;
    FLastError := GetErrorCode(i);
    Result := ProcessIO;
  end
  else
    Result := True;
end;

function TfrxCustomIOHandler.ProcessIO: Boolean;
begin
  Result := False;
end;

procedure TfrxCustomIOHandler.RunIO;
begin

end;

procedure TfrxCustomIOHandler.SetSecurityProtocol(
  const Value: TfrxSecurityProtocol);
begin
  FSecurityProtocol := Value;
end;

function TfrxCustomIOHandler.SupportedSecurityProtocol: TfrxSecurityProtocols;
begin
  Result := [spNone];
end;

function TfrxCustomIOHandler.TryConnect: Boolean;
begin
 Result := False;
end;

{ TfrxWinSockIOHandler }

procedure TfrxWinSockIOHandler.BindSocket(Socket: TCustomWinSocket);
begin
  inherited;
  FWinSock := Socket;
  FLastError := WSAGetLastError;
end;

procedure TfrxWinSockIOHandler.Connect;
begin

end;

constructor TfrxWinSockIOHandler.Create;
begin
  inherited;
end;

destructor TfrxWinSockIOHandler.Destroy;
begin
  FWinSock := nil;
  inherited;
end;

procedure TfrxWinSockIOHandler.Disconnect;
begin
  inherited;

end;

function TfrxWinSockIOHandler.DoRead(var Buffer; Count: Integer): Integer;
begin
  Result := FWinSock.ReceiveBuf(Buffer, Count);
  if Result = -1 then
    FLastError := 2
  else
    FLastError := 0;

end;

function TfrxWinSockIOHandler.DoWrite(var Buffer; Count: Integer): Integer;
begin
  Result := FWinSock.SendBuf(Buffer, Count);
end;

function TfrxWinSockIOHandler.GetErrorCode(ErrCode: Integer): Integer;
begin
  Result := FLastError;//WSAGetLastError;
end;


function TfrxWinSockIOHandler.ProcessIO: Boolean;
begin
  Result := True;
  FLastError := 0;
end;

function TfrxWinSockIOHandler.TryConnect: Boolean;
begin
  FConnected := FWinSock.Connected;
    Result := FConnected;
  FLastError := 0;
  if not FConnected then

    FWinSock. Connect(FWinSock.SocketHandle);
end;

initialization
 frxDefaultSocketIOHandlerClass := TfrxWinSockIOHandler;

finalization
 frxDefaultSocketIOHandlerClass := nil;

end.
