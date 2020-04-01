//
//
//
// Copyright 2007 by Paulo Soares.
//
// The contents of this file are subject to the Mozilla Public License Version 1.1
// (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
// for the specific language governing rights and limitations under the License.
//
// The Original Code is 'iText, a free JAVA-PDF library'.
//
// The Initial Developer of the Original Code is Bruno Lowagie. Portions created by
// the Initial Developer are Copyright (C) 1999, 2000, 2001, 2002 by Bruno Lowagie.
// All Rights Reserved.
// Co-Developer of the code is Paulo Soares. Portions created by the Co-Developer
// are Copyright (C) 2000, 2001, 2002 by Paulo Soares. All Rights Reserved.
// Modifications: Alexander Tzyganenko
//
//
//
//


unit frxBarcodeDataMatrix;


interface

{$I frx.inc}

uses
{$IFDEF FPC}
  LCLType, LMessages, LazHelper, LCLIntf,
{$ELSE}
  Windows, Messages,
{$ENDIF}
  SysUtils, Types, StrUtils, Classes, Graphics, Controls, Forms, Dialogs, frxBarcode2DBase, frxUnicodeUtils;

type


// Specifies the Datamatrix encoding. ///////////////////////////////////////////////////////////////////////

DatamatrixEncoding =
(
    Auto,
    Ascii,
    C40,
    Txt,
    Base256,
    X12,
    Edifact
);

// Specifies the Datamatrix symbol size. /////////////////////////////////////////////////////////////////////

DatamatrixSymbolSize =
(
    AutoSize,
    Size10x10,
    Size12x12,
    Size8x18,
    Size14x14,
    Size8x32,
    Size16x16,
    Size12x26,
    Size18x18,
    Size20x20,
    Size12x36,
    Size22x22,
    Size16x36,
    Size24x24,
    Size26x26,
    Size16x48,
    Size32x32,
    Size36x36,
    Size40x40,
    Size44x44,
    Size48x48,
    Size52x52,
    Size64x64,
    Size72x72,
    Size80x80,
    Size88x88,
    Size96x96,
    Size104x104,
    Size120x120,
    Size132x132,
    Size144x144
);

// ////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
// ////////////////////////////////////////////////////////////////////////////////////////////////////

DmParams = record

    height,
    width,
    heightSection,
    widthSection,
    dataSize,
    dataBlock,
    errorBlock : integer;

end;

const

    dmSizes : array[Size10x10..Size144x144] of DmParams =
    (
        ( height: 10; width: 10; heightSection: 10; widthSection: 10; dataSize: 3; dataBlock: 3; errorBlock: 5 ),
        ( height: 12; width: 12; heightSection: 12; widthSection: 12; dataSize: 5; dataBlock: 5; errorBlock: 7 ),
        ( height:  8; width: 18; heightSection:  8; widthSection: 18; dataSize: 5; dataBlock: 5; errorBlock: 7 ),
        ( height: 14; width: 14; heightSection: 14; widthSection: 14; dataSize: 8; dataBlock: 8; errorBlock:10 ),
        ( height:  8; width: 32; heightSection:  8; widthSection: 16; dataSize:10; dataBlock:10; errorBlock:11 ),
        ( height: 16; width: 16; heightSection: 16; widthSection: 16; dataSize:12; dataBlock:12; errorBlock:12 ),
        ( height: 12; width: 26; heightSection: 12; widthSection: 26; dataSize:16; dataBlock:16; errorBlock:14 ),
        ( height: 18; width: 18; heightSection: 18; widthSection: 18; dataSize:18; dataBlock:18; errorBlock:14 ),
        ( height: 20; width: 20; heightSection: 20; widthSection: 20; dataSize:22; dataBlock:22; errorBlock:18 ),
   ( height: 12; width: 36; heightSection: 12; widthSection: 18; dataSize:22; dataBlock:22; errorBlock:18 ),
   ( height: 22; width: 22; heightSection: 22; widthSection: 22; dataSize:30; dataBlock:30; errorBlock:20 ),
   ( height: 16; width: 36; heightSection: 16; widthSection: 18; dataSize:32; dataBlock:32; errorBlock:24 ),
   ( height: 24; width: 24; heightSection: 24; widthSection: 24; dataSize:36; dataBlock:36; errorBlock:24 ),
   ( height: 26; width: 26; heightSection: 26; widthSection: 26; dataSize:44; dataBlock:44; errorBlock:28 ),
   ( height: 16; width: 48; heightSection: 16; widthSection: 24; dataSize:49; dataBlock:49; errorBlock:28 ),
   ( height: 32; width: 32; heightSection: 16; widthSection: 16; dataSize:62; dataBlock:62; errorBlock:36 ),
   ( height: 36; width: 36; heightSection: 18; widthSection: 18; dataSize:86; dataBlock:86; errorBlock:42 ),
   ( height: 40; width: 40; heightSection: 20; widthSection: 20; dataSize:114; dataBlock:114; errorBlock: 48 ),
   ( height: 44; width: 44; heightSection: 22; widthSection: 22; dataSize:144; dataBlock:144; errorBlock: 56 ),
   ( height: 48; width: 48; heightSection: 24; widthSection: 24; dataSize:174; dataBlock:174; errorBlock: 68 ),
   ( height: 52; width: 52; heightSection: 26; widthSection: 26; dataSize:204; dataBlock:102; errorBlock: 42 ),
   ( height: 64; width: 64; heightSection: 16; widthSection: 16; dataSize:280; dataBlock:140; errorBlock: 56 ),
   ( height: 72; width: 72; heightSection: 18; widthSection: 18; dataSize:368; dataBlock:92; errorBlock: 36 ),
   ( height: 80; width: 80; heightSection: 20; widthSection: 20; dataSize:456; dataBlock:114; errorBlock: 48 ),
   ( height: 88; width: 88; heightSection: 22; widthSection: 22; dataSize:576; dataBlock:144; errorBlock: 56 ),
   ( height: 96; width: 96; heightSection: 24; widthSection: 24; dataSize:696; dataBlock:174; errorBlock: 68 ),
   ( height:104; width:104; heightSection: 26; widthSection: 26; dataSize:816; dataBlock:136; errorBlock: 56 ),
   ( height:120; width:120; heightSection: 20; widthSection: 20; dataSize:1050; dataBlock:175; errorBlock: 68 ),
   ( height:132; width:132; heightSection: 22; widthSection: 22; dataSize:1304; dataBlock:163; errorBlock: 62 ),
   ( height:144; width:144; heightSection: 24; widthSection: 24; dataSize:1558; dataBlock:156; errorBlock: 62 )
);

 log : array[0..255] of integer =
              ( 0, 255,   1, 240,   2, 225, 241,  53,   3,  38, 226, 133, 242,  43,  54, 210,
                4, 195,  39, 114, 227, 106, 134,  28, 243, 140,  44,  23,  55, 118, 211, 234,
                5, 219, 196,  96,  40, 222, 115, 103, 228,  78, 107, 125, 135,   8,  29, 162,
                244, 186, 141, 180,  45,  99,  24,  49,  56,  13, 119, 153, 212, 199, 235,  91,
                6,  76, 220, 217, 197,  11,  97, 184,  41,  36, 223, 253, 116, 138, 104, 193,
                229,  86,  79, 171, 108, 165, 126, 145, 136,  34,   9,  74,  30,  32, 163,  84,
                245, 173, 187, 204, 142,  81, 181, 190,  46,  88, 100, 159,  25, 231,  50, 207,
                57, 147,  14,  67, 120, 128, 154, 248, 213, 167, 200,  63, 236, 110,  92, 176,
                7, 161,  77, 124, 221, 102, 218,  95, 198,  90,  12, 152,  98,  48, 185, 179,
                42, 209,  37, 132, 224,  52, 254, 239, 117, 233, 139,  22, 105,  27, 194, 113,
                230, 206,  87, 158,  80, 189, 172, 203, 109, 175, 166,  62, 127, 247, 146,  66,
                137, 192,  35, 252,  10, 183,  75, 216,  31,  83,  33,  73, 164, 144,  85, 170,
                246,  65, 174,  61, 188, 202, 205, 157, 143, 169,  82,  72, 182, 215, 191, 251,
                47, 178,  89, 151, 101,  94, 160, 123,  26, 112, 232,  21,  51, 238, 208, 131,
                58,  69, 148,  18,  15,  16,  68,  17, 121, 149, 129,  19, 155,  59, 249,  70,
                214, 250, 168,  71, 201, 156,  64,  60, 237, 130, 111,  20,  93, 122, 177, 150 );

      alog : array[0..255] of integer =
              ( 1,   2,   4,   8,  16,  32,  64, 128,  45,  90, 180,  69, 138,  57, 114, 228,
                229, 231, 227, 235, 251, 219, 155,  27,  54, 108, 216, 157,  23,  46,  92, 184,
                93, 186,  89, 178,  73, 146,   9,  18,  36,  72, 144,  13,  26,  52, 104, 208,
                141,  55, 110, 220, 149,   7,  14,  28,  56, 112, 224, 237, 247, 195, 171, 123,
                246, 193, 175, 115, 230, 225, 239, 243, 203, 187,  91, 182,  65, 130,  41,  82,
                164, 101, 202, 185,  95, 190,  81, 162, 105, 210, 137,  63, 126, 252, 213, 135,
                35,  70, 140,  53, 106, 212, 133,  39,  78, 156,  21,  42,  84, 168, 125, 250,
                217, 159,  19,  38,  76, 152,  29,  58, 116, 232, 253, 215, 131,  43,  86, 172,
                117, 234, 249, 223, 147,  11,  22,  44,  88, 176,  77, 154,  25,  50, 100, 200,
                189,  87, 174, 113, 226, 233, 255, 211, 139,  59, 118, 236, 245, 199, 163, 107,
                214, 129,  47,  94, 188,  85, 170, 121, 242, 201, 191,  83, 166,  97, 194, 169,
                127, 254, 209, 143,  51, 102, 204, 181,  71, 142,  49,  98, 196, 165, 103, 206,
                177,  79, 158,  17,  34,  68, 136,  61, 122, 244, 197, 167,  99, 198, 161, 111,
                222, 145,  15,  30,  60, 120, 240, 205, 183,  67, 134,  33,  66, 132,  37,  74,
                148,   5,  10,  20,  40,  80, 160, 109, 218, 153,  31,  62, 124, 248, 221, 151,
                3,   6,  12,  24,  48,  96, 192, 173, 119, 238, 241, 207, 179,  75, 150,   1 );
    poly5  : array[0..4] of integer = ( 228,  48,  15, 111,  62 );
    poly7  : array[0..6] of integer = ( 23,  68, 144, 134, 240,  92, 254 );
    poly10 : array[0..9] of integer = ( 28,  24, 185, 166, 223, 248, 116, 255, 110,  61 );
    poly11 : array[0..10] of integer = ( 175, 138, 205,  12, 194, 168,  39, 245,  60,  97, 120 );
    poly12 : array[0..11] of integer = ( 41, 153, 158,  91,  61,  42, 142, 213,  97, 178, 100, 242 );
    poly14 : array[0..13] of integer = ( 156,  97, 192, 252,  95,   9, 157, 119, 138,  45,  18, 186,  83, 185 );
    poly18 : array[0..17] of integer = ( 83, 195, 100,  39, 188,  75,  66,  61, 241, 213, 109, 129,  94, 254, 225,  48, 90, 188 );
    poly20 : array[0..19] of integer = ( 15, 195, 244,   9, 233,  71, 168,   2, 188, 160, 153, 145, 253,  79,
                                         108,  82, 27, 174, 186, 172 );
    poly24 : array[0..23] of integer = ( 52, 190,  88, 205, 109,  39, 176,  21, 155, 197, 251, 223, 155,  21,   5, 172,
                                         254, 124,  12, 181, 184,  96,  50, 193 );
    poly28 : array[0..27] of integer = ( 211, 231,  43,  97,  71,  96, 103, 174,  37, 151, 170,  53,  75,  34, 249, 121,
                                         17, 138, 110, 213, 141, 136, 120, 151, 233, 168,  93, 255 );
    poly36 : array[0..35] of integer = ( 245, 127, 242, 218, 130, 250, 162, 181, 102, 120,  84, 179, 220, 251,  80, 182,
                                         229,  18,   2,   4,  68,  33, 101, 137,  95, 119, 115,  44, 175, 184,  59,  25,
                                         225,  98,  81, 112 );
    poly42 : array[0..41] of integer = ( 77, 193, 137,  31,  19,  38,  22, 153, 247, 105, 122,   2, 245, 133, 242,   8,
                                        175,  95, 100,   9, 167, 105, 214, 111,  57, 121,  21,   1, 253,  57,  54, 101,
                                         248, 202,  69,  50, 150, 177, 226,   5,   9,   5 );
    poly48 : array[0..47] of integer = ( 245, 132, 172, 223,  96,  32, 117,  22, 238, 133, 238, 231, 205, 188, 237,  87,
                                         191, 106,  16, 147, 118,  23,  37,  90, 170, 205, 131,  88, 120, 100,  66, 138,
                                         186, 240,  82,  44, 176,  87, 187, 147, 160, 175,  69, 213,  92, 253, 225,  19 );
    poly56 : array[0..55] of integer = ( 175,   9, 223, 238,  12,  17, 220, 208, 100,  29, 175, 170, 230, 192, 215, 235,
                                         150, 159,  36, 223,  38, 200, 132,  54, 228, 146, 218, 234, 117, 203,  29, 232,
                                         144, 238,  22, 150, 201, 117,  62, 207, 164,  13, 137, 245, 127,  67, 247,  28,
                                         155,  43, 203, 107, 233,  53, 143,  46 );
    poly62 : array[0..61] of integer = ( 242,  93, 169,  50, 144, 210,  39, 118, 202, 188, 201, 189, 143, 108, 196,  37,
                                         185, 112, 134, 230, 245,  63, 197, 190, 250, 106, 185, 221, 175,  64, 114,  71,
                                         161,  44, 147,   6,  27, 218,  51,  63,  87,  10,  40, 130, 188,  17, 163,  31,
                                         176, 170,   4, 107, 232,   7,  94, 166, 224, 124,  86,  47,  11, 204 );
    poly68 : array[0..67] of integer = ( 220, 228, 173,  89, 251, 149, 159,  56,  89,  33, 147, 244, 154,  36,  73, 127,
                                         213, 136, 248, 180, 234, 197, 158, 177,  68, 122,  93, 213,  15, 160, 227, 236,
                                         66, 139, 153, 185, 202, 167, 179,  25, 220, 232,  96, 210, 231, 136, 223, 239,
                                         181, 241,  59,  52, 172,  25,  49, 232, 211, 189,  64,  54, 108, 153, 132,  63,
                                         96, 103,  82, 186 );

       _x12  = #13 + '*> 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
       cbDefaultText = '12345678';

type

    SizeF = record
        height : extended;
        width  : extended;
    end;

    TInts = array of integer;

//                                         /////////////////////////////////////////////////////////////////////////
// Generates the 2D Data Matrix barcode.   /////////////////////////////////////////////////////////////////////////
//                                         /////////////////////////////////////////////////////////////////////////

{$M+}
TfrxBarcodeDataMatrix = class( TfrxBarcode2DBase )

  private

    FPlace            : TInts;
    FSymbolSize       : DatamatrixSymbolSize;
    FEncoding         : DatamatrixEncoding;
    FCodePage         : integer;

    procedure SetBit(x, y, xByte : integer);
    procedure Generate(var text : string); overload;
    procedure Generate( var text: array of byte; textOffset, textSize : integer); overload;
    function  GetEncodation(var Text : array of byte; textOffset, textSize : integer; var data : array of byte;
                                     dataOffset, dataSize : integer; firstMatch : boolean) : integer;

    procedure Draw(var data : array of byte; dataSize : integer; const dm: DmParams);
    procedure SetCodePage( cp : integer );
    procedure SetEncoding( v : DatamatrixEncoding);
    procedure Ecc200;
    procedure SetSymbolSize( s : DatamatrixSymbolSize);
    function  GetPixelSize : integer;
    procedure SetPixelSize(v : integer);
protected
    procedure SetText(v : string); override;

public

    constructor Create; override;
    destructor  Destroy; override;
    procedure   Assign(src: TfrxBarcode2DBase);override;
//    procedure   Draw2DBarcode(var g : TCanvas; scalex, scaley : extended; x, y : integer ); override;

published


    property SymbolSize : DatamatrixSymbolSize read FSymbolSize write SetSymbolSize;
    property Encoding :  DatamatrixEncoding read    FEncoding    write    SetEncoding;
    property CodePage : integer read FCodePage write SetCodePage;
    property PixelSize : integer read GetPixelSize write SetPixelSize;

end;


procedure GenerateECC(var wd : array of byte; nd, datablock, nc : integer );


implementation

{$IFDEF DELPHI12}
uses AnsiStrings;
{$ENDIF}

var
     nrow, ncol : integer;


constructor TfrxBarcodeDataMatrix.Create;

begin

    inherited;
    FSymbolSize := AutoSize;
    FEncoding := Auto;
    FCodePage := 437;
    PixelWidth := 4;
    PixelHeight := 4;
    FWidth := 0;
    FHeight := 0;

    Generate(FText);

end;

destructor TfrxBarcodeDataMatrix.Destroy;
begin
  SetLength(FPlace, 0);
  inherited;
end;


//

procedure TfrxBarcodeDataMatrix.SetCodepage(cp : integer);
begin

    FCodepage := cp;
    Generate(FText);

end;


procedure TfrxBarcodeDataMatrix.SetEncoding( v : DatamatrixEncoding);
begin

    FEncoding := v;
    Generate(FText);

end;

procedure TfrxBarcodeDataMatrix.SetSymbolSize( s : DatamatrixSymbolSize );
begin
        FSymbolSize := s;
        Generate(FText);

end;

function TfrxBarcodeDataMatrix.GetPixelSize: integer;
begin
  result := FPixelWidth;
end;

procedure TfrxBarcodeDataMatrix.SetPixelSize(v : integer);
begin
  FPixelWidth := v;
  FPixelHeight := v;
end;

procedure TfrxBarcodeDataMatrix.Assign(src: TfrxBarcode2DBase);
var
   BSource : TfrxBarcodeDataMatrix;
begin
   inherited;
   if src is TfrxBarcodeDataMatrix then
   begin
      BSource    := TfrxBarcodeDataMatrix( src );
      FHeight    := BSource.FHeight;
      FSymbolSize := BSource.SymbolSize;
      FEncoding := BSource.Encoding;
      FCodePage := BSource.CodePage;
   end;
end;

procedure TfrxBarcodeDataMatrix.SetText( v : string);
begin
    if( FText <> v) then
    begin
        FText := v;
        Generate( FText );
    end;
end;

procedure TfrxBarcodeDataMatrix.SetBit( x, y, xByte : integer);
begin
    FImage[y * xByte + x div 8] := FImage[y * xByte + x div 8] or ( 128 shr (x and 7) );
end;


procedure TfrxBarcodeDataMatrix.Draw(var data : array of byte; dataSize : integer; const dm: DmParams);
var
     k,i, j, p, x, y, xs, ys, z, xByte : integer;
begin

  xByte := (dm.width + 7) div 8;

 for k:=0 to Length(FImage)-1 do
      FImage[k] := 0;

  //alignment patterns
  //dotted horizontal line
  i := 0;
  while i < dm.height do
  begin
      j := 0;
      while j < dm.width do
      begin
          SetBit(j, i, xByte);
          inc(j,2);
      end;
      inc(i, dm.heightSection);
  end;

  //solid horizontal line
  i := dm.heightSection - 1;
  while i < dm.height do
  begin
      for j := 0 to dm.width-1 do
          SetBit(j, i, xByte);

      inc(i,dm.heightSection);
  end;

  //solid vertical line
  i := 0;
  while i < dm.width do
  begin
      for j:=0 to dm.height-1 do
          SetBit(i, j, xByte);
      inc(i, dm.widthSection);
  end;

  //dotted vertical line
  i := dm.widthSection - 1;
  while i < dm.width do
  begin
      j := 1;
      while j < dm.height do
      begin
          SetBit(i, j, xByte);
          inc(j,2);
      end;
      inc(i, dm.widthSection);
  end;

  p := 0;
  ys := 0;
  while ys < dm.height do
  begin
      for y := 1 to dm.heightSection - 2 do
      begin
          xs := 0;
          while xs < dm.width do
          begin
              for x:=1 to dm.widthSection - 2 do
              begin
                  z := FPlace[p];
                  inc(p);
                  if ( (z = 1) or (  (z > 1) and (( data[(z div 8) - 1] and $ff ) and  (128 shr (z mod 8)) <> 0) ) ) then
                      SetBit(x + xs, y + ys, xByte);
              end;
              inc(xs, dm.widthSection);
          end;
      end;
      inc(ys, dm.heightSection);
  end;

end;




procedure MakePadding(var data : array of byte; position, count : integer);
var
    t : integer;
begin
    //already in ascii mode
    if count > 0 then
    begin
        data[position] := 129;
        inc(position);
        dec(count);
        while count > 0 do
        begin
            t := 129 + (((position + 1) * 149) mod 253) + 1;
            if t > 254 then dec(t,254);
            data[position] := byte(t);
            inc(position);
            dec(count);
      end
    end
end;

function IsDigit( c : integer ) : boolean;
begin
    result := false;
{$IFDEF Delphi12}
    if CharInSet(char(c), ['0'..'9']) then result := true;
{$ELSE}
    if char(c) in ['0'..'9'] then result := true;
{$ENDIF}
end;


function AsciiEncodation( var text : array of byte; textOffset, textLength : integer; var data : array of byte; dataOffset, dataLength : integer )  : integer;
var
    ptrIn, ptrOut,c : integer;

begin

     ptrIn := textOffset;
     ptrOut := dataOffset;
     inc(textLength, textOffset);
     inc(dataLength, dataOffset);

     while (ptrIn < textLength) do
     begin
         if (ptrOut >= dataLength) then
         begin
             result := -1;
             exit;
         end;

         c := text[ptrIn] and $ff;
         inc(ptrIn);

         if  IsDigit(c) and (ptrIn < textLength) and IsDigit( text[ptrIn]  and $ff ) then
         begin
             data[ptrOut] := byte( (( c - integer('0')) * 10 + ( text[ptrIn] and $ff ) - integer('0') + 130));
             inc(ptrIn);
             inc(ptrOut);
         end
         else
             if c > 127 then
             begin
                 if ( ptrOut + 1 ) >= dataLength then
                 begin
                     result := -1;
                     exit;
                 end;
                 data[ptrOut] := byte(235);
                 inc(ptrOut);
                 data[ptrOut] := byte(c - 128 + 1);
                 inc(ptrOut);
             end
             else
             begin
                 data[ptrOut] := byte(c + 1);
                 inc(ptrOut);
             end
     end;

     result := ptrOut - dataOffset;
end;

function B256Encodation(var text : array of byte; textOffset, textLength : integer; var data : array of byte; dataOffset, dataLength : integer ) : integer;
var
    k, j, prn, tv, c : integer;

begin

    if textLength = 0 then begin result := 0; exit; end;
    if (textLength < 250) and (textLength + 2 > dataLength) then begin  result := -1; exit; end;
    if (textLength >= 250) and (textLength + 3 > dataLength) then begin  result := -1; exit; end;

    data[dataOffset] := byte(231);
    if textLength < 250 then
    begin
        data[dataOffset + 1] := byte(textLength);
        k := 2;
    end
    else
    begin
        data[dataOffset + 1] := byte((textLength div 250) + 249);
        data[dataOffset + 2] := byte( textLength mod 250 );
        k := 3;
    end;

    for j := 0 to textLength-1 do
        data[k + dataOffset + j] := byte(text[textOffset + j]);

    inc(k, textLength + dataOffset);

    for j := dataOffset + 1 to k-1 do
    begin
        c := data[j] and $ff;
        prn := ((149 * (j + 1)) mod 255) + 1;
        tv := c + prn;
        if (tv > 255) then dec(tv, 256);
        data[j] := byte(tv);
    end;
    result := k - dataOffset;
end;



function X12Encodation(var text: array of byte; textOffset, textLength : integer; var data : array of byte; dataOffset, dataLength : integer ) : integer;
var
      ptrIn, ptrOut, count, k, n, ci, i : integer;
      c : byte;
      x : array of byte;
begin

      if (textLength = 0) then begin result := 0; exit; end;
      ptrOut := 0;
      SetLength( x, textLength);

      count := 0;
      for ptrIn := 0 to textLength - 1 do
      begin
          i := Pos(  char(text[ptrIn + textOffset]), _x12)  - 1;
          if (i >= 0) then
          begin
              x[ptrIn] := byte(i);
              inc(count);
          end
          else
          begin
              x[ptrIn] := byte(100);
              if (count >= 6) then
                  dec(count, (count div 3) * 3 );
              for k := 0 to count-1 do
                  x[ptrIn - k - 1] := byte(100);
              count := 0;
          end
      end;

      if (count >= 6) then dec(count, (count div 3) * 3);
      ptrIn := textLength;
      for k := 0 to count-1 do
          x[ptrIn - k - 1] := byte(100);

      ptrIn := 0;
      while ptrIn < textLength do
      begin
          c := x[ptrIn];
          if (ptrOut >= dataLength) then break;
          if (c < 40) then
          begin
              if (ptrIn = 0) or ( (ptrIn > 0 ) and ( x[ptrIn - 1] > 40 ) ) then
              begin
                  data[dataOffset + ptrOut] := byte(238);
                  inc(ptrOut);
              end;

              if (ptrOut + 2 > dataLength) then
                  break;
              n := 1600 * x[ptrIn] + 40 * x[ptrIn + 1] + x[ptrIn + 2] + 1;
              data[dataOffset + ptrOut] := byte(n div 256);
              inc(ptrOut);
              data[dataOffset + ptrOut] := byte(n);
              inc(ptrOut);
              inc(ptrIn, 2);
          end
          else
          begin
              if (ptrIn > 0) and (x[ptrIn - 1] < 40) then
              begin
                  data[dataOffset + ptrOut] := byte(254);
                  inc(ptrOut);
              end;
              ci := text[ptrIn + textOffset] and $ff;
              if (ci > 127) then
              begin
                  data[dataOffset + ptrOut] := byte(235);
                  inc(ptrOut);
                  dec(ci, 128);
              end;
              if (ptrOut >= dataLength) then
                  break;
              data[dataOffset + ptrOut] := byte(ci + 1);
              inc(ptrOut);
          end;
          inc(ptrIn);
      end;
      c := 100;
      if (textLength > 0) then
          c := x[textLength - 1];
      if (ptrIn <> textLength) or ( (c < 40 ) and (ptrOut >= dataLength)) then
      begin
        result := -1;
        exit;
      end;
      if (c < 40) then
      begin
        data[dataOffset + ptrOut] := byte(254);
        inc(ptrOut);
      end;

      result := ptrOut;
      // need try finally
      SetLength( x, 0);
end;


function EdifactEncodation(var text: array of byte; textOffset, textLength: integer; var data: array of byte; dataOffset, dataLength: integer): integer;
var
    ptrIn, ptrOut, edi, pedi, c : integer;
    Ascii : boolean;
begin

    if (textLength = 0) then begin result := 0; exit; end;
    ptrOut := 0;
    edi := 0;
    pedi := 18;
    Ascii := true;

    for ptrIn := 0 to textLength-1 do
    begin
        c := text[ptrIn + textOffset]  and $ff;
        if ( ( (c and $e0) = $40 ) or  ( (c and $e0) = $20) )
           and
           (char(c) <> '_' ) then
        begin
            if (Ascii) then
            begin
                if (ptrOut + 1 > dataLength) then break;
                data[dataOffset + ptrOut] := byte(240);
                inc(ptrOut);
                Ascii := false;
            end;
            c := c and $3f;
            edi := edi or (c shl pedi);
            if (pedi =  0) then
            begin
                if (ptrOut + 3 > dataLength) then break;
                data[dataOffset + ptrOut] := byte(edi shr 16); inc(ptrOut);
                data[dataOffset + ptrOut] := byte(edi shr 8);  inc(ptrOut);
                data[dataOffset + ptrOut] := byte(edi);   inc(ptrOut);
                edi := 0;
                pedi := 18;
            end
            else
                dec(pedi,6);
        end
        else
        begin
            if (not Ascii) then
            begin
                edi := edi or ( (integer('_') and $3f) shl pedi);
                if (ptrOut + (3 - ( pedi div 8 )) > dataLength) then break;
                data[dataOffset + ptrOut] := byte(edi shr 16); inc(ptrOut);
                if (pedi <= 12) then
                begin
                    data[dataOffset + ptrOut] := byte(edi shr 8); inc(ptrOut);
                end;
                if (pedi <= 6) then
                begin
                    data[dataOffset + ptrOut] := byte(edi); inc(ptrOut);
                end;
                Ascii := true;
                pedi := 18;
                edi := 0;
             end;
             if (c > 127) then
             begin
                 if (ptrOut >= dataLength) then break;
                 data[dataOffset + ptrOut] := byte(235);
                 inc(ptrOut);
                 dec(c, 128);
             end;
             if (ptrOut >= dataLength) then break;
             data[dataOffset + ptrOut] := byte(c + 1);
             inc(ptrOut);
        end;

   end; // for

   if ( ptrIn <> textLength) then begin result := -1; exit; end;
   if (not Ascii) then
   begin
       edi := edi or ( (integer('_') and $3f) shl pedi );
       if (ptrOut + (3 - (pedi div 8)) > dataLength) then begin result:= - 1; exit; end;
       data[dataOffset + ptrOut] := byte(edi shr 16);
       inc(ptrOut);
       if ( pedi <= 12) then
       begin
           data[dataOffset + ptrOut] := byte(edi shr 8);
           inc(ptrOut);
       end;
       if ( pedi <= 6 ) then
       begin
           data[dataOffset + ptrOut] := byte(edi);
           inc(ptrOut);
       end;
   end;

   result := ptrOut;

end;

function C40OrTextEncodation(var Text : array of byte; textOffset, textLength : integer; var data : array of byte; dataOffset, dataLength : integer;
                             C40 : boolean ) : integer;
var

    ptrIn, ptrOut, encPtr, last0, last1, i, a, c, idx : integer;
    basic, shift2, shift3 : string;
    enc : array of integer;

begin

    if (textLength  = 0) then begin result := 0; exit; end;
    ptrIn := 0;
    ptrOut := 0;
    if (C40) then
    begin
        data[dataOffset + ptrOut] := byte(230);
        inc(ptrOut);
    end
    else
    begin
        data[dataOffset + ptrOut] := byte(239);
        inc(ptrOut);
    end;

    shift2 := '!\"#$%&'+#39+'()*+,-./:;<=>?@[\\]^_';
    if (C40) then
    begin
        basic := ' 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        shift3 := '`abcdefghijklmnopqrstuvwxyz{|}~' + #127;
    end
    else
    begin
        basic := ' 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        shift3 := '`abcdefghijklmnopqrstuvwxyz{|}~' + #127;
    end;

    SetLength( enc, textLength * 4 + 10);
    encPtr := 0;
    last0 := 0;
    last1 := 0;

    try
      while (ptrIn < textLength) do
      begin
        if ((encPtr mod 3) = 0) then
        begin
            last0 := ptrIn;
            last1 := encPtr;
        end;
        c := text[textOffset + ptrIn] and $ff;
        inc(ptrIn);
        if (c > 127) then
        begin
            dec(c, 128);
            enc[encPtr] := 1; inc(encPtr);
            enc[encPtr] := 30; inc(encPtr);
        end;

        idx := Pos( char(c), basic)  - 1;
        if (idx >= 0) then
        begin
            enc[encPtr] := idx + 3;
            inc(encPtr);
        end
        else
            if (c < 32) then
            begin
                enc[encPtr] := 0;  inc(encPtr);
                enc[encPtr] := c;  inc(encPtr);
            end
            else
            begin
                idx := Pos( char(c), shift2) - 1;
                if ( idx >= 0 ) then
                begin
                    enc[encPtr] := 1; inc(encPtr);
                    enc[encPtr] := idx;  inc(encPtr);
                end
                else
                begin
                    idx := Pos( char(c), shift3)  - 1;
                    if ( idx >= 0) then
                    begin
                        enc[encPtr] := 2; inc(encPtr);
                        enc[encPtr] := idx; inc(encPtr);
                    end
                end;
            end;
      end;

      if ((encPtr mod 3) <> 0) then
      begin
        ptrIn := last0;
        encPtr := last1;
      end;

      if ( (encPtr div 3) * 2 > dataLength - 2) then
      begin
        result :=  - 1;
        exit;
      end;

      i := 0;
      while i < encPtr do
      begin
        a := 1600 * enc[i] + 40 * enc[i + 1] + enc[i + 2] + 1;
        data[dataOffset + ptrOut] := byte(a div 256); inc(ptrOut);
        data[dataOffset + ptrOut] := byte(a);  inc(ptrOut);
        inc(i, 3);
      end;

      data[ptrOut] := byte(254);
      inc(ptrOut);
      i := AsciiEncodation(Text, ptrIn, textLength - ptrIn, data, ptrOut, dataLength - ptrOut);
      if (i < 0) then
        result := i
      else
        result := ptrOut + i;
    finally
      SetLength( enc, 0);
    end;

end;

function TfrxBarcodeDataMatrix.GetEncodation(var Text : array of byte; textOffset, textSize : integer; var data : array of byte;
                                     dataOffset, dataSize : integer; firstMatch : boolean) : integer;
var
      e, j, k : integer;
      e1 : array[0..5] of integer;

begin

    if (dataSize < 0) then
    begin
        result := -1;
        exit;
    end;

    if ( FEncoding = Auto) then
    begin
        e1[0] := AsciiEncodation(text, textOffset, textSize, data, dataOffset, dataSize);
        if firstMatch and ( e1[0] >= 0 ) then begin result := e1[0]; exit; end;
        e1[1] := C40OrTextEncodation(text, textOffset, textSize, data, dataOffset, dataSize, false);
        if firstMatch and ( e1[1] >= 0 ) then begin result := e1[1]; exit; end;
        e1[2] := C40OrTextEncodation(text, textOffset, textSize, data, dataOffset, dataSize, true);
        if firstMatch and ( e1[2] >= 0 ) then begin result := e1[2]; exit; end;
        e1[3] := B256Encodation(text, textOffset, textSize, data, dataOffset, dataSize);
        if firstMatch and ( e1[3] >= 0 ) then begin result := e1[3]; exit; end;
        e1[4] := X12Encodation(text, textOffset, textSize, data, dataOffset, dataSize);
        if firstMatch and ( e1[4] >= 0 ) then begin result := e1[4]; exit; end;
        e1[5] := EdifactEncodation(text, textOffset, textSize, data, dataOffset, dataSize);
        if firstMatch and ( e1[5] >= 0 ) then begin result := e1[5]; exit; end;
        if (e1[0] < 0) and (e1[1] < 0) and (e1[2] < 0) and (e1[3] < 0) and (e1[4] < 0) and (e1[5] < 0) then
        begin
          result := -1;
          exit;
        end;

        j := 0;
        e := 99999;
        for k := 0 to 5 do
          if (e1[k] >= 0 ) and (e1[k] < e) then
          begin
            e := e1[k];
            j := k;
          end;

        if (j = 0) then
            e := AsciiEncodation(text, textOffset, textSize, data, dataOffset, dataSize)
        else
            if (j = 1) then
                e := C40OrTextEncodation(text, textOffset, textSize, data, dataOffset, dataSize, false)
            else
                if (j = 2) then
                    e := C40OrTextEncodation(text, textOffset, textSize, data, dataOffset, dataSize, true)
                else
                    if (j = 3) then
                        e := B256Encodation(text, textOffset, textSize, data, dataOffset, dataSize)
                    else
                        if (j = 4) then
                            e := X12Encodation(text, textOffset, textSize, data, dataOffset, dataSize);
        result := e;
        exit;
    end;

    case (FEncoding) of

        Ascii:   begin result := AsciiEncodation(text, textOffset, textSize, data, dataOffset, dataSize); exit; end;
        C40:     begin result := C40OrTextEncodation(text, textOffset, textSize, data, dataOffset, dataSize, true); exit; end;
        Txt:    begin result := C40OrTextEncodation(text, textOffset, textSize, data, dataOffset, dataSize, false); exit; end;
        Base256: begin result := B256Encodation(text, textOffset, textSize, data, dataOffset, dataSize); exit; end;
        X12:     begin result := X12Encodation(text, textOffset, textSize, data, dataOffset, dataSize); exit; end;
        Edifact: begin result := EdifactEncodation(text, textOffset, textSize, data, dataOffset, dataSize); exit; end;

    end;
    result := -1;

end;

function ReplaceControlCodes(var text: AnsiString) : AnsiString;
begin
    if Pos(AnsiString('&1;'), text) = 1 then
    begin
          Delete(text,1,3);
          text := AnsiString(#232) + text;
    end;
{$IFDEF DELPHI12}
    result := AnsiStrings.StringReplace(text, '&1;', AnsiString(#29), [rfReplaceAll]);
{$ELSE}
    result := StringReplace(text, '&1;', AnsiString(#29), [rfReplaceAll]);
{$ENDIF}
end;

procedure TfrxBarcodeDataMatrix.Generate(var text : string);
var
    t : array of byte;
    i: Integer;
    AnsiText: AnsiString;
{$IFNDEF DELPHI12}
    WideText: WideString;
{$ENDIF}
begin
{$IFNDEF DELPHI12}
    WideText := WideString(text);
    if FCodePage = 65001 then
      AnsiText := UTF8Encode(WideText)
    else
      AnsiText := _UnicodeToAnsi(WideText, 0, FCodePage);
{$ELSE}
    if FCodePage = 65001 then
      AnsiText := UTF8Encode(text)
    else
      AnsiText := _UnicodeToAnsi(text, 0, FCodePage);
{$ENDIF}
    AnsiText := ReplaceControlCodes(AnsiText);
    SetLength(t, Length(AnsiText));
    try
      for i := 1 to Length(AnsiText) do
        t[i - 1] := Ord(AnsiText[i]);
      Generate(t, 0, Length(t));
    finally
      SetLength(t, 0);
    end;
end;

procedure  TfrxBarcodeDataMatrix.Generate( var text :array of byte; textOffset, textSize : integer);

var
     e, full, extCount : integer;
     dm, last : DmParams;
     data : array of byte;
     k : DatamatrixSymbolSize;

begin

  ErrorText := '';
  extCount := 0;
  SetLength(data, 2500);

  try
    if ( Length(text) > 0) and ( text[0] = byte(232)) then
    begin
        data[0] := byte(232);
        inc(textOffset);
        dec(textSize);
        extCount := 1;
    end;

    // проверяем, возможна ли вообще кодировка такого текста по длине
    last := dmSizes[ High(dmSizes) ];
    e := GetEncodation(text, textOffset, textSize, data, extCount, last.dataSize, false);  // если кодировка Auto, то вернет самую короткую длину кода                                                                                           // иначе длину кода для текущей кодировки или -1, если не умещается
    try

      if (e < 0) then
      begin
        raise Exception.Create('The text is too big.');
      end;

      inc(e, extCount);   // учитываем расширения

      // текст определенно кодируется,
      // длина кода сейчас в E, определимся с размером символа

      if FSymbolSize = AutoSize then
      begin
        for k := Size10x10 to High(dmSizes) do
            if dmSizes[k].datasize >= e then
                break;

        dm := dmSizes[k];
        FHeight := dm.height;
        FWidth := dm.width;

      end
      else
      begin

        dm := dmSizes[FSymbolSize];
        e := GetEncodation(text, textOffset, textSize, data, extCount, dm.dataSize, false);

        if (e < 0) then
        begin
            raise Exception.Create(' The text is too big.');
        end;

        FHeight := dm.height;
        FWidth := dm.width;
        inc(e, extCount);

      end;

      SetLength(FImage, ((dm.width + 7) div 8) * dm.height );
      MakePadding(data, e, dm.dataSize - e);
      nrow := dm.height - ( (dm.height div dm.heightSection) * 2);
      ncol := dm.width - ( ( dm.width div dm.widthSection ) * 2);
      SetLength(FPlace, nrow * ncol);
      Ecc200;

      full := dm.dataSize + ((dm.dataSize + 2) div dm.dataBlock) * dm.errorBlock;
      GenerateECC(data, dm.dataSize, dm.dataBlock, dm.errorBlock);
      Draw(data, full, dm);

    except
      on e: Exception do
      begin
  //        FText := cbDefaultText;
        ErrorText := e.Message;
      end;
    end;
  finally
    SetLength(data, 0);
  end;

end;



//* "ECC200" fills an nrow x ncol array with appropriate values for ECC200 */
procedure TfrxBarcodeDataMatrix.Ecc200;

//* "module" places "chr+bit" with appropriate wrapping within array[] */
procedure Module(  row, col, chr, bit : integer);
begin
     if (row < 0) then begin row := row + nrow; col := col + 4 - ((nrow + 4) mod 8); end;
     if (col < 0) then begin col := col + ncol; row := row + 4 - ((ncol + 4) mod 8); end;
     FPlace[row * ncol + col] := integer(8 * chr + bit);
end;

//* "utah" places the 8 bits of a utah-shaped symbol character in ECC200 */

procedure Utah( row, col, chr : integer);
begin
    Module(row - 2, col - 2, chr, 0);
    Module(row - 2, col - 1, chr, 1);
    Module(row - 1, col - 2, chr, 2);
    Module(row - 1, col - 1, chr, 3);
    Module(row - 1, col, chr, 4);
    Module(row, col - 2, chr, 5);
    Module(row, col - 1, chr, 6);
     Module(row, col, chr, 7);
end;

//* "cornerN" places 8 bits of the four special corner cases in ECC200 */
procedure Corner1( chr : integer);
begin
    Module(nrow - 1, 0, chr, 0);
    Module(nrow - 1, 1, chr, 1);
    Module(nrow - 1, 2, chr, 2);
    Module(0, ncol - 2, chr, 3);
    Module(0, ncol - 1, chr, 4);
    Module(1, ncol - 1, chr, 5);
    Module(2, ncol - 1, chr, 6);
    Module(3, ncol - 1, chr, 7);
end;

procedure Corner2( chr : integer);
begin
    Module(nrow - 3, 0, chr, 0);
    Module(nrow - 2, 0, chr, 1);
    Module(nrow - 1, 0, chr, 2);
    Module(0, ncol - 4, chr, 3);
    Module(0, ncol - 3, chr, 4);
    Module(0, ncol - 2, chr, 5);
    Module(0, ncol - 1, chr, 6);
    Module(1, ncol - 1, chr, 7);
end;

procedure Corner3( chr : integer);
begin
    Module(nrow - 3, 0, chr, 0);
    Module(nrow - 2, 0, chr, 1);
    Module(nrow - 1, 0, chr, 2);
    Module(0, ncol - 2, chr, 3);
    Module(0, ncol - 1, chr, 4);
    Module(1, ncol - 1, chr, 5);
    Module(2, ncol - 1, chr, 6);
    Module(3, ncol - 1, chr, 7);
end;

procedure Corner4( chr : integer);
begin
    Module(nrow - 1, 0, chr, 0);
    Module(nrow - 1, ncol - 1, chr, 1);
    Module(0, ncol - 3, chr, 2);
    Module(0, ncol - 2, chr, 3);
    Module(0, ncol - 1, chr, 4);
    Module(1, ncol - 3, chr, 5);
    Module(1, ncol - 2, chr, 6);
    Module(1, ncol - 1, chr, 7);
end;



var

    row, col, chr, k : integer;

label    l1,l2,l3;

begin

        //* First, fill the array[] with invalid entries */
        for k := 0 to Length(FPlace) - 1 do
          FPlace[k] := 0;
        //* Starting in the correct location for character #1, bit 8,... */
        chr := 1; row := 4; col := 0;
l1://repeat
            //* repeatedly first check for one of the special corner cases, then... */
            if ((row = nrow) and (col = 0)) then begin Corner1(chr); inc(chr); end;
            if ((row = nrow - 2) and (col = 0) and ( (ncol mod 4 ) <> 0)) then
                begin Corner2(chr); inc(chr); end;
            if ((row = nrow - 2) and (col = 0) and ( ( ncol mod 8 ) = 4)) then
                begin Corner3(chr); inc(chr); end;
            if ((row = nrow + 4) and (col = 2) and ( ( ncol mod 8 ) = 0)) then
                 begin Corner4(chr); inc(chr); end;
            //* sweep upward diagonally, inserting successive characters,... */
l2:  //repeat

                if ((row < nrow) and (col >= 0) and ( FPlace[row * ncol + col] = 0)) then

                begin
                    Utah(row, col, chr);
                    inc(chr);
                end;
                dec(row, 2); inc(col,  2);
    //until not((row >= 0) and (col < ncol));
            if ((row >= 0) and (col < ncol)) then goto l2;
            inc(row);
            inc(col, 3);
            //* & then sweep downward diagonally, inserting successive characters,... */
l3: //repeat
                if ((row >= 0) and (col < ncol) and (FPlace[row * ncol + col] = 0)) then
                begin
                    Utah(row, col, chr);
                    inc(chr);
                end;
                inc(row,2);
                dec(col, 2);
   //until not ((row < nrow) and (col >= 0));
            if((row < nrow) and (col >= 0)) then goto l3;
            inc(row, 3);
            inc( col, 1);
        //* ... until the entire array is scanned */
//until not ((row < nrow) or (col < ncol));
        if(((row < nrow) or (col < ncol))) then goto l1;
        //* Lastly, if the lower righthand corner is untouched, fill in fixed pattern */
        if (FPlace[nrow * ncol - 1] = 0) then
        begin
            FPlace[nrow * ncol - 1] := 1;
            FPlace[nrow * ncol - ncol - 2] := 1;
        end
end;

procedure ReedSolomonBlock(var wd : array of byte; nd : integer; var ncout : array of byte; nc: integer; var c : TInts );
var

    i,j,k : integer;

begin

    for i := 0 to nc do
        ncout[i] := 0;
    for i := 0 to nd-1 do
    begin
        k := ( ncout[0] xor wd[i] ) and $ff;
        for j := 0 to nc-1 do
        begin
            if( k = 0 ) then
                ncout[j] := byte( ncout[j + 1] xor byte(0) )
            else
                ncout[j] := byte( ncout[j + 1]
                                  xor (byte( alog[ (log[k] + log[ c[nc - j - 1] ] ) mod 255 ] ))   );
        end
    end
end;

procedure GenerateECC(var wd : array of byte; nd, datablock, nc : integer );
var

     blocks, b, n, p : integer;
     buf, ecc : array of byte;
     c : Pointer;

begin
  blocks := (nd + 2) div datablock;
  SetLength(buf, 256);
  SetLength(ecc, 256);
  try
    c := nil;
    case nc of
        5:  c := @poly5;
        7:  c := @poly7;
        10:c := @poly10;
        11:c := @poly11;
        12:c := @poly12;
        14:c := @poly14;
        18:c := @poly18;
        20:c := @poly20;
        24:c := @poly24;
        28:c := @poly28;
        36:c := @poly36;
        42:c := @poly42;
        48:c := @poly48;
        56:c := @poly56;
        62:c := @poly62;
        68:c := @poly68;
    end;
    for b := 0 to blocks-1 do
    begin
        p := 0;
        n := b;
        while n < nd do
        begin
            buf[p] := wd[n];
            inc(p);
            inc(n, blocks);
        end;
        ReedSolomonBlock(buf, p, ecc, nc, TInts(c));
        p := 0;
        n := b;
        while n < nc * blocks do
        begin
            wd[nd + n] := ecc[p];
            inc(p);
            inc(n, blocks);
        end;
    end;
  finally
    SetLength(buf, 0);
    SetLength(ecc, 0);
  end;
end;


initialization



finalization


end.
