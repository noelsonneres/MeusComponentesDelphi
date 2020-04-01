
{******************************************}
{                                          }
{             FastReport v5.0              }
{             New item dialog              }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxNewItem;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls
  {$IFDEF FPC}
  , LCLType
  {$ELSE}
  , ImgList
  {$ENDIF}
  ;

type
  TfrxNewItemForm = class(TForm)
    Pages: TPageControl;
    ItemsTab: TTabSheet;
    OkB: TButton;
    CancelB: TButton;
    TemplateTab: TTabSheet;
    InheritCB: TCheckBox;
    TemplateLV: TListView;
    ItemsLV: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ItemsLVDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FTemplates: TStringList;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

uses frxClass, frxDesgn, frxDsgnIntf, {$IFNDEF FPC}frxUtils,{$ENDIF} frxRes;


constructor TfrxNewItemForm.Create(AOwner: TComponent);
begin
  inherited;
  FTemplates := TStringList.Create;
  FTemplates.Sorted := True;
end;

destructor TfrxNewItemForm.Destroy;
begin
  FTemplates.Free;
  inherited;
end;

procedure TfrxNewItemForm.FormCreate(Sender: TObject);
begin
  Caption := frxGet(5300);
  ItemsTab.Caption := frxGet(5301);
  TemplateTab.Caption := frxGet(5302);
  InheritCB.Caption := frxGet(5303);
  OkB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);
  ItemsLV.LargeImages := frxResources.WizardImages;
  TemplateLV.LargeImages := frxResources.WizardImages;

  if UseRightToLeftAlignment then
    FlipChildren(True);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

procedure TfrxNewItemForm.FormShow(Sender: TObject);
var
{$IFDEF FPC}
  i: PtrInt;
{$ELSE}
  i: Integer;
{$ENDIF}
  Item: TfrxWizardItem;
  lvItem: TListItem;
begin
  for i := 0 to frxWizards.Count - 1 do
  begin
    Item := frxWizards[i];
	if Item.ButtonImageIndex = -1 then
   	begin
      if Item.WizardButtonBmp <> nil then
        begin
          frxResources.SetWizardImages(Item.WizardButtonBmp);
          Item.ButtonImageIndex := frxResources.WizardImages.Count - 1;
        end
      else if Item.ButtonBmp <> nil then
        begin
          frxResources.SetWizardImages(Item.ButtonBmp);
          Item.ButtonImageIndex := frxResources.WizardImages.Count - 1;
        end;
    end;

    lvItem := ItemsLV.Items.Add;
    lvItem.Caption := Item.ClassRef.GetDescription;
    lvItem.Data := Item;
    lvItem.ImageIndex := Item.ButtonImageIndex;
  end;

  TfrxDesignerForm(Owner).GetTemplateList(FTemplates);
  for i := 0 to FTemplates.Count - 1 do
  begin
    lvItem := TemplateLV.Items.Add;
    lvItem.Caption := ExtractFileName(FTemplates[i]);
{$IFDEF FPC}
    lvItem.Data := TObject(i);
{$ELSE}
    lvItem.Data := Pointer(i);
{$ENDIF}

    lvItem.ImageIndex := 5;
  end;
end;

procedure TfrxNewItemForm.ItemsLVDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrxNewItemForm.FormDestroy(Sender: TObject);
var
  w: TfrxCustomWizard;
  ADesigner: TfrxDesignerForm;
  Report: TfrxReport;
  templ: String;
begin
  if ModalResult = mrOk then
  begin
    if (Pages.ActivePage = ItemsTab) and (ItemsLV.Selected <> nil) then
    begin
      w := TfrxCustomWizard(TfrxWizardItem(ItemsLV.Selected.Data).ClassRef.NewInstance);
      w.Create(Owner);
      if w.Execute then
        w.Designer.Modified := True;
      w.Free;
    end
    else if (Pages.ActivePage = TemplateTab) and (TemplateLV.Selected <> nil) then
    begin
      ADesigner := TfrxDesignerForm(Owner);
      Report := ADesigner.Report;
{$IFDEF FPC}
      templ := FTemplates[PtrInt(TObject(TemplateLV.Selected.Data))];
{$ELSE}
      templ := FTemplates[Integer(TemplateLV.Selected.Data)];
{$ENDIF}
      ADesigner.Lock;
      try
        Report.Clear;
        if InheritCB.Checked then
          Report.ParentReport := ExtractRelativePath(
            Report.GetApplicationFolder, templ)
        else
        begin
          if Assigned(Report.OnLoadTemplate) then
            Report.OnLoadTemplate(Report, templ)
          else
            Report.LoadFromFile(templ);
        end;
      finally
        Report.FileName := '';
        ADesigner.ReloadReport;
      end;
    end;
  end;
end;

procedure TfrxNewItemForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

end.
