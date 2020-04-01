
{******************************************}
{                                          }
{             FastScript v1.9              }
{             Standard events              }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMX.fs_ievents;

interface

{$i fs.inc}

uses
  System.SysUtils, System.Classes, FMX.Controls, FMX.Forms, System.UITypes, FMX.Types,
  System.Types, System.Rtti, FMX.fs_iinterpreter, FMX.fs_iclassesrtti
{$IFDEF DELPHI19}
  , FMX.Graphics
{$ENDIF};

type

  PDragObject = ^TDragObject;
  TfsDragObject = class(TPersistent)
  private
    FDragObject: TDragObject;
    FFiles: TStringList;
    function GetStringList: TStringList;
  public
    function GetRect: TDragObject;
    function GetRectP: PDragObject;
    constructor Create(aDragObj: TDragObject);
    destructor Destroy; override;
  published
    property Source: TObject read FDragObject.Source write FDragObject.Source;
    property Data: {$IFDEF Delphi17}TValue{$ELSE}Variant{$ENDIF} read FDragObject.Data write FDragObject.Data;
    property Files: TStringList read GetStringList;
  end;

  TfsNotifyEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject);
    function GetMethod: Pointer; override;
  end;

  TfsMouseEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    function GetMethod: Pointer; override;
  end;

  TfsMouseMoveEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; Shift: TShiftState; X, Y: Single);
    function GetMethod: Pointer; override;
  end;

  TfsMouseWheelEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    function GetMethod: Pointer; override;
  end;

  TfsOnPaintEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    function GetMethod: Pointer; override;
  end;

  TfsCanFocusEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; var ACanFocus: Boolean);
    function GetMethod: Pointer; override;
  end;

  TfsDragOverEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; const Data: TDragObject; const Point: TPointF; var Accept: Boolean);
    function GetMethod: Pointer; override;
  end;

  TfsDragDropEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; const Data: TDragObject; const Point: TPointF);
    function GetMethod: Pointer; override;
  end;

  TfsKeyEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
    function GetMethod: Pointer; override;
  end;

  TfsKeyPressEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; var Key: Char);
    function GetMethod: Pointer; override;
  end;

  TfsCloseEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; var Action: TCloseAction);
    function GetMethod: Pointer; override;
  end;

  TfsCloseQueryEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; var CanClose: Boolean);
    function GetMethod: Pointer; override;
  end;

  TfsCanResizeEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    function GetMethod: Pointer; override;
  end;


implementation


type
  TByteSet = set of 0..7;
  PByteSet = ^TByteSet;


{ TfsNotifyEvent }

procedure TfsNotifyEvent.DoEvent(Sender: TObject);
begin
  CallHandler([Sender]);
end;

function TfsNotifyEvent.GetMethod: Pointer;
begin
  Result := @TfsNotifyEvent.DoEvent;
end;

{ TfsMouseEvent }

procedure TfsMouseEvent.DoEvent(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
var
  b: Byte;
begin
  b := Byte(PByteSet(@Shift)^);
  CallHandler([Sender, Integer(Button), b, X, Y]);
end;

function TfsMouseEvent.GetMethod: Pointer;
begin
  Result := @TfsMouseEvent.DoEvent;
end;

{ TfsMouseMoveEvent }

procedure TfsMouseMoveEvent.DoEvent(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
var
  b: Byte;
begin
  b := Byte(PByteSet(@Shift)^);
  CallHandler([Sender, b, X, Y]);
end;

function TfsMouseMoveEvent.GetMethod: Pointer;
begin
  Result := @TfsMouseMoveEvent.DoEvent;
end;

{ TfsKeyEvent }

procedure TfsKeyEvent.DoEvent(Sender: TObject; var Key: Word;
                              var KeyChar: WideChar; Shift: TShiftState);
var
  b: Byte;
begin
  b := Byte(PByteSet(@Shift)^);
  CallHandler([Sender, Key, KeyChar, b]);
  Key := Handler.Params[1].Value;
  KeyChar := WideChar(Cardinal(Handler.Params[2].Value));
end;

function TfsKeyEvent.GetMethod: Pointer;
begin
  Result := @TfsKeyEvent.DoEvent;
end;

{ TfsKeyPressEvent }

procedure TfsKeyPressEvent.DoEvent(Sender: TObject; var Key: Char);
begin
  CallHandler([Sender, Key]);
  Key := String(Handler.Params[1].Value)[1];
end;

function TfsKeyPressEvent.GetMethod: Pointer;
begin
  Result := @TfsKeyPressEvent.DoEvent;
end;

{ TfsCloseEvent }

procedure TfsCloseEvent.DoEvent(Sender: TObject; var Action: TCloseAction);
begin
  CallHandler([Sender, Integer(Action)]);
  Action := Handler.Params[1].Value;
end;

function TfsCloseEvent.GetMethod: Pointer;
begin
  Result := @TfsCloseEvent.DoEvent;
end;

{ TfsCloseQueryEvent }

procedure TfsCloseQueryEvent.DoEvent(Sender: TObject; var CanClose: Boolean);
begin
  CallHandler([Sender, CanClose]);
  CanClose := Handler.Params[1].Value;
end;

function TfsCloseQueryEvent.GetMethod: Pointer;
begin
  Result := @TfsCloseQueryEvent.DoEvent;
end;

{ TfsCanResizeEvent }

procedure TfsCanResizeEvent.DoEvent(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  CallHandler([Sender, NewWidth, NewHeight, Resize]);
  NewWidth := Handler.Params[1].Value;
  NewHeight := Handler.Params[2].Value;
  Resize := Handler.Params[3].Value;
end;

function TfsCanResizeEvent.GetMethod: Pointer;
begin
  Result := @TfsCanResizeEvent.DoEvent;
end;

{ TfsMouseWheelEvent }

procedure TfsMouseWheelEvent.DoEvent(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
var
  b: Byte;
begin
  b := Byte(PByteSet(@Shift)^);
  CallHandler([Sender, b, WheelDelta, Boolean(Handled)]);
  Handled := Handler.Params[3].Value;
end;

function TfsMouseWheelEvent.GetMethod: Pointer;
begin
  Result := @TfsMouseWheelEvent.DoEvent;
end;

{ TfsOnPaintEvent }

procedure TfsOnPaintEvent.DoEvent(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
var
  r: TfsRectF;
begin
  r := TfsRectF.Create(ARect);
  CallHandler([Sender, Canvas, r]);
  r.Free;
end;

function TfsOnPaintEvent.GetMethod: Pointer;
begin
  Result := @TfsOnPaintEvent.DoEvent;
end;

{ TfsCanFocusEvent }

procedure TfsCanFocusEvent.DoEvent(Sender: TObject; var ACanFocus: Boolean);
begin
  CallHandler([Sender, ACanFocus]);
  ACanFocus := Handler.Params[1].Value;
end;

function TfsCanFocusEvent.GetMethod: Pointer;
begin
  Result := @TfsCanFocusEvent.DoEvent;
end;

{ TfsDragOverEvent }

procedure TfsDragOverEvent.DoEvent(Sender: TObject; const Data: TDragObject;
  const Point: TPointF; var Accept: Boolean);
var
  dObj: TfsDragObject;
begin
  dObj := TfsDragObject.Create(Data);
  CallHandler([Sender, dObj, Accept]);
  dObj.Free;
  Accept := Handler.Params[3].Value;
end;

function TfsDragOverEvent.GetMethod: Pointer;
begin
  Result := @TfsDragOverEvent.DoEvent;
end;

{ TfsDragObject }

constructor TfsDragObject.Create(aDragObj: TDragObject);
var
  idx: Integer;
begin
  FFiles := TStringList.Create;
  FDragObject.Source := aDragObj.Source;
  FDragObject.Data := aDragObj.Data;
  for idx := Low(FDragObject.Files) to High(FDragObject.Files) do
    FFiles.Add(FDragObject.Files[idx]);
end;

destructor TfsDragObject.Destroy;
begin
  FFiles.Free;
  inherited;
end;

function TfsDragObject.GetRect: TDragObject;
var
  idx: Integer;
begin
  SetLength(FDragObject.Files, FFiles.Count);
  for idx := 0 to FFiles.Count - 1 do
    FDragObject.Files[idx] := FFiles.Strings[idx];
  Result := FDragObject;
end;

function TfsDragObject.GetRectP: PDragObject;
var
  idx: Integer;
begin
  SetLength(FDragObject.Files, FFiles.Count);
  for idx := 0 to FFiles.Count - 1 do
    FDragObject.Files[idx] := FFiles.Strings[idx];
  Result := @FDragObject;
end;

function TfsDragObject.GetStringList: TStringList;
begin
  Result := FFiles;
end;

{ TfsDragDropEvent }

procedure TfsDragDropEvent.DoEvent(Sender: TObject; const Data: TDragObject;
  const Point: TPointF);
var
  dObj: TfsDragObject;
  aPoint: TfsPointF;
begin
  dObj := TfsDragObject.Create(Data);
  aPoint := TfsPointF.Create(Point);
  CallHandler([Sender, dObj, aPoint]);
  dObj.Free;
  aPoint.Free;
end;

function TfsDragDropEvent.GetMethod: Pointer;
begin
  Result := @TfsDragDropEvent.DoEvent;
end;

end.