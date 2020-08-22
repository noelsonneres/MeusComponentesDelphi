Unit formMain;

Interface

Uses
  DateUtils,      Windows,     Messages,                SysUtils,  Variants,  Classes, Graphics,   Controls,
  Forms,          Dialogs,     StdCtrls,                UDWJSONObject,   DB,  Grids,   DBGrids,    URESTDWBase,
  UDWJSONTools,   UDWConsts,   Vcl.ExtCtrls,            Vcl.Imaging.Pngimage, URESTDWPoolerDB,     Vcl.ComCtrls,
  System.UITypes, IdComponent, FireDAC.Stan.Intf,       FireDAC.Stan.Option,  FireDAC.Stan.Param,  FireDAC.Stan.Error,
  FireDAC.DatS,   FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDWConstsData,
  System.Actions, Vcl.ActnList, uRESTDWServerEvents,    uDWDataset, uDWAbout, Vcl.Buttons,         Vcl.Imaging.jpeg,
  FireDAC.Stan.StorageJSON, MemDS, VirtualTable;

 Type
  TForm2 = Class(TForm)
   EHost             : TEdit;
   EPort             : TEdit;
   labHost           : TLabel;
   labPorta          : TLabel;
   DataSource1       : TDataSource;
   EdPasswordDW      : TEdit;
   labSenha          : TLabel;
   EdUserNameDW      : TEdit;
   labUsuario        : TLabel;
   labResult         : TLabel;
   DBGrid1           : TDBGrid;
   MComando          : TMemo;
   btnOpen           : TButton;
   cbxCompressao     : TCheckBox;
   RESTDWClientSQL1  : TRESTDWClientSQL;
   RESTDWDataBase1   : TRESTDWDataBase;
   btnExecute        : TButton;
   ProgressBar1      : TProgressBar;
   btnGet            : TButton;
   StatusBar1        : TStatusBar;
   Memo1             : TMemo;
   btnApply          : TButton;
   chkhttps          : TCheckBox;
   btnMassive        : TButton;
   ActionList1       : TActionList;
   DWClientEvents1   : TDWClientEvents;
   RESTClientPooler1 : TRESTClientPooler;
   btnServerTime     : TButton;
   eAccesstag        : TEdit;
   labAcesso         : TLabel;
   eWelcomemessage   : TEdit;
   labWelcome        : TLabel;
   DWClientEvents2   : TDWClientEvents;
   labExtras         : TLabel;
   paTopo            : TPanel;
   labSistema        : TLabel;
   labSql            : TLabel;
   labRepsonse       : TLabel;
   labConexao        : TLabel;
   paPortugues       : TPanel;
   Image3            : TImage;
   paEspanhol        : TPanel;
   Image4            : TImage;
   paIngles          : TPanel;
   Image2            : TImage;
   Image1            : TImage;
   labVersao         : TLabel;
    Button1: TButton;
    cbBinaryRequest: TCheckBox;
    cbUseCripto: TCheckBox;
   Procedure btnOpenClick            (Sender            : TObject);
   Procedure btnExecuteClick         (Sender            : TObject);
   Procedure RESTDWDataBase1WorkBegin(ASender           : TObject;
                                      AWorkMode         : TWorkMode;
                                      AWorkCountMax     : Int64);
   Procedure RESTDWDataBase1Work     (ASender           : TObject;
                                      AWorkMode         : TWorkMode;
                                      AWorkCount        : Int64);
   Procedure RESTDWDataBase1WorkEnd  (ASender           : TObject;
                                      AWorkMode         : TWorkMode);
   Procedure RESTDWDataBase1Status   (ASender           : TObject;
                                      Const AStatus     : TIdStatus;
                                      Const AStatusText : String);
   Procedure FormCreate              (Sender            : TObject);
   Procedure RESTDWDataBase1Connection   (Sucess        : Boolean;
                                          Const Error   : String);
   Procedure RESTDWDataBase1BeforeConnect(Sender        : TComponent);
   Procedure btnApplyClick               (Sender        : TObject);
   Procedure btnMassiveClick             (Sender        : TObject);
   Procedure btnServerTimeClick          (Sender        : TObject);
   Procedure btnGetClick                 (Sender        : TObject);
   Procedure Image3Click                 (Sender        : TObject);
   Procedure Image4Click                 (Sender        : TObject);
   Procedure Image2Click                 (Sender        : TObject);
    procedure Button1Click(Sender: TObject);
    procedure RESTDWDataBase1FailOverExecute(
      ConnectionServer: TRESTDWConnectionServer);
    procedure RESTDWDataBase1FailOverError(
      ConnectionServer: TRESTDWConnectionServer; MessageError: string);
    procedure cbUseCriptoClick(Sender: TObject);
 Private
  { Private declarations }
  FBytesToTransfer : Int64;
 Public
  { Public declarations }
  Procedure Locale_Portugues(pLocale : String);
 End;

Var
 Form2: TForm2;

Implementation

{$R *.dfm}

Procedure TForm2.btnOpenClick(Sender: TObject);
Var
 INICIO,
 FIM    : TdateTime;
Begin
// RESTDWDataBase1.Close;
 If Not RESTDWDataBase1.Active Then
  Begin
   RESTDWDataBase1.PoolerService  := EHost.Text;
   RESTDWDataBase1.PoolerPort     := StrToInt(EPort.Text);
   RESTDWDataBase1.Login          := EdUserNameDW.Text;
   RESTDWDataBase1.Password       := EdPasswordDW.Text;
   RESTDWDataBase1.Compression    := cbxCompressao.Checked;
   RESTDWDataBase1.AccessTag      := eAccesstag.Text;
   RESTDWDataBase1.WelcomeMessage := eWelcomemessage.Text;
   If chkhttps.Checked Then
    RESTDWDataBase1.TypeRequest   := TTyperequest.trHttps
   Else
    RESTDWDataBase1.TypeRequest   := TTyperequest.trHttp;
   RESTDWDataBase1.Open;
  End;
 INICIO                         := Now;
 DataSource1.DataSet            := RESTDWClientSQL1;
 RESTDWClientSQL1.Close;
// RESTDWClientSQL1.Active        := False;
 RESTDWClientSQL1.SQL.Clear;
 RESTDWClientSQL1.SQL.Add(MComando.Text);
 RESTDWClientSQL1.BinaryRequest := cbBinaryRequest.Checked;
 Try
  RESTDWClientSQL1.Active := True;
 Except
  On E: Exception Do
   Begin
    Raise Exception.Create('Erro ao executar a consulta: ' + sLineBreak + E.Message);
   End;
 End;
 FIM := Now;
 EHost.Text            := RESTDWDataBase1.PoolerService;
 EPort.Text            := IntToStr(RESTDWDataBase1.PoolerPort);
 EdUserNameDW.Text     := RESTDWDataBase1.Login;
 EdPasswordDW.Text     := RESTDWDataBase1.Password;
 cbxCompressao.Checked := RESTDWDataBase1.Compression;
 eAccesstag.Text       := RESTDWDataBase1.AccessTag;
 eWelcomemessage.Text  := RESTDWDataBase1.WelcomeMessage;
 If RESTDWClientSQL1.FindField('EMP_NO') <> Nil Then
  RESTDWClientSQL1.FindField('EMP_NO').ProviderFlags := [pfInUpdate, pfInWhere, pfInKey];
 If RESTDWClientSQL1.FindField('FULL_NAME') <> Nil Then
  RESTDWClientSQL1.FindField('FULL_NAME').ProviderFlags := [];
 If RESTDWClientSQL1.Active Then
  Showmessage(IntToStr(RESTDWClientSQL1.Recordcount) + ' registro(s) recebido(s) em ' + IntToStr(MilliSecondsBetween(FIM, INICIO)) + ' Milis.');
End;

Procedure TForm2.btnExecuteClick(Sender: TObject);
Var
 VError : String;
Begin
// RESTDWDataBase1.Close;
 If Not RESTDWDataBase1.Active Then
  Begin
   RESTDWDataBase1.PoolerService  := EHost.Text;
   RESTDWDataBase1.PoolerPort     := StrToInt(EPort.Text);
   RESTDWDataBase1.Login          := EdUserNameDW.Text;
   RESTDWDataBase1.Password       := EdPasswordDW.Text;
   RESTDWDataBase1.Compression    := cbxCompressao.Checked;
   RESTDWDataBase1.AccessTag      := eAccesstag.Text;
   RESTDWDataBase1.WelcomeMessage := eWelcomemessage.Text;
   If chkhttps.Checked Then
    RESTDWDataBase1.TypeRequest   := TTyperequest.trHttps
   Else
    RESTDWDataBase1.TypeRequest   := TTyperequest.trHttp;
   RESTDWDataBase1.Open;
  End;
 RESTDWClientSQL1.Close;
 RESTDWClientSQL1.SQL.Clear;
 RESTDWClientSQL1.SQL.Add(MComando.Text);
 If Not RESTDWClientSQL1.ExecSQL(VError) Then
  Application.MessageBox(PChar('Erro executando o comando ' + RESTDWClientSQL1.SQL.Text), 'Erro...', Mb_IconError + Mb_Ok)
 Else
  Application.MessageBox('Comando executado com sucesso...', 'Informação !!!', Mb_iconinformation + Mb_Ok);
End;

Procedure TForm2.btnGetClick(Sender: TObject);
Var
 dwParams       : TDWParams;
 vErrorMessage,
 vNativeResult  : String;
Begin
 RESTClientPooler1.Host            := EHost.Text;
 RESTClientPooler1.Port            := StrToInt(EPort.Text);
 RESTClientPooler1.UserName        := EdUserNameDW.Text;
 RESTClientPooler1.Password        := EdPasswordDW.Text;
 RESTClientPooler1.DataCompression := cbxCompressao.Checked;
 RESTClientPooler1.AccessTag       := eAccesstag.Text;
 RESTClientPooler1.WelcomeMessage  := eWelcomemessage.Text;
 If chkhttps.Checked then
  RESTClientPooler1.TypeRequest    := TTyperequest.trHttps
 Else
  RESTClientPooler1.TypeRequest    := TTyperequest.trHttp;
 DWClientEvents1.CreateDWParams('getemployee', dwParams);
 DWClientEvents1.SendEvent('getemployee', dwParams, vErrorMessage, vNativeResult);
 If vNativeResult <> '' Then
  Showmessage(vNativeResult)
 Else
  Showmessage(vErrorMessage);
 dwParams.Free;
End;

Procedure TForm2.btnApplyClick(Sender: TObject);
Var
 vError : String;
Begin
 If Not RESTDWClientSQL1.ApplyUpdates(vError) Then
  MessageDlg(vError, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
End;

Procedure TForm2.btnMassiveClick(Sender: TObject);
Begin
 If RESTDWClientSQL1.MassiveCount > 0 Then
  Showmessage(RESTDWClientSQL1.MassiveToJSON);
End;

Procedure TForm2.btnServerTimeClick(Sender: TObject);
Var
 dwParams      : TDWParams;
 vErrorMessage : String;
Begin
 RESTClientPooler1.Host            := EHost.Text;
 RESTClientPooler1.Port            := StrToInt(EPort.Text);
 RESTClientPooler1.UserName        := EdUserNameDW.Text;
 RESTClientPooler1.Password        := EdPasswordDW.Text;
 RESTClientPooler1.DataCompression := cbxCompressao.Checked;
 RESTClientPooler1.AccessTag       := eAccesstag.Text;
 RESTClientPooler1.WelcomeMessage  := eWelcomemessage.Text;
 If chkhttps.Checked then
  RESTClientPooler1.TypeRequest    := TTyperequest.trHttps
 Else
  RESTClientPooler1.TypeRequest    := TTyperequest.trHttp;
 DWClientEvents1.CreateDWParams('servertime', dwParams);
 dwParams.ItemsString['inputdata'].AsString := 'teste de string';
 DWClientEvents1.SendEvent('servertime', dwParams, vErrorMessage);
 If vErrorMessage = '' Then
  Begin
   If dwParams.ItemsString['result'].AsString <> '' Then
    Showmessage('Server Date/Time is : ' + DateTimeToStr(dwParams.ItemsString['result'].Value))
   Else
    Showmessage(vErrorMessage);
   dwParams.ItemsString['result'].SaveToFile('json.txt');
  End
 Else
  Showmessage(vErrorMessage);
 dwParams.Free;
 EHost.Text            := RESTClientPooler1.Host;
 EPort.Text            := IntToStr(RESTClientPooler1.Port);
 EdUserNameDW.Text     := RESTClientPooler1.Username;
 EdPasswordDW.Text     := RESTClientPooler1.Password;
 cbxCompressao.Checked := RESTClientPooler1.DataCompression;
 eAccesstag.Text       := RESTClientPooler1.AccessTag;
 eWelcomemessage.Text  := RESTClientPooler1.WelcomeMessage;
End;

procedure TForm2.Button1Click(Sender: TObject);
Var
 vErrorMessage : String;
 dwParams      : TdwParams;
Begin
 dwParams      := Nil;
 RESTClientPooler1.Host            := EHost.Text;
 RESTClientPooler1.Port            := StrToInt(EPort.Text);
 RESTClientPooler1.UserName        := EdUserNameDW.Text;
 RESTClientPooler1.Password        := EdPasswordDW.Text;
 RESTClientPooler1.DataCompression := cbxCompressao.Checked;
 RESTClientPooler1.AccessTag       := eAccesstag.Text;
 RESTClientPooler1.WelcomeMessage  := eWelcomemessage.Text;
 If chkhttps.Checked then
  RESTClientPooler1.TypeRequest    := TTyperequest.trHttps
 Else
  RESTClientPooler1.TypeRequest    := TTyperequest.trHttp;
 DWClientEvents1.SendEvent('assyncevent', dwParams, vErrorMessage, sePOST, True);
 If vErrorMessage = '' Then
  Showmessage('Assyncevent Executed...')
 Else
  Showmessage(vErrorMessage);
End;

procedure TForm2.cbUseCriptoClick(Sender: TObject);
begin
 RESTDWDataBase1.CriptOptions.Use   := cbUseCripto.Checked;
 RESTClientPooler1.CriptOptions.Use := RESTDWDataBase1.CriptOptions.Use;
end;

Procedure TForm2.FormCreate(Sender: TObject);
Begin
// RESTDWDataBase1.FailOverConnections[0].GetPoolerList;
 Memo1.Lines.Clear;
 labVersao.Caption := uDWConsts.DWVERSAO;
End;

Procedure TForm2.Image2Click(Sender: TObject);
Begin
 Locale_Portugues('ingles');
End;

Procedure TForm2.Image3Click(Sender: TObject);
Begin
 Locale_Portugues('portugues');
End;

Procedure TForm2.Image4Click(Sender: TObject);
Begin
 Locale_Portugues('espanhol');
End;

Procedure TForm2.Locale_Portugues( pLocale : String );
Begin
 If pLocale = 'portugues'     Then
  Begin
   paPortugues.Color     := clWhite;
   paEspanhol.Color      := $002a2a2a;
   paIngles.Color        := $002a2a2a;
   labConexao.Caption    := ' .: CONFIGURAÇÃO DO SERVIDOR';
   labSql.Caption        := ' .: COMANDO SQL';
   labRepsonse.Caption   := ' .: RESPOSTA DO SERVIDOR';
   labResult.Caption     := ' .: RESULTADO DA CONSULTA SQL';
   cbxCompressao.Caption := 'Compressão';
  End
 Else If pLocale = 'ingles'   Then
  Begin
   paPortugues.Color     := $002a2a2a;
   paEspanhol.Color      := $002a2a2a;
   paIngles.Color        := clWhite;
   labConexao.Caption    := ' .: SQL COMMAND';
   labSql.Caption        := ' .: SERVER CONFIGURATION';
   labRepsonse.Caption   := ' .: SQL QUERY RESULT';
   labResult.Caption     := ' .: SQL QUERY RESULT';
   cbxCompressao.Caption := 'Compresión';
  End
 Else If pLocale = 'espanhol' Then
  Begin
   paPortugues.Color     := $002a2a2a;
   paEspanhol.Color      := clWhite;
   paIngles.Color        := $002a2a2a;
   labConexao.Caption    := ' .: CONFIGURATIÓN DEL SERVIDOR';
   labSql.Caption        := ' .: COMANDO SQL';
   labRepsonse.Caption   := ' .: RESPUESTA DEL SERVIDOR';
   labResult.Caption     := ' .: RESULTADO DE LA CONSULTA DE SQL';
   cbxCompressao.Caption := 'Compressão';
  End;
End;

Procedure TForm2.RESTDWDataBase1BeforeConnect(Sender: TComponent);
Begin
 Memo1.Lines.Add(' ');
 Memo1.Lines.Add('**********');
 Memo1.Lines.Add(' ');
End;

Procedure TForm2.RESTDWDataBase1Connection(Sucess: Boolean; Const Error: String);
Begin
 If Sucess Then
  Memo1.Lines.Add(DateTimeToStr(Now) + ' - Database conectado com sucesso.')
 Else
  Memo1.Lines.Add(DateTimeToStr(Now) + ' - Falha de conexão ao Database: ' + Error);
End;

procedure TForm2.RESTDWDataBase1FailOverError(
  ConnectionServer: TRESTDWConnectionServer; MessageError: string);
begin
 Memo1.Lines.Add(Format('FailOver Error(Server %s) : ', [ConnectionServer.Name, MessageError]));
end;

procedure TForm2.RESTDWDataBase1FailOverExecute(
  ConnectionServer: TRESTDWConnectionServer);
begin
 Memo1.Lines.Add('Executando FailOver Servidor : ' + ConnectionServer.Name);
end;

Procedure TForm2.RESTDWDataBase1Status(ASender: TObject; Const AStatus: TIdStatus; Const AStatusText: String);
Begin
 If Self = Nil Then
  Exit;
 Case AStatus Of
   hsResolving:
    Begin
     StatusBar1.Panels[0].Text := 'hsResolving...';
     Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    End;
   hsConnecting:
    Begin
     StatusBar1.Panels[0].Text := 'hsConnecting...';
     Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    End;
   hsConnected:
    Begin
     StatusBar1.Panels[0].Text := 'hsConnected...';
     Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    End;
   hsDisconnecting:
    Begin
     If StatusBar1.Panels.count > 0 Then
      StatusBar1.Panels[0].Text := 'hsDisconnecting...';
     Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    End;
   hsDisconnected:
    Begin
     StatusBar1.Panels[0].Text := 'hsDisconnected...';
     Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    End;
   hsStatusText:
    Begin
     StatusBar1.Panels[0].Text := 'hsStatusText...';
     Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    End;
  // These are to eliminate the TIdFTPStatus and the coresponding event These can be use din the other protocols to.
   ftpTransfer:
    Begin
     StatusBar1.Panels[0].Text := 'ftpTransfer...';
     Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    End;
   ftpReady:
    Begin
     StatusBar1.Panels[0].Text := 'ftpReady...';
     Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    End;
   ftpAborted:
    Begin
     StatusBar1.Panels[0].Text := 'ftpAborted...';
     Memo1.Lines.Add(DateTimeToStr(Now) + ' - ' + AStatusText);
    End;
  End;
End;

Procedure TForm2.RESTDWDataBase1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
Begin
 If FBytesToTransfer = 0 Then // No Update File
  Exit;
 ProgressBar1.Position := AWorkCount;
 ProgressBar1.Update;
End;

Procedure TForm2.RESTDWDataBase1WorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
Begin
 FBytesToTransfer      := AWorkCountMax;
 ProgressBar1.Max      := FBytesToTransfer;
 ProgressBar1.Position := 0;
 ProgressBar1.Update;
End;

Procedure TForm2.RESTDWDataBase1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
Begin
 ProgressBar1.Position := FBytesToTransfer;
 Application.ProcessMessages;
 FBytesToTransfer := 0;
End;

End.
