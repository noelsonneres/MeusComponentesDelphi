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

unit frxRichInPlaceEditor;

interface

{$I frx.inc}

uses
  SysUtils, Types, Classes, Variants, Controls,
  frxClass, frxDsgnIntf;

implementation

uses Math, Graphics, Forms, Windows, Messages, frxDesgnEditors, frxRes, frxInPlaceEditors, ComCtrls, frxZipCode,
  frxUnicodeCtrls, frxUnicodeUtils, RichEdit,
  frxRichEdit, frxRich;

type
  TfrxRichInPlaceEditor = class(TfrxInPlaceMemoEditorBase)
  protected
    procedure InitControlFromComponent; override;
    procedure InitComponentFromControl; override;
    procedure CreateMemo; override;
  public
    procedure DrawCustomEditor(aCanvas: TCanvas; aRect: TRect); override;
  end;

  THackWinControl = class(TWinControl);
{ TfrxRichInPlaceEditor }

procedure TfrxRichInPlaceEditor.CreateMemo;
begin
  FInPlaceMemo := TRxUnicodeRichEdit.Create(FOwner);
end;

procedure TfrxRichInPlaceEditor.DrawCustomEditor(aCanvas: TCanvas;
  aRect: TRect);
  var
    R: TRect;
begin
  inherited;
  TRxUnicodeRichEdit(FInPlaceMemo).Invalidate;
  TRxUnicodeRichEdit(FInPlaceMemo).Perform(EM_FORMATRANGE, 0, 0);
  with TRxUnicodeRichEdit(FInPlaceMemo) do
  begin
    R := Rect(0, 0, ClientWidth, ClientHeight);
    SendMessage(Handle, EM_SETRECT, 0, LPARAM(@R));
  end;
end;

procedure TfrxRichInPlaceEditor.InitComponentFromControl;
var
  Rich: TfrxRichView;
begin
  Rich := TfrxRichView(FComponent);
  frxAssignRich(TRxUnicodeRichEdit(FInPlaceMemo), Rich.RichEdit);
end;

procedure TfrxRichInPlaceEditor.InitControlFromComponent;
var
  Rich: TfrxRichView;
    R: TRect;
begin
  Rich := TfrxRichView(FComponent);
  frxAssignRich(Rich.RichEdit, TRxUnicodeRichEdit(FInPlaceMemo));
end;

initialization
  frxRegEditorsClasses.Register(TfrxRichView, [TfrxRichInPlaceEditor], [[evPreview]]);

end.
