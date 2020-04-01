unit frxEditHyperlink;

interface

{$I frx.inc}

uses
{$IFDEF FPC}
  LCLType, LMessages, LazHelper, LCLIntf,
{$ELSE}
  Windows, Messages,
{$ENDIF}  
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, frxClass, frxCtrls
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxHyperlinkEditorForm = class(TForm)
    OKB: TButton;
    CancelB: TButton;
    KindGB: TGroupBox;
    UrlRB: TRadioButton;
    PageNumberRB: TRadioButton;
    AnchorRB: TRadioButton;
    ReportRB: TRadioButton;
    ReportPageRB: TRadioButton;
    CustomRB: TRadioButton;
    PropertiesGB: TGroupBox;
    UrlP: TPanel;
    UrlL: TLabel;
    UrlE: TEdit;
    UrlExprL: TLabel;
    UrlExprE: TfrxComboEdit;
    Hint1L: TLabel;
    Hint2L: TLabel;
    PageNumberP: TPanel;
    PageNumberL: TLabel;
    PageNumberExprL: TLabel;
    PageNumberE: TEdit;
    PageNumberExprE: TfrxComboEdit;
    AnchorP: TPanel;
    AnchorL: TLabel;
    AnchorExprL: TLabel;
    AnchorE: TEdit;
    AnchorExprE: TfrxComboEdit;
    CustomP: TPanel;
    CustomL: TLabel;
    CustomExprL: TLabel;
    CustomE: TEdit;
    CustomExprE: TfrxComboEdit;
    ReportP: TPanel;
    ReportValueL: TLabel;
    ReportExprL: TLabel;
    ReportValueE: TEdit;
    ReportExprE: TfrxComboEdit;
    ReportNameL: TLabel;
    ReportNameE: TfrxComboEdit;
    ReportParamL: TLabel;
    ReportParamCB: TComboBox;
    ReportPageP: TPanel;
    ReportPageValueL: TLabel;
    ReportPageExprL: TLabel;
    ReportPageL: TLabel;
    ReportPageParamL: TLabel;
    ReportPageValueE: TEdit;
    ReportPageExprE: TfrxComboEdit;
    ReportPageParamCB: TComboBox;
    ReportPageCB: TComboBox;
    OpenDialog: TOpenDialog;
    ModifyAppearanceCB: TCheckBox;
    procedure UrlRBClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ExprClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure ReportNameEButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure FillVariablesList(Report: TfrxReport; List: TStrings); overload;
    procedure FillVariablesList(const FileName: String; List: TStrings); overload;
    procedure FillPagesList;
  public
    { Public declarations }
    View: TfrxView;
  end;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

uses frxRes;


procedure TfrxHyperlinkEditorForm.FormCreate(Sender: TObject);
begin
  Text := frxGet(6200);
  KindGB.Caption := frxGet(6201);
  UrlRB.Caption := frxGet(6202);
  PageNumberRB.Caption := frxGet(6203);
  AnchorRB.Caption := frxGet(6204);
  ReportRB.Caption := frxGet(6205);
  ReportPageRB.Caption := frxGet(6206);
  CustomRB.Caption := frxGet(6207);
  PropertiesGB.Caption := frxGet(6208);
  UrlL.Caption := frxGet(6209);
  UrlExprL.Caption := frxGet(6210);
  PageNumberL.Caption := frxGet(6211);
  PageNumberExprL.Caption := frxGet(6212);
  AnchorL.Caption := frxGet(6213);
  AnchorExprL.Caption := frxGet(6214);
  ReportNameL.Caption := frxGet(6215);
  ReportParamL.Caption := frxGet(6216);
  ReportValueL.Caption := frxGet(6217);
  ReportExprL.Caption := frxGet(6218);
  ReportPageL.Caption := frxGet(6219);
  ReportPageParamL.Caption := frxGet(6216);
  ReportPageValueL.Caption := frxGet(6217);
  ReportPageExprL.Caption := frxGet(6218);
  CustomL.Caption := frxGet(6220);
  CustomExprL.Caption := frxGet(6221);
  Hint1L.Caption := frxGet(6222);
  ModifyAppearanceCB.Caption := frxGet(6229);
  OpenDialog.Filter := frxGet(2471);
  OKB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

procedure TfrxHyperlinkEditorForm.FillVariablesList(Report: TfrxReport; List: TStrings);
var
  i: Integer;
  s: String;
begin
  List.Clear;
  for i := 0 to Report.Variables.Count - 1 do
  begin
    s := Report.Variables.Items[i].Name;
    if s <> '' then
      if s[1] <> ' ' then
        List.Add(s);
  end;
end;

procedure TfrxHyperlinkEditorForm.FillVariablesList(const FileName: String; List: TStrings);
var
  Report: TfrxReport;
begin
  Report := TfrxReport.Create(nil);
  try
    Report.LoadFromFile(FileName);
    FillVariablesList(Report, List);
  except
    List.Clear;
  end;
  Report.Free;
end;

procedure TfrxHyperlinkEditorForm.FillPagesList;
var
  i: Integer;
  p: TfrxPage;
begin
  ReportPageCB.Items.Clear;
  for i := 0 to TfrxCustomDesigner(Self.Owner).Report.PagesCount - 1 do
  begin
    p := TfrxCustomDesigner(Self.Owner).Report.Pages[i];
    if (p is TfrxReportPage) and (TfrxCustomDesigner(Self.Owner).Page <> p) then
      ReportPageCB.Items.Add(p.Name);
  end;
end;

procedure TfrxHyperlinkEditorForm.UrlRBClick(Sender: TObject);
begin
  UrlP.Visible := UrlRB.Checked;
  PageNumberP.Visible := PageNumberRB.Checked;
  AnchorP.Visible := AnchorRB.Checked;
  ReportP.Visible := ReportRB.Checked;
  ReportPageP.Visible := ReportPageRB.Checked;
  CustomP.Visible := CustomRB.Checked;

  UrlP.Left := 12; UrlP.Top := 20;
  PageNumberP.Left := 12; PageNumberP.Top := 20;
  AnchorP.Left := 12; AnchorP.Top := 20;
  ReportP.Left := 12; ReportP.Top := 20;
  ReportPageP.Left := 12; ReportPageP.Top := 20;
  CustomP.Left := 12; CustomP.Top := 20;

  if UrlRB.Checked then
    Hint2L.Caption := frxGet(6223)
  else if PageNumberRB.Checked then
    Hint2L.Caption := frxGet(6224)
  else if AnchorRB.Checked then
    Hint2L.Caption := frxGet(6225)
  else if ReportRB.Checked then
    Hint2L.Caption := frxGet(6226)
  else if ReportPageRB.Checked then
    Hint2L.Caption := frxGet(6227)
  else if CustomRB.Checked then
    Hint2L.Caption := frxGet(6228);
end;

procedure TfrxHyperlinkEditorForm.FormShow(Sender: TObject);
begin
  FillVariablesList(TfrxCustomDesigner(Self.Owner).Report, ReportPageParamCB.Items);
  FillPagesList;

  case View.Hyperlink.Kind of
    hkURL:
      begin
        UrlRB.Checked := True;
        UrlE.Text := View.Hyperlink.Value;
        UrlExprE.Text := View.Hyperlink.Expression;
      end;
    hkPageNumber:
      begin
        PageNumberRB.Checked := True;
        PageNumberE.Text := View.Hyperlink.Value;
        PageNumberExprE.Text := View.Hyperlink.Expression;
      end;
    hkAnchor:
      begin
        AnchorRB.Checked := True;
        AnchorE.Text := View.Hyperlink.Value;
        AnchorExprE.Text := View.Hyperlink.Expression;
      end;
    hkDetailReport:
      begin
        ReportRB.Checked := True;
        ReportNameE.Text := View.Hyperlink.DetailReport;
        ReportParamCB.Text := View.Hyperlink.ReportVariable;
        ReportValueE.Text := View.Hyperlink.Value;
        ReportExprE.Text := View.Hyperlink.Expression;
        FillVariablesList(View.Hyperlink.DetailReport, ReportParamCB.Items);
      end;
    hkDetailPage:
      begin
        ReportPageRB.Checked := True;
        ReportPageCB.ItemIndex := ReportPageCB.Items.IndexOf(View.Hyperlink.DetailPage);
        ReportPageParamCB.Text := View.Hyperlink.ReportVariable;
        ReportPageValueE.Text := View.Hyperlink.Value;
        ReportPageExprE.Text := View.Hyperlink.Expression;
      end;
    hkCustom:
      begin
        CustomRB.Checked := True;
        CustomE.Text := View.Hyperlink.Value;
        CustomExprE.Text := View.Hyperlink.Expression;
      end;
  end;

  UrlRBClick(nil);
end;

procedure TfrxHyperlinkEditorForm.FormHide(Sender: TObject);
var
  p: TfrxReportPage;
begin
  if ModalResult = mrOk then
  begin
    if UrlRB.Checked then
    begin
      View.Hyperlink.Kind := hkURL;
      View.Hyperlink.Value := UrlE.Text;
      View.Hyperlink.Expression := UrlExprE.Text;
    end
    else if PageNumberRB.Checked then
    begin
      View.Hyperlink.Kind := hkPageNumber;
      View.Hyperlink.Value := PageNumberE.Text;
      View.Hyperlink.Expression := PageNumberExprE.Text;
    end
    else if AnchorRB.Checked then
    begin
      View.Hyperlink.Kind := hkAnchor;
      View.Hyperlink.Value := AnchorE.Text;
      View.Hyperlink.Expression := AnchorExprE.Text;
    end
    else if ReportRB.Checked then
    begin
      View.Hyperlink.Kind := hkDetailReport;
      View.Hyperlink.DetailReport := ReportNameE.Text;
      View.Hyperlink.ReportVariable := ReportParamCB.Text;
      View.Hyperlink.Value := ReportValueE.Text;
      View.Hyperlink.Expression := ReportExprE.Text;
    end
    else if ReportPageRB.Checked then
    begin
      View.Hyperlink.Kind := hkDetailPage;
      View.Hyperlink.DetailPage := ReportPageCB.Text;
      View.Hyperlink.ReportVariable := ReportPageParamCB.Text;
      View.Hyperlink.Value := ReportPageValueE.Text;
      View.Hyperlink.Expression := ReportPageExprE.Text;
      p := TfrxCustomDesigner(Self.Owner).Report.FindObject(View.Hyperlink.DetailPage) as TfrxReportPage;
      if p <> nil then
        p.Visible := False;
    end
    else if CustomRB.Checked then
    begin
      View.Hyperlink.Kind := hkCustom;
      View.Hyperlink.Value := CustomE.Text;
      View.Hyperlink.Expression := CustomExprE.Text;
    end;

    if ModifyAppearanceCB.Checked then
    begin
      View.Cursor := crHandPoint;
      if View is TfrxCustomMemoView then
      begin
        (View as TfrxCustomMemoView).Font.Color := clNavy;
        (View as TfrxCustomMemoView).Font.Style := (View as TfrxCustomMemoView).Font.Style + [fsUnderline];
      end;
    end;
  end;
end;

procedure TfrxHyperlinkEditorForm.ExprClick(Sender: TObject);
var
  s: String;
begin
  s := TfrxCustomDesigner(Owner).InsertExpression((Sender as TfrxComboEdit).Text);
  if s <> '' then
    (Sender as TfrxComboEdit).Text := s;
end;

procedure TfrxHyperlinkEditorForm.ReportNameEButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    ReportNameE.Text := OpenDialog.FileName;
    ReportParamCB.Text := '';
    FillVariablesList(ReportNameE.Text, ReportParamCB.Items);
  end;
end;

end.
