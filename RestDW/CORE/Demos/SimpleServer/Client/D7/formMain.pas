unit formMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, uDWJSONObject, uLkJSON,
  DB, Grids, DBGrids, uRESTDWBase, uDWJSONTools, uDWConsts, idComponent,
  ExtCtrls, DBClient, uRESTDWPoolerDB, ComCtrls,
  uDWConstsData, uRESTDWServerEvents, DateUtils, uDWDataset, uDWAbout,
  ActnList, jpeg;

type

  { TForm2 }

  TForm2 = class(TForm)
    labHost: TLabel;
    labPorta: TLabel;
    labSenha: TLabel;
    labUsuario: TLabel;
    labResult: TLabel;
    labAcesso: TLabel;
    labWelcome: TLabel;
    labExtras: TLabel;
    labSql: TLabel;
    labRepsonse: TLabel;
    labConexao: TLabel;
    labVersao: TLabel;
    eHost: TEdit;
    ePort: TEdit;
    edPasswordDW: TEdit;
    edUserNameDW: TEdit;
    DBGrid1: TDBGrid;
    mComando: TMemo;
    btnOpen: TButton;
    cbxCompressao: TCheckBox;
    btnExecute: TButton;
    ProgressBar1: TProgressBar;
    btnGet: TButton;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    btnApply: TButton;
    chkhttps: TCheckBox;
    btnMassive: TButton;
    btnServerTime: TButton;
    eAccesstag: TEdit;
    eWelcomemessage: TEdit;
    DataSource1: TDataSource;
    RESTDWClientSQL1: TRESTDWClientSQL;
    RESTDWDataBase1: TRESTDWDataBase;
    ActionList1: TActionList;
    DWClientEvents1: TDWClientEvents;
    RESTClientPooler1: TRESTClientPooler;
    DWClientEvents2: TDWClientEvents;
    paTopo: TPanel;
    Image1: TImage;
    labSistema: TLabel;
    paPortugues: TPanel;
    Image3: TImage;
    paEspanhol: TPanel;
    Image4: TImage;
    paIngles: TPanel;
    Image2: TImage;
    cbBinaryRequest: TCheckBox;
    cbUseCripto: TCheckBox;
    procedure RESTDWDataBase1WorkBegin(ASender: TObject;
      AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure RESTDWDataBase1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure RESTDWDataBase1WorkEnd(ASender: TObject;
      AWorkMode: TWorkMode);
    procedure RESTDWDataBase1BeforeConnect(Sender: TComponent);
    procedure RESTDWDataBase1Connection(Sucess: Boolean;
      const Error: String);
    procedure RESTDWDataBase1Status(ASender: TObject;
      const AStatus: TIdStatus; const AStatusText: String);
    procedure btnOpenClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnServerTimeClick(Sender: TObject);
    procedure btnMassiveClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure cbUseCriptoClick(Sender: TObject);
  private
    { Private declarations }
   FBytesToTransfer : Int64;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.RESTDWDataBase1WorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
 FBytesToTransfer      := AWorkCountMax;
 ProgressBar1.Max      := FBytesToTransfer;
 ProgressBar1.Position := 0;
end;

procedure TForm2.RESTDWDataBase1Work(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  If FBytesToTransfer = 0 Then // No Update File
   Exit;
  ProgressBar1.Position := AWorkCount;
end;

procedure TForm2.RESTDWDataBase1WorkEnd(ASender: TObject;
  AWorkMode: TWorkMode);
begin
 ProgressBar1.Position := FBytesToTransfer;
 FBytesToTransfer      := 0;
end;

procedure TForm2.RESTDWDataBase1BeforeConnect(Sender: TComponent);
begin
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add('**********');
  Memo1.Lines.Add(' ');
end;

procedure TForm2.RESTDWDataBase1Connection(Sucess: Boolean;
  const Error: String);
begin
  IF Sucess THEN
  BEGIN
    Memo1.Lines.Add(DateTimeToStr(Now) + ' - Database conectado com sucesso.');
  END
  ELSE
  BEGIN
    Memo1.Lines.Add(DateTimeToStr(Now) + ' - Falha de conexão ao Database: ' + Error);
  END;
end;

procedure TForm2.RESTDWDataBase1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
 if Self = Nil then
  Exit;
  CASE AStatus OF
    hsResolving:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsResolving...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsConnecting:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsConnecting...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsConnected:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsConnected...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsDisconnecting:
      BEGIN
        if StatusBar1.Panels.count > 0 then
         StatusBar1.Panels[0].Text := 'hsDisconnecting...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsDisconnected:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsDisconnected...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    hsStatusText:
      BEGIN
        StatusBar1.Panels[0].Text := 'hsStatusText...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    // These are to eliminate the TIdFTPStatus and the coresponding event These can be use din the other protocols to.
    ftpTransfer:
      BEGIN
        StatusBar1.Panels[0].Text := 'ftpTransfer...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    ftpReady:
      BEGIN
        StatusBar1.Panels[0].Text := 'ftpReady...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
    ftpAborted:
      BEGIN
        StatusBar1.Panels[0].Text := 'ftpAborted...';
        Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
      END;
  END;
end;

procedure TForm2.btnOpenClick(Sender: TObject);
VAR
  INICIO: TdateTime;
  FIM: TdateTime;
BEGIN
  RESTDWDataBase1.Close;
  RESTDWDataBase1.PoolerService  := EHost.Text;
  RESTDWDataBase1.PoolerPort     := StrToInt(EPort.Text);
  RESTDWDataBase1.Login          := EdUserNameDW.Text;
  RESTDWDataBase1.Password       := EdPasswordDW.Text;
  RESTDWDataBase1.Compression    := cbxCompressao.Checked;
  RESTDWDataBase1.AccessTag      := eAccesstag.Text;
  RESTDWDataBase1.WelcomeMessage := eWelcomemessage.Text;
  If chkhttps.Checked Then
   RESTDWDataBase1.TypeRequest   := trHttps
  Else
   RESTDWDataBase1.TypeRequest   := trHttp;
  RESTDWDataBase1.Open;
  INICIO                  := Now;
  DataSource1.DataSet     := RESTDWClientSQL1;
  RESTDWClientSQL1.Active := False;
  RESTDWClientSQL1.SQL.Clear;
  RESTDWClientSQL1.SQL.Add(MComando.Text);
  RESTDWClientSQL1.BinaryRequest := cbBinaryRequest.Checked;
  TRY
    RESTDWClientSQL1.Active := True;
  EXCEPT
    ON E: Exception DO
    BEGIN
      RAISE Exception.Create(E.Message);
    END;
  END;
  FIM := Now;
  Showmessage(IntToStr(RESTDWClientSQL1.Recordcount) + ' registro(s) recebido(s) em ' + IntToStr(SecondsBetween(FIM, INICIO)) + ' segundos.');
END;

procedure TForm2.btnApplyClick(Sender: TObject);
Var
 vError : String;
begin
 If Not RESTDWClientSQL1.ApplyUpdates(vError) Then
  MessageDlg(vError, mtError, [mbOK], 0);
end;

procedure TForm2.btnServerTimeClick(Sender: TObject);
Var
 dwParams      : TDWParams;
 vErrorMessage : String;
begin
 RESTClientPooler1.Host            := EHost.Text;
 RESTClientPooler1.Port            := StrToInt(EPort.Text);
 RESTClientPooler1.UserName        := EdUserNameDW.Text;
 RESTClientPooler1.Password        := EdPasswordDW.Text;
 RESTClientPooler1.DataCompression := cbxCompressao.Checked;
 RESTClientPooler1.AccessTag       := eAccesstag.Text;
 RESTClientPooler1.WelcomeMessage  := eWelcomemessage.Text;
 If chkhttps.Checked then
  RESTClientPooler1.TypeRequest := trHttps
 Else
  RESTClientPooler1.TypeRequest := trHttp;
 DWClientEvents1.CreateDWParams('servertime', dwParams);
 dwParams.ItemsString['inputdata'].AsString := 'teste de string';
 DWClientEvents1.SendEvent('servertime', dwParams, vErrorMessage);
 If vErrorMessage = '' Then
  Begin
   If dwParams.ItemsString['result'].AsString <> '' Then
    Showmessage('Server Date/Time is : ' + DateTimeToStr(dwParams.ItemsString['result'].Value))
   Else
    Showmessage('Invalid result data...');
   dwParams.ItemsString['result'].SaveToFile('json.d7'); 
  End
 Else
  Showmessage(vErrorMessage);
 dwParams.Free;
end;

procedure TForm2.btnMassiveClick(Sender: TObject);
begin
 If RESTDWClientSQL1.MassiveCount > 0 Then
  Showmessage(RESTDWClientSQL1.MassiveToJSON);
end;

procedure TForm2.btnGetClick(Sender: TObject);
Var
 dwParams      : TDWParams;
 vErrorMessage,
 vNativeResult : String;
begin
 RESTClientPooler1.Host            := EHost.Text;
 RESTClientPooler1.Port            := StrToInt(EPort.Text);
 RESTClientPooler1.UserName        := EdUserNameDW.Text;
 RESTClientPooler1.Password        := EdPasswordDW.Text;
 RESTClientPooler1.DataCompression := cbxCompressao.Checked;
 RESTClientPooler1.AccessTag       := eAccesstag.Text;
 RESTClientPooler1.WelcomeMessage  := eWelcomemessage.Text;
 If chkhttps.Checked then
  RESTClientPooler1.TypeRequest := trHttps
 Else
  RESTClientPooler1.TypeRequest := trHttp;
 DWClientEvents1.CreateDWParams('getemployee', dwParams);
 DWClientEvents1.SendEvent('getemployee', dwParams, vErrorMessage, vNativeResult);
 dwParams.Free;
 If vErrorMessage = '' Then
  Showmessage(vNativeResult)
 Else
  Showmessage(vErrorMessage);
end;

procedure TForm2.btnExecuteClick(Sender: TObject);
VAR
  VError: STRING;
BEGIN
  RESTDWDataBase1.Close;
  RESTDWDataBase1.PoolerService  := EHost.Text;
  RESTDWDataBase1.PoolerPort     := StrToInt(EPort.Text);
  RESTDWDataBase1.Login          := EdUserNameDW.Text;
  RESTDWDataBase1.Password       := EdPasswordDW.Text;
  RESTDWDataBase1.Compression    := cbxCompressao.Checked;
  RESTDWDataBase1.AccessTag      := eAccesstag.Text;
  RESTDWDataBase1.WelcomeMessage := eWelcomemessage.Text;
  If chkhttps.Checked Then
   RESTDWDataBase1.TypeRequest   := trHttps
  Else
   RESTDWDataBase1.TypeRequest   := trHttp;
  RESTDWDataBase1.Open;
  RESTDWClientSQL1.Close;
  RESTDWClientSQL1.SQL.Clear;
  RESTDWClientSQL1.SQL.Add(MComando.Text);
  IF NOT RESTDWClientSQL1.ExecSQL(VError) THEN
    Application.MessageBox(PChar('Erro executando o comando ' + RESTDWClientSQL1.SQL.Text), 'Erro...', Mb_iconerror + Mb_ok)
  ELSE
    Application.MessageBox('Comando executado com sucesso...', 'Informação !!!', Mb_iconinformation + Mb_ok);
END;

procedure TForm2.cbUseCriptoClick(Sender: TObject);
begin
 RESTDWDataBase1.CriptOptions.Use   := cbUseCripto.Checked;
 RESTClientPooler1.CriptOptions.Use := RESTDWDataBase1.CriptOptions.Use;
end;

end.
