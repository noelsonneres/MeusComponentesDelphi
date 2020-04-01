{******************************************}
{                                          }
{             FastReport v6.0              }
{           ZipCode Object Editors         }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxZipCodeInPlaceEditor;

interface

{$I frx.inc}

uses
  SysUtils, Types, Classes, Variants, Controls,
  frxClass, frxDsgnIntf;

implementation

uses Math, frxDesgnEditors, frxRes, frxInPlaceEditors, ComCtrls, frxZipCode,
  frxUnicodeCtrls, frxUnicodeUtils;

type
  TfrxInPlaceZipCodeEditor = class(TfrxInPlaceTextEditorBase)
  private
    procedure KeyPress(Sender: TObject; var Key: Char);
  protected
    procedure InitControlFromComponent; override;
    procedure InitComponentFromControl; override;
  end;

{ TfrxInPlaceZipCodeEditor }

procedure TfrxInPlaceZipCodeEditor.InitComponentFromControl;
var
  Zip: TfrxZipCodeView;
begin
  Zip := TfrxZipCodeView(FComponent);
  Zip.Text := FInPlaceMemo.Text;
end;

procedure TfrxInPlaceZipCodeEditor.InitControlFromComponent;
var
  Zip: TfrxZipCodeView;
begin
  Zip := TfrxZipCodeView(FComponent);
  FInPlaceMemo.Text := Zip.Text;
  TUnicodeMemo(FInPlaceMemo).Alignment := taCenter;
  TUnicodeMemo(FInPlaceMemo).Font.Height := -Round(Zip.mmDigitHeight * fr01cm * FScale);
  TUnicodeMemo(FInPlaceMemo).OnKeyPress := KeyPress;
end;

procedure TfrxInPlaceZipCodeEditor.KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    FInPlaceMemo.Modified := False;
    EditDone;
  end
  else if (Key < '0') or (Key > '9') then
    Key := Char(0);
end;

initialization
  frxRegEditorsClasses.Register(TfrxZipCodeView, [TfrxInPlaceZipCodeEditor], [[evPreview]]);

end.
