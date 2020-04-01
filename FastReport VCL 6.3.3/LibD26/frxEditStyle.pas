
{******************************************}
{                                          }
{             FastReport v5.0              }
{              Style editor                }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxEditStyle;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls,
  {$IFDEF FPC}
  LCLType,
  {$ELSE}
  ToolWin, ImgList,
  {$ENDIF}
  frxClass, frxDesgnCtrls;

type
  TfrxStyleEditorForm = class(TForm)
    ToolBar: TToolBar;
    AddB: TToolButton;
    DeleteB: TToolButton;
    Sep1: TToolButton;
    LoadB: TToolButton;
    SaveB: TToolButton;
    Sep2: TToolButton;
    CancelB: TToolButton;
    OkB: TToolButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    StylesTV: TTreeView;
    EditB: TToolButton;
    PaintBox: TPaintBox;
    ColorB: TButton;
    FontB: TButton;
    FrameB: TButton;
    DefCB: TCheckBox;
    ApplyFillCB: TCheckBox;
    ApplyFontCB: TCheckBox;
    ApplyFrameCB: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CancelBClick(Sender: TObject);
    procedure OkBClick(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure AddBClick(Sender: TObject);
    procedure DeleteBClick(Sender: TObject);
    procedure LoadBClick(Sender: TObject);
    procedure SaveBClick(Sender: TObject);
    procedure BClick(Sender: TObject);
    procedure StylesTVClick(Sender: TObject);
    procedure StylesTVEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure EditBClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DefCBClick(Sender: TObject);
    procedure ApplyFillCBClick(Sender: TObject);
  private
    FImageList: TImageList;
    FReport: TfrxReport;
    FStyles: TfrxStyles;
    FIsLocked: Boolean;
    FontColorCB: TfrxColorComboBox;
    procedure FontColorCBChanged(Sender: TObject);
    procedure UpdateStyles(Focus: Integer = 0);
    procedure UpdateControls;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

uses frxDesgn, frxEditFrame, frxEditFill, frxRes;


constructor TfrxStyleEditorForm.Create(AOwner: TComponent);
begin
  inherited;
  FStyles := TfrxStyles.Create(nil);
  FIsLocked := False;
end;

destructor TfrxStyleEditorForm.Destroy;
begin
  FStyles.Free;
  inherited;
end;

procedure TfrxStyleEditorForm.FormCreate(Sender: TObject);
begin
  Caption := frxGet(5100);
  ColorB.Caption := frxGet(5101);
  FontB.Caption := frxGet(5102);
  FrameB.Caption := frxGet(5103);
  AddB.Hint := frxGet(5104);
  DeleteB.Hint := frxGet(5105);
  EditB.Hint := frxGet(5106);
  LoadB.Hint := frxGet(5107);
  SaveB.Hint := frxGet(5108);
  CancelB.Hint := frxGet(2);
  OkB.Hint := frxGet(1);
  DefCB.Caption := frxGet(2480);

  FReport := TfrxCustomDesigner(Owner).Report;
  FImageList := frxResources.MainButtonImages;
  ToolBar.Images := FImageList;

  FontColorCB := TfrxColorComboBox.Create(Self);
  FontColorCB.Parent := Self;
  FontColorCB.SetBounds(DefCB.Left, FontB.Top + 3, DefCB.Width, DefCB.Height);
  FontColorCB.ShowColorName := True;
  FontColorCB.OnColorChanged := FontColorCBChanged;

  if UseRightToLeftAlignment then
    FlipChildren(True);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

procedure TfrxStyleEditorForm.FontColorCBChanged(Sender: TObject);
var
  Style: TfrxStyleItem;
begin
  if StylesTV.Selected = nil then Exit;
  Style := TfrxStyleItem(StylesTV.Selected.Data);
  Style.Font.Color := FontColorCB.Color;
  PaintBoxPaint(nil);
end;

procedure TfrxStyleEditorForm.FormShow(Sender: TObject);
begin
  FStyles.Assign(FReport.Styles);
  UpdateStyles;
end;

procedure TfrxStyleEditorForm.FormHide(Sender: TObject);
begin
  if ModalResult = mrOk then
    FReport.Styles.Assign(FStyles);
end;

procedure TfrxStyleEditorForm.UpdateStyles(Focus: Integer = 0);
var
  i: Integer;
  Node: TTreeNode;
begin
  StylesTV.Items.BeginUpdate;
  StylesTV.Items.Clear;
  for i := 0 to FStyles.Count - 1 do
  begin
    Node := StylesTV.Items.AddChild(nil, FStyles[i].Name);
    Node.Data := FStyles[i];
  end;
  StylesTV.Items.EndUpdate;

  if Focus >= StylesTV.Items.Count then
    Focus := StylesTV.Items.Count - 1;
  if Focus <> -1 then
    StylesTV.Selected := StylesTV.Items[Focus];
  StylesTVClick(nil);
end;

procedure TfrxStyleEditorForm.UpdateControls;
var
  Style: TfrxStyleItem;
  b: Boolean;
begin
  b := StylesTV.Selected <> nil;
  LoadB.Enabled := not FReport.IsAncestor;
  ColorB.Enabled := b;
  FontB.Enabled := b;
  FontColorCB.Enabled := FontB.Enabled;
  if b then FontColorCB.Color := TfrxStyleItem(StylesTV.Selected.Data).Font.Color;
  FrameB.Enabled := b;
  ApplyFillCB.Enabled := b;
  ApplyFrameCB.Enabled := b;
  ApplyFontCB.Enabled := b;
  if StylesTV.Selected = nil then Exit;
  Style := TfrxStyleItem(StylesTV.Selected.Data);
  FIsLocked := True;
  ApplyFillCB.Checked := Style.ApplyFill;
  ApplyFrameCB.Checked := Style.ApplyFrame;
  ApplyFontCB.Checked := Style.ApplyFont;
  FIsLocked := False;
  ColorB.Enabled := Style.ApplyFill;
  FontB.Enabled := Style.ApplyFont;
  FontColorCB.Enabled := FontB.Enabled;
  if FontColorCB.Enabled then FontColorCB.Color := Style.Font.Color;
  FrameB.Enabled := Style.ApplyFrame;
  DeleteB.Enabled := not Style.IsInherited;
  EditB.Enabled := not Style.IsInherited;
  DefCB.Checked := Style.Font.Charset = DEFAULT_CHARSET;
end;

procedure TfrxStyleEditorForm.PaintBoxPaint(Sender: TObject);
var
  m: TfrxMemoView;
begin
  with PaintBox.Canvas do
  begin
    Brush.Color := clWindow;
    Pen.Color := clGray;
    Pen.Width := 1;
    Pen.Style := psSolid;
    Rectangle(0, 0, PaintBox.Width, PaintBox.Height);
  end;
  if StylesTV.Selected = nil then Exit;

  m := TfrxMemoView.Create(nil);
  m.ApplyStyle(TfrxStyleItem(StylesTV.Selected.Data));
  m.Text := frxResources.Get('dsStyleSample');
  m.GapX := 20;
  m.GapY := 10;
  m.Width := m.CalcWidth;
  m.Height := m.CalcHeight;
  m.Left := (PaintBox.Width - m.Width) / 2;
  m.Top := (PaintBox.Height - m.Height) / 2;
  m.Draw(PaintBox.Canvas, 1, 1, 0, 0);
  m.Free;
end;

procedure TfrxStyleEditorForm.StylesTVClick(Sender: TObject);
begin
  UpdateControls;
  PaintBoxPaint(nil);
end;

procedure TfrxStyleEditorForm.BClick(Sender: TObject);
var
  Style: TfrxStyleItem;
begin
  if StylesTV.Selected = nil then Exit;
  Style := TfrxStyleItem(StylesTV.Selected.Data);

  case TControl(Sender).Tag of
    2:
      with TfrxFillEditorForm.Create(Self) do
      begin
        Fill := Style.Fill;
        if ShowModal = mrOk then
        begin
          Style.FillType := frxGetFillType(Fill);
          Style.Fill.Assign(Fill);
        end;
        Free;
      end;
    3:
      with TFontDialog.Create(Application) do
      begin
        Font := Style.Font;
        Options := Options + [fdForceFontExist];
        if Execute then
          begin
            Style.Font := Font;
            FontColorCB.Color := Font.Color;
          end;
        if DefCB.Checked then
          Style.Font.Charset := DEFAULT_CHARSET;
        Free;
      end;

    4:
      with TfrxFrameEditorForm.Create(Owner) do
      begin
        Frame.Assign(Style.Frame);
        if ShowModal = mrOk then
          Style.Frame := Frame;
        Free;
      end;
  end;

  PaintBoxPaint(nil);
end;

procedure TfrxStyleEditorForm.AddBClick(Sender: TObject);
begin
  FStyles.Add.CreateUniqueName;
  UpdateStyles(FStyles.Count - 1);
  StylesTV.Selected.EditText;
end;

procedure TfrxStyleEditorForm.DeleteBClick(Sender: TObject);
begin
  if StylesTV.Selected = nil then Exit;
  TfrxStyleItem(StylesTV.Selected.Data).Free;
  UpdateStyles(StylesTV.Selected.Index);
end;

procedure TfrxStyleEditorForm.LoadBClick(Sender: TObject);
begin
  OpenDialog.Filter := frxResources.Get('dsStyleFile') + ' (*.fs3)|*.fs3';
  if frxDesignerComp <> nil then
    OpenDialog.InitialDir := frxDesignerComp.OpenDir;
  if OpenDialog.Execute then
  begin
    FStyles.LoadFromFile(OpenDialog.FileName);
    UpdateStyles;
  end;
end;

procedure TfrxStyleEditorForm.SaveBClick(Sender: TObject);
begin
  SaveDialog.Filter := frxResources.Get('dsStyleFile') + ' (*.fs3)|*.fs3';
  if frxDesignerComp <> nil then
    SaveDialog.InitialDir := frxDesignerComp.SaveDir;
  if SaveDialog.Execute then
    FStyles.SaveToFile(ChangeFileExt(SaveDialog.FileName, '.fs3'));
end;

procedure TfrxStyleEditorForm.CancelBClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrxStyleEditorForm.OkBClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrxStyleEditorForm.StylesTVEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
var
  Style: TfrxStyleItem;
begin
  if not EditB.Enabled then
  begin
    S := Node.Text;
    Exit;
  end;
  Style := TfrxStyleItem(Node.Data);
  Style.Name := s;
end;

procedure TfrxStyleEditorForm.EditBClick(Sender: TObject);
begin
  if StylesTV.Selected = nil then Exit;
  StylesTV.Selected.EditText;
end;

procedure TfrxStyleEditorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
  if Key = VK_F2 then
    EditBClick(nil);
end;

procedure TfrxStyleEditorForm.DefCBClick(Sender: TObject);
var
  Style: TfrxStyleItem;
begin
  if (StylesTV.Selected = nil) or not DefCB.Checked then Exit;
  Style := TfrxStyleItem(StylesTV.Selected.Data);
  Style.Font.Charset := DEFAULT_CHARSET;
end;

procedure TfrxStyleEditorForm.ApplyFillCBClick(Sender: TObject);
var
  Style: TfrxStyleItem;
begin
  if (StylesTV.Selected = nil) or (FIsLocked) then Exit;
  Style := TfrxStyleItem(StylesTV.Selected.Data);
  Style.ApplyFont := ApplyFontCB.Checked;
  Style.ApplyFill := ApplyFillCB.Checked;
  Style.ApplyFrame := ApplyFrameCB.Checked;
  UpdateControls;
  PaintBoxPaint(nil);
end;

end.
