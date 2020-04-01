
{******************************************}
{                                          }
{              FastReport v6.0             }
{           OneDrive Save Filter           }
{                                          }
{          Copyright (c) 2016-2017         }
{             by Oleg Adibekov,            }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxIOTransportOneDrive;

interface

{$I frx.inc}

uses
  Classes, frxIOTransportHelpers, frxBaseTransportConnection,
  frxIOTransportOneDriveBase;

type
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxOneDriveIOTransport = class(TfrxBaseOneDriveIOTransport)
  protected
    function GetListFolder: String; override;
    function GetListFolderContinue(NextLink: String): String; override;
    procedure CreateFolder(Dir: String); override;
    procedure DeleteFileOrFolder(Name: String); override;
    procedure Upload(const Source: TStream; DestFileName: String = '');
      override;
    procedure Download(const SourceFileName: String; const Source: TStream); override;
  public
    function GetConnectorInstance: TfrxBaseTransportConnectionClass; override;
    procedure TestToken(const URL: String; var sToken: String; bUsePOST: Boolean = False); override;
  end;

implementation

uses
  SysUtils, frxJSON, frxTransportHTTP, frxServerUtils;

{ TfrxOneDriveIOTransport }

procedure TfrxOneDriveIOTransport.CreateFolder(Dir: String);
var
  Stream: TStringStream;
  tHTTP: TfrxTransportHTTP;
begin
  tHTTP := TfrxTransportHTTP(FHTTP);
  tHTTP.HTTPRequest.ContentType := 'application/json';
  tHTTP.HTTPRequest.Encoding :='UTF-8';

  Stream := TStringStream.Create(Format('{ "name": "%s", "folder": { } }',
    {$IfDef Delphi12}[(Dir)]), TEncoding.UTF8);
    {$Else}          [JsonEncode(Dir)]));
    {$EndIf}

  try
    tHTTP.Post(AnsiString(Format(AnsiString(frx_OneD_CreateDir_URL), [Str2HTML(UTF8Encode(RemoteDir))])), Stream);
  finally
    Stream.Free;
  end;
end;

procedure TfrxOneDriveIOTransport.DeleteFileOrFolder(Name: String);
begin
  TfrxTransportHTTP(FHTTP).Delete(AnsiString(UTF8Encode(Format(frx_OneD_DEL_URL, [Str2HTML(SureUTF8(RemoteDir + Name))]))));
end;

procedure TfrxOneDriveIOTransport.Download(const SourceFileName: String;
  const Source: TStream);
var
  DlLink: String;
  tHTTP: TfrxTransportHTTP;
begin
  inherited;
  DlLink := '';
  tHTTP := TfrxTransportHTTP(FHTTP);
  tHTTP.HTTPRequest.ContentType := 'application/octet-stream';
  try
    tHTTP.Get(AnsiString(Format(frx_OneD_DL_URL, [SureUTF8(RemoteDir), Str2HTML(SureUTF8(SourceFileName))])));
  finally
    Source.Size := 0;
    if tHTTP.ServerFields.AnswerCode  = 302 then
      DlLink := tHTTP.ServerFields.Location;
    if DlLink <> '' then
      tHTTP.Get(DlLink, Source);
  end;
end;

function TfrxOneDriveIOTransport.GetConnectorInstance: TfrxBaseTransportConnectionClass;
begin
  Result := TfrxTransportHTTP;
end;

function TfrxOneDriveIOTransport.GetListFolder: String;
begin
  Result := TfrxTransportHTTP(FHTTP).Get(Format(frx_OneD_LF_URL, [Str2HTML(UTF8Encode((RemoteDir)))]));
end;

function TfrxOneDriveIOTransport.GetListFolderContinue(NextLink: String): String;
begin
  Result := TfrxTransportHTTP(FHTTP).Get(NextLink);
end;

procedure TfrxOneDriveIOTransport.TestToken(const URL: String;
  var sToken: String; bUsePOST: Boolean);
begin
  frxTestToken(URL, sToken, bUsePOST);
end;

procedure TfrxOneDriveIOTransport.Upload(const Source: TStream;
  DestFileName: String);
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
    AnsiString(Format('multipart/related; boundary="%s"', [frx_OneD_Boundary]));
  tHTTP.HTTPRequest.Encoding:='';
  MemoryStream := TMemoryStream.Create;

  PutLn('--' + frx_OneD_Boundary);
  PutLn('Content-ID: <metadata>');
  PutLn('Content-Type: application/json');
  PutLn;

  PutLn(SureAnsi(Format(
    '{ "name": "%s", "file": {}, "@content.sourceUrl": "cid:content" }',
    [SureUTF8(DestFileName)])));
  PutLn('--' + frx_OneD_Boundary);
  PutLn('Content-ID: <content>');
  PutLn('Content-Type: application/octet-stream');
  PutLn;
  MemoryStream.CopyFrom(Source, Source.Size);

  PutLn;
  Put('--' + frx_OneD_Boundary + '--');

  try
    tHTTP.Post(AnsiString(Format(frx_OneD_UP_URL, [Str2HTML(SureUTF8(RemoteDir))])), MemoryStream);
  finally
    MemoryStream.Free;
  end;
end;

(* Work Ok with Indy 10 only
procedure TfrxOneDriveIOTransport.Upload(const SourceFileName: String;
  DestFileName: String = '');
const
  URL = 'https://api.onedrive.com/v1.0/drive/root:%s/%s:/content';
var
  Source: TFileStream;
begin
  FHTTP.Request.ContentType := 'application/octet-stream';
  {$IfNDef Indy9} FHTTP.Request.CharSet:=''; {$EndIf}

  Source := TFileStream.Create(SourceFileName, fmOpenRead);
  If DestFileName = '' then
    DestFileName := ExtractFileName(SourceFileName);

  try
    FHTTP.Put(TIdURI.URLEncode(Format(URL, [SureUTF8(RemoteDir), SureUTF8(DestFileName)])),
              Source);
  finally
    Source.Free;
  end;
end;
*)

end.
