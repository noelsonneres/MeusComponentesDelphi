
{******************************************}
{                                          }
{             FastReport v5.0              }
{               OLE object                 }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxOLE;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {$IFNDEF FPC}
  OleCtnrs,
  {$ENDIF}
  StdCtrls, ExtCtrls, frxClass
  {$IFNDEF FPC}
  , ActiveX
  {$ENDIF}
  {$IFDEF FPC}
  , LCLType, LCLIntf, LazHelper
  {$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF}
;


type
  TfrxSizeMode = (fsmClip, fsmScale);
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxOLEObject = class(TComponent)  // fake component
  end;


  TfrxOLEView = class(TfrxView)

  private
    FOleContainer: TOleContainer;
    FSizeMode: TfrxSizeMode;
    FStretched: Boolean;
    procedure ReadData(Stream: TStream);
    procedure SetStretched(const Value: Boolean);
    procedure WriteData(Stream: TStream);
  protected
    procedure DefineProperties(Filer: TFiler); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure GetData; override;
    class function GetDescription: String; override;
    property OleContainer: TOleContainer read FOleContainer;
    function IsEMFExportable: Boolean; override;
  published
    property BrushStyle;
    property Color;
    property Cursor;
    property DataField;
    property DataSet;
    property DataSetName;
    property FillType;
    property Fill;
    property Frame;
    property SizeMode: TfrxSizeMode read FSizeMode write FSizeMode default fsmClip;
    property Stretched: Boolean read FStretched write SetStretched default False;
    property TagStr;
    property URL;
  end;

procedure frxAssignOle(ContFrom, ContTo: TOleContainer);


implementation

uses 
  frxOLERTTI, 
{$IFNDEF NO_EDITORS}
  frxOLEEditor, 
{$ENDIF}
  frxDsgnIntf, frxRes;


procedure frxAssignOle(ContFrom, ContTo: TOleContainer);
var
  st: TMemoryStream;
begin
  {$IFNDEF FPC}
  if (ContFrom = nil) or (ContFrom.OleObjectInterface = nil) then
  begin
    ContTo.DestroyObject;
    Exit;
  end;
  st := TMemoryStream.Create;
  ContFrom.SaveToStream(st);
  st.Position := 0;
  ContTo.LoadFromStream(st);
  st.Free;
  {$ENDIF}
end;

function HimetricToPixels(const P: TPoint): TPoint;
begin
  Result.X := MulDiv(P.X, Screen.PixelsPerInch, 2540);
  Result.Y := MulDiv(P.Y, Screen.PixelsPerInch, 2540);
end;


{ TfrxOLEView }

constructor TfrxOLEView.Create(AOwner: TComponent);
begin
  inherited;
  Font.Name := 'Tahoma';
  Font.Size := 8;

  FOleContainer := TOleContainer.Create(nil);
  with FOleContainer do
  begin
    Parent := frxParentForm;
    {$IFNDEF FPC}
    SendMessage(frxParentForm.Handle, WM_CREATEHANDLE, frxInteger(FOleContainer), 0);
    AllowInPlace := False;
    AutoVerbMenu := False;
    BorderStyle := bsNone;
    SizeMode := smClip;
    {$ENDIF}
  end;
end;

destructor TfrxOLEView.Destroy;
begin
  {$IFNDEF FPC}
  SendMessage(frxParentForm.Handle, WM_DESTROYHANDLE, frxInteger(FOleContainer), 0);
  {$ENDIF}
  FOleContainer.Free;
  inherited;
end;

class function TfrxOLEView.GetDescription: String;
begin
  Result := frxResources.Get('obOLE');
end;

procedure TfrxOLEView.DefineProperties(Filer: TFiler);
begin
  inherited;
  {$IFNDEF FPC}
  Filer.DefineBinaryProperty('OLE', ReadData, WriteData,
    OleContainer.OleObjectInterface <> nil);
  {$ENDIF}
end;

procedure TfrxOLEView.ReadData(Stream: TStream);
begin
  {$IFNDEF FPC}
  FOleContainer.LoadFromStream(Stream);
  {$ENDIF}
end;

procedure TfrxOLEView.WriteData(Stream: TStream);
begin
  {$IFNDEF FPC}
  FOleContainer.SaveToStream(Stream);
  {$ENDIF}
end;

procedure TfrxOLEView.SetStretched(const Value: Boolean);
var
  VS: TPoint;
begin
  FStretched := Value;
  {$IFNDEF FPC}
  if not Stretched then
    with FOleContainer do
      if OleObjectInterface <> nil then
      begin
        Run;
        VS.X := MulDiv(Width, 2540, Screen.PixelsPerInch);
        VS.Y := MulDiv(Height, 2540, Screen.PixelsPerInch);
{$IFDEF WIN64}
        OleObjectInterface.SetExtent(DVASPECT_CONTENT, @VS);
{$ELSE}
        OleObjectInterface.SetExtent(DVASPECT_CONTENT, VS);
{$ENDIF}
      end;
  {$ENDIF}
end;

procedure TfrxOLEView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
{$IFNDEF FPC}
var
  DRect, R: TRect;
  W, H: Integer;
  ViewObject2: IViewObject2;
  S, ViewSize: TPoint;
{$ENDIF}
begin
  {$IFNDEF FPC}
  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  DRect := Rect(FX, FY, FX1, FY1);
  OleContainer.Width := FDX;
  OleContainer.Height := FDY;
  DrawBackground;

  if (FDX > 0) and (FDY > 0) then
    with OleContainer do
      if OleObjectInterface <> nil then
        if Self.SizeMode = fsmClip then
          OleDraw(OleObjectInterface, DVASPECT_CONTENT, Canvas.Handle, DRect)
        else
        begin
          if Succeeded(OleObjectInterface.QueryInterface(IViewObject2,
             ViewObject2)) then
          begin
            ViewObject2.GetExtent(DVASPECT_CONTENT, -1, nil, ViewSize);
            W := DRect.Right - DRect.Left;
            H := DRect.Bottom - DRect.Top;
            S := HimetricToPixels(ViewSize);
            if W * S.Y > H * S.X then
            begin
              S.X := S.X * H div S.Y;
              S.Y := H;
            end
            else
            begin
              S.Y := S.Y * W div S.X;
              S.X := W;
            end;

            R.Left := DRect.Left + (W - S.X) div 2;
            R.Top := DRect.Top + (H - S.Y) div 2;
            R.Right := R.Left + S.X;
            R.Bottom := R.Top + S.Y;
            OleDraw(OleObjectInterface, DVASPECT_CONTENT, Canvas.Handle, R);
          end
        end
      else
        frxResources.ObjectImages.Draw(Canvas, FX + 1, FY + 2, 22);

  DrawFrame;
  {$ENDIF}
end;

procedure TfrxOLEView.GetData;
var
  s: TMemoryStream;
begin
  inherited;
  {$IFNDEF FPC}
  if IsDataField then
  begin
    s := TMemoryStream.Create;
    try
      DataSet.AssignBlobTo(DataField, s);
      FOleContainer.LoadFromStream(s);
    finally
      s.Free;
    end;
  end;
  {$ENDIF}
end;

function TfrxOLEView.IsEMFExportable: Boolean;
begin
  Result := False;
end;




initialization
{$IFDEF DELPHI16}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfrxOLEObject, TControl);
{$ENDIF}
  frxObjects.RegisterObject1(TfrxOLEView, nil, '', '', 0, 22);

finalization
  frxObjects.UnRegister(TfrxOLEView);

end.

