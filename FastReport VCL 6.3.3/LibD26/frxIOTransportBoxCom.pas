
{******************************************}
{                                          }
{              FastReport v6.0             }
{            BoxCom Save Filter            }
{                                          }
{            Copyright (c) 2017            }
{             by Oleg Adibekov,            }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxIOTransportBoxCom;

interface

{$I frx.inc}

uses
  Classes, frxIOTransportHelpers, frxBaseTransportConnection,
  frxIOTransportBoxComBase;

type
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxBoxComIOTransport = class(TfrxBaseBoxComIOTransport)
  protected
    function GetListFolder: String; override;
    function GetListFolderContinue(Offset: Integer): String; override;
    procedure CreateFolder(Dir: String); override;
    procedure DeleteFile(Id: String); override;
    procedure DeleteFolder(Id: String); override;

    procedure Upload(const Source: TStream; DestFileName: String = '');
      override;
  public
    function GetAccessToken(AuthorizationCode, ClientId, ClientSecret: String; var ErrorMsg: String): String; override;
    function GetConnectorInstance: TfrxBaseTransportConnectionClass; override;
    procedure TestToken(const URL: String; var sToken: String; bUsePOST: Boolean = False); override;
  end;

implementation

uses
  SysUtils, frxJSON, frxTransportHTTP;

{ TfrxBoxComIOTransport }

procedure TfrxBoxComIOTransport.CreateFolder(Dir: String);
var
  Stream: TStringStream;
  tHTTP: TfrxTransportHTTP;
begin
  tHTTP := TfrxTransportHTTP(FHTTP);
  tHTTP.HTTPRequest.ContentType := 'application/json';
  tHTTP.HTTPRequest.Encoding := 'UTF-8';
  Stream := TStringStream.Create(Format('{"name": "%s", "parent": {"id": "%s"}}',
    {$IfDef Delphi12}[Dir, FDirStack.Top]), TEncoding.UTF8);
    {$Else}          [JsonEncode(Dir), FDirStack.Top]));
    {$EndIf}

  try
    tHTTP.Post(frx_BoxCom_CreateDir_URL, Stream);
  finally
    Stream.Free;
  end;
end;

procedure TfrxBoxComIOTransport.DeleteFile(Id: String);
begin
  TfrxTransportHTTP(FHTTP).Delete(Format(frx_BoxCom_DelFile_URL, [Id]));
end;

procedure TfrxBoxComIOTransport.DeleteFolder(Id: String);
begin
  TfrxTransportHTTP(FHTTP).Delete(Format(frx_BoxCom_DelDir_URL, [Id]));
end;

function TfrxBoxComIOTransport.GetAccessToken(
  AuthorizationCode, ClientId, ClientSecret: String; var ErrorMsg: String): String;
var
  tHTTP: TfrxTransportHTTP;
  Source: TStringStream;
  Res: String;
  frxJSON: TfrxJSON;
begin
  Source := TStringStream.Create('');
  Source.WriteString('grant_type=authorization_code&');
  Source.WriteString('code=' + AuthorizationCode + '&');
  Source.WriteString('client_id=' + ClientId + '&');
  Source.WriteString('client_secret=' + ClientSecret);

  try
    tHTTP := TfrxTransportHTTP.Create(nil);
    tHTTP.HTTPRequest.Encoding := '';
    tHTTP.HTTPRequest.DefAcceptTypes := htcDefaultXML;
    tHTTP.HTTPRequest.ContentType := 'application/x-www-form-urlencoded';
    try
      Res := tHTTP.Post(frx_BoxCom_GetToken_URL, Source);
      frxJSON := TfrxJSON.Create(Res);
      try
        if      frxJSON.IsNameExists('access_token') then
          Result := frxJSON.ValueByName('access_token')
        else if frxJSON.IsNameValueExists('type', 'error') then
          ErrorMsg := 'Error: ' + frxJSON.ValueByName('status') + '; ' +
            frxJSON.ValueByName('message');
      finally
        frxJSON.Free;
      end;
    finally
      tHTTP.Free;
    end;
  finally
    Source.Free;
  end;
end;

function TfrxBoxComIOTransport.GetConnectorInstance: TfrxBaseTransportConnectionClass;
begin
  Result := TfrxTransportHTTP;
end;

function TfrxBoxComIOTransport.GetListFolder: String;
begin
  Result := TfrxTransportHTTP(FHTTP).Get(Format(frx_BoxCom_ListDir_URL, [FDirStack.Top]));
end;

function TfrxBoxComIOTransport.GetListFolderContinue(Offset: Integer): String;
begin
  Result := TfrxTransportHTTP(FHTTP).Get(Format(frx_BoxCom_ListDirContinue_URL, [FDirStack.Top, Offset]));
end;

procedure TfrxBoxComIOTransport.TestToken(const URL: String; var sToken: String;
  bUsePOST: Boolean);
begin
  frxTestToken(URL, sToken, bUsePOST);
end;

procedure TfrxBoxComIOTransport.Upload(const Source: TStream;
  DestFileName: String);
const
  Boundary = '560310243403';
var
  MemoryStream: TMemoryStream;
  tHTTP: TfrxTransportHTTP;

  procedure Put(str: AnsiString);
  begin
    MemoryStream.Write(str[1], Length(str));
  end;

  procedure PutLn(str: AnsiString = '');
  begin
    Put(str + #13#10);
  end;
begin
  inherited;
  tHTTP := TfrxTransportHTTP(FHTTP);
  tHTTP.HTTPRequest.ContentType :=
  AnsiString(Format('multipart/related; boundary="%s"', [Boundary]));
  tHTTP.HTTPRequest.Encoding:='';
  MemoryStream := TMemoryStream.Create;
  try
    PutLn('--' + Boundary);
    PutLn('Content-ID: <metadata>');
    PutLn('Content-Type: application/json');
    PutLn;

    PutLn(SureAnsi(Format('{"name": "%s", "parent": {"id": "%s"}}',
             [SureUTF8(DestFileName), FDirStack.Top])));
    PutLn('--' + Boundary);
    PutLn('Content-ID: <content>');
    PutLn('Content-Type: application/octet-stream');
    PutLn;

    MemoryStream.CopyFrom(Source, Source.Size);

    PutLn;
    Put('--' + Boundary + '--');

    tHTTP.Post(frx_BoxCom_Upload_URL, MemoryStream);
  finally
    MemoryStream.Free;
  end;
end;

end.
