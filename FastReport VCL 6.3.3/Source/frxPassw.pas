
{******************************************}
{                                          }
{             FastReport v5.0              }
{              Password form               }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxPassw;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls
  {$IFDEF FPC}
  , LResources
  {$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};
  

type
  TfrxPasswordForm = class(TForm)
    OkB: TButton;
    CancelB: TButton;
    PasswordE: TEdit;
    PasswordL: TLabel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
  public
  end;


implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses frxRes;


procedure TfrxPasswordForm.FormCreate(Sender: TObject);
begin
  Caption := frxGet(5000);
  PasswordL.Caption := frxGet(5001);
  OkB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);

  if UseRightToLeftAlignment then
    FlipChildren(True);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

end.
