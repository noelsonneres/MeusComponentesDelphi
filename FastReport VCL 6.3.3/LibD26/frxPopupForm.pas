
{******************************************}
{                                          }
{             FastReport v5.0              }
{     Parent form for pop-up controls      }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxPopupForm;

interface

{$I frx.inc}

uses
  SysUtils,
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls
  {$IFDEF FPC}
  , LResources, LCLType, LCLIntf, LCLProc
  {$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};
  

type
  TfrxPopupForm = class(TForm)
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frxPopupFormCloseTime: UInt = 0;


implementation

{$IFNDEF FPC}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}


procedure TfrxPopupForm.FormDeactivate(Sender: TObject);
begin
  frxPopupFormCloseTime := GetTickCount;
  Close;
end;

procedure TfrxPopupForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if ModalResult = mrNone then
    CloseAction := caFree;
end;

end.
