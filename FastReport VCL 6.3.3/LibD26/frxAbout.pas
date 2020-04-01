
{******************************************}
{                                          }
{             FastReport v5.0              }
{              About window                }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxAbout;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls
  {$IFDEF FPC}
  , LCLType, LCLIntf
  {$ENDIF}
  ;

type
  TfrxAboutForm = class(TForm)
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Image1: TImage;
    Bevel2: TBevel;
    Label5: TLabel;
    Shape1: TShape;
    Label1: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure LabelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  {$IFDEF FR_COM}
    LabelVer: Tlabel;
  {$ENDIF}
  public
    { Public declarations }
  end;


implementation

uses frxClass, frxRes

{$IFNDEF FPC} , frxUtils , ShellApi {$ENDIF}
{$IFDEF FR_COM}, Registry{$ENDIF};

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

procedure TfrxAboutForm.FormCreate(Sender: TObject);
{$IFDEF FR_COM}
var
  r: TRegistry;
  s: String;
{$ENDIF}
begin
  Caption := frxGet(2600);
  Label4.Caption := frxGet(2601);
  Label6.Caption := frxGet(2602);
  Label8.Caption := frxGet(2603);
  Label2.Caption := 'Version ' + FR_VERSION;
  Label10.Caption := String(#174);
  {$IFDEF FR_COM}
  LabelVer := TLabel.Create(Self);
  LabelVer.AutoSize := False;
  LabelVer.Alignment := taRightJustify;
  LabelVer.Left := 93;
  LabelVer.Top := 70;
  LabelVer.Width := 148;
  LabelVer.Parent := Self;
  LabelVer.Font.Name := 'Tahoma';
  LabelVer.Font.Size := 8;
  LabelVer.Caption := 'Studio';
  r := TRegistry.Create;
  try
    r.RootKey := HKEY_CURRENT_USER;
    if r.OpenKeyReadOnly('Software\Fast Reports\Studio') then
    begin
      s := Copy(r.ReadString('Serial'), 12, 3);
      if s = 'TSN' then
        LabelVer.Caption := LabelVer.Caption + ' Business';
      if s = 'TTM' then
        LabelVer.Caption := LabelVer.Caption + ' Team';
      if s = 'TCM' then
        LabelVer.Caption := LabelVer.Caption + ' Company';
      if s = 'TPR' then
        LabelVer.Caption := LabelVer.Caption + ' Personal';
{$IFDEF OLAP}
      if s = 'TBA' then
        LabelVer.Caption := LabelVer.Caption + ' Business Analytic';
{$ENDIF}        
    end;
  finally
    r.Free;
  end;
  {$ENDIF}
  Label3.Caption := '(c) 1998-' + FormatDateTime('YYYY', Now) + ' by Alexander Tzyganenko, Fast Reports Inc.';
  if UseRightToLeftAlignment then
    FlipChildren(True);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

procedure TfrxAboutForm.LabelClick(Sender: TObject);
begin
  {$IFDEF FPC}
  if TLabel(Sender).Tag = 1 then
    LCLIntf.OpenURL(TLabel(Sender).Caption)
  else
  if TLabel(Sender).Tag = 2 then
  begin
    ShowMessage('mailto: is not implemented in LCL');
  end;
  {$ELSE}
  case TLabel(Sender).Tag of
    1: ShellExecute(GetDesktopWindow, 'open',
      PChar(TLabel(Sender).Caption), nil, nil, sw_ShowNormal);
    2: ShellExecute(GetDesktopWindow, 'open',
      PChar('mailto:' + TLabel(Sender).Caption), nil, nil, sw_ShowNormal);
  end;
  {$ENDIF}
end;

procedure TfrxAboutForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TfrxAboutForm.FormDestroy(Sender: TObject);
begin
 {$IFDEF FR_COM}
 LabelVer.Free;
 {$ENDIF}
end;

end.

