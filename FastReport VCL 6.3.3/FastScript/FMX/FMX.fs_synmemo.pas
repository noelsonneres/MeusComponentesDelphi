
{******************************************}
{                                          }
{             FastScript v1.9              }
{         Syntax memo FMX control          }
{                                          }
{  (c) 2003-2011 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

{ Simple syntax highlighter. Supports Pascal, C++, JS, VB and SQL syntax.

  Assign text to Text property.
  Assign desired value to SyntaxType property.
  Call SetPos to move caret.
  Call ShowMessage to display an error message at the bottom.
}

unit FMX.fs_synmemo;

interface

{$I fs.inc}
{$I fmx.inc}

uses
  System.Classes, System.Variants, System.UIConsts, System.SysUtils, System.UITypes, System.Types,
  FMX.Controls, FMX.Forms, FMX.Menus, FMX.Types, FMX.Edit, FMX.Platform, FMX.TreeView
{$IFDEF DELPHI18}
  ,FMX.StdCtrls
{$ENDIF}
{$IFDEF DELPHI19}
  , FMX.Graphics
{$ENDIF}
{$IFDEF DELPHI19}
  , FMX.Text
{$ENDIF};

type
  TSyntaxType = (stPascal, stCpp, stJs, stVB, stSQL, stText);
  TCharAttr = (caNo, caText, caBlock, caComment, caKeyword, caString);
  TCharAttributes = set of TCharAttr;

type
  TfsBorderSettings = class(TPersistent)
  private
    FFill: TBrush;
    FWidth: Integer;
  private
    procedure SetFill(const Value: TBrush);
    procedure SetWidth(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Fill: TBrush read FFill write SetFill;
    property Width: Integer read FWidth write SetWidth;
  end;

  TfsFontSettings = class(TPersistent)
  private
    FFill: TBrush;
    FFont: TFont;
    procedure SetFill(const Value: TBrush);
    procedure SetFont(const Value: TFont);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Fill: TBrush read FFill write SetFill;
    property Font: TFont read FFont write SetFont;
  end;

  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
  TfsSyntaxMemo = class(TStyledControl{$IFDEF DELPHI18}, ICaret{$ENDIF})
  private
{$IFDEF DELPHI18}
    FCaret: TCaret;
{$ENDIF}
    FBorder: TfsBorderSettings;
    FFill: TBrush;
    FFontSettings: TfsFontSettings;
    FGutterFill: TBrush;
    FAllowLinesChange: Boolean;
    FCharHeight: Single;
    FCharWidth: Single;
    FDoubleClicked: Boolean;
    FDown: Boolean;
    FGutterWidth: Integer;
    FFooterHeight: Integer;
    FIsMonoType: Boolean;
    FKeywords: String;
    FMaxLength: Integer;
    FMessage: String;
    FModified: Boolean;
    FMoved: Boolean;
    FOffset: TPoint;
    FPos: TPoint;
    FReadOnly: Boolean;
    FSelEnd: TPoint;
    FSelStart: TPoint;
    FSynStrings: TStrings;
    FSyntaxType: TSyntaxType;
    FTempPos: TPoint;
    FText: TStringList;
    FKeywordAttr: TfsFontSettings;
    FStringAttr: TfsFontSettings;
    FTextAttr: TfsFontSettings;
    FCommentAttr: TfsFontSettings;
    FBlockColor: TAlphaColor;
    FBlockFontColor: TAlphaColor;
    FUndo: TStringList;
    FUpdating: Boolean;
    FUpdatingSyntax: Boolean;
    FVScroll: TScrollBar;
    FWindowSize: TPoint;
    FPopupMenu: TPopupMenu;
    KWheel: Integer;
    LastSearch: String;
    FShowGutter: boolean;
    FShowFooter: boolean;
    Bookmarks: array of Integer;
    FActiveLine: Integer;
    FOnChange: TNotifyEvent;
    FTmpCanvas: TBitmap;
    procedure CalcCharSize;
    function GetCharWidth(Str: String): Single;
    function GetText: TStrings;
    procedure SetText(Value: TStrings);
    procedure SetSyntaxType(Value: TSyntaxType);
    procedure SetShowGutter(Value: boolean);
    procedure SetShowFooter(Value: boolean);
    function FMemoFind(Text: String; var Position : TPoint): boolean;
    function GetCharAttr(Pos: TPoint): TCharAttributes;
    function GetLineBegin(Index: Integer): Integer;
    function GetPlainTextPos(Pos: TPoint): Integer;
    function GetPosPlainText(Pos: Integer): TPoint;
    function GetSelText: String;
    function LineAt(Index: Integer): String;
    function LineLength(Index: Integer): Integer;
    function Pad(n: Integer): String;
    procedure AddSel;
    procedure AddUndo;
    procedure ClearSel;
    procedure CreateSynArray;
    procedure DoChange;
    procedure EnterIndent;
    procedure SetSelText(Value: String);
    procedure ShiftSelected(ShiftRight: Boolean);
    procedure ShowCaretPos;
    procedure TabIndent;
    procedure UnIndent;
    procedure UpdateScrollBar;
    procedure UpdateSyntax;
    procedure DoLeft;
    procedure DoRight;
    procedure DoUp;
    procedure DoDown;
    procedure DoHome(Ctrl: Boolean);
    procedure DoEnd(Ctrl: Boolean);
    procedure DoPgUp;
    procedure DoPgDn;
    procedure DoChar(Ch: Char);
    procedure DoReturn;
    procedure DoDel;
    procedure DoBackspace;
    procedure DoCtrlI;
    procedure DoCtrlU;
    procedure DoCtrlR;
    procedure DoCtrlL;
    procedure ScrollClick(Sender: TObject);
    procedure ScrollEnter(Sender: TObject);
    procedure LinesChange(Sender: TObject);
    procedure ShowPos;
    procedure BookmarkDraw(Y :Single; ALine : integer);
    procedure ActiveLineDraw(Y :Single; ALine : integer);
    procedure CorrectBookmark(Line : integer; delta : integer);
    procedure SetKeywordAttr(Value: TfsFontSettings);
    procedure SetStringAttr(Value: TfsFontSettings);
    procedure SetTextAttr(Value: TfsFontSettings);
    procedure SetCommentAttr(Value: TfsFontSettings);
    procedure SetBorder(const Value: TfsBorderSettings);
    procedure SetFill(const Value: TBrush);
    procedure SetFontSettings(const Value: TfsFontSettings);
    procedure SetGutterFill(const Value: TBrush);
  protected
    procedure SetParent(const Value: TFmxObject); override;
    function GetClientRect: TRectF;
    procedure DblClick; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure KeyDown(var Key: Word; var KeyChar: WideChar; Shift: TShiftState); override;
    procedure CopyPopup(Sender: TObject);
    procedure PastePopup(Sender: TObject);
    procedure CutPopup(Sender: TObject);
    procedure MouseWheel(Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean); override;
    procedure DOver(Sender: TObject; const Data: TDragObject; const Point: TPointF; {$IFNDEF DELPHI20}var Accept: Boolean{$ELSE} var Operation: TDragOperation{$ENDIF});
    procedure DDrop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
    procedure DoExit; override;
    procedure Resize; override;
    procedure UpdateWindowSize;
    procedure FontChanged(Sender: TObject);
    procedure DialogKey(var Key: Word; Shift: TShiftState); override;
{$IFDEF Delphi18}
    function ICaret.GetObject = GetCaret;
    function GetCaret: TCustomCaret;
    procedure SetCaret(const Value: TCaret);
    procedure ShowCaret;
    procedure HideCaret;
{$ENDIF}
{$IFDEF Delphi17}
    function CreateCaret: TCaret; {$IFNDEF Delphi18} override; {$ENDIF}
{$ENDIF}
    procedure SetAttr(aCanvas: TCanvas; a: TCharAttributes);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure CopyToClipboard;
    procedure CutToClipboard;
    procedure PasteFromClipboard;
    procedure SetPos(x, y: Integer);
    procedure ShowMessage(s: String);
    procedure Undo;
    procedure UpdateView;
    function GetPos: TPoint;
    function Find(Text: String): boolean;
    property Modified: Boolean read FModified write FModified;
    property SelText: String read GetSelText write SetSelText;
    function  IsBookmark(Line : integer): integer;
    procedure AddBookmark(Line, Number : integer);
    procedure DeleteBookmark(Number : integer);
    procedure GotoBookmark(Number : integer);
    procedure SetActiveLine(Line : Integer);
    function GetActiveLine: Integer;
{$IFDEF Delphi18}
    property Caret: TCaret read FCaret write SetCaret;
{$ENDIF}
  published
    property Align;
    property Anchors;
    property DragMode;
    property Enabled;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Width;
    property Height;
    property Visible;
{$IFDEF Delphi18}
	property Cursor;
{$ENDIF}
    property BlockColor: TAlphaColor read FBlockColor write FBlockColor;
    property BlockFontColor: TAlphaColor read FBlockFontColor write FBlockFontColor;
    property CommentAttr: TfsFontSettings read FCommentAttr write SetCommentAttr;
    property KeywordAttr: TfsFontSettings read FKeywordAttr write SetKeywordAttr;
    property StringAttr: TfsFontSettings read FStringAttr write SetStringAttr;
    property TextAttr: TfsFontSettings read FTextAttr write SetTextAttr;
    property Border: TfsBorderSettings read FBorder write SetBorder;
    property Fill: TBrush read FFill write SetFill;
    property FontSettings: TfsFontSettings read FFontSettings write SetFontSettings;
    property GutterFill: TBrush read FGutterFill write SetGutterFill;
    property Lines: TStrings read GetText write SetText;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property SyntaxType: TSyntaxType read FSyntaxType write SetSyntaxType;
    property ShowFooter: boolean read FShowFooter write SetShowFooter;
    property ShowGutter: boolean read FShowGutter write SetShowGutter;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfsSynMemoSearch = class(TForm)
    Search: TButton;
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SynMemoSearch: TfsSynMemoSearch;

implementation

{$R *.FMX}
{$IFDEF DELPHI18}
type THachCaret = class(TCaret);
{$ENDIF}

const
  PasKeywords =
     'and,array,begin,case,const,div,do,downto,else,end,except,finally,'+
     'for,function,if,in,is,mod,nil,not,of,or,procedure,program,repeat,shl,'+
     'shr,string,then,to,try,until,uses,var,while,with,xor';

  CppKeywords =
     'bool,break,case,char,continue,define,default,delete,do,double,else,'+
     'except,finally,float,for,if,include,int,is,new,return,string,switch,try,'+
     'variant,void,while';

  SQLKeywords =
    'active,after,all,alter,and,any,as,asc,ascending,at,auto,' +
    'base_name,before,begin,between,by,cache,cast,check,column,commit,' +
    'committed,computed,conditional,constraint,containing,count,create,' +
    'current,cursor,database,debug,declare,default,delete,desc,descending,' +
    'distinct,do,domain,drop,else,end,entry_point,escape,exception,execute,' +
    'exists,exit,external,extract,filter,for,foreign,from,full,function,' +
    'generator,grant,group,having,if,in,inactive,index,inner,insert,into,is,' +
    'isolation,join,key,left,level,like,merge,names,no,not,null,of,on,only,' +
    'or,order,outer,parameter,password,plan,position,primary,privileges,' +
    'procedure,protected,read,retain,returns,revoke,right,rollback,schema,' +
    'select,set,shadow,shared,snapshot,some,suspend,table,then,to,' +
    'transaction,trigger,uncommitted,union,unique,update,user,using,values,' +
    'view,wait,when,where,while,with,work';

  JSKeywords =
    'break,case,continue,default,delete,do,else,except,finally,for,function,' +
    'import,in,is,if,new,return,switch,try,var,while,with';

  VBKeywords =
    'addressof,and,as,byref,byval,case,catch,delete,dim,do,else,elseif,' +
    'end,endif,exit,finally,for,function,if,imports,is,loop,mod,new,next,' +
    'not,or,rem,return,select,set,step,sub,then,to,try,wend,while,with,xor';


  WordChars = ['a'..'z', 'A'..'Z', '0'..'9', '_'];
  LineBreak: AnsiString = sLineBreak;

function IsUnicodeChar(Chr: Char): Boolean;
begin
  Result := ((Chr >= Char($007F)) and (Chr <= Char($FFFF)));
end;


{ TfsSyntaxMemo }

constructor TfsSyntaxMemo.Create(AOwner: TComponent);
var
  m: TMenuItem;
  i: integer;
begin
  inherited Create(AOwner);
  FTmpCanvas := TBitmap.Create(1, 1);
{$IFDEF DELPHI18}
  FCaret := CreateCaret;
{$ENDIF}
  FVScroll := TScrollBar.Create(Self);
  FVScroll.Stored := False;
  FVScroll.Orientation := TOrientation.orVertical;

  FFontSettings := TfsFontSettings.Create;
  FFontSettings.Font.OnChanged := FontChanged;
  FFontSettings.Fill.Color := TAlphaColorRec.Black;

  FCommentAttr := TfsFontSettings.Create;
  FCommentAttr.Fill.Color := TAlphaColorRec.Green;
  FCommentAttr.Font.Style := [TFontStyle.fsItalic];

  FKeywordAttr := TfsFontSettings.Create;
  FKeywordAttr.FFill.Color := TAlphaColorRec.Navy;
  FKeywordAttr.Font.Style := [TFontStyle.fsBold];

  FStringAttr := TfsFontSettings.Create;
  FStringAttr.Fill.Color := TAlphaColorRec.Navy;
  FStringAttr.Font.Style := [];

  FTextAttr := TfsFontSettings.Create;
  FTextAttr.Fill.Color := TAlphaColorRec.Black;
  FTextAttr.Font.Style := [];

  FBorder := TfsBorderSettings.Create;
  FFill := TBrush.Create(TBrushKind.bkSolid, TAlphaColorRec.White);
  FGutterFill := TBrush.Create(TBrushKind.bkSolid, TAlphaColorRec.Whitesmoke);

  if AOwner is TFmxObject then
    Parent := AOwner as TFmxObject;

  OnDragOver := DOver;
  OnDragDrop := DDrop;
  KWheel := -1;


  FText := TStringList.Create;
  FUndo := TStringList.Create;
  FSynStrings := TStringList.Create;
  FText.Add('');
  FText.OnChange := LinesChange;
  FMaxLength := 1024;
  SyntaxType := stPascal;
  FMoved := True;
  SetPos(1, 1);
  FOffset := Point(0, 0);
  CanFocus := True;
  Cursor := crIBeam;

  FBlockColor := TAlphaColorRec.Blue;
  FBlockFontColor := TAlphaColorRec.White;

  FPopupMenu := TPopupMenu.Create(Self);
  m := TMenuItem.Create(FPopupMenu);
  m.Text := 'Cut';
  m.OnClick := CutPopup;
  FPopupMenu.AddObject(m);
  m := TMenuItem.Create(FPopupMenu);
  m.Text := 'Copy';
  m.OnClick := CopyPopup;
  FPopupMenu.AddObject(m);
  m := TMenuItem.Create(FPopupMenu);
  m.Text := 'Paste';
  m.OnClick := PastePopup;
  FPopupMenu.AddObject(m);

  LastSearch := '';
  Setlength(Bookmarks, 10);
  for i := 0 to Length(Bookmarks)-1 do
    Bookmarks[i] := -1;

  FActiveLine := -1;

  Height := 200;
  Width := 200;
  CalcCharSize;
end;

destructor TfsSyntaxMemo.Destroy;
begin
  FPopupMenu.Free;
  FCommentAttr.Free;
  FKeywordAttr.Free;
  FStringAttr.Free;
  FFontSettings.Free;
  FTextAttr.Free;
  FText.Free;
  FUndo.Free;
  FSynStrings.Free;
  //FVScroll.Free;
  FFill.Free;
  FBorder.Free;
  FGutterFill.Free;
{$IFDEF DELPHI18}
  FCaret.Free;
{$ENDIF}
  FreeAndNil(FTmpCanvas);
  inherited;
end;

procedure TfsSyntaxMemo.CalcCharSize;
var
  tmpBmp: TBitmap;
  r: TRectF;
begin
  tmpBmp := TBitmap.Create(1, 1);
  with tmpBmp.Canvas do
  begin
    Font.Assign(FFontSettings.Font);
    Font.Style := [];
    r := RectF(0, 0, 1000, 1000);
    MeasureText(r, 'WWWWWW', True, [], TTextAlign.taLeading); // taLeading returns incorrect results in xe2
    FCharHeight := r.Height + 2;
    FCharWidth := r.Width / 6;
    FIsMonoType := Pos('COURIER NEW', AnsiUppercase(FFontSettings.Font.Family)) <> 0;
  end;
  tmpBmp.Free;
end;

{$IFDEF Delphi17}
function TfsSyntaxMemo.CreateCaret: TCaret;
begin
  Result := TCaret.Create(Self);
  Result.Visible := True;
{$IFDEF DELPHI20}
  Result.ReadOnly := False;
  Result.Color := claBlack;
{$ENDIF}
  Result.Pos := TPointF.Create(1, 1);
end;
{$ENDIF}

{$IFDEF DELPHI18}
function TfsSyntaxMemo.GetCaret: TCustomCaret;
begin
  Result := FCaret;
end;

procedure TfsSyntaxMemo.SetCaret(const Value: TCaret);
begin
  if Assigned(FCaret) then
    FCaret.Assign(Value);
end;

procedure TfsSyntaxMemo.ShowCaret;
begin
  THachCaret(FCaret).Show;
end;

procedure TfsSyntaxMemo.HideCaret;
begin
  THachCaret(FCaret).Hide;
end;
{$ENDIF}

procedure TfsSyntaxMemo.ShowCaretPos;
var
  cWidth: Single;
  LineLen: Integer;
begin
    cWidth  := GetCharWidth(Copy(LineAt(FPos.Y - 1), FOffset.X, FPos.X - 1  - FOffset.X));
    LineLen := LineLength(FPos.Y - 1);
    if LineLen < FPos.X then
      cWidth := Round(cWidth + FCharWidth * (FPos.X - 1 - LineLen));
{$IFNDEF Delphi18}
{$IFDEF Delphi17}
  if IsFocused then
  begin
    CaretVisible := False;
    SetCaretParams(PointF(
      FCharWidth * (FPos.X - 1 - FOffset.X) + FGutterWidth + FBorder.Width + 1,
      FCharHeight * (FPos.Y - 1 - FOffset.Y) + 1),
      PointF(2, FCharHeight), claBlack);
    CaretVisible := True;
  end
  else
    CaretVisible := False;
{$ELSE}
  if IsFocused then
  begin
    SetCaretSize(PointF(2, FCharHeight));
    SetCaretPos(PointF(
      FCharWidth * (FPos.X - 1 - FOffset.X) + FGutterWidth + FBorder.Width + 1,
      FCharHeight * (FPos.Y - 1 - FOffset.Y) + 1));
    ShowCaretProc;
  end
  else
    HideCaret;
{$ENDIF}
{$ELSE}
  if IsFocused then
  begin
    //SetCaretSize(PointF(2, FCharHeight));
    FCaret.Size := PointF(2, FCharHeight);
    FCaret.Pos := PointF(
      cWidth + FGutterWidth + FBorder.Width + 1,
      FCharHeight * (FPos.Y - 1 - FOffset.Y) + 1);
    ShowCaret;
//    SetCaretPos(PointF(
//      FCharWidth * (FPos.X - 1 - FOffset.X) + FGutterWidth + FBorder.Width + 1,
//      FCharHeight * (FPos.Y - 1 - FOffset.Y) + 1));
//    ShowCaretProc;
  end
  else
    HideCaret;
{$ENDIF}
end;

procedure TfsSyntaxMemo.ShowPos;
var
  cRect: TRectF;
begin
  if FFooterHeight > 0 then
    with Canvas do
    begin
      Font.Family := 'Tahoma';
      Font.Style := [];
      Font.Size := 11;
      Fill.Color := TAlphaColorRec.Black;
      cRect := GetClientRect;
      FillText(RectF(cRect.Left + FGutterWidth + 2, cRect.Bottom - TextHeight('|') - 8,
              FGutterWidth + 4 + FCharWidth * 10 ,
              (Self.Height - TextHeight('|') - 4) + FCharHeight), IntToStr(FPos.y)
                + ' : ' + IntToStr(FPos.x) + '    ', FALSE, 1, [], TTextAlign.taLeading);
    end;
end;

procedure TfsSyntaxMemo.SetParent(const Value: TFmxObject);
begin
  inherited SetParent(Value);
  if (Parent = nil) or (csDestroying in ComponentState) then Exit;
  ShowGutter := True;
  ShowFooter := True;
  FVScroll.Parent := Self;
  FVScroll.OnChange := ScrollClick;
  FVScroll.OnEnter := ScrollEnter;
end;

function TfsSyntaxMemo.GetClientRect: TRectF;
begin
  if FVScroll.Visible then
    Result := RectF(FBorder.Width, FBorder.Width,
                    Width - FVScroll.Width - FBorder.Width,
                    Height - FBorder.Width)
  else
    Result := RectF(FBorder.Width, FBorder.Width,
                    Width - FBorder.Width, Height - FBorder.Width);
end;

procedure TfsSyntaxMemo.UpdateSyntax;
begin
  CreateSynArray;
  Repaint;
end;

procedure TfsSyntaxMemo.UpdateScrollBar;
begin
  with FVScroll do
  begin
// prevent OnScroll event
    FUpdating := True;

    Value := 0;
    ViewportSize  := 0;

    Max := FText.Count;
    SmallChange := 1;
    if FWindowSize.Y < Max then
    begin
      Visible := True;
      ViewportSize := FWindowSize.Y;
    end
    else
      Visible := False;
    ViewportSize := FWindowSize.Y;
    Value := FOffset.Y;

    FUpdating := False;
  end;
end;

function TfsSyntaxMemo.GetText: TStrings;
var
  i: Integer;
begin
  for i := 0 to FText.Count - 1 do
    FText[i] := LineAt(i);
  Result := FText;
  FAllowLinesChange := True;
end;

procedure TfsSyntaxMemo.SetText(Value: TStrings);
begin
  FAllowLinesChange := True;
  FText.Assign(Value);
end;

procedure TfsSyntaxMemo.SetSyntaxType(Value: TSyntaxType);
begin
  FSyntaxType := Value;
  if Value = stPascal then
    FKeywords := PasKeywords
  else if Value = stCpp then
    FKeywords := CppKeywords
  else if Value = stSQL then
    FKeywords := SQLKeywords
  else if Value = stVB then
    FKeywords := VBKeywords
  else if Value = stJS then
    FKeywords := JSKeywords
  else
    FKeywords := '';
  UpdateSyntax;
end;

function TfsSyntaxMemo.GetPos: TPoint;
begin
  Result := FPos;
end;

procedure TfsSyntaxMemo.DoChange;
begin
  FModified := True;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TfsSyntaxMemo.LinesChange(Sender: TObject);
begin
  if FAllowLinesChange then
  begin
    UpdateSyntax;
    FAllowLinesChange := False;
    if FText.Count = 0 then
      FText.Add('');
    FMoved := True;
    FUndo.Clear;
    FPos := Point(1, 1);
    FOffset := Point(0, 0);
    SetPos(FPos.X, FPos.Y);
    ClearSel;
    ShowCaretPos;
    UpdateScrollBar;
  end;
end;

procedure TfsSyntaxMemo.ShowMessage(s: String);
begin
  FMessage := s;
  Repaint;
end;

procedure SetClipboard(const Value: String);
{$IFDEF Delphi17}
var
  ClipService: IFMXClipboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, IInterface(ClipService)) then
    ClipService.SetClipboard(Value);
end;
{$ELSE}
begin
  Platform.SetClipboard(Value);
end;
{$ENDIF}

function GetClipboard: String;
{$IFDEF Delphi17}
var
  ClipService: IFMXClipboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, IInterface(ClipService)) then
    Result := ClipService.GetClipboard.ToString
  else
    Result := '';
end;
{$ELSE}
begin
  Result := VarToStr(Platform.GetClipboard);
end;
{$ENDIF}

procedure TfsSyntaxMemo.CopyToClipboard;
begin
  if FSelStart.X <> 0 then
    SetClipboard(SelText);
end;

procedure TfsSyntaxMemo.CutToClipboard;
begin
  if not FReadOnly then
  begin
    if FSelStart.X <> 0 then
    begin
      SetClipboard(SelText);
      SelText := '';
    end;
    CorrectBookmark(FSelStart.Y, FSelStart.Y - FSelEnd.Y);
    Repaint;
  end;
end;

procedure TfsSyntaxMemo.PasteFromClipboard;
begin
  if (not FReadOnly) then
    SelText := GetClipboard;
end;

function TfsSyntaxMemo.LineAt(Index: Integer): String;
begin
  if Index < FText.Count then
    Result := TrimRight(FText[Index])
  else
    Result := '';
end;

function TfsSyntaxMemo.LineLength(Index: Integer): Integer;
begin
  if Index < 0 then
    Result := 0 else
    Result := Length(LineAt(Index));
end;

function TfsSyntaxMemo.Pad(n: Integer): String;
begin
  result := '';
  SetLength(result, n);
  Result := StringOfChar(Char(' '), n)
end;

procedure TfsSyntaxMemo.AddUndo;
begin
  if not FMoved then exit;
  FUndo.Add(Format('%5d%5d', [FPos.X, FPos.Y]) + FText.Text);
  if FUndo.Count > 32 then
    FUndo.Delete(0);
end;

procedure TfsSyntaxMemo.Undo;
var
  s: String;
begin
  FMoved := True;
  if FUndo.Count = 0 then exit;
  s := FUndo[FUndo.Count - 1];
  FPos.X := StrToInt(Copy(s, 1, 5));
  FPos.Y := StrToInt(Copy(s, 6, 5));
  FText.Text := Copy(s, 11, Length(s) - 10);
  FUndo.Delete(FUndo.Count - 1);
  SetPos(FPos.X, FPos.Y);
  UpdateSyntax;
  DoChange;
end;

function TfsSyntaxMemo.GetPlainTextPos(Pos: TPoint): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Pos.Y - 2 do
    Result := Result + Length(FText[i]) + Length(LineBreak);
  Result := Result + Pos.X;
end;

function TfsSyntaxMemo.GetPosPlainText(Pos: Integer): TPoint;
var
  i: Integer;
  s: String;
begin
  Result := Point(0, 1);
  s := FText.Text;
  i := 1;
  while i <= Pos do
    if s[i] = Char(LineBreak[1]) then
    begin
      Inc(i, Length(LineBreak));
      if i <= Pos then
      begin
        Inc(Result.Y);
        Result.X := 0;
      end
      else
        Inc(Result.X);
    end
    else
    begin
      Inc(i);
      Inc(Result.X);
    end;
end;

function TfsSyntaxMemo.GetLineBegin(Index: Integer): Integer;
var
  s: String;
begin
  s := FText[Index];
  Result := 1;
  if Trim(s) <> '' then
    for Result := 1 to Length(s) do
      if s[Result] <> ' ' then
        break;
end;

procedure TfsSyntaxMemo.TabIndent;
begin
  SelText := Pad(2);
end;

procedure TfsSyntaxMemo.EnterIndent;
var
  res: Integer;
begin
  if Trim(FText[FPos.Y - 1]) = '' then
    res := FPos.X else
    res := GetLineBegin(FPos.Y - 1);

  CorrectBookmark(FPos.Y, 1);

  FPos := Point(1, FPos.Y + 1);
  SelText := Pad(res - 1);
end;

procedure TfsSyntaxMemo.UnIndent;
var
  i, res: Integer;
begin
  i := FPos.Y - 2;
  res := FPos.X - 1;
  CorrectBookmark(FPos.Y, -1);
  while i >= 0 do
  begin
    res := GetLineBegin(i);
    if (res < FPos.X) and (Trim(FText[i]) <> '') then
      break else
      Dec(i);
  end;
  FSelStart := FPos;
  FSelEnd := FPos;
  Dec(FSelEnd.X, FPos.X - res);
  SelText := '';
end;

procedure TfsSyntaxMemo.ShiftSelected(ShiftRight: Boolean);
var
  i, ib, ie: Integer;
  s: String;
  Shift: Integer;
begin
  if FReadOnly then exit;
  AddUndo;
  if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then
  begin
    ib := FSelStart.Y - 1;
    ie := FSelEnd.Y - 1;
  end
  else
  begin
    ib := FSelEnd.Y - 1;
    ie := FSelStart.Y - 1;
  end;
  if FSelEnd.X = 1 then
    Dec(ie);

  Shift := 2;
  if not ShiftRight then
    for i := ib to ie do
    begin
      s := FText[i];
      if (Trim(s) <> '') and (GetLineBegin(i) - 1 < Shift) then
        Shift := GetLineBegin(i) - 1;
    end;

  for i := ib to ie do
  begin
    s := FText[i];
    if ShiftRight then
      s := Pad(Shift) + s
    else if Trim(s) <> '' then
      Delete(s, 1, Shift);
    FText[i] := s;
  end;
  UpdateSyntax;
  DoChange;
end;

function TfsSyntaxMemo.GetSelText: String;
var
  p1, p2: TPoint;
  i: Integer;
begin
  if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then
  begin
    p1 := FSelStart;
    p2 := FSelEnd;
    Dec(p2.X);
  end
  else
  begin
    p1 := FSelEnd;
    p2 := FSelStart;
    Dec(p2.X);
  end;

  if LineLength(p1.Y - 1) < p1.X then
  begin
    Inc(p1.Y);
    p1.X := 1;
  end;
  if LineLength(p2.Y - 1) < p2.X then
    p2.X := LineLength(p2.Y - 1);

  i := GetPlainTextPos(p1);
  Result := Copy(FText.Text, i, GetPlainTextPos(p2) - i + 1);
end;

procedure TfsSyntaxMemo.SetSelText(Value: String);
var
  p1, p2, p3: TPoint;
  i: Integer;
  s: String;
begin
  if FReadOnly then exit;
  AddUndo;
  if FSelStart.X = 0 then
  begin
    p1 := FPos;
    p2 := p1;
    Dec(p2.X);
  end
  else if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then
  begin
    p1 := FSelStart;
    p2 := FSelEnd;
    Dec(p2.X);
  end
  else
  begin
    p1 := FSelEnd;
    p2 := FSelStart;
    Dec(p2.X);
  end;

  if LineLength(p1.Y - 1) < p1.X then
    FText[p1.Y - 1] := FText[p1.Y - 1] + Pad(p1.X - LineLength(p1.Y - 1) + 1);
  if LineLength(p2.Y - 1) < p2.X then
    p2.X := LineLength(p2.Y - 1);

  i := GetPlainTextPos(p1);
  s := FText.Text;
  Delete(s, i, GetPlainTextPos(p2) - i + 1);
  Insert(Value, s, i);
  FText.Text := s;
  p3 := GetPosPlainText(i + Length(Value));

  CorrectBookmark(FPos.Y, p3.y-FPos.Y);

  SetPos(p3.X, p3.Y);
  FSelStart.X := 0;
  DoChange;
  UpdateSyntax;
end;

procedure TfsSyntaxMemo.ClearSel;
begin
  if FSelStart.X <> 0 then
  begin
    FSelStart := Point(0, 0);
    Repaint;
  end;
end;

procedure TfsSyntaxMemo.AddSel;
begin
  if FSelStart.X = 0 then
    FSelStart := FTempPos;
  FSelEnd := FPos;
  Repaint;
end;

procedure TfsSyntaxMemo.SetPos(x, y: Integer);
begin
  if FMessage <> '' then
  begin
    FMessage := '';
    Repaint;
  end;

  if x > FMaxLength then x := FMaxLength;
  if x < 1 then x := 1;
  if y > FText.Count then y := FText.Count;
  if y < 1 then y := 1;

  FPos := Point(x, y);
  if (FWindowSize.X = 0) or (FWindowSize.Y = 0) then exit;

  if FOffset.Y >= FText.Count then
    FOffset.Y := FText.Count - 1;

  if FPos.X > FOffset.X + FWindowSize.X then
  begin
    FOffset.X := FOffset.X + FPos.X - (FOffset.X + FWindowSize.X);
    Repaint;
  end
  else if FPos.X <= FOffset.X then
  begin
    FOffset.X := FOffset.X - (FOffset.X - FPos.X + 1);
    Repaint;
  end
  else if FPos.Y > FOffset.Y + FWindowSize.Y then
  begin
    FOffset.Y := FOffset.Y + FPos.Y - (FOffset.Y + FWindowSize.Y);
    Repaint;
  end
  else if FPos.Y <= FOffset.Y then
  begin
    FOffset.Y := FOffset.Y - (FOffset.Y - FPos.Y + 1);
    Repaint;
  end;

  ShowCaretPos;
  UpdateScrollBar;

end;

procedure TfsSyntaxMemo.ScrollClick(Sender: TObject);
begin
  if FUpdating then exit;
  FOffset.Y := Round(FVScroll.Value);
  if FOffset.Y > FText.Count then
    FOffset.Y := FText.Count;
  ShowCaretPos;
  Repaint;
end;

procedure TfsSyntaxMemo.ScrollEnter(Sender: TObject);
begin
  SetFocus;
end;

procedure TfsSyntaxMemo.DblClick;
var
  s: String;
begin
  FDoubleClicked := True;
  DoCtrlL;
  FSelStart := FPos;
  s := LineAt(FPos.Y - 1);
  if s <> '' then
    while CharInSet(s[FPos.X],WordChars)
      or IsUnicodeChar(s[FPos.X]) do
      Inc(FPos.X);
  FSelEnd := FPos;
  Repaint;
end;

function GetComponentForm(Comp: TFmxObject): TCommonCustomForm;
begin
  Result := nil;
  while (Comp.Parent <> nil) do
  begin
    if (Comp.Parent is TCommonCustomForm) then
    begin
      Result := Comp.Parent as TCommonCustomForm;
      Exit;
    end;
    Comp := Comp.Parent;
  end;
end;

procedure TfsSyntaxMemo.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  pt: TPointF;
  f: TCommonCustomForm;
  r: TRectF;
  LStr, s: String;
  i, cIndex: Integer;

begin
  if FDoubleClicked then
  begin
    FDoubleClicked := False;
    Exit;
  end;
  if Button = TMouseButton.mbRight then
  begin
    if PopupMenu = nil then
    begin
      f := GetComponentForm(Self);
      if f <> nil then
      begin
        pt := f.ClientToScreen(PointF(AbsoluteRect.Left + X, AbsoluteRect.Top + Y));
        FPopUpMenu.Popup(pt.X, pt.Y);
      end;
    end;
  end
  else
  begin
    FMoved := True;
    if not IsFocused then
      SetFocus;
    FDown := True;
    if FIsMonoType then
      SetPos(Round((X - FGutterWidth) / FCharWidth) + 1 + FOffset.X,
             Trunc(Y / FCharHeight) + 1 + FOffset.Y)
    else
    begin
      cIndex := 0;
      LStr := LineAt(FPos.Y - 1);
      LStr := Copy(LineAt(FPos.Y - 1), FOffset.X + 1, Length(LStr) - (FOffset.X + 1));
      for i := 1 to Length(LStr) do
      begin
        s := Copy(LStr, 1, i);
        r := RectF(0, 0, 100000, 100000);
        FTmpCanvas.Canvas.MeasureText(r, s, False, [], TTextAlign.taLeading);
        if r.Width >= X - FGutterWidth then
        begin
          cIndex := i;
          break;
        end;
      end;
      SetPos(cIndex + 1 + FOffset.X,
             Trunc(Y / FCharHeight) + 1 + FOffset.Y)
    end;
    ClearSel;
  end;
end;

procedure TfsSyntaxMemo.MouseMove(Shift: TShiftState; X, Y: Single);
begin
  if FDown then
  begin
    FTempPos := FPos;
    FPos.X := Round((X - FGutterWidth) / FCharWidth) + 1 + FOffset.X;
    FPos.Y := Round(Y / FCharHeight) + 1 + FOffset.Y;
    if (FPos.X <> FTempPos.X) or (FPos.Y <> FTempPos.Y) then
    begin
      SetPos(FPos.X, FPos.Y);
      AddSel;
    end;
  end;
end;

procedure TfsSyntaxMemo.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Single);
begin
  FDown := False;
end;

procedure TfsSyntaxMemo.MouseWheel(Shift: TShiftState; WheelDelta: Integer;
  var Handled: Boolean);
begin
  inherited;
  FVScroll.Value := FVScroll.Value + (WheelDelta div ABS(WheelDelta)) * KWheel;
end;

procedure TfsSyntaxMemo.DialogKey(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = 9 then
  begin
    if Shift = [] then
    begin
      if FSelStart.X <> 0 then
        DoCtrlI
      else
        TabIndent;
    end
    else if Shift = [ssShift] then
      DoCtrlU;
    FMoved := True;
  end;
end;

procedure TfsSyntaxMemo.KeyDown(var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
var
  MyKey: Boolean;
begin
  inherited;
  FAllowLinesChange := False;

  FTempPos := FPos;
  MyKey := True;
  case Key of
    vkLeft:
      if ssCtrl in Shift then
        DoCtrlL else
        DoLeft;

    vkRight:
      if ssCtrl in Shift then
        DoCtrlR else
        DoRight;

    vkUp:
      DoUp;

    vkDown:
      DoDown;

    vkHome:
      DoHome(ssCtrl in Shift);

    vkEnd:
      DoEnd(ssCtrl in Shift);

    vkPrior:
      DoPgUp;

    vkNext:
      DoPgDn;

    vkReturn:
      if Shift = [] then
        DoReturn;

    vkDelete:
      if ssShift in Shift then
        CutToClipboard else
        DoDel;

    vkBack:
      DoBackspace;

    vkInsert:
      if ssCtrl in Shift then
        CopyToClipboard
      else if ssShift in Shift then
        PasteFromClipboard;

    vkF3:
      Find(LastSearch);  // F3 Repeat search

  else
    MyKey := False;
  end;

  if (Shift = [ssCtrl]) or (Shift = [ssCommand]) then
  begin
    MyKey := True;
    if (Key = Ord('c')) or (Key = Ord('C')) then // Ctrl+C Copy
      CopyToClipboard
    else if (Key = Ord('v')) or (Key = Ord('V')) then // Ctrl+V Paste
      PasteFromClipboard
    else if (Key = Ord('x')) or (Key = Ord('X')) then // Ctrl+X Cut
      CutToClipboard
    else if (Key = Ord('z')) or (Key = Ord('Z')) then // Ctrl+Z Undo
      Undo
    else if (Key = Ord('a')) or (Key = Ord('A')) then // Ctrl+A Select all
    begin
      SetPos(0, 0);
      FSelStart := FPos;
      SetPos(LineLength(FText.Count - 1) + 1, FText.Count);
      FSelEnd := FPos;
      Repaint;
    end
    else if (Key = Ord('f')) or (Key = Ord('F')) then // Ctrl+F Search
    begin
       SynMemoSearch := TfsSynMemoSearch.Create(nil);
       if SynMemoSearch.ShowModal = mrOk then
         Find(SynMemoSearch.Edit1.Text);
       LastSearch := SynMemoSearch.Edit1.Text;
       SynMemoSearch.Free;
    end
    else if (Key = Ord('y')) or (Key = Ord('Y')) then // Ctrl+Y Delete line
    begin
      if FText.Count > FPos.Y then
      begin
        FMoved := True;
        AddUndo;
        FText.Delete(FPos.Y - 1);
        CorrectBookmark(FPos.Y, -1);
        UpdateSyntax;
      end
      else
      if FText.Count = FPos.Y then
      begin
        FMoved := True;
        AddUndo;
        FText[FPos.Y - 1] := '';
        FPos.X := 1;
        SetPos(FPos.X, FPos.Y);
        UpdateSyntax;
      end
    end
    else if Key in [48..57] then
      GotoBookmark(Key-48)
    else
      MyKey := False;
  end;

  if Shift = [ssCtrl, ssShift] then
    if Key in [48..57] then
      if IsBookmark(FPos.Y - 1) < 0 then
         AddBookmark(FPos.Y - 1, Key-48)
      else
      if IsBookmark(FPos.Y - 1) = (Key-48) then
         DeleteBookmark(Key-48);


  if Key in [vkLeft, vkRight, vkUp, vkDown, vkHome, vkEnd, vkPrior, vkNext] then
  begin
    FMoved := True;
    if ssShift in Shift then
      AddSel else
      ClearSel;
  end
  else if Key in [vkReturn, vkDelete, vkBack, vkInsert] then
    FMoved := True;

  case WideChar(KeyChar) of
    #0032..#$FFFF:
      if (Shift = []) or (Shift = [ssShift]) then
      begin
        DoChar(WideChar(KeyChar));
        FMoved := True;
      end;
  else
    MyKey := False;
  end;
  if MyKey then
    Key := 0;
end;

procedure TfsSyntaxMemo.DoLeft;
begin
  Dec(FPos.X);
  if FPos.X < 1 then
    FPos.X := 1;
  SetPos(FPos.X, FPos.Y);
end;

procedure TfsSyntaxMemo.DoRight;
begin
  Inc(FPos.X);
  if FPos.X > FMaxLength then
    FPos.X := FMaxLength;
  SetPos(FPos.X, FPos.Y);
end;

procedure TfsSyntaxMemo.DoUp;
begin
  Dec(FPos.Y);
  if FPos.Y < 1 then
    FPos.Y := 1;
  SetPos(FPos.X, FPos.Y);
end;

procedure TfsSyntaxMemo.DoDown;
begin
  Inc(FPos.Y);
  if FPos.Y > FText.Count then
    FPos.Y := FText.Count;
  SetPos(FPos.X, FPos.Y);
end;

procedure TfsSyntaxMemo.DoHome(Ctrl: Boolean);
begin
  if Ctrl then
    SetPos(1, 1) else
    SetPos(1, FPos.Y);
end;

procedure TfsSyntaxMemo.DoEnd(Ctrl: Boolean);
begin
  if Ctrl then
    SetPos(LineLength(FText.Count - 1) + 1, FText.Count) else
    SetPos(LineLength(FPos.Y - 1) + 1, FPos.Y);
end;

procedure TfsSyntaxMemo.DoExit;
begin
{$IFDEF Delphi17}
  inherited;
{$IFNDEF DELPHI18}
  CaretVisible := False;
{$ELSE}
  HideCaret;
{$ENDIF}
{$ELSE}
  Platform.HideVirtualKeyboard;
  inherited;
  HideCaret;
{$ENDIF}
end;

procedure TfsSyntaxMemo.DoPgUp;
begin
  if FOffset.Y > FWindowSize.Y then
  begin
    FOffset.Y := FOffset.Y - (FWindowSize.Y - 1);
    FPos.Y := FPos.Y - (FWindowSize.Y - 1);
  end
  else
  begin
    if FOffset.Y > 0 then
    begin
      FPos.Y := FPos.Y - FOffset.Y;
      FOffset.Y := 0;
    end
    else
      FPos.Y := 1;
  end;
  SetPos(FPos.X, FPos.Y);
  Repaint;
end;

procedure TfsSyntaxMemo.DoPgDn;
begin
  if FOffset.Y + FWindowSize.Y < FText.Count then
  begin
    FOffset.Y := FOffset.Y + (FWindowSize.Y - 1);
    FPos.Y := FPos.Y + (FWindowSize.Y - 1);
  end
  else
  begin
    FOffset.Y := FText.Count;
    FPos.Y := FText.Count;
  end;
  SetPos(FPos.X, FPos.Y);
  Repaint;
end;

procedure TfsSyntaxMemo.DoReturn;
var
  s: String;
begin
  if FReadOnly then exit;
  s := LineAt(FPos.Y - 1);
  FText[FPos.Y - 1] := Copy(s, 1, FPos.X - 1);
  FText.Insert(FPos.Y, Copy(s, FPos.X, FMaxLength));
  EnterIndent;
end;

procedure TfsSyntaxMemo.DoDel;
var
  s: String;
begin
  if FReadOnly then exit;
  FMessage := '';
  if FSelStart.X <> 0 then
    SelText := ''
  else
  begin
    s := FText[FPos.Y - 1];
    AddUndo;
    if FPos.X <= LineLength(FPos.Y - 1) then
    begin
      Delete(s, FPos.X, 1);
      FText[FPos.Y - 1] := s;
    end
    else if FPos.Y < FText.Count then
    begin
      s := s + Pad(FPos.X - Length(s) - 1) + LineAt(FPos.Y);
      FText[FPos.Y - 1] := s;
      FText.Delete(FPos.Y);
      CorrectBookmark(FSelStart.Y, -1);
    end;
    UpdateScrollBar;
    UpdateSyntax;
    DoChange;
  end;
end;

procedure TfsSyntaxMemo.DoBackspace;
var
  s: String;
begin
  if FReadOnly then exit;
  FMessage := '';
  if FSelStart.X <> 0 then
    SelText := ''
  else
  begin
    s := FText[FPos.Y - 1];
    if FPos.X > 1 then
    begin
      if (GetLineBegin(FPos.Y - 1) = FPos.X) or (Trim(s) = '') then
        UnIndent
      else
      begin
        AddUndo;
        if Trim(s) <> '' then
        begin
          Delete(s, FPos.X - 1, 1);
          FText[FPos.Y - 1] := s;
          DoLeft;
        end
        else
          DoHome(False);
        UpdateSyntax;
        DoChange;
      end;
    end
    else if FPos.Y > 1 then
    begin
      AddUndo;
      CorrectBookmark(FPos.Y, -1);
      s := LineAt(FPos.Y - 2);
      FText[FPos.Y - 2] := s + FText[FPos.Y - 1];
      FText.Delete(FPos.Y - 1);
      SetPos(Length(s) + 1, FPos.Y - 1);
      UpdateSyntax;
      DoChange;
    end;
  end;
end;

procedure TfsSyntaxMemo.DoCtrlI;
begin
  if FSelStart.X <> 0 then
    ShiftSelected(True);
end;

procedure TfsSyntaxMemo.DoCtrlU;
begin
  if FSelStart.X <> 0 then
    ShiftSelected(False);
end;

procedure TfsSyntaxMemo.DoCtrlL;
var
  i: Integer;
  s: String;
begin
  s := FText.Text;
  i := Length(LineAt(FPos.Y - 1));
  if FPos.X > i then
    FPos.X := i;

  i := GetPlainTextPos(FPos);

  Dec(i);
  while (i > 0) and not (CharInSet(s[i], WordChars) or IsUnicodeChar(s[i])) do
    if s[i] = Char(LineBreak[1]) then
      break else
      Dec(i);
  while (i > 0) and (CharInSet(s[i], WordChars) or IsUnicodeChar(s[i])) do
    Dec(i);
  Inc(i);

  FPos := GetPosPlainText(i);
  SetPos(FPos.X, FPos.Y);
end;

procedure TfsSyntaxMemo.DoCtrlR;
var
  i: Integer;
  s: String;
begin
  s := FText.Text;
  i := Length(LineAt(FPos.Y - 1));
  if FPos.X > i then
  begin
    DoDown;
    DoHome(False);
    FPos.X := 0;
  end;

  i := GetPlainTextPos(FPos);
  while (i < Length(s)) and ((CharInSet(s[i], WordChars)) or IsUnicodeChar(s[i])) do
    Inc(i);
  while (i < Length(s)) and not ((CharInSet(s[i], WordChars)) or IsUnicodeChar(s[i])) do
    if s[i] = Char(LineBreak[1]) then
      break else
      Inc(i);
  FPos := GetPosPlainText(i);
  SetPos(FPos.X, FPos.Y);
end;

procedure TfsSyntaxMemo.DoChar(Ch: Char);
begin
  SelText := Ch;
end;

function TfsSyntaxMemo.GetCharAttr(Pos: TPoint): TCharAttributes;

  function IsBlock: Boolean;
  var
    p1, p2, p3: Integer;
  begin
    Result := False;
    if FSelStart.X = 0 then exit;

    p1 := FSelStart.X + FSelStart.Y * FMaxLength;
    p2 := FSelEnd.X + FSelEnd.Y * FMaxLength;
    if p1 > p2 then
    begin
      p3 := p1;
      p1 := p2;
      p2 := p3;
    end;
    p3 := Pos.X + Pos.Y * FMaxLength;
    Result := (p3 >= p1) and (p3 < p2);
  end;

  function CharAttr: TCharAttr;
  var
    s: String;
  begin
    if Pos.Y - 1 < FSynStrings.Count then
    begin
      s := FSynStrings[Pos.Y - 1];
      if Pos.X <= Length(s) then
        Result := TCharAttr(Ord(s[Pos.X])) else
        Result := caText;
    end
    else
      Result := caText;
  end;

begin
  Result := [CharAttr];
  if IsBlock then
    Result := Result + [caBlock];
end;

function TfsSyntaxMemo.GetCharWidth(Str: String): Single;
var
  r: TRectF;
  dx: Single;
  j, j1: Integer;
  a, a1: TCharAttributes;

  function CalcSize(LStr: String): Single;
  begin
    if FIsMonoType then
    begin
      Result := FCharWidth * Length(LStr);
      Exit;
    end;
    if LStr = '' then
    begin
      Result := 0;
      Exit;
    end;

      r := RectF(0, 0, 100000, 100000);
    { MeasureText trunc all spaces at the end, so we are using this hack to calcl size with spaces }
    FTmpCanvas.Canvas.MeasureText(r, LStr + 'W', False, [], TTextAlign.taLeading);
    dx := r.Width;
    FTmpCanvas.Canvas.MeasureText(r, 'W', False, [], TTextAlign.taLeading);
    Result := dx - r.Width;
  end;
begin

  j1 := 1;
  a := GetCharAttr(Point(1, FPos.Y));
  a1 := a;
  Result := 0;

  for j := 1 to Length(Str) do
  begin
    a1 := GetCharAttr(Point(j, FPos.Y));
    if a1 <> a then
    begin
      SetAttr(FTmpCanvas.Canvas, a);
      Result := Result + CalcSize(Copy(Str, j1, (j - j1)));
      a := a1;
      j1 := j;
    end;
  end;
  SetAttr(FTmpCanvas.Canvas, a);
  Result := Result + CalcSize(Copy(Str, j1, Length(Str) - (j1 - 1)));
end;

procedure TfsSyntaxMemo.Paint;
var
  i, j, j1: Integer;
  a, a1: TCharAttributes;
  s: String;
  x, y: Single;
  aClientR: TRectF;
  aSelColor, aSelFontColor: TAlphaColor;

  procedure SetAttrL(a: TCharAttributes);
  begin
    SetAttr(Canvas, a);
    aSelColor := FFill.Color;
    aSelFontColor := Canvas.Fill.Color;
    if caBlock in a then
    begin
      aSelColor := FBlockColor;
      aSelFontColor := FBlockFontColor;
    end;

    // make non-selected text looking good
    if aSelColor = FFill.Color then
      aSelColor := 0;
  end;

  function MyTextOut(x, y: Single; const s: String): Single;
  var
    i: Integer;
    dx, dy: Single;
    r: TRectF;
  begin
    with Canvas do
    begin
      r := RectF(0, 0, 100000, 100000);
      { MeasureText trunc all spaces at the end, so we are using this hack to calcl size with spaces }
      Canvas.MeasureText(r, s + 'W',False, [], TTextAlign.taLeading);
      dx := r.Width + x;
      Canvas.MeasureText(r, 'W', False, [], TTextAlign.taLeading);
      dx := dx - r.Width;
      if dx > (aClientR.Right - aClientR.Left)  then
        dx := aClientR.Right - aClientR.Left;
      dy := y + FCharHeight;
      if FIsMonoType then
        dx := x + FCharWidth * Length(s);
      Fill.Color := aSelColor;
      FillRect(RectF(x + 1, y, dx + 1, dy + 1), 0, 0, AllCorners, 1);
      Fill.Color := aSelFontColor;
      if FIsMonoType then
        FillText(RectF(x, y, dx + 1, 10000),
                  s, False, 1, [], TTextAlign.taLeading,  TTextAlign.taLeading)
      else
      begin
        for i := 1 to Length(s) do
          FillText(RectF(x + (i - 1) * FCharWidth, y,
                  (x + (i - 1) * FCharWidth) + FCharWidth, y + FCharHeight),
                  s[i], False, 1, FillTextFlags, TTextAlign.taLeading, TTextAlign.taLeading);
      end;
    end;
    Result := dx;
  end;

begin
  aClientR := GetClientRect;
  with Canvas do
  begin
    Fill.Assign(FBorder.Fill);
    FillRect(RectF(0, 0, Self.Width , Self.Height), 0, 0, AllCorners, 1, TCornerType.ctBevel);
    Fill.Assign(FFill);
    FillRect(aClientR, 0, 0, AllCorners, 1, TCornerType.ctBevel);
    Fill.Assign(FGutterFill);
    FillRect(RectF(FGutterWidth - aClientR.Left,
            Self.Height - FFooterHeight - aClientR.Top,
            aClientR.Left, aClientR.Top), 0, 0, AllCorners, 1, TCornerType.ctBevel);
    FillRect(RectF(aClientR.Left, Self.Height - FFooterHeight - aClientR.Top,
             Self.Width - aClientR.Left, Self.Height - aClientR.Top), 1, 1,
             AllCorners, 1, TCornerType.ctBevel);

    Stroke.Assign(FBorder.Fill);
{$IFDEF DELPHI25}
    Stroke.Cap :=  TStrokeCap.scRound;
    Stroke.Thickness := FBorder.Width;
{$ELSE}
    StrokeCap :=  TStrokeCap.scRound;
    StrokeThickness := FBorder.Width;
{$ENDIF}
    x := FGutterWidth - FBorder.Width;
    DrawLine(PointF(x, aClientR.Top + 1), PointF(x, aClientR.Bottom - FFooterHeight ), 1);
    if FFooterHeight > 0 then
      DrawLine(PointF(x, aClientR.Bottom - FFooterHeight),
                      PointF(aClientR.Right - 1, aClientR.Bottom - FFooterHeight), 1);
    if FUpdatingSyntax then Exit;

    for i := FOffset.Y to FOffset.Y + FWindowSize.Y - 1 do
    begin
      if i >= FText.Count then break;

      s := FText[i];
      j1 := FOffset.X + 1;
      a := GetCharAttr(Point(j1, i + 1));
      a1 := a;
      x := FGutterWidth + FBorder.Width;
      y := aClientR.Top + (i - FOffset.Y) * FCharHeight;
      for j := j1 to FOffset.X + FWindowSize.X do
      begin
        if j > Length(s) then break;

        a1 := GetCharAttr(Point(j, i + 1));
        if a1 <> a then
        begin
          SetAttrL(a);
          x := MyTextOut(x, y, Copy(FText[i], j1, j - j1));
          a := a1;
          j1 := j;
        end;
      end;

      SetAttrL(a);

      MyTextOut(x, y, Copy(s, j1, FMaxLength));

      BookmarkDraw(y, i);
      ActiveLineDraw(y, i);
    end;

    if FMessage <> '' then
    begin
      Font.Family := 'Tahoma';
      Font.Style := [TFontStyle.fsBold];
      Font.Size := 8;
      Fill.Color := TAlphaColorRec.Maroon;
      FillRect(RectF(aClientR.Left, aClientR.Bottom - TextHeight('|') - 6, aClientR.Right , aClientR.Bottom), 0, 0,
              AllCorners, 1, TCornerType.ctBevel);
      Fill.Color := TAlphaColorRec.White;
      FillText(RectF(aClientR.Left + 6, aClientR.Bottom - TextHeight('|') - 5,
                6 + TextWidth('W') * Length(FMessage), aClientR.Bottom), FMessage,
                False, 1, [], TTextAlign.taLeading)
    end
    else
      ShowPos;
  end;
end;

procedure TfsSyntaxMemo.CreateSynArray;
var
  i, n, Pos: Integer;
  ch: Char;
  FSyn: String;

  procedure SkipSpaces;
  begin
    while (Pos <= Length(FSyn)) and
          ((CharInSet(FSyn[Pos], [#1..#32])) or
           not (CharInSet(FSyn[Pos],['_', 'A'..'Z', 'a'..'z', '''', '"', '/', '{', '(', '-']))) do
      Inc(Pos);
  end;

  function IsKeyWord(const s: String): Boolean;
  begin
    Result := False;
    if FKeywords = '' then exit;

    if FKeywords[1] <> ',' then
      FKeywords := ',' + FKeywords;
    if FKeywords[Length(FKeywords)] <> ',' then
      FKeywords := FKeywords + ',';

    Result := System.Pos(',' + AnsiLowerCase(s) + ',', FKeywords) <> 0;
  end;

  function GetIdent: TCharAttr;
  var
    i: Integer;
    cm1, cm2, cm3, cm4, st1: Char;
  begin
    i := Pos;
    Result := caText;

    if FSyntaxType = stPascal then
    begin
      cm1 := '/';
      cm2 := '{';
      cm3 := '(';
      cm4 := ')';
      st1 := '''';
    end
    else if FSyntaxType in [stCpp,stJs,stVb] then
    begin
      cm1 := '/';
      cm2 := ' ';
      cm3 := '/';
      cm4 := '/';
      st1 := '"';
    end
    else if FSyntaxType = stSQL then
    begin
      cm1 := '-';
      cm2 := ' ';
      cm3 := '/';
      cm4 := '/';
      st1 := '"';
    end
    else
    begin
      cm1 := ' ';
      cm2 := ' ';
      cm3 := ' ';
      cm4 := ' ';
      st1 := ' ';
    end;

    if CharInSet(FSyn[Pos], ['_', 'A'..'Z', 'a'..'z']) then
    begin
      while CharInSet(FSyn[Pos], ['_', 'A'..'Z', 'a'..'z', '0'..'9']) do
        Inc(Pos);
      if IsKeyWord(Copy(FSyn, i, Pos - i)) then
        Result := caKeyword;
      Dec(Pos);
    end
    else if (FSyn[Pos] = cm1) and (FSyn[Pos + 1] = cm1) then
    begin
      while (Pos <= Length(FSyn)) and not (CharInSet(FSyn[Pos], [#10, #13])) do
        Inc(Pos);
      Result := caComment;
    end
    else if FSyn[Pos] = cm2 then
    begin
      while (Pos <= Length(FSyn)) and (FSyn[Pos] <> '}') do
        Inc(Pos);
      Result := caComment;
    end
    else if (FSyn[Pos] = cm3) and (FSyn[Pos + 1] = '*') then
    begin
      while (Pos < Length(FSyn)) and not ((FSyn[Pos] = '*') and (FSyn[Pos + 1] = cm4)) do
        Inc(Pos);
      Inc(Pos, 2);
      Result := caComment;
    end
    else if FSyn[Pos] = st1 then
    begin
      Inc(Pos);
      while (Pos < Length(FSyn)) and (FSyn[Pos] <> st1) and not (CharInSet(FSyn[Pos], [#10, #13])) do
        Inc(Pos);
      Result := caString;
    end;
    Inc(Pos);
  end;

begin
  FSyn := FText.Text + #0#0#0#0#0#0#0#0#0#0#0;
  FAllowLinesChange := False;
  Pos := 1;

  while Pos < Length(FSyn) do
  begin
    n := Pos;
    SkipSpaces;
    for i := n to Pos - 1 do
      if FSyn[i] > #31 then
        FSyn[i] := Chr(Ord(caText));

    n := Pos;
    ch := Chr(Ord(GetIdent));
    for i := n to Pos - 1 do
      if i <= Length(FSyn) then
        if FSyn[i] > #31 then
          FSyn[i] := ch;
  end;

  FUpdatingSyntax := True;
  FSynStrings.Text := FSyn;
  FSynStrings.Add(' ');
  FUpdatingSyntax := False;
end;

procedure TfsSyntaxMemo.UpdateView;
begin
  UpdateSyntax;
  Repaint;
end;

procedure TfsSyntaxMemo.UpdateWindowSize;
begin
  if FCharWidth = 0 then exit;
  FWindowSize := Point(Trunc((Width - FGutterWidth  - FBorder.Width * 2) / FCharWidth),
                       Trunc((Height - FFooterHeight  - FBorder.Width * 2) / FCharHeight));
end;

procedure TfsSyntaxMemo.CopyPopup(Sender: TObject);
begin
  CopyToClipboard;
end;

procedure TfsSyntaxMemo.PastePopup(Sender: TObject);
begin
  PasteFromClipboard;
end;

procedure TfsSyntaxMemo.Resize;
begin
  inherited;
  UpdateWindowSize;
  FVScroll.Position.Y := FBorder.Width;
  FVScroll.Height := Height - FFooterHeight - FBorder.Width;
  FVScroll.Width := 16;
  FVScroll.Position.X := Width - FVScroll.Width - FBorder.Width;
  UpdateScrollBar;
end;

procedure TfsSyntaxMemo.CutPopup(Sender: TObject);
begin
  CutToClipboard;
end;

procedure TfsSyntaxMemo.SetShowGutter(Value: boolean);
begin
  FShowGutter := Value;
  if Value then
    FGutterWidth := 20
  else
    FGutterWidth := 0;
  Repaint;
end;

procedure TfsSyntaxMemo.SetShowFooter(Value: boolean);
begin
  FShowFooter := Value;
  if Value then
    FFooterHeight := 20
  else
    FFooterHeight := 0;
  Repaint;
end;

function TfsSyntaxMemo.FMemoFind(Text: String; var Position : TPoint): boolean;
var
  i, j : integer;
begin
  j := 0;
  result := False;
  if FText.Count > 1 then
  begin
    Text := UpperCase(Text);
    for i := Position.Y to FText.Count - 1 do
    begin
      j := Pos( Text, UpperCase(FText[i]));
      if j > 0 then
      begin
        Result := True;
        break;
      end
    end;
    Position.X := j;
    Position.Y := i + 1;
  end;
end;

procedure TfsSyntaxMemo.FontChanged(Sender: TObject);
begin
  FCommentAttr.Font.Size := FFontSettings.Font.Size;
  FCommentAttr.Font.Family := FFontSettings.Font.Family;
  FKeywordAttr.Font.Size := FFontSettings.Font.Size;
  FKeywordAttr.Font.Family := FFontSettings.Font.Family;
  FStringAttr.Font.Size := FFontSettings.Font.Size;
  FStringAttr.Font.Family := FFontSettings.Font.Family;
  FTextAttr.Font.Size := FFontSettings.Font.Size;
  FTextAttr.Font.Family := FFontSettings.Font.Family;
  CalcCharSize;
  { need to uptade size, maybe font size was changed }
  UpdateWindowSize;
end;

function TfsSyntaxMemo.Find(Text: String): boolean;
var
  Position: TPoint;
begin
  Position := FPos;
  if FMemoFind(Text, Position) then
  begin
    SetPos(Position.X, Position.Y);
    result := true;
  end
  else
  begin
    ShowMessage('Text "'+Text+'" not found.');
    result := false;
  end;
end;

procedure TfsSyntaxMemo.ActiveLineDraw(Y : Single; ALine : integer);
begin
  if ShowGutter then
    with Canvas do
      if ALine = FActiveLine then
      begin
        Fill.Color := TAlphaColorRec.Red;
        //Pen.Color := clBlack;
        FillEllipse(RectF(4, Y + 4, 11, Y + 15), 1);
      end;
end;

procedure TfsSyntaxMemo.BookmarkDraw(Y : Single; ALine : integer);
var
  bm : integer;
begin
  if ShowGutter then
    with Canvas do
    begin
      bm := IsBookmark(ALine);
      if bm >= 0 then
      begin
        Fill.Color := TAlphaColorRec.Black;
        FillRect(RectF(3 + Border.Width, Y + 1, 13 + Border.Width, Y + 12), 0, 0,
                AllCorners, 1, TCornerType.ctBevel);
        Fill.Color := TAlphaColorRec.Green;
        FillRect(RectF(2 + Border.Width, Y + 2, 12 + Border.Width, Y + 13), 0, 0,
                AllCorners, 1, TCornerType.ctBevel);
        Font.Family := 'Tahoma';
        Fill.Color := TAlphaColorRec.White;
        Font.Style := [TFontStyle.fsBold];
        Font.Size := 7;
        y :=  y + 2.0;
        FillText(RectF(4 + Border.Width, Y, 4 + TextWidth('7') + Border.Width,
                  Y + TextHeight('7')), IntToStr(bm), False, 1, [], TTextAlign.taLeading)
      end;
    end;
end;

function TfsSyntaxMemo.IsBookmark(Line : integer): integer;
var
  Pos : integer;
begin
  Result := -1;
  for Pos := 0 to Length(Bookmarks) - 1 do
    if Bookmarks[Pos] = Line then
    begin
      Result := Pos;
      break;
    end;
end;

procedure TfsSyntaxMemo.AddBookmark(Line, Number : integer);
begin
  if Number < Length(Bookmarks) then
  begin
    Bookmarks[Number] := Line;
    Repaint;
  end;
end;

procedure TfsSyntaxMemo.DeleteBookmark(Number : integer);
begin
  if Number < Length(Bookmarks) then
  begin
    Bookmarks[Number] := -1;
    Repaint;
  end;
end;

procedure TfsSyntaxMemo.CorrectBookmark(Line : integer; delta : integer);
var
  i : integer;
begin
  for i := 0 to Length(Bookmarks) - 1 do
    if Bookmarks[i] >= Line then
      Inc(Bookmarks[i], Delta);
end;

procedure TfsSyntaxMemo.GotoBookmark(Number : integer);
begin
  if Number < Length(Bookmarks) then
    if Bookmarks[Number] >= 0 then
      SetPos(0, Bookmarks[Number] + 1);
end;

procedure TfsSyntaxMemo.DOver(Sender: TObject; const Data: TDragObject; const Point: TPointF; {$IFNDEF DELPHI20}var Accept: Boolean{$ELSE} var Operation: TDragOperation{$ENDIF});
begin
{$IFNDEF DELPHI20}
  Accept := Data.Source is TTreeView;
{$ELSE}
  if Data.Source is TTreeView then
	Operation := TDragOperation.Copy;
{$ENDIF}
end;

procedure TfsSyntaxMemo.DDrop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
begin
  if Data.Source is TTreeView then
  begin
     SetPos(Round((Point.X - FGutterWidth) / FCharWidth) + 1 + FOffset.X,
          Round(Point.Y / FCharHeight) + 1 + FOffset.Y);
     SetSelText(TTreeView(Data.Source).Selected.Text);
  end;
end;

procedure TfsSyntaxMemo.SetKeywordAttr(Value: TfsFontSettings);
begin
  FKeywordAttr.Assign(Value);
  UpdateSyntax;
end;

procedure TfsSyntaxMemo.SetStringAttr(Value: TfsFontSettings);
begin
  FStringAttr.Assign(Value);
  UpdateSyntax;
end;

procedure TfsSyntaxMemo.SetTextAttr(Value: TfsFontSettings);
begin
  FTextAttr.Assign(Value);
  UpdateSyntax;
end;

procedure TfsSyntaxMemo.SetCommentAttr(Value: TfsFontSettings);
begin
  FCommentAttr.Assign(Value);
  UpdateSyntax;
end;

procedure TfsSyntaxMemo.SetFill(const Value: TBrush);
begin
  FFill.Assign(Value);
end;

procedure TfsSyntaxMemo.SetFontSettings(const Value: TfsFontSettings);
begin
  FFontSettings.Assign(Value);
end;

procedure TfsSyntaxMemo.SetGutterFill(const Value: TBrush);
begin
  FGutterFill.Assign(Value);
end;

procedure TfsSyntaxMemo.SetActiveLine(Line : Integer);
begin
  FActiveLine := Line;
  Repaint;
end;

procedure TfsSyntaxMemo.SetAttr(aCanvas: TCanvas; a: TCharAttributes);
begin
  with aCanvas do
  begin
    Font.Assign(FFontSettings.Font);
    Canvas.Fill.Assign(FFontSettings.Fill);

    if caText in a then
    begin
      Font.Assign(FTextAttr.Font);
      Canvas.Fill.Assign(FTextAttr.Fill);
    end;

    if caComment in a then
    begin
      Font.Assign(FCommentAttr.Font);
      Canvas.Fill.Assign(FCommentAttr.Fill);
    end;

    if caKeyword in a then
    begin
      Font.Assign(FKeywordAttr.Font);
      Canvas.Fill.Assign(FKeywordAttr.Fill);
    end;

    if caString in a then
    begin
      Font.Assign(FStringAttr.Font);
      Canvas.Fill.Assign(FStringAttr.Fill);
    end;
  end;
end;



procedure TfsSyntaxMemo.SetBorder(const Value: TfsBorderSettings);
begin
  FBorder.Fill.Assign(Value.Fill);
  FBorder.Width := Value.Width;
end;

function TfsSyntaxMemo.GetActiveLine: Integer;
begin
  Result := FActiveLine;
end;

procedure TfsSynMemoSearch.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
     ModalResult := mrOk;
end;

{ TfsBorderSettings }

constructor TfsBorderSettings.Create;
begin
   FFill := TBrush.Create(TBrushKind.bkSolid, TAlphaColorRec.Silver);
   FWidth := 1;
end;

destructor TfsBorderSettings.Destroy;
begin
  FFill.Free;
  inherited;
end;

procedure TfsBorderSettings.SetFill(const Value: TBrush);
begin
  FFill.Assign(Value);
end;

procedure TfsBorderSettings.SetWidth(const Value: Integer);
begin
  if Value > 3 then
    FWidth := 3
  else if Value < 0 then
    FWidth := 0
  else
    FWidth := Value;
end;

{ TfsFontSettings }

procedure TfsFontSettings.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TfsFontSettings then
  begin
    Fill.Assign(TfsFontSettings(Source).Fill);
    Font.Assign(TfsFontSettings(Source).Font);
  end;
end;

constructor TfsFontSettings.Create();
begin
  FFill := TBrush.Create(TBrushKind.bkSolid, TAlphaColorRec.Black);
  FFont := TFont.Create;
  FFont.Family := 'Courier New';
  FFont.Size := 13;
end;

destructor TfsFontSettings.Destroy;
begin
  FFill.Free;
  FFont.Free;
  inherited;
end;

procedure TfsFontSettings.SetFill(const Value: TBrush);
begin
  FFill.Assign(Value);
end;

procedure TfsFontSettings.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

initialization
  StartClassGroup(TFmxObject);
  ActivateClassGroup(TFmxObject);
  GroupDescendentsWith(TfsSyntaxMemo, TFmxObject);
  GroupDescendentsWith(TfsBorderSettings, TFmxObject);
  GroupDescendentsWith(TfsFontSettings, TFmxObject);

  RegisterFmxClasses([TfsBorderSettings, TfsFontSettings]);

end.
