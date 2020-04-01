
{******************************************}
{                                          }
{             FastReport v5.0              }
{           Designer workspace             }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxDesgnWorkspace1;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  Types, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, frxClass, frxDesgn,
  frxDesgnWorkspace, frxPopupForm
  {$IFDEF FPC}
  ,LCLType, LCLIntf, LazHelper
  {$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxGuideItem = class(TCollectionItem)
  public
    Left, Top, Right, Bottom: Extended;
  end;

  TfrxVirtualGuides = class(TCollection)
  private
    function GetGuides(Index: Integer): TfrxGuideItem;
  public
    constructor Create;
    procedure Add(Left, Top, Right, Bottom: Extended);
    property Items[Index: Integer]: TfrxGuideItem read GetGuides; default;
  end;

  TDesignerWorkspace = class(TfrxDesignerWorkspace)
  private
    FDesigner: TfrxDesignerForm;
    FGuide: Integer;
    FShowGuides: Boolean;
    FSimulateMove: Boolean;
    FTool: TfrxDesignTool;
    FVirtualGuides: TfrxVirtualGuides;
    FVirtualGuideObjects: TList;
    FGuidesObjects: TList;
    FGuidesObjectsSize: TList;
    FPopupFormVisible: Boolean;
    FMouseDownObject: TfrxComponent;
    FStickToGuides: Boolean;
    FGuidesAsAnchor: Boolean;
    FStickAccuracy: Extended;
    FVVirtualGuid: Extended;
    FHVirtualGuid: Extended;
    procedure CreateVirtualGuides;
    procedure SetShowGuides(const Value: Boolean);
    procedure SetHGuides(const Value: TStrings);
    procedure SetVGuides(const Value: TStrings);
    function GetHGuides: TStrings;
    function GetVGuides: TStrings;
    procedure SetTool(const Value: TfrxDesignTool);
  protected
    procedure CheckGuides(var kx, ky: Extended; var Result: Boolean; IsMouseDown: Boolean); override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    procedure DrawObjects; override;
    procedure DoFinishInPlace(Sender: TObject; Refresh, Modified: Boolean); override;
    procedure SetDefaultEventParams(var EventParams: TfrxInteractiveEventsParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    procedure DblClick; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ClearLastView; override;
    destructor Destroy; override;
    procedure DeleteObjects; override;
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    procedure SimulateMove;
    procedure SetVirtualGuids(VGuid, HGuid: Extended); override;
    procedure SetInsertion(AClass: TfrxComponentClass;
      AWidth, AHeight: Extended; AFlag: Word); override;
    property HGuides: TStrings read GetHGuides write SetHGuides;
    property VGuides: TStrings read GetVGuides write SetVGuides;
    property ShowGuides: Boolean read FShowGuides write SetShowGuides;
    property StickToGuides: Boolean read FStickToGuides write FStickToGuides;
    property GuidesAsAnchor: Boolean read FGuidesAsAnchor write FGuidesAsAnchor;
    property StickAccuracy: Extended read FStickAccuracy write FStickAccuracy;
    property Tool: TfrxDesignTool read FTool write SetTool;
  end;

implementation

uses
  ComCtrls, frxDesgnCtrls, frxUtils, frxDataTree, frxDMPClass, frxRes;

type
  THackMemo = class(TfrxCustomMemoView);

function Round8(e: Extended): Extended;
begin
  Result := Round(e * 100000000) / 100000000;
end;

function ToIdent(const s: String): String;
var
  I: Integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    if i = 1 then
    begin
{$IFDEF Delphi12}
      if CharInSet(s[i], ['A'..'Z','a'..'z','_']) then
{$ELSE}
      if s[i] in ['A'..'Z','a'..'z','_'] then
{$ENDIF}
        Result := Result + s[i]
    end
{$IFDEF Delphi12}
    else if CharInSet(s[i], ['A'..'Z','a'..'z','_','0'..'9']) then
{$ELSE}
    else if s[i] in ['A'..'Z','a'..'z','_','0'..'9'] then
{$ENDIF}
      Result := Result + s[i];
  if Length(Result) < Length(s) * 2 div 3 then
    Result := 'Memo';
end;


{ TfrxVirtualGuides }

constructor TfrxVirtualGuides.Create;
begin
  inherited Create(TfrxGuideItem);
end;

procedure TfrxVirtualGuides.Add(Left, Top, Right, Bottom: Extended);
var
  Item: TfrxGuideItem;
begin
  Item := TfrxGuideItem(inherited Add);
  Item.Left := Left;
  Item.Top := Top;
  Item.Right := Right;
  Item.Bottom := Bottom;
end;

function TfrxVirtualGuides.GetGuides(Index: Integer): TfrxGuideItem;
begin
  Result := TfrxGuideItem(inherited Items[Index]);
end;


{ TDesignerWorkspace }

procedure TDesignerWorkspace.ClearLastView;
var
  EventParams: TfrxInteractiveEventsParams;
begin
  inherited;
  if Assigned(FLastObjectOver) then
  begin
    SetDefaultEventParams(EventParams);
    EventParams.PopupVisible := FPopupFormVisible;
    FLastObjectOver.MouseLeave(-1, -1, nil, EventParams);
    FPopupFormVisible := EventParams.PopupVisible;
    FLastObjectOver := nil;
    if EventParams.Refresh then
    begin
{$IFDEF FPC}
      frxUpdateControl(Self);
{$ELSE}
      Repaint;
{$ENDIF}
    end;
    UpdateInternalSelection;
  end;
  FMouseDownObject := nil;
end;

constructor TDesignerWorkspace.Create(AOwner: TComponent);
begin
  inherited;
  FDesigner := TfrxDesignerForm(AOwner);
  FVirtualGuides := TfrxVirtualGuides.Create;
  FVirtualGuideObjects := TList.Create;
  FGuidesObjects := TList.Create;
  FGuidesObjectsSize := TList.Create;
  FMouseDownObject := nil;
  FStickAccuracy := 0.3;
  FVVirtualGuid := 0;
  FHVirtualGuid := 0;
end;

destructor TDesignerWorkspace.Destroy;
begin
  FVirtualGuides.Free;
  FVirtualGuideObjects.Free;
  FGuidesObjects.Free;
  FGuidesObjectsSize.Free;
  inherited;
end;

procedure TDesignerWorkspace.DeleteObjects;
var
  i: Integer;
  NeedReload: Boolean;
begin
  NeedReload := False;
  for i := 0 to FSelectedObjects.Count - 1 do
  begin
    if TObject(FSelectedObjects[i]) is TfrxSubreport then
      NeedReload := True;
    //if FLastObjectOver = TObject(FSelectedObjects[i]) then
    //  FLastObjectOver := nil;
    ClearLastView;
  end;

  inherited;

  if NeedReload then
    FDesigner.ReloadPages(FDesigner.Report.Objects.IndexOf(Page));
end;

procedure TDesignerWorkspace.SetInsertion(AClass: TfrxComponentClass;
  AWidth, AHeight: Extended; AFlag: Word);
begin
  inherited;
  CreateVirtualGuides;
end;

procedure TDesignerWorkspace.DrawObjects;
var
  i, d: Integer;
begin
  if FDesigner.Page is TfrxReportPage then
    with TfrxReportPage(FDesigner.Page) do
      if Columns > 1 then
        for i := 0 to Columns - 1 do
        begin
          d := Round(frxStrToFloat(ColumnPositions[i]) * fr01cm * FScale);
          if d = 0 then continue;
          FCanvas.Pen.Color := clSilver;
          FCanvas.MoveTo(d, 0);
          FCanvas.LineTo(d, Self.Height);
        end;

  inherited;
  { draw guides on top }
  if FShowGuides and (FPage is TfrxReportPage) then
  begin
    with FCanvas do
    begin
      Pen.Width := 1;
      Pen.Style := psSolid;
      Pen.Color := $FFCC00;
      Pen.Mode := pmCopy;
    end;

    for i := 0 to HGuides.Count - 1 do
    begin
      d := Round(frxStrToFloat(HGuides[i]) * Scale);
      FCanvas.MoveTo(0, d);
      FCanvas.LineTo(Width, d);
    end;

    for i := 0 to VGuides.Count - 1 do
    begin
      d := Round(frxStrToFloat(VGuides[i]) * Scale);
      FCanvas.MoveTo(d, 0);
      FCanvas.LineTo(d, Height);
    end;

    if (FVVirtualGuid > 0) or (FHVirtualGuid > 0) then
    begin
      FCanvas.Pen.Mode := pmXor;
      FCanvas.Pen.Color := clSilver;
      FCanvas.Pen.Width := 1;
      FCanvas.Pen.Style := psDot;
      FCanvas.Brush.Style := bsClear;


      if FVVirtualGuid > 0 then
      begin
        d := Round(FVVirtualGuid * Scale);
        FCanvas.MoveTo(d, 0);
        FCanvas.LineTo(d, Height);
     end;

      if FHVirtualGuid > 0 then
      begin
        d := Round(FHVirtualGuid * Scale);
        FCanvas.MoveTo(0, d);
        FCanvas.LineTo(Width, d);
      end;
      FCanvas.Pen.Mode := pmCopy;
      FCanvas.Brush.Style := bsSolid;
    end;
  end;

  if FVirtualGuides.Count > 0 then
  begin
    if FMouseDown or (FMode1 = dmInsertObject) or (FMode1 = dmInsertLine) then
      with FCanvas do
      begin
        Pen.Width := 1;
        Pen.Style := psSolid;
        Pen.Color := $FFCC00;
        Pen.Mode := pmCopy;
        for i := 0 to FVirtualGuides.Count - 1 do
        begin
          MoveTo(Round(FVirtualGuides[i].Left * Scale), Round(FVirtualGuides[i].Top * Scale));
          LineTo(Round(FVirtualGuides[i].Right * Scale), Round(FVirtualGuides[i].Bottom * Scale));
        end;
      end;
    FVirtualGuides.Clear;
  end;
end;

procedure TDesignerWorkspace.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  ds: TfrxDataset;
  s, fld: String;
  w: Integer;
  EventParams: TfrxInteractiveEventsParams;
begin
{$IFDEF FPC}
  ds := nil;
  fld := '';
{$ENDIF}
  SetDefaultEventParams(EventParams);
  if FLastObjectOver <> nil then
    if FLastObjectOver.DragOver(Source, X, Y, State, Accept, EventParams) then
    begin
      FMode := dmDrag;
      MouseMove([], X - 8,  Y - 8);
      Exit;
    end;

  Accept := ((FDesigner.CheckOp(drDontInsertObject) and
    (Source is TTreeView) and
    (TTreeView(Source).Owner = FDesigner.DataTree) and
    ((FDesigner.DataTree.GetFieldName(-1) <> '') or (FDesigner.DataTree.ActiveDS <> ''))) or
    ((Source is TfrxRuler) and FDesigner.ShowGuides)) and (FDesigner.Page is TfrxReportPage);
  if not Accept then Exit;

  FMode := dmDrag;
  if Source is TfrxRuler then
    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Style := psSolid;
      Pen.Color := clBlack;
{$IFDEF FPC}
      frxUpdateControl(Self);
{$ELSE}
      Repaint;
{$ENDIF}

      if GridAlign then
      begin
        X := Round(Trunc(X / (GridX * Scale)) * GridX * Scale);
        Y := Round(Trunc(Y / (GridY * Scale)) * GridY * Scale);
      end;

      if TfrxRuler(Source).Align = alLeft then
      begin
        MoveTo(X, 0);
        LineTo(X, Height);
      end
      else
      begin
        MoveTo(0, Y);
        LineTo(Width, Y);
      end;

      MouseMove([], X, Y);
    end
  else
  begin
    if (FInsertion.ComponentClass = nil) and
      (FDesigner.DataTree.InsFieldCB.Checked or
      FDesigner.DataTree.InsCaptionCB.Checked or
      not FDesigner.DataTree.IsDataField) then
    begin
      s := FDesigner.DataTree.GetFieldName(-1);
      s := Copy(s, 2, Length(s) - 2);
      FDesigner.Report.GetDatasetAndField(s, ds, fld);
      try
        if (ds <> nil) and (fld <> '') then
          w := ds.DisplayWidth[fld] else
          w := 10;
      except
        w := 10;
      end;

      if w > 50 then
        w := 50;

      SetInsertion(TfrxMemoView, Round(w * 8 / GridX) * GridX,
        FDesigner.GetDefaultObjectSize.Y, 0);
    end;

    MouseMove([], X - 8,  Y - 8);
  end;
end;

procedure TDesignerWorkspace.DragDrop(Source: TObject; X, Y: Integer);
var
  eX, eY, OrgLeft: Extended;
  m: TfrxCustomMemoView;
  b: TfrxDataBand;
  ds: TfrxDataset;
  s, fld: String;
  i, idx: Integer;
  BandsList: TStringList;
  EventParams: TfrxInteractiveEventsParams;
begin
{$IFDEF FPC}
  ds := nil;
  fld := '';
{$ENDIF}
  SetDefaultEventParams(EventParams);
  if FLastObjectOver <> nil then
    if FLastObjectOver.DragDrop(Source, X, Y, EventParams) then
    begin
      SetInsertion(nil, 0, 0, 0);
      FModifyFlag := EventParams.Modified;
      MouseUp(mbLeft, [], X,  Y);
      UpdateInternalSelection;
      SelectionChanged;
      Exit;
    end;

  if (Source is TfrxRuler) and (FPage is TfrxReportPage) then
  begin
    if GridAlign then
    begin
      eX := Trunc(X / Scale / GridX) * GridX;
      eY := Trunc(Y / Scale / GridY) * GridY;
    end
    else
    begin
      eX := X / Scale;
      eY := Y / Scale;
    end;

    eX := Round8(eX);
    eY := Round8(eY);

    if TfrxRuler(Source).Align = alLeft then
      VGuides.Add(FloatToStr(eX)) else
      HGuides.Add(FloatToStr(eY));
    FMode := dmSelect;
  end
  else if (FDesigner.DataTree.InsFieldCB.Checked or
    FDesigner.DataTree.InsCaptionCB.Checked or
    not FDesigner.DataTree.IsDataField){$IFDEF FR_COM} and not FDesigner.IsExpired{$ENDIF} then
  begin
    // TODO: code for multi-selection need future refactoring
    FSelectedObjects.Clear;
    BandsList := TStringList.Create;
    try
      for i := FDesigner.DataTree.GetSelectionCount - 1 downto 0 do
      begin
        s := FDesigner.DataTree.GetFieldName(i);
        ds := FDesigner.DataTree.GetDataSet(i);
        if (s = '') and (ds <> nil) then
        begin
          if ds.IsHasMaster then
            b := TfrxDetailData.Create(Page)
          else
            b := TfrxMasterData.Create(Page);
          b.CreateUniqueName;
          b.DataSet := ds;
          BandsList.AddObject(ds.UserName, b);
        end;
      end;
      ds := nil;
      OrgLeft := FInsertion.Left;

      for i := 0 to FDesigner.DataTree.GetSelectionCount - 1 do
      begin
        s := ToIdent(FDesigner.DataTree.GetFieldName(i));
        if s <> '' then
        begin
          if Page is TfrxDMPPage then
            m := TfrxDMPMemoView.Create(Page)
          else
            m := TfrxMemoView.Create(Page);
          if (s <> 'Memo') and (FDesigner.Report.FindObject(s) = nil) then
            m.Name := s
          else
          begin
            THackMemo(m).FBaseName := s;
            m.CreateUniqueName;
          end;
          m.IndexTag := i + 1;
          m.IsDesigning := True;
          s := FDesigner.DataTree.GetFieldName(i);
          s := Copy(s, 2, Length(s) - 2);
          FDesigner.Report.GetDataSetAndField(s, ds, fld);
          idx := -1;

          if FInsertion.Left + FInsertion.Width > Page.Width then
          begin
            FInsertion.Left := OrgLeft;
            if FDesigner.DataTree.InsCaptionCB.Checked then
              FInsertion.Top := FInsertion.Top + FInsertion.Height * 2
            else
              FInsertion.Top := FInsertion.Top + FInsertion.Height;
          end;

          if not FDesigner.DataTree.IsDataField or FDesigner.DataTree.InsFieldCB.Checked then
          begin
            m.DataSet := ds;
            m.DataField := fld;
            if (ds = nil) and (fld = '') then
            begin
              if Pos('<', FDesigner.DataTree.GetFieldName(i)) = 1 then
                m.Text := '[' + s + ']' else
                m.Text := '[' + FDesigner.DataTree.GetFieldName(i) + ']';
            end;

            if ds <> nil then
            begin
              idx := BandsList.IndexOf(ds.UserName);
              if idx <> -1 then
              begin
                b := TfrxMasterData(BandsList.Objects[idx]);
                b.SetBounds(0, Round8(FInsertion.Top),
                FPage.Width, Round8(FInsertion.Height));
                b.IsDesigning := True;
                m.Parent := b;
                m.Align := baLeft;
              end;
            end;
            if idx <> -1 then
              m.SetBounds(Round8(FInsertion.Left), 0,
              Round8(FInsertion.Width), Round8(FInsertion.Height))
            else if FDesigner.DataTree.InsCaptionCB.Checked then
              m.SetBounds(Round8(FInsertion.Left), Round8(FInsertion.Top + FInsertion.Height),
              Round8(FInsertion.Width), Round8(FInsertion.Height))
            else
              m.SetBounds(Round8(FInsertion.Left), Round8(FInsertion.Top),
              Round8(FInsertion.Width), Round8(FInsertion.Height));

            FDesigner.SampleFormat.ApplySample(m);
            FObjects.Add(m);
            FSelectedObjects.Add(m);
          end
          else
            m.Free;
          if FDesigner.DataTree.IsDataField and FDesigner.DataTree.InsCaptionCB.Checked then
          begin
            if Page is TfrxDMPPage then
              m := TfrxDMPMemoView.Create(Page) else
              m := TfrxMemoView.Create(Page);
            m.CreateUniqueName;
            m.IsDesigning := True;
            m.Text := fld;
            m.SetBounds(Round8(FInsertion.Left), Round8(FInsertion.Top),
            Round8(FInsertion.Width), Round8(FInsertion.Height));
            FDesigner.SampleFormat.ApplySample(m);
            FObjects.Add(m);
            FSelectedObjects.Add(m);
          end;
          FInsertion.Left := FInsertion.Left + FInsertion.Width;
          if (frxDesignerComp <> nil) and Assigned(frxDesignerComp.OnInsertObject) then
            frxDesignerComp.OnInsertObject(m);
        end;
      end;
      for i:= 0 to BandsList.Count - 1 do
      begin
        b := TfrxMasterData(BandsList.Objects[i]);
        if b.Objects.Count = 0 then
          b.Free
        else
        begin
          FObjects.Add(b);
          AdjustBandHeight(b);
        end;
      end;
    finally
      BandsList.Free;
    end;
    SetInsertion(nil, 0, 0, 0);
  end;

  FModifyFlag := True;
  MouseUp(mbLeft, [], X,  Y);
  SelectionChanged;
end;

procedure TDesignerWorkspace.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  EventParams: TfrxInteractiveEventsParams;
  bEventProcessed: Boolean;
  e: Extended;
  i: Integer;
  cc: TfrxComponent;
  function CheckGuids(aGuids: TStrings; ePos: Extended): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 0 to aGuids.Count -1 do
      if Abs(frxStrToFloat(aGuids[i]) - ePos) <= 0.001 then
      begin
        Result := True;
        break;
      end;
  end;
begin
  if FDisableUpdate then Exit;
  { if popup active, send leave message to FLastObjectOver }
  { and mouse enter message to a new one }
  if FPopUpActive and (Button = mbRight) then
  begin
    if Assigned(FMouseDownObject) then
    begin
      FLastObjectOver := FMouseDownObject;
      FMouseDownObject := nil;
    end;
    MouseMove(Shift, X, Y);
  end;
  SetDefaultEventParams(EventParams);
  FMouseDownObject := FLastObjectOver;

  if FTool = dtHand then
  begin
    FMode1 := dmNone;
    FMouseDown := True;
    FLastMousePointX := X;
    FLastMousePointY := Y;
    Exit;
  end
  else if FTool in [dtZoom, dtText] then
  begin
    FMode1 := dmSelectionRect;
    FSelectionRect := frxRect(X, Y, X, Y);
  end
  else if FTool = dtFormat then
  begin
    FMode1 := dmNone;
    Exit;
  end;

  // csContainer handles in acenstor
  if (FLastObjectOver <> nil) and FLastObjectOver.IsContain(X / FScale, Y / FScale)
  { and FDesigner.DropFields - link with memo processes there or remove} then
  begin
    bEventProcessed := FLastObjectOver.MouseDown(X, Y, Button, Shift,
      EventParams);
    FPopupFormVisible := EventParams.PopupVisible;
    if FPopupFormVisible then
    begin
      FSelectedObjects.Clear;
      FSelectedObjects.Add(FLastObjectOver);
      FMode1 := dmNone;
      FMouseDown := False;
//      if (csContainer in FLastObjectOver.frComponentStyle) then
//        FMode1 := dmContainer
    end;
    UpdateInternalSelection;
    if bEventProcessed then
    begin
      if EventParams.Refresh then
      begin
{$IFDEF FPC}
        frxUpdateControl(Self);
{$ELSE}
        Repaint;
{$ENDIF}
      end;
      Exit;
    end;
  end;

  if not ((FTool = dtZoom) and (Button = mbRight)) then
    inherited;

  CreateVirtualGuides;
  if (FMode1 = dmMoveGuide) and not (ssCtrl in Shift) and FStickToGuides then
  begin
    if FPage is TfrxReportPage then
      for i := 0 to Objects.Count - 1 do
      begin
        cc := TfrxComponent(Objects[i]);
        if not((cc is TfrxView) or (csContained in cc.frComponentStyle)) then continue;
        if Cursor = crHSplit then
        begin
          e := frxStrToFloat(VGuides[FGuide]);
          if  (Abs(cc.AbsLeft - e) <= FStickAccuracy) then
          begin
           if CheckGuids(VGuides, cc.AbsLeft + cc.Width) or (csContained in cc.frComponentStyle) and FGuidesAsAnchor then
            FGuidesObjectsSize.Add(cc)
           else
            FGuidesObjects.Add(cc);
          end;
          if  (Abs(cc.AbsLeft + cc.Width - e) <= FStickAccuracy) then
          begin
           if CheckGuids(VGuides, cc.AbsLeft) or (csContained in cc.frComponentStyle) and FGuidesAsAnchor then
            FGuidesObjectsSize.Add(cc)
           else
            FGuidesObjects.Add(cc);
          end;
        end
        else if Cursor = crVSplit then
        begin
          e := frxStrToFloat(HGuides[FGuide]);
          if  (Abs(cc.AbsTop - e) <= FStickAccuracy) then
          begin
           if CheckGuids(HGuides, cc.AbsTop + cc.Height) or (csContained in cc.frComponentStyle) and FGuidesAsAnchor then
            FGuidesObjectsSize.Add(cc)
           else
            FGuidesObjects.Add(cc);
          end;
          if  (Abs(cc.AbsTop + cc.Height - e) <= FStickAccuracy) then
          begin
           if CheckGuids(HGuides, cc.AbsTop) or (csContained in cc.frComponentStyle) and FGuidesAsAnchor then
            FGuidesObjectsSize.Add(cc)
           else
            FGuidesObjects.Add(cc);
          end;
        end;
      end;

  end;
end;

procedure TDesignerWorkspace.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  i, px, py: Integer;
  ContainedObj: TfrxComponent;
  e, OldVal, kx, ky: Extended;
  EventParams: TfrxInteractiveEventsParams;

  function GridCheck: Boolean;
  begin
    Result := (kx >= GridX) or (kx <= -GridX) or
              (ky >= GridY) or (ky <= -GridY);
    if Result then
    begin
      kx := Trunc(kx / GridX) * GridX;
      ky := Trunc(ky / GridY) * GridY;
    end;
  end;

  procedure StickToGuides(aGuidsObjects: TList; Resize: Boolean; Vertical: Boolean);
  var
    i: Integer;
    cc: TfrxComponent;
    ePos, eLen: Extended;
  begin
    for I := 0 to aGuidsObjects.Count - 1 do
    begin
      cc := TfrxComponent(aGuidsObjects[I]);
      if Vertical then
      begin
        ePos := cc.AbsLeft;
        eLen := cc.Width;
      end
      else
      begin
        ePos := cc.AbsTop;
        eLen := cc.Height;
      end;
      if (Abs(ePos - OldVal) <= FStickAccuracy) then
      begin
        if Resize then
        begin
          ePos := e;
          eLen := eLen + (OldVal - e);
        end
        else
          ePos := e;
      end;
      if (Abs(ePos + eLen - OldVal) <= FStickAccuracy) then
      begin
        if Resize then
          eLen := e - ePos
        else
          ePos := e - eLen;
      end;
      if Vertical then
      begin
        cc.Left := ePos - (cc.AbsLeft - cc.Left);
        cc.Width := eLen;
      end
      else
      begin
        cc.Top := ePos - (cc.AbsTop - cc.Top);
        cc.Height := eLen;
      end;
    end;
  end;

begin
  if FDisableUpdate then Exit;
  inherited;
  SetDefaultEventParams(EventParams);
  if FTool = dtHand then
  begin
    Cursor := crHand;

    if FMouseDown then
    begin
      kx := X - FLastMousePointX;
      ky := Y - FLastMousePointY;

      if Parent is TScrollingWinControl then
        with TScrollingWinControl(Parent) do
        begin
          px := HorzScrollBar.Position;
          py := VertScrollBar.Position;
          HorzScrollBar.Position := px - Round(kx);
          VertScrollBar.Position := py - Round(ky);
          if HorzScrollBar.Position = px then
            FLastMousePointX := X;
          if VertScrollBar.Position = py then
            FLastMousePointY := Y;
        end;
    end;
  end
  else if FTool = dtZoom then
    Cursor := crZoom
  else if FTool = dtText then
    Cursor := crIBeam
  else if FTool = dtFormat then
    Cursor := crFormat;

  if not FMouseDown and (FMode = dmSelect) and
    ((FMode1 = dmNone) or (FMode1 = dmMoveGuide)) and not FPopupFormVisible then
  begin
    if FPage is TfrxReportPage then
    begin
      for i := 0 to HGuides.Count - 1 do
      begin
        e := frxStrToFloat(HGuides[i]);
        if (Y / Scale > e - 5) and (Y / Scale < e + 5) then
        begin
          FMode1 := dmMoveGuide;
          Cursor := crVSplit;
          FGuide := i;
        end;
      end;

      for i := 0 to VGuides.Count - 1 do
      begin
        e := frxStrToFloat(VGuides[i]);
        if (X / Scale > e - 5) and (X / Scale < e + 5) then
        begin
          FMode1 := dmMoveGuide;
          Cursor := crHSplit;
          FGuide := i;
        end;
      end;
    end;
  end;

  if FMode1 in [dmNone, dmInsertObject, dmInsertLine, dmContainer, dmInplaceEdit] then
  begin
      EventParams.PopupVisible := FPopupFormVisible;

      ContainedObj := nil;
      if FPage <> nil then
        ContainedObj := FPage.GetContainedComponent(X / FScale, Y / FScale);

      { call event only for top-most objects }
      if Assigned(FMouseDownObject) and (FLastObjectOver = FMouseDownObject) then
        ContainedObj := FMouseDownObject;

      if Assigned(ContainedObj) then
      begin

        ContainedObj.MouseMove(X, Y, Shift, EventParams);
        if (FLastObjectOver <> nil) and (FLastObjectOver <> ContainedObj) then
        begin
          FLastObjectOver.MouseLeave(X, Y, ContainedObj, EventParams);
          EventParams.Refresh := True;
          FLastObjectOver := nil;
        end;
        if (ContainedObj <> nil) and (FLastObjectOver <> ContainedObj) and not ((ContainedObj is TfrxPage) and (FLastObjectOver <> nil))  then
        begin
          ContainedObj.MouseEnter(FLastObjectOver, EventParams);
          FLastObjectOver := ContainedObj;
        end;
      end
      else if FLastObjectOver <> nil then
      begin
        FLastObjectOver.MouseLeave(X, Y, nil, EventParams);
        EventParams.Refresh := True;
        FLastObjectOver := nil;
      end;

      FPopupFormVisible := EventParams.PopupVisible;
      UpdateInternalSelection;
      if EventParams.Refresh then
      begin
{$IFDEF FPC}
        frxUpdateControl(Self);
{$ELSE}
        Repaint;
{$ENDIF}
      end;
      UpdateInternalSelection;
    end;

// moving the guideline
  if FMouseDown and (FMode1 = dmMoveGuide) then
  begin
    if Cursor = crHSplit then
    begin
      e := frxStrToFloat(VGuides[FGuide]);
      kx := X / Scale - FLastMousePointX;
      ky := 0;
      OldVal := e;
      if not (GridAlign and not GridCheck) then
      begin
        FModifyFlag := True;
        e := Round((e + kx) * 100000000) / 100000000;
        FLastMousePointX := FLastMousePointX + kx;
      end;
      StickToGuides(FGuidesObjects, False, True);
      StickToGuides(FGuidesObjectsSize, True, True);
      VGuides[FGuide] := FloatToStr(e);
    end
    else
    begin
      e := frxStrToFloat(HGuides[FGuide]);
      kx := 0;
      ky := Y / Scale - FLastMousePointY;
      OldVal := e;
      if not (GridAlign and not GridCheck) then
      begin
        FModifyFlag := True;
        e := Round((e + ky) * 100000000) / 100000000;
        FLastMousePointY := FLastMousePointY + ky;
      end;
      StickToGuides(FGuidesObjects, False, False);
      StickToGuides(FGuidesObjectsSize, True, False);
      HGuides[FGuide] := FloatToStr(e);
    end;
{$IFDEF FPC}
      frxUpdateControl(Self);
{$ELSE}
      Invalidate;
{$ENDIF}
  end;
end;

procedure TDesignerWorkspace.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  e: Extended;
  c: TfrxComponent;
  EventParams: TfrxInteractiveEventsParams;

  procedure CopyFormat(MemoFrom, MemoTo: TfrxMemoView);
  begin
    MemoTo.Color := MemoFrom.Color;
    MemoTo.Font := MemoFrom.Font;
    MemoTo.Frame.Assign(MemoFrom.Frame);
    MemoTo.BrushStyle := MemoFrom.BrushStyle;
    MemoTo.HAlign := MemoFrom.HAlign;
    MemoTo.VAlign := MemoFrom.VAlign;
  end;

begin
  if FDisableUpdate then Exit;

  FSimulateMove := False;
  FVirtualGuideObjects.Clear;
  FGuidesObjects.Clear;
  FGuidesObjectsSize.Clear;

  SetDefaultEventParams(EventParams);

  if FLastObjectOver <> nil then
  begin
    TfrxComponent(FLastObjectOver).MouseUp(X, Y, Button, Shift, EventParams);
    FModifyFlag := FModifyFlag or EventParams.Modified;
  end;
  FMouseDownObject := nil;
  UpdateInternalSelection;

  if FTool = dtZoom then
  begin
    FMode1 := dmNone;
    NormalizeRect(FSelectionRect);

    with FSelectionRect do
      if (Right - Left > 5) and (Bottom - Top > 5) then
      begin
        e := Scale;

        if (Right - Left) / (Parent.ClientWidth - 16) <
           (Bottom - Top) / (Parent.ClientHeight - 16) then
          FDesigner.Scale := (Parent.ClientHeight - 16) / (Bottom - Top) * Scale else
          FDesigner.Scale := (Parent.ClientWidth - 16) / (Right - Left) * Scale;

        if Parent is TScrollingWinControl then
          with TScrollingWinControl(Parent) do
          begin
            HorzScrollBar.Position := Round((FSelectionRect.Left / e +
              TfrxReportPage(FDesigner.Page).LeftMargin * fr01cm) * Scale);
            VertScrollBar.Position := Round((FSelectionRect.Top / e +
              TfrxReportPage(FDesigner.Page).TopMargin * fr01cm) * Scale);
          end;
      end
      else
      begin
        e := Scale;
        if Button = mbLeft then
        begin
          if FDesigner.Scale >= 1 then
            FDesigner.Scale := FDesigner.Scale + 1
          else
            FDesigner.Scale := FDesigner.Scale + 0.25
        end
        else
        begin
          if FDesigner.Scale >= 2 then
            FDesigner.Scale := FDesigner.Scale - 1
          else if FDesigner.Scale > 0.4 then
            FDesigner.Scale := FDesigner.Scale - 0.25
        end;
        if Parent is TScrollingWinControl then
          with TScrollingWinControl(Parent) do
          begin
            HorzScrollBar.Position := Round((FSelectionRect.Left / e +
              TfrxReportPage(FDesigner.Page).LeftMargin * fr01cm) * Scale -
              ClientWidth / 2);
            VertScrollBar.Position := Round((FSelectionRect.Top / e +
              TfrxReportPage(FDesigner.Page).TopMargin * fr01cm) * Scale -
              ClientHeight / 2);
          end;
      end;
  end

  else if (FTool = dtText) and FMouseDown then
  begin
    FMode1 := dmNone;
    FMouseDown := False;
    NormalizeRect(FSelectionRect);

    with FSelectionRect do
      if (Right - Left > 5) or (Bottom - Top > 5) then
      begin
        if GridAlign then
        begin
          Left := Trunc(Left / GridX) * GridX;
          Right := Trunc(Right / GridX) * GridX;
          Top := Trunc(Top / GridY) * GridY;
          Bottom := Trunc(Bottom / GridY) * GridY;
        end;

        FInsertion.Left := Left / FScale;
        FInsertion.Top := Top / FScale;
        FInsertion.Width := (Right - Left) / FScale;
        FInsertion.Height := (Bottom - Top) / FScale;
        if Page is TfrxDMPPage then
          FInsertion.ComponentClass := TfrxDMPMemoView else
          FInsertion.ComponentClass := TfrxMemoView;

        if Assigned(FOnInsert) then
          FOnInsert(Self);
        AdjustBands;

        if TObject(FSelectedObjects[0]) is TfrxCustomMemoView then
          FLastObjectOver := TfrxCustomMemoView(FSelectedObjects[0]);
      end;

    if FLastObjectOver <> nil then
    begin
      FSelectedObjects.Clear;
      FSelectedObjects.Add(FLastObjectOver);
      SelectionChanged;
    end;

    Exit;
  end
  else if FTool = dtFormat then
  begin
    FSelectionRect := frxRect(X, Y, X + 1, Y + 1);
    for i := FObjects.Count - 1 downto 0 do
    begin
      c := TfrxComponent(FObjects[i]);
      if (c is TfrxMemoView) and c.IsContain(X / FScale, Y / FScale) and not
         (rfDontModify in c.Restrictions) and (c <> TfrxComponent(FSelectedObjects[0])) then
      begin
        CopyFormat(TfrxMemoView(FSelectedObjects[0]), TfrxMemoView(c));
        FModifyFlag := True;
        break;
      end;
    end;
  end;


  if FMode1 = dmMoveGuide then
  begin
    if Cursor = crHSplit then
    begin
      e := frxStrToFloat(VGuides[FGuide]);
      if (e < 3) or (e > (Width / Scale) - 3) then
        VGuides.Delete(FGuide);
    end
    else
    begin
      e := frxStrToFloat(HGuides[FGuide]);
      if (e < 3) or (e > (Height / Scale) - 3) then
        HGuides.Delete(FGuide);
    end;

{$IFDEF FPC}
      frxUpdateControl(Self);
{$ELSE}
      Repaint;
{$ENDIF}
  end;

  inherited;
end;

procedure TDesignerWorkspace.DblClick;
begin
  if FTool = dtSelect then
    inherited;
end;

procedure TDesignerWorkspace.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and FSimulateMove then
  begin
    Key := VK_DELETE;
    MouseUp(mbLeft, [], 0, 0);
  end;
  inherited;
end;

procedure TDesignerWorkspace.SimulateMove;
var
  r: TfrxRect;
begin
  FMode1 := dmMove;
  r := GetSelectionBounds;
  MouseDown(mbLeft, [], Round(r.Left / Scale) + 20, Round(r.Top / Scale) + 20);
  FSimulateMove := True;
end;

procedure TDesignerWorkspace.CreateVirtualGuides;
var
  i: Integer;
begin
  FVirtualGuideObjects.Clear;
  for i := 0 to Objects.Count - 1 do
    if (TObject(Objects[i]) is TfrxComponent) and not (csContained in TfrxComponent(Objects[i]).frComponentStyle) then
    FVirtualGuideObjects.Add(Objects[i]);
end;

procedure TDesignerWorkspace.DoFinishInPlace(Sender: TObject; Refresh,
  Modified: Boolean);
begin
  FPopupFormVisible := False;
  Inherited;
end;

function TDesignerWorkspace.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
var
  EventParams: TfrxInteractiveEventsParams;
begin
  inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  Result := True;
  if FLastObjectOver <> nil then
  begin
    SetDefaultEventParams(EventParams);
    Result := not TfrxComponent(FLastObjectOver).MouseWheel(Shift, WheelDelta, MousePos, EventParams);
    FModifyFlag := EventParams.Modified;
    UpdateInternalSelection;
    DoModify;
    if EventParams.Refresh then
    begin
{$IFDEF FPC}
      frxUpdateControl(Self);
{$ELSE}
      Repaint;
{$ENDIF}
    end;
  end;
//  if Result then
//    Result := Inherited;
end;

procedure TDesignerWorkspace.CheckGuides(var kx, ky: Extended;
  var Result: Boolean; IsMouseDown: Boolean);
var
  i: Integer;
  cc: TfrxComponent;

  procedure CheckH(coord: Extended);
  var
    i: Integer;
    e: Extended;
  begin
    if FPage is TfrxReportPage then
      for i := 0 to HGuides.Count - 1 do
      begin
        e := frxStrToFloat(HGuides[i]);
        if Abs(coord + ky - e) < 6 then
        begin
          ky := e - coord;
          break;
        end;
      end;
  end;

  procedure CheckV(coord: Extended);
  var
    i: Integer;
    e: Extended;
  begin
    if FPage is TfrxReportPage then
      for i := 0 to VGuides.Count - 1 do
      begin
        e := frxStrToFloat(VGuides[i]);
        if Abs(coord + kx - e) < 6 then
        begin
          kx := e - coord;
          break;
        end;
      end;
  end;

  procedure CheckHH(Left, Top: Extended; Obj: TfrxComponent);
  var
    i: Integer;
    c: TfrxComponent;
    e: Extended;
  begin
    for i := 0 to FVirtualGuideObjects.Count - 1 do
    begin
      c := TfrxComponent(FVirtualGuideObjects[i]);
      if c = Obj then continue;
      e := c.AbsTop;
      if Abs(Top + ky - e) < 0.001 then
        FVirtualGuides.Add(Left, e, c.AbsLeft, e);
      e := c.AbsTop + c.Height;
      if Abs(Top + ky - e) < 0.001 then
        FVirtualGuides.Add(Left, e, c.AbsLeft, e);
    end;
  end;

  procedure CheckVV(Left, Top: Extended; Obj: TfrxComponent);
  var
    i: Integer;
    c: TfrxComponent;
    e: Extended;
  begin
    for i := 0 to FVirtualGuideObjects.Count - 1 do
    begin
      c := TfrxComponent(FVirtualGuideObjects[i]);
      if c = Obj then continue;
      e := c.AbsLeft;
      if Abs(Left + kx - e) < 0.001 then
        FVirtualGuides.Add(e, c.AbsTop, e, Top);
      e := c.AbsLeft + c.Width;
      if Abs(Left + kx - e) < 0.001 then
        FVirtualGuides.Add(e, c.AbsTop, e, Top);
    end;
  end;

begin
  if not FShowGuides then Exit;

  FVirtualGuides.Clear;

  if IsMouseDown and (FMode1 = dmSizeBand) then
    CheckH(FSizedBand.Top + FSizedBand.Height);

  if not IsMouseDown and ((FMode1 = dmInsertObject) or (FMode1 = dmInsertLine)) then
  begin
    CheckV(FInsertion.Left);
    CheckH(FInsertion.Top);
    CheckVV(FInsertion.Left, FInsertion.Top, nil);
    CheckHH(FInsertion.Left, FInsertion.Top, nil);
    CheckV(FInsertion.Left + FInsertion.Width);
    CheckH(FInsertion.Top + FInsertion.Height);
    CheckVV(FInsertion.Left + FInsertion.Width, FInsertion.Top, nil);
    CheckHH(FInsertion.Left, FInsertion.Top + FInsertion.Height, nil);
  end;

  if IsMouseDown and ((FMode1 = dmInsertObject) or (FMode1 = dmInsertLine)) then
  begin
    CheckV(FInsertion.Left);
    CheckH(FInsertion.Top);
    CheckVV(FInsertion.Left, FInsertion.Top, nil);
    CheckHH(FInsertion.Left, FInsertion.Top, nil);
  end;

  if IsMouseDown and (FMode1 = dmMove) then
    for i := 0 to SelectedCount - 1 do
    begin
      cc := TfrxComponent(FSelectedObjects[i]);
      CheckV(cc.Left);
      CheckVV(cc.AbsLeft, cc.AbsTop, cc);
      CheckHH(cc.AbsLeft, cc.AbsTop, cc);
      CheckH(cc.AbsTop);
      CheckH(cc.Top);
      CheckV(cc.Left + cc.Width);
      CheckVV(cc.AbsLeft + cc.Width, cc.AbsTop, cc);
      CheckHH(cc.AbsLeft, cc.AbsTop + cc.Height, cc);
      CheckH(cc.AbsTop + cc.Height);
    end;

  if IsMouseDown and (FMode1 = dmSize) then
  begin
    cc := TfrxComponent(FSelectedObjects[0]);
    if FCT in [ct1, ct6, ct4] then
    begin
      CheckV(cc.Left);
      CheckVV(cc.AbsLeft, cc.AbsTop, cc);
    end;
    if FCT in [ct1, ct7, ct3] then
    begin
      CheckH(cc.AbsTop);
      CheckHH(cc.AbsLeft, cc.AbsTop, cc);
    end;
    if FCT in [ct3, ct5, ct2] then
    begin
      CheckV(cc.Left + cc.Width);
      CheckVV(cc.AbsLeft + cc.Width, cc.AbsTop, cc);
    end;
    if FCT in [ct4, ct8, ct2] then
    begin
      CheckH(cc.AbsTop + cc.Height);
      CheckHH(cc.AbsLeft, cc.AbsTop + cc.Height, cc);
    end;
  end;
end;

procedure TDesignerWorkspace.SetShowGuides(const Value: Boolean);
begin
  FShowGuides := Value;
  Invalidate;
end;

function TDesignerWorkspace.GetHGuides: TStrings;
begin
  Result := nil;
  if not(FPage is TfrxReportPage) then Exit;
  Result := TfrxReportPage(FPage).HGuides;
end;

function TDesignerWorkspace.GetVGuides: TStrings;
begin
  Result := nil;
  if not(FPage is TfrxReportPage) then Exit;
  Result := TfrxReportPage(FPage).VGuides;
end;

procedure TDesignerWorkspace.SetDefaultEventParams(
  var EventParams: TfrxInteractiveEventsParams);
begin
  inherited SetDefaultEventParams(EventParams);
  EventParams.EditMode := FTool;
  EventParams.SelectionList := FSelectedObjects;
  FSelectedObjects.Updated := False;
end;

procedure TDesignerWorkspace.SetHGuides(const Value: TStrings);
begin
  TfrxReportPage(FPage).HGuides := Value;
end;

procedure TDesignerWorkspace.SetVGuides(const Value: TStrings);
begin
  TfrxReportPage(FPage).VGuides := Value;
end;

procedure TDesignerWorkspace.SetVirtualGuids(VGuid, HGuid: Extended);
begin
  FVVirtualGuid := VGuid;
  FHVirtualGuid := HGuid;
end;

procedure TDesignerWorkspace.SetTool(const Value: TfrxDesignTool);
begin
  FTool := Value;
end;

end.
