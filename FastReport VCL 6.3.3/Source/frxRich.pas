
{******************************************}
{                                          }
{             FastReport v5.0              }
{         RichEdit Add-In Object           }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxRich;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Menus, frxClass,
  RichEdit,
  frxRichEdit,
  frxPrinter
{$IFDEF Delphi6}
, Variants
{$ENDIF}

{$IFDEF DELPHI16}
 , Vcl.Controls
{$ENDIF};


{$IFDEF WIN64}
//const RichEditVersion: Integer = 3;
{$ENDIF}

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxRichObject = class(TComponent)  // fake component
  end;

  TfrxRichView = class(TfrxStretcheable)

  private
    FAllowExpressions: Boolean;
    FExpressionDelimiters: String;
    FFlowTo: TfrxRichView;
    FGapX: Extended;
    FGapY: Extended;
    FParaBreak: Boolean;
    FRichEdit: TrxRichEdit;
    FTempStream: TMemoryStream;
    FTempStream1: TMemoryStream;
    FWysiwyg: Boolean;
    FHasNextDataPart: Boolean;
    FLastChar: Integer;
    function CreateMetafile: TMetafile;
    function IsExprDelimitersStored: Boolean;
    function UsePrinterCanvas: Boolean;
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure AfterPrint; override;
    procedure BeforePrint; override;
    procedure GetData; override;
    procedure InitPart; override;
    function CalcHeight: Extended; override;
    function DrawPart: Extended; override;
    class function GetDescription: String; override;
    function GetComponentText: String; override;
    function HasNextDataPart(aFreeSpace: Extended): Boolean; override;
    function IsEMFExportable: Boolean; override;
    property RichEdit: TrxRichEdit read FRichEdit;
  published
    property AllowExpressions: Boolean read FAllowExpressions
      write FAllowExpressions default True;
    property BrushStyle;
    property Color;
    property Cursor;
    property DataField;
    property DataSet;
    property DataSetName;
    property ExpressionDelimiters: String read FExpressionDelimiters
      write FExpressionDelimiters stored IsExprDelimitersStored;
    property FlowTo: TfrxRichView read FFlowTo write FFlowTo;
    property FillType;
    property Fill;
    property Frame;
    property GapX: Extended read FGapX write FGapX;
    property GapY: Extended read FGapY write FGapY;
    property TagStr;
    property URL;
    property Wysiwyg: Boolean read FWysiwyg write FWysiwyg default True;
  end;


    procedure frxAssignRich(RichFrom, RichTo: TrxRichEdit);



implementation

uses
  frxRichRTTI,
{$IFNDEF NO_EDITORS}
  frxRichEditor,
{$ENDIF}
  frxUtils, frxDsgnIntf, frxRes
{$IFNDEF NO_CRITICAL_SECTION}
  , SyncObjs
{$ENDIF};

{$IFNDEF NO_CRITICAL_SECTION}
var
  frxCSRich: TCriticalSection;
{$ENDIF}

procedure frxAssignRich(RichFrom, RichTo: TrxRichEdit);
var
  st: TMemoryStream;
begin
  st := TMemoryStream.Create;
  try
    RichFrom.Lines.SaveToStream(st);
    st.Position := 0;
    RichTo.Lines.LoadFromStream(st);
  finally
    st.Free;
  end;
end;


{ TfrxRichView }

constructor TfrxRichView.Create(AOwner: TComponent);
begin
  inherited;
{$IFNDEF NO_CRITICAL_SECTION}
  frxCSRich.Enter;
  try
{$ENDIF}
    FRichEdit := TrxRichEdit.Create(nil);
    FRichEdit.Parent := frxParentForm;
    SendMessage(frxParentForm.Handle, WM_CREATEHANDLE, frxInteger(FRichEdit), 0);
    FRichEdit.AutoURLDetect := False;

  { make rich transparent }
  SetWindowLong(FRichEdit.Handle, GWL_EXSTYLE,
    GetWindowLong(FRichEdit.Handle, GWL_EXSTYLE) or WS_EX_TRANSPARENT);
{$IFNDEF NO_CRITICAL_SECTION}
  finally
    frxCSRich.Leave;
  end;
{$ENDIF}
  FTempStream := TMemoryStream.Create;
  FTempStream1 := TMemoryStream.Create;

  FAllowExpressions := True;
  FExpressionDelimiters := '[,]';
  FGapX := 2;
  FGapY := 1;
  FWysiwyg := True;
  FHasNextDataPart := True;
  FLastChar := 0;
end;

destructor TfrxRichView.Destroy;
begin
{$IFNDEF NO_CRITICAL_SECTION}
  frxCSRich.Enter;
  try
{$ENDIF}
    SendMessage(frxParentForm.Handle, WM_DESTROYHANDLE, frxInteger(FRichEdit), 0);
    FRichEdit.Free;
{$IFNDEF NO_CRITICAL_SECTION}
  finally
    frxCSRich.Leave;
  end;
{$ENDIF}
  FTempStream.Free;
  FTempStream1.Free;
  inherited;
end;

class function TfrxRichView.GetDescription: String;
begin
  Result := frxResources.Get('obRich');
end;

function TfrxRichView.IsExprDelimitersStored: Boolean;
begin
  Result := FExpressionDelimiters <> '[,]';
end;

procedure TfrxRichView.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('RichEdit', ReadData, WriteData, True);
end;

procedure TfrxRichView.ReadData(Stream: TStream);
begin
  FRichEdit.Lines.LoadFromStream(Stream);
end;

procedure TfrxRichView.WriteData(Stream: TStream);
begin
  FRichEdit.Lines.SaveToStream(Stream);
end;

procedure TfrxRichView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFlowTo) then
    FFlowTo := nil;
end;

function TfrxRichView.UsePrinterCanvas: Boolean;
begin
  Result := frxPrinters.HasPhysicalPrinters and FWysiwyg;
end;

function TfrxRichView.CreateMetafile: TMetafile;
var
  Range: TFormatRange;
  EMFCanvas: TMetafileCanvas;
  PrinterHandle: THandle;
  aScaleX, aScaleY: Extended;
//  BottomOffset :Integer;
begin
  if UsePrinterCanvas then
    PrinterHandle := frxPrinters.Printer.Canvas.Handle
  else
    PrinterHandle := GetDC(0);
  FillChar(Range, SizeOf(TFormatRange), 0);

  Range.rc := Rect(Round(GapX * 1440 / 96), Round(GapY * 1440 / 96),
    Round((Width - GapX) * 1440 / 96), Round((Height - GapY) * 1440 / 96));
  Range.rcPage := Range.rc;

  Result := TMetafile.Create;
  GetDisplayScale(PrinterHandle, UsePrinterCanvas, aScaleX, aScaleY);
  Result.Width := Round(Width * aScaleX);
  Result.Height := Round(Height * aScaleY);
{$IFNDEF NO_CRITICAL_SECTION}
  frxCSRich.Enter;
{$ENDIF}
  EMFCanvas := TMetafileCanvas.Create(Result, PrinterHandle);

  EMFCanvas.Lock;
  try
    Range.hdc := EMFCanvas.Handle;
    Range.hdcTarget := Range.hdc;

    (* code to process all Rich edit page,
      at this moment engine split big RTF by page tag
      so this code is nessasary only for very small RTF wit pages
      therefore i have commented it.
      Delete in futer if none will ask it

      chrg.cpMax := RichEdit.GetTextLen;
      chrg.cpMin:= 0;
      BottomOffset := 0;
      { process all pages in RichEdit, maybe it contain /PAGE tag}
      repeat
      with rc do
      begin
      FRichEdit.Perform(EM_FORMATRANGE, 0, frxInteger(@Range));
      if Bottom > rcPage.Bottom then break;
      chrg.cpMin := FRichEdit.Perform(EM_FORMATRANGE, 1, frxInteger(@Range));
      Top := Top + Bottom - BottomOffset;
      BottomOffset := Bottom;
      Bottom := rcPage.Bottom - Bottom;
      end;
      until (chrg.cpMin >= chrg.cpMax) or (Height <= Round(BottomOffset / (1440.0 / 96)) + 2 * GapY  + 1 );
    *)
    Range.chrg.cpMax := -1;
    Range.chrg.cpMin := 0;

    FRichEdit.Perform(EM_FORMATRANGE, 1, frxInteger(@Range));

    if not UsePrinterCanvas then
      ReleaseDC(0, PrinterHandle);

    FRichEdit.Perform(EM_FORMATRANGE, 0, 0);

  finally
    EMFCanvas.Unlock;
    EMFCanvas.Free;
{$IFNDEF NO_CRITICAL_SECTION}
    frxCSRich.Leave;
{$ENDIF}
  end;
end;

procedure TfrxRichView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  EMF: TMetafile;
begin
  if Height < 0 then Height := Height * (-1);
  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  DrawBackground;

  EMF := CreateMetafile;
  try
    Canvas.StretchDraw(Rect(FX, FY, FX1, FY1), EMF);
  finally
    EMF.Free;
  end;

  if not FObjAsMetafile then
    DrawFrame;
end;

procedure TfrxRichView.BeforePrint;
begin
  inherited;
  FTempStream.Position := 0;
{$IFNDEF NO_CRITICAL_SECTION}
  frxCSRich.Enter;
  try
{$ENDIF}
    FRichEdit.Lines.SaveToStream(FTempStream);
{$IFNDEF NO_CRITICAL_SECTION}
  finally
    frxCSRich.Leave;
  end;
{$ENDIF}
end;

procedure TfrxRichView.AfterPrint;
begin
  FTempStream.Position := 0;
{$IFNDEF NO_CRITICAL_SECTION}
  frxCSRich.Enter;
  try
{$ENDIF}
    FRichEdit.Lines.LoadFromStream(FTempStream);
{$IFNDEF NO_CRITICAL_SECTION}
  finally
    frxCSRich.Leave;
  end;
{$ENDIF}
  inherited;
end;

procedure TfrxRichView.GetData;
const
  RTFHeader = '{\rtf';
  URTFHeader = '{urtf';
type
  tag_settextex = record
    flags: DWORD;
    codepage: UINT;
  end;
var
  ss: TStringStream;
  i, j, TextLen, sStart, sLen: Integer;
  s1, s2, dc1, dc2: String;
  SetText: tag_settextex;
  cf: TCharFormat2A;
{$IFDEF Delphi12}
  AnsiStr: AnsiString;
{$ENDIF}

  function GetSpecial(const s: String; Pos: Integer): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 1 to Pos do
{$IFDEF Delphi12}
      if CharInSet(s[i], [#10, #13]) then
{$ELSE}
      if s[i] in [#10, #13] then
{$ENDIF}
        Inc(Result);
  end;

  { this function search expression broken by new line}
  { [                                                 }
  {  IIF(1>2,'oh',                                    }
  {  'OK')                                            }
  {  ]                                                }
  { EM_FINDTEXTEX coldn't search text with new line   }
  function SearchForText(const s: String; StartPos: Integer): Boolean;
  var
    i, sPos, sLen, SelStart, SelEnd: Integer;
    sText: String;
    Sel: TCharRange;
  begin
    sLen := Length(s);
    SelStart := -1;
    sPos := 1;
    for i := 1 to sLen do
{$IFDEF Delphi12}
      if CharInSet(s[i], [#10, #13]) then
{$ELSE}
      if s[i] in [#10, #13] then
{$ENDIF}
      begin
        if (sPos = i) and (i <> 2) then
        begin
          sPos := i + 1;
          continue;
        end;
        sText := Copy(s, sPos, i - sPos);
        Result := (FRichEdit.FindText(sText, StartPos - 1 - GetSpecial(FRichEdit.Text, StartPos) div 2, -1, [stSetSelection]) > 0);
        if not Result then Exit;

        Sel := FRichEdit.GetSelection;
        if sPos = 1 then
          SelStart := Sel.cpMin;
        Inc(StartPos, Sel.cpMax - Sel.cpMin);
        sPos := i + 1;
      end;
    if SelStart = -1 then
      Result := (FRichEdit.FindText(s, StartPos - 1 - GetSpecial(FRichEdit.Text, StartPos) div 2, -1, [stSetSelection]) >= 0)
    else
    begin
      Result := (FRichEdit.FindText(Copy(s, sPos, Length(s) - (sPos - 1)), StartPos - 1 - GetSpecial(FRichEdit.Text, StartPos) div 2, -1, [stSetSelection]) > 0);
      Sel := FRichEdit.GetSelection;
      SelEnd := Sel.cpMax;
      FRichEdit.SetSelection(SelStart, SelEnd, False);
    end;
  end;

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

begin
  inherited;
  if IsDataField then
  begin
    if DataSet.IsBlobField(DataField) then
    begin
      ss := TStringStream.Create('');
      DataSet.AssignBlobTo(DataField, ss)
    end
    else
      ss := TStringStream.Create(VarToStr(DataSet.Value[DataField]));
    try
{$IFNDEF NO_CRITICAL_SECTION}
      frxCSRich.Enter;
      try
{$ENDIF}
        FRichEdit.Lines.LoadFromStream(ss);
{$IFNDEF NO_CRITICAL_SECTION}
      finally
        frxCSRich.Leave;
      end;
{$ENDIF}
    finally
      ss.Free;
    end;
  end;

  if FAllowExpressions then
  begin
    dc1 := FExpressionDelimiters;
    dc2 := Copy(dc1, Pos(',', dc1) + 1, 255);
    dc1 := Copy(dc1, 1, Pos(',', dc1) - 1);
    TextLen := 0;
    with FRichEdit do
    try
      Lines.BeginUpdate;
      i := Pos(dc1, Text);
      while i > 0 do
      begin
{$IFDEF Delphi12}
        s1 := frxGetBrackedVariableW(Text, dc1, dc2, i, j);
{$ELSE}
        s1 := frxGetBrackedVariable(Text, dc1, dc2, i, j);
{$ENDIF}
        // win8.1 old detection of expression doesn't work anymore
        // search it by using control, maybe litle slower , but works
        // temprary solution - TODO search expressions in RAW rtf
        if IsWin8 then
        begin
          if not SearchForText(dc1 + s1 + dc2, i) then
            raise Exception.Create('Could not search for expression in RichText.');
        end
        else
          SelStart := i - 1 - GetSpecial(Text, i) div 2;

        s2 := VarToStr(Report.Calc(s1));
        if IsWin8 then
          i := i + Length(s2)
        else
        begin
          SelLength := j - i + 1;
          TextLen := Length(Text) - SelLength;
        end;


        if (Copy(s2, 1, 5) = RTFHeader) or (Copy(s2, 1, 6) = URTFHeader) then
        begin
{$IFDEF Delphi12}
          AnsiStr := AnsiString(s2);
{$ENDIF}
          if RichEditVersion = 4 then
          begin
            SetText.flags := 2;//ST_SELECTION
{$IFDEF Delphi12}
            SetText.codepage := 1200;
{$ELSE}
            SetText.codepage := CP_ACP;
{$ENDIF}
             sStart := SelStart;
             sLen :=  SendMessage(FRichEdit.Handle, WM_USER + 97 {EM_SETTEXTEX}, frxInteger(@SetText),
                frxInteger({$IFDEF Delphi12}PAnsiChar(AnsiStr){$ELSE}PChar(s2){$ENDIF}));

             if IsWin8 then
               begin
                 if not IsWin10 then
                   begin
                     cf.cbSize := sizeof(TCharFormat2A);
                     cf.dwMask := CFM_CHARSET;
                     SendMessage(FRichEdit.Handle, EM_GETCHARFORMAT,  SCF_SELECTION, frxInteger(@cf));
                     cf.dwMask := CFM_CHARSET;
                     SelStart := sStart;
                     SelLength := sLen;
                     SendMessage(FRichEdit.Handle, EM_SETCHARFORMAT,  SCF_SELECTION, frxInteger(@cf));
                   end;
                 i := i - (Length(s2) - sLen) ;
               end;

              { empty line workraround }
              SelStart := SelStart + SelLength  - 1;
              SelLength := 1;
              if (SelText = #13) then
                SelText := '';
          end
          else
            SendMessage(FRichEdit.Handle, EM_REPLACESEL, frxInteger(True),
                frxInteger({$IFDEF Delphi12}PAnsiChar(AnsiStr){$ELSE}PChar(s2){$ENDIF}));// rich text workground

        end else
        begin
{$IFDEF Delphi12}
          //AnsiStr := AnsiString(s2);
{$ENDIF}
          if RichEditVersion = 4 then
          begin
            SetText.flags := 2;//ST_SELECTION
{$IFDEF Delphi12}
            SetText.codepage := 1200;
            //SetText.codepage := CP_ACP;
{$ELSE}
            SetText.codepage := CP_ACP;
{$ENDIF}
            SendMessage(FRichEdit.Handle, WM_USER + 97 {EM_SETTEXTEX}, frxInteger(@SetText),
                frxInteger({$IFDEF Delphi12}s2{$ELSE}PChar(s2){$ENDIF}));
              { empty line workraround }
              if SelLength > 0 then
              begin
                SelStart := SelStart + SelLength  - 1;
                SelLength := 1;
                if (SelText = #13) then
                  SelText := '';
              end;
          end
          else
            SelText := s2;
        end;
        if IsWin8 then
          i := PosEx(dc1, Text, i)
        else
          i := PosEx(dc1, Text, i + Length(Text) - TextLen);
      end;
    finally
      Lines.EndUpdate;
    end;
  end;

  if FFlowTo <> nil then
  begin
    InitPart;
    DrawPart;
    FTempStream1.Position := 0;
    FlowTo.RichEdit.Lines.LoadFromStream(FTempStream1);
    FFlowTo.AllowExpressions := False;
  end;
end;

function TfrxRichView.CalcHeight: Extended;
var
  Range: TFormatRange;
  chrgRange: TCharRange;
  rcBottom: Integer;
begin
  FillChar(Range, SizeOf(TFormatRange), 0);
  Result := 0;
{$IFNDEF NO_CRITICAL_SECTION}
  frxCSRich.Enter;
  try
{$ENDIF}
    with Range do
    begin
      rc := Rect(0, 0, Round((Width - GapX * 2) * 1440 / 96),
        Round(1000000 * 1440.0 / 96));
      rcPage := rc;

      if UsePrinterCanvas then
        hdc := frxPrinters.Printer.Canvas.Handle
      else
        hdc := GetDC(0);
      hdcTarget := hdc;
      chrgRange.cpMax := RichEdit.GetTextLen;

      chrg.cpMax := -1;
      chrg.cpMin := 0;
      rcBottom := 0;
      { process all pages in RichEdit, maybe it contain /PAGE tag }
      // FRichEdit.Perform(EM_SETSEL, -1, -1);
      repeat
        rc := rcPage;
        chrg.cpMin := FRichEdit.Perform(EM_FORMATRANGE, 0, frxInteger(@Range));
        rcBottom := rcBottom + rc.Bottom;
      until (chrg.cpMin >= chrgRange.cpMax);

      if chrgRange.cpMax = 0 then
        Result := 0
      else
        Result := Result + Round(rcBottom / (1440.0 / 96)) + 2 * GapY + 2;

      if not UsePrinterCanvas then
        ReleaseDC(0, hdc);
    end;
    FRichEdit.Perform(EM_FORMATRANGE, 0, 0);
{$IFNDEF NO_CRITICAL_SECTION}
  finally
    frxCSRich.Leave;
  end;
{$ENDIF}
end;

function TfrxRichView.DrawPart: Extended;
var
  Range: TFormatRange;
  LastChar: Integer;
begin
  { text can't fit }
  if (Round((Height - GapY * 2)) <= 0)then
  begin
    Result := Height;
    FHasNextDataPart := True;
    Exit;
  end;
{$IFNDEF NO_CRITICAL_SECTION}
  frxCSRich.Enter;
  try
{$ENDIF}
    { get remained part of text }
      FTempStream1.Position := 0;
      FRichEdit.Lines.LoadFromStream(FTempStream1);
      if FParaBreak then
        with FRichEdit.Paragraph do
        begin
          FirstIndent := FirstIndent + LeftIndent;
          FRichEdit.Paragraph.LeftIndent := 0;
        end;
      { calculate the last visible char }
      FillChar(Range, SizeOf(TFormatRange), 0);

      with Range do
      begin
        rc := Rect(0, 0, Round((Width - GapX * 2) * 1440 / 96),
          Round((Height - GapY * 2) * 1440 / 96));
        rcPage := rc;
        if UsePrinterCanvas then
          hdc := frxPrinters.Printer.Canvas.Handle
        else
          hdc := GetDC(0);
        hdcTarget := hdc;

        FRichEdit.Perform(EM_SETSEL, WPARAM(-1), LPARAM(-1));
        // need for RE 4.1 and tables
        chrg.cpMin := 0;
        chrg.cpMax := -1;

        { RTF4.1 trying to place data, if data doesn't fit decrease line index and try again }
        { need for tables and object in richedit }
        repeat
          LastChar := FRichEdit.Perform(EM_FORMATRANGE, 0, frxInteger(@Range));
          if (LastChar = -1) then
            break; // can't be split
          if chrg.cpMax <> -1 then
            LastChar := chrg.cpMax;
          chrg.cpMax := FRichEdit.LineFromChar(LastChar - 1) - 1;
          if chrg.cpMax <= 0 then
            break;
          chrg.cpMax := FRichEdit.GetLineIndex(chrg.cpMax);

        until ((rcPage.Bottom - rc.Bottom >= 0) or (chrg.cpMax = LastChar));

        Result := Round((rcPage.Bottom - rc.Bottom) / (1440.0 / 96)) +
          GapY * 2 + 2;

        if not UsePrinterCanvas then
          ReleaseDC(0, hdc);

        FRichEdit.Perform(EM_FORMATRANGE, 0, 0);
      end;

      { text can't fit }
      try
        if (Result < 0) then
        begin
          Result := Height;
          if FLastChar = LastChar then
            FHasNextDataPart := False;
          exit;
        end;
      finally
        FLastChar := LastChar;
      end;

      { copy the outbounds text to the temp stream }
      try
        if LastChar > 1 then
        begin
          FRichEdit.SelStart := LastChar - 1;
          FRichEdit.SelLength := 1;
          FParaBreak := FRichEdit.SelText <> #13;
        end;

        FRichEdit.SelStart := LastChar;
        FRichEdit.SelLength := RichEdit.GetTextLen - LastChar + 1;

        if FRichEdit.SelLength <= 1 then
        begin
          Result := 0;
          FHasNextDataPart := False;
        end
        else
          FHasNextDataPart := True;

        FTempStream1.Clear;
        FRichEdit.StreamMode := [smSelection];
        if FHasNextDataPart then
          FRichEdit.Lines.SaveToStream(FTempStream1);
        FRichEdit.SelText := '';
      finally
        FRichEdit.StreamMode := [];
        { bug fix when the last line hides }
        FRichEdit.Paragraph.SpaceAfter := 0;
        FRichEdit.Paragraph.SpaceBefore := 0;
        FRichEdit.Perform(EM_SETSEL, WPARAM(-1), LPARAM(-1));
      end;
{$IFNDEF NO_CRITICAL_SECTION}
    finally
      frxCSRich.Leave;
    end;
{$ENDIF}
 end;

procedure TfrxRichView.InitPart;
begin
  FTempStream1.Clear;
{$IFNDEF NO_CRITICAL_SECTION}
  frxCSRich.Enter;
  try
{$ENDIF}
    FRichEdit.Lines.SaveToStream(FTempStream1);
{$IFNDEF NO_CRITICAL_SECTION}
  finally
    frxCSRich.Leave;
  end;
{$ENDIF}
  FParaBreak := False;
  FHasNextDataPart := True;
end;

function TfrxRichView.GetComponentText: String;
var
  FTStream: TMemoryStream;
{$IFDEF Delphi12}
  TempStr: AnsiString;
{$ENDIF}
begin
  if PlainText then
  begin
    FTStream := TMemoryStream.Create;
    try
      FTempStream.Clear;
      FRichEdit.Lines.SaveToStream(FTStream);
      FRichEdit.PlainText := True;
      FRichEdit.Lines.SaveToStream(FTempStream);
{$IFDEF Delphi12}
      SetLength(TempStr, FTempStream.Size);
      FTempStream.Position := 0;
      FTempStream.Read(TempStr[1], FTempStream.Size);
      Result := String(TempStr);
{$ELSE}
      SetLength(Result, FTempStream.Size);
      FTempStream.Position := 0;
      FTempStream.Read(Result[1], FTempStream.Size);
{$ENDIF}
      FRichEdit.PlainText := False;
      FTStream.Position := 0;
      FRichEdit.Lines.LoadFromStream(FTStream);
    finally
      FTStream.Free;
    end;
  end
  else
  begin
    FTempStream.Clear;
    FRichEdit.Lines.SaveToStream(FTempStream);
{$IFDEF Delphi12}
    SetLength(TempStr, FTempStream.Size);
    FTempStream.Position := 0;
    FTempStream.Read(TempStr[1], FTempStream.Size);
    Result := String(TempStr);
{$ELSE}
    SetLength(Result, FTempStream.Size);
    FTempStream.Position := 0;
    FTempStream.Read(Result[1], FTempStream.Size);
{$ENDIF}
  end;
end;

function TfrxRichView.HasNextDataPart(aFreeSpace: Extended): Boolean;
begin
  Result := FHasNextDataPart and (StretchMode <> smDontStretch) or
    Inherited HasNextDataPart(aFreeSpace);
end;

function TfrxRichView.IsEMFExportable: Boolean;
begin
  Result := AllowVectorExport;
end;



initialization
{$IFDEF DELPHI16}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfrxRichObject, TControl);
{$ENDIF}
  frxObjects.RegisterObject1(TfrxRichView, nil, '', '', 0, 26);
{$IFNDEF NO_CRITICAL_SECTION}
  frxCSRich := TCriticalSection.Create;
{$ENDIF}

finalization
  frxObjects.UnRegister(TfrxRichView);
{$IFNDEF NO_CRITICAL_SECTION}
  frxCSRich.Free;
{$ENDIF}


end.
