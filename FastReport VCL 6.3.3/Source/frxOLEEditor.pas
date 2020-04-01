
{******************************************}
{                                          }
{             FastReport v5.0              }
{            OLE design editor             }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxOLEEditor;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows,
  {$ENDIF}
  Classes, SysUtils, Graphics, Controls, StdCtrls, Forms, Menus,
  Dialogs, frxClass, frxCustomEditors, frxDsgnIntf, frxOLE
  {$IFNDEF FPC}
  , OleCtnrs
  {$ENDIF}
  {$IFDEF FPC}
  , LResources, LCLType, LazHelper
  {$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxOLEEditor = class(TfrxViewEditor)
  public
    function Edit: Boolean; override;
    function HasEditor: Boolean; override;
    procedure GetMenuItems; override;
    function Execute(Tag: Integer; Checked: Boolean): Boolean; override;
  end;

  TfrxOleEditorForm = class(TForm)
    InsertB: TButton;
    EditB: TButton;
    CloseB: TButton;
    OleContainer: TOleContainer;
    procedure InsertBClick(Sender: TObject);
    procedure EditBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$IFNDEF FPC}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses frxRes;


{ TfrxOLEEditor }

function TfrxOLEEditor.HasEditor: Boolean;
begin
  Result := True;
end;

function TfrxOLEEditor.Edit: Boolean;
begin
  with TfrxOleEditorForm.Create(Designer) do
  begin
    frxAssignOLE(TfrxOLEView(Component).OleContainer, OleContainer);
    Result := ShowModal = mrOk;
    if Result then
      frxAssignOLE(OleContainer, TfrxOLEView(Component).OleContainer);
    Free;
  end;
end;

function TfrxOLEEditor.Execute(Tag: Integer; Checked: Boolean): Boolean;
var
  i: Integer;
  c: TfrxComponent;
  v: TfrxOLEView;
begin
  Result := inherited Execute(Tag, Checked);
  for i := 0 to Designer.SelectedObjects.Count - 1 do
  begin
    c := TfrxComponent(Designer.SelectedObjects[i]);
    if (c is TfrxOLEView) and not (rfDontModify in c.Restrictions) then
    begin
      v := TfrxOLEView(c);
      if Tag = 1 then
        v.Stretched := Checked;
      Result := True;
    end;
  end;
end;

procedure TfrxOLEEditor.GetMenuItems;
var
  v: TfrxOLEView;
begin
  v := TfrxOLEView(Component);
  AddItem(frxResources.Get('mvHyperlink'), 50);
  AddItem('-', -1);
  AddItem(frxResources.Get('olStretched'), 1, v.Stretched);
  inherited;
end;


{ TfrxOLEEditorForm }

procedure TfrxOleEditorForm.InsertBClick(Sender: TObject);
begin
  {$IFNDEF FPC}
  OleContainer.InsertObjectDialog;
  {$ENDIF}
end;

procedure TfrxOleEditorForm.EditBClick(Sender: TObject);
begin
  {$IFNDEF FPC}
  if OleContainer.OleObjectInterface <> nil then
    OleContainer.DoVerb(ovPrimary);
  {$ENDIF}
end;

procedure TfrxOleEditorForm.FormCreate(Sender: TObject);
begin
  Caption := frxGet(3400);
  InsertB.Caption := frxGet(3401);
  EditB.Caption := frxGet(3402);
  CloseB.Caption := frxGet(3403);

  if UseRightToLeftAlignment then
    FlipChildren(True);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;


procedure TfrxOleEditorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

initialization
  frxComponentEditors.Register(TfrxOLEView, TfrxOLEEditor);


end.
