
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

unit frxExportMail;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, frxClass, IniFiles, ComCtrls,
{$IFDEF USE_INDY}
  IdSMTP, IdMessage,
  IdSSLOpenSSL, IdExplicitTLSClientServerBase, IdAttachmentFile
{$ELSE}
  frxSMTP
{$ENDIF}

{$IFDEF Delphi6}, Variants {$ENDIF};

type

  TMailTransport = (SMTP, MAPI, MSOutlook);
  TSMTPStartCommand = (EHLO, HELO);
  TfrxOnSendMailEvent = function (const Server: String;
    const Port: Integer;const UserField, PasswordField: String; FromField,
    ToField, SubjectField, CompanyField, TextField: WideString;
    FileNames: TStringList; Timeout: Integer; ConfurmReading: boolean; MailCc, MailBcc: WideString): String of object;

  TfrxOnAfterSendMailEvent = procedure (const MailResult: String) of object;

  TfrxMailExportDialog = class(TForm)
    OkB: TButton;
    CancelB: TButton;
    PageControl1: TPageControl;
    ExportSheet: TTabSheet;
    MessageGroup: TGroupBox;
    AddressLB: TLabel;
    SubjectLB: TLabel;
    MessageLB: TLabel;
    MessageM: TMemo;
    AttachGroup: TGroupBox;
    ExportsCombo: TComboBox;
    FormatLB: TLabel;
    SettingCB: TCheckBox;
    AccountSheet: TTabSheet;
    MailGroup: TGroupBox;
    RememberCB: TCheckBox;
    AccountGroup: TGroupBox;
    FromNameE: TEdit;
    FromNameLB: TLabel;
    FromAddrE: TEdit;
    FromAddrLB: TLabel;
    OrgLB: TLabel;
    OrgE: TEdit;
    SignatureLB: TLabel;
    SignatureM: TMemo;
    HostLB: TLabel;
    HostE: TEdit;
    PortE: TEdit;
    PortLB: TLabel;
    LoginLB: TLabel;
    LoginE: TEdit;
    PasswordE: TEdit;
    PasswordLB: TLabel;
    SignBuildBtn: TButton;
    AddressE: TComboBox;
    SubjectE: TComboBox;
    ReqLB: TLabel;
    TimeoutLB: TLabel;
    TimeoutE: TEdit;
    ReadingCB: TCheckBox;
    Radio_SMTP: TRadioButton;
    Radio_MAPI: TRadioButton;
    Radio_Outlook: TRadioButton;
    MailTransportLB: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SignBuildBtnClick(Sender: TObject);
    procedure OkBClick(Sender: TObject);
    procedure PortEKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PageControl1Change(Sender: TObject);
  end;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxMailExport = class(TfrxCustomExportFilter)
  private
    FExportFilter: TfrxCustomExportFilter;
    FAddress: String;
    FSubject: String;
    FMessage: TStrings;
    FShowExportDialog: Boolean;
    FOldSlaveStatus: Boolean;
    FFromName: String;
    FFromMail: String;
    FFromCompany: String;
    FSignature: TStrings;
    FSmtpHost: String;
    FSmtpPort: Integer;
    FLogin: String;
    FPassword: String;
    FUseIniFile: Boolean;
    FLogFile: String;
    FTimeOut: Integer;
    FConfurmReading: boolean;
    FUseMAPI: TMailTransport;
    FSMTPStartCommand: TSMTPStartCommand;
    FOnSendMail: TfrxOnSendMailEvent;
    FOnAfterSendMail: TfrxOnAfterSendMailEvent;
    FMailCc: String;
    FMailBcc: String;
    FMAPISendFlag: Integer;
    procedure SetMessage(const Value: TStrings);
    procedure SetSignature(const Value: TStrings);
  protected
    property DefaultPath;
    property Stream;
    property CurPage;
    property PageNumbers;
    property FileName;
    property UseFileCache;
    property ExportNotPrintable;
  public
    constructor Create(AOwner: TComponent); override;
    function CreateDefaultIOTransport: TfrxCustomIOTransport; override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    function ShowModal: TModalResult; override;
    function Start: Boolean; override;
    function Mail(const Server: String; const Port: Integer;const
      UserField, PasswordField: String; FromField, ToField, SubjectField, CompanyField,
      TextField: WideString; FileNames: TStringList; Timeout: integer = 60;
      ConfurmReading: boolean = false; MailCc: WideString = ''; MailBcc: WideString = ''): String;
    procedure ExportObject(Obj: TfrxComponent); override;
    property ExportFilter: TfrxCustomExportFilter read FExportFilter write FExportFilter;
    property SMTPStartCommand: TSMTPStartCommand read FSMTPStartCommand write FSMTPStartCommand;
  published
    property Address: String read FAddress write FAddress;
    property Subject: String read FSubject write FSubject;
    property Lines: TStrings read FMessage write SetMessage;
    property ShowExportDialog: Boolean read FShowExportDialog write FShowExportDialog;
    property FromMail: String read FFromMail write FFromMail;
    property FromName: String read FFromName write FFromName;
    property FromCompany: String read FFromCompany write FFromCompany;
    property Signature: TStrings read FSignature write SetSignature;
    property SmtpHost: String read FSmtpHost write FSmtpHost;
    property SmtpPort: Integer read FSmtpPort write FSmtpPort;
    property Login: String read FLogin write Flogin;
    property Password: String read FPassword write FPassword;
    property UseIniFile: Boolean read FUseIniFile write FUseIniFile;
    property LogFile: String read FLogFile write FLogFile;
    property TimeOut: integer read FTimeOut write FTimeOut;
    property ConfurmReading: boolean read FConfurmReading write FConfurmReading;
    property OnSendMail: TfrxOnSendMailEvent read FOnSendMail write FOnSendMail;
    property OnAfterSendMail: TfrxOnAfterSendMailEvent read FOnAfterSendMail write FOnAfterSendMail;
    property UseMAPI: TMailTransport read FUseMAPI write FUseMAPI;
    property MailCc: String read FMailCc write FMailCc;
    property MailBcc: String read FMailBcc write FMailBcc;
    property MAPISendFlag: Integer read FMAPISendFlag write FMAPISendFlag;
  end;


implementation

uses frxDsgnIntf, frxFileUtils, frxNetUtils, frxUtils,
     frxUnicodeUtils, frxRes, frxrcExports, Registry,
     frxSendMAPI, ComObj;

{$R *.dfm}

const
  EMAIL_EXPORT_SECTION = 'EmailExport';

{ TfrxMailExport }

constructor TfrxMailExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAddress := '';
  FSubject := '';
  FMessage := TStringList.Create;
  FShowExportDialog := True;
  FFromName := '';
  FFromMail := '';
  FFromCompany := '';
  FSignature := TStringList.Create;
  FSmtpHost := '';
  FSmtpPort := 25;
  FLogin := '';
  FPassword := '';
  FUseIniFile := True;
  FTimeOut := 60;
  FConfurmReading := false;
  FUseMAPI := SMTP;
  FSMTPStartCommand := HELO;
  FMailCc := '';
  FMailBcc := '';
  FMAPISendFlag := 0;
end;

function TfrxMailExport.CreateDefaultIOTransport: TfrxCustomIOTransport;
begin
  FDefaultIOTransport := TfrxCustomIOTransport(frxDefaultIOTransportClass.NewInstance);
  FDefaultIOTransport.CreateNoRegister;
  Result := FDefaultIOTransport;
end;

destructor TfrxMailExport.Destroy;
begin
  FMessage.Free;
  FSignature.Free;
  inherited;
end;

class function TfrxMailExport.GetDescription: String;
begin
  Result := frxResources.Get('EmailExport');
end;

function TfrxMailExport.ShowModal: TModalResult;
var
  i: Integer;
  ini: TCustomIniFile;
  Section: String;
begin
  with TfrxMailExportDialog.Create(nil) do
  begin
    try
      case FUseMapi of
        SMTP: Radio_Smtp.Checked  := True;
        MAPI: Radio_MAPI.Checked  := True;
        else Radio_Outlook.Checked     := True
      end;
      AttachGroup.Visible := not SlaveExport;
      SendMessage(GetWindow(ExportsCombo.Handle,GW_CHILD), EM_SETREADONLY, 1, 0);
      for i := 0 to frxExportFilters.Count - 1 do
      begin
        if (TfrxCustomExportFilter(frxExportFilters[i].Filter).ClassName <> 'TfrxDotMatrixExport')
          and (TfrxCustomExportFilter(frxExportFilters[i].Filter).ClassName <> 'TfrxMailExport') then
        ExportsCombo.Items.AddObject(TfrxCustomExportFilter(frxExportFilters[i].Filter).GetDescription, TfrxCustomExportFilter(frxExportFilters[i].Filter));
      end;
      ExportsCombo.Items.AddObject(frxResources.Get('FastReportFile'), nil);
      SettingCB.Checked := ShowExportDialog;
      if Radio_Smtp.Checked then FUseMapi := SMTP else
      if Radio_MAPI.Checked then FUseMapi := MAPI else
      if Radio_Outlook.Checked then FUseMapi := MSOutlook;
//      CheckBox1.Checked := FUseMAPI;
      if Assigned(Report) then
        ini := Report.GetIniFile
      else
        ini := TRegistryIniFile.Create('\Software\Fast Reports');
      try
        if not FUseIniFile then
          RememberCB.Visible := False;

        Section := EMAIL_EXPORT_SECTION + '.Properties';

        if ini.SectionExists(Section) and FUseIniFile then
        begin
          FromNameE.Text := ini.ReadString(Section, 'FromName', '');
          FromAddrE.Text := ini.ReadString(Section, 'FromAddress', '');
          OrgE.Text := ini.ReadString(Section, 'Organization', '');
          SignatureM.Lines.Text := ini.ReadString(Section, 'Signature', '');
          HostE.Text := ini.ReadString(Section, 'SmtpHost', '');
          PortE.Text := ini.ReadString(Section, 'SmtpPort', '25');
          LoginE.Text := String(Base64Decode(AnsiString(ini.ReadString(Section, 'Login', ''))));
          PasswordE.Text := String(Base64Decode(AnsiString(ini.ReadString(Section, 'Password', ''))));
          ExportsCombo.ItemIndex := ini.ReadInteger(Section, 'LastUsedExport', 0);
          ini.ReadSection(EMAIL_EXPORT_SECTION + '.RecentAddresses' , AddressE.Items);
          ini.ReadSection(EMAIL_EXPORT_SECTION + '.RecentSubjects' , SubjectE.Items);
          TimeoutE.Text := ini.ReadString(Section, 'Timeout', '60');
        end
        else begin
          FromNameE.Text := FFromName;
          FromAddrE.Text := FFromMail;
          OrgE.Text := FFromCompany;
          SignatureM.Lines.Text := FSignature.Text;
          HostE.Text := FSmtpHost;
          PortE.Text := IntToStr(FSmtpPort);
          LoginE.Text := FLogin;
          PasswordE.Text := FPassword;
          TimeoutE.Text := IntToStr(FTimeout);
          if not Assigned(FExportFilter) then
            ExportsCombo.ItemIndex := 0
          else
            ExportsCombo.ItemIndex := ExportsCombo.Items.IndexOfObject(FExportFilter);
        end;

        AddressE.Text := FAddress;
        SubjectE.Text := FSubject;
        MessageM.Text := FMessage.Text;
        ReadingCB.Checked := FConfurmReading;

        Result := ShowModal;

        if Result = mrOk then
        begin
          FAddress := AddressE.Text;
          FFromName := FromNameE.Text;
          FFromMail := FromAddrE.Text;
          FFromCompany := OrgE.Text;
          FSignature.Text := SignatureM.Lines.Text;
          FSmtpHost := HostE.Text;
          FSmtpPort := StrToInt(PortE.Text);
          FLogin := LoginE.Text;
          FPassword := PasswordE.Text;
          FSubject := SubjectE.Text;
          FMessage.Text := MessageM.Lines.Text;
          FTimeOut := StrToInt(TimeoutE.Text);
          FConfurmReading := ReadingCB.Checked;
          if Radio_Smtp.Checked then FUseMapi := SMTP else
          if Radio_MAPI.Checked then FUseMapi := MAPI else
          if Radio_Outlook.Checked then FUseMapi := MSOutlook;
//          FUseMAPI := CheckBox1.Checked;

          if RememberCB.Checked and FUseIniFile then
          begin
            ini.WriteString(Section, 'FromName', FromNameE.Text);
            ini.WriteString(Section, 'FromAddress', FromAddrE.Text);
            ini.WriteString(Section, 'Organization', OrgE.Text);
            ini.WriteString(Section, 'Signature', SignatureM.Lines.Text);
            ini.WriteString(Section, 'SmtpHost', HostE.Text);
            ini.WriteString(Section, 'SmtpPort', PortE.Text);
            ini.WriteString(Section, 'Login', String(Base64Encode(AnsiString(LoginE.Text))));
            ini.WriteString(Section, 'Password', String(Base64Encode(AnsiString(PasswordE.Text))));
            ini.WriteString(Section, 'Timeout', String(TimeoutE.Text));
          end;
          if FUseIniFile then
          begin
            ini.WriteInteger(Section, 'LastUsedExport', ExportsCombo.ItemIndex);
            ini.WriteString(EMAIL_EXPORT_SECTION + '.RecentAddresses' , AddressE.Text, '');
            ini.WriteString(EMAIL_EXPORT_SECTION + '.RecentSubjects' , SubjectE.Text, '');
          end;
          ShowExportDialog := SettingCB.Checked;
          FExportFilter := TfrxCustomExportFilter(ExportsCombo.Items.Objects[ExportsCombo.ItemIndex]);
        end;
      finally
        ini.Free;
      end;
    finally
      Free;
    end;
  end;
end;

function TfrxMailExport.Start: Boolean;
var
  s, f: String;
  i: Integer;
  fname, Oldfname, FullFileName: String;
  OldShowProgress, OldShowDialog: Boolean;
  Files: TStringList;
begin
  s := '';
  if Assigned(FExportFilter) and (FExportFilter.FileName <> '') then
    f := ExtractFileName(frxUnixPath2WinPath(FExportFilter.FileName))
  else if Report.ReportOptions.Name = '' then
    f := StringReplace(ExtractFileName(frxUnixPath2WinPath(Report.FileName)), ExtractFileExt(frxUnixPath2WinPath(Report.FileName)), '', [])
  else
    f := Report.ReportOptions.Name;
  if Assigned(FExportFilter) and (FExportFilter.FileName = '') then
    f := f + FExportFilter.DefaultExt;
  if Assigned(FExportFilter) then
  begin
    Oldfname := FExportFilter.FileName;
    if FExportFilter.DefaultPath <> '' then
    begin
      FDefaultIOTransport.BasePath := FExportFilter.DefaultPath;
      FExportFilter.FileName := f;
    end
    else
    begin
      FDefaultIOTransport.CreateTempContainer;
      FExportFilter.FileName :=  FDefaultIOTransport.BasePath + PathDelim + f;
    end;
    FOldSlaveStatus := FExportFilter.SlaveExport;
    FExportFilter.SlaveExport := True;
    OldShowDialog := FExportFilter.ShowDialog;
    OldShowProgress := FExportFilter.ShowProgress;
    FExportFilter.IOTransport := FDefaultIOTransport;
    try
      FExportFilter.ShowDialog := ShowDialog and ShowExportDialog;
      FExportFilter.ShowProgress := ShowProgress;
      if Report.Export(FExportFilter) then
      begin
        Files := TStringList.Create;
        try
          if FExportFilter.Files = nil then
          begin
            if FExportFilter.DefaultPath <> '' then
              FullFileName := FExportFilter.DefaultPath + PathDelim + FExportFilter.FileName
            else
              FullFileName := FExportFilter.FileName;
            if FUseMAPI = SMTP then
              Files.Add(FullFileName + '=' + f)
            else
              Files.Add(FullFileName)
          end
          else
            Files.AddStrings(FExportFilter.Files);

            s := Mail(FSmtpHost, FSmtpPort, FLogin, FPassword, FFromMail, FAddress,
              FSubject, FFromCompany, FMessage.Text + FSignature.Text, Files, FTimeOut, FConfurmReading, FMailCc, FMailBcc);
        finally
          FExportFilter.IOTransport := nil;
          if Assigned(FOnAfterSendMail) then
            FOnAfterSendMail(s);
          FDefaultIOTransport.FreeTempContainer;
          for i := 0 to Files.Count - 1 do
            DeleteFile(Files.Names[i]);
          Files.Free;
        end;
      end;
    finally
      FExportFilter.SlaveExport := FOldSlaveStatus;
      FExportFilter.ShowDialog := OldShowDialog;
      FExportFilter.ShowProgress := OldShowProgress;
      FExportFilter.FileName := Oldfname;
    end;
  end
  else begin
    f := f + '.fp3';
    fname := GetTempFile;
    Report.PreviewPages.SaveToFile(fname);
    Files := TStringList.Create;
    try
      if FUseMAPI = SMTP then
        Files.Add(fname + '=' + f)
      else
        Files.Add(fname);

      s := Mail(FSmtpHost, FSmtpPort, FLogin, FPassword, FFromMail, FAddress,
          FSubject, FFromCompany, FMessage.Text + FSignature.Text, Files);
    finally
      if Assigned(FOnAfterSendMail) then
            FOnAfterSendMail(s);
      for i := 0 to Files.Count - 1 do
        DeleteFile(Files.Names[i]);
      Files.Free;
    end;
  end;
  if s <> '' then
    case Report.EngineOptions.NewSilentMode of
      simSilent:        Report.Errors.Add(s);
      simMessageBoxes:  frxErrorMsg(s);
      simReThrow: raise Exception.Create(s);
    end;
  Result := False;
end;

procedure TfrxMailExport.ExportObject(Obj: TfrxComponent);
begin
  // Fake
end;

function TfrxMailExport.Mail(const Server: String; const Port: Integer;const
  UserField, PasswordField: String; FromField, ToField, SubjectField, CompanyField,
  TextField: WideString; FileNames: TStringList; Timeout: integer = 60; ConfurmReading: boolean = false;
  MailCc: WideString = ''; MailBcc: WideString = ''): String;
const
    olMailItem = 0;
var
{$IFDEF USE_INDY}
  mailer : TIdSMTP;
  EMsg: TIdMessage;
  sslIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  p: Integer;
{$ELSE}
  frxMail:  TfrxSMTPClient;
{$ENDIF}
  frxMapi:  TMapiControl;
  Outlook:  OLEVariant;
  MailItem: Variant;
  i, j: Integer;
  s: String;
  OutlockVailable: Boolean;

begin
  if Assigned(FOnSendMail) then
  begin
    Result := FOnSendMail(Server, Port, UserField, PasswordField, FromField, ToField,
          SubjectField, CompanyField, TextField, FileNames , TimeOut, ConfurmReading, MailCc, MailBcc);
    if Result = '' then exit;
  end;
  case FUseMAPI of
  // ---------------------- SMTP -------------------------
  SMTP:
begin
{$IFDEF USE_INDY}
    mailer := TIdSMTP.Create(nil);
//    try
      mailer.AuthType := satDefault; // satSASL; //
      mailer.Host := Server;;
      mailer.UserName := UserField;
      mailer.Password := PasswordField;

      sslIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
      sslIOHandler.SSLOptions.Method := sslvSSLv23;
      mailer.IOHandler := sslIOHandler;
      case Port of
       465, 587: mailer.UseTLS := utUseImplicitTLS
       else
         mailer.UseTLS := utUseExplicitTLS;
      end;

      EMsg := TIdMessage.Create(mailer);
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
      EMsg.Body.Append( StringReplace(TextField, '\n', #13#10, [rfReplaceAll]));

      for i := 0 to FileNames.Count - 1 do
        begin
          p := Pos('=', FileNames[i]);
          if p <> 0 then
            begin
              with TIdAttachmentFile.Create(EMsg.MessageParts, Copy(FileNames[i], 1, p - 1)) do
                FileName := Copy(FileNames[i], p + 1, length(FileNames[i]) - p);
            end
          else
            TIdAttachmentFile.Create(EMsg.MessageParts, FileNames[i]);
        end;

      EMsg.AfterConstruction;

      mailer.Connect;
      if mailer.Connected then
        mailer.Send(EMsg);

      mailer.Disconnect;
      EMsg.Free;
      sslIOHandler.Free;
      mailer.Free;
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
{$ELSE}
      frxMail := TfrxSMTPClient.Create(nil);
      try
        frxMail.Host := Server;
        frxMail.Port := Port;
        frxMail.User := UserField;
        frxMail.Password := PasswordField;
        frxMail.MailFrom := FromField;
        frxMail.MailTo := ToField;
        frxMail.MailSubject := SubjectField;
        frxMail.Organization := CompanyField;
        frxMail.MailText := StringReplace(TextField, '\n', #13#10, [rfReplaceAll]);
        frxMail.MailFiles.Assign(FileNames);
        frxMail.ShowProgress := ShowProgress;
        frxMail.TimeOut := Timeout;
        frxMail.ConfirmReading := FConfurmReading;
        frxMail.MailCc := FMailCc;
        frxMail.MailBcc := FMailBcc;
        if SMTPStartCommand = HELO then
          frxMail.StartCommand := 'HELO'
        else
          frxMail.StartCommand := 'EHLO';
  {$IFDEF FR_DEBUG}
        frxMail.LogFile := GetCurrentDir + '\fr_mail.log';
  {$ELSE}
        frxMail.LogFile := LogFile;
  {$ENDIF}
        frxMail.Open;
      finally
        Result := frxMail.Errors.Text;
        frxMail.Free;
      end
{$ENDIF}
    end;
  // ---------------------- MAPI -------------------------
  MAPI:
    begin
    frxMapi := TMapiControl.Create(nil);
    frxMapi.FromName := FromField;
    i := 1;
    j := 1;
    while i <= Length(ToField) do
    begin
      if ToField[i] = ',' then
      begin
        s := Copy(ToField, j, i - j);
        frxMapi.Recipients.Add(s);
        j := i + 1;
      end;
      Inc(i);
    end;
    s := Copy(ToField, j, i - j);
    frxMapi.Recipients.Add(s);
    frxMapi.Subject := SubjectField;
    frxMapi.Body := StringReplace(TextField, '\n', #13#10, [rfReplaceAll]);
    frxMapi.AttachedFiles.Assign(FileNames);
    frxMapi.ShowDialog := false;
    frxMapi.MAPISendFlag := MAPISendFlag;
    Result := frxMapi.Sendmail(UserField, PasswordField);
    frxMapi.Free;
  end;
  // ---------------------- Outlook -------------------------
  MSOutlook:
  begin
    OutlockVailable := false;
    try
      Outlook:= GetActiveOleObject('Outlook.Application');
      OutlockVailable := true;
    except
    end;
{
    if Not OutlockVailable then
    try
      OutlockVailable := false;
      Outlook:= CreateOleObject('Outlook.Application');
      OutlockVailable := true;
    except
    end;
}
    if Not OutlockVailable then
    begin
      Result := 'Cannot access to Microsoft Outlook.';
      exit
    end;
    MailItem:= Outlook.CreateItem(olMailItem);
    MailItem.Subject:= SubjectField;
    i := 1;
    j := 1;
    while i <= Length(ToField) do
    begin
      if ToField[i] = ',' then
      begin
        s := Copy(ToField, j, i - j);
        MailItem.Recipients.Add(s);
        j := i + 1;
      end;
      Inc(i);
    end;
    s := Copy(ToField, j, i - j);
    MailItem.Recipients.Add(s);
    MailItem.Body:= StringReplace(TextField, '\n', #13#10, [rfReplaceAll]);
    MailItem.Attachments.Add(FileNames[0]);
    MailItem.Send;
    Outlook := Unassigned;
  end;
  end;
end;

procedure TfrxMailExport.SetMessage(const Value: TStrings);
begin
  FMessage.Assign(Value);
end;

procedure TfrxMailExport.SetSignature(const Value: TStrings);
begin
  FSignature.Assign(Value);
end;

{ TfrxMailExportDialog }

procedure TfrxMailExportDialog.FormCreate(Sender: TObject);
begin
  Caption := frxGet(8900);
  OkB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);
  ExportSheet.Caption := frxGet(8901);
  AccountSheet.Caption := frxGet(8902);
  AccountGroup.Caption := frxGet(8903);
  AddressLB.Caption := frxGet(8904);
  AttachGroup.Caption := frxGet(8905);
  FormatLB.Caption := frxGet(8906);
  FromAddrLB.Caption := frxGet(8907);
  FromNameLB.Caption := frxGet(8908);
  HostLB.Caption := frxGet(8909);
  LoginLB.Caption := frxGet(8910);
  MailGroup.Caption := frxGet(8911);
  MessageGroup.Caption := frxGet(8912);
  MessageLB.Caption := frxGet(8913);
  OrgLB.Caption := frxGet(8914);
  PasswordLB.Caption := frxGet(8915);
  PortLB.Caption := frxGet(8916);
  RememberCB.Caption := frxGet(8917);
  ReqLB.Caption := frxGet(8918);
  SettingCB.Caption := frxGet(8919);
  SignatureLB.Caption := frxGet(8920);
  SignBuildBtn.Caption := frxGet(8921);
  SubjectLB.Caption := frxGet(8922);
  ReadingCB.Caption := frxGet(8989);
  MailTransportLB.Caption := frxGet(8925);
  TimeoutLB.Caption := frxGet(8926);
  AddressE.Hint := frxResources.Get('expMailAddr');

  if UseRightToLeftAlignment then
    FlipChildren(True);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;


procedure TfrxMailExportDialog.SignBuildBtnClick(Sender: TObject);
begin
  SignatureM.Clear;
  SignatureM.Lines.Add('--');
  SignatureM.Lines.Add(frxGet(8923) + ',');
  if Length(FromNameE.Text) > 0 then
    SignatureM.Lines.Add('  ' + FromNameE.Text);
  if Length(FromAddrE.Text) > 0 then
    SignatureM.Lines.Add('  mailto: ' + FromAddrE.Text);
  if Length(OrgE.Text) > 0 then
    SignatureM.Lines.Add('  ' + OrgE.Text);
end;

procedure TfrxMailExportDialog.OkBClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TLabel then
      (Components[i] as TLabel).Font.Style := [];
  if AddressE.Text = '' then
  begin
    ExportSheet.Show;
    AddressLB.Font.Style := [fsBold];
    ModalResult := mrNone;
  end;
  if SubjectE.Text = '' then
  begin
    ExportSheet.Show;
    SubjectLB.Font.Style := [fsBold];
    ModalResult := mrNone;
  end;
  if Radio_Smtp.Checked then
  begin
    if FromAddrE.Text = '' then
    begin
      AccountSheet.Show;
      FromAddrLB.Font.Style := [fsBold];
      ModalResult := mrNone;
    end;
    if HostE.Text = '' then
    begin
      AccountSheet.Show;
      HostLB.Font.Style := [fsBold];
      ModalResult := mrNone;
    end;
    if PortE.Text = '' then
    begin
      AccountSheet.Show;
      PortLB.Font.Style := [fsBold];
      ModalResult := mrNone;
    end;
  end;
  ReqLB.Visible := ModalResult = mrNone
end;

procedure TfrxMailExportDialog.PortEKeyPress(Sender: TObject;
  var Key: Char);
begin
  case key of
    '0'..'9':;
    #8:;
  else
    key := #0;
  end;
end;

procedure TfrxMailExportDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxMailExportDialog.PageControl1Change(Sender: TObject);
begin
{$IFDEF Delphi6}
//  if (PageControl1.ActivePageIndex = 1) and (CheckBox1.Checked) then
//    PageControl1.ActivePageIndex := 0;
{$ENDIF}
end;

end.

