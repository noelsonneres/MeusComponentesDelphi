
{******************************************}
{                                          }
{             FastReport v5.0              }
{             Map Size Ranges              }
{                                          }
{        Copyright (c) 2015 - 2016         }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapSizeRangeForm;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ELSE}
  LCLType, LMessages, LCLIntf, LCLProc,
  {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,
  frxMapRanges, frxMapHelpers, frxAnaliticGeometry;

type
  TSizeRangeItem = class(TMapRangeItem)
  private
    FAutoSize: Boolean;
    FSize: Extended;

    procedure SetSize(const Value: Extended);
    procedure SetSizeByForce(const Value: Extended);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Read(Reader: TReader); override;
    procedure Write(Writer: TWriter); override;
    function IsValueInside(Value: Extended; var OutSize: Extended): Boolean;
    function AsString(FValueFormat: String): String; override;
  published
    property AutoSize: Boolean read FAutoSize write FAutoSize;
    property Size: Extended read FSize write SetSize;
    property SizeByForce: Extended read FSize write SetSizeByForce;
  end;
(******************************************************************************)
  TSizeRangeCollection = class(TMapRangeCollection)
  protected
    function GetItem(Index: Integer): TSizeRangeItem;
    procedure SetItem(Index: Integer; const Value: TSizeRangeItem);

    function GetMixedSize(Size1, Size2: Extended; p: Extended): Extended;
  public
    constructor Create;
    function Add: TSizeRangeItem;
    function GetSize(Value: Extended): Extended;
    function GetPeerSize(StartSize, EndSize, Value: Extended): Extended;
    procedure FillRangeSizes(StartIndex, EndIndex: Integer);

    property Items[Index: Integer]: TSizeRangeItem read GetItem write SetItem; default;
  end;
(******************************************************************************)
  TMapSizeRangeForm = class(TForm)
    CollectionListBox: TListBox;
    SizeEdit: TEdit;
    StartEdit: TEdit;
    EndEdit: TEdit;
    SizeCheckBox: TCheckBox;
    StartCheckBox: TCheckBox;
    EndCheckBox: TCheckBox;
    AutoLabel: TLabel;
    OkB: TButton;
    CancelB: TButton;
    Bevel1: TBevel;
    AddButton: TButton;
    DeleteButton: TButton;
    UpSpeedButton: TSpeedButton;
    DownSpeedButton: TSpeedButton;

    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CollectionListBoxClick(Sender: TObject);
    procedure OkBClick(Sender: TObject);
    procedure SizeCheckBoxClick(Sender: TObject);
    procedure StartEditChange(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure UpSpeedButtonClick(Sender: TObject);
    procedure DownSpeedButtonClick(Sender: TObject);
  private
    FEditedCollection: TSizeRangeCollection;
    FValueFormat: String;
    FPreviousItemIndex: Integer;

    procedure RefillCollectionListBox(const ItemIndex: integer);
    procedure Syncronize;
    procedure UpdateControls;
  public
    procedure SetCollection(SRCollection: TSizeRangeCollection);
    function GetCollection: TSizeRangeCollection;

    property ValueFormat: String read FValueFormat write FValueFormat;
  end;
(******************************************************************************)
  TfrxSizeRanges = class(TMapRanges)
  private
    FSizeRangeCollection: TSizeRangeCollection;
    FStartSize: Extended;
    FEndSize: Extended;

    procedure SetSizeRangeCollection(const Value: TSizeRangeCollection);
  protected
    procedure DrawContent(Canvas: TCanvas); override;

    procedure FillRangeSizes;

    function GetSpaceWidth: Integer; override;
    function GetStepWidth: integer; override;
    function GetContentHeight: Integer; override;
  public
    constructor Create(MapScale: TMapScale);
    procedure Fill(const Values: TDoubleArray);
    property SizeRangeCollection: TSizeRangeCollection read FSizeRangeCollection write SetSizeRangeCollection;
  published
    function GetSize(Value: Extended): Extended;

    property StartSize: Extended read FStartSize write FStartSize;
    property EndSize: Extended read FEndSize write FEndSize;
  end;
(******************************************************************************)
implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  frxUtils, frxRes, frxDsgnIntf, frxMapLayer, Math;

const
  Unknown = -1;

type
  TfrxSizeRangeCollectionProperty = class(TfrxClassProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
  end;

{ TSizeRangeItem }

procedure TSizeRangeItem.AssignTo(Dest: TPersistent);
var
  CRDest: TSizeRangeItem;
begin
  inherited;
  if Dest is TSizeRangeItem then
  begin
    CRDest := TSizeRangeItem(Dest);
    CRDest.FAutoSize := FAutoSize;
    CRDest.FSize := FSize;
  end;
end;

function TSizeRangeItem.AsString(FValueFormat: String): String;
begin
  Result := inherited AsString(FValueFormat) +
    ' - ' + IfStr(AutoSize, GetStr('Auto'), Format(FValueFormat, [Size]));
end;

constructor TSizeRangeItem.Create(Collection: TCollection);
begin
  inherited;

  FAutoSize := True;
  FSize := 10;
end;

function TSizeRangeItem.IsValueInside(Value: Extended; var OutSize: Extended): Boolean;
begin
  Result := IsInside(Value);
  if Result then
    OutSize := Size;
end;

procedure TSizeRangeItem.Read(Reader: TReader);
begin
  inherited;
  FAutoSize := Reader.ReadBoolean;
  FSize := Reader.ReadFloat;
end;

procedure TSizeRangeItem.SetSize(const Value: Extended);
begin
  if FAutoSize then
    FSize := Value;
end;

procedure TSizeRangeItem.SetSizeByForce(const Value: Extended);
begin
  FSize := Value;
end;

procedure TSizeRangeItem.Write(Writer: TWriter);
begin
  inherited;
  Writer.WriteBoolean(FAutoSize);
  Writer.WriteFloat(FSize);
end;

{ TMapSizeForm }

procedure TMapSizeRangeForm.AddButtonClick(Sender: TObject);
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

procedure TMapSizeRangeForm.CollectionListBoxClick(Sender: TObject);
begin
  Syncronize;
end;

procedure TMapSizeRangeForm.DeleteButtonClick(Sender: TObject);
begin
  if CollectionListBox.ItemIndex <> Unknown then
  begin
    FEditedCollection.Delete(CollectionListBox.ItemIndex);
    RefillCollectionListBox(Min(CollectionListBox.ItemIndex, FEditedCollection.Count - 1));
  end;
end;

procedure TMapSizeRangeForm.DownSpeedButtonClick(Sender: TObject);
begin
  with CollectionListBox do
    if ItemIndex < Count - 1 then
    begin
      FEditedCollection.Swap(ItemIndex, ItemIndex + 1);
      RefillCollectionListBox(ItemIndex + 1);
    end;
end;

procedure TMapSizeRangeForm.FormCreate(Sender: TObject);
begin
  Translate(Self);

  frxResources.MainButtonImages.GetBitmap(100, UpSpeedButton.Glyph);
  frxResources.MainButtonImages.GetBitmap(101, DownSpeedButton.Glyph);

  FEditedCollection := TSizeRangeCollection.Create;
  FPreviousItemIndex := Unknown;
end;

procedure TMapSizeRangeForm.FormDestroy(Sender: TObject);
begin
  FEditedCollection.Free;
end;

procedure TMapSizeRangeForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self)
end;

function TMapSizeRangeForm.GetCollection: TSizeRangeCollection;
begin
  Result := FEditedCollection;
end;

procedure TMapSizeRangeForm.OkBClick(Sender: TObject);
begin
  Syncronize;
end;

procedure TMapSizeRangeForm.RefillCollectionListBox(const ItemIndex: integer);
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

procedure TMapSizeRangeForm.SetCollection(SRCollection: TSizeRangeCollection);
begin
  FEditedCollection.Assign(SRCollection);

  RefillCollectionListBox(0);
end;

procedure TMapSizeRangeForm.SizeCheckBoxClick(Sender: TObject);
begin
  UpdateControls;
end;

procedure TMapSizeRangeForm.StartEditChange(Sender: TObject);
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

procedure TMapSizeRangeForm.Syncronize;
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
        AutoSize := SizeCheckBox.Checked;
        SizeByForce := StrToFloat(SizeEdit.Text);
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
      SizeCheckBox.Checked := AutoSize;
      SizeEdit.Text := Format(FValueFormat, [Size]);
    end;

  FPreviousItemIndex := CollectionListBox.ItemIndex;
end;

procedure TMapSizeRangeForm.UpdateControls;
begin
  StartEdit.Enabled := not StartCheckBox.Checked;
  EndEdit.Enabled := not EndCheckBox.Checked;
  SizeEdit.Enabled := not SizeCheckBox.Checked;
end;

procedure TMapSizeRangeForm.UpSpeedButtonClick(Sender: TObject);
begin
  with CollectionListBox do
    if ItemIndex > 0 then
    begin
      FEditedCollection.Swap(ItemIndex, ItemIndex - 1);
      RefillCollectionListBox(ItemIndex - 1);
    end;
end;

{ TSizeRangeCollection }

function TSizeRangeCollection.Add: TSizeRangeItem;
begin
  Result := TSizeRangeItem(inherited Add);
end;

constructor TSizeRangeCollection.Create;
begin
  inherited Create(TSizeRangeItem);
end;

procedure TSizeRangeCollection.FillRangeSizes(StartIndex, EndIndex: Integer);
var
  NumSizes, i: Integer;
  StartSize, EndSize: Extended;
begin
  NumSizes := EndIndex - StartIndex + 1;
  StartSize := Items[StartIndex].Size;
  EndSize := Items[EndIndex].Size;
  for i := 1 to NumSizes - 2 do
    Items[StartIndex + i].Size := GetMixedSize(StartSize, EndSize, i / (NumSizes - 1));
end;

function TSizeRangeCollection.GetItem(Index: Integer): TSizeRangeItem;
begin
  Result := TSizeRangeItem(inherited GetItem(Index))
end;

function TSizeRangeCollection.GetMixedSize(Size1, Size2: Extended; p: Extended): Extended;
begin
  Result := Size1 * (1 - p) + Size2 * p;
end;

function TSizeRangeCollection.GetPeerSize(StartSize, EndSize, Value: Extended): Extended;
begin
  Result := GetMixedSize(StartSize, EndSize, Part(Value));
end;

function TSizeRangeCollection.GetSize(Value: Extended): Extended;
var
  i: Integer;
begin
  Result := 0.0;
  if IsNaN(Value) then
    Exit;
  for i := 0 to Count - 1 do
    if Items[i].IsValueInside(Value, Result) then
      Break;
end;

procedure TSizeRangeCollection.SetItem(Index: Integer; const Value: TSizeRangeItem);
begin
  inherited SetItem(Index, Value)
end;

{ TfrxSizeRangeCollectionProperty }

function TfrxSizeRangeCollectionProperty.Edit: Boolean;
var
  SRCollection: TSizeRangeCollection;
begin
  SRCollection := TfrxCustomLayer(Component).SizeRangesData;
  with TMapSizeRangeForm.Create(Designer) do
  begin
    ValueFormat := TfrxCustomLayer(Component).SizeRanges.MapScale.ValueFormat;
    SetCollection(SRCollection);

    Result := ShowModal = mrOk;
    if Result then
      SRCollection.Assign(GetCollection);
    Free;
  end;
end;

function TfrxSizeRangeCollectionProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

{ TfrxSizeRanges }

constructor TfrxSizeRanges.Create(MapScale: TMapScale);
begin
  inherited;

  FSizeRangeCollection := TSizeRangeCollection.Create;
  FMapRangeCollection := FSizeRangeCollection;
  FStartSize := 4;
  FEndSize := 20;
end;

procedure TfrxSizeRanges.DrawContent(Canvas: TCanvas);
var
  i, Left, Top, Bottom: integer;
  Center: Extended;

  procedure DrawDelimiter;
  begin
    Canvas.MoveTo(Left, Top);
    Canvas.LineTo(Left, Bottom);
  end;

  procedure DrawCircle(X, Y, D: Extended);
  begin
    Canvas.Ellipse(Round(X - D / 2), Round(Y - D / 2),
                   Round(X + D / 2), Round(Y + D / 2));
  end;
begin
  Left := SpaceWidth;
  Top := TitleHeight + ValuesHeight;
  Center := Top + ContentHeight / 2;
  Bottom := Top + ContentHeight;

  if RangeCount > 1 then
  begin
    for i := 0 to RangeCount - 1 do
    begin
      DrawCircle(Left + StepWidth / 2, Center, SizeRangeCollection[i].Size);
      DrawDelimiter;
      Left := Left + StepWidth - 1;
    end;
    DrawDelimiter;
  end
  else
  begin
    DrawCircle(Left, Center, SizeRangeCollection.GetMixedSize(StartSize, EndSize, 0));
    Left := Left + StepWidth - 1;
    DrawCircle(Left, Center, SizeRangeCollection.GetMixedSize(StartSize, EndSize, 0.5));
    Left := Left + StepWidth - 1;
    DrawCircle(Left, Center, SizeRangeCollection.GetMixedSize(StartSize, EndSize, 1));
  end;
end;

procedure TfrxSizeRanges.Fill(const Values: TDoubleArray);
begin
  FSizeRangeCollection.FillRangeValues(Values, RangeFactor);
  FillRangeSizes;
end;

procedure TfrxSizeRanges.FillRangeSizes;
begin
  if RangeCount = 0 then
    Exit;
  FSizeRangeCollection[0].Size := StartSize;
  FSizeRangeCollection[RangeCount - 1].Size := EndSize;
  FSizeRangeCollection.FillRangeSizes(0, RangeCount - 1);
end;

function TfrxSizeRanges.GetContentHeight: Integer;
begin
  Result := Max(inherited GetContentHeight, Round(EndSize));
end;

function TfrxSizeRanges.GetSize(Value: Extended): Extended;
begin
  if IsNaN(Value) then
    Result := 0.0
  else if RangeCount = 1 then
    Result := FSizeRangeCollection.GetPeerSize(StartSize, EndSize, Value)
  else
    Result := FSizeRangeCollection.GetSize(Value);
end;

function TfrxSizeRanges.GetSpaceWidth: Integer;
begin
  Result := Max(inherited GetSpaceWidth, Round(EndSize / 2) + 1);
end;

function TfrxSizeRanges.GetStepWidth: integer;
begin
  Result := Max(inherited GetStepWidth, Round(EndSize));
end;

procedure TfrxSizeRanges.SetSizeRangeCollection(const Value: TSizeRangeCollection);
begin
  FSizeRangeCollection.Assign(Value);
end;

initialization

  frxPropertyEditors.Register(TypeInfo(TSizeRangeCollection), TfrxCustomLayer, 'SizeRangesData',
    TfrxSizeRangeCollectionProperty);

end.
