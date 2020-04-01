
{******************************************}
{                                          }
{             FastReport v5.0              }
{              E-mail export               }
{                                          }
{         Copyright (c) 1998-2014          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxIOTransportIndyMail;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, frxClass, IniFiles, ComCtrls, frxIOTransportMail, frxProgress,
  IdSMTP, IdMessage, IdComponent,
  IdSSLOpenSSL,
{$IFNDEF INDY9}
  IdExplicitTLSClientServerBase,
  IdAttachmentFile,
{$ENDIF}
{$IFDEF Delphi6}
  Variants
{$ENDIF};

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxMailIOTransportIndy = class(TfrxMailIOTransport)
  private
    FProgress: TfrxProgress;
  protected
    function DoMailSMTP(const Server: String; const Port: Integer;const
      UserField, PasswordField: String; FromField, ToField, SubjectField, CompanyField,
      TextField: WideString; FileNames: TStringList; Timeout: integer = 60;
      ConfurmReading: boolean = false; MailCc: WideString = ''; MailBcc: WideString = ''): String; override;
    procedure ConnectionWork(Sender: TObject; AWorkMode: TWorkMode;
      {$IfDef INDYPARAM_INT}{$IfDef INDY10_2005} AWorkCount: Integer
      {$ELSE}
                           const AWorkCount: Integer
      {$ENDIF}
      {$Else}              AWorkCount: Int64 {$EndIf});
  public
    class function GetDescription: String; override;
  end;


implementation

uses frxDsgnIntf, frxFileUtils, frxNetUtils, frxUtils,
     frxUnicodeUtils, frxRes, Registry, IdTCPConnection,
     frxIOSendMAPI, ComObj, StrUtils;

{ TfrxMailIOTransportIndy }

procedure TfrxMailIOTransportIndy.ConnectionWork(Sender: TObject; AWorkMode: TWorkMode;
      {$IfDef INDYPARAM_INT}{$IfDef INDY10_2005} AWorkCount: Integer
      {$ELSE}
                           const AWorkCount: Integer
      {$EndIf}
      {$Else}              AWorkCount: Int64 {$EndIf});
begin
  if not Assigned(FProgress) then Exit;  
  if FProgress.Terminated then
  begin
    if Sender is TIdSMTP then
    begin
      TIdSMTP(Sender).OnWork := nil;
      TIdSMTP(Sender).Disconnect;
    end;
  end
  else if AWorkMode = wmWrite then
    FProgress.Position := AWorkCount;
end;

function TfrxMailIOTransportIndy.DoMailSMTP(const Server: String;
  const Port: Integer; const UserField, PasswordField: String; FromField,
  ToField, SubjectField, CompanyField, TextField: WideString;
  FileNames: TStringList; Timeout: integer; ConfurmReading: boolean; MailCc,
  MailBcc: WideString): String;
var
  mailer : TIdSMTP;
  EMsg: TIdMessage;
{$IFDEF Indy9}
  sslIOHandler: TIdSSLIOHandlerSocket;
{$ELSE}
  sslIOHandler: TIdSSLIOHandlerSocketOpenSSL;
{$ENDIF}
  i, j, SizeOfFiles: Integer;
  s: String;
  FilesList: TStringList;
begin
  Result := '';
  mailer := TIdSMTP.Create(nil);
  mailer.OnWork := ConnectionWork;
  FProgress := TfrxProgress.Create(nil);
  FilesList := TStringList.Create;
  try
{$IFNDEF Indy9}
{$IFNDEF INDY10_2005}
    mailer.AuthType := satDefault; // satSASL; //
{$ENDIF}
{$ENDIF}
    mailer.Host := Server;;
    mailer.UserName := UserField;
    mailer.Password := PasswordField;
{$IFDEF Indy9}
      sslIOHandler := TIdSSLIOHandlerSocket.Create(mailer);
      sslIOHandler.SSLOptions.Method := sslvTLSv1;
{$ELSE}
      sslIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(mailer);
      sslIOHandler.SSLOptions.Method := sslvSSLv23;
{$ENDIF}
    try
      mailer.IOHandler := sslIOHandler;
{$IFNDEF Indy9}
      mailer.UseTLS := utUseExplicitTLS;
{$ENDIF}
      EMsg := TIdMessage.Create(mailer);
      try
        EMsg.ContentTransferEncoding := '8bit';
        EMsg.From.Address := FromField;
        EMsg.Organization := CompanyField;

        i := 1;
        j := 1;
        while i <= Length(ToField) do
        begin
          if ToField[i] = ',' then
          begin
            s := Copy(ToField, j, i - j);
            EMsg.Recipients.Add.Text := s;
            j := i + 1;
          end;
          Inc(i);
        end;
        s := Copy(ToField, j, i - j);
        EMsg.Recipients.Add.Text := s;

        EMsg.Subject := SubjectField;
        EMsg.CharSet := 'UTF-8';
        EMsg.Body.Append(StringReplace(TextField, '\n', #13#10,
          [rfReplaceAll]));
        SizeOfFiles := 0;
        for i := 0 to FileNames.Count - 1 do
          Inc(SizeOfFiles, GetFileSize(FileNames.Names[i]));

        FProgress.Position := 0;
        FProgress.Execute(SizeOfFiles, 'Sending mail',
        { Canceled: } False, { Progress: } True);

{$IFDEF Indy9}
        for i := 0 to FileNames.Count - 1 do
          TIdAttachment.Create(EMsg.MessageParts, FileNames.Names[i]);
{$ELSE}
        for i := 0 to FileNames.Count - 1 do
          TIdAttachmentFile.Create(EMsg.MessageParts, FileNames.Names[i]);
{$ENDIF}

        EMsg.AfterConstruction;
        mailer.Connect;
        if mailer.Connected then
          mailer.Send(EMsg);
        mailer.Disconnect;
      finally
        EMsg.Free;
      end;
    finally
      sslIOHandler.Free;
    end;
  finally
    mailer.Free;
    FreeAndNil(FProgress);
    FilesList.Free;
  end;

{
    except
      on E: Exception do
        case Report.EngineOptions.NewSilentMode of
          simSilent:        Report.Errors.Add(E.Message);
          simMessageBoxes:  frxErrorMsg(E.Message);
          simReThrow: raise Exception.Create(E.Message);
        end;
    end;
}
end;

class function TfrxMailIOTransportIndy.GetDescription: String;
begin
  Result := frxResources.Get('Email Transport(Indy)');
end;

end.
