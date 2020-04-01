unit frxBarcod;

{
Barcode Component
Version 1.25 (15.05.2003)
Copyright 1998-2003 Andreas Schmidt and friends
Adapted to FR: Alexander Tzyganenko
Added USPS Intelligent Mail: Oleg Adibekov

for use with Delphi 1 - 7
Delphi 1 not tested; better use Delphi 2 (or higher)

Freeware
Feel free to distribute the component as
long as all files are unmodified and kept together.

I'am not responsible for wrong barcodes.

bug-reports, enhancements:
mailto:shmia@bizerba.de or a_j_schmidt@rocketmail.com

please tell me wich version you are using, when mailing me.


get latest version from
http://members.tripod.de/AJSchmidt/index.html
http://mitglied.lycos.de/AJSchmidt/fbarcode.zip


many thanx and geetings to
Nikolay Simeonov, Wolfgang Koranda, Norbert Waas,
Richard Hugues, Olivier Guilbaud, Berend Tober, Jan Tungli,
Mauro Lemes, Norbert Kostka, Frank De Prins, Shane O'Dea,
Daniele Teti, Ignacio Trivino, Samuel J. Comstock, Roberto Parola,
Stefano Torricella and Mariusz Mialkon.

i use tabs:  1 tab = 3 spaces


History:
----------------------------------------------------------------------
Version 1.0:
- initial release
Version 1.1:
- more comments
- changed function Code_93Extended (now correct ?)
Version 1.2:
- Bugs (found by Nikolay Simeonov) removed
Version 1.3:
- EAN8/EAN13 added by Wolfgang Koranda (wkoranda@csi.com)
Version 1.4:
- Bug (found by Norbert Waas) removed
  Component must save the Canvas-properties Font,Pen and Brush
Version 1.5:
- Bug (found by Richard Hugues) removed
  Last line of barcode was 1 Pixel too wide
Version 1.6:
- new read-only property 'Width'
Version 1.7
- check for numeric barcode types
- compatible with Delphi 1 (i hope)
Version 1.8
- add Color and ColorBar properties
Version 1.9
- Code 128 C added by Jan Tungli
Version 1.10
- Bug in Code 39 Character I removed
Version 1.11 (06.07.1999)
- additional Code Types
  CodeUPC_A,
  CodeUPC_E0,
  CodeUPC_E1,
  CodeUPC_Supp2,
  CodeUPC_Supp5
  by Jan Tungli
Version 1.12 (13.07.1999)
- improved ShowText property by Mauro Lemes
  you must change your applications due changed interface of TBarcode.
Version 1.13 (23.07.1999)
- additional Code Types
  CodeEAN128A,
  CodeEAN128B,
  CodeEAN128C
  (support by Norbert Kostka)
- new property 'CheckSumMethod'
Version 1.14 (29.07.1999)
- checksum for EAN128 by Norbert Kostka
- bug fix for EAN128C
Version 1.15 (23.09.1999)
- bug fix for Code 39 with checksum by Frank De Prins
Version 1.16 (10.11.1999)
- width property is now writable (suggestion by Shane O'Dea)
Version 1.17 (27.06.2000)
- new OnChange property
- renamed TBarcode to TAsBarcode to avoid name conflicts
Version 1.18 (25.08.2000)
- some speed improvements (Code 93 and Code 128)
Version 1.19 (27.09.2000)
  (thanks to Samuel J. Comstock)
- origin of the barcode (left upper edge) is moved so that
  the barcode stays always on the canvas
- new (read only) properties 'CanvasWidth' and 'CanvasHeight' gives you
  the size of the resulting image.
- a wrapper class for Quick Reports is now available.
Version 1.20 (13.09.2000)
- Assign procedure added
- support for scaling barcode to Printer (see Demo)
Version 1.21 (19.07.2001)
  (thanks to Roberto Parola)
- new properties ShowTextFont and ShowTextPosition
Version 1.22 (26.10.2001)
- Code 128 Symbol #12 (=comma) fixed (thanks to Stefano Torricella)
Version 1.23 (13.11.2002)
- UPC_E0 and UPC_E1 stopcodes fixed (thanks to Duo Dreamer)
Version 1.24 (04.12.2002)
- Bugfix for Code93 Extended
Version 1.25 (15.05.2003)
- fixed a bug in procedure Assign (thanks to Mariusz Mialkon)

Todo (missing features)
-----------------------

- more CheckSum Methods
- user defined barcodes
- checksum event (fired when the checksum is calculated)
- rename the unit name (from 'barcode' to 'fbarcode') to avoid name conflicts
- I'am working on PDF417 barcode (has anybody some technical information about PDF417
  or a PDF417 reader ?)



Known Bugs
---------
- Top and Left properties must be set at runtime.
- comments not compatible with Delphi 1
}



interface

{$I frx.inc}

uses
  {WinProcs, WinTypes}
  {$IFNDEF FPC}Windows, Messages, {$ENDIF}
  Types, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  {$IFDEF FPC}
  , LCLType, LazHelper, LCLIntf, LCLProc
  {$ENDIF}
  , frxBarcodOneCode
  , StrUtils
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
  ;

type
  TfrxBarcodeType =
  (
  bcCode_2_5_interleaved,
  bcCode_2_5_industrial,
  bcCode_2_5_matrix,
  bcCode39,
  bcCode39Extended,
  bcCode128,     // auto encoded
  bcCode128A,
  bcCode128B,
  bcCode128C,
  bcCode93,
  bcCode93Extended,
  bcCodeMSI,
  bcCodePostNet,
  bcCodeCodabar,
  bcCodeEAN8,
  bcCodeEAN13,
  bcCodeUPC_A,
  bcCodeUPC_E0,
  bcCodeUPC_E1,
  bcCodeUPC_Supp2,    { UPC 2 digit supplemental }
  bcCodeUPC_Supp5,    { UPC 5 digit supplemental }
  bcCodeEAN128,  // auto encoded
  bcCodeEAN128A,
  bcCodeEAN128B,
  bcCodeEAN128C,
  bcCodeUSPSIntelligentMail,
  bcGS1Code128
  );


  TfrxBarLineType = (white, black, black_half,
    black_track, black_ascend, black_descend);  {for internal use only}
  { black_half means a black line with 2/5 height (used for PostNet) }
  { black_track, black_ascend, black_descend used for USPS Intelligent Mail,
    see https://en.wikipedia.org/wiki/File:Four_State_Barcode.svg }


  TfrxCheckSumMethod =
  (
  csmNone,
  csmModulo10
  );


  TfrxBarcode = class(TComponent)
  private
    FAngle: Double;
    FColor: TColor;
    FColorBar: TColor;
    FCheckSum: Boolean;
    FCheckSumMethod: TfrxCheckSumMethod;
    FHeight: Integer;
    FLeft: Integer;
    FModul: Integer;
    FRatio: Double;
    FText: AnsiString;
    FTop: Integer;
    FTyp: TfrxBarcodeType;
    FFont: TFont;
    modules: array[0..3] of ShortInt;

    procedure DoLines(data: AnsiString; Canvas: TCanvas);
    procedure OneBarProps(code: AnsiChar; var Width: Integer; var lt: TfrxBarLineType);
    function SetLen(pI: Byte): AnsiString;
    function Code_2_5_interleaved: AnsiString;
    function Code_2_5_industrial: AnsiString;
    function Code_2_5_matrix: AnsiString;
    function Code_39: AnsiString;
    function Code_39Extended: AnsiString;
    function Code_128: AnsiString;
    function Code_93: AnsiString;
    function Code_93Extended: AnsiString;
    function Code_MSI: AnsiString;
    function Code_PostNet: AnsiString;
    function Code_Codabar: AnsiString;
    function Code_EAN8: AnsiString;
    function Code_EAN13: AnsiString;
    function Code_UPC_A: AnsiString;
    function Code_UPC_E0: AnsiString;
    function Code_UPC_E1: AnsiString;
    function Code_Supp5: AnsiString;
    function Code_Supp2: AnsiString;
    function Code_USPSIntelligentMail: AnsiString;

    procedure MakeModules;
    function GetWidth : integer;
    function DoCheckSumming(const data : AnsiString):AnsiString;
    function MakeData : AnsiString;
    procedure SetTyp(const Value: TfrxBarcodeType);
  public
    constructor Create(Owner:TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent);override;

    procedure DrawBarcode(Canvas: TCanvas; ARect: TRect; ShowText: Boolean; aScaleDPIX, aScaleDPIY: Extended; DirectToEMF: Boolean = false);
  published
    property Text   : AnsiString read FText write FText;
    property Modul  : integer read FModul  write FModul;
    property Ratio  : Double read FRatio write FRatio;
    property Typ    : TfrxBarcodeType read FTyp write SetTyp;
    property Checksum:boolean read FCheckSum write FCheckSum;
    property CheckSumMethod:TfrxCheckSumMethod read FCheckSumMethod write FCheckSumMethod;
    property Angle  :double read FAngle write FAngle;
    property Width : integer read GetWidth;
    property Height: Integer read FHeight write FHeight;
    property Color:TColor read FColor write FColor;
    property ColorBar:TColor read FColorBar write FColorBar;
    property Font: TFont read FFont write FFont;
  end;


  TBCdata = packed record
   Name:AnsiString;        { Name of Barcode }
   num :Boolean;       { numeric data only }
  end;

  TfrxAICodesData = packed record
   AI: AnsiString;
   AISize:Byte;
   DataMinSize:Byte;
   DataMaxSize:Byte;
   FNC1 :Boolean;
  end;

const BCdata:array[bcCode_2_5_interleaved..bcGS1Code128] of TBCdata =
  (
    (Name:'2_5_interleaved'; num:True),
    (Name:'2_5_industrial';  num:True),
    (Name:'2_5_matrix';      num:True),
    (Name:'Code39';          num:False),
    (Name:'Code39 Extended'; num:False),
    (Name:'Code128';         num:False),
    (Name:'Code128A';        num:False),
    (Name:'Code128B';        num:False),
    (Name:'Code128C';        num:True),
    (Name:'Code93';          num:False),
    (Name:'Code93 Extended'; num:False),
    (Name:'MSI';             num:True),
    (Name:'PostNet';         num:True),
    (Name:'Codebar';         num:False),
    (Name:'EAN8';            num:True),
    (Name:'EAN13';           num:True),
    (Name:'UPC_A';           num:True),
    (Name:'UPC_E0';          num:True),
    (Name:'UPC_E1';          num:True),
    (Name:'UPC Supp2';       num:True),
    (Name:'UPC Supp5';       num:True),
    (Name:'EAN128';          num:False),
    (Name:'EAN128A';         num:False),
    (Name:'EAN128B';         num:False),
    (Name:'EAN128C';         num:True),
    (Name:'USPS Intelligent Mail'; num:True),
    (Name:'GS1 Code128'; num:False)
  );


const AICodesCount = 89;
{ AI table }
{ https://www.gs1.org/docs/barcodes/GS1_General_Specifications.pdf }
const AICodesData:array[0 .. AICodesCount - 1] of TfrxAICodesData =
  (
    (AI: '00'; AISize: 2; DataMinSize: 18; DataMaxSize: 18; FNC1: False),
    (AI: '01'; AISize: 2; DataMinSize: 14; DataMaxSize: 14; FNC1: False),
    (AI: '02'; AISize: 2; DataMinSize: 14; DataMaxSize: 14; FNC1: False),
    (AI: '10'; AISize: 2; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '11'; AISize: 2; DataMinSize: 6; DataMaxSize: 6; FNC1: False),
    (AI: '12'; AISize: 2; DataMinSize: 6; DataMaxSize: 6; FNC1: False),
    (AI: '13'; AISize: 2; DataMinSize: 6; DataMaxSize: 6; FNC1: False),
    (AI: '15'; AISize: 2; DataMinSize: 6; DataMaxSize: 6; FNC1: False),
    (AI: '16'; AISize: 2; DataMinSize: 6; DataMaxSize: 6; FNC1: False),
    (AI: '17'; AISize: 2; DataMinSize: 6; DataMaxSize: 6; FNC1: False),
    (AI: '20'; AISize: 2; DataMinSize: 2; DataMaxSize: 2; FNC1: False),
    (AI: '21'; AISize: 2; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '22'; AISize: 2; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '240'; AISize: 3; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '241'; AISize: 3; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '242'; AISize: 3; DataMinSize: 1; DataMaxSize: 6; FNC1: True),
    (AI: '243'; AISize: 3; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '250'; AISize: 3; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '251'; AISize: 3; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '253'; AISize: 3; DataMinSize: 13; DataMaxSize: 30; FNC1: True),
    (AI: '254'; AISize: 3; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '255'; AISize: 3; DataMinSize: 13; DataMaxSize: 25; FNC1: True),
    (AI: '30'; AISize: 2; DataMinSize: 1; DataMaxSize: 8; FNC1: True),
    (AI: '31XX'; AISize: 4; DataMinSize: 6; DataMaxSize: 6; FNC1: False),  // all 31xx
    (AI: '32XX'; AISize: 4; DataMinSize: 6; DataMaxSize: 6; FNC1: False),  // all 32xx
    (AI: '33XX'; AISize: 4; DataMinSize: 6; DataMaxSize: 6; FNC1: False),  // all 33xx
    (AI: '34XX'; AISize: 4; DataMinSize: 6; DataMaxSize: 6; FNC1: False),  // all 34xx
    (AI: '35XX'; AISize: 4; DataMinSize: 6; DataMaxSize: 6; FNC1: False),  // all 35xx
    (AI: '36XX'; AISize: 4; DataMinSize: 6; DataMaxSize: 6; FNC1: False),  // all 36xx
    (AI: '37'; AISize: 2; DataMinSize: 1; DataMaxSize: 8; FNC1: True),
    (AI: '390X'; AISize: 4; DataMinSize: 1; DataMaxSize: 15; FNC1: True),
    (AI: '391X'; AISize: 4; DataMinSize: 3; DataMaxSize: 18; FNC1: True),
    (AI: '392X'; AISize: 4; DataMinSize: 1; DataMaxSize: 15; FNC1: True),
    (AI: '393X'; AISize: 4; DataMinSize: 3; DataMaxSize: 18; FNC1: True),
    (AI: '394X'; AISize: 4; DataMinSize: 4; DataMaxSize: 4; FNC1: True),
    (AI: '400'; AISize: 3; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '401'; AISize: 3; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '402'; AISize: 3; DataMinSize: 17; DataMaxSize: 17; FNC1: True),
    (AI: '403'; AISize: 3; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '41X'; AISize: 3; DataMinSize: 13; DataMaxSize: 13; FNC1: False),
    (AI: '420'; AISize: 3; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '421'; AISize: 3; DataMinSize: 3; DataMaxSize: 12; FNC1: True),
    (AI: '422'; AISize: 3; DataMinSize: 3; DataMaxSize: 3; FNC1: True),
    (AI: '423'; AISize: 3; DataMinSize: 3; DataMaxSize: 15; FNC1: True),
    (AI: '424'; AISize: 3; DataMinSize: 3; DataMaxSize: 3; FNC1: True),
    (AI: '425'; AISize: 3; DataMinSize: 3; DataMaxSize: 15; FNC1: True),
    (AI: '426'; AISize: 3; DataMinSize: 3; DataMaxSize: 3; FNC1: True),
    (AI: '7001'; AISize: 4; DataMinSize: 13; DataMaxSize: 13; FNC1: True),
    (AI: '7002'; AISize: 4; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '7003'; AISize: 4; DataMinSize: 10; DataMaxSize: 10; FNC1: True),
    (AI: '7004'; AISize: 4; DataMinSize: 1; DataMaxSize: 4; FNC1: True),
    (AI: '7005'; AISize: 4; DataMinSize: 1; DataMaxSize: 12; FNC1: True),
    (AI: '7006'; AISize: 4; DataMinSize: 6; DataMaxSize: 6; FNC1: True),
    (AI: '7007'; AISize: 4; DataMinSize: 6; DataMaxSize: 12; FNC1: True),
    (AI: '7008'; AISize: 4; DataMinSize: 1; DataMaxSize: 3; FNC1: True),
    (AI: '7009'; AISize: 4; DataMinSize: 1; DataMaxSize: 10; FNC1: True),
    (AI: '7010'; AISize: 4; DataMinSize: 1; DataMaxSize: 2; FNC1: True),
    (AI: '7020'; AISize: 4; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '7021'; AISize: 4; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '7022'; AISize: 4; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '7023'; AISize: 4; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '703X'; AISize: 4; DataMinSize: 3; DataMaxSize: 30; FNC1: True),
    (AI: '710'; AISize: 3; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '711'; AISize: 3; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '712'; AISize: 3; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '713'; AISize: 3; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '71X'; AISize: 3; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '8001'; AISize: 4; DataMinSize: 14; DataMaxSize: 14; FNC1: True),
    (AI: '8002'; AISize: 4; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '8003'; AISize: 4; DataMinSize: 14; DataMaxSize: 30; FNC1: True),
    (AI: '8004'; AISize: 4; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '8005'; AISize: 4; DataMinSize: 6; DataMaxSize: 6; FNC1: True),
    (AI: '8006'; AISize: 4; DataMinSize: 18; DataMaxSize: 18; FNC1: True),
    (AI: '8007'; AISize: 4; DataMinSize: 1; DataMaxSize: 34; FNC1: True),
    (AI: '8008'; AISize: 4; DataMinSize: 8; DataMaxSize: 12; FNC1: True),
    (AI: '8010'; AISize: 4; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '8011'; AISize: 4; DataMinSize: 1; DataMaxSize: 12; FNC1: True),
    (AI: '8012'; AISize: 4; DataMinSize: 1; DataMaxSize: 20; FNC1: True),
    (AI: '8013'; AISize: 4; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '8017'; AISize: 4; DataMinSize: 18; DataMaxSize: 18; FNC1: True),
    (AI: '8018'; AISize: 4; DataMinSize: 18; DataMaxSize: 18; FNC1: True),
    (AI: '8019'; AISize: 4; DataMinSize: 1; DataMaxSize: 10; FNC1: True),
    (AI: '8020'; AISize: 4; DataMinSize: 1; DataMaxSize: 25; FNC1: True),
    (AI: '8110'; AISize: 4; DataMinSize: 1; DataMaxSize: 70; FNC1: True),
    (AI: '8111'; AISize: 4; DataMinSize: 4; DataMaxSize: 4; FNC1: True),
    (AI: '8112'; AISize: 4; DataMinSize: 1; DataMaxSize: 70; FNC1: True),
    (AI: '8200'; AISize: 4; DataMinSize: 1; DataMaxSize: 70; FNC1: True),
    (AI: '90'; AISize: 2; DataMinSize: 1; DataMaxSize: 30; FNC1: True),
    (AI: '9X'; AISize: 2; DataMinSize: 1; DataMaxSize: 90; FNC1: True)
  );

implementation

function CheckSumModulo10(const data:AnsiString):AnsiString;
        var i,fak,sum : Integer;
begin
        sum := 0;
        fak := Length(data);
        for i:=1 to Length(data) do
        begin
                if (fak mod 2) = 0 then
                        sum := sum + (StrToInt(String(data[i]))*1)
                else
                        sum := sum + (StrToInt(String(data[i]))*3);
                dec(fak);
        end;
        if (sum mod 10) = 0 then
                result := data+'0'
        else
                result := data + AnsiString(IntToStr(10-(sum mod 10)));
end;

procedure Assert(Cond: Boolean; Text: String);
begin
  if not Cond then
    raise Exception.Create(Text);
end;

{
  converts a string from '321' to the internal representation '715'
  i need this function because some pattern tables have a different
  format :

  '00111'
  converts to '05161'
}
function Convert(const s:AnsiString):AnsiString;
var
  i, v : integer;
begin
  Result := s;  { same Length as Input - string }
  for i:=1 to Length(s) do
  begin
    v := ord(s[i]) - 1;

    if odd(i) then
      Inc(v, 5);
    Result[i] := AnsiChar(Chr(v));
  end;
end;

(*
 * Berechne die Quersumme aus einer Zahl x
 * z.B.: Quersumme von 1234 ist 10
 *)
function quersumme(x:integer):integer;
var
  sum:integer;
begin
  sum := 0;

  while x > 0 do
  begin
    sum := sum + (x mod 10);
    x := x div 10;
  end;
  result := sum;
end;


{
  Rotate a Point by Angle 'alpha'
}
function Rotate2D(p:TPoint; alpha:double): TPoint;
var
  sinus, cosinus : Extended;
begin
  sinus   := sin(alpha);
  cosinus := cos(alpha);
  result.x := Round(p.x*cosinus + p.y*sinus);
  result.y := Round(-p.x*sinus + p.y*cosinus);
end;

{
  Move Point "a" by Vector "b"
}
function Translate2D(a, b:TPoint): TPoint;
begin
  result.x := a.x + b.x;
  result.y := a.y + b.y;
end;


{
  Move the orgin so that when point is rotated by alpha, the rect
  between point and orgin stays in the visible quadrant.
}
function TranslateQuad2D(const alpha :double; const orgin, point :TPoint): TPoint;
var
   alphacos: Extended;
   alphasin: Extended;
   moveby:   TPoint;
begin
   alphasin := sin(alpha);
   alphacos := cos(alpha);

   if alphasin >= 0 then
   begin
      if alphacos >= 0 then
      begin
         // 1. Quadrant
         moveby.x := 0;
         moveby.y := Round(alphasin*point.x);
      end
      else
      begin
         // 2. Quadrant
         moveby.x := -Round(alphacos*point.x);
         moveby.y := Round(alphasin*point.x - alphacos*point.y);
      end;
   end
   else
   begin
      if alphacos >= 0 then
      begin
         // 4. quadrant
         moveby.x := -Round(alphasin*point.y);
         moveby.y := 0;
      end
      else
      begin
         // 3. quadrant
         moveby.x := -Round(alphacos*point.x) - Round(alphasin*point.y);
         moveby.y := -Round(alphacos*point.y);
      end;
   end;
   Result := Translate2D(orgin, moveby);
end;


constructor TfrxBarcode.Create(Owner:TComponent);
begin
  inherited Create(owner);
  FAngle := 0.0;
  FRatio := 2.0;
  FModul := 1;
  FTyp   := bcCodeEAN13;
  FCheckSum := FALSE;
  FCheckSumMethod := csmModulo10;
  FColor    := clWhite;
  FColorBar := clBlack;
  FFont := TFont.Create;
  FFont.Name := 'Arial';
  FFont.Size := 9;
  FFont.PixelsPerInch := 96;
end;


procedure TfrxBarcode.Assign(Source: TPersistent);
var
   BSource : TfrxBarcode;
begin
   if Source is TfrxBarcode then
   begin
      BSource    := TfrxBarcode(Source);
      FHeight    := BSource.FHeight;
      FText      := BSource.FText;
      FTop       := BSource.FTop;
      FLeft      := BSource.FLeft;
      FModul     := BSource.FModul;
      FRatio     := BSource.FRatio;
      FTyp       := BSource.FTyp;
      FCheckSum  := BSource.FCheckSum;
      FAngle     := BSource.FAngle;
      FColor     := BSource.FColor;
      FColorBar  := BSource.FColorBar;
      FCheckSumMethod := BSource.FCheckSumMethod;
   end;
end;



{
calculate the width and the linetype of a sigle bar


  Code   Line-Color      Width               Height
------------------------------------------------------------------
  '0'   white           100%                full
  '1'   white           100%*Ratio          full
  '2'   white           150%*Ratio          full
  '3'   white           200%*Ratio          full
  '5'   black           100%                full
  '6'   black           100%*Ratio          full
  '7'   black           150%*Ratio          full
  '8'   black           200%*Ratio          full
  'A'   black           100%                2/5  (used for PostNet)
  'B'   black           100%*Ratio          2/5  (used for PostNet)
  'C'   black           150%*Ratio          2/5  (used for PostNet)
  'D'   black           200%*Ratio          2/5  (used for PostNet)
}
procedure TfrxBarcode.OneBarProps(code:AnsiChar; var Width:integer; var lt:TfrxBarLineType);
begin
  case code of
    '0': begin width := modules[0]; lt := white; end;
    '1': begin width := modules[1]; lt := white; end;
    '2': begin width := modules[2]; lt := white; end;
    '3': begin width := modules[3]; lt := white; end;


    '5': begin width := modules[0]; lt := black; end;
    '6': begin width := modules[1]; lt := black; end;
    '7': begin width := modules[2]; lt := black; end;
    '8': begin width := modules[3]; lt := black; end;

    'A': begin width := modules[0]; lt := black_half; end;
    'B': begin width := modules[1]; lt := black_half; end;
    'C': begin width := modules[2]; lt := black_half; end;
    'D': begin width := modules[3]; lt := black_half; end;

    'F': begin width := modules[0]; lt := black_track; end;
    'G': begin width := modules[0]; lt := black_ascend; end;
    'H': begin width := modules[0]; lt := black_descend; end;
  else
    begin
   {something went wrong  :-(  }
   {mistyped pattern table}
    raise Exception.CreateFmt('%s: internal Error', [self.ClassName]);
    end;
  end;
end;

function StripControlCodes(const code: AnsiString; stripFNCodes: Boolean): AnsiString; forward;

function TfrxBarcode.MakeData : AnsiString;
var
  i : integer;
  S: AnsiString;
begin
  {calculate the with of the different lines (modules)}
  MakeModules;


  {numeric barcode type ?}
  if BCdata[Typ].num then
  begin
    FText := AnsiString(Trim(String(FText))); {remove blanks}
    S := FTEXT;
    if Typ in [bcCode128C, bcCodeEAN128C] then
      s := StripControlCodes(AnsiString(StringReplace(String(s), '&FNC1;', '&1;', [rfReplaceAll])), True);
    for i := 1 to Length(S) do
      if ((S[i] > '9') or (S[i] < '0')) and not (Typ in [bcCode128C, bcCodeEAN128C]) and ((S[i] = '(') or (S[i] = ')'))  then
        raise Exception.Create('Barcode must be numeric');
  end;


  {get the pattern of the barcode}
  case Typ of
    bcCode_2_5_interleaved: Result := Code_2_5_interleaved;
    bcCode_2_5_industrial:  Result := Code_2_5_industrial;
    bcCode_2_5_matrix:      Result := Code_2_5_matrix;
    bcCode39:               Result := Code_39;
    bcCode39Extended:       Result := Code_39Extended;
    bcGS1Code128,
    bcCode128,
    bcCode128A,
    bcCode128B,
    bcCode128C,
    bcCodeEAN128,
    bcCodeEAN128A,
    bcCodeEAN128B,
    bcCodeEAN128C:          Result := Code_128;
    bcCode93:               Result := Code_93;
    bcCode93Extended:       Result := Code_93Extended;
    bcCodeMSI:              Result := Code_MSI;
    bcCodePostNet:          Result := Code_PostNet;
    bcCodeCodabar:          Result := Code_Codabar;
    bcCodeEAN8:             Result := Code_EAN8;
    bcCodeEAN13:            Result := Code_EAN13;
    bcCodeUPC_A:            Result := Code_UPC_A;
    bcCodeUPC_E0:           Result := Code_UPC_E0;
    bcCodeUPC_E1:           Result := Code_UPC_E1;
    bcCodeUPC_Supp2:        Result := Code_Supp2;
    bcCodeUPC_Supp5:        Result := Code_Supp5;
    bcCodeUSPSIntelligentMail: Result := Code_USPSIntelligentMail;
  else
    raise Exception.CreateFmt('%s: wrong BarcodeType', [self.ClassName]);
  end;

{
Showmessage(Format('Data <%s>', [Result]));
}
end;



function TfrxBarcode.GetWidth:integer;
var
  data : AnsiString;
  i : integer;
  w : integer;
  lt : TfrxBarLineType;
begin
  Result := 0;

  {get barcode pattern}
  data := MakeData;

  for i:=1 to Length(data) do  {examine the pattern string}
  begin
    OneBarProps(data[i], w, lt);
    Inc(Result, w);
  end;
end;

function TfrxBarcode.DoCheckSumming(const data : AnsiString):AnsiString;
begin
  case FCheckSumMethod of

    csmNone:
      Result := data;
    csmModulo10:
      Result := CheckSumModulo10(data);

  end;
end;




{
////////////////////////////// EAN /////////////////////////////////////////
}


{
////////////////////////////// EAN8 /////////////////////////////////////////
}

{Pattern for Barcode EAN Charset A}
     {L1   S1   L2   S2}
const tabelle_EAN_A:array['0'..'9'] of AnsiString =
  (
  ('2605'),    { 0 }
  ('1615'),    { 1 }
  ('1516'),    { 2 }
  ('0805'),    { 3 }
  ('0526'),    { 4 }
  ('0625'),    { 5 }
  ('0508'),    { 6 }
  ('0706'),    { 7 }
  ('0607'),    { 8 }
  ('2506')     { 9 }
  );

{Pattern for Barcode EAN Charset C}
     {S1   L1   S2   L2}
const tabelle_EAN_C:array['0'..'9'] of AnsiString =
  (
  ('7150' ),    { 0 }
  ('6160' ),    { 1 }
  ('6061' ),    { 2 }
  ('5350' ),    { 3 }
  ('5071' ),    { 4 }
  ('5170' ),    { 5 }
  ('5053' ),    { 6 }
  ('5251' ),    { 7 }
  ('5152' ),    { 8 }
  ('7051' )     { 9 }
  );


function TfrxBarcode.Code_EAN8:AnsiString;
var
  i : integer;
  tmp : AnsiString;
begin
  if FCheckSum then
  begin
    tmp := SetLen(7);
    tmp := DoCheckSumming(copy(tmp,length(tmp)-6,7));
  end
  else
    tmp := SetLen(8);

  Assert(Length(tmp)=8, 'Invalid Text len (EAN8)');
  result := '505';   {Startcode}

  for i:=1 to 4 do
    result := result + tabelle_EAN_A[tmp[i]] ;

  result := result + '05050';   {Center Guard Pattern}

  for i:=5 to 8 do
    result := result + tabelle_EAN_C[tmp[i]] ;

  result := result + '505';   {Stopcode}
end;

{////////////////////////////// EAN13 ///////////////////////////////////////}

{Pattern for Barcode EAN Zeichensatz B}
     {L1   S1   L2   S2}
const tabelle_EAN_B:array['0'..'9'] of AnsiString =
  (
  ('0517'),    { 0 }
  ('0616'),    { 1 }
  ('1606'),    { 2 }
  ('0535'),    { 3 }
  ('1705'),    { 4 }
  ('0715'),    { 5 }
  ('3505'),    { 6 }
  ('1525'),    { 7 }
  ('2515'),    { 8 }
  ('1507')     { 9 }
  );

{Zuordung der Paraitaetsfolgen f¹r EAN13}
const tabelle_ParityEAN13:array[0..9, 1..6] of AnsiChar =
  (
  ('A', 'A', 'A', 'A', 'A', 'A'),    { 0 }
  ('A', 'A', 'B', 'A', 'B', 'B'),    { 1 }
  ('A', 'A', 'B', 'B', 'A', 'B'),    { 2 }
  ('A', 'A', 'B', 'B', 'B', 'A'),    { 3 }
  ('A', 'B', 'A', 'A', 'B', 'B'),    { 4 }
  ('A', 'B', 'B', 'A', 'A', 'B'),    { 5 }
  ('A', 'B', 'B', 'B', 'A', 'A'),    { 6 }
  ('A', 'B', 'A', 'B', 'A', 'B'),    { 7 }
  ('A', 'B', 'A', 'B', 'B', 'A'),    { 8 }
  ('A', 'B', 'B', 'A', 'B', 'A')     { 9 }
  );

function TfrxBarcode.Code_EAN13:AnsiString;
var
   i, LK: integer;
   tmp : AnsiString;
begin
  if FCheckSum then
    FText := Copy(FText, 1, 12);
  if Length(FText) <> 13 then 
  begin
    FText := SetLen(13);
    if FCheckSum then
      tmp := DoCheckSumming(copy(FText,2,12));
    if FCheckSum then 
      FText := tmp
    else 
      tmp := FText;
  end
  else 
    tmp := FText;

  Assert(Length(tmp) = 13, 'Invalid Text len (EAN13)');

  LK := StrToInt(String(tmp[1]));
  tmp := copy(tmp,2,12);

  result := '505';   {Startcode}

  for i:=1 to 6 do
  begin
    case tabelle_ParityEAN13[LK,i] of
      'A' : result := result + tabelle_EAN_A[tmp[i]];
      'B' : result := result + tabelle_EAN_B[tmp[i]] ;
      'C' : result := result + tabelle_EAN_C[tmp[i]] ;
  end;
  end;

  result := result + '05050';   {Center Guard Pattern}

  for i:=7 to 12 do
    result := result + tabelle_EAN_C[tmp[i]] ;

    result := result + '505';   {Stopcode}
end;

{Pattern for Barcode 2 of 5}
const tabelle_2_5:array['0'..'9', 1..5] of AnsiChar =
  (
  ('0', '0', '1', '1', '0'),    {'0'}
  ('1', '0', '0', '0', '1'),    {'1'}
  ('0', '1', '0', '0', '1'),    {'2'}
  ('1', '1', '0', '0', '0'),    {'3'}
  ('0', '0', '1', '0', '1'),    {'4'}
  ('1', '0', '1', '0', '0'),    {'5'}
  ('0', '1', '1', '0', '0'),    {'6'}
  ('0', '0', '0', '1', '1'),    {'7'}
  ('1', '0', '0', '1', '0'),    {'8'}
  ('0', '1', '0', '1', '0')     {'9'}
  );

function TfrxBarcode.Code_2_5_interleaved:AnsiString;
var
  i, j : integer;
  c : AnsiChar;
begin
  result := '5050';   {Startcode}
  if FCheckSum and (Length(FText) mod 2 <> 0) then
      FText := DoCheckSumming(FText);
  if Length(FText) mod 2 = 1 then FText := '0' + FText;
  for i:=1 to Length(FText) div 2 do
  begin
    for j:= 1 to 5 do
    begin
      if tabelle_2_5[FText[i*2-1], j] = '1' then
        c := '6'
      else
        c := '5';
      result := result + c;
      if tabelle_2_5[FText[i*2], j] = '1' then
        c := '1'
      else
        c := '0';
      result := result + c;
    end;
  end;

  result := result + '605';    {Stopcode}
end;


function TfrxBarcode.Code_2_5_industrial:AnsiString;
var
  i, j: integer;
begin
//  result := '606050';   {Startcode}
  result := '55055050';   {Startcode}

  for i:=1 to Length(FText) do
  begin
    for j:= 1 to 5 do
    begin
    if tabelle_2_5[FText[i], j] = '1' then
      result := result + '60'
    else
      result := result + '50';
    end;
  end;

//  result := result + '605060';   {Stopcode}
  result := result + '55050550';   {Stopcode}
end;

function TfrxBarcode.Code_2_5_matrix:AnsiString;
var
  i, j: integer;
  c :AnsiChar;
begin
  result := '705050';   {Startcode}

  for i:=1 to Length(FText) do
  begin
    for j:= 1 to 5 do
    begin
      if tabelle_2_5[FText[i], j] = '1' then
        c := '1'
      else
        c := '0';

    {Falls i ungerade ist dann mache L¹cke zu Strich}
      if odd(j) then
        c := AnsiChar(chr(ord(c)+5));
      result := result + c;
    end;
   result := result + '0';   {L¹cke zwischen den Zeichen}
  end;

  result := result + '70505';   {Stopcode}
end;



type TCode39 =
  record
    c : AnsiChar;
    data : array[0..9] of AnsiChar;
    chk: shortint;
  end;

const tabelle_39: array[0..43] of TCode39 = (
  ( c:'0'; data:'505160605'; chk:0 ),
  ( c:'1'; data:'605150506'; chk:1 ),
  ( c:'2'; data:'506150506'; chk:2 ),
  ( c:'3'; data:'606150505'; chk:3 ),
  ( c:'4'; data:'505160506'; chk:4 ),
  ( c:'5'; data:'605160505'; chk:5 ),
  ( c:'6'; data:'506160505'; chk:6 ),
  ( c:'7'; data:'505150606'; chk:7 ),
  ( c:'8'; data:'605150605'; chk:8 ),
  ( c:'9'; data:'506150605'; chk:9 ),
  ( c:'A'; data:'605051506'; chk:10),
  ( c:'B'; data:'506051506'; chk:11),
  ( c:'C'; data:'606051505'; chk:12),
  ( c:'D'; data:'505061506'; chk:13),
  ( c:'E'; data:'605061505'; chk:14),
  ( c:'F'; data:'506061505'; chk:15),
  ( c:'G'; data:'505051606'; chk:16),
  ( c:'H'; data:'605051605'; chk:17),
  ( c:'I'; data:'506051605'; chk:18),
  ( c:'J'; data:'505061605'; chk:19),
  ( c:'K'; data:'605050516'; chk:20),
  ( c:'L'; data:'506050516'; chk:21),
  ( c:'M'; data:'606050515'; chk:22),
  ( c:'N'; data:'505060516'; chk:23),
  ( c:'O'; data:'605060515'; chk:24),
  ( c:'P'; data:'506060515'; chk:25),
  ( c:'Q'; data:'505050616'; chk:26),
  ( c:'R'; data:'605050615'; chk:27),
  ( c:'S'; data:'506050615'; chk:28),
  ( c:'T'; data:'505060615'; chk:29),
  ( c:'U'; data:'615050506'; chk:30),
  ( c:'V'; data:'516050506'; chk:31),
  ( c:'W'; data:'616050505'; chk:32),
  ( c:'X'; data:'515060506'; chk:33),
  ( c:'Y'; data:'615060505'; chk:34),
  ( c:'Z'; data:'516060505'; chk:35),
  ( c:'-'; data:'515050606'; chk:36),
  ( c:'.'; data:'615050605'; chk:37),
  ( c:' '; data:'516050605'; chk:38),
  ( c:'*'; data:'515060605'; chk:0 ),
  ( c:'$'; data:'515151505'; chk:39),
  ( c:'/'; data:'515150515'; chk:40),
  ( c:'+'; data:'515051515'; chk:41),
  ( c:'%'; data:'505151515'; chk:42)
  );

function TfrxBarcode.Code_39:AnsiString;

function FindIdx(z: AnsiChar):integer;
var
  i:integer;
begin
  for i:=0 to High(tabelle_39) do
  begin
    if z = tabelle_39[i].c then
    begin
      result := i;
      exit;
    end;
  end;
  result := -1;
end;

var
  i, idx : integer;
  checksum:integer;

begin
  checksum := 0;
  {Startcode}
  result := tabelle_39[FindIdx('*')].data + '0';

  for i:=1 to Length(FText) do
  begin
    idx := FindIdx(AnsiChar(FText[i]));
    if idx < 0 then
      continue;
    result := result + tabelle_39[idx].data + '0';
    Inc(checksum, tabelle_39[idx].chk);
  end;

  {Calculate Checksum Data}
  if FCheckSum then
    begin
    checksum := checksum mod 43;
    for i:=0 to High(tabelle_39) do
      if checksum = tabelle_39[i].chk then
      begin
        result := result + tabelle_39[i].data + '0';
        break;
      end;
    end;

  {Stopcode}
  result := result + tabelle_39[FindIdx('*')].data;
end;

const code39x : array[0..127] of AnsiString  =
  (
  ('%U'), ('$A'), ('$B'), ('$C'), ('$D'), ('$E'), ('$F'), ('$G'),
  ('$H'), ('$I'), ('$J'), ('$K'), ('$L'), ('$M'), ('$N'), ('$O'),
  ('$P'), ('$Q'), ('$R'), ('$S'), ('$T'), ('$U'), ('$V'), ('$W'),
  ('$X'), ('$Y'), ('$Z'), ('%A'), ('%B'), ('%C'), ('%D'), ('%E'),
   (' '), ('/A'), ('/B'), ('/C'), ('/D'), ('/E'), ('/F'), ('/G'),
  ('/H'), ('/I'), ('/J'), ('/K'), ('/L'), ('/M'), ('/N'), ('/O'),
  ( '0'),  ('1'),  ('2'),  ('3'),  ('4'),  ('5'),  ('6'),  ('7'),
   ('8'),  ('9'), ('/Z'), ('%F'), ('%G'), ('%H'), ('%I'), ('%J'),
  ('%V'),  ('A'),  ('B'),  ('C'),  ('D'),  ('E'),  ('F'),  ('G'),
   ('H'),  ('I'),  ('J'),  ('K'),  ('L'),  ('M'),  ('N'),  ('O'),
   ('P'),  ('Q'),  ('R'),  ('S'),  ('T'),  ('U'),  ('V'),  ('W'),
   ('X'),  ('Y'),  ('Z'), ('%K'), ('%L'), ('%M'), ('%N'), ('%O'),
  ('%W'), ('+A'), ('+B'), ('+C'), ('+D'), ('+E'), ('+F'), ('+G'),
  ('+H'), ('+I'), ('+J'), ('+K'), ('+L'), ('+M'), ('+N'), ('+O'),
  ('+P'), ('+Q'), ('+R'), ('+S'), ('+T'), ('+U'), ('+V'), ('+W'),
  ('+X'), ('+Y'), ('+Z'), ('%P'), ('%Q'), ('%R'), ('%S'), ('%T')
  );

function TfrxBarcode.Code_39Extended:AnsiString;
var
  save:AnsiString;
  i : integer;
begin
  save := FText;
  FText := '';

  for i:=1 to Length(save) do
  begin
    if ord(save[i]) <= 127 then
      FText := FText + code39x[ord(save[i])];
  end;
  result := Code_39;
  FText := save;
end;



{
Code 128
}
type
  Code128Encoding = (encA, encB, encC, encAorB, encNone);
  TCode128 = record
    a, b : AnsiChar;
    c : AnsiString;
    data : AnsiString;
  end;

const
  tabelle_128: array[0..105] of TCode128 = (
  ( a:' '; b:' '; c:'00'; data:'212222' ),
  ( a:'!'; b:'!'; c:'01'; data:'222122' ),
  ( a:'"'; b:'"'; c:'02'; data:'222221' ),
  ( a:'#'; b:'#'; c:'03'; data:'121223' ),
  ( a:'$'; b:'$'; c:'04'; data:'121322' ),
  ( a:'%'; b:'%'; c:'05'; data:'131222' ),
  ( a:'&'; b:'&'; c:'06'; data:'122213' ),
  ( a:''''; b:''''; c:'07'; data:'122312' ),
  ( a:'('; b:'('; c:'08'; data:'132212' ),
  ( a:')'; b:')'; c:'09'; data:'221213' ),
  ( a:'*'; b:'*'; c:'10'; data:'221312' ),
  ( a:'+'; b:'+'; c:'11'; data:'231212' ),
  ( a:','; b:','; c:'12'; data:'112232' ), {23.10.2001 Stefano Torricella}
  ( a:'-'; b:'-'; c:'13'; data:'122132' ),
  ( a:'.'; b:'.'; c:'14'; data:'122231' ),
  ( a:'/'; b:'/'; c:'15'; data:'113222' ),
  ( a:'0'; b:'0'; c:'16'; data:'123122' ),
  ( a:'1'; b:'1'; c:'17'; data:'123221' ),
  ( a:'2'; b:'2'; c:'18'; data:'223211' ),
  ( a:'3'; b:'3'; c:'19'; data:'221132' ),
  ( a:'4'; b:'4'; c:'20'; data:'221231' ),
  ( a:'5'; b:'5'; c:'21'; data:'213212' ),
  ( a:'6'; b:'6'; c:'22'; data:'223112' ),
  ( a:'7'; b:'7'; c:'23'; data:'312131' ),
  ( a:'8'; b:'8'; c:'24'; data:'311222' ),
  ( a:'9'; b:'9'; c:'25'; data:'321122' ),
  ( a:':'; b:':'; c:'26'; data:'321221' ),
  ( a:';'; b:';'; c:'27'; data:'312212' ),
  ( a:'<'; b:'<'; c:'28'; data:'322112' ),
  ( a:'='; b:'='; c:'29'; data:'322211' ),
  ( a:'>'; b:'>'; c:'30'; data:'212123' ),
  ( a:'?'; b:'?'; c:'31'; data:'212321' ),
  ( a:'@'; b:'@'; c:'32'; data:'232121' ),
  ( a:'A'; b:'A'; c:'33'; data:'111323' ),
  ( a:'B'; b:'B'; c:'34'; data:'131123' ),
  ( a:'C'; b:'C'; c:'35'; data:'131321' ),
  ( a:'D'; b:'D'; c:'36'; data:'112313' ),
  ( a:'E'; b:'E'; c:'37'; data:'132113' ),
  ( a:'F'; b:'F'; c:'38'; data:'132311' ),
  ( a:'G'; b:'G'; c:'39'; data:'211313' ),
  ( a:'H'; b:'H'; c:'40'; data:'231113' ),
  ( a:'I'; b:'I'; c:'41'; data:'231311' ),
  ( a:'J'; b:'J'; c:'42'; data:'112133' ),
  ( a:'K'; b:'K'; c:'43'; data:'112331' ),
  ( a:'L'; b:'L'; c:'44'; data:'132131' ),
  ( a:'M'; b:'M'; c:'45'; data:'113123' ),
  ( a:'N'; b:'N'; c:'46'; data:'113321' ),
  ( a:'O'; b:'O'; c:'47'; data:'133121' ),
  ( a:'P'; b:'P'; c:'48'; data:'313121' ),
  ( a:'Q'; b:'Q'; c:'49'; data:'211331' ),
  ( a:'R'; b:'R'; c:'50'; data:'231131' ),
  ( a:'S'; b:'S'; c:'51'; data:'213113' ),
  ( a:'T'; b:'T'; c:'52'; data:'213311' ),
  ( a:'U'; b:'U'; c:'53'; data:'213131' ),
  ( a:'V'; b:'V'; c:'54'; data:'311123' ),
  ( a:'W'; b:'W'; c:'55'; data:'311321' ),
  ( a:'X'; b:'X'; c:'56'; data:'331121' ),
  ( a:'Y'; b:'Y'; c:'57'; data:'312113' ),
  ( a:'Z'; b:'Z'; c:'58'; data:'312311' ),
  ( a:'['; b:'['; c:'59'; data:'332111' ),
  ( a:'\'; b:'\'; c:'60'; data:'314111' ),
  ( a:']'; b:']'; c:'61'; data:'221411' ),
  ( a:'^'; b:'^'; c:'62'; data:'431111' ),
  ( a:'_'; b:'_'; c:'63'; data:'111224' ),
  ( a:#00; b:'`'; c:'64'; data:'111422' ),
  ( a:#01; b:'a'; c:'65'; data:'121124' ),
  ( a:#02; b:'b'; c:'66'; data:'121421' ),
  ( a:#03; b:'c'; c:'67'; data:'141122' ),
  ( a:#04; b:'d'; c:'68'; data:'141221' ),
  ( a:#05; b:'e'; c:'69'; data:'112214' ),
  ( a:#06; b:'f'; c:'70'; data:'112412' ),
  ( a:#07; b:'g'; c:'71'; data:'122114' ),
  ( a:#08; b:'h'; c:'72'; data:'122411' ),
  ( a:#09; b:'i'; c:'73'; data:'142112' ),
  ( a:#10; b:'j'; c:'74'; data:'142211' ),
  ( a:#11; b:'k'; c:'75'; data:'241211' ),
  ( a:#12; b:'l'; c:'76'; data:'221114' ),
  ( a:#13; b:'m'; c:'77'; data:'413111' ),
  ( a:#14; b:'n'; c:'78'; data:'241112' ),
  ( a:#15; b:'o'; c:'79'; data:'134111' ),
  ( a:#16; b:'p'; c:'80'; data:'111242' ),
  ( a:#17; b:'q'; c:'81'; data:'121142' ),
  ( a:#18; b:'r'; c:'82'; data:'121241' ),
  ( a:#19; b:'s'; c:'83'; data:'114212' ),
  ( a:#20; b:'t'; c:'84'; data:'124112' ),
  ( a:#21; b:'u'; c:'85'; data:'124211' ),
  ( a:#22; b:'v'; c:'86'; data:'411212' ),
  ( a:#23; b:'w'; c:'87'; data:'421112' ),
  ( a:#24; b:'x'; c:'88'; data:'421211' ),
  ( a:#25; b:'y'; c:'89'; data:'212141' ),
  ( a:#26; b:'z'; c:'90'; data:'214121' ),
  ( a:#27; b:'{'; c:'91'; data:'412121' ),
  ( a:#28; b:'|'; c:'92'; data:'111143' ),
  ( a:#29; b:'}'; c:'93'; data:'111341' ),
  ( a:#30; b:'~'; c:'94'; data:'131141' ),
  ( a:#31; b:' '; c:'95'; data:'114113' ),
  ( a:' '; b:' '; c:'96'; data:'114311' ),     // FNC3
  ( a:' '; b:' '; c:'97'; data:'411113' ),     // FNC2
  ( a:' '; b:' '; c:'98'; data:'411311' ),     // SHIFT
  ( a:' '; b:' '; c:'99'; data:'113141' ),     // CODE C
  ( a:' '; b:' '; c:'  '; data:'114131' ),     // FNC4, CODE B
  ( a:' '; b:' '; c:'  '; data:'311141' ),     // FNC4, CODE A
  ( a:' '; b:' '; c:'  '; data:'411131' ),     // FNC1
  ( a:' '; b:' '; c:'  '; data:'211412' ),     // START A
  ( a:' '; b:' '; c:'  '; data:'211214' ),     // START B
  ( a:' '; b:' '; c:'  '; data:'211232' )      // START C
  );

function IsDigit(c: AnsiChar): Boolean;
begin
  Result := (c >= '0') and (c <= '9');
end;

function IsFourOrMoreDigits(const code: AnsiString; index: Integer; var numDigits: Integer): Boolean;
begin
  numDigits := 0;
  if IsDigit(code[index]) and (index + 4 <= Length(code)) then
  begin
    while (index + numDigits <= Length(code)) and IsDigit(code[index + numDigits]) do
      Inc(numDigits);
  end;

  Result := numDigits >= 4;
end;

function FindCodeA(c: AnsiChar): Integer;
var
  i: Integer;
begin
  for i := 0 to Length(tabelle_128) - 1 do
  begin
    if c = tabelle_128[i].a then
    begin
      Result := i;
      Exit;
    end;
  end;

  Result := -1;
end;

function FindCodeB(c: AnsiChar): Integer;
var
  i: Integer;
begin
  for i := 0 to Length(tabelle_128) - 1 do
  begin
    if c = tabelle_128[i].b then
    begin
      Result := i;
      Exit;
    end;
  end;

  Result := -1;
end;

function FindCodeC(const c: AnsiString): Integer;
var
  i: Integer;
begin
  for i := 0 to Length(tabelle_128) - 1 do
  begin
    if c = tabelle_128[i].c then
    begin
      Result := i;
      Exit;
    end;
  end;

  Result := -1;
end;

function GetNextChar(const code: AnsiString; var index: Integer; var encoding: Code128Encoding): AnsiString;
var
  c: AnsiString;
begin
  Result := '';
  if index > Length(code) then
    Exit;

  // check special codes:
  // "&A;" means START A / CODE A
  // "&B;" means START B / CODE B
  // "&C;" means START C / CODE C
  // "&S;" means SHIFT
  // "&1;" means FNC1
  // "&2;" means FNC2
  // "&3;" means FNC3
  // "&4;" means FNC4

  if (code[index] = '&') and (index + 2 <= Length(code)) and (code[index + 2] = ';') then
  begin
    c := AnsiString(AnsiUpperCase(String(code[index + 1])));
    if (c = 'A') or (c = 'B') or (c = 'C') or (c = 'S') or (c = '1') or (c = '2') or (c = '3') or (c = '4') then
    begin
      Inc(index, 3);
      Result := '&' + c + ';';
      Exit;
    end;
  end;

  // if encoding is C, get next two chars
  if (encoding = encC) and (index + 1 <= Length(code)) then
  begin
    Result := Copy(code, index, 2);
    Inc(index, 2);
    Exit;
  end;

  Result := Copy(code, index, 1);
  Inc(index);
end;

// Returns a group of characters with the same encoding. Updates encoding and index parameters.
function GetNextPortion(const code: AnsiString; var index: Integer; var encoding: Code128Encoding): AnsiString;
var
  aIndex, bIndex, numDigits, numChars: Integer;
  firstCharEncoding, nextCharEncoding: Code128Encoding;
  prefix, c: AnsiString;
begin
  Result := '';
  if index > Length(code) then
    Exit;

  // determine the first character encoding

  c := '';
  if (code[index] = '&') and (index + 2 <= Length(code)) and (code[index + 2] = ';') then
  begin
    c := AnsiString(AnsiUpperCase(String(code[index + 1])));
    if (c = 'A') or (c = 'B') or (c = 'C') or (c = 'S') or (c = '1') or (c = '2') or (c = '3') or (c = '4') then
    begin
      c := Copy(code, index, 3);
      Inc(index, 3);
    end
    else
      c := '';
  end;

  aIndex := FindCodeA(code[index]);
  bIndex := FindCodeB(code[index]);
  firstCharEncoding := encA;
  if (aIndex = -1) and (bIndex <> -1) then
    firstCharEncoding := encB
  else if (aIndex <> -1) and (bIndex <> -1) then
    firstCharEncoding := encAorB;
  // if we have four or more digits in the current position, use C encoding.
  numDigits := 0;
  if IsFourOrMoreDigits(code, index, numDigits) then
    firstCharEncoding := encC;

  // if encoding = C, we have found the group, just return it.
  if firstCharEncoding = encC then
  begin
    // we need digit pairs, so round it to even value
    numDigits := (numDigits div 2) * 2;
    Result := Copy(code, index, numDigits);
    Inc(index, numDigits);
    if encoding <> encC then
      Result := '&C;' + c + Result //only switch to C if not already on it
    else
      Result := c + Result;
    encoding := encC;
    Exit;
  end;

  // search for next characters with the same encoding. Calculate numChars with the same encoding.
  numChars := 1;
  while index + numChars <= Length(code) do
  begin
    // same as above...
    aIndex := FindCodeA(code[index + numChars]);
    bIndex := FindCodeB(code[index + numChars]);
    nextCharEncoding := encA;
    if (aIndex = -1) and (bIndex <> -1) then
      nextCharEncoding := encB
    else if (aIndex <> -1) and (bIndex <> -1) then
      nextCharEncoding := encAorB;
    if IsFourOrMoreDigits(code, index + numChars, numDigits) then
      nextCharEncoding := encC;

    // switch to particular encoding from AorB
    if (nextCharEncoding <> encC) and (nextCharEncoding <> firstCharEncoding) then
    begin
      if firstCharEncoding = encAorB then
        firstCharEncoding := nextCharEncoding
      else if nextCharEncoding = encAorB then
        nextCharEncoding := firstCharEncoding;
    end;

    if firstCharEncoding <> nextCharEncoding then
      break;
    Inc(numChars);
  end;

  // give precedence to B encoding
  if firstCharEncoding = encAorB then
    firstCharEncoding := encB;

  if firstCharEncoding = encA then
    prefix := '&A;'
  else
    prefix := '&B;';
  // if we have only one character, use SHIFT code to switch encoding. Do not change current encoding.
  if (encoding <> firstCharEncoding) and
    (numChars = 1) and
    ((encoding = encA) or (encoding = encB)) and
    ((firstCharEncoding = encA) or (firstCharEncoding = encB)) then
    prefix := '&S;'
  else
    encoding := firstCharEncoding;

  Result := prefix + c + Copy(code, index, numChars);
  Inc(index, numChars);
end;

function StripControlCodes(const code: AnsiString; stripFNCodes: Boolean): AnsiString;
var
  index: Integer;
  nextChar: AnsiString;
  encoding: Code128Encoding;
begin
  Result := '';
  index := 1;
  encoding := encNone;

  while index <= Length(code) do
  begin
    nextChar := GetNextChar(code, index, encoding);
    if (nextChar <> '&A;') and (nextChar <> '&B;') and (nextChar <> '&C;') and (nextChar <> '&S;') then
    begin
      if (not stripFNCodes) or ((nextChar <> '&1;') and (nextChar <> '&2;') and (nextChar <> '&3;') and (nextChar <> '&4;')) then
        Result := Result + nextChar;
    end;
  end;
end;

function Encode(code: AnsiString): AnsiString;
var
  index: Integer;
  encoding: Code128Encoding;
begin
  code := StripControlCodes(code, False);
  Result := '';
  index := 1;
  encoding := encNone;

  while index <= Length(code) do
  begin
    Result := Result + GetNextPortion(code, index, encoding);
  end;
end;

function ParseGS1(code: AnsiString): AnsiString;
var
  i: Integer;
  s: AnsiString;

  { simple GS1 rules implementation }
  function GetCode(const Code: AnsiString; var Index: Integer): AnsiString;
  var
    i, j, FoundAI, MaxLen, CodeLen: Integer;
  begin
    Result := '';
    { error in syntax }
    if code[Index] <> '(' then Exit;
    CodeLen := Length(code) - Index;
    if CodeLen < 3 then Exit;
    for i := 0 to AICodesCount - 1 do
    begin
      FoundAI := -1;
      MaxLen := Length(AICodesData[i].AI);
      if MaxLen > CodeLen then continue;
      for j := 1 to MaxLen do
      begin
        FoundAI := i;
        if (AICodesData[i].AI[j] <> code[Index + j]) and (AICodesData[i].AI[j] <> 'X') then
        begin
          FoundAI := -1;
          break;
        end;
      end;
      if FoundAI <> -1 then break;
    end;
    { no AI was found }
    if FoundAI = -1 then Exit;
    Inc(Index, Length(AICodesData[FoundAI].AI) + 1);
    { error in syntax }
    if (code[Index] <> ')') then Exit;
    CodeLen := Length(code) - Index;
    Inc(Index);
    if not AICodesData[FoundAI].FNC1 and (CodeLen >= AICodesData[FoundAI].DataMaxSize) then
    begin
      Result := Copy(code, Index - AICodesData[FoundAI].AISize - 1, AICodesData[FoundAI].AISize) +
        {AICodesData[FoundAI].AI +} Copy(code, Index, AICodesData[FoundAI].DataMaxSize);
      Inc(Index, AICodesData[FoundAI].DataMaxSize);
    end
    else if AICodesData[FoundAI].FNC1 then
    begin
      MaxLen := PosEx('(', String(code), Index) - Index;
      if MaxLen < 0 then MaxLen := CodeLen;
      if (MaxLen >= AICodesData[FoundAI].DataMinSize) and (MaxLen <= AICodesData[FoundAI].DataMaxSize) then
      begin
        Result := Copy(code, Index - AICodesData[FoundAI].AISize - 1, AICodesData[FoundAI].AISize) +
          {AICodesData[FoundAI].AI +} Copy(code, Index, MaxLen);
        if MaxLen < CodeLen then
          Result := Result + '&1;';
        Inc(Index, MaxLen);
      end;
    end;
  end;

begin
  Result := '';
  if Length(code) < 3 then Exit;
  s := '';
  i := 1;
  Result := '&1;';
  while i < Length(code) do
  begin
    s := GetCode(code, i);
    if s <> '' then
      Result := Result + s
    else
    begin
      Result := '';
      Exit;
    end;
  end;
end;

function TfrxBarcode.Code_128:AnsiString;
var
  code, nextChar, startCode, checkSumCode: AnsiString;
  encoding: Code128Encoding;
  index, checksum, codeword_pos, idx: Integer;
begin
  code := FText;
  // compatibility
  code := AnsiString(StringReplace(String(code), '&FNC1;', '&1;', [rfReplaceAll]));

  case FTyp of
    bcCode128A, bcCodeEAN128A:
      code := '&A;' + code;
    bcCode128B, bcCodeEAN128B:
      code := '&B;' + code;
    bcCode128C, bcCodeEAN128C:
    begin
      code := AnsiString(StringReplace(String(code), '(', '&1;', [rfReplaceAll]));
      code := AnsiString(StringReplace(String(code), ')', '', [rfReplaceAll]));
      code := '&C;' + code;
    end;
    bcGS1Code128:
    begin
      code := Encode(ParseGS1(code));
    end
    else
      code := Encode(code);
  end;

  case FTyp of
    bcCodeEAN128,
    bcCodeEAN128A,
    bcCodeEAN128B,
    bcCodeEAN128C:
    begin
      {
      special identifier
      FNC1 = function code 1
      for EAN 128 barcodes
      }
      if Copy(code, 4, 3) <> '&1;' then
        Insert('&1;', code, 4);
      {
      if there is no checksum at the end of the string
      the EAN128 needs one (modulo 10)
      }
      if FCheckSum then
      begin
        CheckSumCode := DoCheckSumming(StripControlCodes(code, True));
        code := code + CheckSumCode[Length(CheckSumCode)];
      end;
    end;
  end;

  // get first char to determine encoding
  encoding := encNone;
  index := 1;
  nextChar := GetNextChar(code, index, encoding);
  startCode := '';

  // setup encoding
  if nextChar = '&A;' then
  begin
    encoding := encA;
    checksum := 103;
    startCode := tabelle_128[103].data;
  end
  else if nextChar = '&B;' then
  begin
    encoding := encB;
    checksum := 104;
    startCode := tabelle_128[104].data;
  end
  else if nextChar = '&C;' then
  begin
    encoding := encC;
    checksum := 105;
    startCode := tabelle_128[105].data;
  end
  else
    raise Exception.Create('Invalid Barcode');

  Result := startCode;    // Startcode
  codeword_pos := 1;

  while index <= Length(code) do
  begin
    nextChar := GetNextChar(code, index, encoding);

    if nextChar = '&A;' then
    begin
      encoding := encA;
      idx := 101;
    end
    else if nextChar = '&B;' then
    begin
      encoding := encB;
      idx := 100;
    end
    else if nextChar = '&C;' then
    begin
      encoding := encC;
      idx := 99;
    end
    else if nextChar = '&S;' then
    begin
      if encoding = encA then
        encoding := encB
      else
        encoding := encA;
      idx := 98;
    end
    else if nextChar = '&1;' then
      idx := 102
    else if nextChar = '&2;' then
      idx := 97
    else if nextChar = '&3;' then
      idx := 96
    else if nextChar = '&4;' then
    begin
      if encoding = encA then
        idx := 101
      else
        idx := 100;
    end
    else
    begin
      if encoding = encA then
        idx := FindCodeA(nextChar[1])
      else if encoding = encB then
        idx := FindCodeB(nextChar[1])
      else
        idx := FindCodeC(nextChar);
    end;

    if idx < 0 then
      raise Exception.Create('Invalid Barcode');

    Result := Result + tabelle_128[idx].data;
    Inc(checksum, idx * codeword_pos);
    Inc(codeword_pos);

    // switch encoding back after the SHIFT
    if nextChar = '&S;' then
    begin
      if encoding = encA then
        encoding := encB
      else
        encoding := encA;
    end;
  end;

  checksum := checksum mod 103;
  Result := Result + tabelle_128[checksum].data;

  // stop code
  Result := Result + '2331112';
  Result := Convert(Result);
end;


type TCode93 =
  record
    c : AnsiChar;
    data : array[0..5] of AnsiChar;
  end;

const tabelle_93: array[0..46] of TCode93 = (
  ( c:'0'; data:'131112'  ),
  ( c:'1'; data:'111213'  ),
  ( c:'2'; data:'111312'  ),
  ( c:'3'; data:'111411'  ),
  ( c:'4'; data:'121113'  ),
  ( c:'5'; data:'121212'  ),
  ( c:'6'; data:'121311'  ),
  ( c:'7'; data:'111114'  ),
  ( c:'8'; data:'131211'  ),
  ( c:'9'; data:'141111'  ),
  ( c:'A'; data:'211113'  ),
  ( c:'B'; data:'211212'  ),
  ( c:'C'; data:'211311'  ),
  ( c:'D'; data:'221112'  ),
  ( c:'E'; data:'221211'  ),
  ( c:'F'; data:'231111'  ),
  ( c:'G'; data:'112113'  ),
  ( c:'H'; data:'112212'  ),
  ( c:'I'; data:'112311'  ),
  ( c:'J'; data:'122112'  ),
  ( c:'K'; data:'132111'  ),
  ( c:'L'; data:'111123'  ),
  ( c:'M'; data:'111222'  ),
  ( c:'N'; data:'111321'  ),
  ( c:'O'; data:'121122'  ),
  ( c:'P'; data:'131121'  ),
  ( c:'Q'; data:'212112'  ),
  ( c:'R'; data:'212211'  ),
  ( c:'S'; data:'211122'  ),
  ( c:'T'; data:'211221'  ),
  ( c:'U'; data:'221121'  ),
  ( c:'V'; data:'222111'  ),
  ( c:'W'; data:'112122'  ),
  ( c:'X'; data:'112221'  ),
  ( c:'Y'; data:'122121'  ),
  ( c:'Z'; data:'123111'  ),
  ( c:'-'; data:'121131'  ),
  ( c:'.'; data:'311112'  ),
  ( c:' '; data:'311211'  ),
  ( c:'$'; data:'321111'  ),
  ( c:'/'; data:'112131'  ),
  ( c:'+'; data:'113121'  ),
  ( c:'%'; data:'211131'  ),
  ( c:'['; data:'121221'  ),   {only used for Extended Code 93}
  ( c:']'; data:'312111'  ),   {only used for Extended Code 93}
  ( c:'{'; data:'311121'  ),   {only used for Extended Code 93}
  ( c:'}'; data:'122211'  )    {only used for Extended Code 93}
  );

function TfrxBarcode.Code_93:AnsiString;

{find Code 93}
function Find_Code93(c: AnsiChar):integer;
var
  i:integer;
begin
  for i:=0 to High(tabelle_93) do
  begin
    if c = tabelle_93[i].c then
    begin
      result := i;
      exit;
    end;
  end;
  result := -1;
end;

var
  i, idx : integer;
  checkC, checkK,   {Checksums}
  weightC, weightK : integer;
begin

  result := '111141';   {Startcode}

  for i:=1 to Length(FText) do
  begin
    idx := Find_Code93(AnsiChar(FText[i]));
    if idx < 0 then
      raise Exception.CreateFmt('%s:Code93 bad Data <%s>', [self.ClassName,FText]);
    result := result + tabelle_93[idx].data;
  end;

  checkC := 0;
  checkK := 0;

  weightC := 1;
  weightK := 2;

  for i:=Length(FText) downto 1 do
  begin
    idx := Find_Code93(AnsiChar(FText[i]));

    Inc(checkC, idx*weightC);
    Inc(checkK, idx*weightK);

    Inc(weightC);
    if weightC > 20 then weightC := 1;
    Inc(weightK);
    if weightK > 15 then weightK := 1;
  end;

  Inc(checkK, checkC);

  checkC := checkC mod 47;
  checkK := checkK mod 47;

  result := result + tabelle_93[checkC].data +
    tabelle_93[checkK].data;

  result := result + '1111411';   {Stopcode}
  Result := Convert(Result);
end;





const code93x : array[0..127] of AnsiString =
  (
  (']U'), ('[A'), ('[B'), ('[C'), ('[D'), ('[E'), ('[F'), ('[G'),
  ('[H'), ('[I'), ('[J'), ('[K'), ('[L'), ('[M'), ('[N'), ('[O'),
  ('[P'), ('[Q'), ('[R'), ('[S'), ('[T'), ('[U'), ('[V'), ('[W'),
  ('[X'), ('[Y'), ('[Z'), (']A'), (']B'), (']C'), (']D'), (']E'),
   (' '), ('{A'), ('{B'), ('{C'), ('{D'), ('{E'), ('{F'), ('{G'),
  ('{H'), ('{I'), ('{J'), ('{K'), ('{L'), ('{M'), ('{N'), ('{O'),
  ( '0'),  ('1'),  ('2'),  ('3'),  ('4'),  ('5'),  ('6'),  ('7'),
   ('8'),  ('9'), ('{Z'), (']F'), (']G'), (']H'), (']I'), (']J'),
  (']V'),  ('A'),  ('B'),  ('C'),  ('D'),  ('E'),  ('F'),  ('G'),
   ('H'),  ('I'),  ('J'),  ('K'),  ('L'),  ('M'),  ('N'),  ('O'),
   ('P'),  ('Q'),  ('R'),  ('S'),  ('T'),  ('U'),  ('V'),  ('W'),
   ('X'),  ('Y'),  ('Z'), (']K'), (']L'), (']M'), (']N'), (']O'),
  (']W'), ('}A'), ('}B'), ('}C'), ('}D'), ('}E'), ('}F'), ('}G'),
  ('}H'), ('}I'), ('}J'), ('}K'), ('}L'), ('}M'), ('}N'), ('}O'),
  ('}P'), ('}Q'), ('}R'), ('}S'), ('}T'), ('}U'), ('}V'), ('}W'),
  ('}X'), ('}Y'), ('}Z'), (']P'), (']Q'), (']R'), (']S'), (']T')
  );

function TfrxBarcode.Code_93Extended:AnsiString;
var
  save : AnsiString;
  i : integer;
begin
 {CharToOem(PChar(FText), save);}

  save := FText;
  FText := '';


  for i:=1 to Length(save) do
  begin
    if ord(save[i]) <= 127 then
      FText := FText + code93x[ord(save[i])];
  end;

  {Showmessage(Format('Text: <%s>', [FText]));}

  result := Code_93;
  FText := save;
end;



const tabelle_MSI:array['0'..'9'] of AnsiString =
  (
  ( '51515151' ),    {'0'}
  ( '51515160' ),    {'1'}
  ( '51516051' ),    {'2'}
  ( '51516060' ),    {'3'}
  ( '51605151' ),    {'4'}
  ( '51605160' ),    {'5'}
  ( '51606051' ),    {'6'}
  ( '51606060' ),    {'7'}
  ( '60515151' ),    {'8'}
  ( '60515160' )     {'9'}
  );

function TfrxBarcode.Code_MSI:AnsiString;
var
  i:integer;
  check_even, check_odd, checksum:integer;
begin
  result := '60';    {Startcode}
  check_even := 0;
  check_odd  := 0;

  for i:=1 to Length(FText) do
  begin
    if odd(i-1) then
      check_odd := check_odd*10 + ord(FText[i]) - ord('0')
    else
      check_even := check_even + ord(FText[i]) - ord('0');

    result := result + tabelle_MSI[FText[i]];
  end;

  checksum := quersumme(check_odd*2) + check_even;

  checksum := checksum mod 10;
  if checksum > 0 then
    checksum := 10-checksum;

  if FCheckSum then
    result := result + tabelle_MSI[chr(ord('0')+checksum)];

  result := result + '515'; {Stopcode}
end;



const tabelle_PostNet:array['0'..'9'] of AnsiString =
  (
  ( '5151A1A1A1' ),    {'0'}
  ( 'A1A1A15151' ),    {'1'}
  ( 'A1A151A151' ),    {'2'}
  ( 'A1A15151A1' ),    {'3'}
  ( 'A151A1A151' ),    {'4'}
  ( 'A151A151A1' ),    {'5'}
  ( 'A15151A1A1' ),    {'6'}
  ( '51A1A1A151' ),    {'7'}
  ( '51A1A151A1' ),    {'8'}
  ( '51A151A1A1' )     {'9'}
  );

function TfrxBarcode.Code_PostNet:AnsiString;
var
  i:integer;
begin
  result := '51';

  for i:=1 to Length(FText) do
  begin
    result := result + tabelle_PostNet[FText[i]];
  end;
  result := result + '5';
end;


type TCodabar =
  record
    c : AnsiChar;
    data : array[0..6] of AnsiChar;
  end;

const tabelle_cb: array[0..19] of TCodabar = (
  ( c:'1'; data:'5050615'  ),
  ( c:'2'; data:'5051506'  ),
  ( c:'3'; data:'6150505'  ),
  ( c:'4'; data:'5060515'  ),
  ( c:'5'; data:'6050515'  ),
  ( c:'6'; data:'5150506'  ),
  ( c:'7'; data:'5150605'  ),
  ( c:'8'; data:'5160505'  ),
  ( c:'9'; data:'6051505'  ),
  ( c:'0'; data:'5050516'  ),
  ( c:'-'; data:'5051605'  ),
  ( c:'$'; data:'5061505'  ),
  ( c:':'; data:'6050606'  ),
  ( c:'/'; data:'6060506'  ),
  ( c:'.'; data:'6060605'  ),
  ( c:'+'; data:'5060606'  ),
  ( c:'A'; data:'5061515'  ),
  ( c:'B'; data:'5151506'  ),
  ( c:'C'; data:'5051516'  ),
  ( c:'D'; data:'5051615'  )
  );

function TfrxBarcode.Code_Codabar:AnsiString;

{find Codabar}
function Find_Codabar(c: AnsiChar):integer;
var
  i:integer;
begin
  for i:=0 to High(tabelle_cb) do
  begin
    if c = tabelle_cb[i].c then
    begin
      result := i;
      exit;
    end;
  end;
  result := -1;
end;

var
  i, idx : integer;
  StartCode, StopCode: AnsiChar;
  Text: AnsiString;
begin
  StartCode := AnsiChar('A');
  StopCode := AnsiChar('B');
  Text := FText;
  if (Text[1] = AnsiChar('&')) and (AnsiChar(Text[3]) = AnsiChar(';')) then
    begin
      {$IFDEF Delphi12}
      if CharInSet(Text[2], [AnsiChar('A'), AnsiChar('B'), AnsiChar('C'), AnsiChar('D')]) then
      {$ELSE}
      if Text[2] in [AnsiChar('A'), AnsiChar('B'), AnsiChar('C'), AnsiChar('D')] then
      {$ENDIF}
        StartCode := Text[2];
      Delete(Text, 1, 3);
    end;
  i := Length(Text) - 2;
  if (Text[i] = AnsiChar('&')) and (AnsiChar(Text[i + 2]) = AnsiChar(';')) then
    begin
      {$IFDEF Delphi12}
      if CharInSet(Text[i + 1], [AnsiChar('A'), AnsiChar('B'), AnsiChar('C'), AnsiChar('D')]) then
      {$ELSE}
      if Text[i + 1] in [AnsiChar('A'), AnsiChar('B'), AnsiChar('C'), AnsiChar('D')] then
      {$ENDIF}
        StopCode := Text[i + 1];
      Delete(Text, i, 3);
    end;
  result := tabelle_cb[Find_Codabar(StartCode)].data + '0';
  for i:=1 to Length(Text) do
  begin
    idx := Find_Codabar(AnsiChar(Text[i]));
    result := result + tabelle_cb[idx].data + '0';
  end;
  result := result + tabelle_cb[Find_Codabar(StopCode)].data;
end;



{---------------}

{Assist function}
function TfrxBarcode.SetLen(pI:byte):AnsiString;
begin
  Result := StringOfChar(AnsiChar('0'), pI - Length(FText)) + FText;
end;



procedure TfrxBarcode.SetTyp(const Value: TfrxBarcodeType);
begin
  FTyp := Value;
  if Typ = bcCodeUSPSIntelligentMail then
    Modul := 3
  else
    Modul := 1;
end;

function TfrxBarcode.Code_UPC_A:AnsiString;
var
  i : integer;
  tmp : AnsiString;
begin
  FText := SetLen(12);
  if FCheckSum then tmp:=DoCheckSumming(copy(FText,1,11));
  if FCheckSum then FText:=tmp else tmp:=FText;
  result := '505';   {Startcode}
  for i:=1 to 6 do
    result := result + tabelle_EAN_A[tmp[i]];
  result := result + '05050';   {Trennzeichen}
  for i:=7 to 12 do
    result := result + tabelle_EAN_C[tmp[i]];
  result := result + '505';   {Stopcode}
end;


{UPC E Parity Pattern Table , Number System 0}
const tabelle_UPC_E0:array['0'..'9', 1..6] of AnsiChar =
  (
  ('E', 'E', 'E', 'o', 'o', 'o' ),    { 0 }
  ('E', 'E', 'o', 'E', 'o', 'o' ),    { 1 }
  ('E', 'E', 'o', 'o', 'E', 'o' ),    { 2 }
  ('E', 'E', 'o', 'o', 'o', 'E' ),    { 3 }
  ('E', 'o', 'E', 'E', 'o', 'o' ),    { 4 }
  ('E', 'o', 'o', 'E', 'E', 'o' ),    { 5 }
  ('E', 'o', 'o', 'o', 'E', 'E' ),    { 6 }
  ('E', 'o', 'E', 'o', 'E', 'o' ),    { 7 }
  ('E', 'o', 'E', 'o', 'o', 'E' ),    { 8 }
  ('E', 'o', 'o', 'E', 'o', 'E' )     { 9 }
  );

function TfrxBarcode.Code_UPC_E0:AnsiString;
var i,j : integer;
   tmp : AnsiString;
   c   : AnsiChar;
begin
  FText := SetLen(7);
  tmp:=DoCheckSumming(copy(FText,1,6));
  c:=tmp[7];
  if FCheckSum then FText:=tmp else tmp := FText;
  result := '505';   {Startcode}
  for i:=1 to 6 do
  begin
    if tabelle_UPC_E0[c,i]='E' then
    begin
      for j:= 1 to 4 do result := result + tabelle_EAN_C[tmp[i],5-j];
    end
    else
    begin
      result := result + tabelle_EAN_A[tmp[i]];
    end;
  end;
  result := result + '050505';   {Stopcode}
end;

function TfrxBarcode.Code_UPC_E1:AnsiString;
var i,j : integer;
   tmp : AnsiString;
   c   : AnsiChar;
begin
  FText := SetLen(7);
  tmp:=DoCheckSumming(copy(FText,1,6));
  c:=tmp[7];
  if FCheckSum then FText:=tmp else tmp := FText;
  result := '505';   {Startcode}
  for i:=1 to 6 do
  begin
    if tabelle_UPC_E0[c,i]='E' then
    begin
      result := result + tabelle_EAN_A[tmp[i]];
    end
    else
    begin
      for j:= 1 to 4 do result := result + tabelle_EAN_C[tmp[i],5-j];
    end;
  end;
  result := result + '050505';   {Stopcode}
end;

{ USPS Intelligent Mail }
function TfrxBarcode.Code_USPSIntelligentMail: AnsiString;
var
  i: Integer;
  OneCodeBars: AnsiString;
begin
  with TOneCode.Create do
    try
      OneCodeBars := Bars(FText);
    finally
      Free;
    end;
  Result := '0';
//  Track, Descend, Ascend, Full bar => F, H, G, 5
  for i := 1 to Length(OneCodeBars) do
    case OneCodeBars[i] of
      'T': Result := Result + 'F0';
      'D': Result := Result + 'H0';
      'A': Result := Result + 'G0';
      'F': Result := Result + '50';
    end;
end;

{assist function}
function getSupp(Nr : AnsiString) : AnsiString;
var i,fak,sum : Integer;
      tmp   : AnsiString;
begin
  sum := 0;
  tmp := copy(nr,1,Length(Nr)-1);
  fak := Length(tmp);
  for i:=1 to length(tmp) do
  begin
    if (fak mod 2) = 0 then
      sum := sum + (StrToInt(String(tmp[i]))*9)
    else
      sum := sum + (StrToInt(String(tmp[i]))*3);
    dec(fak);
  end;
  sum:=((sum mod 10) mod 10) mod 10;
  result := tmp + AnsiString(IntToStr(sum));
end;

function TfrxBarcode.Code_Supp5:AnsiString;
var i,j : integer;
   tmp : AnsiString;
   c   : AnsiChar;
begin
  FText := SetLen(5);
  tmp:=getSupp(copy(FText,1,5)+'0');
  c:=tmp[6];
  if FCheckSum then FText:=tmp else tmp := FText;
  result := '506';   {Startcode}
  for i:=1 to 5 do
  begin
    if tabelle_UPC_E0[c,(6-5)+i]='E' then
    begin
      for j:= 1 to 4 do result := result + tabelle_EAN_C[tmp[i],5-j];
    end
    else
    begin
      result := result + tabelle_EAN_A[tmp[i]];
    end;
    if i<5 then result:=result+'05'; { character delineator }
  end;
end;

function TfrxBarcode.Code_Supp2:AnsiString;
var i,j : integer;
   tmp,mS : AnsiString;
begin
  FText := SetLen(2);
  i := StrToInt(String(Ftext));
  case i mod 4 of
    3: mS:='EE';
    2: mS:='Eo';
    1: mS:='oE';
    0: mS:='oo';
  end;
  tmp:=getSupp(copy(FText,1,5)+'0');

  if FCheckSum then FText:=tmp else tmp := FText;
  result := '506';   {Startcode}
  for i:=1 to 2 do
  begin
    if mS[i]='E' then
    begin
      for j:= 1 to 4 do result := result + tabelle_EAN_C[tmp[i],5-j];
    end
    else
    begin
      result := result + tabelle_EAN_A[tmp[i]];
    end;
    if i<2 then result:=result+'05'; { character delineator }
  end;
end;

{---------------}




procedure TfrxBarcode.MakeModules;
begin
  case Typ of
    bcCode_2_5_interleaved,
    bcCode_2_5_industrial,
    bcCode39,
    bcCodeEAN8,
    bcCodeEAN13,
    bcCode39Extended,
    bcCodeCodabar,
    bcCodeUPC_A,
    bcCodeUPC_E0,
    bcCodeUPC_E1,
    bcCodeUPC_Supp2,
    bcCodeUPC_Supp5:

    begin
      if Ratio < 2.0 then Ratio := 2.0;
      if Ratio > 3.0 then Ratio := 3.0;
    end;

    bcCode_2_5_matrix:
    begin
      if Ratio < 2.25 then Ratio := 2.25;
      if Ratio > 3.0 then Ratio := 3.0;
    end;
    bcCode128A,
    bcCode128B,
    bcCode128C,
    bcCode93,
    bcCode93Extended,
    bcCodeMSI,
    bcCodePostNet,
    bcCodeUSPSIntelligentMail: ;
  end;


  modules[0] := FModul;
  modules[1] := Round(FModul*FRatio);
  modules[2] := modules[1] * 3 div 2;
  modules[3] := modules[1] * 2;
end;


{
Draw the Barcode

Parameter :
'data' holds the pattern for a Barcode.
A barcode begins always with a black line and
ends with a black line.

The white Lines builds the space between the black Lines.

A black line must always followed by a white Line and vica versa.

Examples:
  '50505'   // 3 thin black Lines with 2 thin white Lines
  '606'     // 2 fat black Lines with 1 thin white Line

  '5605015' // Error


data[] : see procedure OneBarProps

}
procedure TfrxBarcode.DoLines(data:AnsiString; Canvas:TCanvas);

var i:integer;
  lt : TfrxBarLineType;
  xadd:integer;
  awidth, aheight:integer;
  a,b,c,d,     {Edges of a line (we need 4 Point because the line}
          {is a recangle}
  orgin : TPoint;
  alpha:double;
begin
  xadd := 0;
  orgin.x := FLeft;
  orgin.y := FTop;

  alpha := FAngle/180.0*pi;

  { Move the orgin so the entire barcode ends up in the visible region. }
  orgin := TranslateQuad2D(alpha,orgin,Point(Self.Width,Self.Height));

  with Canvas do begin
    Pen.Width := 1;

   for i:=1 to Length(data) do  {examine the pattern string}
    begin

      {
      input:  pattern code
      output: Width and Linetype
      }
      OneBarProps(data[i], awidth, lt);

      if lt <> white then
      begin
        Pen.Color := FColorBar;
      end
      else
      begin
        Pen.Color := FColor;
      end;
      Brush.Color := Pen.Color;

      if lt = black_half then
        aheight := FHeight * 2 div 5
      else if lt = black_track then
        aheight := Round(FHeight / 3)
      else if lt in [black_ascend, black_descend] then
        aheight := Round(FHeight * 2 / 3)
      else
        aheight := FHeight;

      a.x := xadd;
      a.y := 0;

      b.x := xadd;
      b.y := aheight;

    {c.x := xadd+width;}
    c.x := xadd+aWidth-1;  {23.04.1999 Line was 1 Pixel too wide}
      c.y := aheight;

    {d.x := xadd+width;}
    d.x := xadd+aWidth-1;  {23.04.1999 Line was 1 Pixel too wide}
      d.y := 0;

    {a,b,c,d builds the rectangle we want to draw}

     {PostNet and USPS Intelligent Mail bug}
      case lt of
        black_track:
          begin
            a.Y := FHeight - aheight - a.Y;
            b.Y := FHeight - aheight - b.Y;
            c.Y := FHeight - aheight - c.Y;
            d.Y := FHeight - aheight - d.Y;
          end;
        black_half, black_descend:
          begin
            a.Y := FHeight - a.Y;
            b.Y := FHeight - b.Y;
            c.Y := FHeight - c.Y;
            d.Y := FHeight - d.Y;
          end;
      end;

     {rotate the rectangle}
     a := Translate2D(Rotate2D(a, alpha), orgin);
     b := Translate2D(Rotate2D(b, alpha), orgin);
     c := Translate2D(Rotate2D(c, alpha), orgin);
     d := Translate2D(Rotate2D(d, alpha), orgin);

    {draw the rectangle}
      Polygon([a,b,c,d]);

      xadd := xadd + awidth;
    end;
  end;
end;

procedure TfrxBarcode.DrawBarcode(Canvas: TCanvas; ARect: TRect; ShowText: Boolean; aScaleDPIX, aScaleDPIY: Extended; DirectToEMF: Boolean);
var
  data : AnsiString;
  w, h, BarWidth, TxtHeight: Integer;
  EMF: TMetafile;
  EMFCanvas: TMetafileCanvas;
  Zoom: Extended;

  function CreateRotatedFont(Font: TFont; Angle: Integer): HFont;
  var
    F: TLogFont;
  begin
    GetObject(Font.Handle, SizeOf(TLogFont), @F);
    F.lfEscapement := Angle * 10;
    F.lfOrientation := Angle * 10;
    Result := CreateFontIndirect(F);
  end;

  procedure TextOutR(x, x1, x2: Integer; s: AnsiString);
  begin
    with EMFCanvas do
      case Round(FAngle) of
        90:
          begin
            FillRect(Rect(w - TxtHeight, h - x1, w, h - x2 - 1));
            TextOut(w - TxtHeight, h - x, String(s));
          end;
        180:
          begin
            FillRect(Rect(w - x1, 0, w - x2 - 1, TxtHeight + 2));
            TextOut(w - x, TxtHeight, String(s));
          end;
        270:
          begin
            FillRect(Rect(0, x1, TxtHeight, x2 + 1));
            TextOut(TxtHeight, x, String(s));
          end;
        else
          begin
            FillRect(Rect(x1, h - TxtHeight - 2, x2 + 1, h));
            TextOut(x, h - TxtHeight, String(s));
          end;
      end;
  end;

  procedure OutText;
  var
    TxtWidth: Integer;
    FontHandle, OldFontHandle: HFont;
    s: AnsiString;
  begin
    with EMFCanvas do
    begin
      {Font.Name := 'Arial';
      Font.Size := 9; }
      Font.PixelsPerInch := 96;
      Font.Assign(FFont);
      FontHandle := CreateRotatedFont(Font, Round(FAngle));
      OldFontHandle := SelectObject(Handle, FontHandle);
      Brush.Color := Color;
      SetBkMode(Handle, Transparent);

      case FTyp of
        bcCodeEAN8:            // 8 digits, 4+4
          if FCheckSum then
            begin
              TextOutR(3, 3, 30, Copy(DoCheckSumming(copy(FText,length(FText)-6,7)), 1, 4));
              TextOutR(35, 35, BarWidth - 4, Copy(DoCheckSumming(copy(FText,length(FText)-6,7)), 5, 4));
            end
          else
            begin
              TextOutR(3, 3, 30, Copy(FText, 1, 4));
              TextOutR(35, 35, BarWidth - 4, Copy(FText, 5, 4));
            end;
        bcCodeCodabar:
          begin
            s := FText;
            s := AnsiString(StringReplace(String(s), '&A;', '', [rfReplaceAll]));
            s := AnsiString(StringReplace(String(s), '&B;', '', [rfReplaceAll]));
            s := AnsiString(StringReplace(String(s), '&C;', '', [rfReplaceAll]));
            s := AnsiString(StringReplace(String(s), '&D;', '', [rfReplaceAll]));
            TxtWidth := TextWidth(String(s));
            TextOutR((BarWidth - TxtWidth) div 2, 0, BarWidth, s);
          end;
        bcCodeEAN13:           // 13 digits, 1+6+6 or 12 digits, 6+6
          begin
            //if FText[1] <> '0' then
              TextOutR(-8, -8, -2, Copy(FText, 1, 1));
            TextOutR(3, 3, 44, Copy(FText, 2, 6));
            TextOutR(49, 49, BarWidth - 4, Copy(FText, 8, 6));
          end;
        bcCodeUPC_A:           // 12 digits, 1+5+5+1
          begin
            TextOutR(-8, -8, -2, Copy(FText, 1, 1));
            TextOutR(10, 10, 44, Copy(FText, 2, 5));
            TextOutR(49, 49, 83, Copy(FText, 7, 5));
            TextOutR(BarWidth + 1, BarWidth + 1, BarWidth + 8, Copy(FText, 12, 1));
          end;
        bcCodeUPC_E0,
        bcCodeUPC_E1:          // 7 digits, 6+1
          begin
            TextOutR(3, 3, 44, Copy(FText, 1, 6));
            TextOutR(BarWidth + 1, BarWidth + 1, BarWidth + 8, Copy(FText, 7, 1));
          end;
        bcCodeEAN128,
        bcCodeEAN128A,
        bcCodeEAN128B,
        bcCodeEAN128C,
        bcCode128,
        bcCode128A,
        bcCode128B,
        bcCode128C,
        bcGS1Code128:
          begin
            s := StripControlCodes(FText, True);
            TxtWidth := TextWidth(String(s));
            TextOutR((BarWidth - TxtWidth) div 2, 0, BarWidth, s);
          end
        else
          begin
            TxtWidth := TextWidth(String(FText));
            TextOutR((BarWidth - TxtWidth) div 2, 0, BarWidth, FText);
          end;
      end;

      SelectObject(Handle, OldFontHandle);
      DeleteObject(FontHandle);
    end;
  end;

begin
  data := MakeData;
  if Canvas is TMetafileCanvas then
    data := '0' + data + '0';
  BarWidth := Width;

  FLeft := 0;
  FTop := 0;
  TxtHeight := -Font.Height + 2;
  if (FAngle = 0) or (FAngle = 180) then
  begin
    Zoom := (ARect.Right - ARect.Left) / BarWidth;
    w := BarWidth;
    h := ARect.Bottom - ARect.Top;
    h := Round(h / Zoom);
    FHeight := h;
    if ShowText then
      if FTyp in [bcCodeEAN8, bcCodeEAN13, bcCodeUPC_A, bcCodeUPC_E0, bcCodeUPC_E1] then
      begin
        FHeight := h - TxtHeight div 2;
        if FAngle = 180 then
          FTop := (TxtHeight + 2) div 2;
      end
      else
      begin
        FHeight := h - TxtHeight - 2;
        if FAngle = 180 then
          FTop := TxtHeight + 2;
      end;
  end
  else
  begin
    Zoom := (ARect.Bottom - ARect.Top) / BarWidth;
    w := ARect.Right - ARect.Left;
    h := BarWidth;
    w := Round(w / Zoom);
    FHeight := w;
    if ShowText then
      if FTyp in [bcCodeEAN8, bcCodeEAN13, bcCodeUPC_A, bcCodeUPC_E0, bcCodeUPC_E1] then
      begin
        FHeight := w - TxtHeight div 2;
        if FAngle = 270 then
          FLeft := (TxtHeight + 2) div 2;
      end
      else
      begin
        FHeight := w - TxtHeight - 2;
        if FAngle = 270 then
          FLeft := TxtHeight + 2;
      end;
  end;

  if Typ = bcCodeUSPSIntelligentMail then
    FHeight := 3 * (FHeight div 3);

  if DirectToEMF then
  begin
    DoLines(data, EMFCanvas);
    if ShowText then
      OutText;
    Exit;
  end;

  EMF := TMetafile.Create;
  EMF.Width := Round(w * aScaleDPIX + 0.5);
  EMF.Height := Round(h * aScaleDPIY + 0.5);

  try
    EMFCanvas := TMetafileCanvas.Create(EMF, 0);

    try
      DoLines(data, EMFCanvas);
      if ShowText then
        OutText;
    finally
      EMFCanvas.Free;
    end;

    Canvas.StretchDraw(ARect, EMF);
  finally
    EMF.Free;
  end;
end;


destructor TfrxBarcode.Destroy;
begin
  FFont.Free;
  inherited;
end;

end.