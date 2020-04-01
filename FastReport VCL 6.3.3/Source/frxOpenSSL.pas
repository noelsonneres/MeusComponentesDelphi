
{******************************************}
{                                          }
{             FastReport v6.0              }
{            OpenSSL IO handler            }
{                                          }
{         Copyright (c) 2006-2018          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxOpenSSL;

{$I frx.inc}
interface

uses
  Windows, SysUtils, Classes, ScktComp, frxBaseSocketIOHandler,
  WinSock;

type
  TfrxSSLIOHandler = Class(TfrxCustomIOHandler)
  private
    FSSL: Pointer;
    FCtx: pointer;
    FMethod: Pointer;
    FHandshakeDone: Boolean;
  protected
    function DoRead(var Buffer; Count: Longint): Integer; override;
    function DoWrite(var Buffer; Count: Longint): Integer; override;
    function GetErrorCode(ErrCode: Integer): Integer; override;
  public
    constructor Create; override;
    function GetLastError: String; override;
    function InitializeHandler: Boolean; override;
    procedure BindSocket(Socket: TCustomWinSocket); override;
    procedure DoHandshake;
    procedure Connect;
    function TryConnect: Boolean; override;
    procedure Disconnect; override;
//    function Read(Stream: TStream): Boolean; override;
//    function Write(Stream: TStream): Boolean; override;
    function ProcessIO: Boolean; override;
  end;

implementation

uses
  StrUtils,
  frxFileUtils, frxUtils;

const SSL_LIB_NAME = 'ssleay32.dll';

type
  TfrxSSL_library_init = function: Integer; cdecl;
  TfrxSSLv2_client_method = function: Pointer; cdecl;
  TfrxSSLv23_client_method = function: Pointer; cdecl;
  TfrxTLSv1_1_client_method = function: Pointer; cdecl;
  TfrxTLSv1_2_client_method = function: Pointer; cdecl;
  TfrxTLSv1_client_method = function: Pointer; cdecl;
  TfrxSSLv3_client_method = function: Pointer; cdecl;
  TfrxDTLS_client_method = function: Pointer; cdecl;
  TfrxDTLSv1_2_client_method = function: Pointer; cdecl;
  TfrxDTLSv1_client_method = function: Pointer; cdecl;

  TfrxSSL_CTX_new = function(meth: Pointer): Pointer; cdecl;
  TfrxSSL_CTX_free = procedure(ctx: Pointer); cdecl;
  TfrxSSL_new = function(ctx: Pointer): Pointer; cdecl;
  TfrxSSL_set_fd = function(s: Pointer; fd: TSocket): Integer cdecl;
  TfrxSSL_connect = function(ssl: Pointer): Integer; cdecl;
  TfrxSSL_do_handshake = function(ssl: Pointer): Integer; cdecl;
  TfrxSSL_free = procedure(ssl: Pointer); cdecl;
  TfrxSSL_read = function(ssl: Pointer; buf: PAnsiChar; num: Integer): Integer; cdecl;
  TfrxSSL_write = function(ssl: Pointer; buf: PAnsiChar; num: Integer): Integer; cdecl;
  TfrxSSL_get_error = function(ssl: Pointer; ret: Integer): Integer; cdecl;
  TfrxSSL_CTX_ctrl = function(ctx: Pointer; cmd: Integer; larg: Integer; parg: Pointer): Longint; cdecl;
  TfrxSSL_CTX_set_default_verify_paths = function(ctx: Pointer): Longint; cdecl;
  TfrxSSL_CTX_set_cipher_list = function(ctx: Pointer; const str: PAnsiChar): Longint; cdecl;
  TfrxSSL_get_fd = function(const SSL: Pointer): Longint; cdecl;
  TfrxSSL_clear = function(SSL: Pointer): Longint; cdecl;

const
  SSL_ERROR_NONE = 0;
  SSL_ERROR_SSL = 1;
  SSL_ERROR_WANT_READ = 2;
  SSL_ERROR_WANT_WRITE = 3;
  SSL_ERROR_WANT_X509_LOOKUP = 4;
  SSL_ERROR_SYSCALL = 5;
  SSL_ERROR_ZERO_RETURN = 6;
  SSL_ERROR_WANT_CONNECT = 7;
  SSL_ERROR_WANT_ACCEPT = 8;
  SSL_ERROR_WANT_ASYNC = 9;
  SSL_ERROR_WANT_ASYNC_JOB = 10;
  SSL_DEFAULT_CIPHER_LIST = 'AES:ALL:!aNULL:!eNULL:+RC4:@STRENGTH';

var
  frxSSLLibrary: HModule;
  frxSSL_library_init: TfrxSSL_library_init;
  frxSSLv2_client_method: TfrxSSLv2_client_method;
  frxSSLv23_client_method: TfrxSSLv23_client_method;
  frxTLSv1_1_client_method: TfrxTLSv1_1_client_method;
  frxTLSv1_2_client_method: TfrxTLSv1_2_client_method;
  frxTLSv1_client_method: TfrxTLSv1_client_method;
  frxSSLv3_client_method: TfrxSSLv3_client_method;
  frxDTLS_client_method: TfrxDTLS_client_method;
  frxDTLSv1_2_client_method: TfrxDTLSv1_2_client_method;
  frxDTLSv1_client_method: TfrxDTLSv1_client_method;
  frxSSL_CTX_new: TfrxSSL_CTX_new;
  frxSSL_CTX_free: TfrxSSL_CTX_free;
  frxSSL_new: TfrxSSL_new;
  frxSSL_set_fd: TfrxSSL_set_fd;
  frxSSL_connect: TfrxSSL_connect;
  frxSSL_do_handshake: TfrxSSL_do_handshake;
  frxSSL_free: TfrxSSL_free;
  frxSSL_read: TfrxSSL_read;
  frxSSL_write: TfrxSSL_write;
  frxSSL_get_error: TfrxSSL_get_error;
  frxSSL_CTX_ctrl: TfrxSSL_CTX_ctrl;
  frxSSL_CTX_set_default_verify_paths: TfrxSSL_CTX_set_default_verify_paths;
  frxSSL_CTX_set_cipher_list: TfrxSSL_CTX_set_cipher_list;
  frxSSL_get_fd: TfrxSSL_get_fd;
  frxSSL_clear: TfrxSSL_clear;


procedure InitializeFunctions(aLibrary: HModule);
begin
  frxSSL_library_init := TfrxSSL_library_init(GetProcAddress(aLibrary, 'SSL_library_init'));
  frxSSLv2_client_method := TfrxSSLv2_client_method(GetProcAddress(aLibrary, 'SSLv2_client_method'));
  frxSSLv23_client_method := TfrxSSLv23_client_method(GetProcAddress(aLibrary, 'SSLv23_client_method'));
  frxTLSv1_1_client_method := TfrxTLSv1_1_client_method(GetProcAddress(aLibrary, 'TLSv1_1_client_method'));
  frxTLSv1_2_client_method := TfrxTLSv1_2_client_method(GetProcAddress(aLibrary, 'TLSv1_2_client_method'));
  frxTLSv1_client_method := TfrxTLSv1_client_method(GetProcAddress(aLibrary, 'TLSv1_client_method'));
  frxSSLv3_client_method := TfrxSSLv3_client_method(GetProcAddress(aLibrary, 'SSLv3_client_method'));
  frxDTLS_client_method := TfrxDTLS_client_method(GetProcAddress(aLibrary, 'DTLS_client_method'));
  frxDTLSv1_2_client_method := TfrxDTLSv1_2_client_method(GetProcAddress(aLibrary, 'DTLSv1_2_client_method'));
  frxDTLSv1_client_method := TfrxDTLSv1_client_method(GetProcAddress(aLibrary, 'DTLSv1_client_method'));
  frxSSL_CTX_new := TfrxSSL_CTX_new(GetProcAddress(aLibrary, 'SSL_CTX_new'));
  frxSSL_CTX_free := TfrxSSL_CTX_free(GetProcAddress(aLibrary, 'SSL_CTX_free'));
  frxSSL_new := TfrxSSL_new(GetProcAddress(aLibrary, 'SSL_new'));
  frxSSL_set_fd := TfrxSSL_set_fd(GetProcAddress(aLibrary, 'SSL_set_fd'));
  frxSSL_connect := TfrxSSL_connect(GetProcAddress(aLibrary, 'SSL_connect'));
  frxSSL_do_handshake := TfrxSSL_do_handshake(GetProcAddress(aLibrary, 'SSL_do_handshake'));
  frxSSL_free := TfrxSSL_free(GetProcAddress(aLibrary, 'SSL_free'));
  frxSSL_read := TfrxSSL_read(GetProcAddress(aLibrary, 'SSL_read'));
  frxSSL_write := TfrxSSL_write(GetProcAddress(aLibrary, 'SSL_write'));
  frxSSL_get_error := TfrxSSL_get_error(GetProcAddress(aLibrary, 'SSL_get_error'));
  frxSSL_CTX_ctrl := TfrxSSL_CTX_ctrl(GetProcAddress(aLibrary, 'SSL_CTX_ctrl'));
  frxSSL_CTX_set_default_verify_paths := TfrxSSL_CTX_set_default_verify_paths(GetProcAddress(aLibrary, 'SSL_CTX_set_default_verify_paths'));
  frxSSL_CTX_set_cipher_list := TfrxSSL_CTX_set_cipher_list(GetProcAddress(aLibrary, 'SSL_CTX_set_cipher_list'));
  frxSSL_get_fd := TfrxSSL_get_fd(GetProcAddress(aLibrary, 'SSL_get_fd'));
  frxSSL_clear := TfrxSSL_clear(GetProcAddress(aLibrary, 'SSL_clear'));
end;

function SSL_library_init: Integer;
begin
  Result := -1;
  if Assigned(frxSSL_library_init) then
    Result := frxSSL_library_init();
end;

function SSLv2_client_method: Pointer;
begin
  Result := nil;
  if Assigned(frxSSLv2_client_method) then
    Result := frxSSLv2_client_method();
end;

function SSLv23_client_method: Pointer;
begin
  Result := nil;
  if Assigned(frxSSLv23_client_method) then
    Result := frxSSLv23_client_method();
end;

function TLSv1_1_client_method: Pointer;
begin
  Result := nil;
  if Assigned(frxTLSv1_1_client_method) then
    Result := frxTLSv1_1_client_method();
end;

function TLSv1_2_client_method: Pointer;
begin
  Result := nil;
  if Assigned(frxTLSv1_2_client_method) then
    Result := frxTLSv1_2_client_method();
end;

function TLSv1_client_method: Pointer;
begin
  Result := nil;
  if Assigned(frxTLSv1_client_method) then
    Result := frxTLSv1_client_method();
end;

function SSLv3_client_method: Pointer;
begin
  Result := nil;
  if Assigned(frxSSLv3_client_method) then
    Result := frxSSLv3_client_method();
end;

function DTLS_client_method: Pointer;
begin
  Result := nil;
  if Assigned(frxDTLS_client_method) then
    Result := frxDTLS_client_method();
end;

function DTLSv1_2_client_method: Pointer;
begin
  Result := nil;
  if Assigned(frxDTLSv1_2_client_method) then
    Result := frxDTLSv1_2_client_method();
end;

function DTLSv1_client_method: Pointer;
begin
  Result := nil;
  if Assigned(frxDTLSv1_client_method) then
    Result := frxDTLSv1_client_method();
end;

function SSL_CTX_new(meth: Pointer): Pointer;
begin
  Result := nil;
  if Assigned(frxSSL_CTX_new) then
    Result := frxSSL_CTX_new(meth);
end;

procedure SSL_CTX_free(ctx: Pointer);
begin
  if Assigned(frxSSL_CTX_free) then
    frxSSL_CTX_free(ctx);
end;

function SSL_new(ctx: Pointer): Pointer;
begin
  Result := nil;
  if Assigned(frxSSL_new) then
    Result := frxSSL_new(ctx);
end;

function SSL_set_fd(s: Pointer; fd: TSocket): Integer;
begin
  Result := 0;
  if Assigned(frxSSL_set_fd) then
    Result := frxSSL_set_fd(s, fd);
end;

function SSL_connect(ssl: Pointer): Integer;
begin
  Result := 0;
  if Assigned(frxSSL_connect) then
    Result := frxSSL_connect(ssl);
end;

function SSL_do_handshake(ssl: Pointer): Integer;
begin
  Result := 0;
  if Assigned(frxSSL_do_handshake) then
    Result := frxSSL_do_handshake(ssl);
end;

procedure SSL_free(ssl: Pointer);
begin
  if Assigned(frxSSL_free) then
    frxSSL_free(ssl);
end;

function SSL_read(ssl: Pointer; buf: PAnsiChar; num: Integer): Integer;
begin
  Result := 0;
  if Assigned(frxSSL_read) then
    Result := frxSSL_read(ssl, buf, num);
end;

function SSL_write(ssl: Pointer; buf: PAnsiChar; num: Integer): Integer;
begin
  Result := 0;
  if Assigned(frxSSL_write) then
    Result := frxSSL_write(ssl, buf, num);
end;

function SSL_get_error(ssl: Pointer; ret: Integer): Integer;
begin
  Result := 0;
  if Assigned(frxSSL_get_error) then
    Result := frxSSL_get_error(ssl, ret);
end;

function SSL_CTX_ctrl(ctx: Pointer; cmd: Integer; larg: Integer; parg: Pointer): Longint;
begin
  Result := 0;
  if Assigned(frxSSL_CTX_ctrl) then
    Result := frxSSL_CTX_ctrl(ctx, cmd, larg, parg);
end;

function SSL_CTX_set_default_verify_paths(ctx: Pointer): Longint;
begin
  Result := 0;
  if Assigned(frxSSL_CTX_set_default_verify_paths) then
    Result := frxSSL_CTX_set_default_verify_paths(ctx);
end;

function SSL_CTX_set_cipher_list(ctx: Pointer; const str: PAnsiChar): Longint;
begin
  Result := 0;
  if Assigned(frxSSL_CTX_set_cipher_list) then
    Result := frxSSL_CTX_set_cipher_list(ctx, str);
end;

function SSL_get_fd(const SSL: Pointer): Longint;
begin
  Result := 0;
  if Assigned(frxSSL_get_fd) then
    Result := frxSSL_get_fd(SSL);
end;

function SSL_clear(SSL: Pointer): Longint;
begin
  Result := 0;
  if Assigned(frxSSL_clear) then
    Result := frxSSL_clear(SSL);
end;

{ TfrxSSLIOHandler }

procedure TfrxSSLIOHandler.BindSocket(Socket: TCustomWinSocket);
var
  Ret: Integer;
begin
  Ret := SSL_set_fd(FSSL, Socket.SocketHandle);
  if Ret <= 0 then
    FLastError := SSL_get_error(FSSL, Ret);
end;

procedure TfrxSSLIOHandler.Connect;
var
  Ret: Integer;
begin
  FLastError := 0;
  Ret := SSL_connect(FSSL);
  if Ret <= 0 then
     FLastError := SSL_get_error(FSSL, Ret)
  else
    FConnected := True;
end;

constructor TfrxSSLIOHandler.Create;
begin
  inherited;
  SecurityProtocol := spTLSv1_1;
end;

procedure TfrxSSLIOHandler.Disconnect;
begin
  if Assigned(FSSL) then
    SSL_clear(FSSL);
  FConnected := False;
  FHandshakeDone := False;
  if FSSL <> nil then
    SSL_free(FSSL);
  FSSL := nil;
  if FCtx <> nil then
    SSL_CTX_free(FCtx);
  FCtx := nil;
end;

procedure TfrxSSLIOHandler.DoHandshake;
var
  Ret: Integer;
begin
  if not FConnected or FHandshakeDone then Exit;
  FLastError := 0;
  Ret := SSL_do_handshake(FSSL);
  if Ret <= 0 then
  begin
     FLastError := SSL_get_error(FSSL, Ret);
     Exit;
  end;
  FHandshakeDone := True;
end;

function TfrxSSLIOHandler.DoRead(var Buffer; Count: Integer): Integer;
begin
  Result := SSL_read(FSSL, PAnsiChar(@Buffer), Count);
end;

function TfrxSSLIOHandler.DoWrite(var Buffer; Count: Integer): Integer;
begin
  Result := SSL_write(FSSL, PAnsiChar(@Buffer), Count);
end;

function TfrxSSLIOHandler.GetErrorCode(ErrCode: Integer): Integer;
begin
  Result := SSL_get_error(FSSL, ErrCode);
end;

function TfrxSSLIOHandler.GetLastError: String;
begin
  Result := '';
  case FLastError   of
     SSL_ERROR_SSL: Result := 'Internal error in OpenSSL library.';
     SSL_ERROR_SYSCALL: Result := 'Internal I/O error in OpenSSL library.';
     SSL_ERROR_ZERO_RETURN: Result := 'Zero bytes returned.';
  end;
end;

function TfrxSSLIOHandler.InitializeHandler: Boolean;
begin
  Result := False;
  SSL_library_init();
  //FMethod := TLSv1_1_client_method();
  case SecurityProtocol of
    spSSLv2: FMethod := SSLv2_client_method();
    spSSLv3: FMethod := SSLv3_client_method();
    spSSLv23: FMethod := SSLv23_client_method();
    spTLSv1: FMethod := TLSv1_client_method();
    spTLSv1_1: FMethod := TLSv1_1_client_method();
    spTLSv1_2: FMethod := TLSv1_2_client_method();
  end;
  if FMethod <> nil then
  begin
    FCTX := SSL_CTX_new(FMethod);
    if FCTX <> nil then
    begin
      FLastError := SSL_CTX_ctrl(FCTX, 33, 4, nil);
      FLastError := SSL_CTX_set_default_verify_paths(FCTX);
      FLastError := SSL_CTX_set_cipher_list(FCtx, PAnsiChar(SSL_DEFAULT_CIPHER_LIST));
      if FLastError < 0 then
        FLastError := SSL_get_error(FSSL, FLastError);
      FSSL := SSL_new(FCTX);
      if FSSL <> nil then
      begin
        Result := True;
        FLastError := 0;
      end;
    end;
  end;
end;

function TfrxSSLIOHandler.ProcessIO: Boolean;
var
  FDSet: TFDSet;
  TimeVal: TTimeVal;
  Sock: TSocket;
begin
  Result := (FLastError in [SSL_ERROR_NONE, SSL_ERROR_WANT_READ, SSL_ERROR_WANT_WRITE, SSL_ERROR_ZERO_RETURN]);
  if not Result then
    raise Exception.Create(GetLastError);
  case FLastError of
    SSL_ERROR_WANT_WRITE, SSL_ERROR_WANT_READ:
    begin
      Sock := SSL_get_fd(FSSL);
      FD_ZERO(FDSet);
      FD_SET(Sock, FDSet);
      TimeVal.tv_sec := 0;
      TimeVal.tv_usec := 500;
      if FLastError = SSL_ERROR_WANT_READ then
        select(sock + 1, @FDSet, nil, nil, @TimeVal)
      else
        select(sock + 1, nil, @FDSet, nil, @TimeVal);

      FLastError := 0;
      Exit;
    end;
    SSL_ERROR_NONE: Exit;
  end;
end;

function TfrxSSLIOHandler.TryConnect: Boolean;
begin
  if not FConnected then
    Connect;
  if not FHandshakeDone then
    DoHandshake;
  Result := FHandshakeDone and FConnected;
  if not Result then
    ProcessIO;
end;

initialization
 frxSSLLibrary := LoadLibrary(SSL_LIB_NAME);
 if frxSSLLibrary <> 0 then
 begin
   InitializeFunctions(frxSSLLibrary);
   frxDefaultSocketIOHandlerClass := TfrxSSLIOHandler;
 end;

finalization
 if frxSSLLibrary <> 0 then
   frxDefaultSocketIOHandlerClass := nil;
  frxSSL_library_init := nil;
  frxSSLv2_client_method := nil;
  frxSSLv23_client_method := nil;
  frxTLSv1_1_client_method := nil;
  frxTLSv1_2_client_method := nil;
  frxTLSv1_client_method := nil;
  frxSSLv3_client_method := nil;
  frxDTLS_client_method := nil;
  frxDTLSv1_2_client_method := nil;
  frxDTLSv1_client_method := nil;
  frxSSL_CTX_new := nil;
  frxSSL_CTX_free := nil;
  frxSSL_new := nil;
  frxSSL_set_fd := nil;
  frxSSL_connect := nil;
  frxSSL_do_handshake := nil;
  frxSSL_free := nil;
  frxSSL_read := nil;
  frxSSL_write := nil;
  frxSSL_get_error := nil;
  frxSSL_CTX_ctrl := nil;
  frxSSL_CTX_set_default_verify_paths := nil;
  frxSSL_CTX_set_cipher_list := nil;
  frxSSL_get_fd := nil;
  frxSSL_clear := nil;

end.
