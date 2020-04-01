
{******************************************}
{                                          }
{             FastReport v5.0              }
{             RB -> FR  importer           }
{                                          }
{         Copyright (c) 1998-2014          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit ConverterRB2FR ;

interface

{$I frx.inc}

implementation

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Printers, TypInfo, Jpeg, DB,
  frxClass, frxVariables, frxPrinter, frxDCtrl, frxBarcode, frxBarcod,
  {$IFDEF DELPHI16}
  VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart, VCLTee.Series, VCLTee.TeCanvas
{$ELSE}
  TeeProcs, TeEngine, Chart, Series, TeCanvas
{$ENDIF}
{$IFDEF DELPHI16}
 {$IFDEF TeeChartPro}, VCLTEE.TeeEdit{$IFNDEF TeeChart4}, VCLTEE.TeeEditCha{$ENDIF} {$ENDIF}
{$ELSE}
 {$IFDEF TeeChartPro}, TeeEdit{$IFNDEF TeeChart4}, TeeEditCha{$ENDIF} {$ENDIF}
{$ENDIF}
, frxChart, frxChBox, frxOLE, frxRich,
  frxCross, frxDBSet, frxUnicodeUtils, frxUtils, fs_ipascal,
  frxCustomDB, frxBDEComponents, frxADOComponents, frxIBXComponents
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxFR2EventsNew = class(TObject)
  private
    function DoLoad(Sender: TfrxReport; Stream: TStream): Boolean;
  end;

  TppDuplex = (dpNone, dpHorizontal, dpVertical);
  TppFrame = (bpLeft, bpRight, bpTop, bpBottom);
  TShapeType = (stRectangle, stRoundRect, stEllipse, stSquare, stRoundSquare ,stCircle);
  TRBVarType =(vtDate, vtDateTime, vtDocumentName, vtPrintDateTime, vtPageCount ,vtPageSet,vtPageSetDesc,vtPageNo, vtPageNoDesc, vtTime);
  TppBarTypes = (bcUPC_A, bcUPC_E, bcEAN_13, bcEAN_8, bcInt2of5, bcCode128, bcCode39, bcPostnet, bcFIM, bcCodabar, bcMSI);

  TAssignProp = procedure ();

var
  frxFR2EventsNew: TfrxFR2EventsNew;


const RBVarsCat = ' RBVariables'; 
function LoadFromRB(AReport: TfrxReport; AStream: TStream): Boolean;
Var
  Reader: TReader;
  SaveSeparator: Char;
  ClassName,ObjectName,PropName: string;
  Flags: TFilerFlags;
  Position: Integer;
  Val:Variant;
  LastObj: TfrxComponent;
  Parent: TfrxComponent;
  isBin: Boolean;
  Sig: AnsiString;
  CurY: Extended;
  DataBand: TfrxBand;
  DSName: String;


 function GetBoolValue(Str: String): Boolean;
 begin
  Result := False;
  If CompareStr(Str,'True') = 0 then
    Result := True;
 end;

 procedure AssignReport();
 var
   Page: TfrxReportPage;
   i: Integer;
 begin
  Page := LastObj as TfrxReportPage;
  {Page property}
  if PropName = 'PrinterSetup.mmPaperHeight' then
    Page.PaperHeight := Val/1000
  else if PropName = 'PrinterSetup.mmPaperWidth' then
    Page.PaperWidth := Val/1000
  else if PropName = 'PrinterSetup.mmMarginTop' then
    Page.TopMargin := Val/1000
  else if PropName = 'PrinterSetup.mmMarginBottom' then
    Page.BottomMargin := Val/1000
  else if PropName = 'PrinterSetup.mmMarginLeft' then
  begin
    Page.LeftMargin := Val/1000;
    for i := 0 to Page.ColumnPositions.Count - 1 do
      Page.ColumnPositions[i] := FloatToStr(StrToFloat(Page.ColumnPositions[i]) - Page.LeftMargin);
  end
  else if PropName = 'PrinterSetup.mmMarginRight' then
    Page.RightMargin := Val/1000
  else if PropName = 'PrinterSetup.PaperSize' then
    Page.PaperSize := Val
  else if PropName = 'PrinterSetup.BinName' then
    Page.Bin := frxPrinters.Printer.BinNameToNumber(Val)
  else if PropName = 'Columns' then
  begin
    Page.Columns := Val;
    Page.ColumnPositions.Clear;
  end
  else if PropName = 'ColumnPositions.Strings' then
    Page.ColumnPositions.Add(FloatToStr((StrToFloat(Val))/10000 * fr01in))
  else if PropName = 'mmColumnWidth' then
    Page.ColumnWidth := Val/10000 * fr01in
  else if PropName = 'PrinterSetup.Orientation' then
    Page.Orientation := TPrinterOrientation(GetEnumValue(TypeInfo(TPrinterOrientation), Val))
  else if PropName  = 'PrinterSetup.Duplex' then
    Page.Duplex := TfrxDuplexMode(GetEnumValue(TypeInfo(TppDuplex),Val))
  else if PropName = 'PrinterSetup.Copies' then
    AReport.PrintOptions.Copies := Val
  else if PropName = 'PrinterSetup.PrinterName' then
    AReport.PrintOptions.Printer := Val
  else if PropName = 'PrinterSetup.DocumentName' then
    AReport.ReportOptions.Name := Val
  else if PropName = 'DataPipeline' then
  begin
    i := pos('.', Val) + 1;
    DSName := Val;
    if i > 0 then
      DSName := copy(Val, i, length(DSName) - i)
    else DSName := '';
  end;

 end;

 procedure AssignHeader();
 var
  Header: TfrxHeader;
 begin
  Header := LastObj as TfrxHeader;
  if PropName = 'mmHeight' then
    Header.Height := Val / 10000 * fr1cm
 end;

 procedure AssignDBProp;
 var
  View: TfrxView;
  i: Integer;
 begin
   View := LastObj as TfrxView;
   if PropName = 'DataPipeline' then
   begin
     i := pos('.', Val) + 1;
     View.DataSetName := Val;
     if i <> - 1 then
       View.DataSetName := copy(Val, i, length(View.DataSetName) - i)
     else View.DataSetName := '';
   end
   else
   if PropName = 'DataField' then
    View.DataField := Val
   else if PropName = 'DataPipelineName' then
     View.DataSetName := Val
 end;

 function GetCharsetByName(cName: String):TFontCharset;
 begin
   if cName = 'ANSI_CHARSET' then
     Result := ANSI_CHARSET
   else if cName = 'DEFAULT_CHARSET' then
     Result := DEFAULT_CHARSET
   else if cName = 'SYMBOL_CHARSET' then
     Result := SYMBOL_CHARSET
   else if cName = 'MAC_CHARSET' then
     Result := MAC_CHARSET
   else if cName = 'SHIFTJIS_CHARSET' then
     Result := SHIFTJIS_CHARSET
   else if cName = 'HANGEUL_CHARSET' then
     Result := HANGEUL_CHARSET
   else if cName = 'JOHAB_CHARSET' then
     Result := JOHAB_CHARSET
   else if cName = 'GB2312_CHARSET' then
     Result := GB2312_CHARSET
   else if cName = 'CHINESEBIG5_CHARSET' then
     Result := CHINESEBIG5_CHARSET
   else if cName = 'GREEK_CHARSET' then
     Result := GREEK_CHARSET
   else if cName = 'TURKISH_CHARSET' then
     Result := TURKISH_CHARSET
   else if cName = 'HEBREW_CHARSET' then
     Result := HEBREW_CHARSET
   else if cName = 'ARABIC_CHARSET' then
     Result := ARABIC_CHARSET
   else if cName = 'BALTIC_CHARSET' then
     Result := BALTIC_CHARSET
   else if cName = 'RUSSIAN_CHARSET' then
     Result := RUSSIAN_CHARSET
   else if cName = 'THAI_CHARSETT' then
     Result := THAI_CHARSET
   else if cName = 'EASTEUROPE_CHARSET' then
     Result := EASTEUROPE_CHARSET
   else if cName = 'OEM_CHARSET' then
     Result := OEM_CHARSET
   else
    Result := 1;
 end;

 procedure AssignFont;
 var
  View: TfrxView;
 begin
   View := LastObj as TfrxView;
   if View = nil then exit;
   if PropName = 'Font.Charset' then
    View.Font.Charset :=  GetCharsetByName(Val)
   else if PropName = 'Font.Color' then
    View.Font.Color := StringToColor(Val)
   else if PropName = 'Font.Name' then
    View.Font.Name := Val
   else if PropName = 'Font.Size' then
    View.Font.Size := Val
   else if PropName = 'Font.Style' then
    View.Font.Style := View.Font.Style + [TFontStyle(GetEnumValue(TypeInfo(TFontStyle), Val))]
 end;


 procedure AssignBandData;
 var
  B: TfrxDataBand;
 begin
   B := LastObj as TfrxDataBand;
   if B = nil then exit;
   B.DataSetName := DSName;
 end;

 procedure AssignBorder;
 var
   frxView: TfrxView;
 begin
   frxView := lastObj as TfrxView;
   if frxView = nil then exit;
   if PropName = 'Border.BorderPositions' then
    frxView.Frame.Typ := frxView.Frame.Typ + [TfrxFrameType(GetEnumValue(TypeInfo(TppFrame),Val))]
   else if PropName = 'Border.Color' then
    frxView.Frame.Color := StringToColor(Val)
   else if PropName = 'Border.Style' then
    frxView.Frame.Style := TfrxFrameStyle(GetEnumValue(TypeInfo(TPenStyle),Val))
 end;

 procedure AssignMemo();
 var
   Memo: TfrxMemoView;
 begin
   Memo := LastObj as TfrxMemoView;

   if PropName = 'mmHeight' then
    Memo.Height := Val/10000 * fr1cm
   else if PropName = 'mmWidth' then
    Memo.Width := Val/10000 * fr1cm
   else if PropName = 'mmLeft' then
    Memo.Left := Val/10000 * fr1cm
   else if PropName = 'mmTop' then
    Memo.Top := Val/10000 * fr1cm
   else if (PropName = 'Caption') and (Memo.Text = '') then
    Memo.Text := Val
   else if PropName = 'UserName' then
    Memo.Name := Val
   else if PropName = 'Angle' then
    Memo.Rotation := Val
   else if PropName= 'Color' then
    Memo.Color := StringToColor(Val)
   else if PropName = 'CharWrap' then
    Memo.WordWrap := Val
   else if Pos('Border', PropName) = 1 then
    AssignBorder
   else if Pos('Font', PropName) = 1 then
    AssignFont
   else if PropName = 'BlankWhenZero' then
    Memo.HideZeros := Val
   else if PropName = 'SuppressRepeatedValues' then
    Memo.SuppressRepeated := Val
   else if PropName = 'TextAlignment' then
   begin
      if Val = 'taLeftJustified' then
        Memo.HAlign := haLeft
      else if Val = 'taRightJustified' then
        Memo.HAlign := haRight
      else if Val = 'taCentered' then
        Memo.HAlign := haCenter
      else if Val = 'taFullJustified' then
        Memo.HAlign := haBlock;
   end
   else if PropName = 'WordWrap' then
    Memo.WordWrap := Val
   else if PropName = 'Stretch' then
   begin
    if Val then
      Memo.StretchMode := smActualHeight
    else
      Memo.StretchMode := smDontStretch;
   end
   else if PropName = 'Lines.Strings' then
    Memo.Lines.Add(Val);
   if (Pos('DB', ClassName) = 4) and (Memo.DataSetName <> '') and (Memo.DataField <> '')  then
    Memo.Text := '['+ Memo.DataSetName + '."' + Memo.DataField + '"]'

{DBCalcType}
 end;

 procedure AssignBarCode;
  var
   Bar: TfrxBarCodeView;
 begin
   Bar := LastObj as TfrxBarCodeView;
   if Bar = nil then exit;
   if PropName = 'BarCodeType' then
   case GetEnumValue(TypeInfo(TppBarTypes),Val) of
     0: Bar.BarType := bcCodeUPC_A;
     1: Bar.BarType := bcCodeUPC_E0;
     2: Bar.BarType := bcCodeEAN13;
     3: Bar.BarType := bcCodeEAN8;
     4: Bar.BarType := bcCode_2_5_interleaved;
     5: Bar.BarType := TfrxBarcodeType(5);
     6: Bar.BarType := TfrxBarcodeType(12);
     7: Bar.BarType := bcCodePostNet;
     8: Bar.BarType := bcCode_2_5_industrial;
     9: Bar.BarType := bcCodeCodabar;
     10: Bar.BarType :=  bcCodeMSI;
   end
   else if PropName = 'Data' then
    Bar.Text := Val
   //else if PropName = 'mmBarWidth' then
   // Bar.Width := Val
   else if PropName = 'mmWideBarRatio' then
    Bar.WideBarRatio := round(Val/1000000 * fr1cm)
   else if PropName = 'PrintHumanReadable' then
    Bar.ShowText := Val
   else if PropName = 'BarColorCalcCheckDigit' then
    Bar.CalcCheckSum := Val
 end;

 procedure ObjectCreator(Name:String);
 begin
  if Name = 'TppReport' then
  begin
    LastObj := TfrxReportPage.Create(AReport);
    Parent := LastObj;
    TfrxReportPage(LastObj).CreateUniqueName;
    TfrxReportPage(LastObj).SetDefaults;
  end
  else if Name = 'TppHeaderBand' then
  begin
    LastObj := TfrxHeader.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if Name = 'TppTitleBand' then
  begin
    LastObj := TfrxReportTitle.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if Name = 'TppColumnHeaderBand' then
  begin
    LastObj := TfrxColumnHeader.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppLabel') or (Name = 'TppSystemVariable')
       or (Name = 'TppVariable') or (Name = 'TppMemo')
       or (Name = 'TppDBText') or (Name = 'TppDBMemo') or (Name = 'TppDBCalc') then
  begin
    LastObj := TfrxMemoView.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppImage') or (Name = 'TppDBImage') then
  begin
    LastObj := TfrxPictureView.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppShape') then
  begin
    LastObj := TfrxShapeView.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppDetailBand') then
  begin
    LastObj := TfrxMasterData.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppColumnHeaderBand') then
  begin
    LastObj := TfrxColumnHeader.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppColumnFooterBand') then
  begin
    LastObj := TfrxColumnFooter.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppFooterBand') then
  begin
    LastObj := TfrxFooter.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppSummaryBand') then
  begin
    LastObj := TfrxReportSummary.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppBarCode') or (Name = 'TppDBBarCode') then
  begin
    LastObj := TfrxBarCodeView.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppRichText') or (Name = 'TppDBRichText') then
  begin
    LastObj := TfrxRichView.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TmyCheckBox') or (Name = 'TmyDBCheckBox') then
  begin
    LastObj := TfrxCheckBoxView.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppLine') then
  begin
    LastObj := TfrxLineView.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppGroupHeaderBand') then
  begin
    LastObj := TfrxGroupHeader.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TppGroupFooterBand') then
  begin
    LastObj := TfrxGroupFooter.Create(Parent);
    LastObj.CreateUniqueName;
  end
  else if (Name = 'TdaSQL') then
  begin
    LastObj := TfrxADOQuery.Create(AReport.Pages[0]);
    LastObj.CreateUniqueName;
  end
 end;


 procedure AssignView;
 begin
     if PropName = 'mmHeight' then
      LastObj.Height := Val/10000 * fr1cm
    else if PropName = 'mmWidth' then
      LastObj.Width := Val/10000 * fr1cm
    else if PropName = 'mmLeft' then
      LastObj.Left := Val/10000 * fr1cm
    else if PropName = 'mmTop' then
      LastObj.Top := Val/10000 * fr1cm
    else if PropName = 'Visible' then
       LastObj.Visible := Val
 end;

 procedure AssignADOQuery;
 var
   Query: TfrxADOQuery;
 begin
   Query := LastObj as TfrxADOQuery;
   if Query = nil then exit;
   if PropName = 'DataPipelineName' then
   begin
     Query.UserName := Val;
     Query.Name := Val;
   end
   else if PropName = 'SQLText.Strings' then
     Query.SQL.Add(Val)
 end;

 procedure AssignPicture;
 var
   Stream: TMemoryStream;
   Cn: Integer;
 begin
  if PropName = 'Picture.Data' then
    begin
      Stream := TMemoryStream.Create;
      Cn := 0;
      TMemoryStream(frxInteger(Val)).Position := 0;
      TMemoryStream(frxInteger(Val)).Read(Cn, 1);
      TMemoryStream(frxInteger(Val)).Position := Cn + 5;
      Stream.SetSize(TMemoryStream(frxInteger(Val)).Size - (Cn + 5));
      Stream.CopyFrom(TMemoryStream(frxInteger(Val)), Stream.Size);
      TfrxPictureView(LastObj).LoadPictureFromStream(Stream);
      Stream.Free;
    end;
 end;

 procedure AssignProp;
 begin
   if Pos('DB', ClassName) = 4 then
    AssignDBProp;
   if (PropName = 'UserName') and not (LastObj is TfrxPage) then
    LastObj.Name := Val
   else if ClassName = 'TppReport' then
     AssignReport
   {else if ClassName = 'TppHeaderBand' then
     AssignHeader}
   else if (ClassName = 'TppTitleBand') or (ClassName = 'TppColumnHeaderBand') or (ClassName = 'TppDetailBand')
   or (ClassName = 'TppColumnHeaderBand') or ( ClassName = 'TppColumnFooterBand') or (ClassName = 'TppFooterBand')
   or (ClassName = 'TppSummaryBand') or (ClassName = 'TppHeaderBand') or (ClassName = 'TppGroupHeaderBand')
   or (ClassName = 'TppGroupFooterBand') then
   begin
     if ClassName = 'TppDetailBand' then
      AssignBandData;
     if PropName = 'mmHeight' then
     begin
       TfrxBand(LastObj).Top := CurY;
       TfrxBand(LastObj).Height := Val / 10000 * fr1cm;
       CurY := CurY + TfrxBand(LastObj).Height + 1;
     end
     else if PropName = 'Visible' then
       LastObj.Visible := Val
     else if (ClassName = 'TppGroupHeaderBand') then
     begin
        if DataBand <> nil then
        begin
          DataBand.FGroup := TfrxGroupHeader(LastObj);
          LastObj.Top := DataBand.Top ;
        end
     end
     else if (ClassName = 'TppGroupFooterBand') then
     begin
        if DataBand <> nil then
        begin
          LastObj.Top := DataBand.Top + DataBand.Height;
        end
     end
     else if (ClassName = 'TppDetailBand') then
        DataBand := LastObj as TfrxBand
     else if(ClassName = 'TppSummaryBand') then
       if PropName = 'NewPage' then
         TfrxReportSummary(LastObj).StartNewPage := Val;
   end
   else if (ClassName = 'TppLabel')
        or (ClassName = 'TppMemo') or (ClassName = 'TppDBText') or (ClassName = 'TppDBCalc')
        or (ClassName = 'TppDBMemo') then
     AssignMemo
   else if (ClassName = 'TppSystemVariable') then
   begin
     AssignMemo;
     if PropName = 'VarType' then
      case TRBVarType(GetEnumValue(TypeInfo(TRBVarType),Val)) of
        vtDate : TfrxCustomMemoView(LastObj).Text := '[Date]';
        vtDateTime : TfrxCustomMemoView(LastObj).Text := '[Now]';
        vtDocumentName : TfrxCustomMemoView(LastObj).Text := '[Report.ReportOptions.Name]';
        vtPrintDateTime : TfrxCustomMemoView(LastObj).Text := 'PrintDateTime does not exist in Fast Report';
        vtPageCount : TfrxCustomMemoView(LastObj).Text := '[TotalPages#]';
        vtPageSet : TfrxCustomMemoView(LastObj).Text := '[Page#] of [TotalPages#]';
        vtPageSetDesc : TfrxCustomMemoView(LastObj).Text := 'Page [Page#] of [TotalPages#]';
        vtPageNo : TfrxCustomMemoView(LastObj).Text := '[Page#]';
        vtPageNoDesc : TfrxCustomMemoView(LastObj).Text := 'Page [Page#]';        vtTime : TfrxCustomMemoView(LastObj).Text := '[Time]';        else TfrxCustomMemoView(LastObj).Text := 'Unknown Variable';      end;
   end
   else if (ClassName = 'TppVariable') then
   begin
    AssignMemo;
    if AReport.Variables.IndexOf(RBVarsCat)  = -1 then
      with AReport.Variables.Add do
      begin
        Name := RBVarsCat;
        Value := Null;
      end;
    AReport.Variables.AddVariable('RBVariables', 'Report' + LastObj.Name, '''' + '''');
    TfrxCustomMemoView(LastObj).Text := '[Report' + LastObj.Name + ']';
   end
   else if (ClassName = 'TppImage') or (ClassName = 'TppDBImage') then
   begin
     AssignView;
     AssignBorder;
     AssignPicture;
   end
   else if (ClassName = 'TppShape') then
   begin
     AssignView;
     if PropName = 'Shape' then
     begin
       TfrxShapeView(LastObj).Shape := TfrxShapeKind(GetEnumValue(TypeInfo(TShapeType),Val));
       if (Val = 'stRoundRect') or (Val = 'stRoundSquare') then
         TfrxShapeView(LastObj).Curve := 2;
     end;
   end
   else if (ClassName = 'TppBarCode') or (ClassName = 'TppDBBarCode') then
   begin
     AssignView;
     AssignBorder;
     AssignBarCode;
   end
   else if (ClassName = 'TppRichText') or (ClassName = 'TppDBRichText') then
   begin
     AssignView;
     AssignBorder;
     if PropName = 'RichText' then
      TfrxRichView(LastObj).RichEdit.Text := String(Val)
     else if PropName = 'Stretch' then
     begin
      if Val then
        TfrxRichView(LastObj).StretchMode := smActualHeight
      else
        TfrxRichView(LastObj).StretchMode := smDontStretch;
      end   
   end
   else if (ClassName = 'TmyCheckBox') or (ClassName = 'TmyDBCheckBox') then
   begin
     AssignView;
     AssignBorder;
   end
   else if (ClassName ='TppLine') then
   begin
      AssignView;
      AssignBorder;
   end
   else if (ClassName = 'TdaSQL') then
   begin
      AssignView;
      AssignADOQuery;
   end
 end;

  procedure ConvertBinary;
  var
    Count: Longint;
    Stream: TMemoryStream;
  begin
    Reader.ReadValue;
    Reader.Read(Count, SizeOf(Count));
    Stream := TMemoryStream.Create;
    Stream.SetSize(Count);
    Reader.Read(Stream.Memory^, Count);
    Val := frxInteger(Stream);
  end;

 procedure ReadProperty; forward;
 procedure ConvertValue;
  var
    L: Integer;
    S: string;
    W: WideString;
  begin
    case Reader.NextValue of
      vaList:
        begin
          Reader.ReadValue;
          while not Reader.EndOfList do
          begin
            ConvertValue;
          end;
          Reader.ReadListEnd;
          exit;
        end;
      vaInt8, vaInt16, vaInt32:
        Val := IntToStr(Reader.ReadInteger);
      vaExtended:
        Val := FloatToStrF(Reader.ReadFloat, ffFixed, 16, 18);
      vaSingle:
        Val := FloatToStr(Reader.ReadSingle) + 's';
      vaCurrency:
        Val := FloatToStr(Reader.ReadCurrency * 10000) + 'c';
      vaDate:
        Val := FloatToStr(Reader.ReadDate) + 'd';
      vaWString, vaUTF8String:
        begin
          W := Reader.ReadWideString;
          L := Length(W);
          if L = 0 then W :=  '';
          Val := W;
        end;
      vaString, vaLString:
        begin
          S := Reader.ReadString;
          L := Length(S);
          if L = 0 then S :=  '';
          Val := S;
        end;
      vaIdent, vaFalse, vaTrue, vaNil, vaNull:
        Val := Reader.ReadIdent;
      vaBinary:
        begin
          isBin := True;
          ConvertBinary;
        end;
      vaSet:
        begin
          Reader.ReadValue;

          while True do
          begin
            S := Reader.ReadStr;
            if S = '' then exit;
            Val := S;
            AssignProp;
          end;
        end;
      vaCollection:
        begin
          Reader.ReadValue;
          while not Reader.EndOfList do
          begin
            if Reader.NextValue in [vaInt8, vaInt16, vaInt32] then
            begin
              ConvertValue;
            end;
            Reader.CheckValue(vaList);
            while not Reader.EndOfList do ReadProperty;
            Reader.ReadListEnd;

          end;
          Reader.ReadListEnd;
        end;
      vaInt64:
        Val := IntToStr(Reader.ReadInt64);
    end;
      AssignProp;
  end;


 procedure ReadProperty;
  begin
    PropName := Reader.ReadStr;
    ConvertValue;
  end;

 procedure ReadObject;
  var
    LastParent: TfrxComponent;
  begin
    Reader.ReadPrefix(Flags, Position);
    if (ffInherited in Flags) or(ffInline in Flags)  then exit;
    ClassName := Reader.ReadStr;
    ObjectName := Reader.ReadStr;
    ObjectCreator(ClassName);
    LastParent := LastObj;
    while not Reader.EndOfList do
    begin
      ReadProperty;
      if isBin then
      begin
        TMemoryStream(frxInteger(Val)).Free;
        isBin := False;
      end;
    end;
    if (LastObj.Parent <> nil) and not (LastObj.Parent is TfrxReport)  then
      LastObj := LastObj.Parent;
    Reader.ReadListEnd;
    while not Reader.EndOfList do
    begin
      Parent := LastParent;
      ReadObject;
    end;
    Reader.ReadListEnd;
  end;

begin
  Result := False;
  SetLength(Sig, 3);
  AStream.Position := 0;
  AStream.Read(Sig[1], 3);
  AStream.Position := 0;
  if Sig <> 'TPF' then exit;
  AReport.Clear;
  with TfrxDataPage.Create(AReport) do
  begin
    CreateUniqueName;
  end;
  Reader := TReader.Create(AStream, 4096);
{$IFDEF Delphi16}
  SaveSeparator := FormatSettings.DecimalSeparator;
{$ELSE}
  SaveSeparator := DecimalSeparator;
{$ENDIF}

  isBin  := False;
  CurY := 0;
{$IFDEF Delphi16}
  FormatSettings.DecimalSeparator := '.';
{$ELSE}
  DecimalSeparator := '.';
{$ENDIF}

  try
    Reader.ReadSignature;
    Reader.ReadPrefix(Flags, Position);
    ReadObject;
    Result := True;
  finally
    Reader.Free;
  end;
{$IFDEF Delphi16}
  FormatSettings.DecimalSeparator := SaveSeparator;
{$ELSE}
  DecimalSeparator := SaveSeparator;
{$ENDIF}

end;

function TfrxFR2EventsNew.DoLoad(Sender: TfrxReport; Stream: TStream): Boolean;
var
  Sig: AnsiString;
  TmpStream: TMemoryStream;
begin
  SetLength(Sig, 6);
  Stream.Position := 0;
  Stream.Read(Sig[1], 6);
  Stream.Position := 0;
  if Sig = 'object' then
  begin
    TmpStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(Stream, TmpStream);
      Result := LoadFromRB(Sender, TmpStream);
    finally
      TmpStream.Free;
    end;
  end
  else
    Result := LoadFromRB(Sender, Stream);
end;



initialization
  frxFR2EventsNew := TfrxFR2EventsNew.Create;
  frxFR2Events.OnLoad := frxFR2EventsNew.DoLoad;
  frxFR2Events.Filter := '*.rtm';

finalization
  frxFR2EventsNew.Free;


end.