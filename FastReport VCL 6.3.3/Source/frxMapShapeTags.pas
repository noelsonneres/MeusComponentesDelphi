
{******************************************}
{                                          }
{             FastReport v5.0              }
{             Map Shape Tags               }
{                                          }
{        Copyright (c) 2016 - 2017         }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapShapeTags;

{$I frx.inc}

interface

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ELSE}
  LCLType, LCLIntf, LCLProc,
  {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMapShapeTagsForm = class(TForm)
    CancelB: TButton;
    OkB: TButton;
    Memo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  public
    { Public declarations }
  end;

implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  frxDsgnIntf, frxMapShape, frxRes, frxMapHelpers;

type
  TfrxMapShapeTagsProperty = class(TfrxClassProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
  end;

{ TMapShapeTagsForm }

procedure TMapShapeTagsForm.FormCreate(Sender: TObject);
begin
  Translate(Self);
end;

procedure TMapShapeTagsForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

{ TfrxMapShapeTagsProperty }

function TfrxMapShapeTagsProperty.Edit: Boolean;
var
  MSStringList: TStringList;
begin
  MSStringList := TShape(Component).ShapeTags;

  with TMapShapeTagsForm.Create(Designer) do
    try
      Memo.Lines.Assign(MSStringList);
      Result := ShowModal = mrOk;
      if Result then
        MSStringList.Assign(Memo.Lines);
    finally
      Free;
    end;
end;

function TfrxMapShapeTagsProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

initialization

  frxPropertyEditors.Register(TypeInfo(TStringList), TShape, 'ShapeTags',
    TfrxMapShapeTagsProperty);

end.
