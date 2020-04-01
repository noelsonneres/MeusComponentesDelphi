
{******************************************}
{                                          }
{             FastReport v6.0              }
{            Graphic routines              }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxGraphicUtils;

interface

{$I frx.inc}

uses
  SysUtils, {$IFNDEF FPC}Windows, Messages,{$ENDIF}
  Classes, Graphics, Controls, Forms, Dialogs,
  frxClass, Variants, frxVectorCanvas
  {$IFDEF FPC}
  , Types, LCLType, LCLIntf, LazUTF8, LCLProc, LazHelper, Printers
  {$ELSE}
  , frxUnicodeUtils
  {$ENDIF}
{$IFDEF Delphi10}
, WideStrings
{$ENDIF}
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
 (*$HPPEMIT '#undef NewLine'*)
  TIntArray = array[0..MaxInt div 4 - 1] of Integer;
  PIntArray = ^TIntArray;
  TSubStyle = (ssNormal, ssSubscript, ssSuperscript);

  TfrxHTMLTag = class(TObject)
  public
    Position: Integer;
    Size: Integer;
    AddY: Integer;
    Style: TFontStyles;
    Color: Integer;
    Default: Boolean;
    Small: Boolean;
    DontWRAP: Boolean;
    SubType: TSubStyle;
    procedure Assign(Tag: TfrxHTMLTag);
  end;

  TfrxHTMLTags = class(TObject)
  private
    FItems: TList;
    procedure Add(Tag: TfrxHTMLTag);
    function GetItems(Index: Integer): TfrxHTMLTag;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Count: Integer;
    property Items[Index: Integer]: TfrxHTMLTag read GetItems; default;
  end;

  TfrxHTMLTagsList = class(TObject)
  private
    FAllowTags: Boolean;
    FAddY: Integer;
    FColor: LongInt;
    FDefColor: LongInt;
    FDefSize: Integer;
    FDefStyle: TFontStyles;
    FItems: TList;
    FPosition: Integer;
    FSize: Integer;
    FStyle: TFontStyles;
    FDontWRAP: Boolean;
    FTempArray: PIntArray;
    FTempArraySize: Integer;
    FSubStyle: TSubStyle;
    procedure NewLine;
    procedure Wrap(TagsCount: Integer; AddBreak: Boolean);
    function Add: TfrxHTMLTag;
    function FillCharSpacingArray(var ar: PIntArray; const s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
      Canvas: TCanvas; LineIndex, Add: Integer; Convert: Boolean; DefCharset: Boolean): Integer;
    function GetItems(Index: Integer): TfrxHTMLTags;
    function GetPrevTag: TfrxHTMLTag;
    procedure ReallocTempArray(ANewSize: Integer);
    procedure FreeTempArray;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure SetDefaults(DefColor: TColor; DefSize: Integer;
      DefStyle: TFontStyles);
    procedure ExpandHTMLTags(var s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF});
    function Count: Integer;
    property AllowTags: Boolean read FAllowTags write FAllowTags;
    property Items[Index: Integer]: TfrxHTMLTags read GetItems; default;
    property Position: Integer read FPosition write FPosition;
  end;

  TfrxDrawText = class(TObject)
  private
// internals
    FBMP: TBitmap;
//    FLocked: Boolean; commented by Samuray
    FCanvas: TCanvas;
    FDefPPI: Integer;
    FScrPPI: Integer;
    FTempArray: PIntArray;
    FTempArraySize: Integer;

// data passed by SetXXX calls
    FFontSize: Integer;
    FHTMLTags: TfrxHTMLTagsList;
    FCharSpacing: Extended;
    FLineSpacing: Extended;
    FOptions: Integer;
    FOriginalRect: TRect;
    FParagraphGap: Extended;
    FPlainText: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
    FPrintScale: Extended;
    FRotation: Integer;
    FRTLReading: Boolean;
    FScaledRect: TRect;
    FScaleX: Extended;
    FScaleY: Extended;
    FText: TWideStrings;
    FWordBreak: Boolean;
    FWordWrap: Boolean;
    FWysiwyg: Boolean;
    FMonoFont: Boolean;
    FUseDefaultCharset: Boolean;
    FVC: TVectorCanvas;
    FUseOldLineHeight: Boolean;
    function GetWrappedText: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
    function IsPrinter(C: TCanvas): Boolean;
    procedure DrawTextLine(C: TCanvas; const s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
      X, Y, DX, LineIndex: Integer; Align: TfrxHAlign; var fh, oldfh: HFont);
    procedure WrapTextLine(s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF}; Width, FirstLineWidth,
      CharSpacing: Integer);
    function GetFontHeightMetric(aCanvas: TCanvas): Integer;
    procedure ReallocTempArray(ANewSize: Integer);
    procedure FreeTempArray;
  public
    constructor Create;
    destructor Destroy; override;

// Call these methods in the same order
    procedure SetFont(Font: TFont);
    procedure SetOptions(WordWrap, HTMLTags, RTLReading, WordBreak,
      Clipped, Wysiwyg: Boolean; Rotation: Integer);
    procedure SetGaps(ParagraphGap, CharSpacing, LineSpacing: Extended);
    procedure SetDimensions(ScaleX, ScaleY, PrintScale: Extended;
      OriginalRect, ScaledRect: TRect);
    // need for wrap correction
    procedure SetText(Text: TWideStrings; FirstParaBreak: Boolean = False);
    procedure SetParaBreaks(FirstParaBreak, LastParaBreak: Boolean);
    function DeleteTags(const Txt: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF}): {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};

// call these methods only after methods listed above
    procedure DrawText(C: TCanvas; HAlign: TfrxHAlign; VAlign: TfrxVAlign; UnderlinesTextMode: TfrxUnderlinesTextMode = ulmNone);
    function CalcHeight: Extended;
    function CalcWidth: Extended;
    function LineHeight: Extended;
    function TextHeight: Extended;
    function GetFontHeight(aCanvas: TCanvas): Integer;
// returns the text that don't fit in the bounds
    function GetInBoundsText: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
    function GetOutBoundsText(var ParaBreak: Boolean): {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
    function UnusedSpace: Extended;

// call these methods before and after doing something
    procedure Lock;
    procedure Unlock;
    procedure LockCanvas;
    procedure UnlockCanvas;

    property Canvas: TCanvas read FCanvas;
    property DefPPI: Integer read FDefPPI;
    property ScrPPI: Integer read FScrPPI;
    property WrappedText: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF} read GetWrappedText;
    property UseDefaultCharset: Boolean read FUseDefaultCharset write FUseDefaultCharset;
    property UseMonoFont: Boolean read FMonoFont write FMonoFont;
    property Text: TWideStrings read FText;
    property VC: TVectorCanvas read FVC write FVC;
    property UseOldLineHeight: Boolean read FUseOldLineHeight write FUseOldLineHeight;

  end;

  function frxCreateRotatedFont(Font: TFont; Rotation: Integer): HFont;

var
  frxDrawText: TfrxDrawText;

implementation

uses
  frxPrinter, SyncObjs {added by Samuray}, frxPlatformServices;

var
  GraphCS: TCriticalSection;

const
  DefaultLineLen = 32768;
  {$IFDEF FPC}
  glasn: string = #$D0#$90#$D0#$95#$D0#$81#$D0#$98#$D0#$9E#$D0#$A3#$D0#$AB +
                  #$D0#$AD#$D0#$AE#$D0#$AF;

  soglasn: string = #$D0#$91#$D0#$92#$D0#$93#$D0#$94 +
                    #$D0#$96#$D0#$97#$D0#$99 +
                    #$D0#$9A#$D0#$9B#$D0#$9C#$D0#$9D +
                    #$D0#$9F#$D0#$A0#$D0#$A1#$D0#$A2 +
                    #$D0#$A4#$D0#$A5#$D0#$A6#$D0#$A7 +
                    #$D0#$A8#$D0#$A9#$D0#$AC#$D0#$AA;

  znaks: string =  #$D0#$AC#$D0#$AA;
  znaks1: string = #$D0#$99;
  {$ELSE}
  {$IFDEF Delphi12}
  glasn: string = #$410#$415#$401#$418#$41E#$423#$42B#$42D +
                  #$42E#$42F;

  soglasn: string = #$411#$412#$413#$414#$416#$417#$419 +
                    #$41A#$41B#$41C#$41D#$41F +
                    #$420#$421#$422#$424#$425#$426#$427 +
                    #$428#$429#$42C#$42A;

  znaks: string =  #$42C#$42A;
  znaks1: string = #$419;
  {$ELSE}
  glasn: string = #192#197#168#200#206#211#219#221#222#223;
  soglasn: string = #193#194#195#196#198#199#201#202#203 +
                    #204#205#207#208#209#210#212#213#214 +
                    #215#216#217#220#218;
  znaks: string = #220#218;
  znaks1: string = #201;
  {$ENDIF}
  {$ENDIF}

{ Правила переноса по слогам, принятые в русском языке, которые можно
  реализовать в виде алгоритма без словаря.

  1. При переносе слов нельзя ни оставлять в конце строки, ни переносить на
  другую строку часть слова, не составляющую слога; например, нельзя
  переносить просмо-тр, ст-рах.

  2. Нельзя отделять согласную от следующей за ней гласной.
  Неправильно  Правильно
  люб-овь      лю-бовь

  3. Нельзя отрывать буквы ь и ъ от предшествующей согласной.
  Неправильно  Правильно
  бол-ьшой     боль-шой

  4. Нельзя отрывать букву й от предшествующей гласной.
  Неправильно  Правильно
  во-йна       вой-на

  5. Нельзя оставлять в конце строки или переносить на другую строку одну букву.
  Неправильно       Правильно
  а-кация, акаци-я  ака-ция

  6. Нельзя оставлять в конце строки или переносить в начало следующей две
  одинаковые согласные, стоящие между гласными.
  Неправильно  Правильно
  ко-нный      кон-ный }

{ Алгоритм возвращает номера символов строки, после которых можно ставить перенос }
function BreakRussianWord(const s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF}): String;
var
  i, j: Integer;
  CanBreak: Boolean;

  function Check1and5(const s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF}): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    if frxLength(s) >= 2 then
      for i := 1 to frxLength(s) do
        if frxPos(
          {$IFDEF FPC}frxCopy(s,i,1){$ELSE}s[i]{$ENDIF}, glasn) <> 0 then
        begin
          Result := True;
          break;
        end;
  end;

begin
  Result := '';
  if frxLength(s) < 4 then Exit;

  for i := 1 to frxLength(s) do
  begin
    CanBreak := False;
    if frxPos(
        {$IFDEF FPC}frxCopy(s,i,1){$ELSE}s[i]{$ENDIF}, soglasn) <> 0 then
    begin
      CanBreak := True;
      { 2 }
      if (i < frxLength(s)) and
         (frxPos(
           {$IFDEF FPC}frxCopy(s, i + 1, 1){$ELSE}s[i + 1]{$ENDIF}, glasn) <> 0) then
        CanBreak := False;
      { 3 }
      if (i < frxLength(s)) and
         (frxPos(
           {$IFDEF FPC}frxCopy(s, i + 1, 1){$ELSE}s[i + 1]{$ENDIF}, znaks) <> 0) then
        CanBreak := False;
    end;
    if frxPos(
      {$IFDEF FPC}frxCopy(s,i,1){$ELSE}s[i]{$ENDIF}, glasn) <> 0 then
    begin
      CanBreak := True;
      { 4 }
      if (i < frxLength(s)) and
        (frxPos(
          {$IFDEF FPC}frxCopy(s, i + 1, 1){$ELSE}s[i + 1]{$ENDIF}, znaks1) <> 0) then
        CanBreak := False;
      { 6 }
      if (i < frxLength(s) - 2) and
        (frxPos(
          {$IFDEF FPC}frxCopy(s, i + 1, 1){$ELSE}s[i + 1]{$ENDIF}, soglasn) <> 0) and
         ({$IFDEF FPC}frxCopy(s, i + 1, 1){$ELSE}s[i + 1]{$ENDIF} =
          {$IFDEF FPC}frxCopy(s, i + 2, 1){$ELSE}s[i + 2]{$ENDIF}) and
         (frxPos(
           {$IFDEF FPC}frxCopy(s, i + 3, 1){$ELSE}s[i + 3]{$ENDIF}, glasn) <> 0) then
        CanBreak := False;
    end;
    if CanBreak then
      Result := Result + Chr(i);
  end;

  { 1, 5 }
  for i := 1 to Length(Result) do
  begin
    j := Ord(Result[i]);
    if not (Check1and5(frxCopy(s, 1, j)) and Check1and5(frxCopy(s, j + 1, 255))) then
      Result[i] := #255;
  end;
  while Pos(#255, Result) <> 0 do
    Delete(Result, Pos(#255, Result), 1);
end;

procedure IncArray(Ar: PIntArray; x1, x2, n, one: Integer);
var
  xm: Integer;
begin
  if n <= 0 then Exit;
  xm := (x2 - x1 + 1) div 2;
  if xm = 0 then
    xm := 1;
  if n = 1 then
    Inc(Ar[x1 + xm - 1], one)
  else
  begin
    IncArray(Ar, x1, x1 + xm - 1, n div 2, one);
    IncArray(Ar, x1 + xm, x2, n - n div 2, one);
  end;
end;

function frxCreateRotatedFont(Font: TFont; Rotation: Integer): HFont;
var
  F: TLogFont;
begin
  GetObject(Font.Handle, SizeOf(TLogFont), @F);
  F.lfEscapement := Rotation * 10;
  F.lfOrientation := Rotation * 10;
  Result := CreateFontIndirect(F);
end;


{ TfrxHTMLTag }

procedure TfrxHTMLTag.Assign(Tag: TfrxHTMLTag);
begin
  Position := Tag.Position;
  Size := Tag.Size;
  AddY := Tag.AddY;
  Style := Tag.Style;
  Color := Tag.Color;
  Default := Tag.Default;
  Small := Tag.Small;
  Self.SubType := Tag.SubType;
end;


{ TfrxHTMLTags }

constructor TfrxHTMLTags.Create;
begin
  FItems := TList.Create;
end;

destructor TfrxHTMLTags.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

procedure TfrxHTMLTags.Clear;
var
  i: Integer;
begin
  for i := 0 to FItems.Count - 1 do
    TfrxHTMLTag(FItems[i]).Free;
  FItems.Clear;
end;

function TfrxHTMLTags.GetItems(Index: Integer): TfrxHTMLTag;
begin
  Result := TfrxHTMLTag(FItems[Index]);
end;

function TfrxHTMLTags.Count: Integer;
begin
  Result := FItems.Count;
end;

procedure TfrxHTMLTags.Add(Tag: TfrxHTMLTag);
begin
  FItems.Add(Tag);
end;


{ TfrxHTMLTagsList }

constructor TfrxHTMLTagsList.Create;
begin
  FItems := TList.Create;
  FAllowTags := True;
  //GetMem(FTempArray, SizeOf(Integer) * 32768);
  FTempArray := nil;
  FTempArraySize := 0;
  ReallocTempArray(DefaultLineLen);
end;

destructor TfrxHTMLTagsList.Destroy;
begin
  Clear;
  FItems.Free;
  //FreeMem(FTempArray, SizeOf(Integer) * 32768);
  FreeTempArray;
  inherited;
end;

procedure TfrxHTMLTagsList.Clear;
var
  i: Integer;
begin
  for i := 0 to FItems.Count - 1 do
    TfrxHTMLTags(FItems[i]).Free;
  FItems.Clear;
end;

procedure TfrxHTMLTagsList.NewLine;
begin
  if Count <> 0 then
    FItems.Add(TfrxHTMLTags.Create);
end;

procedure TfrxHTMLTagsList.ReallocTempArray(ANewSize: Integer);
begin
  if ANewSize <= FTempArraySize then Exit;
  if Assigned(FTempArray) then
    FreeTempArray;
  try
    GetMem(FTempArray, SizeOf(Integer) * ANewSize);
    FTempArraySize := ANewSize;
  except
    FTempArraySize := 0;
    raise;
  end;
end;

procedure TfrxHTMLTagsList.Wrap(TagsCount: Integer; AddBreak: Boolean);
var
  i: Integer;
  Line, OldLine: TfrxHTMLTags;
  NewTag: TfrxHTMLTag;
begin
  OldLine := Items[Count - 1];
  if OldLine.Count <= TagsCount then
    Exit;

  NewLine;
  Line := Items[Count - 1];
  for i := TagsCount to OldLine.Count - 1 do
    Line.Add(OldLine[i]);
  OldLine.FItems.Count := TagsCount;
  if AddBreak then
  begin
    NewTag := TfrxHTMLTag.Create;
    OldLine.FItems.Add(NewTag);
    NewTag.Assign(TfrxHTMLTag(OldLine.FItems[TagsCount - 1]))
  end
  else if Line[0].Default then
    Line[0].Assign(OldLine[TagsCount - 1]);
end;

function TfrxHTMLTagsList.Count: Integer;
begin
  Result := FItems.Count;
end;

function TfrxHTMLTagsList.GetItems(Index: Integer): TfrxHTMLTags;
begin
  Result := TfrxHTMLTags(FItems[Index]);
end;

function TfrxHTMLTagsList.Add: TfrxHTMLTag;
var
  i: Integer;
begin
  Result := TfrxHTMLTag.Create;
  i := Count - 1;
  if i = -1 then
  begin
    FItems.Add(TfrxHTMLTags.Create);
    i := 0;
  end;
  Items[i].Add(Result);
end;

function TfrxHTMLTagsList.GetPrevTag: TfrxHTMLTag;
var
  Tags: TfrxHTMLTags;
begin
  Result := nil;
  Tags := Items[Count - 1];
  if Tags.Count > 1 then
    Result := Tags[Tags.Count - 2]
  else if Count > 1 then
  begin
    Tags := Items[Count - 2];
    Result := Tags[Tags.Count - 1];
  end;
end;

procedure TfrxHTMLTagsList.SetDefaults(DefColor: TColor; DefSize: Integer;
  DefStyle: TFontStyles);
begin
  FDefColor := DefColor;
  FDefSize := DefSize;
  FDefStyle := DefStyle;
  FAddY := 0;
  FColor := FDefColor;
  FSize := FDefSize;
  FStyle := FDefStyle;
  FDontWRAP := False;
  FPosition := 1;
  FSubStyle := ssNormal;
  Clear;
end;

procedure TfrxHTMLTagsList.ExpandHTMLTags(var s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF});
var
  i, j, j1: Integer;
  b: Boolean;
  cl: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
  {$IFDEF FPC}
  fps:string;
  {$ENDIF}


  procedure AddTag;
  var
    Tag, PrevTag: TfrxHTMLTag;
  begin
    Tag := Add;
    Tag.Position := FPosition; // this will help us to get position in the original text
    Tag.Size := FSize;
    Tag.Style := FStyle;
    Tag.Color := FColor;
    Tag.AddY := FAddY;
    Tag.DontWRAP := FDontWRAP;
    Tag.SubType := FSubStyle;
// when "Default" changes, we need to set Font.Style, Size and Color
    if FAllowTags then
    begin
      PrevTag := GetPrevTag;
      if PrevTag <> nil then
        Tag.Default := (FStyle = PrevTag.Style) and
                       (FColor = PrevTag.Color) and
                       (FSize = PrevTag.Size) and (FAddY = PrevTag.AddY) and (FDontWRAP = PrevTag.DontWRAP)
      else
        Tag.Default := (FStyle = FDefStyle) and (FColor = FDefColor) and (FSize = FDefSize);
    end
    else
      Tag.Default := True;
    Tag.Small := FSize <> FDefSize;
  end;

begin
  i := 1;
  if frxLength(s) = 0 then
    Exit;

  while i <= frxLength(s) do
  begin
    b := True;

    if FAllowTags then
      if {$IFDEF FPC}frxCopy(s, i, 1){$ELSE}s[i]{$ENDIF} = '<' then
      begin

        // <b>, <u>, <i> tags
        if (i + 2 <= frxLength(s)) and
          ({$IFDEF FPC}frxCopy(s,i + 2, 1){$ELSE}s[i + 2]{$ENDIF} = '>') then
        begin
          {$IFDEF FPC}
            fps := frxUpperCase(frxCopy(s, i + 1, 1));
            if fps = 'B' then
              FStyle := FStyle + [fsBold]
            else if fps = 'I' then
              FStyle := FStyle + [fsItalic]
            else if fps = 'U' then
              FStyle := FStyle + [fsUnderline]
            else
              b := False;
          {$ELSE}
          case s[i + 1] of
            'b','B': FStyle := FStyle + [fsBold];
            'i','I': FStyle := FStyle + [fsItalic];
            'u','U': FStyle := FStyle + [fsUnderline];
            else
              b := False;
          end;
          {$ENDIF}
          if b then
          begin
            frxDelete(s, i, 3);
            Inc(FPosition, 3);
            continue;
          end;
        end

        // </b>, </u>, </i>, </strike>, </font>, </sub>, </sup> tags
        else if (i + 1 <= frxLength(s)) and
            ({$IFDEF FPC}frxCopy(s,i + 1, 1){$ELSE}s[i + 1]{$ENDIF} = '/') then
        begin
          if (i + 3 <= frxLength(s)) and
             ({$IFDEF FPC}frxCopy(s,i + 3, 1){$ELSE}s[i + 3]{$ENDIF} = '>') then
          begin
            {$IFDEF FPC}
              fps := frxUpperCase(frxCopy(s, i + 2, 1));
              if fps = 'B' then
                FStyle := FStyle - [fsBold]
              else if fps = 'I' then
                FStyle := FStyle - [fsItalic]
              else if fps = 'U' then
                FStyle := FStyle - [fsUnderline]
              else
                b := False;
            {$ELSE}
            case s[i + 2] of
              'b','B': FStyle := FStyle - [fsBold];
              'i','I': FStyle := FStyle - [fsItalic];
              'u','U': FStyle := FStyle - [fsUnderline];
              else
                b := False;
            end;
            {$ENDIF}
            if b then
            begin
              frxDelete(s, i, 4);
              Inc(FPosition, 4);
              continue;
            end;
          end
          else if (frxPos('STRIKE>',
             frxUpperCase(s)) = i + 2) then
          begin
            FStyle := FStyle - [fsStrikeOut];
            frxDelete(s, i, 9);
            Inc(FPosition, 9);
            continue;
          end
          else if (frxPos('NOWRAP>',
            frxUpperCase(s)) = i + 2) then
          begin
            FDontWRAP := False;
            frxDelete(s, i, 9);
            Inc(FPosition, 9);
            continue;
          end
          else if frxPos('FONT>',
            frxUpperCase(s)) = i + 2 then
          begin
            FColor := FDefColor;
            frxDelete(s, i, 7);
            Inc(FPosition, 7);
            continue;
          end
          else if (frxPos('SUB>',
               frxUpperCase(s)) = i + 2) or
            (frxPos('SUP>',
              frxUpperCase(s)) = i + 2) then
          begin
            FSize := FDefSize;
            FAddY := 0;
            FSubStyle := ssNormal;
            frxDelete(s, i, 6);
            Inc(FPosition, 6);
            continue;
          end
        end

        // <sub>, <sup> tags
        else if (i + 4 <= frxLength(s))
          and ({$IFDEF FPC}frxCopy(s,i + 4, 1){$ELSE}s[i + 4]{$ENDIF} = '>') then
        begin
          b := False;
          if frxPos('SUB>',
            frxUpperCase(s)) = i + 1 then
          begin
            FSize := Round(FDefSize / 1.5);
            FAddY := 1;
            b := True;
            FSubStyle := ssSubscript;
          end
          else if frxPos('SUP>',
            frxUpperCase(s)) = i + 1 then
          begin
            FSize := Round(FDefSize / 1.5);
            FAddY := 0;
            b := True;
            FSubStyle := ssSuperscript;
          end;
          if b then
          begin
            frxDelete(s, i, 5);
            Inc(FPosition, 5);
            continue;
          end;
        end

        // <sub>, <sup> tags
        else if (i + 5 <= frxLength(s)) and
           ({$IFDEF FPC}frxCopy(s,i + 5, 1){$ELSE}s[i + 5]{$ENDIF} = '>') then
        begin
          b := False;
          if (frxPos('/SUB>',
            frxUpperCase(s)) = i + 1) or
            (frxPos('/SUP>',
            frxUpperCase(s)) = i + 1) then
          begin
            FSize := FDefSize;
            FAddY := 0;
            b := True;
            FSubStyle := ssNormal;
          end;
          if b then
          begin
            frxDelete(s, i, 6);
            Inc(FPosition, 6);

            continue;
          end;
        end


        else if (i + 7 <= frxLength(s)) and
            (({$IFDEF FPC}frxCopy(s,i + 1, 1){$ELSE}s[i + 1]{$ENDIF} = 'n') or
            ({$IFDEF FPC}frxCopy(s,i + 1, 1){$ELSE}s[i + 1]{$ENDIF} = 'N')) then
        begin
          if frxPos('NOWRAP>',
             frxUpperCase(s)) = i + 1 then
          begin
            FDontWRAP := True;
            frxDelete(s, i, 8);
            Inc(FPosition, 8);
            continue;
          end;
        end

        // <strike> tag
        else if (i + 1 <= frxLength(s)) and
          (({$IFDEF FPC}frxCopy(s,i + 1, 1){$ELSE}s[i + 1]{$ENDIF} = 's') or
           ({$IFDEF FPC}frxCopy(s,i + 1, 1){$ELSE}s[i + 1]{$ENDIF} = 'S')) then
        begin
          if frxPos('STRIKE>',
            frxUpperCase(s)) = i + 1 then
          begin
            FStyle := FStyle + [fsStrikeOut];
            frxDelete(s, i, 8);
            Inc(FPosition, 8);
            continue;
          end;
        end

  // <font color = ...> tag
        else if frxPos('FONT COLOR',
          frxUpperCase(s)) = i + 1 then
        begin
          j := i + 11;
          while (j <= frxLength(s))
             and ({$IFDEF FPC}frxCopy(s,j, 1){$ELSE}s[j]{$ENDIF} <> '=') do
            Inc(j);
          Inc(j);
          while (j <= frxLength(s))
             and ({$IFDEF FPC}frxCopy(s,j, 1){$ELSE}s[j]{$ENDIF} = ' ') do
            Inc(j);
          j1 := j;
          while (j <= frxLength(s))
             and ({$IFDEF FPC}frxCopy(s,j, 1){$ELSE}s[j]{$ENDIF} <> '>') do
            Inc(j);

          cl := frxCopy(s, j1, j - j1);
          if cl <> '' then
          begin
            if (frxLength(cl) > 3)
              and (cl[1] = '"') and (cl[2] = '#') and
              (cl[Length(cl)] = '"') then
            begin
              cl := '$' + Copy(cl, 3, Length(cl) - 3);
              FColor := StrToInt(cl);
              FColor := (FColor and $00FF0000) div 65536 +
                        (FColor and $000000FF) * 65536 +
                        (FColor and $0000FF00);
              frxDelete(s, i, j - i + 1);
              Inc(FPosition, j - i + 1);
              continue;
            end
            else if IdentToColor('cl' + cl, FColor) then
            begin
              frxDelete(s, i, j - i + 1);
              Inc(FPosition, j - i + 1);
              continue;
            end;
          end;
        end
      end;

    AddTag;
    Inc(i);
    Inc(FPosition);
  end;

  if Length(s) = 0 then
  begin
    AddTag;
    s := ' ';
  end;
end;

function TfrxHTMLTagsList.FillCharSpacingArray(var ar: PIntArray; const s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
  Canvas: TCanvas; LineIndex, Add: Integer; Convert: Boolean; DefCharset: Boolean): Integer;
var
  i, n, addI: Integer;
  Tags: TfrxHTMLTags;
  Tag: TfrxHTMLTag;
  AnsiStr: AnsiString;
  AddNext, Is2ByteCodepage: Boolean;

  {$IFDEF FPC}
  procedure BreakArray;
  var
    i, j, offs: Integer;
    Size: TSize;
  begin
    if DefCharset then // we always assume defcharset under lcl
    begin
      GetTextExtentExPoint(Canvas.Handle, PAnsiChar(AnsiStr), Length(s), 0, nil,
        @FTempArray[0], Size);
    end
    else
      GetTextExtentExPointW(Canvas.Handle, PWideChar(s), Length(s), 0, nil,
        @FTempArray[0], Size);
    i := 0;
    repeat
      if FTempArray[i] = 32767 then
      begin
        offs := FTempArray[i - 1];
        if DefCharset then
        begin
          GetTextExtentExPoint(Canvas.Handle, PAnsiChar(AnsiStr) + i, Length(s) - i, 0, nil,
            @FTempArray[i], Size);
        end
        else
          GetTextExtentExPointW(Canvas.Handle, PWideChar(s) + i, Length(s) - i, 0, nil,
            @FTempArray[i], Size);
        for j := i to n - 1 do
          if FTempArray[j] = 32767 then
          begin
            i := j - 1;
            break;
          end
          else
            FTempArray[j] := FTempArray[j] + offs;
      end;
      Inc(i);
    until i >= n;
  end;
  {$ELSE}
  procedure BreakArray;
  var
    i, j, offs: Integer;
    Size: TSize;
  begin
    if {(Win32Platform <> VER_PLATFORM_WIN32_NT) or ((Canvas.Font.Charset <> DEFAULT_CHARSET) and not FUseDefaultCharset)} DefCharset then
    begin
      GetTextExtentExPointA(Canvas.Handle, PAnsiChar(AnsiStr), n, 0, nil,
        @FTempArray[0], Size);
    end
    else
      GetTextExtentExPointW(Canvas.Handle, PWideChar(s), n, 0, nil,
        @FTempArray[0], Size);
    i := 0;
    repeat
      if FTempArray[i] = 32767 then
      begin
        offs := FTempArray[i - 1];
        if {(Win32Platform <> VER_PLATFORM_WIN32_NT) or ((Canvas.Font.Charset <> DEFAULT_CHARSET) and not FUseDefaultCharset)} DefCharset then
        begin
          GetTextExtentExPointA(Canvas.Handle, PAnsiChar(AnsiStr) + i, n - i, 0, nil,
            @FTempArray[i], Size);
        end
        else
          GetTextExtentExPointW(Canvas.Handle, PWideChar(s) + i, n - i, 0, nil,
            @FTempArray[i], Size);
        for j := i to n - 1 do
          if FTempArray[j] = 32767 then
          begin
            i := j - 1;
            break;
          end
          else
            FTempArray[j] := FTempArray[j] + offs;
      end;
      Inc(i);
    until i >= n;
  end;
  {$ENDIF}

begin
  Result := 0;
  {$IFDEF FPC}
  DefCharset := True;
  {$ELSE}
  DefCharset := (Win32Platform <> VER_PLATFORM_WIN32_NT) or ((Canvas.Font.Charset <> DEFAULT_CHARSET) and not DefCharset);
  {$ENDIF}
  addI := 0;
  AddNext := True;
  Is2ByteCodepage := False;
  if {((Canvas.Font.Charset <> DEFAULT_CHARSET) and not FUseDefaultCharset) or (Win32Platform <> VER_PLATFORM_WIN32_NT)} DefCharset then
  begin
    AnsiStr := _UnicodeToAnsi(s, Canvas.Font.Charset);
    n := Length(AnsiStr);
    Is2ByteCodepage := (n > Length(s))
  end
  else n := frxLength(s);
  {$IFDEF FPC}
  n := frxLength(s);
  {$ENDIF}
  ReallocTempArray(n);
  Tags := Items[LineIndex];
  Tag := Tags.Items[0];
  if not Tag.Default then
    Canvas.Font.Style := Tag.Style;

  BreakArray;

  for i := 0 to n - 1 do
  begin
    Tag := Tags.Items[i - addI];
    if (i <> 0) and not Tag.Default then
    begin
      Canvas.Font.Style := Tag.Style;
      BreakArray;
    end;

    { needs for some codepage like CHINESEBIG5_CHARSET, }
    { for spec. characters it use two bytes like in UTF8, }
    { but FHTMLTags works only with unicode, and we correct index here}
    if Is2ByteCodepage and (Byte(AnsiStr[i + 1]) > $7F) and AddNext then
    begin
      Inc(addI);
      AddNext := False;
    end
    else AddNext := True;

    if i > 0 then
      Ar[i] := FTempArray[i] - FTempArray[i - 1] + Add else
      Ar[i] := FTempArray[i] + Add;
    if Tag.Small then
      Ar[i] := Round(Ar[i] / 1.5);
    Inc(Result, Ar[i]);
    if Convert and (i > 0) then
      Inc(Ar[i], Ar[i - 1]);
  end;
end;


procedure TfrxHTMLTagsList.FreeTempArray;
begin
  FreeMem(FTempArray, SizeOf(Integer) * FTempArraySize);
end;

{ TfrxDrawText }

constructor TfrxDrawText.Create;
begin
  FBMP := TBitmap.Create;
  FCanvas := FBMP.Canvas;
  FDefPPI := 600;
  FScrPpi := 96;
  FHTMLTags := TfrxHTMLTagsList.Create;
{$IFDEF Delphi10}
  FText := TfrxWideStrings.Create;
{$ELSE}
  FText := TWideStrings.Create;
{$ENDIF}
  FWysiwyg := True;
  FMonoFont := False;
  FTempArraySize := 0;
  FTempArray := nil;
  ReallocTempArray(DefaultLineLen);
  VC := nil;
  FUseOldLineHeight := True;
end;

destructor TfrxDrawText.Destroy;
begin
  FBMP.Free;
  FHTMLTags.Free;
  FText.Free;
  FreeTempArray;
  inherited;
end;

procedure TfrxDrawText.SetFont(Font: TFont);
var
  h: Integer;
begin
  FFontSize := Font.Size;
  h := -Round(FFontSize * FDefPPI / 72);  // height is as in the 600 dpi printer
  FCanvas.Lock;
  try
    with FCanvas.Font do
    begin
      if Name <> Font.Name then
        Name := Font.Name;
      if Height <> h then
        Height := h;
      if Style <> Font.Style then
        Style := Font.Style;
      if Charset <> Font.Charset then
        Charset := Font.Charset;
      if FMonoFont then
        Color := clBlack
      else
        if Color <> Font.Color then
          Color := Font.Color;
    end;
  finally
    FCanvas.Unlock;
  end;
end;

procedure TfrxDrawText.SetOptions(WordWrap, HTMLTags, RTLReading,
  WordBreak, Clipped, Wysiwyg: Boolean; Rotation: Integer);
begin
  FWordWrap := WordWrap;
  FHTMLTags.AllowTags := HTMLTags;
  FRTLReading := RTLReading;
  FOptions := 0;
  {$IFNDEF FPC}
  if RTLReading then
    FOptions := ETO_RTLREADING;
  {$ENDIF}
  if Clipped then
    FOptions := FOptions or ETO_CLIPPED;
  FWordBreak := WordBreak;
  FRotation := Rotation mod 360;
  FWysiwyg := Wysiwyg;
end;

procedure TfrxDrawText.SetDimensions(ScaleX, ScaleY, PrintScale: Extended;
  OriginalRect, ScaledRect: TRect);
begin
  FScaleX := ScaleX;
  FScaleY := ScaleY;
  FPrintScale := PrintScale;
  FOriginalRect := OriginalRect;
  FScaledRect := ScaledRect;
end;

procedure TfrxDrawText.SetGaps(ParagraphGap, CharSpacing, LineSpacing: Extended);
begin
  FParagraphGap := ParagraphGap;
  FCharSpacing := CharSpacing;
  FLineSpacing := LineSpacing;
end;

procedure TfrxDrawText.SetText(Text: TWideStrings; FirstParaBreak: Boolean);
var
  i, j, n, Width: Integer;
  s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
  Style: TFontStyles;
  FPPI: Extended;
begin
  FCanvas.Lock;
  try
    FPlainText := '';
    FText.Clear;
  finally
    FCanvas.Unlock;
  end;

  n := Text.Count;
  if n = 0 then Exit;

  FCanvas.Lock;
  try
  // set up html engine
    FHTMLTags.SetDefaults(FCanvas.Font.Color, FFontSize, FCanvas.Font.Style);
    Style := FCanvas.Font.Style;

  // width of the wrap area
    Width := FOriginalRect.Right - FOriginalRect.Left;
    if ((FRotation >= 90) and (FRotation < 180)) or
       ((FRotation >= 270) and (FRotation < 360)) then
      Width := FOriginalRect.Bottom - FOriginalRect.Top;

    for i := 0 to n - 1 do
    begin
      j := FText.Count;
      s := Text[i];
      if s = '' then
        s := ' ';
      FPlainText := FPlainText + s + #13#10;
      FPPI := FDefPPI / FScrPPI;
      if (not FirstParaBreak) or (i > 0) then
        WrapTextLine(s,
          Round(Width * FPPI),
          Round((Width - FParagraphGap) * FPPI),
          Round(FCharSpacing * FPPI))
      else
        WrapTextLine(s,
          Round(Width * FPPI),
          Round(Width * FPPI),
          Round(FCharSpacing * FPPI));
      if FText.Count <> j then
      begin
        FText.Objects[j] := Pointer(1);                 // mark the begin of paragraph:
        if FText.Count - 1 = j then                     // it will be needed in DrawText
          FText.Objects[j] := Pointer(3) else           // both begin and end at one line
          FText.Objects[FText.Count - 1] := Pointer(2); // mark the end of paragraph
      end;
    end;

    FCanvas.Font.Style := Style;
  finally
    FCanvas.Unlock;
  end;
end;

procedure TfrxDrawText.SetParaBreaks(FirstParaBreak, LastParaBreak: Boolean);
begin
  if FText.Count = 0 then Exit;

  if FirstParaBreak then
    FText.Objects[0] := Pointer(Integer(FText.Objects[0]) and not 1);
  if LastParaBreak then
    FText.Objects[FText.Count - 1] := Pointer(Integer(FText.Objects[FText.Count - 1]) and not 2);
end;

function TfrxDrawText.DeleteTags(const Txt: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF}): {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
begin
  Result := Txt;
  FHTMLTags.ExpandHTMLTags(Result);
end;

procedure TfrxDrawText.WrapTextLine(s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
  Width, FirstLineWidth, CharSpacing: Integer);
var
  n, i, Offset, LineBegin, LastSpace, BreakPos: Integer;
  sz: TSize;
  TheWord: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
  WasBreak: Boolean;
  Tag: TfrxHTMLTag;
  addI: Integer;
  Is2ByteCodepage: Boolean;
  AnsiStr: AnsiString;

  function BreakWord(const s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF}; LineBegin, CurPos, LineEnd: Integer): {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
  var
    i, BreakPos: Integer;
    TheWord, Breaks: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
  begin
    // get the whole word
    i := CurPos;
    while (i <= LineEnd) and
       (frxPos(
         {$IFDEF FPC}frxCopy(s, i, 1){$ELSE}s[i]{$ENDIF}, ' .,-;') = 0) do
      Inc(i);
    TheWord := frxCopy(s, LineBegin, i - LineBegin);
    // get available break positions
    Breaks := BreakRussianWord(frxUpperCase(TheWord));
    // find the closest position
    BreakPos := CurPos - LineBegin;
    for i := Length(Breaks) downto 1 do
      if Ord(Breaks[i]) < BreakPos then
      begin
        BreakPos := Ord(Breaks[i]);
        break;
      end;
    if BreakPos <> CurPos - LineBegin then
      Result := frxCopy(TheWord, 1, BreakPos) else
      Result := '';
  end;

begin
// remove all HTML tags and build the tag list
  FHTMLTags.NewLine;
  FHTMLTags.ExpandHTMLTags(s);
  FHTMLTags.FPosition := FHTMLTags.FPosition + 2;

  Is2ByteCodepage := False;
  if (Win32Platform <> VER_PLATFORM_WIN32_NT) or ((Canvas.Font.Charset <> DEFAULT_CHARSET) and not FUseDefaultCharset) then
  begin
    AnsiStr := _UnicodeToAnsi(s, Canvas.Font.Charset);
    n := Length(AnsiStr);
    Is2ByteCodepage := (n > Length(s))
  end;

  n := frxLength(s);
  if (n < 2) or not FWordWrap then  // no need to wrap a string with 0 or 1 symbol
  begin
    FText.Add(s);
    Tag := FHTMLTags.Items[FHTMLTags.Count - 1].Items[0];
    if not Tag.Default then
      Canvas.Font.Style := Tag.Style;
    Exit;
  end;

// get the intercharacter spacing table and calculate the width
  FCanvas.Lock;
  try
    ReallocTempArray(n);
    sz.cx := FHTMLTags.FillCharSpacingArray(FTempArray, s, FCanvas,
      FHTMLTags.Count - 1, CharSpacing, True, {$IFDEF JPN}true{$ELSE}FUseDefaultCharset{$ENDIF});
  finally
    FCanvas.Unlock;
  end;

// text fits, no need to wrap it
  if sz.cx < FirstLineWidth then
  begin
    FText.Add(s);
    Exit;
  end;
  addI := 0;
  Offset := 0;
  i := 1;
  LineBegin := 1; // index of the first symbol in the current line
  LastSpace := 1; // index of the last space symbol in the current line

  while i <= n do
  begin
    if ({$IFDEF FPC}frxCopy(s, i, 1){$ELSE}s[i]{$ENDIF} = ' ') then
      if (FHTMLTags.AllowTags) and (FHTMLTags.Count > 0) then
      begin
        if (not FHTMLTags[FHTMLTags.Count - 1].Items[i - LineBegin].DontWRAP) then
          LastSpace := i;
      end
      else
        LastSpace := i;



    if FTempArray[i - 1 + addI] - Offset > FirstLineWidth then  // need wrap
    begin
      if LastSpace = LineBegin then  // there is only one word without spaces...
      begin
        if i <> LineBegin then       // ... and it has more than 1 symbol
        begin
          if FWordBreak then
          begin
            TheWord := BreakWord(s, LineBegin, i, n);
            WasBreak := TheWord <> '';
            if not WasBreak then
              TheWord := frxCopy(s, LineBegin, i - LineBegin);
            if WasBreak then
              FText.Add(TheWord + '-') else
              FText.Add(TheWord);
            BreakPos := frxLength(TheWord);
            FHTMLTags.Wrap(BreakPos, WasBreak);
            LastSpace := LineBegin + BreakPos - 1;
          end
          else
          begin
            FText.Add(frxCopy(s, LineBegin, i - LineBegin));
            FHTMLTags.Wrap(i - LineBegin, False);
            LastSpace := i - 1;
          end;
        end
        else
        begin
          FText.Add({$IFDEF FPC}frxCopy(s, LineBegin, 1){$ELSE}s[LineBegin]{$ENDIF}); // can't wrap 1 symbol, just add it to the new line
          FHTMLTags.Wrap(1, False);
        end;
      end
      else // we have a space symbol inside
      begin
        if FWordBreak then
        begin
          TheWord := BreakWord(s, LastSpace + 1, i, n);
          WasBreak := TheWord <> '';
          if WasBreak then
            FText.Add(frxCopy(s, LineBegin, LastSpace - LineBegin + 1) + TheWord + '-') else
            FText.Add(frxCopy(s, LineBegin, LastSpace - LineBegin));
          BreakPos := LastSpace - LineBegin + frxLength(TheWord) + 1;
          FHTMLTags.Wrap(BreakPos, WasBreak);
          if WasBreak then
            LastSpace := LineBegin + BreakPos - 1;
        end
        else
        begin
          FText.Add(frxCopy(s, LineBegin, LastSpace - LineBegin));
          FHTMLTags.Wrap(LastSpace - LineBegin + 1, False);
        end;
      end;

      Offset := FTempArray[LastSpace - 1 + addI]; // starting a new line
      i := LastSpace;
      Inc(LastSpace);
      LineBegin := LastSpace;
      FirstLineWidth := Width; // this line is not first, so use Width
    end;

    { needs for some codepage like CHINESEBIG5_CHARSET, }
    { for spec. characters it uses two bytes like in UTF8, }
    { Index correction }
    if Is2ByteCodepage and (i + 1 <= n) and (Byte(AnsiStr[i + 1 + addI]) > $7F) then
      Inc(addI);
    Inc(i);
  end;

  if n - LineBegin + 1 > 0 then   // put the rest of line to FText
    FText.Add(frxCopy(s, LineBegin, n - LineBegin + 1));
end;

procedure TfrxDrawText.DrawTextLine(C: TCanvas; const s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
  X, Y, DX, LineIndex: Integer; Align: TfrxHAlign; var fh, oldfh: HFont);
var
  spaceAr: PIntArray;
  n, i, j, cw, neededSize, extraSize, spaceCount: Integer;
  add1, add2, add3, addCount, addI : Integer;
  ratio: Extended;
  Sz, prnSz, PPI: Integer;
  Tag: TfrxHTMLTag;
  CosA, SinA: Extended;
  Style: TFontStyles;
  FPPI: Extended;
  AnsiStr: AnsiString;
  AddNext, Is2ByteCodepage: Boolean;
  {$IFDEF FPC}
   i1,j1:Integer;
  {$ENDIF}

  function CountSpaces: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to n - 1 do
    begin
      spaceAr[i] := 0;
      if ({$IFDEF FPC}frxCopy(s, i + 1, 1){$ELSE}s[i + 1]{$ENDIF} = ' ') or
         ({$IFDEF FPC}frxCopy(s, i + 1, 1){$ELSE}s[i + 1]{$ENDIF} = #$00A0) then
      begin
        Inc(Result);
        spaceAr[i] := 1;
      end;
    end;
  end;

  function CalcWidth(Index, Count: Integer): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := Index to Index + Count - 1 do
      Result := Result + FTempArray[i];
  end;

begin
  Is2ByteCodepage := False;
  addI := 0;
  AddNext := True;
  if{$IFNDEF FPC} ((C.Font.Charset <> DEFAULT_CHARSET) and not FUseDefaultCharset)
   or (Win32Platform <> VER_PLATFORM_WIN32_NT) {$ELSE} True {$ENDIF} then
  begin
    AnsiStr := _UnicodeToAnsi(s, C.Font.Charset);
    n := Length(AnsiStr);
    Is2ByteCodepage := (n > Length(s));
    {$IFDEF FPC}
    Is2ByteCodepage := False;
    n := frxLength(s);
    {$ENDIF}
  end
  else n := Length(s);

  if n = 0 then Exit;

  spaceAr := nil;
  FCanvas.Lock;

  try
    ReallocTempArray(n);
    Style := C.Font.Style;
    FHTMLTags.FDefStyle := Style;
    FCanvas.Font.Style := Style;
    FPPI := FDefPPI / FScrPPI;

    PrnSz := FHTMLTags.FillCharSpacingArray(FTempArray, s, FCanvas, LineIndex,
      Round(FCharSpacing * FPPI), False, FUseDefaultCharset) - Round(FCharSpacing * FPPI);
    Sz := FHTMLTags.FillCharSpacingArray(FTempArray, s, C, LineIndex,
      Round(FCharSpacing * FScaleX), False, FUseDefaultCharset) - Round(FCharSpacing * FScaleX);                      //!Den
    C.Font.Style := Style;
    if FHTMLTags.AllowTags and (FRotation <> 0) then
    begin
      SelectObject(C.Handle, oldfh);
      DeleteObject(fh);
      fh := frxCreateRotatedFont(C.Font, FRotation);
      oldfh := SelectObject(C.Handle, fh);
    end;

    {$IFDEF LCLGTK2}
    if IsPrinter(C) then
        PPI := frxPrinters.Printer.CUPSPrinter.XDPI
      else
        PPI := GetDeviceCaps(C.Handle, LOGPIXELSX);
    {$ELSE}
    PPI := GetDeviceCaps(C.Handle, LOGPIXELSX);
    {$ENDIF}

    if PPI = 0 then
      PPI := 96;
    ratio := FDefPPI / PPI;
    if IsPrinter(C) then
      neededSize := Round(prnSz * FPrintScale / ratio) else
      neededSize := Round(prnSz / (FDefPPI / 96) * FScaleX);
    if not FWysiwyg then
      neededSize := Sz;
    extraSize := neededSize - Sz;

    CosA := Cos(pi / 180 * FRotation);
    SinA := Sin(pi / 180 * FRotation);
    if Align = haRight then
    begin
      X := x + Round((dx - neededSize + 1) * CosA);
      Y := y - Round((dx - neededSize + 1) * SinA);

      Dec(X, 1);
      if (fsBold in Style) or (fsItalic in Style) then
        if FRotation = 0 then
          Dec(X, 1);
    end
    else if Align = haCenter then
    begin
      X := x + Round((dx - neededSize) / 2 * CosA);
      Y := y - Round((dx - neededSize) / 2 * SinA);
    end;


    if Align = haBlock then
    begin
      GetMem(spaceAr, SizeOf(Integer) * n);
      spaceCount := CountSpaces;
      if spaceCount = 0 then
        Align := haLeft else
        extraSize := Abs(dx) - Sz;
    end
    else
      spaceCount := 0;

    if extraSize < 0 then
    begin
      extraSize := -extraSize;
      add3 := -1;
    end
    else
      add3 := 1;

    if Align <> haBlock then
    begin
      if extraSize < n then
        IncArray(FTempArray, 0, n - 1, extraSize, add3)
      else
      begin
        add1 := extraSize div n * add3;
        for i := 0 to n - 1 do
          Inc(FTempArray[i], add1);
        IncArray(FTempArray, 0, n - 1, extraSize - add1 * n * add3, add3)
      end;
    end
    else
    begin
      add1 := extraSize div spaceCount;
      add2 := extraSize mod spaceCount;
      addCount := 0;
      for i := 0 to n - 1 do
        if spaceAr[i] = 1 then
        begin
          Inc(FTempArray[i], add1 * add3);
          if addCount <= add2 then
          begin
            Inc(FTempArray[i], add3);
            Inc(addCount);
          end;
        end;
    end;


    i := 0;
    Tag := FHTMLTags[LineIndex].Items[0];
    add1 := Round(Tag.AddY * Tag.Size * FScaleY);

    repeat
      j := i;
      while i < n do
      begin
        Tag := FHTMLTags[LineIndex].Items[i - addI];
        if not Tag.Default then
        begin
          Tag.Default := True;
          break;
        end;
        { needs for some codepage like CHINESEBIG5_CHARSET, }
        { for spec. characters it use two bytes like in UTF8, }
        { but FHTMLTags works only with unicode, and we correct index here}
        if Is2ByteCodepage and (Byte(AnsiStr[i + 1]) > $7F) and AddNext then
        begin
          Inc(addI);
          AddNext := False;
        end
        else AddNext := True;
        Inc(i);
      end;
      {$IFDEF FPC}
      if n = Length(s) then
      begin
        j1 := j;
        i1 := i;
      end
      else
      begin
        if i > 0 then
        i1 := UTF8CharToByteIndex(PChar(s),Length(s),i)
        else
          i1 := 0;
        if j <> 0 then
         j1 := UTF8CharToByteIndex(PChar(s),Length(s),j)
        else
        j1 := 0;
      end;
      {$ENDIF}

      if ((C.Font.Charset = DEFAULT_CHARSET) or FUseDefaultCharset)
      {$IFNDEF FPC} and (Win32Platform = VER_PLATFORM_WIN32_NT) {$ENDIF} then
        if FWysiwyg then
          {$IFDEF FPC}
          {$IFDEF LCLGTK2}
          if IsPrinter(C) then
            C.TextRect(FScaledRect, X + Round(add1 * SinA), Y + Round(add1 * CosA),
               s, C.TextStyle)
          else
            ExtTextOutExtra(C, X + Round(add1 * SinA), Y + Round(add1 * CosA),
              FOptions, @FScaledRect, PChar(s) + j1, i1 - j1, @FTempArray^[j])
          {$ELSE}
          ExtTextOutExtra(C, X + Round(add1 * SinA), Y + Round(add1 * CosA),
            FOptions, @FScaledRect, PChar(s) + j1, i1 - j1, @FTempArray^[j])
          {$ENDIF}
          {$ELSE}
        begin
          ExtTextOutW(C.Handle, X + Round(add1 * SinA), Y + Round(add1 * CosA),
            FOptions, @FScaledRect, PWideChar(s) + j, i - j, @FTempArray[j]);
          if VC <> nil then
            VC.ExtTextOutW(X + Round(add1 * SinA), Y + Round(add1 * CosA),
              FOptions, @FScaledRect, PWideChar(s) + j, i - j, @FTempArray[j]);
        end
          {$ENDIF}
        else
          {$IFDEF FPC}
          {$IFDEF LCLGTK2}
          if IsPrinter(C) then
            C.TextRect(FScaledRect, X + Round(add1 * SinA), Y + Round(add1 * CosA),
               s, C.TextStyle)
          else
            ExtTextOutExtra(C, X + Round(add1 * SinA), Y + Round(add1 * CosA),
              FOptions, @FScaledRect, PChar(s) + j1, i1 - j1, nil)
          {$ELSE}
          ExtTextOutExtra(C, X + Round(add1 * SinA), Y + Round(add1 * CosA),
            FOptions, @FScaledRect, PChar(s) + j1, i1 - j1, nil)
          {$ENDIF}
          {$ELSE}
          ExtTextOutW(C.Handle, X + Round(add1 * SinA), Y + Round(add1 * CosA),
            FOptions, @FScaledRect, PWideChar(s) + j, i - j, nil)
          {$ENDIF}
      else
        {AnsiStr := _UnicodeToAnsi(s, C.Font.Charset);
        if C.Font.Charset = OEM_CHARSET then
          AnsiStr := OemToStr(AnsiStr);}
        if FWysiwyg then
          {$IFDEF FPC}
          {$IFDEF LCLGTK2}
          if IsPrinter(C) then
            C.TextRect(FScaledRect, X + Round(add1 * SinA), Y + Round(add1 * CosA),
               AnsiStr, C.TextStyle)
          else
            ExtTextOutExtra(C, X + Round(add1 * SinA), Y + Round(add1 * CosA),
              FOptions, @FScaledRect, PChar(AnsiStr) + j1, i1 - j1, @FTempArray^[j])
          {$ELSE}
          ExtTextOutExtra(C, X + Round(add1 * SinA), Y + Round(add1 * CosA),
            FOptions, @FScaledRect, PChar(AnsiStr) + j1, i1 - j1, @FTempArray^[j])
          {$ENDIF}
          {$ELSE}
        begin
          ExtTextOutA(C.Handle, X + Round(add1 * SinA), Y + Round(add1 * CosA),
            FOptions, @FScaledRect, PAnsiChar(AnsiStr) + j, i - j , @FTempArray[j]);
          if VC <> nil then
            VC.ExtTextOutA(X + Round(add1 * SinA), Y + Round(add1 * CosA),
             FOptions, @FScaledRect, PAnsiChar(AnsiStr) + j, i - j, @FTempArray[j]);
        end
          {$ENDIF}
        else
          {$IFDEF FPC}
          {$IFDEF LCLGTK2}
          if IsPrinter(C) then
            C.TextRect(FScaledRect, X + Round(add1 * SinA), Y + Round(add1 * CosA),
               AnsiStr, C.TextStyle)
          else
            ExtTextOutExtra(C, X + Round(add1 * SinA), Y + Round(add1 * CosA),
              FOptions, @FScaledRect, PChar(AnsiStr) + j1, i1 - j1, nil);
          {$ELSE}
          ExtTextOutExtra(C, X + Round(add1 * SinA), Y + Round(add1 * CosA),
            FOptions, @FScaledRect, PChar(AnsiStr) + j1, i1 - j1, nil);
          {$ENDIF}
          {$ELSE}
          ExtTextOutA(C.Handle, X + Round(add1 * SinA), Y + Round(add1 * CosA),
            FOptions, @FScaledRect, PAnsiChar(AnsiStr) + j, i - j, nil);
          {$ENDIF}
      if i < n then
      begin
        if IsPrinter(C) then
          C.Font.Height := -Round(Tag.Size * PPI * FPrintScale / 72) else
          C.Font.Height := -Round(Tag.Size * FScaleY * 96 / 72);
        C.Font.Style := Tag.Style;
        if FMonoFont then
          C.Font.Color := clBlack
        else
          C.Font.Color := Tag.Color;
        add1 := Round(Tag.AddY * Tag.Size * FScaleY);

        cw := CalcWidth(j, i - j);
        if FRotation = 0 then
          X := X + cw
        else
        begin
          X := X + Round(cw * CosA);
          Y := Y - Round(cw * SinA);

          SelectObject(C.Handle, oldfh);
          DeleteObject(fh);
          fh := frxCreateRotatedFont(C.Font, FRotation);
          oldfh := SelectObject(C.Handle, fh);
        end;
      end;
    until i >= n;

    if spaceAr <> nil then
      FreeMem(spaceAr, SizeOf(Integer) * n);

  finally
    FCanvas.Unlock;
  end;
end;

procedure TfrxDrawText.FreeTempArray;
begin
  FreeMem(FTempArray, SizeOf(Integer) * FTempArraySize);
end;

procedure TfrxDrawText.DrawText(C: TCanvas; HAlign: TfrxHAlign; VAlign: TfrxVAlign; UnderlinesTextMode: TfrxUnderlinesTextMode = ulmNone);
var
  Ar: PIntArray;
  i, j, n, neededSize, extraSize, add1, add3: Integer;
  ratio: Extended;
  al: TfrxHAlign;
  x, y, par: Integer;
  Sz, prnSz, LineSz: Integer;
  Tag: TfrxHTMLTag;
  fh, oldfh: HFont;
  h, PPI, dx, gx: Integer;
  CosA, SinA: Extended;

  procedure CalcRotatedCoords;
  var
    AbsCosA, AbsSinA: Extended;
    dy: Integer;
    LastLineCorr: Integer;
  begin
    FRotation := (FRotation + 360) mod 360;
    CosA := Cos(pi / 180 * FRotation);
    SinA := Sin(pi / 180 * FRotation);
    AbsCosA := Abs(CosA);
    AbsSinA := Abs(SinA);
    LastLineCorr := neededSize;
    dy := 0;
    with FScaledRect do
      case FRotation of
        0:
          begin
            x := Left;
            y := Top;
            dx := Right - Left;
            dy := Bottom - Top;
          end;

        1..89:
          begin
            x := Left;
            dx := Round((Right - Left - neededsize * AbsSinA) / AbsCosA);
            y := Top + Round(dx * AbsSinA);
            dy := Bottom - y - Round(neededsize * AbsCosA) + neededsize;
            CosA := 1; SinA := 0;
          end;

        90:
          begin
            x := Left;
            y := Bottom;
            dx := Bottom - Top;
            dy := Right - Left;
          end;

        91..179:
          begin
            y := Bottom;
            dx := Round((Right - Left - neededsize * AbsSinA) / AbsCosA);
            x := Left + Round(dx * AbsCosA);
            dy := Bottom - Top - Round(neededsize * AbsCosA + dx * AbsSinA) + neededsize;
            CosA := -1; SinA := 0;
          end;

        180:
          begin
            x := Right;
            y := Bottom;
            dx := Right - Left;
            dy := Bottom - Top;
          end;

        181..269:
          begin
            x := Right;
            dx := Round((Right - Left - neededsize * AbsSinA) / AbsCosA);
            y := Bottom - Round(dx * AbsSinA);
            dy := y - Top - Round(neededsize * AbsCosA) + neededsize;
            CosA := -1; SinA := 0;
          end;

        270:
          begin
            x := Right;
            y := Top;
            dx := Bottom - Top;
            dy := Right - Left;
          end;

        271..359:
          begin
            y := Top;
            dx := Round((Right - Left - neededsize * AbsSinA) / AbsCosA);
            x := Left + Round(neededsize * AbsSinA);
            dy := Bottom - Top - Round(dx * AbsSinA + neededsize * AbsCosA) + neededsize;
            CosA := 1; SinA := 0;
          end;
      end;
    { Correction of last line for LineSpacing less than 0, need to do more test of this }
    if (FLineSpacing < 0) and (VAlign <> vaTop) then
      LastLineCorr := LastLineCorr + Abs(Round(FLineSpacing * 2));
    if VAlign = vaBottom then
    begin
      y := y + Round(CosA * (dy - LastLineCorr));
      x := x + Round(SinA * (dy - LastLineCorr));
    end
    else if VAlign = vaCenter then
    begin
      y := y + Round(CosA * (dy - LastLineCorr) / 2);
      x := x + Round(SinA * (dy - LastLineCorr) / 2);
    end;

    CosA := cos(pi / 180 * FRotation);
    SinA := sin(pi / 180 * FRotation);
  end;

begin
  n := FText.Count;
  if ((n = 0) or (FHTMLTags.Count = 0)) and (UnderlinesTextMode = ulmNone) then exit;  // no text to draw

  FCanvas.Lock;
  try
    {$IFDEF LCLGTK2}
    if IsPrinter(C) then
      PPI := frxPrinters.Printer.CUPSPrinter.XDPI
    else
      PPI := 96;
    {$ELSE}
    PPI := GetDeviceCaps(C.Handle, LOGPIXELSY);
    {$ENDIF}
    if IsPrinter(C) then
      h := -Round(FFontSize * PPI * FPrintScale / 72) else
      h := -Round(FFontSize * FScaleY * 96 / 72);
    C.Font := FCanvas.Font;

    {$IFDEF FPC}
    {$IFDEF LCLQt}
    // qt pixelsize -1 have different meaning
    if h = -1 then
      h := -2;
    {$ENDIF}
    {$ENDIF}
    C.Font.Height := h;

    if FHTMLTags[0].Count > 0 then
    begin
      Tag := FHTMLTags[0].Items[0];
      if not Tag.Default then
      begin
        C.Font.Style := Tag.Style;
        if FMonoFont then
          C.Font.Color := clBlack
        else
          C.Font.Color := Tag.Color;
        if IsPrinter(C) then
          C.Font.Height := -Round(Tag.Size * PPI * FPrintScale / 72) else
          C.Font.Height := -Round(Tag.Size * FScaleY * 96 / 72);
      end;
      Tag.Default := True;
    end;

    fh := 0; oldfh := 0;
    if FRotation <> 0 then
    begin
      fh := frxCreateRotatedFont(C.Font, FRotation);
      oldfh := SelectObject(C.Handle, fh);
    end;

    Sz := GetFontHeight(C);
    PrnSz := GetFontHeight(FCanvas);
    if IsPrinter(C) then
    begin
      ratio := FDefPPI / PPI / FPrintScale;
      neededSize := Round((prnSz * n + FLineSpacing * FScaleY * ratio * n) / ratio)
    end
    else
    begin
      ratio := FDefPPI / 96;
      neededSize := Round((prnSz * n + FLineSpacing * ratio * n) / ratio * FScaleY);
    end;
    extraSize := neededSize - (Sz * n + Round(FLineSpacing * FScaleY) * n);

    if not FWysiwyg then
      extraSize := 0;

    CalcRotatedCoords;

    GetMem(Ar, SizeOf(Integer) * n);
    for i := 0 to n - 2 do
      Ar[i] := Round(FLineSpacing * FScaleY) + Sz;

    if extraSize < 0 then
    begin
      extraSize := -extraSize;
      add3 := -1;
    end
    else
      add3 := 1;

    if n > 1 then
      if extraSize < n then
        IncArray(Ar, 0, n - 2, extraSize, add3)
      else if n > 1 then
      begin
        add1 := extraSize div (n - 1) * add3;
        for i := 0 to n - 2 do
          Inc(Ar[i], add1);
        IncArray(Ar, 0, n - 2, extraSize - add1 * (n - 1) * add3, add3)
      end;

    SetBkMode(C.Handle, Transparent);

    if (n < 1) and (UnderlinesTextMode = ulmUnderlinesAll) then
      begin
        LineSz := Sz + Round(FScaleY);
        for j := 1 to Trunc((FScaledRect.Bottom - FScaledRect.Top) / LineSz) do
          if FScaledRect.Top + j * LineSz < FScaledRect.Bottom then
            begin
              C.MoveTo(x, FScaledRect.Top + j * LineSz);
              C.LineTo(x + dx, FScaledRect.Top + j * LineSz);
            end;
      end;

    for i := 0 to n - 1 do
    begin
      gx := 0;
      al := HAlign;
      par := Integer(FText.Objects[i]);
      if (par and 1) <> 0 then
        if HAlign in [haLeft, haBlock] then
          gx := Round(FParagraphGap * FScaleX);
      if (par and 2) <> 0 then
        if HAlign = haBlock then
          if FRTLReading then
            al := haRight else
            al := haLeft;

      DrawTextLine(C, FText[i], x + gx, y, dx - gx, i, al, fh, oldfh);
      if UnderlinesTextMode <> ulmNone then
        begin
          LineSz := Sz + Round(FScaleY);
          if (UnderlinesTextMode = ulmUnderlinesAll) and (i = 0) and (VAlign <> vaTop) then
            for j := 0 to Trunc((y - FScaledRect.Top) / LineSz) do
              if y - j * LineSz > FScaledRect.Top then
                begin
                  C.MoveTo(x, y - j * LineSz);
                  C.LineTo(x + dx, y - j * LineSz);
                end;
          if not ((UnderlinesTextMode = ulmUnderlinesText) and (Trim(FText[i]) = '')) then
            if (y + LineSz < FScaledRect.Bottom) and (y + LineSz > FScaledRect.Top) then
              begin
                C.MoveTo(x, y + LineSz);
                C.LineTo(x + dx, y + LineSz);
              end;
          if (UnderlinesTextMode = ulmUnderlinesAll) and (i = n - 1) and (VAlign <> vaBottom) then
            for j := 0 to Trunc((FScaledRect.Bottom - y) / LineSz) - 2 do
              if y + (j + 2) * LineSz < FScaledRect.Bottom then
                begin
                  C.MoveTo(x, y + (j + 2) * LineSz);
                  C.LineTo(x + dx, y + (j + 2) * LineSz);
                end;
        end;
      {$I-}
      Inc(y, Round(Ar[i] * CosA));
      Inc(x, Round(Ar[i] * SinA));
      {$I+}
    end;

    FreeMem(Ar, SizeOf(Integer) * n);

    if FRotation <> 0 then
    begin
      SelectObject(C.Handle, oldfh);
      DeleteObject(fh);
    end;

  finally
    FCanvas.Unlock;
  end;
end;

function TfrxDrawText.UnusedSpace: Extended;
var
  PrnSz: Integer;
  n: Integer;
  ratio: Extended;
begin
  FCanvas.Lock;
  try
    PrnSz := GetFontHeight(FCanvas);
    ratio := FDefPPI / FScrPPI;

  // number of lines that will fit in the bounds
    n := Trunc((FOriginalRect.Bottom - FOriginalRect.Top + 1) /
      (PrnSz / ratio + FLineSpacing));
    if n = 0 then
      Result := 0
    else
    begin
      Result := (FOriginalRect.Bottom - FOriginalRect.Top + 1) -
        (PrnSz / ratio + FLineSpacing) * n;
      if Result = 0 then
        Result := 1e-4;
    end;
  finally
    FCanvas.Unlock;
  end;
end;

function TfrxDrawText.CalcHeight: Extended;
var
  PrnSz: Integer;
  n: Integer;
  ratio, Corr: Extended;
begin
  n := FText.Count;
  if n = 0 then
  begin
    Result := 0;
    Exit;
  end;
  FCanvas.Lock;
  ratio := FDefPPI / FScrPPI;
  try
    PrnSz := GetFontHeight(FCanvas);
    Corr := (GetFontHeightMetric(FCanvas) - PrnSz) / ratio;
  finally
    FCanvas.Unlock;
  end;

  Result := (PrnSz / ratio + FLineSpacing) * n;
  if FLineSpacing < 0 then
    Result := Result - FLineSpacing;
  { temprary solution }
  if (FFontSize > 12) and (Corr > 0) then
    Result := Result + Corr;
end;

function TfrxDrawText.CalcWidth: Extended;
var
  Sz, tSz: TSize;
  s: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
  LineIndex, Ln, i, j, maxWidth, par: Integer;
  ratio: Extended;
  Tag: TfrxHTMLTag;
  TmpStyle: TFontStyles;
begin
  if FText.Count = 0 then
  begin
    Result := 0;
    Exit;
  end;

  ratio := FDefPPI / FScrPPI;
  maxWidth := 0;
  FCanvas.Lock;
  try
    for LineIndex := 0 to FText.Count - 1 do
    begin
      Sz.cx := 0;
      s := FText[LineIndex];
      i := 0;
      {search for HTML tags styles}
      if (FHTMLTags.FAllowTags) and (FHTMLTags.Count <> 0) and (FHTMLTags[LineIndex].Count > 0) then
      begin
        TmpStyle := FCanvas.Font.Style;
        Ln := FHTMLTags[LineIndex].Count;
        Tag := FHTMLTags[LineIndex].Items[0];
        FCanvas.Font.Style := Tag.Style;
        repeat
          j := i;
          while i < Ln do
          begin
            Tag := FHTMLTags[LineIndex].Items[i];
            if not Tag.Default then
            begin
              Tag.Default := True;
              break;
            end;
            Inc(i);
          end;
          {$IFDEF FPC}
          GetTextExtentPoint(FCanvas.Handle, PChar(s) + j, i - j, tSz);
          {$ELSE}
          GetTextExtentPointW(FCanvas.Handle, PWideChar(s) + j, i - j, tSz);
          {$ENDIF}
          FCanvas.Font.Style := Tag.Style;
          Sz.cx := Sz.cx + tSz.cx;
        until i >= Ln;
        FCanvas.Font.Style := TmpStyle;
     end
      else
        {$IFDEF FPC}
        GetTextExtentPoint(FCanvas.Handle, PChar(s), Length(s), Sz);
        {$ELSE}
        GetTextExtentPointW(FCanvas.Handle, PWideChar(s), Length(s), Sz);
        {$ENDIF}

      Inc(Sz.cx, Round(Length(s) * FCharSpacing * ratio));

      par := Integer(FText.Objects[LineIndex]);
      if (par and 1) <> 0 then
        Inc(Sz.cx, Round(FParagraphGap * ratio));

      if maxWidth < Sz.cx then
        maxWidth := Sz.cx;
    end;
  finally
    FCanvas.Unlock;
  end;

  Result := maxWidth / ratio;
end;

function TfrxDrawText.LineHeight: Extended;
var
  PrnSz: Integer;
  ratio: Extended;
begin
  FCanvas.Lock;
  try
    PrnSz := GetFontHeight(FCanvas);
  finally
    FCanvas.Unlock;
  end;
  ratio := FDefPPI / FScrPPI;
  Result := PrnSz / ratio + FLineSpacing;
end;

function TfrxDrawText.GetOutBoundsText(var ParaBreak: Boolean): {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
var
  PrnSz: Integer;
  n, vl, Ln: Integer;
  ratio: Extended;
  Tag: TfrxHTMLTags;
  cl: LongInt;
begin
  ParaBreak := False;
  Result := '';
  n := FText.Count;
  if n = 0 then Exit;

  FCanvas.Lock;
  try
    PrnSz := GetFontHeight(FCanvas);
    ratio := FDefPPI / FScrPPI;

  // number of lines that will fit in the bounds
    vl := Trunc((FOriginalRect.Bottom - FOriginalRect.Top + 1) / (PrnSz / ratio + FLineSpacing));
    if vl > n then
      vl := n;

    if vl < FHTMLTags.Count then
    begin
  // deleting all outbounds text
      while FText.Count > vl do
        FText.Delete(FText.Count - 1);

      if (vl > 0) and (Integer(FText.Objects[vl - 1]) in [0, 1]) then
        ParaBreak := True;

      Tag := FHTMLTags[vl];
      Result := Copy(FPlainText, Tag[0].Position, Length(FPlainText) - Tag[0].Position + 1);
      if ParaBreak then
        if (Length(Result) > 0) and (Result[1] = ' ') then
          Delete(Result, 1, 1);
      Delete(FPlainText, Tag[0].Position, Length(FPlainText) - Tag[0].Position + 1);
     Ln := Length(FText.Text);
     if (Ln > 2) and  FWordBreak and (FText.Text[Ln - 2] = '-') then
       FPlainText := FPlainText + '-';

      if FHTMLTags.AllowTags then
      begin
        if fsBold in Tag[0].Style then
          Result := '<b>' + Result;
        if fsItalic in Tag[0].Style then
          Result := '<i>' + Result;
        if fsUnderline in Tag[0].Style then
          Result := '<u>' + Result;
        if ssSubscript = Tag[0].SubType then
          Result := '<sub>' + Result;
        if ssSuperscript = Tag[0].SubType then
          Result := '<sup>' + Result;
        cl := ColorToRGB(Tag[0].Color);
        cl := (cl and $00FF0000) div 65536 + (cl and $000000FF) * 65536 + (cl and $0000FF00);
        Result := '<font color="#' + IntToHex(cl, 6) + '">' + Result;
      end;
    end;
  finally
    FCanvas.Unlock;
  end;
end;

function TfrxDrawText.GetFontHeight(aCanvas: TCanvas): Integer;
begin
  if FUseOldLineHeight then
    Result := -aCanvas.Font.Height
  else
    Result := GetFontHeightMetric(aCanvas);
end;

function TfrxDrawText.GetFontHeightMetric(aCanvas: TCanvas): Integer;
{$IFNDEF FPC}
var
  tm: TEXTMETRIC;
{$ENDIF}
begin
{$IFDEF FPC}
  Result := -aCanvas.Font.Height;
{$ELSE}
  try
    GetTextMetrics(aCanvas.Handle, tm);
    Result := tm.tmHeight;
  except
    Result := -aCanvas.Font.Height;
  end;
{$ENDIF}
end;


function TfrxDrawText.GetInBoundsText: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
begin
  Result := FPlainText;
end;

function TfrxDrawText.IsPrinter(C: TCanvas): Boolean;
begin
  Result := C is {$IFDEF LCLGTK2}TPrinterCanvas{$ELSE}TfrxPrinterCanvas{$ENDIF};
end;

procedure TfrxDrawText.Lock;
begin
// commented by Samuray
//  while FLocked do
//    Application.ProcessMessages;
//  FLocked := True;
  GraphCS.Enter; // added by Samuray
end;

procedure TfrxDrawText.LockCanvas;
begin
  FCanvas.Lock;
end;

procedure TfrxDrawText.ReallocTempArray(ANewSize: Integer);
begin
  if ANewSize <= FTempArraySize then Exit;
  if Assigned(FTempArray) then
    FreeTempArray;
  try
    GetMem(FTempArray, SizeOf(Integer) * ANewSize);
    FTempArraySize := ANewSize;
  except
    FTempArraySize := 0;
    raise;
  end;
end;

procedure TfrxDrawText.Unlock;
begin
//  FLocked := False;  commented by Samuray
  GraphCS.Leave; // added by Samuray
end;

procedure TfrxDrawText.UnlockCanvas;
begin
  FCanvas.Unlock;
end;

function TfrxDrawText.GetWrappedText: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF};
begin
  Result := FText.Text;
end;

function TfrxDrawText.TextHeight: Extended;
var
  PrnSz: Integer;
  ratio: Extended;
begin
  FCanvas.Lock;
  try
    PrnSz := -FCanvas.Font.Height;
  finally
    FCanvas.Unlock;
  end;
  ratio := FDefPPI / FScrPPI;
  Result := PrnSz / ratio;
end;

initialization
  frxDrawText := TfrxDrawText.Create;
  GraphCS := TCriticalSection.Create;

finalization
  frxDrawText.Free;
  GraphCS.Free;

end.
