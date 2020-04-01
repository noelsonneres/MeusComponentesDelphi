
{******************************************}
{                                          }
{             FastReport v5.0              }
{              Search dialog               }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxSearchDialog;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls
  {$IFDEF FPC}
  , LResources, LCLType
  {$ENDIF}
  ;

type
  TfrxSearchDialog = class(TForm)
    ReplacePanel: TPanel;
    ReplaceL: TLabel;
    ReplaceE: TEdit;
    Panel2: TPanel;
    TextL: TLabel;
    TextE: TEdit;
    Panel3: TPanel;
    OkB: TButton;
    CancelB: TButton;
    SearchL: TGroupBox;
    CaseCB: TCheckBox;
    TopCB: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
  private
  public
  end;


implementation

uses frxRes;

{$IFNDEF FPC}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

var
  LastText: String;

procedure TfrxSearchDialog.FormCreate(Sender: TObject);
begin
  Caption := frxGet(300);
  TextL.Caption := frxGet(301);
  SearchL.Caption := frxGet(302);
  ReplaceL.Caption := frxGet(303);
  TopCB.Caption := frxGet(304);
  CaseCB.Caption := frxGet(305);
  OkB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);

  if UseRightToLeftAlignment then
    FlipChildren(True);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

procedure TfrxSearchDialog.FormShow(Sender: TObject);
begin
  TextE.Text := LastText;
end;

procedure TfrxSearchDialog.FormHide(Sender: TObject);
begin
  if ModalResult = mrOk then
    LastText := TextE.Text;
end;

procedure TfrxSearchDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxSearchDialog.FormActivate(Sender: TObject);
begin
  TextE.SetFocus;
  TextE.SelectAll;
end;

end.

