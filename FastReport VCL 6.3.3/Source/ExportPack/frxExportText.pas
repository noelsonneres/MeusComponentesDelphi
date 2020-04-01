
{******************************************}
{                                          }
{             FastReport v6.0              }
{            Simple text export            }
{                                          }
{         Copyright (c) 1998-2017          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportText;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  frxClass, frxExportMatrix, frxExportBaseDialog, ShellAPI
{$IFDEF Delphi6}, Variants {$ENDIF};

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxSimpleTextExport = class(TfrxBaseDialogExportFilter)
  private
    FPageBreaks: Boolean;
    FMatrix: TfrxIEMatrix;
    Exp: TStream;
    FPage: TfrxReportPage;
    FFrames: Boolean;
    pX: Extended;
    pY: Extended;
    pT: Extended;
    FEmptyLines: Boolean;
    FOEM: Boolean;
    FDeleteEmptyColumns: Boolean;
    procedure ExportPage(Stream: TStream);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    class function ExportDialogClass: TfrxBaseExportDialogClass; override;
    function Start: Boolean; override;
    procedure Finish; override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
    procedure ExportObject(Obj: TfrxComponent); override;
  published
    property PageBreaks: Boolean read FPageBreaks write FPageBreaks default True;
    property Frames: Boolean read FFrames write FFrames;
    property EmptyLines: Boolean read FEmptyLines write FEmptyLines;
    property OEMCodepage: Boolean read FOEM write FOEM;
    property OpenAfterExport;
    property OverwritePrompt;
    property DeleteEmptyColumns: Boolean read FDeleteEmptyColumns write FDeleteEmptyColumns;
  end;


implementation

uses frxUtils, frxFileUtils, frxUnicodeUtils, frxRes, frxrcExports, frxExportTextDialog;

{$IFDEF Delphi12}
function Trim(const S: AnsiString): AnsiString;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do Inc(I);
  if I > L then Result := '' else
  begin
    while S[L] <= ' ' do Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;

function TrimRight(const S: AnsiString): AnsiString;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] <= ' ') do Dec(I);
  Result := Copy(S, 1, I);
end;
{$ENDIF}

{ TfrxSimpleTextExport }

constructor TfrxSimpleTextExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPageBreaks := True;
  FFrames := False;
  FEmptyLines := False;
  FOEM := False;
  FDeleteEmptyColumns := True;
  FilterDesc := frxGet(8801);
  DefaultExt := frxGet(8802);
end;

class function TfrxSimpleTextExport.GetDescription: String;
begin
  Result := frxResources.Get('SimpleTextExport');
end;

procedure TfrxSimpleTextExport.ExportPage(Stream: TStream);
var
  x, y, i: Integer;
  FScreen: array of AnsiChar;
  FScreenWidth: Integer;
  FScreenHeight: Integer;
  Obj: TfrxIEMObject;
  ObjBounds: TfrxRect;
  ObjWidth, ObjHeight: Extended;
  c: AnsiChar;
  s: AnsiString;

  procedure InitObjBounds(Obj: TfrxIEMObject);
  begin
    ObjBounds := FMatrix.GetObjectBounds(Obj);
    ObjWidth := ObjBounds.Right - ObjBounds.Left;
    ObjHeight := ObjBounds.Bottom - ObjBounds.Top;
  end;

  function MakeStr(C: AnsiChar; N: Integer): AnsiString;
  begin
    if N < 1 then
      Result := ''
    else
    begin
      SetLength(Result, N);
      FillChar(Result[1], Length(Result), C);
    end;
  end;

  function AddChar(C: AnsiChar; const S: AnsiString; N: Integer): AnsiString;
  begin
    if Length(S) < N then
      Result := MakeStr(C, N - Length(S)) + S else
      Result := S;
  end;

  function AddCharR(C: AnsiChar; const S: AnsiString; N: Integer): AnsiString;
  begin
    if Length(S) < N then
      Result := S + MakeStr(C, N - Length(S)) else
      Result := S;
  end;

  function LeftStr(const S: AnsiString; N: Integer): AnsiString;
  begin
    Result := AddCharR(' ', S, N);
  end;

  function RightStr(const S: AnsiString; N: Integer): AnsiString;
  begin
    Result := AddChar(' ', S, N);
  end;

  function CenterStr(const S: AnsiString; Len: Integer): AnsiString;
  begin
    if Length(S) < Len then
    begin
      Result := MakeStr(' ', (Len div 2) - (Length(S) div 2)) + S;
      Result := Result + MakeStr(' ', Len - Length(Result));
    end
    else
      Result := S;
  end;

  function AlignStr(const Buf: AnsiString; const style: TfrxIEMStyle; const Width: Integer): AnsiString;
  begin
    if (style.HAlign = haRight) then
      Result := RightStr(buf, Width - 1)
    else if (style.HAlign = haCenter) then
      Result := CenterStr(buf, Width - 1)
    else
      Result := LeftStr(buf, Width - 1);
  end;

  procedure ScreenCreate;
  begin
    Initialize(FScreen);
    SetLength(FScreen, FScreenWidth * FScreenHeight);
    FillChar(FScreen[0], Length(FScreen), #32);
  end;

  procedure ScreenType(const x,y: Integer; const c: AnsiChar);
  begin
    FScreen[FScreenWidth * y + x] := c;
  end;

  procedure ScreenString(const x, y: Integer; const s: AnsiString);
  var
    i: Integer;
  begin
    for i := 0 to Length(s) - 1 do
      ScreenType(x + i, y, s[i + 1]);
  end;

  procedure ScreenMemo(const Obj: TfrxIEMObject);
  var
    i: Integer;
    curx, cury: Integer;
    s: AnsiString;

  function StrToOem(const AnsiStr: AnsiString): AnsiString;
  begin
    SetLength(Result, Length(AnsiStr));
    if Length(Result) > 0 then
      CharToOemBuffA(PAnsiChar(AnsiStr), PAnsiChar(Result), Length(Result));
  end;

  begin
    curx := Round(ObjBounds.Left / pX);
    cury := Round(ObjBounds.Top / pY);
    for i := 0 to Obj.Memo.Count - 1 do
    begin
      if FOEM then
        s := StrToOem(_UnicodeToAnsi(Obj.Memo[i], DEFAULT_CHARSET))
      else
        s := _UnicodeToAnsi(Obj.Memo[i], DEFAULT_CHARSET);
      ScreenString(curx, cury + i, AlignStr(s, Obj.Style, Round(ObjWidth / pX) - 1));
    end;
    if FFrames then
    begin
      if (ftLeft in Obj.Style.FrameTyp) then
        for i := 0 to Round(ObjHeight / pY) - 1 do
          ScreenType(curx - 1, cury + i, '|');
      if (ftRight in Obj.Style.FrameTyp) then
        for i := 0 to Round(ObjHeight / pY) - 1 do
          ScreenType(curx + Round(ObjWidth / pX) - 2, cury + i, '|');
      if (ftTop in Obj.Style.FrameTyp) then
        for i := 0 to Round(ObjWidth / pX) - 1 do
          ScreenType(curx - 1 + i, cury - 1, '-');
      if (ftBottom in Obj.Style.FrameTyp) then
        for i := 0 to Round(ObjWidth / pX) - 1 do
          ScreenType(curx - 1 + i, cury + Round(ObjHeight / pY) - 1, '-');
     end;
  end;

  function ScreenGet(const x, y: Integer): AnsiChar;
  begin
   if (x < FScreenWidth) and (y < FScreenHeight) and
     (x >= 0) and (y >= 0) then
     Result := FScreen[FScreenWidth * y + x] else
     Result := ' ';
  end;

  function GetMaxPX(const Obj: TfrxIEMObject): Extended;
  var
    i : Integer;
  begin
    Result := 0;
    for i := 0 to Obj.Memo.Count - 1 do
      if Length(Obj.Memo[i]) > Result then
        Result := Length(Obj.Memo[i]);
    if (Result > 0)  then //and (Obj.Width )
      Result := 6 * ObjWidth / (Result * Obj.Style.Font.Size);
    if Result < 1 then
      Result := 1;
  end;

  function GetMaxPY(const Obj: TfrxIEMObject): Extended;
  begin
    if Obj.Memo.Count > 0 then
      Result := 5 * ObjHeight / (Obj.Memo.Count * Obj.Style.Font.Size)
    else
      Result := 0;
  end;

  function ColumnEmpty(const x: Integer): Boolean;
  var
    y: Integer;
  begin
    Result := True;
    for y := 0 to FScreenHeight - 1 do
      if FScreen[FScreenWidth * y + x] <> #32 then
      begin
        Result := False;
        break;
      end;
  end;

  procedure DeleteColumn(const x: Integer);
  var
    i, j: Integer;
  begin
    for i := 0 to FScreenHeight - 1 do
    begin
      for j := x to FScreenWidth - 2 do
        FScreen[FScreenWidth * i + j] := FScreen[FScreenWidth * i + j + 1];
      FScreen[FScreenWidth * i + FScreenWidth - 1] := #32;
    end;
  end;

begin
  FMatrix.Prepare;

  for i := 0 to FMatrix.ObjectsCount - 1 do
  begin
    Obj := FMatrix.GetObjectById(i);
    InitObjBounds(Obj);

    pT := GetMaxPX(Obj);

    if (pT < pX) and (pT <> 0) then
      pX := pT;

    pT := GetMaxPY(Obj);

    if (pT < pY) and (pT <> 0) then
      pY := pT;
  end;

  FScreenWidth := Round(FPage.Width / pX);
  FScreenHeight := Round(FPage.Height / pY);
  ScreenCreate;

  for y := 0 to FMatrix.Height - 2 do
  begin
    for x := 0 to FMatrix.Width - 1 do
    begin
      i := FMatrix.GetCell(x, y);
      if (i <> -1) then
      begin
        Obj := FMatrix.GetObjectById(i);
        InitObjBounds(Obj);
        ScreenMemo(Obj);
      end;
    end;
  end;

  x := 0;
  i := 2;
  y := FScreenWidth;
  while x < y - 1 do
    if DeleteEmptyColumns and ColumnEmpty(x) then
      if i = 0 then
      begin
        DeleteColumn(x);
        Dec(y);
      end
      else
      begin
        Dec(i);
        Inc(x);
      end
    else
    begin
      Inc(x);
      i := 2;
    end;

  for y := 0 to FScreenHeight - 1 do
  begin
    s := '';
    for x := 0 to FScreenWidth - 1 do
    begin
      c := ScreenGet(x, y);
      s := s + c;
    end;
    s := TrimRight(s);
    if (Length(Trim(s)) > 0) or FEmptyLines then
    begin
      s := s + #13#10;
      Stream.Write(s[1], Length(s));
    end;
  end;
  if FPageBreaks then
    Stream.Write(AnsiString(#12), 1);
end;

function TfrxSimpleTextExport.Start: Boolean;
begin
  if (FileName <> '') or Assigned(Stream) then
  begin
    if (ExtractFilePath(FileName) = '') and (DefaultPath <> '') then
      FileName := DefaultPath + '\' + FileName;
    FMatrix := TfrxIEMatrix.Create(UseFileCache, Report.EngineOptions.TempDir);
    FMatrix.Background := False;
    FMatrix.BackgroundImage := False;
    FMatrix.Printable := ExportNotPrintable;
    FMatrix.RichText := True;
    FMatrix.PlainRich := True;
    FMatrix.AreaFill := False;
    FMatrix.CropAreaFill := True;
    FMatrix.Inaccuracy := 0.5;
    FMatrix.DeleteHTMLTags := True;
    FMatrix.Images := False;
    FMatrix.WrapText := True;
    FMatrix.ShowProgress := False;
    FMatrix.FramesOptimization := True;
    try
      if Assigned(Stream) then
        Exp := Stream
      else
        Exp := IOTransport.GetStream(FileName);
       Result := True;
    except
      Result := False;
    end;
  end
  else
    Result := False;
end;

procedure TfrxSimpleTextExport.StartPage(Page: TfrxReportPage; Index: Integer);
begin
  FMatrix.Clear;
  pX := MAXWORD;
  pY := MAXWORD;
end;

class function TfrxSimpleTextExport.ExportDialogClass: TfrxBaseExportDialogClass;
begin
  Result := TfrxSimpleTextExportDialog;
end;

procedure TfrxSimpleTextExport.ExportObject(Obj: TfrxComponent);
var v: TfrxView;
begin
  if Obj is TfrxView then
    begin
      v := TfrxView(Obj);
      if vsExport in v.Visibility then
        FMatrix.AddObject(v);
    end;
end;

procedure TfrxSimpleTextExport.FinishPage(Page: TfrxReportPage; Index: Integer);
begin
  FPage := Page;
  ExportPage(Exp);
end;

procedure TfrxSimpleTextExport.Finish;
begin
  FMatrix.Free;
  if not Assigned(Stream) then
  begin
    IOTransport.DoFilterSave(Exp);
    IOTransport.FreeStream(Exp);
  end;
end;

end.
