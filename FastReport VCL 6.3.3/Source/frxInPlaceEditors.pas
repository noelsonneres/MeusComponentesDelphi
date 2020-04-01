{******************************************}
{                                          }
{             FastReport v6.0              }
{           Basic InPlace Editors          }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxInPlaceEditors;

interface

uses
{$IFDEF FPC}LazHelper{$ELSE}Windows{$ENDIF},
  Types, Classes, SysUtils, Graphics, Controls, StdCtrls, ComCtrls, Forms,
  Menus, TypInfo,
  Dialogs, frxClass, frxUtils, frxGraphicControls,
  frxRes, frxUnicodeCtrls, frxUnicodeUtils, Buttons, frxPopupForm
{$IFDEF Delphi6}
    , Variants
{$ENDIF}
{$IFDEF Delphi10}
    , WideStrings
{$ENDIF};

type
  TfrxInPlaceMemoEditorBase = class(TfrxInPlaceEditor)
  private
    procedure LinesChange(Sender: TObject);
    procedure MemoKeyPress(Sender: TObject; var Key: Char);
    procedure DoExit(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
  protected
    FInPlaceMemo: TCustomMemo;
    FEdited: Boolean;
    procedure InitControlFromComponent; virtual;
    procedure InitComponentFromControl; virtual;
    procedure EditDone;
    procedure CreateMemo; virtual; abstract;
  public
    constructor Create(aClassRef: TfrxComponentClass;
      aOwner: TWinControl); override;
    destructor Destroy; override; 
    function HasCustomEditor: Boolean; override;
    function DoMouseUp(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    procedure EditInPlace(aParent: TComponent; aRect: TRect); override;
    function EditInPlaceDone: Boolean; override;
    function DoMouseWheel(Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    procedure FinalizeUI(var EventParams: TfrxInteractiveEventsParams); override;
  end;

  TfrxInPlaceTextEditorBase = class(TfrxInPlaceMemoEditorBase)
  protected
    procedure CreateMemo; override;
  end;

  TfrxInPlaceMemoEditor = class(TfrxInPlaceTextEditorBase)
  protected
    procedure InitControlFromComponent; override;
    procedure InitComponentFromControl; override;
  end;

  TfrxInPlaceDataFiledEditor = class(TfrxInPlaceEditor)
  private
    FPopupForm: TfrxPopupForm;
    FListBox: TListBox;
    FDrawDropDown: Boolean;
    FDrawButton: Boolean;
    FDRawDragDrop: Boolean;
    FRect: TRect;
    FModified: Boolean;
    procedure UpdateRect;
    procedure DoPopupHide(Sender: TObject);
    procedure DoLBClick(Sender: TObject);
    procedure LBDrawItem(Control: TWinControl; Index: Integer; aRect: TRect;
      State: TOwnerDrawState);
    function GetParentDS: TfrxDataSet;
  public
    procedure InitializeUI(var EventParams: TfrxInteractiveEventsParams); override;
    procedure FinalizeUI(var EventParams: TfrxInteractiveEventsParams); override;
    function DoMouseDown(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    procedure DrawCustomEditor(aCanvas: TCanvas; aRect: TRect); override;
    function DoMouseMove(X, Y: Integer; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    function ShowPopup(aParent: TComponent; aRect: TRect; X, Y: Integer)
      : Boolean;
    function DoCustomDragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    function DoCustomDragDrop(Source: TObject; X, Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean;
      override;
  end;

  TfrxInPlaceBasePanelEditor = class(TfrxInPlaceEditor)
  private
    FButtonsPanel: TfrxSwitchButtonsPanel;
    FSwitchMode: Boolean;
    FPosition: TPoint;
    function DestroyPanel: Boolean;
  protected
    FMouseDown: Boolean;
    function GetItem(Index: Integer): Boolean; virtual; abstract;
    procedure SetItem(Index: Integer; const Value: Boolean); virtual; abstract;
    function Count: Integer; virtual; abstract;
    function GetName(Index: Integer): String; virtual; abstract;
    function GetColor(Index: Integer): TColor; virtual; abstract;
  public
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure InitializeUI(var EventParams: TfrxInteractiveEventsParams); override;
    procedure FinalizeUI(var EventParams: TfrxInteractiveEventsParams); override;
    function GetActiveRect: TRect; override;
    function DoMouseDown(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    function DoMouseUp(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    procedure DrawCustomEditor(aCanvas: TCanvas; aRect: TRect); override;
    property Item[Index: Integer]: Boolean read GetItem write SetItem;
  end;

{$I frx.inc}

implementation

uses Math, frxInPlaceClipboards;


type
  { InPlace editors }
  TfrxHackView = class(TfrxView);
  THackCustomMemo = class(TCustomMemo);
  TfrxInPlaceBandEditor = class(TfrxInPlaceEditor)
  private
    FDrawDragDrop: Boolean;
  public
    constructor Create(aClassRef: TfrxComponentClass;
      aOwner: TWinControl); override;
    function HasCustomEditor: Boolean; override;
    procedure FinalizeUI(var EventParams: TfrxInteractiveEventsParams); override;
    procedure DrawCustomEditor(aCanvas: TCanvas; aRect: TRect); override;
    function DoCustomDragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    function DoCustomDragDrop(Source: TObject; X, Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean;
      override;
  end;


  { TfrxMemoEditor }

constructor TfrxInPlaceMemoEditorBase.Create(aClassRef: TfrxComponentClass;
  aOwner: TWinControl);
begin
  inherited;
  CreateMemo;
  THackCustomMemo(FInPlaceMemo).OnExit := DoExit;
  with THackCustomMemo(FInPlaceMemo) do
  begin
    Visible := False;
    WordWrap := False;
    OnChange := LinesChange;
    OnKeyPress := MemoKeyPress;
    OnKeyDown := MemoKeyDown;
    Parent := FOwner;
  end;
end;

procedure TfrxInPlaceMemoEditorBase.DoExit(Sender: TObject);
begin
  EditDone;
end;

function TfrxInPlaceMemoEditorBase.DoMouseUp(X, Y: Integer;
  Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := Inherited DoMouseUp(X, Y, Button, Shift, EventParams);
  OnFinishInPlace := EventParams.OnFinish;
  EditInPlaceDone;
  if ((EventParams.EditMode = dtText) or ((EventParams.EventSender = esPreview) and (ssAlt in Shift) and not(rfDontEditInPreview in FComponent.Restrictions))) then
  EditInPlace(EventParams.Sender as TComponent, Rect(TfrxHackView(FComponent).FX, TfrxHackView(FComponent).FY, TfrxHackView(FComponent).FX1, TfrxHackView(FComponent).FY1));
    //OnFinishInPlace := EventParams.OnFinish;
end;

function TfrxInPlaceMemoEditorBase.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := FInPlaceMemo.Visible;
end;

procedure TfrxInPlaceMemoEditorBase.EditDone;
begin
  if (csDestroying in FInPlaceMemo.ComponentState) or
    Assigned(FInPlaceMemo.Parent) and
    (csDestroying in FInPlaceMemo.Parent.ComponentState) then
    Exit;
  if FInPlaceMemo.Modified then
  begin
    InitComponentFromControl;
    DoFinishInPlace(Component, True, True);
    FInPlaceMemo.Modified := False;
    FEdited := True;
  end;
  FInPlaceMemo.Hide;
end;

procedure TfrxInPlaceMemoEditorBase.EditInPlace(aParent: TComponent; aRect: TRect);
var
  View: TfrxView;
  Scale: Extended;
  r: TRect;
begin
  View := TfrxView(Component);
  Scale := FScale;
  with THackCustomMemo(FInPlaceMemo) do
  begin

    r := Rect(Round(View.AbsLeft * Scale), Round(View.AbsTop * Scale),
      Round((View.AbsLeft + View.Width) * Scale + 1),
      Round((View.AbsTop + View.Height) * Scale + 1));
    OffsetRect(r, Round(FOffsetX), Round(FOffsetY));
    SetBounds(r.Left, r.Top, r.Right - r.Left, r.Bottom - r.Top);
    InitControlFromComponent;

    // FOriginalSize.cx := Width;
    // FOriginalSize.cy := Height;

    if View.Color = clNone then
      Color := clWhite
    else
      Color := View.Color;
{$IFNDEF FPC}
    Ctl3D := False;
{$ENDIF}
    BorderStyle := bsNone;

    Show;
    SetFocus;
    SelectAll;
    FEdited := False;
  end;

end;

function TfrxInPlaceMemoEditorBase.EditInPlaceDone: Boolean;
begin
  EditDone;
  Result := FEdited;
end;

procedure TfrxInPlaceMemoEditorBase.FinalizeUI(
  var EventParams: TfrxInteractiveEventsParams);
begin
  inherited;
  EventParams.Refresh := EventParams.Refresh or EditInPlaceDone;
//  EventParams.Modified := EventParams.Refresh;
end;

function TfrxInPlaceMemoEditorBase.HasCustomEditor: Boolean;
begin
  Result := True;
end;

procedure TfrxInPlaceMemoEditorBase.InitComponentFromControl;
begin
//
end;

procedure TfrxInPlaceMemoEditorBase.InitControlFromComponent;
begin
//
end;

procedure TfrxInPlaceMemoEditorBase.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = $0D) and (ssCtrl in Shift) then
    EditDone;
end;

procedure TfrxInPlaceMemoEditorBase.MemoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    FInPlaceMemo.Modified := False;
    EditDone;
  end;
end;

procedure TfrxInPlaceMemoEditorBase.LinesChange(Sender: TObject);
// var
// i, w0, w, h: Integer;
begin
  { h := (-FInPlaceMemo.Font.Height + 3) * FInPlaceMemo.Lines.Count + 4;
    if h > FInPlaceMemo.Height - FInPlaceMemo.Font.Height then
    FInPlaceMemo.Height := h;

    TPanel(FInPlaceMemo.Parent).Canvas.Font := FInPlaceMemo.Font;

    w := FInPlaceMemo.Width;
    for i := 0 to FInPlaceMemo.Lines.Count - 1 do
    begin
    w0 := FDesigner.Canvas.TextWidth(FInPlaceMemo.Lines[i]) + 6;
    if w0 > w then
    w := w0;
    end;

    if w > FInPlaceMemo.Width then
    FInPlaceMemo.Width := w; }
end;

{ TfrxInPlaceBandEditor }

constructor TfrxInPlaceBandEditor.Create(aClassRef: TfrxComponentClass;
  aOwner: TWinControl);
begin
  inherited;

end;

function TfrxInPlaceBandEditor.DoCustomDragDrop(Source: TObject;
  X, Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  Band: TfrxBand;
  Node: TTreeNode;
  i: Integer;
  s: String;
  aEventParams: TfrxInteractiveEventsParams;
  e: TfrxEventObject;
  c: TfrxComponent;

  function GetComponentByIndex(Index: Integer): TfrxComponent;
  var
    i: Integer;
    c: TfrxComponent;
  begin
    Result := nil;
    for i := 0 to Band.Objects.Count - 1 do
      if TObject(Band.Objects[i]) is TfrxComponent then
      begin
        c := TfrxComponent(Band.Objects[i]);
        if c.IndexTag = Index then
        begin
          Result := c;
          Exit;
        end;
      end;
  end;

begin
  Result := False;
  if not FDrawDragDrop then Exit;
  Band := nil;
  if Component is TfrxBand then
    Band := TfrxBand(Component);
  if (Source is TTreeView) and Assigned(Band) then
    with Band do
      for i := TTreeView(Source).SelectionCount - 1 downto 0 do
      begin
        Node := TTreeView(Source).Selections[i];
        s := '';
        if (Node <> nil) and (Node.Data <> nil) then
          s := Report.GetAlias(TfrxDataSet(Node.Data));
        if s <> '' then
        begin
          c := GetComponentByIndex(i + 1);
          Result := True;
          if Assigned(c) then
          begin
//            Result := True;
            // pass helper class which helps to determanate sender
            e := TfrxEventObject.Create;
            try
              e.Sender := Source;
              e.Index := i;
              aEventParams.EditorsList := Editors;
              c.DragDrop(e, X, Y, aEventParams);
            finally
              e.Free;
            end;
          end;
        end;
      end;
end;

function TfrxInPlaceBandEditor.DoCustomDragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  Band: TfrxBand;
begin
  Result := False;
  Band := nil;
  Accept := False;
  if Component is TfrxBand then
    Band := TfrxBand(Component);
  if (Source is TTreeView) and Assigned(Band) and (Band.AbsLeft * FScale < X)
    and ((Band.AbsLeft + Band.Width) * FScale > X) and
    ((Band.AbsTop - Band.BandDesignHeader) * FScale < Y) and
    (Band.AbsTop * FScale > Y) then
  begin
    Accept := True;
    Result := True;
  end;
  FDrawDragDrop := Accept;
  EventParams.Refresh := True;
end;

procedure TfrxInPlaceBandEditor.DrawCustomEditor(aCanvas: TCanvas; aRect: TRect);
var
  Band: TfrxBand;
begin
  Band := TfrxBand(Component);
  if FDrawDragDrop then
  begin
    frxResources.MainButtonImages.Draw(aCanvas, Round((Band.AbsLeft + Band.Width) * FScale / 2),
            Round((Band.AbsTop - Band.BandDesignHeader) * FScale), 112);
    TransparentFillRect(aCanvas.Handle, Round(Band.AbsLeft * FScale), Round((Band.AbsTop - Band.BandDesignHeader) * FScale),
      Round((Band.AbsLeft + Band.Width) * FScale), Round(Band.AbsTop * FScale), clGray);
  end;
end;

procedure TfrxInPlaceBandEditor.FinalizeUI(
  var EventParams: TfrxInteractiveEventsParams);
begin
  EventParams.Refresh := FDrawDragDrop;
  FDrawDragDrop := False;
end;

function TfrxInPlaceBandEditor.HasCustomEditor: Boolean;
begin
  Result := inherited HasCustomEditor;
end;

{ TfrxInPlaceDataFiledEditor }

function TfrxInPlaceDataFiledEditor.DoCustomDragDrop(Source: TObject; X,
  Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  Memo: TfrxCustomMemoView;
  View: TfrxView;
  Node: TTreeNode;
  i, nStart, nCount: Integer;
  s: String;
begin
  Result := False;
  FDRawDragDrop := False;
  Memo := nil;
  nCount := 0;
  nStart := 0;
  if Component is TfrxCustomMemoView then
    Memo := TfrxCustomMemoView(Component);
  View := TfrxView(Component);
  if (Source is TTreeView) and Assigned(View) then
  begin
    nCount := TTreeView(Source).SelectionCount - 1;
    nStart := 0;
  end
  { called from another editor with TfrxEventObject }
  else if (Source is TfrxEventObject) and Assigned(View) then
  begin
    nStart := TfrxEventObject(Source).Index;
    nCount := nStart;
    Source := TfrxEventObject(Source).Sender;
  end;
  if (Source is TTreeView) then

    with View do
      for i := nCount downto nStart do
      begin
        Node := TTreeView(Source).Selections[i];
        s := '';
        EventParams.Refresh := True;
        EventParams.Modified := True;
        if (Node <> nil) and Assigned(Node.Data) and (TObject(Node.Data) is TfrxDataSet) then
          s := Report.GetAlias(TfrxDataSet(Node.Data));
        if s <> '' then
        begin
          Result := True;
          if (nCount = nStart) or ((Memo = nil) and (i = nCount)) then
          begin
            DataSet := TfrxDataSet(Node.Data);
            DataField := Node.Text;
            Break;
          end
          else
          begin
            if i = nCount then
              Memo.Text := '';
            Memo.DataSet := nil;
            Memo.DataField := '';
            Memo.Text := Memo.Text + '[' + s + '."' + Node.Text + '"]';
          end;
        end
        else if Assigned(Memo) then
        begin
          Result := True;
          if i = nCount then
              Memo.Text := '';
          Memo.DataSet := nil;
          Memo.DataField := '';
          Memo.Text := Memo.Text + '[' + Node.Text + ']';
        end;
      end;
end;

function TfrxInPlaceDataFiledEditor.DoCustomDragOver(Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  View: TfrxView;
begin
  Result := False;
  View := nil;
  if Component is TfrxView then
    View := TfrxCustomMemoView(Component);
  if (Source is TTreeView) and Assigned(View) then
  begin
    Accept := True;
    Result := True;
    FDrawDragDrop := True;
    EventParams.Refresh := True;
  end;
end;

procedure TfrxInPlaceDataFiledEditor.DoLBClick(Sender: TObject);
var
  i: Integer;
begin
  if Component is TfrxView then
  begin
    TfrxView(Component).DataSet :=
      GetParentDS;
    TfrxView(Component).DataField :=
      FListBox.Items[FListBox.ItemIndex];
  end;

  if Assigned(FComponents) then
    for i := 0 to FComponents.Count - 1 do
      if TObject(FComponents[i]) is Component.ClassType then
      begin
        TfrxView(FComponents[i]).DataSet :=
        GetParentDS;
          TfrxView(FComponents[i]).DataField :=
          FListBox.Items[FListBox.ItemIndex];
      end;
  FModified := True;
  FPopupForm.Hide;
end;

function TfrxInPlaceDataFiledEditor.DoMouseDown(X, Y: Integer;
  Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  UpdateRect;
  if not FLocked then
  begin
    OnFinishInPlace := EventParams.OnFinish;
    ShowPopup(EventParams.Sender as TComponent, FRect, X, Y);
  end;
  Result := FLocked;
end;

function TfrxInPlaceDataFiledEditor.DoMouseMove(X, Y: Integer;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
end;

procedure TfrxInPlaceDataFiledEditor.DoPopupHide(Sender: TObject);
begin
  FLocked := False;
  DoFinishInPlace(Component, True, FModified);
  FDrawDropDown := False;
  OnFinishInPlace := nil;
end;

procedure TfrxInPlaceDataFiledEditor.DrawCustomEditor(aCanvas: TCanvas;
  aRect: TRect);
var
  r: TRect;
  rHeight: Integer;
begin
  UpdateRect;
  rHeight := FRect.Bottom - FRect.Top;
  if FDrawDragDrop then
  begin
    frxResources.MainButtonImages.Draw(aCanvas, FRect.Left - 10,
            FRect.Top + (rHeight - 5) div 2, 111);
    TransparentFillRect(aCanvas.Handle, FRect.Left + 1, FRect.Top + 1,
      FRect.Right - 1, FRect.Bottom - 1, clGray);
  end;
  if not FDrawButton then Exit;
  // move same code to function
  with aCanvas do
  begin
    r.TopLeft := Point(FRect.Right - 16, FRect.Top + 2);
    r.BottomRight := Point(r.Left + 16, r.Top + 16);
    DrawButtonFace(aCanvas, r, 1, bsNew, False, False, False);
    Brush.Color := clBlack;
    Brush.Style := bsSolid;
    Pen.Color := clBlack;
    Pen.Style := psSolid;
    Pen.Width := 1;
    if FDrawDropDown then
      Polygon([Point(r.Left + 4, r.Top + 6), Point(r.Left + 7, r.Top + 9),
        Point(r.Left + 10, r.Top + 6), Point(r.Left + 4, r.Top + 6)])
    else
      Polygon([Point(r.Left + 6, r.Top + 4), Point(r.Left + 9, r.Top + 7),
        Point(r.Left + 6, r.Top + 10), Point(r.Left + 6, r.Top + 4)])
  end;
//    frxResources.WizardImages.Draw(aCanvas, aRect.Left + rWidth div 2 - 16, aRect.Top + rHeight div 2 - 16, Index, True);
end;

procedure TfrxInPlaceDataFiledEditor.FinalizeUI(var EventParams: TfrxInteractiveEventsParams);
begin
  if Not FLocked then
    FDrawButton := False;
  FDrawDragDrop := False;
end;

function TfrxInPlaceDataFiledEditor.GetParentDS: TfrxDataSet;
var
  p: TfrxComponent;
begin
  Result := nil;
  p := FComponent.Parent;
  while (p.Parent <> nil) and not(p is TfrxDataBand) do
    p := p.Parent;
 if (p is TfrxDataBand) then
   Result := TfrxDataBand(p).DataSet;
end;

procedure TfrxInPlaceDataFiledEditor.InitializeUI(var EventParams: TfrxInteractiveEventsParams);
begin
  FModified := False;
  FDrawButton := GetParentDS <> nil;
  FDrawDragDrop := False;
  UpdateRect;
end;

procedure TfrxInPlaceDataFiledEditor.LBDrawItem(Control: TWinControl;
  Index: Integer; aRect: TRect; State: TOwnerDrawState);
begin
  with FListBox do
  begin
    Canvas.FillRect(aRect);
    frxResources.MainButtonImages.Draw(Canvas, aRect.Left, aRect.Top, 54);
    Canvas.TextOut(aRect.Left + 20, aRect.Top + 1, Items[Index]);
  end;
end;

function TfrxInPlaceDataFiledEditor.ShowPopup(aParent: TComponent; aRect: TRect;
  X, Y: Integer): Boolean;
var
  r: TRect;
  p: TPoint;
  ds: TfrxDataSet;
  c: TWinControl;
begin
  Result := False;

  if not((X >= aRect.Right - 16) and
    (X <= aRect.Right) and (Y >= aRect.Top) and
    (Y <= aRect.Top + 16)) then
    Exit;

  FPopupForm := TfrxPopupForm.Create(aParent);
  FListBox := TListBox.Create(FPopupForm);
{$IFDEF FPC}
  FPopupForm.PopupParent := Screen.ActiveForm;
{$ENDIF}
  FPopupForm.OnDestroy := DoPopupHide;

  with FListBox do
  begin
    Parent := FPopupForm;
{$IFNDEF FPC}
    Ctl3D := False;
{$ENDIF}
    Align := alClient;
    Style := lbOwnerDrawFixed;
    ItemHeight := 16;
    OnClick := DoLBClick;
    OnDrawItem := LBDrawItem;
    r.Top := aRect.Top + 18;
    r.Right := aRect.Right;
    r.Left := r.Right - 140;
    r.Bottom := r.Top + 162;

    if r.Left < 0 then
    begin
      Inc(r.Right, -r.Left);
      r.Left := 0;
    end;
    c := aParent as TWinControl;
    if c = nil then
      c := Screen.ActiveForm;
    p := c.ClientToScreen(r.TopLeft);
    FPopupForm.SetBounds(p.X, p.Y, r.Right - r.Left, r.Bottom - r.Top);

    ds := GetParentDS;
    if ds <> nil then
    begin
      ds.GetFieldList(Items);
      ItemIndex := Items.IndexOf(TfrxCustomMemoView(Component).DataField);
      FPopupForm.Show;
      FLocked := True;
      Result := True;
      FDrawDropDown := True;
    end
    else
    begin
      FListBox.Free;
      FPopupForm.Free;
    end;
  end;
end;

procedure TfrxInPlaceDataFiledEditor.UpdateRect;
begin
  FRect := Rect(TfrxHackView(FComponent).FX, TfrxHackView(FComponent).FY, TfrxHackView(FComponent).FX1, TfrxHackView(FComponent).FY1);
end;

{ TfrxInPlaceBasePanelEditor }

procedure TfrxInPlaceBasePanelEditor.AfterConstruction;
begin
  inherited;
  FPosition := Point(1, 20);
end;

destructor TfrxInPlaceBasePanelEditor.Destroy;
begin
  DestroyPanel;
  inherited;
end;

function TfrxInPlaceBasePanelEditor.DestroyPanel: Boolean;
begin
  Result := False;
  if Assigned(FButtonsPanel) then
  begin
    Result := True;
    FreeAndNil(FButtonsPanel);
  end;
end;

function TfrxInPlaceBasePanelEditor.DoMouseDown(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
  FMouseDown := True;
end;

function TfrxInPlaceBasePanelEditor.DoMouseUp(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  i: Integer;
  btn: TfrxSwithcButton;
begin
  Result := False;
  if not Assigned(FButtonsPanel) or not FMouseDown then Exit;
  FMouseDown := False;
  btn := FButtonsPanel.DoClick(Round(X - (FComponent.AbsLeft + FComponent.Width) * FScale) + FButtonsPanel.CalcWidth - FPosition.X, Round(Y - FComponent.AbsTop * FScale) - FPosition.Y);
  if btn <> nil then
  for i := 0 to Count - 1 do
  begin
    if FSwitchMode then
    begin
      if (FButtonsPanel.Count > i) and (btn.Tag <> i) then
        FButtonsPanel[i].Switch := False;
      if btn.Switch = false and FSwitchMode then btn.Switch := True;
    end;
    Item[i] := FButtonsPanel[i].Switch;
  end;
  EventParams.Refresh := True;
end;

procedure TfrxInPlaceBasePanelEditor.DrawCustomEditor(aCanvas: TCanvas;
  aRect: TRect);
begin
  inherited;
  if Assigned(FButtonsPanel) then
    FButtonsPanel.Draw(aCanvas, aRect.Right - FButtonsPanel.CalcWidth - FPosition.X, aRect.Top + FPosition.Y);
end;

procedure TfrxInPlaceBasePanelEditor.FinalizeUI(var EventParams: TfrxInteractiveEventsParams);
begin
  inherited;
  EventParams.Refresh := DestroyPanel;
end;

function TfrxInPlaceBasePanelEditor.GetActiveRect: TRect;
begin
  Result := Inherited GetActiveRect;
end;

procedure TfrxInPlaceBasePanelEditor.InitializeUI(var EventParams: TfrxInteractiveEventsParams);
var
  i: integer;
  bFirst: Boolean;
begin
  DestroyPanel;
  EventParams.Refresh := True;
  FButtonsPanel := TfrxSwitchButtonsPanel.Create;
  FButtonsPanel.ShowColors := True;
  FButtonsPanel.ShowCaption := True;
  bFirst := True;
  for i := 0 to Count - 1 do
    if FButtonsPanel.Count - 1 < i then
      with FButtonsPanel.AddButton(GetName(i)) do
      begin
        Switch := Item[i];
        if bFirst and Switch then
        begin
          FSwitchMode := Switch and (EventParams.EventSender <> esDesigner);
          bFirst := False;
        end
        else if Switch then
          FSwitchMode := False;
        Tag := i;
        ColorTag := GetColor(i);
      end;
  FSwitchMode := FSwitchMode and (FButtonsPanel.Count > 1);
end;

{ TfrxInPlaceMemoEditor }

procedure TfrxInPlaceMemoEditor.InitControlFromComponent;
var
  s: WideString;
  MemoView: TfrxCustomMemoView;
  function frxAlignToAlignment(HAlign: TfrxHAlign): TAlignment;
  begin
    case HAlign of
      haLeft: Result := taLeftJustify;
      haRight: Result := taRightJustify;
      else
        Result := taCenter;
    end;
  end;

begin
  MemoView := FComponent as TfrxCustomMemoView;
  if not Assigned(MemoView) then Exit;
  THackCustomMemo(FInPlaceMemo).WordWrap := MemoView.WordWrap;
  THackCustomMemo(FInPlaceMemo).Alignment := frxAlignToAlignment(MemoView.HAlign);
  s := MemoView.Text;
  if (s <> '') and (s[Length(s)] = #10) then
    Delete(s, Length(s) - 1, 2);
  FInPlaceMemo.Text := s;
  THackCustomMemo(FInPlaceMemo).Font.Assign(MemoView.Font);
  THackCustomMemo(FInPlaceMemo).Font.Height := Round(THackCustomMemo(FInPlaceMemo).Font.Height * FScale);
end;


procedure TfrxInPlaceMemoEditor.InitComponentFromControl;
var
  MemoView: TfrxCustomMemoView;
begin
  MemoView := TfrxCustomMemoView(Component);
  MemoView.Text := FInPlaceMemo.Text;
end;

{ TfrxInPlaceTextEditorBase }

procedure TfrxInPlaceTextEditorBase.CreateMemo;
begin
  FInPlaceMemo := TUnicodeMemo.Create(nil);
end;

destructor TfrxInPlaceMemoEditorBase.Destroy;
begin
  FInPlaceMemo.Free;
  inherited;
end;

initialization
  frxRegEditorsClasses.Register(TfrxMemoView, [TfrxInPlaceDataFiledEditor, TfrxInPlaceMemoEditor], [[evDesigner], [evDesigner, evPreview], [evDesigner, evPreview]]);
  frxRegEditorsClasses.Register(TfrxPictureView, [TfrxInPlaceDataFiledEditor], [[evDesigner], [evDesigner, evPreview]]);
  frxRegEditorsClasses.Register(TfrxMasterData, [TfrxInPlaceBandEditor], [[evDesigner]]);

end.
