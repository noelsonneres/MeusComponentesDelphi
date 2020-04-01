
{******************************************}
{                                          }
{             FastReport v5.0              }
{             Map Color Ranges             }
{                                          }
{        Copyright (c) 2015 - 2016         }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapColorRangeForm;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ELSE}
  LCLType, LMessages, LCLIntf, LCLProc, ColorBox,
  {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,
  frxMapRanges, frxMapHelpers, frxAnaliticGeometry;

type
  TColorRangeItem = class(TMapRangeItem)
  private
    FAutoColor: Boolean;
    FColor: TColor;

    procedure SetColor(const Value: TColor);
    procedure SetColorByForce(const Value: TColor);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Read(Reader: TReader); override;
    procedure Write(Writer: TWriter); override;
    function IsValueInside(Value: Extended; var OutColor: TColor): Boolean;
    function AsString(FValueFormat: String): String; override;
  published
    property AutoColor: Boolean read FAutoColor write FAutoColor;
    property Color: TColor read FColor write SetColor;
    property ColorByForce: TColor read FColor write SetColorByForce;
  end;
(******************************************************************************)
  TColorRangeCollection = class(TMapRangeCollection)
  protected
    function GetItem(Index: Integer): TColorRangeItem;
    procedure SetItem(Index: Integer; const Value: TColorRangeItem);

    function GetMixedColor(C1, C2: TColor; p: Extended): TColor;
  public
    constructor Create;
    function Add: TColorRangeItem;
    function GetColor(Value: Extended): TColor;
    function GetPeerColor(StartColor, MiddleColor, EndColor: TColor; Value: Extended): TColor;
    function GetPeerPartColor(StartColor, MiddleColor, EndColor: TColor; Part: Extended): TColor;
    procedure FillRangeColors(StartIndex, EndIndex: Integer);

    property Items[Index: Integer]: TColorRangeItem read GetItem write SetItem; default;
  end;
(******************************************************************************)
  TMapColorRangeForm = class(TForm)
    CollectionListBox: TListBox;
    CancelB: TButton;
    OkB: TButton;
    ColorColorBox: TColorBox;
    StartEdit: TEdit;
    EndEdit: TEdit;
    ColorCheckBox: TCheckBox;
    StartCheckBox: TCheckBox;
    EndCheckBox: TCheckBox;
    AutoLabel: TLabel;
    AddButton: TButton;
    DeleteButton: TButton;
    UpSpeedButton: TSpeedButton;
    DownSpeedButton: TSpeedButton;
    Bevel1: TBevel;

    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CollectionListBoxClick(Sender: TObject);
    procedure OkBClick(Sender: TObject);
    procedure ColorCheckBoxClick(Sender: TObject);
    procedure StartEditChange(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure UpSpeedButtonClick(Sender: TObject);
    procedure DownSpeedButtonClick(Sender: TObject);
  private
    FEditedCollection: TColorRangeCollection;
    FValueFormat: String;
    FPreviousItemIndex: Integer;

    procedure RefillCollectionListBox(const ItemIndex: integer);
    procedure Syncronize;
    procedure UpdateControls;
  public
    procedure SetCollection(CRCollection: TColorRangeCollection);
    function GetCollection: TColorRangeCollection;

    property ValueFormat: String read FValueFormat write FValueFormat;
  end;
(******************************************************************************)
  TfrxColorRanges = class(TMapRanges)
  private
    FColorRangeCollection: TColorRangeCollection;
    FStartColor: TColor;
    FMiddleColor: TColor;
    FEndColor: TColor;

    procedure SetColorRangeCollection(const Value: TColorRangeCollection);
  protected
    procedure DrawContent(Canvas: TCanvas); override;

    procedure FillRangeColors;
  public
    constructor Create(MapScale: TMapScale);
    procedure Fill(const Values: TDoubleArray);

    property ColorRangeCollection: TColorRangeCollection read FColorRangeCollection write SetColorRangeCollection;
  published
    function GetColor(Value: Extended): TColor;

    property StartColor: TColor read FStartColor write FStartColor;
    property MiddleColor: TColor read FMiddleColor write FMiddleColor;
    property EndColor: TColor read FEndColor write FEndColor;
  end;
(******************************************************************************)
implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  frxRes, frxUtils, frxDsgnIntf, frxMapLayer, Types, Math;

const
  Unknown = -1;

type
  TfrxColorRangeCollectionProperty = class(TfrxClassProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
  end;

{ TMapColorRangeForm }

procedure TMapColorRangeForm.AddButtonClick(Sender: TObject);
begin
  if CollectionListBox.ItemIndex = Unknown then
    FEditedCollection.Insert(0)
  else
  begin
    Syncronize;
    FEditedCollection.Insert(CollectionListBox.ItemIndex);
    with CollectionListBox do
      FEditedCollection[ItemIndex + 1].AssignTo(FEditedCollection[ItemIndex]);
  end;
  RefillCollectionListBox(Max(0, CollectionListBox.ItemIndex));
end;

procedure TMapColorRangeForm.CollectionListBoxClick(Sender: TObject);
begin
  Syncronize;
end;

procedure TMapColorRangeForm.ColorCheckBoxClick(Sender: TObject);
begin
  UpdateControls;
end;

procedure TMapColorRangeForm.DeleteButtonClick(Sender: TObject);
begin
  if CollectionListBox.ItemIndex <> Unknown then
  begin
    FEditedCollection.Delete(CollectionListBox.ItemIndex);
    RefillCollectionListBox(Min(CollectionListBox.ItemIndex, FEditedCollection.Count - 1));
  end;
end;

procedure TMapColorRangeForm.DownSpeedButtonClick(Sender: TObject);
begin
  with CollectionListBox do
    if ItemIndex < Count - 1 then
    begin
      FEditedCollection.Swap(ItemIndex, ItemIndex + 1);
      RefillCollectionListBox(ItemIndex + 1);
    end;
end;

procedure TMapColorRangeForm.FormCreate(Sender: TObject);
begin
  Translate(Self);

  frxResources.MainButtonImages.GetBitmap(100, UpSpeedButton.Glyph);
  frxResources.MainButtonImages.GetBitmap(101, DownSpeedButton.Glyph);

  FEditedCollection := TColorRangeCollection.Create;
  FPreviousItemIndex := Unknown;
end;

procedure TMapColorRangeForm.FormDestroy(Sender: TObject);
begin
  FEditedCollection.Free;
end;

procedure TMapColorRangeForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self)
end;

function TMapColorRangeForm.GetCollection: TColorRangeCollection;
begin
  Result := FEditedCollection;
end;

procedure TMapColorRangeForm.RefillCollectionListBox(const ItemIndex: integer);
var
  i: integer;
begin
  CollectionListBox.Items.Clear;

  for i := 0 to FEditedCollection.Count - 1 do
    CollectionListBox.Items.Add(FEditedCollection[i].AsString(FValueFormat));

  CollectionListBox.ItemIndex := ItemIndex;
  FPreviousItemIndex := Unknown;
  Syncronize;
end;

procedure TMapColorRangeForm.OkBClick(Sender: TObject);
begin
  Syncronize;
end;

procedure TMapColorRangeForm.SetCollection(CRCollection: TColorRangeCollection);
begin
  FEditedCollection.Assign(CRCollection);

  RefillCollectionListBox(0);
end;

procedure TMapColorRangeForm.StartEditChange(Sender: TObject);
begin
  with Sender as TEdit do
  begin
    OkB.Enabled := IsValidFloat(True, Text, True);
    if OkB.Enabled then
      Color := clWindow
    else
      Color := (Owner as TForm).Color;
  end;
end;

procedure TMapColorRangeForm.Syncronize;
begin
  if FPreviousItemIndex <> Unknown then
    if    IsValidFloat(not StartCheckBox.Checked, StartEdit.Text)
      and IsValidFloat(not EndCheckBox.Checked, EndEdit.Text) then
    begin
      with FEditedCollection[FPreviousItemIndex] do
      begin
        AutoStart := StartCheckBox.Checked;
        StartValueByForce := StrToFloat(StartEdit.Text);
        AutoEnd := EndCheckBox.Checked;
        EndValueByForce := StrToFloat(EndEdit.Text);
        AutoColor := ColorCheckBox.Checked;
        ColorByForce := ColorColorBox.Selected;
      end;
      CollectionListBox.Items[FPreviousItemIndex] := FEditedCollection[FPreviousItemIndex].AsString(FValueFormat);
    end
    else
    begin
      CollectionListBox.ItemIndex := FPreviousItemIndex;
      Exit;
    end;

  if CollectionListBox.ItemIndex <> Unknown then
    with FEditedCollection[CollectionListBox.ItemIndex] do
    begin
      StartCheckBox.Checked := AutoStart;
      StartEdit.Text := Format(FValueFormat, [StartValue]);
      EndCheckBox.Checked := AutoEnd;
      EndEdit.Text := Format(FValueFormat, [EndValue]);
      ColorCheckBox.Checked := AutoColor;
      ColorColorBox.Selected := Color;
    end;

  FPreviousItemIndex := CollectionListBox.ItemIndex;
end;

procedure TMapColorRangeForm.UpdateControls;
begin
  StartEdit.Enabled := not StartCheckBox.Checked;
  EndEdit.Enabled := not EndCheckBox.Checked;
  ColorColorBox.Enabled := not ColorCheckBox.Checked;
end;

procedure TMapColorRangeForm.UpSpeedButtonClick(Sender: TObject);
begin
  with CollectionListBox do
    if ItemIndex > 0 then
    begin
      FEditedCollection.Swap(ItemIndex, ItemIndex - 1);
      RefillCollectionListBox(ItemIndex - 1);
    end;
end;

{ TColorRangeItem }

procedure TColorRangeItem.AssignTo(Dest: TPersistent);
var
  CRDest: TColorRangeItem;
begin
  inherited;
  if Dest is TColorRangeItem then
  begin
    CRDest := TColorRangeItem(Dest);
    CRDest.FAutoColor := FAutoColor;
    CRDest.FColor := FColor;
  end;
end;

function TColorRangeItem.AsString(FValueFormat: String): String;
begin
  Result := inherited AsString(FValueFormat) +
    ' - ' + IfStr(AutoColor, GetStr('Auto'), ColorToString(Color));
end;

constructor TColorRangeItem.Create(Collection: TCollection);
begin
  inherited;

  FAutoColor := True;
  FColor := clNone;
end;

function TColorRangeItem.IsValueInside(Value: Extended; var OutColor: TColor): Boolean;
begin
  Result := IsInside(Value);
  if Result then
    if Color = clNone then
      OutColor := clWhite
    else
      OutColor := Color;
end;

procedure TColorRangeItem.Read(Reader: TReader);
begin
  inherited;
  FAutoColor := Reader.ReadBoolean;
  FColor := TColor(Reader.ReadInteger);
end;

procedure TColorRangeItem.SetColor(const Value: TColor);
begin
  if FAutoColor then
    FColor := Value;
end;

procedure TColorRangeItem.SetColorByForce(const Value: TColor);
begin
  FColor := Value;
end;

procedure TColorRangeItem.Write(Writer: TWriter);
begin
  inherited;
  Writer.WriteBoolean(FAutoColor);
  Writer.WriteInteger(LongInt(FColor));
end;

{ TColorRangeCollection }

function TColorRangeCollection.Add: TColorRangeItem;
begin
  Result := TColorRangeItem(inherited Add);
end;

procedure TColorRangeCollection.FillRangeColors(StartIndex, EndIndex: Integer);
var
  NumColors, i: Integer;
  StartColor, EndColor: TColor;
begin
  NumColors := EndIndex - StartIndex + 1;
  StartColor := Items[StartIndex].Color;
  EndColor := Items[EndIndex].Color;
  for i := 1 to NumColors - 2 do
    Items[StartIndex + i].Color := GetMixedColor(StartColor, EndColor, i / (NumColors - 1));
end;

constructor TColorRangeCollection.Create;
begin
  inherited Create(TColorRangeItem);
end;

function TColorRangeCollection.GetColor(Value: Extended): TColor;
var
  i: Integer;
begin
  Result := clWhite;
  if IsNaN(Value) then
    Exit;
  for i := 0 to Count - 1 do
    if Items[i].IsValueInside(Value, Result) then
      Break;
end;

function TColorRangeCollection.GetItem(Index: Integer): TColorRangeItem;
begin
  Result := TColorRangeItem(inherited GetItem(Index))
end;

function TColorRangeCollection.GetMixedColor(C1, C2: TColor; p: Extended): TColor;
begin
  Result := RGB(Round(GetRValue(C1) * (1 - p) + GetRValue(C2) * p),
                Round(GetGValue(C1) * (1 - p) + GetGValue(C2) * p),
                Round(GetBValue(C1) * (1 - p) + GetBValue(C2) * p));
end;

function TColorRangeCollection.GetPeerColor(StartColor, MiddleColor, EndColor: TColor; Value: Extended): TColor;
begin
  Result := GetPeerPartColor(StartColor, MiddleColor, EndColor, Part(Value));
end;

function TColorRangeCollection.GetPeerPartColor(StartColor, MiddleColor, EndColor: TColor; Part: Extended): TColor;
begin
  if MiddleColor = clNone then
    Result := GetMixedColor(StartColor, EndColor, Part)
  else if Part < 0.5 then
    Result := GetMixedColor(StartColor, MiddleColor, Part * 2)
  else
    Result := GetMixedColor(MiddleColor, EndColor, (Part - 0.5) * 2);
end;

procedure TColorRangeCollection.SetItem(Index: Integer; const Value: TColorRangeItem);
begin
  inherited SetItem(Index, Value)
end;

{ TfrxColorRanges }

constructor TfrxColorRanges.Create(MapScale: TMapScale);
begin
  inherited;

  FColorRangeCollection := TColorRangeCollection.Create;
  FMapRangeCollection := FColorRangeCollection;
  FStartColor := clRed;
  FMiddleColor := clYellow;
  FEndColor := clGreen;
end;

procedure TfrxColorRanges.DrawContent(Canvas: TCanvas);
var
  i, Left, Top, Bottom: integer;
begin
  Left := SpaceWidth;
  Top := TitleHeight + ValuesHeight;
  Bottom := Top + ContentHeight;

  if RangeCount > 1 then
    for i := 0 to RangeCount - 1 do
    begin
      Canvas.Brush.Color := ColorRangeCollection[i].Color;
      Canvas.Rectangle(Left, Top, Left + StepWidth, Bottom);
      Left := Left + StepWidth - 1;
    end
  else
    for i := 0 to 2 * StepWidth do
    begin
      Canvas.Pen.Color := FColorRangeCollection.GetPeerPartColor(StartColor, MiddleColor, EndColor, i / 2 / StepWidth);
      Canvas.MoveTo(Left + i, Top);
      Canvas.LineTo(Left + i, Bottom);
    end;
end;

procedure TfrxColorRanges.Fill(const Values: TDoubleArray);
begin
  FColorRangeCollection.FillRangeValues(Values, RangeFactor);
  FillRangeColors;
end;

procedure TfrxColorRanges.FillRangeColors;
var
  Middle: integer;
begin
  if RangeCount = 0 then
    Exit;
  FColorRangeCollection[0].Color := StartColor;
  FColorRangeCollection[RangeCount - 1].Color := EndColor;
  if RangeCount > 2 then
    if MiddleColor <> clNone then
    begin
      Middle := RangeCount div 2;
      FColorRangeCollection[Middle].Color := MiddleColor;
      FColorRangeCollection.FillRangeColors(0, Middle);
      FColorRangeCollection.FillRangeColors(Middle, RangeCount - 1);
    end
    else
      FColorRangeCollection.FillRangeColors(0, RangeCount - 1);
end;

function TfrxColorRanges.GetColor(Value: Extended): TColor;
begin
  if IsNaN(Value) then
    Result := clWhite
  else if RangeCount = 1 then
    Result := FColorRangeCollection.GetPeerColor(StartColor, MiddleColor, EndColor, Value)
  else
    Result := FColorRangeCollection.GetColor(Value);
end;

procedure TfrxColorRanges.SetColorRangeCollection(const Value: TColorRangeCollection);
begin
  FColorRangeCollection.Assign(Value);
end;

{ TfrxColorRangeCollectionProperty }

function TfrxColorRangeCollectionProperty.Edit: Boolean;
var
  CRCollection: TColorRangeCollection;
begin
  CRCollection := TfrxCustomLayer(Component).ColorRangesData;
  with TMapColorRangeForm.Create(Designer) do
  begin
    ValueFormat := TfrxCustomLayer(Component).ColorRanges.MapScale.ValueFormat;
    SetCollection(CRCollection);

    Result := ShowModal = mrOk;
    if Result then
      CRCollection.Assign(GetCollection);
    Free;
  end;
end;

function TfrxColorRangeCollectionProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

initialization

  frxPropertyEditors.Register(TypeInfo(TColorRangeCollection), TfrxCustomLayer, 'ColorRangesData',
    TfrxColorRangeCollectionProperty);

end.
