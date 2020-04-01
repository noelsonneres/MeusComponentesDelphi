
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

unit frxIOTransportMail;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, frxClass, IniFiles, ComCtrls, frxIOSMTP
{$IFDEF Delphi6}, Variants {$ENDIF};

type

  TMailTransport = (SMTP, MAPI, MSOutlook);
  TSMTPStartCommand = (EHLO, HELO);
  TfrxOnSendMailEvent = function (const Server: String;
    const Port: Integer;const UserField, PasswordField: String; FromField,
    ToField, SubjectField, CompanyField, TextField: WideString;
    FileNames: TStringList; Timeout: Integer; ConfurmReading: boolean; MailCc, MailBcc: WideString): String of object;

  TfrxMailIOTransportForm = class(TForm)
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
  TfrxMailIOTransport = class(TfrxCustomIOTransport)
  private
    FAddress: String;
    FSubject: String;
    FMessage: TStrings;
    FShowExportDialog: Boolean;
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
    FMailCc: String;
    FMailBcc: String;
    FFiles: TStringList;
    FTransportResult: Boolean;
    procedure SetMessage(const Value: TStrings);
    procedure SetSignature(const Value: TStrings);
  protected
    function DoCreateStream(var aFullFilePath: String; aFileName: String): TStream; override;
    function DoMailSMTP(const Server: String; const Port: Integer;const
      UserField, PasswordField: String; FromField, ToField, SubjectField, CompanyField,
      TextField: WideString; FileNames: TStringList; Timeout: integer = 60;
      ConfurmReading: boolean = false; MailCc: WideString = ''; MailBcc: WideString = ''): String; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AllInOneContainer: Boolean; override;
    class function GetDescription: String; override;
    function OpenFilter: Boolean; override;
    procedure CloseFilter; override;
    function ShowModal: TModalResult;
    function Start: Boolean;
    function Mail(const Server: String; const Port: Integer;const
      UserField, PasswordField: String; FromField, ToField, SubjectField, CompanyField,
      TextField: WideString; FileNames: TStringList; Timeout: integer = 60;
      ConfurmReading: boolean = false; MailCc: WideString = ''; MailBcc: WideString = ''): String;
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
    property UseMAPI: TMailTransport read FUseMAPI write FUseMAPI;
    property MailCc: String read FMailCc write FMailCc;
    property MailBcc: String read FMailBcc write FMailBcc;
  end;


implementation

uses frxDsgnIntf, frxFileUtils, frxNetUtils, frxUtils,
     frxUnicodeUtils, frxRes, Registry,
     frxIOSendMAPI, ComObj, StrUtils;

{$R *.dfm}

const
  EMAIL_EXPORT_SECTION = 'EmailExport';

{ TfrxMailExport }

function TfrxMailIOTransport.AllInOneContainer: Boolean;
begin
  Result := True;
end;

procedure TfrxMailIOTransport.CloseFilter;
var
  s: String;
begin
  try
    if FTransportResult then
      s := Mail(FSmtpHost, FSmtpPort, FLogin, FPassword, FFromMail, FAddress,
        FSubject, FFromCompany, FMessage.Text + FSignature.Text, FFiles, FTimeOut,
        FConfurmReading, FMailCc, FMailBcc)
    else
      s := '';
  finally
    inherited;
  end;
  if (s <> '') and (Report <> nil) then
    case Report.EngineOptions.NewSilentMode of
      simSilent:
        Report.Errors.Add(s);
      simMessageBoxes:
        frxErrorMsg(s);
      simReThrow:
        raise Exception.Create(s);
    end;
end;

constructor TfrxMailIOTransport.Create(AOwner: TComponent);
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
  FSupportedStreams := [tsIOWrite];
end;

destructor TfrxMailIOTransport.Destroy;
begin
  FMessage.Free;
  FSignature.Free;
  if Assigned(FFiles) then
    FFiles.Free;
  inherited;
end;

function TfrxMailIOTransport.DoCreateStream(var aFullFilePath: String;
  aFileName: String): TStream;
var
  fName: String;
  i: Integer;
  OldFilterAccess: TfrxFilterAccess;
begin
  Result := nil;
  fName := aFullFilePath;
  i := PosEx(BasePath, fName, 1);
  if i = 1 then
    fName := Copy(fName, Length(BasePath), Length(fName));

  // if ExtractFilePath(aFileName) = '' then
  // fName := GetTempFile + ExtractFileExt(aFileName);

  if (fName = '') and (FilterAccess = faRead) then
      fName := Filename;

  if (fName <> '') then
  begin
    OldFilterAccess := FilterAccess;
    FilterAccess := faWrite;
    InternalFilter.FilterAccess := faWrite;
    InternalFilter.CreateTempContainer;
    fName := InternalFilter.BasePath + PathDelim + fName;
    Result := InternalFilter.GetStream(fName); // TFileStream.Create(fName, fmCreate);
    FilterAccess := OldFilterAccess;
  end;

  if FilterAccess = faRead then
  begin
    { TODO: Move to Filter.Open }
    if aFullFilePath = '' then
    begin
      aFullFilePath := fName;
      aFileName := fName;
    end;
   // DoReadRemoteContent(aFullFilePath, Result);
    if Result = nil then
      Exit;
    InternalFilter.FreeStream(Result);
    OldFilterAccess := InternalFilter.FilterAccess;
    InternalFilter.FilterAccess := faRead;
    fName := InternalFilter.BasePath + PathDelim + fName;
    Result := InternalFilter.GetStream(fName);
    InternalFilter.FilterAccess := OldFilterAccess;
  end;
  if FUseMAPI = SMTP then
    FFiles.AddObject(fName + '=' + ExtractFileName(aFileName), Result)
  else
    FFiles.AddObject(fName, Result);
end;


function TfrxMailIOTransport.DoMailSMTP(const Server: String;
  const Port: Integer; const UserField, PasswordField: String; FromField,
  ToField, SubjectField, CompanyField, TextField: WideString;
  FileNames: TStringList; Timeout: integer; ConfurmReading: boolean; MailCc,
  MailBcc: WideString): String;
var
  frxMail:  TfrxSMTPClient;
begin
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
    frxMail.ShowProgress := True;
    frxMail.Timeout := Timeout;
    frxMail.ConfirmReading := FConfurmReading;
    frxMail.MailCc := MailCc;
    frxMail.MailBcc := MailBcc;
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
end;

class function TfrxMailIOTransport.GetDescription: String;
begin
  Result := frxResources.Get('Email Transport');
end;

function TfrxMailIOTransport.ShowModal: TModalResult;
var
  ini: TCustomIniFile;
  Section: String;
begin
  with TfrxMailIOTRansportForm.Create(nil) do
  begin
    try
      case FUseMapi of
        SMTP: Radio_Smtp.Checked  := True;
        MAPI: Radio_MAPI.Checked  := True;
        else Radio_Outlook.Checked     := True
      end;
      AttachGroup.Visible := true;
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
        end;

        AddressE.Text := FAddress;
        SubjectE.Text := FSubject;
        MessageM.Text := FMessage.Text;

        FTransportResult := False;
        Result := ShowModal;

        if Result = mrOk then
        begin
          FTransportResult := True;
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
            ini.WriteString(EMAIL_EXPORT_SECTION + '.RecentAddresses' , AddressE.Text, '');
            ini.WriteString(EMAIL_EXPORT_SECTION + '.RecentSubjects' , SubjectE.Text, '');
          end;
        end;
      finally
        ini.Free;
      end;
    finally
      Free;
    end;
  end;
end;

function TfrxMailIOTransport.Start: Boolean;
begin
  Result := False;
end;

function TfrxMailIOTransport.Mail(const Server: String; const Port: Integer;const
  UserField, PasswordField: String; FromField, ToField, SubjectField, CompanyField,
  TextField: WideString; FileNames: TStringList; Timeout: integer = 60; ConfurmReading: boolean = false;
  MailCc: WideString = ''; MailBcc: WideString = ''): String;
const
    olMailItem = 0;
var
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
  Result := DoMailSMTP(Server, Port, UserField, PasswordField, FromField, ToField,
          SubjectField, CompanyField, TextField, FileNames , TimeOut, ConfurmReading, MailCc, MailBcc);
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
    for i := 0 to Filenames.Count - 1 do
      MailItem.Attachments.Add(FileNames[i]);
    MailItem.Send;
    Outlook := Unassigned;
  end;
  end;
end;

function TfrxMailIOTransport.OpenFilter: Boolean;
begin
  FFiles := TStringList.Create;
  Result := (ShowModal = mrOk);
end;

procedure TfrxMailIOTransport.SetMessage(const Value: TStrings);
begin
  FMessage.Assign(Value);
end;

procedure TfrxMailIOTransport.SetSignature(const Value: TStrings);
begin
  FSignature.Assign(Value);
end;

{ TfrxMailSaveFilterForm }

procedure TfrxMailIOTransportForm.FormCreate(Sender: TObject);
begin
  Caption := frxGet(8900);
  OkB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);
  ExportSheet.Caption := frxGet(8901);
  AccountSheet.Caption := frxGet(8902);
  AccountGroup.Caption := frxGet(8903);
  AddressLB.Caption := frxGet(8904);
  AttachGroup.Caption := frxGet(8905);
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
  SignatureLB.Caption := frxGet(8920);
  SignBuildBtn.Caption := frxGet(8921);
  SubjectLB.Caption := frxGet(8922);
  ReadingCB.Caption := frxGet(8989);
  AddressE.Hint := frxResources.Get('expMailAddr');

  if UseRightToLeftAlignment then
    FlipChildren(True);
end;


procedure TfrxMailIOTransportForm.SignBuildBtnClick(Sender: TObject);
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

procedure TfrxMailIOTransportForm.OkBClick(Sender: TObject);
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

procedure TfrxMailIOTransportForm.PortEKeyPress(Sender: TObject;
  var Key: Char);
begin
  case key of
    '0'..'9':;
    #8:;
  else
    key := #0;
  end;
end;

procedure TfrxMailIOTransportForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxMailIOTransportForm.PageControl1Change(Sender: TObject);
begin
{$IFDEF Delphi6}
//  if (PageControl1.ActivePageIndex = 1) and (CheckBox1.Checked) then
//    PageControl1.ActivePageIndex := 0;
{$ENDIF}
end;

end.
