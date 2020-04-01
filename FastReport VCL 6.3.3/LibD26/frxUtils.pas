
{******************************************}
{                                          }
{             FastReport v6.0              }
{            Various routines              }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxUtils;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}{$IFDEF Delphi12}pngimage{$ELSE}frxpngimage{$ENDIF},{$ENDIF}
  SysUtils, {$IFNDEF FPC}Windows, Messages,{$ENDIF}
  Classes, Graphics, Controls, Forms,
  StdCtrls, Menus, ImgList, ActnList, ComCtrls, frxClass, frxXML, frxCollections
{$IFDEF FPC}
  ,LCLType, LCLIntf, LazHelper
{$ENDIF}
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxRectArea = class
  public
    X, Y, X1, Y1: Extended;
    constructor Create(c: TfrxComponent); overload;
    constructor Create(Left, Top, Right, Bottom: Extended); overload;
    function InterceptsX(a: TfrxRectArea): Boolean;
    function InterceptsY(a: TfrxRectArea): Boolean;
    function InterceptX(a: TfrxRectArea): TfrxRectArea;
    function InterceptY(a: TfrxRectArea): TfrxRectArea;
    function Max(x1, x2: Extended): Extended;
    function Min(x1, x2: Extended): Extended;
  end;

procedure frxParseDilimitedText(aList: TStrings; aText: String; aDelimiter: Char);
function frxFindComponent(Owner: TComponent; const Name: String): TComponent;
procedure frxGetComponents(Owner: TComponent; ClassRef: TClass;
  List: TStrings; Skip: TComponent);
function frxGetFullName(Owner: TComponent; c: TComponent): String;
procedure frxSetCommaText(const Text: String; sl: TStrings; Comma: Char = ';');
function frxRemoveQuotes(const s: String): String;
function frxStreamToString(Stream: TStream): String;
procedure frxStringToStream(const s: String; Stream: TStream);

function frxStrToFloat(s: String): Extended;

function frxFloatToStr(d: Extended): String;
function frxRect(ALeft, ATop, ARight, ABottom: Extended): TfrxRect;
function frxPoint(X, Y: Extended): TfrxPoint;
function frxGetBrackedVariable(const Str, OpenBracket, CloseBracket: AnsiString;
  var i, j: Integer): AnsiString;
function frxGetBrackedVariableW(const Str, OpenBracket, CloseBracket: WideString;
  var i, j: Integer): WideString;
procedure frxCommonErrorHandler(Report: TfrxReport; const Text: String);
procedure frxErrorMsg(const Text: String);
procedure frxInfoMsg(const Text: String);
function frxConfirmMsg(const Text: String; Buttons: Integer): Integer;
function frxIsValidFloat(const Value: string): Boolean;
procedure frxAssignImages(Bitmap: TBitmap; dx, dy: Integer;
  ImgList1: TImageList; ImgList2: TImageList = nil);
procedure frxDrawTransparent(Canvas: TCanvas; x, y: Integer; bmp: TBitmap);
procedure frxDrawGraphic(Canvas: TCanvas; DestRect: TRect; aGraph: TGraphic;
  IsPrinting, Smooth, Transparent: Boolean; TransparentColor: TColor);
procedure frxParsePageNumbers(const PageNumbers: String; List: TStrings;
  Total: Integer);
function HTMLRGBColor(Color: TColor): string;
procedure frxWriteCollection(Collection: TCollection; Writer: TWriter; Owner: TfrxComponent); overload;
procedure frxReadCollection(Collection: TCollection; Reader: TReader; Owner: TfrxComponent); overload;
procedure frxWriteCollection(Collection: TCollection; const Name: String; Item: TfrxXmlItem; Owner: TfrxComponent; aAncestor: TfrxCollection); overload;
procedure frxReadCollection(Collection: TCollection; Item: TfrxXmlItem; Owner: TfrxComponent;  aAncestor: TfrxCollection); overload;

function GetAppFileName: String;
function GetAppPath: String;
function GetTemporaryFolder: String;
function GetTempFile: String;
function frxCreateTempFile(const TempDir: String): String;
{$IFNDEF Delphi7}
function frFloat2Str(const Value: Extended; const Prec: Integer = 2): String;
{$ELSE}
function frFloat2Str(const Value: Extended; const Prec: Integer = 2; const Sep: Char = '.'): String;
{$ENDIF}
function frxReverseString(const AText: string): string;
function frxStreamCRC32(Stream: TStream): Cardinal;
function frxUnixPath2WinPath(const Path: string): string;
{$IFNDEF Delphi6}
function DirectoryExists(const Name: string): Boolean;
{$ENDIF}
{$IFNDEF Delphi7}
function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
{$ENDIF}
{lcl widgetsets don't like too many Repaint calls, so we use
 update for them, Delphi isn't disturbed}
procedure frxUpdateControl(AControl: TWinControl;
  const ARepaint: Boolean = {$IFDEF NONWINFPC}False{$ELSE}True{$ENDIF});
procedure GetDisplayScale(DevHandle: THandle; IsPrinterHandle: Boolean; var aScaleX, aScaleY: Extended);
procedure TransparentFillRect(aDC: HDC; Left, Top, Right, Bottom: Integer;
  Color: TColor);
function IfStr(Flag: Boolean; const sTrue: string; sFalse: string = ''): string;
function IfInt(Flag: Boolean; const iTrue: integer; iFalse: integer = 0): integer;
function IfReal(Flag: Boolean; const rTrue: Extended; rFalse: Extended = 0.0): Extended;
function IfColor(Flag: Boolean; const cTrue: TColor; cFalse: TColor = clNone): TColor;
function GetStr(const Id: string): string;
function frxFloatDiff(const Val1, Val2: Extended): Boolean;

{$IFNDEF FPC}
function PNGToPNGA(PNG: TPngObject): TPngObject;
procedure DisplayPNGInfo(const PNG: TPNGObject);
{$ENDIF}

type
  TLongWordArray = array of LongWord;
  TIntegerArray = array of Integer;

implementation

uses frxXMLSerializer, frxRes, TypInfo, Dialogs;


function frxFloatDiff(const Val1, Val2: Extended): Boolean;
begin
  Result := Abs(Val1 - Val2) > 1e-4;
end;

procedure TransparentFillRect(aDC: HDC; Left, Top, Right, Bottom: Integer;
  Color: TColor);
const
  ChessBrush: array [0 .. 7] of Word = ($AA, $55, $AA, $55, $AA, $55, $AA, $55);
var
  aSaveState: Integer;
  aBitmap: HBITMAP;
  aBrush: HBRUSH;
  OldBrush, OldPen: HPEN;
begin
  aSaveState := SaveDC(aDC);
  aBitmap := CreateBitmap(8, 8, 1, 1, @ChessBrush);
  try
    aBrush := CreatePatternBrush(aBitmap);
  finally
    DeleteObject(aBitmap);
  end;
  OldBrush := SelectObject(aDC, aBrush);
  OldPen := SelectObject(aDC, GetStockObject(NULL_PEN));
  try
    SetROP2(aDC, R2_MASKPEN);
    SetBkColor(aDC, RGB(255, 255, 255));
    SetTextColor(aDC, RGB(0, 0, 0));
    Rectangle(aDC, Left, Top, Right, Bottom);
    SetROP2(aDC, R2_MERGEPEN);
    SetBkColor(aDC, RGB(0, 0, 0));
    SetTextColor(aDC, Color);
    Rectangle(aDC, Left, Top, Right, Bottom);
  finally
    SelectObject(aDC, OldBrush);
    SelectObject(aDC, OldPen);
    DeleteObject(aBrush);
    RestoreDC(aDC, aSaveState);
  end;
end;

{ TfrxRectArea }

constructor TfrxRectArea.Create(c: TfrxComponent);
begin
  Create(c.AbsLeft, c.AbsTop, c.AbsLeft + c.Width, c.AbsTop + c.Height);
end;

constructor TfrxRectArea.Create(Left, Top, Right, Bottom: Extended);
begin
  X := Left;
  Y := Top;
  X1 := Right;
  Y1 := Bottom;
end;

function TfrxRectArea.InterceptsX(a: TfrxRectArea): Boolean;
begin
  Result := False;
  if (a.X < X1 - 1e-4) and (a.X1 > X + 1e-4) then
    Result := True;
end;

function TfrxRectArea.InterceptsY(a: TfrxRectArea): Boolean;
begin
  Result := False;
  if (a.Y < Y1 - 1e-4) and (a.Y1 > Y + 1e-4) then
    Result := True;
end;

function TfrxRectArea.InterceptX(a: TfrxRectArea): TfrxRectArea;
begin
  Result := nil;
  if InterceptsX(a) then
    Result := TfrxRectArea.Create(Max(a.X, X), 0, Min(a.X1, X1), 0);
end;

function TfrxRectArea.InterceptY(a: TfrxRectArea): TfrxRectArea;
begin
  Result := nil;
  if InterceptsY(a) then
    Result := TfrxRectArea.Create(0, Max(a.Y, Y), 0, Min(a.Y1, Y1));
end;

function TfrxRectArea.Max(x1, x2: Extended): Extended;
begin
  if x1 > x2 then
    Result := x1
  else
    Result := x2;
end;

function TfrxRectArea.Min(x1, x2: Extended): Extended;
begin
  if x1 < x2 then
    Result := x1
  else
    Result := x2;
end;

const
  CRCTable: array [0..255] of Cardinal = (
 0000000000, 1996959894, 3993919788, 2567524794,
 0124634137, 1886057615, 3915621685, 2657392035,
 0249268274, 2044508324, 3772115230, 2547177864,
 0162941995, 2125561021, 3887607047, 2428444049,
 0498536548, 1789927666, 4089016648, 2227061214,
 0450548861, 1843258603, 4107580753, 2211677639,
 0325883990, 1684777152, 4251122042, 2321926636,
 0335633487, 1661365465, 4195302755, 2366115317,
 0997073096, 1281953886, 3579855332, 2724688242,
 1006888145, 1258607687, 3524101629, 2768942443,
 0901097722, 1119000684, 3686517206, 2898065728,
 0853044451, 1172266101, 3705015759, 2882616665,
 0651767980, 1373503546, 3369554304, 3218104598,
 0565507253, 1454621731, 3485111705, 3099436303,
 0671266974, 1594198024, 3322730930, 2970347812,
 0795835527, 1483230225, 3244367275, 3060149565,
 1994146192, 0031158534, 2563907772, 4023717930,
 1907459465, 0112637215, 2680153253, 3904427059,
 2013776290, 0251722036, 2517215374, 3775830040,
 2137656763, 0141376813, 2439277719, 3865271297,
 1802195444, 0476864866, 2238001368, 4066508878,
 1812370925, 0453092731, 2181625025, 4111451223,
 1706088902, 0314042704, 2344532202, 4240017532,
 1658658271, 0366619977, 2362670323, 4224994405,
 1303535960, 0984961486, 2747007092, 3569037538,
 1256170817, 1037604311, 2765210733, 3554079995,
 1131014506, 0879679996, 2909243462, 3663771856,
 1141124467, 0855842277, 2852801631, 3708648649,
 1342533948, 0654459306, 3188396048, 3373015174,
 1466479909, 0544179635, 3110523913, 3462522015,
 1591671054, 0702138776, 2966460450, 3352799412,
 1504918807, 0783551873, 3082640443, 3233442989,
 3988292384, 2596254646, 0062317068, 1957810842,
 3939845945, 2647816111, 0081470997, 1943803523,
 3814918930, 2489596804, 0225274430, 2053790376,
 3826175755, 2466906013, 0167816743, 2097651377,
 4027552580, 2265490386, 0503444072, 1762050814,
 4150417245, 2154129355, 0426522225, 1852507879,
 4275313526, 2312317920, 0282753626, 1742555852,
 4189708143, 2394877945, 0397917763, 1622183637,
 3604390888, 2714866558, 0953729732, 1340076626,
 3518719985, 2797360999, 1068828381, 1219638859,
 3624741850, 2936675148, 0906185462, 1090812512,
 3747672003, 2825379669, 0829329135, 1181335161,
 3412177804, 3160834842, 0628085408, 1382605366,
 3423369109, 3138078467, 0570562233, 1426400815,
 3317316542, 2998733608, 0733239954, 1555261956,
 3268935591, 3050360625, 0752459403, 1541320221,
 2607071920, 3965973030, 1969922972, 0040735498,
 2617837225, 3943577151, 1913087877, 0083908371,
 2512341634, 3803740692, 2075208622, 0213261112,
 2463272603, 3855990285, 2094854071, 0198958881,
 2262029012, 4057260610, 1759359992, 0534414190,
 2176718541, 4139329115, 1873836001, 0414664567,
 2282248934, 4279200368, 1711684554, 0285281116,
 2405801727, 4167216745, 1634467795, 0376229701,
 2685067896, 3608007406, 1308918612, 0956543938,
 2808555105, 3495958263, 1231636301, 1047427035,
 2932959818, 3654703836, 1088359270, 0936918000,
 2847714899, 3736837829, 1202900863, 0817233897,
 3183342108, 3401237130, 1404277552, 0615818150,
 3134207493, 3453421203, 1423857449, 0601450431,
 3009837614, 3294710456, 1567103746, 0711928724,
 3020668471, 3272380065, 1510334235, 0755167117);

function frxStreamCRC32(Stream: TStream): Cardinal;
var
  OldPos: Integer;
  b: Byte;
  c: Cardinal;
begin
  OldPos := Stream.Position;
  Stream.Position := 0;
  c := $ffffffff;
  while Stream.Position < Stream.Size do
  begin
    Stream.Read(b,1);
    c := CrcTable[(c xor Cardinal(b)) and $ff] xor (c shr 8);
  end;
  Stream.Position := OldPos;
  Result := c xor $ffffffff;
end;

procedure frxParseDilimitedText(aList: TStrings; aText: String; aDelimiter: Char);
var
  sLen, i, sPos: Integer;
begin
  aList.Clear;
  if (aText = '') or (aText = aDelimiter) then Exit;
  aList.BeginUpdate;
  try
    sLen := Length(aText);
    i := 1;
    sPos := 1;
    while i <= sLen do
    begin
      if (aText[i] = aDelimiter) and (sPos < i) or ((i = sLen) and (aList.Count > 0)) then
      begin
        if i = sLen then Inc(i);
        aList.Add(Copy(aText, sPos, i - sPos));
        sPos := i + 1;
      end;
      inc(i);
    end;
   finally
     aList.EndUpdate;
   end;
end;

function frxFindComponent(Owner: TComponent; const Name: String): TComponent;
var
  n: Integer;
  s1, s2: String;
begin
  Result := nil;
  n := Pos('.', Name);
  try
    if n = 0 then
    begin
      if Owner <> nil then
        Result := Owner.FindComponent(Name);
      if (Result = nil) and (Owner is TfrxReport) and (Owner.Owner <> nil) then
        Result := Owner.Owner.FindComponent(Name);
    end
    else
    begin
      s1 := Copy(Name, 1, n - 1);        // module name
      s2 := Copy(Name, n + 1, 255);      // component name
      Owner := FindGlobalComponent(s1);
      if Owner <> nil then
      begin
        n := Pos('.', s2);
        if n <> 0 then        // frame name - Delphi5
        begin
          s1 := Copy(s2, 1, n - 1);
          s2 := Copy(s2, n + 1, 255);
          Owner := Owner.FindComponent(s1);
          if Owner <> nil then
            Result := Owner.FindComponent(s2);
        end
        else
          Result := Owner.FindComponent(s2);
      end;
    end;
  except
    on Exception do
      raise EClassNotFound.Create('Missing ' + Name);
  end;
end;

{$HINTS OFF}
procedure frxGetComponents(Owner: TComponent; ClassRef: TClass;
  List: TStrings; Skip: TComponent);
var
  i, j: Integer;

  procedure EnumComponents(f: TComponent);
  var
    i: Integer;
    c: TComponent;
  begin
{$IFDEF Delphi5}
    if f is TForm then
      for i := 0 to TForm(f).ControlCount - 1 do
      begin
        c := TForm(f).Controls[i];
        if c is TFrame then
          EnumComponents(c);
      end;
{$ENDIF}
    for i := 0 to f.ComponentCount - 1 do
    begin
      c := f.Components[i];
      if (c <> Skip) and (c is ClassRef) then
        List.AddObject(frxGetFullName(Owner, c), c);
    end;
  end;

begin
  List.Clear;
  if Owner is TfrxReport then
    EnumComponents(Owner);
  for i := 0 to Screen.FormCount - 1 do
    EnumComponents(Screen.Forms[i]);
  for i := 0 to Screen.DataModuleCount - 1 do
    EnumComponents(Screen.DataModules[i]);
{$IFDEF Delphi6} // D6 bugfix
  with Screen do
    for i := 0 to CustomFormCount - 1 do
      with CustomForms[i] do
      if (ClassName = 'TDataModuleForm')  then
        for j := 0 to ComponentCount - 1 do
        begin
          if (Components[j] is TDataModule) then
            EnumComponents(Components[j]);
        end;
{$ENDIF}
end;
{$HINTS ON}

function frxGetFullName(Owner: TComponent; c: TComponent): String;
var
  o: TComponent;
begin
  Result := '';
  if c = nil then Exit;

  o := c.Owner;
  if (o = nil) or (o = Owner) or ((Owner is TfrxReport) and (o = Owner.Owner)) then
    Result := c.Name
  else if ((o is TForm) or (o is TDataModule)) then
    Result := o.Name + '.' + c.Name
{$IFDEF Delphi5}
  else if o is TFrame then
    if o.Owner <> nil then
      Result := o.Owner.Name + '.' + c.Owner.Name + '.' + c.Name
    else
      Result := c.Owner.Name + '.' + c.Name
{$ENDIF}
end;

procedure frxSetCommaText(const Text: String; sl: TStrings; Comma: Char = ';');
var
  i: Integer;

  function ExtractCommaName(s: string; var Pos: Integer): string;
  var
    i: Integer;
  begin
    i := Pos;
    while (i <= Length(s)) and (s[i] <> Comma) do Inc(i);
    Result := Copy(s, Pos, i - Pos);
    if (i <= Length(s)) and (s[i] = Comma) then Inc(i);
    Pos := i;
  end;

begin
  i := 1;
  sl.Clear;
  while i <= Length(Text) do
    sl.Add(ExtractCommaName(Text, i));
end;

function frxRemoveQuotes(const s: String): String;
begin
  if (Length(s) > 2) and (s[1] = '"') and (s[Length(s)] = '"') then
    Result := Copy(s, 2, Length(s) - 2) else
    Result := s;
end;

function frxStreamToString(Stream: TStream): String;
var
  Size: Integer;
{$IFDEF Delphi12}
    p: PAnsiChar;
{$ELSE}
	p: PChar;
{$ENDIF}
begin
  Size := Stream.Size;
  SetLength(Result, Size * 2);
  GetMem(p, Size);

  Stream.Position := 0;
  Stream.Read(p^, Size);

  BinToHex(p, PChar(@Result[1]), Size);

  FreeMem(p, Size);
end;

procedure frxStringToStream(const s: String; Stream: TStream);
var
  Size: Integer;
{$IFDEF Delphi12}
    p: PAnsiChar;
{$ELSE}
	p: PChar;
{$ENDIF}
begin
  Size := Length(s) div 2;
  GetMem(p, Size);

  HexToBin(PChar(@s[1]), p, Size * 2);

  Stream.Position := 0;
  Stream.Write(p^, Size);

  FreeMem(p, Size);
end;

function frxStrToFloat(s: String): Extended;
var
  i: Integer;
begin
  for i := 1 to Length(s) do
{$IFDEF Delphi12}
    if CharInSet(s[i], [',', '.']) then
{$ELSE}
    if s[i] in [',', '.'] then
{$ENDIF}
{$IFDEF Delphi16}
      s[i] := FormatSettings.DecimalSeparator;
{$ELSE}
      s[i] := DecimalSeparator;
{$ENDIF}
  while Pos(' ', s) <> 0 do
    Delete(s, Pos(' ', s), 1);
  Result := StrToFloat(s);
end;

function frxFloatToStr(d: Extended): String;
begin
  if Int(d) = d then
    Result := FloatToStr(d) else
    Result := Format('%2.2f', [d]);
end;

function frxRect(ALeft, ATop, ARight, ABottom: Extended): TfrxRect;
begin
  with Result do
  begin
    Left := ALeft;
    Top := ATop;
    Right := ARight;
    Bottom := ABottom;
  end;
end;

function frxPoint(X, Y: Extended): TfrxPoint;
begin
  Result.X := X;
  Result.Y := Y;
end;

function frxGetBrackedVariable(const Str, OpenBracket, CloseBracket: AnsiString;
  var i, j: Integer): AnsiString;
var
  c: Integer;
  fl1, fl2: Boolean;
begin
  Result := '';
  j := i;
  fl1 := True;
  fl2 := True;
  c := 0;
  if (Str = '') or (j > Length(Str)) then Exit;

  Dec(j);
  repeat
    Inc(j);
    if isDBCSLeadByte(Byte(Str[j])) then  { if DBCS then skip 2 bytes }
      Inc(j, 2);

    if fl1 and fl2 then
      if Copy(Str, j, Length(OpenBracket)) = OpenBracket then
      begin
        if c = 0 then i := j;
        Inc(c);
      end
      else if Copy(Str, j, Length(CloseBracket)) = CloseBracket then
        Dec(c);
    if fl1 then
      if Str[j] = '"' then fl2 := not fl2;
    if fl2 then
      if Str[j] = '''' then fl1 := not fl1;
  until (c = 0) or (j >= Length(Str));

  Result := Copy(Str, i + Length(OpenBracket), j - i - Length(OpenBracket));
  if i <> j then
    Inc(j, Length(CloseBracket) - 1);
end;

function frxGetBrackedVariableW(const Str, OpenBracket, CloseBracket: WideString;
  var i, j: Integer): WideString;
var
  c: Integer;
  fl1, fl2: Boolean;
begin
  Result := '';
  j := i;
  fl1 := True;
  fl2 := True;
  c := 0;
  if (Str = '') or (j > Length(Str)) then Exit;

  Dec(j);
  repeat
    Inc(j);
    if fl1 and fl2 then
      if Copy(Str, j, Length(OpenBracket)) = OpenBracket then
      begin
        if c = 0 then i := j;
        Inc(c);
      end
      else if Copy(Str, j, Length(CloseBracket)) = CloseBracket then
        Dec(c);
    if fl1 then
      if Str[j] = '"' then fl2 := not fl2;
    if fl2 then
      if Str[j] = '''' then fl1 := not fl1;
  until (c = 0) or (j >= Length(Str));

  Result := Copy(Str, i + Length(OpenBracket), j - i - Length(OpenBracket));
  if i <> j then
    Inc(j, Length(CloseBracket) - 1);
end;

procedure frxCommonErrorHandler(Report: TfrxReport; const Text: String);
var
  e: Exception;
begin
  case Report.EngineOptions.NewSilentMode of
    simMessageBoxes: frxErrorMsg(Text);
    simReThrow: begin e := Exception.Create(Text); raise e; end;
  end;
end;

procedure frxErrorMsg(const Text: String);
begin
  Application.MessageBox(PChar(Text), PChar(frxResources.Get('mbError')),
    mb_Ok + mb_IconError);
end;

function frxConfirmMsg(const Text: String; Buttons: Integer): Integer;
begin
  Result := Application.MessageBox(PChar(Text),
    PChar(frxResources.Get('mbConfirm')), mb_IconQuestion + Buttons);
end;

procedure frxInfoMsg(const Text: String);
begin
  Application.MessageBox(PChar(Text), PChar(frxResources.Get('mbInfo')),
    mb_Ok + mb_IconInformation);
end;

function frxIsValidFloat(const Value: string): Boolean;
begin
  Result := True;
  try
    frxStrToFloat(Value);
  except
    Result := False;
  end;
end;

procedure frxMakeDisabledImage(Bitmap: TBitmap);
var
  i, j: Integer;
  c: TColor;
  B, G, R: Integer;
begin
  for i := 0 to Bitmap.Width - 1 do
  for j := 0 to Bitmap.Height - 1 do
  begin
    c := Bitmap.Canvas.Pixels[i, j];
    r := c and $FF0000 div $10000;
    g := c and $FF00 div $100;
    b := c and $FF;
    c := (r + g + b) div 3;
    c := Round(c / 3);
    c := c + 150;
    if c > 255 then
      c := 255;
    Bitmap.Canvas.Pixels[i, j] := c * $10000 + c * $100 + c;
  end;
end;

procedure frxAssignImages(Bitmap: TBitmap; dx, dy: Integer;
  ImgList1: TImageList; ImgList2: TImageList = nil);
var
  b: TBitmap;
  x, y: Integer;
  Done: Boolean;
begin
  b := TBitmap.Create;
  b.Width := dx;
  b.Height := dy;

  x := 0; y := 0;

  repeat
    b.Canvas.CopyRect(Rect(0, 0, dx, dy), Bitmap.Canvas, Rect(x, y, x + dx, y + dy));
    Done := y > Bitmap.Height;

    if not Done then
    begin
      ImgList1.AddMasked(b, b.TransparentColor);
      if ImgList2 <> nil then
      begin
        frxMakeDisabledImage(b);
        ImgList2.AddMasked(b, b.TransparentColor);
      end;
    end;

    Inc(x, dx);
    if x >= Bitmap.Width then
    begin
      x := 0;
      Inc(y, dy);
    end;
  until Done;

  b.Free;
end;

procedure frxDrawTransparent(Canvas: TCanvas; x, y: Integer; bmp: TBitmap);
var
  img: TImageList;
begin
  if Assigned(bmp) then
  begin
    img := TImageList.Create(nil);
    try
      img.Width := bmp.Width;
      img.Height := bmp.Height;
      img.AddMasked(bmp, bmp.TransparentColor);
      img.Draw(Canvas, x, y, 0);
      img.Clear;
    finally
      img.Free;
    end;
  end;
end;

procedure PrintBitmap(aHandle: HDC; Dest: TRect; Bitmap: TBitmap);
var
  Info: PBitmapInfo;
  HInfo: HGLOBAL;
  InfoSize: DWord;
  Image: Pointer;
  HImage: HGLOBAL;
  ImageSize: DWord;
  PrevStretchBltMode: Integer;
begin
  {$IFDEF FPC}
  {$warning TODO fix frxUtils.PrintBitmap}
  {$ELSE}
  with Bitmap do
  begin
    GetDIBSizes(Handle, InfoSize, ImageSize);
    HInfo := GlobalAlloc(GMEM_MOVEABLE or GMEM_SHARE, InfoSize);
    Info := PBitmapInfo(GlobalLock(HInfo));
    try
      HImage := GlobalAlloc(GMEM_MOVEABLE or GMEM_SHARE, ImageSize);
      Image := Pointer(GlobalLock(HImage));
      try
        GetDIB(Handle, Palette, Info^, Image^);
        with Info^.bmiHeader do
        begin
          PrevStretchBltMode := SetStretchBltMode(aHandle, STRETCH_HALFTONE);
          StretchDIBits(aHandle, Dest.Left, Dest.Top,
            Dest.RIght - Dest.Left, Dest.Bottom - Dest.Top,
            0, 0, biWidth, biHeight, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
          SetStretchBltMode(aHandle, PrevStretchBltMode);
        end;
      finally
        GlobalUnlock(HImage);
        GlobalFree(HImage);
      end;
    finally
      GlobalUnlock(HInfo);
      GlobalFree(HInfo);
    end;
  end;
  {$ENDIF}
end;

{ Draw with smooth }
procedure DrawBitmap(aHandle: HDC; Dest: TRect; Bitmap: TBitmap);
var
  hMemDC: HDC;
  PrevStretchBltMode: Integer;
  hBmp: HBITMAP;

begin
  hMemDC := CreateCompatibleDC(aHandle);
  hBmp := SelectObject(hMemDC, Bitmap.Handle);
  try
    PrevStretchBltMode := SetStretchBltMode(aHandle, STRETCH_HALFTONE);
    with Dest do
      StretchBlt(aHandle, Left, Top, Right - Left, Bottom - Top, hMemDC,
            0, 0, Bitmap.Width, Bitmap.Height, SRCCOPY);
    SetStretchBltMode(aHandle, PrevStretchBltMode);
  finally
    SelectObject(hMemDC, hBmp);
    DeleteDC(hMemDC);
  end;
end;

{ function create 2-bits mask from SourceDC with specify color value }
{ and draw it with White fill on DestDC                              }
procedure ApplyMask(DestDC: HDC; X, Y, Width, Height: Integer; SourceDC:HDC;
  SrcX, SrcY, SrcWidth, SrcHeight: Integer; MaskColor: TColor);
var
  hMaskDC: HDC;
  hMask: HBITMAP;
  oldFore, oldBack, oldBkColor: Cardinal;
begin
  hMaskDC := CreateCompatibleDC(DestDC);
  hMask := CreateBitmap(Width, Height, 1, 1, nil);
  oldBkColor := SetBkColor(SourceDC, ColorToRGB(MaskColor));
  try
    SelectObject(hMaskDC, hMask);
    StretchBlt(hMaskDC, 0, 0, Width, Height, SourceDC, SrcX, SrcY, SrcWidth, SrcHeight,  SRCCOPY);
    oldFore := SetTextColor(DestDC, 0);
    oldBack := SetBkColor(DestDC, RGB(255,255,255));
    BitBlt(DestDC, X, Y, Width, Height, hMaskDC, 0, 0, SRCAND);
    SetTextColor(DestDC, oldFore);
    SetBkColor(DestDC, oldBack);
  finally
    DeleteObject(hMask);
    DeleteDC(hMaskDC);
    SetBkColor(SourceDC, oldBkColor);
  end;
end;

{ function draws an image with transparent color, it has 2 mode: }
{ 1. Draws DIB directly on canvas, this used for printing.       }
{ Using memory DC could cause unexpected behaviour on printer    }
{ like color losing and etc (i.e. both StretchDIBits             }
{ with SRCINVERT should use printer DC).                         }
{ 2. Draw bitmap with using memory compatible DC,                }
{ it used for sreen draw.                                        }
{ TransparentBlt doesn't work with EMF,                          }
{ so it replaced  with 3 ROP's operation for correct export.     }
{$IFNDEF FPC}
procedure frxDrawTransparentBitmap(Canvas: TCanvas; DestRect: TRect; Bitmap: TBitmap; TransparenColor: TColor; UseDIB: Boolean);
var
  hMemDC: HDC;
  rWidth, rHeight: Integer;
  Info: PBitmapInfo;
  HInfo: HGLOBAL;
  InfoSize: DWord;
  Image: Pointer;
  HImage: HGLOBAL;
  ImageSize: DWord;
  StretchBltMode, PrevStretchBltMode, DIBColor: Integer;

  procedure CreateDIB;
  begin
    with Bitmap do
    begin
      GetDIBSizes(Handle, InfoSize, ImageSize);
      HInfo := GlobalAlloc(GMEM_MOVEABLE or GMEM_SHARE, InfoSize);
      Info := PBitmapInfo(GlobalLock(HInfo));
      try
        HImage := GlobalAlloc(GMEM_MOVEABLE or GMEM_SHARE, ImageSize);
        Image := Pointer(GlobalLock(HImage));
        try
          GetDIB(Handle, Palette, Info^, Image^);
        except
          GlobalUnlock(HImage);
          GlobalFree(HImage);
          HImage := 0;
        end;
      except
        GlobalUnlock(HInfo);
        GlobalFree(HInfo);
        HInfo := 0;
      end;
    end;
  end;

  procedure FreeDIB;
  begin
    if HImage <> 0 then
    begin
      GlobalUnlock(HImage);
      GlobalFree(HImage);
    end;
    if HInfo <> 0 then
    begin
      GlobalUnlock(HInfo);
      GlobalFree(HInfo);
    end;
  end;

  procedure DrawDIB;
  begin
    with Info^.bmiHeader, DestRect do
    begin
      if UseDIB then
        StretchDIBits(Canvas.Handle, Left, Top, rWidth, rHeight,
          0, 0, biWidth, biHeight, Image, Info^, DIBColor, SRCINVERT)
      else
        StretchBlt(Canvas.Handle, Left, Top, rWidth, rHeight, hMemDC,
          0, 0, Bitmap.Width, Bitmap.Height, SRCINVERT);
    end;
  end;

begin
  StretchBltMode := STRETCH_HALFTONE;
  DIBColor := DIB_RGB_COLORS;

  case   Bitmap.PixelFormat of
    pf1bit: StretchBltMode := BLACKONWHITE;
    pf4bit..pf16bit: DIBColor := DIB_PAL_COLORS;
  end;

  if UseDIB then
    CreateDIB;
  with  DestRect do
  begin
    rWidth := Right - Left;
    rHeight := Bottom - Top;
    PrevStretchBltMode := SetStretchBltMode(Canvas.Handle, StretchBltMode);
    try
      hMemDC := CreateCompatibleDC(Canvas.Handle);
      SelectObject(hMemDC, Bitmap.Handle);
      DrawDIB;
      ApplyMask(Canvas.Handle, Left, Top, rWidth, rHeight, hMemDC, 0, 0, Bitmap.Width, Bitmap.Height, TransparenColor);
      DrawDIB;
  finally
      DeleteDC(hMemDC);
      SetStretchBltMode(Canvas.Handle, PrevStretchBltMode);
      if UseDIB then
        FreeDIB;
    end;
  end;

end;
{$ENDIF}

{procedure frxDrawTransparentBitmap(Canvas: TCanvas; DestRect: TRect; Bitmap: TBitmap; TransparenColor: TColor);
begin
  with DestRect do
    TransparentBlt(Canvas.Handle, Left, Top, Right - Left, Bottom - Top,
      Bitmap.Canvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height, ColorToRGB(TransparenColor));
end;}


{$IFDEF FPC}
procedure frxDrawGraphic(Canvas: TCanvas; DestRect: TRect; aGraph: TGraphic;
  IsPrinting, Smooth, Transparent: Boolean; TransparentColor: TColor);
var
  Bitmap: TBitmap;
begin
  if (aGraph is TMetaFile) or not IsPrinting then
    Canvas.StretchDraw(DestRect, aGraph)
  else
  begin
    Bitmap := TBitmap.Create;
    Bitmap.Canvas.Lock;
    try
      Bitmap.Width := aGraph.Width;
      Bitmap.Height := aGraph.Height;
      Bitmap.PixelFormat := pf32Bit;
      Bitmap.Canvas.Draw(0, 0, aGraph);
      DrawBitmap(Canvas.Handle, DestRect, Bitmap);
    finally
      Bitmap.Canvas.Unlock;
      Bitmap.Free;
    end;
  end
end;
{$ELSE}
procedure frxDrawGraphic(Canvas: TCanvas; DestRect: TRect; aGraph: TGraphic;
  IsPrinting, Smooth, Transparent: Boolean; TransparentColor: TColor);
var
  Bitmap: TBitmap;
  OldColor: TColor;
begin
  Canvas.Brush.Color := clWhite;// reset brush style
  // metafile shold be printed here
  //Bitmaps and other non-transparet pictures draw here
  if (aGraph is TMetaFile) or
    (not IsPrinting and (not Transparent or (aGraph is TBitmap)) and
      not Smooth)  then
  begin
    aGraph.Transparent := Transparent;
    if (aGraph is TBitmap) and Transparent then
      frxDrawTransparentBitmap(Canvas, DestRect, TBitmap(aGraph),
        TransparentColor, False)
    else
      Canvas.StretchDraw(DestRect, aGraph);
  end
  // used for printing pictures and drawing transparent pictures like JPEG/PNG
  // for printiong use DIB, for drawing memory DC
  else
  begin
    Bitmap := TBitmap.Create;
    Bitmap.Canvas.Lock;
    try
      Bitmap.HandleType := bmDIB;
      if IsPrinting then
        Bitmap.PixelFormat := pf32Bit// for print output
      else
        Bitmap.PixelFormat := pf24Bit;//for screen
      Bitmap.Width := aGraph.Width;
      Bitmap.Height := aGraph.Height;

      if(TransparentColor <> clNone) then
      begin
        OldColor := Bitmap.Canvas.Brush.Color;
        Bitmap.Canvas.Brush.Color := ColorToRGB(TransparentColor);
        Bitmap.Canvas.FillRect(Rect(0,0,Bitmap.Width, Bitmap.Height));
        Bitmap.Canvas.Brush.Color := OldColor;
      end;
      Bitmap.Canvas.Draw(0, 0, aGraph);

      if Transparent and (TransparentColor <> clNone) then
        frxDrawTransparentBitmap(Canvas, DestRect, Bitmap, TransparentColor, IsPrinting)
      else if IsPrinting then
        PrintBitmap(Canvas.Handle, DestRect, Bitmap)
      else
        DrawBitmap(Canvas.Handle, DestRect, Bitmap);
    finally
      Bitmap.Canvas.Unlock;
      Bitmap.Free;
    end;
  end
end;
{$ENDIF}

procedure frxParsePageNumbers(const PageNumbers: String; List: TStrings;
  Total: Integer);
var
  i, j, n1, n2: Integer;
  s: String;
  IsRange: Boolean;
begin
  List.Clear;
  s := PageNumbers;
  while Pos(' ', s) <> 0 do
    Delete(s, Pos(' ', s), 1);
  if s = '' then Exit;

  if s[Length(s)] = '-' then
    s := s + IntToStr(Total);
  s := s + ',';
  i := 1; j := 1; n1 := 1;
  IsRange := False;

  while i <= Length(s) do
  begin
    if s[i] = ',' then
    begin
      n2 := StrToInt(Copy(s, j, i - j));
      j := i + 1;
      if IsRange then
        while n1 <= n2 do
        begin
          List.Add(IntToStr(n1));
          Inc(n1);
        end
      else
        List.Add(IntToStr(n2));
      IsRange := False;
    end
    else if s[i] = '-' then
    begin
      IsRange := True;
      n1 := StrToInt(Copy(s, j, i - j));
      j := i + 1;
    end;
    Inc(i);
  end;
end;

function HTMLRGBColor(Color: TColor): string;
var
  TheRgbValue : TColorRef;
begin
  TheRgbValue := ColorToRGB(Color);
  Result := '#' + Format('%.2x%.2x%.2x', [GetRValue(TheRGBValue), GetGValue(TheRGBValue), GetBValue(TheRGBValue)]);
end;


procedure ConvertOneItem(Item: TCollectionItem; ToAnsi: Boolean);
var
  i: Integer;
  TypeInfo: PTypeInfo;
  PropCount: Integer;
  PropList: PPropList;

  function Convert(const Value: String): String;
  var
    i: Integer;
  begin
    Result := '';
    i := 1;
    while i <= Length(Value) do
    begin
      if ToAnsi then
      begin
        if Value[i] >= #128 then
          Result := Result + #1 + Chr(Ord(Value[i]) - 128) else
          Result := Result + Value[i];
      end
      else
      begin
        if (Value[i] = #1) and (i < Length(Value)) then
        begin
          Result := Result + Chr(Ord(Value[i + 1]) + 128);
          Inc(i);
        end
        else
          Result := Result + Value[i];
      end;

      Inc(i);
    end;
  end;

  procedure DoStrProp;
  var
    Value, NewValue: String;
  begin
    Value := GetStrProp(Item, PropList[i]);
    NewValue := Convert(Value);
    if Value <> NewValue then
      SetStrProp(Item, PropList[i], NewValue);
  end;

  procedure DoVariantProp;
  var
    Value: Variant;
  begin
    Value := GetVariantProp(Item, PropList[i]);
    if (TVarData(Value).VType = varString) or (TVarData(Value).VType = varOleStr)
    {$IFDEF Delphi12} or (TVarData(Value).VType = varUString){$ENDIF} then
    begin
      Value := Convert(Value);
      SetVariantProp(Item, PropList[i], Value);
    end;
  end;

begin
  TypeInfo := Item.ClassInfo;
  PropCount := GetTypeData(TypeInfo).PropCount;
  GetMem(PropList, PropCount * SizeOf(PPropInfo));
  GetPropInfos(TypeInfo, PropList);

  try
    for i := 0 to PropCount - 1 do
    begin
      case PropList[i].PropType^.Kind of
        tkString, tkLString, tkWString{$IFDEF FPC}, tkAString{$ENDIF}:
          DoStrProp;

        tkVariant:
          DoVariantProp;
      end;
    end;

  finally
    FreeMem(PropList, PropCount * SizeOf(PPropInfo));
  end;
end;

procedure frxWriteCollection(Collection: TCollection; Writer: TWriter;
  Owner: TfrxComponent);
var
  i: Integer;
  xs: TfrxXMLSerializer;
  s: String;
{$IFDEF Delphi12}
{$ELSE}
  vt: TValueType;
  l: Integer;
{$ENDIF}
begin
  if Owner.IsWriting then
  begin
    { called from SaveToStream }
    Writer.WriteListBegin;
    xs := TfrxXMLSerializer.Create(nil);
    try
      xs.Owner := Owner.Report;
      for i := 0 to Collection.Count - 1 do
      begin
        Writer.WriteListBegin;
{$IFDEF Delphi12}
        s := {UTF8Encode(}xs.ObjToXML(Collection.Items[i]);
        Writer.WriteString(s);
        Writer.WriteListEnd;
{$ELSE}
{$IFDEF FPC}
        s := {UTF8Encode(}xs.ObjToXML(Collection.Items[i]);
        Writer.WriteString(s);
        Writer.WriteListEnd;
{$ELSE}
        s := xs.ObjToXML(Collection.Items[i]);
        vt := vaLString;
        Writer.Write(vt, SizeOf(vt));
        l := Length(s);
        Writer.Write(l, SizeOf(l));
        Writer.Write(s[1], l);
        Writer.WriteListEnd;
{$ENDIF}
{$ENDIF}
      end;
    finally
      Writer.WriteListEnd;
      xs.Free;
    end;
  end
  else
  begin
    { called from Delphi streamer }
    Writer.WriteCollection(Collection);
  end;
end;

procedure frxWriteCollection(Collection: TCollection; const Name: String; Item: TfrxXmlItem; Owner: TfrxComponent; aAncestor: TfrxCollection);
var
  i: Integer;
  xs: TfrxXMLSerializer;
  xi: TfrxXmlItem;
  aReport: TfrxReport;
  needFree: Boolean;
  frxCollection: TfrxCollection;
  ItemAnc: TPersistent;
  cItem: TfrxCollectionItem;
begin
  Item := Item.Add;
  Item.Name := Name;
  NeedFree := False;
  frxCollection := nil;
  xs := nil;
  ItemAnc := nil;
  //Owner.IsAncestor
  aReport := Owner.Report;
  if aReport <> nil then
    xs := TfrxXMLSerializer(aReport.XmlSerializer);

  if Collection is TfrxCollection then
    frxCollection := TfrxCollection(Collection);
  if xs = nil then
  begin
    xs := TfrxXMLSerializer.Create(nil);
    xs.Owner := aReport;
    NeedFree := True;
    // todo for collection editors, to determinate ancestor
    //IsInherite := Owner.IsAncestor and (frxCollection <> nil);
  end;

  try
    for i := 0 to Collection.Count - 1 do
    begin
      if (frxCollection <> nil) and (aAncestor <> nil) then
      begin
        ItemAnc := aAncestor.FindByName(TfrxCollectionItem(frxCollection.Items[i]).InheritedName)
      end;

      xi := Item.Add;
      xi.Name := 'item';
      if ItemAnc <> nil then
        xi.Text := xi.Text + ' InheritedName="' + frxStrToXML(TfrxCollectionItem(ItemAnc).InheritedName) + '"';

      xi.Text := xi.Text + xs.ObjToXML(Collection.Items[i], '', ItemAnc);
      if Assigned(frxCollection) then
      begin
        cItem := TfrxCollectionItem(Collection.Items[i]);
        if cItem.IsUniqueNameStored then
          xi.Text := xi.Text + ' uin="' + IntToStr(cItem.UniqueIndex) + '"';
      end;
    end;
  finally
    if NeedFree then
      xs.Free;
  end;
end;

procedure frxReadCollection(Collection: TCollection; Reader: TReader;
  Owner: TfrxComponent);
var
  i: Integer;
  vt: TValueType;
  xs: TfrxXMLSerializer;
  s: String;
  Item: TCollectionItem;
  NeedFree: Boolean;
begin
  vt := Reader.ReadValue;
  if vt <> vaCollection then
  begin
    { called from LoadFromStream }
    NeedFree := False;
    xs := nil;
    if Owner.Report <> nil then
      xs := TfrxXMLSerializer(Owner.Report.XMLSerializer);

    if xs = nil then
    begin
      xs := TfrxXMLSerializer.Create(nil);
      xs.Owner := Owner.Report;
      NeedFree := True;
    end;

    try
      Collection.Clear;

      while not Reader.EndOfList do
      begin
        Reader.ReadListBegin;
        Item := Collection.Add;
{$IFDEF Delphi12}
//UTF8Decode()
        s := Reader.ReadString;
{$ELSE}
        s := Reader.ReadString;
{$ENDIF}
        if NeedFree then
          xs.ReadPersistentStr(Owner.Report, Item, s)
        else
          xs.XMLToObj(s, Item);
        Reader.ReadListEnd;
      end;
    finally
      Reader.ReadListEnd;
      if NeedFree then
        xs.Free;
    end;
  end
  else
  begin
    { called from Delphi streamer }
    Reader.ReadCollection(Collection);
    for i := 0 to Collection.Count - 1 do
      ConvertOneItem(Collection.Items[i], False);
  end;
end;

procedure frxReadCollection(Collection: TCollection; Item: TfrxXmlItem; Owner: TfrxComponent; aAncestor: TfrxCollection);
var
  i: Integer;
  xs: TfrxXMLSerializer;
  ci: TCollectionItem;
  ci1: TfrxCollectionItem;
  needFree: Boolean;
  frxCollection: TfrxCollection;
  InheritedName: String;
begin
  xs := nil;
  frxCollection := nil;
  needFree := False;
  // use parent serializer if any. We need fixups.
  if Owner.Report <> nil then
    xs := TfrxXMLSerializer(Owner.Report.XmlSerializer);

  if Collection is TfrxCollection then
    frxCollection := TfrxCollection(Collection);

  if xs = nil then
  begin
    xs := TfrxXMLSerializer.Create(nil);
    xs.Owner := Owner.Report;
    needFree := True;
  end;

  try
    if (Owner.IsAncestor) and (frxCollection = nil) then
      Collection.Clear;
    for i := 0 to Item.Count - 1 do
    begin
      if Owner.IsAncestor and (frxCollection <> nil) {and (aAncestor <> nil)} then
      begin
        InheritedName := Item[i].Prop['InheritedName'];

        if InheritedName <> '' then
        begin
          ci1 := frxCollection.FindByName(InheritedName);
          if ci1 <> nil then
          begin
            xs.XMLToObj(Item[i].Text, ci1);
            ci1.IsInherited := True;
          end;
          Continue;
        end;
      end;
      ci := Collection.Add;
      xs.XMLToObj(Item[i].Text, ci);
      if Assigned(frxCollection) then
      begin
        ci1 := TfrxCollectionItem(ci);
        if ci1.IsUniqueNameStored then
        begin
          InheritedName := Item[i].Prop['uin'];
          if InheritedName <> '' then
            ci1.UniqueIndex := StrToInt(InheritedName);
        end;
      end;
    end;
  finally
    if needFree then
      xs.Free;
  end;
end;

function GetTemporaryFolder: String;
var
  Path: String;
begin
{$IFDEF FPC}
  Result := GetTempDir(True);
{$ELSE}
  Setlength(Path, MAX_PATH);
  SetLength(Path, GetTempPath(MAX_PATH, @Path[1]));
{$IFDEF Delphi12}
  Result := StrPas(PWideChar(@Path[1]));
{$ELSE}
  Result := StrPas(@Path[1]);
{$ENDIF}
{$ENDIF}
end;

function GetTempFile: String;
var
  Path: String;
  FileName: String;
begin
{$IFDEF FPC}
  Result := GetTempFileName(GetTempDir(True),'');
{$ELSE}

  SetLength(Path, MAX_PATH);
  SetLength(Path, GetTempPath(MAX_PATH, @Path[1]));
  SetLength(FileName, MAX_PATH);
  GetTempFileName(@Path[1], PChar('fr'), 0, @FileName[1]);
{$IFDEF Delphi12}
  Result := StrPas(PWideChar(@FileName[1]));
{$ELSE}
  Result := StrPas(@FileName[1]);
{$ENDIF}
{$ENDIF}
end;

function frxCreateTempFile(const TempDir: String): String;
var
  Path: String;
  FileName: String;
  {$IFDEF FPC}
  AFileHandle: THandle;
  {$ENDIF}
begin
  Path := TempDir;
{$IFDEF FPC}
  if (Path <> '') and (Path[Length(Path)] <> PathDelim) then
    Path := Path + PathDelim;
  Result := GetTempFileName(Path,'fr');
  AFileHandle := FileCreate(Result);
  if AFileHandle <> -1 then
    FileClose(AFileHandle);
{$ELSE}
  if (Path <> '') and (Path[Length(Path)] <> '\') then
    Path := Path + '\';
  SetLength(FileName, MAX_PATH);
  if Path = '' then
  begin
    SetLength(Path, MAX_PATH);
    SetLength(Path, GetTempPath(MAX_PATH, @Path[1]));
  end
  else begin
    Path := Path + #0;
    SetLength(Path, MAX_PATH);
  end;
  GetTempFileName(@Path[1], PChar('fr'), 0, @FileName[1]);
{$IFDEF Delphi12}
  Result := StrPas(PWideChar(@FileName[1]));
{$ELSE}
  Result := StrPas(@FileName[1]);
{$ENDIF}
{$ENDIF}
end;

function GetAppFileName: String;
var
  fName: String;
  nsize: cardinal;
begin
  {$IFDEF FPC}
  Result := Application.ExeName;
  {$ELSE}
  nsize := MAX_PATH;
  SetLength(fName,nsize);
  SetLength(fName, GetModuleFileName(hinstance, pchar(fName), nsize));
  Result := fName;
  {$ENDIF}
end;

function GetAppPath: String;
begin
  Result := ExtractFilePath(GetAppFileName);
end;

{$IFNDEF Delphi7}
function frFloat2Str(const Value: Extended; const Prec: Integer = 2): String;
var
  i: Integer;
  IntVal: Integer;
begin
  IntVal := Trunc(Value);
  if IntVal <> Value then
    Result := Format('%.' + IntToStr(Prec)+ 'f', [Value])
  else
    Result := IntToStr(IntVal);
  if DecimalSeparator <> '.' then
  begin
    i := Pos(DecimalSeparator, Result);
    if i > 0 then
      Result[i] := '.';
  end;
end;
{$ELSE}
function frFloat2Str(const Value: Extended; const Prec: Integer = 2; const Sep: Char = '.'): String;
var
  FormatSettings: TFormatSettings;
  Buffer: array[0..63] of Char;
begin
  FormatSettings.DecimalSeparator := Sep;
  FormatSettings.ThousandSeparator := Char(0);
  SetString(Result, Buffer, FloatToText(Buffer, Value, fvExtended,
    ffFixed, 32, Prec, FormatSettings));
end;
{$ENDIF}

function frxReverseString(const AText: string): string;
var
  I: Integer;
  P: PChar;
begin
  SetLength(Result, Length(AText));
  P := PChar(Result);
  for I := Length(AText) downto 1 do
  begin
    P^ := AText[I];
    Inc(P);
  end;
end;

function ChangeChars(const Str: string; FromChar, ToChar: Char): string;
var
  I: Integer;
begin
  Result := Str;
  for I := 1 to Length(Result) do
    if Result[I] = FromChar then
      Result[I] := ToChar;
end;

function frxUnixPath2WinPath(const Path: string): string;
begin
  Result := ChangeChars(Path, '/', '\');
end;

{$IFNDEF Delphi6}
function DirectoryExists(const Name: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;
{$ENDIF}


{$IFNDEF Delphi7}
function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else
  begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
end;
{$ENDIF}

procedure frxUpdateControl(AControl: TWinControl;
  const ARepaint: Boolean = {$IFDEF NONWINFPC}False{$ELSE}True{$ENDIF});
begin
  {$IFDEF FPC}
  if AControl.HandleAllocated then
  begin
  {$ENDIF}
    if ARepaint then
      AControl.Repaint
    else
      AControl.Update;
  {$IFDEF FPC}
  end;
  {$ENDIF}
end;

procedure GetDisplayScale(DevHandle: THandle; IsPrinterHandle: Boolean; var aScaleX, aScaleY: Extended);
{$IFNDEF FPC}
var
  DevMode: TDevMode;
{$ENDIF}
begin
  aScaleX := GetDeviceCaps(DevHandle, LOGPIXELSX) / 96;
  aScaleY := GetDeviceCaps(DevHandle, LOGPIXELSY) / 96;
  if (Abs(aScaleX - 1) > 1e-4) and (Abs(aScaleY - 1) > 1e-4) or IsPrinterHandle then
    Exit;
  // scale factor for non DPI aware applications
  // msdn.microsoft.com/en-us/library/windows/desktop/dn469266(v=vs.85).aspx
{$IFNDEF FPC}
  ZeroMemory(@DevMode, sizeof(DevMode));
  if EnumDisplaySettings(nil, Cardinal(-1{ENUM_CURRENT_SETTINGS MSDN FLAG}), DevMode) then
  begin
    aScaleX := 1 / (DevMode.dmPelsWidth / GetSystemMetrics(SM_CXSCREEN));
    aScaleY := 1 / (DevMode.dmPelsHeight / GetSystemMetrics(SM_CYSCREEN));
  end;
{$ENDIF}
end;

function IfStr(Flag: Boolean; const sTrue: string; sFalse: string = ''): string;
begin
  if Flag then
    Result := sTrue
  else
    Result := sFalse;
end;

function IfInt(Flag: Boolean; const iTrue: integer; iFalse: integer = 0): integer;
begin
  if Flag then
    Result := iTrue
  else
    Result := iFalse;
end;

function IfReal(Flag: Boolean; const rTrue: Extended; rFalse: Extended = 0.0): Extended;
begin
  if Flag then
    Result := rTrue
  else
    Result := rFalse;
end;

function IfColor(Flag: Boolean; const cTrue: TColor; cFalse: TColor = clNone): TColor;
begin
  if Flag then
    Result := cTrue
  else
    Result := cFalse;
end;

function GetStr(const Id: string): string;
begin
  Result := frxResources.Get(Id)
end;

{$IFNDEF FPC}
procedure DisplayPNGInfo(const PNG: TPNGObject);

  function IIF(Expression: boolean; IfTrue: Integer; IfFalse: Integer): Integer; overload;
  begin
    if Expression then IIF := IfTrue else IIF := IfFalse
  end;

  function IIF(Expression: boolean; IfTrue: String; IfFalse: String): String; overload;
  begin
    if Expression then IIF := IfTrue else IIF := IfFalse
  end;

  function FormatTime(Chunk: TChunktIME): String;
  var
    Date: TDate;
    Time: TTime;
  begin
    if Chunk = nil then
      exit;
    Date := EncodeDate(Chunk.Year, Chunk.Month, Chunk.Day);
    Time := EncodeTime(Chunk.Hour, Chunk.Minute, Chunk.Second, 0);
    Result := DateToStr(Date) + ' ' + TimeToStr(Time);
  end;

const
  NewLine = chr(13) + chr(10);
begin
  with PNG, Header do
    ShowMessageFmt('Portable Network Graphics file' + NewLine + NewLine +
      'Width: %d' + NewLine + 'Height: %d' + NewLine +
      'Bitdepth: %d bits per pixel' + NewLine + 'Color type: %s' + NewLine +
      'Transparency type: %s' + NewLine + 'Interlace method: %s' + NewLine +
      'Has inside comments: %s' + NewLine + 'Inside time information: %s',
      [Width, Height, IIF(ColorType = COLOR_RGB, Bitdepth * 3, Bitdepth),
      IIF(ColorType in [COLOR_RGB, COLOR_RGBALPHA], 'RGB',
      IIF(ColorType = COLOR_PALETTE, 'Palette image', 'Grayscale image')),
      IIF(TransparencyMode = ptmBit, 'Single color full transparent',
      IIF(TransparencyMode = ptmPartial, 'Partial blended transparency',
      'No transparency')), IIF(PNG.InterlaceMethod = imAdam7, 'Adam 7', 'None'),
      IIF((Chunks.FindChunk(TChunktEXT) <> nil) or (Chunks.FindChunk(TChunkzTXT)
      <> nil), 'Yes', 'No'), IIF(Chunks.FindChunk(TChunktIME) <> nil,
      FormatTime(TChunktIME(Chunks.FindChunk(TChunktIME))), 'No information')]);
end;

function PNGToPNGA(PNG: TPngObject): TPngObject;
var
  PNGA: TPngObject;
  tRNS: TChunktRNS;
  PLTE: TChunkPLTE;
  dst: pRGBLine;
  src, alpha: {$IFDEF Delphi12}pngimage.{$ELSE}frxpngimage.{$ENDIF}pByteArray;
  X, Y: Integer;
  i: byte;
begin
  PNGA := TPngObject.CreateBlank(COLOR_RGBALPHA, 8, PNG.Width, PNG.Height);
  case PNG.Header.ColorType of
    COLOR_PALETTE:
      begin
        tRNS := PNG.Chunks.ItemFromClass(TChunktRNS) as TChunktRNS;
        PLTE := PNG.Chunks.ItemFromClass(TChunkPLTE) as TChunkPLTE;
        for Y := 0 to PNG.Height - 1 do
        begin
          dst := PNGA.Scanline[Y];
          src := PNG.Scanline[Y];
          alpha := PNGA.AlphaScanline[Y];
          for X := 0 to PNG.Width - 1 do
          begin
            case PNG.Header.BitDepth of
              8:
                i := src[X];
              2, 4:
                i := src[X div 2] shr ((1 - (X mod 2)) * 4) and $0F;
              1:
                i := src[X div 8] shr (7 - (X mod 8)) and 1;
            else
              raise Exception.Create('Unknown PNG BitDepth');
            end;
            dst[X].rgbtBlue := PLTE.Item[i].rgbBlue;
            dst[X].rgbtGreen := PLTE.Item[i].rgbGreen;
            dst[X].rgbtRed := PLTE.Item[i].rgbRed;
            if tRNS <> nil then
              alpha[X] := tRNS.PaletteValues[i]
            else
              alpha[X] := 255;
          end;
        end;
      end;

    COLOR_RGB, COLOR_GRAYSCALE:
      begin
        BitBlt(PNGA.Canvas.Handle, 0, 0, PNGA.Width, PNGA.Height,
          PNG.Canvas.Handle, 0, 0, SRCCOPY);
        for Y := 0 to PNG.Height - 1 do
          FillChar(PNGA.AlphaScanline[Y]^, PNG.Width, 255);
      end;

    COLOR_GRAYSCALEALPHA:
      begin
        BitBlt(PNGA.Canvas.Handle, 0, 0, PNGA.Width, PNGA.Height,
          PNG.Canvas.Handle, 0, 0, SRCCOPY);
        for Y := 0 to PNG.Height - 1 do
        begin
          src := PNG.AlphaScanline[Y];
          alpha := PNGA.AlphaScanline[Y];
          Move(src^, alpha^, PNG.Width);
        end;
      end;

  else
    PNGA.Assign(PNG);
  end;
  Result := PNGA;
end;
{$ENDIF}

end.
