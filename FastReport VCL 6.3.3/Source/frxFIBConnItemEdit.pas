unit frxFIBConnItemEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrxFIBConnItem = class(TForm)
    OKB: TButton;
    CancelB: TButton;
    BaseDlg: TOpenDialog;
    ClientDlg: TOpenDialog;
    GroupBox1: TGroupBox;
    SystemRB: TRadioButton;
    UserRB: TRadioButton;
    NameE: TEdit;
    NameL: TLabel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    RoleL: TLabel;
    PasswordL: TLabel;
    UserNameL: TLabel;
    AliasL: TLabel;
    BaseL: TLabel;
    BaseE: TEdit;
    AliasE: TEdit;
    UserNameE: TEdit;
    PasswordE: TEdit;
    RoleE: TEdit;
    LibE: TEdit;
    LibB: TButton;
    AddM: TMemo;
    AddL: TLabel;
    BaseB: TButton;
    procedure BaseBClick(Sender: TObject);
    procedure LibBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frxFIBConnItem: TfrxFIBConnItem;

implementation

{$R *.dfm}

procedure TfrxFIBConnItem.BaseBClick(Sender: TObject);
begin
  BaseDlg.FileName := BaseE.Text;
  if BaseDlg.Execute then
    BaseE.Text := BaseDlg.FileName;
end;

procedure TfrxFIBConnItem.LibBClick(Sender: TObject);
begin
  ClientDlg.FileName := LibE.Text;
  if ClientDlg.Execute then
    LibE.Text := ClientDlg.FileName;
end;

end.
