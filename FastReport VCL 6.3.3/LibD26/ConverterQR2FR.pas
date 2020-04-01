{******************************************}
{                                          }
{             FastReport 6                 }
{        Converter from QuickReport        }
{                                          }
{         Copyright (c) 2007-2018          }
{           by Alexander Syrykh            }
{            Fast Reports Inc.             }
{                                          }
{                                          }
{******************************************}

{The following works for me with FR6 :

1. Create a new program (File -> New -> VCL Forms Application).

2. Project -> Add -> Browse and find ConverterQR2FR.pas.

3. Depending on the components you have installed, you might have to remove the following units from the uses list in ConverterQR2FR:

VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart, VCLTee.Series, VCLTee.TeCanvas
frxChart, frxBDEComponents, frxIBXComponents

Removing them should be safe, since your report doesn't use TeeChart.

4. Add the following to the form:
frxReport
OpenDialog
SaveDialog
Button

5. Put this in the Button OnClick event:

Code:
  if OpenDialog1.Execute then
  begin
    if frxReport1.LoadFromFile(OpenDialog1.FileName) then
    begin
      if SaveDialog1.Execute then
      begin
        frxReport1.SaveToFile(SaveDialog1.FileName);
      end;
    end;
  end;
6. Run the program, click the button.  }

unit ConverterQR2FR;

interface
{$I frx.inc}
implementation

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Printers, TypInfo, Jpeg, DB,
  frxClass, frxVariables, frxPrinter, frxDCtrl, frxBarcode, frxBarcod, StrUtils,
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
 ,frxChart, frxChBox, frxOLE, frxRich,
  frxCross, frxDBSet, frxUnicodeUtils, frxUtils, fs_ipascal,
  frxCustomDB,frxBarcode2D {frxBDEComponents,}{ frxADOComponents, frxIBXComponents }
{$IFDEF Delphi6}
, Variants
{$ENDIF};
type
  TConverterQr2FrNew = class(TObject)
  private
    function DoLoad(Sender: TfrxReport; Stream: TStream): Boolean;
  end;

  TppDuplex = (dpNone, dpHorizontal, dpVertical);
  TShapeType = (stRectangle, stRoundRect, stEllipse, stSquare,
                stRoundSquare ,stCircle);

  TUnits =    (Characters, Inches, MM, Pixel, Native) ;


  TAssignProp = procedure ();



var
  frxFR2EventsNew: TConverterQr2FrNew;


function LoadFromQR(AReport: TfrxReport; AStream: TStream): Boolean;
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


procedure AssignDBProp;
 var
  View: TfrxView;
  i: Integer;
 begin
   View := LastObj as TfrxView;
   if PropName = 'DataSet' then
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

 function GetFrameStyle(PStyle : String): TfrxFrameStyle;
 var  PenStyle: TPenStyle;
begin
  PenStyle :=   TPenStyle(GetEnumValue(TypeInfo(TPenStyle), Val));


  if PenStyle = psDash            then  Result := TfrxFrameStyle.fsDash
  else if PenStyle = psDot        then  Result := TfrxFrameStyle.fsDot
  else if PenStyle = psDashDot    then  Result := TfrxFrameStyle.fsDashDot
  else if PenStyle = psDashDotDot then  Result := TfrxFrameStyle.fsDashDotDot
  else Result := TfrxFrameStyle.fsSolid;
end;

function GetStretch(AutoStretch:boolean): TfrxStretchMode;
begin
  if AutoStretch then result:= smMaxHeight
  else result:= smDontStretch;
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
   else if PropName = 'Font.Height' then
    View.Font.Height := Val
   else if PropName = 'Font.Name' then
    View.Font.Name := Val
   else if PropName = 'FontSize' then
    View.Font.Size := Val
   else if PropName = 'Font.Style' then
    View.Font.Style := View.Font.Style + [TFontStyle(GetEnumValue(TypeInfo(TFontStyle), Val))]
 end;

procedure AssignReport();
 var
   Page: TfrxReportPage;
 begin

    Page := LastObj as TfrxReportPage;
  {Page property}
    if  (ClassName = 'TQuickRep') or (ClassName = 'TDesignQuickReport') then
      Page.Name := ObjectName;

    if PropName = 'Page.mmPaperHeight' then
      Page.PaperHeight := Val
    else if PropName = 'PrinterSetup.mmPaperWidth' then
      Page.PaperWidth := Val
    else if PropName = 'PrinterSetup.mmMarginTop' then
      Page.TopMargin := Val
    else if PropName = 'PrinterSetup.mmMarginBottom' then
      Page.BottomMargin := Val

    else if PropName = 'Width' then
      AReport.Width := Val
    else if PropName = 'Height' then
      AReport.Height := Val

    else if PropName = 'Frame.Color' then
      Page.Frame.Color :=  StringToColor(Val)
    else if PropName = 'Frame.DrawTop' then
      if GetBoolValue(Val) then
        Page.Frame.Typ := Page.Frame.Typ +[ftTop]
      else
        Page.Frame.Typ := Page.Frame.Typ -[ftTop]

    else if PropName = 'Frame.DrawBottom' then
      if GetBoolValue(Val) then
        Page.Frame.Typ := Page.Frame.Typ +[ftBottom]
      else
        Page.Frame.Typ := Page.Frame.Typ -[ftBottom]

    else if PropName = 'Frame.DrawLeft' then
      if GetBoolValue(Val) then
        Page.Frame.Typ := Page.Frame.Typ +[ftLeft]
      else
        Page.Frame.Typ := Page.Frame.Typ -[ftLeft]

    else if PropName = 'Frame.DrawRight' then
      if GetBoolValue(Val) then
        Page.Frame.Typ := Page.Frame.Typ +[ftRight]
      else
        Page.Frame.Typ := Page.Frame.Typ -[ftRight]

    else if PropName = 'DataSet' then
        AReport.DataSetName:= Val

    else if PropName = 'Font.Charset' then
      Page.Font.Charset :=  GetCharsetByName(Val)
    else if PropName = 'Font.Color' then
      Page.Font.Color := StringToColor(Val)
    else if PropName = 'Font.Height' then
      Page.Font.Height := Val
    else if PropName = 'Font.Name' then
      Page.Font.Name := Val
    else if PropName = 'FontSize' then
      Page.Font.Size := Val
    else if PropName = 'Font.Style' then
      Page.Font.Style := Page.Font.Style + [TFontStyle(GetEnumValue
                                      (TypeInfo(TFontStyle), Val))]

    else if PropName = 'Page.Columns' then
    begin
      Page.Columns := Val;
      Page.ColumnPositions.Clear;
    end
    else if PropName = 'Page.PaperSize' then
      //Page.PaperSize := Val
    else if PropName = 'Page.Orientation' then
      if (Val='poPortrait') then  Page.Orientation := poPortrait
      else Page.Orientation := poLandscape

    else if PropName = 'PrinterSetup.Copies' then
      AReport.PrintOptions.Copies := Val
    else if PropName  = 'PrinterSetup.Duplex' then
      Page.Duplex := TfrxDuplexMode(GetEnumValue(TypeInfo(TppDuplex),Val))

    else if PropName = 'PrinterSettings.OutputBin' then
      Page.Bin := frxPrinters.Printer.BinNameToNumber(Val)

    else if PropName = 'PrintIfEmpty' then
      Page.PrintIfEmpty :=  GetBoolValue(Val)
 end;

 //QRExpr
function ReplaceExpr(BandName, ItemName, s: string;
                      IsCondition, IsFilter:boolean): string;
var sExpr, sSub, sDS :string;
    i:integer;
    bQS:boolean;

const  cExprOper: array[1..17] of string = ( '+' , '-' , '/' , '*' , '>' , '<' ,
        '=' , '>=' , '<=' , '<>' , '(' , ')', '[' , ']' , '''' , '.' , ',' );
       cExprFun : array[1..45] of string =
       //QR
       ( 'IF', 'STR', 'UPPER', 'LOWER', 'PRETTY', 'TIME', 'DATE', 'COPY', 'SUM',
       'COUNT', 'MAX', 'MIN','AVERAGE', 'TRUE', 'FALSE', 'INT', 'FRAC', 'SQRT',
       'DIV', 'TYPEOF','FORMATNUMERIC',
        //QRDesign
       'ABS', 'CALCDATE', 'DAYOFWEEK', 'DAYSTRING', 'EXTRACTDAY','EXTRACTMONTH',
       'EXTRACTYEAR', 'FIELDLEN','GETCAPTION','ISNUL','MONTHSTRING', 'PADLEFT',
       'PADRIGHT','PRINTDATE', 'QUERYNAME', 'READINI','READREGISTRY',
       'REFORMATDATE', 'STRTONUM', 'TRIM', 'VAR', 'ISEMPTY','PAGENUMBER',
       'PAGECOUNT' );
  //--------------------------------------------------
  Function IsNum(s:string):Boolean;
  var x:integer;
  begin
    Result := False;
    for x := 1 to Length(s) do
      case s[x] of
        '0'..'9','.': Result := True;
      else
        Result := False;
        break;
      end;
  end;
  //--------------------------------------------------
  Function TrimControl(s:string):string;
  var i:integer;
  begin
    for i := 1 to Length(s) do
      if not CharInSet(s[i],[#9, #10, #13]) then Result := Result+s[i];
  end;
  //--------------------------------------------------
  Function GetSub(sOper:string):string;
  begin
    if MatchText(sSub,cExprFun) then
    begin
      { some are translated, some the same, some need to be
      checked/changed manualy }
      if      sSub = 'PAGENUMBER'     then sSub:='Page#'
      else if sSub = 'PAGECOUNT'      then sSub:='TotalPages#'
      else if sSub = 'PRINTDATE'      then sSub:='Date'
      else if sSub = 'EXTRACTDAY'     then sSub:='DayOf'
      else if sSub = 'EXTRACTMONTH'   then sSub:='MonthOf'
      else if sSub = 'EXTRACTYEAR'    then sSub:='YearOf'
      else if sSub = 'STRTONUM'       then sSub:='StrToFloat'
      else if sSub = 'FORMATNUMERIC'  then sSub:='FormatFloat'
      else if sSub = 'STR'            then sSub:='StrToInt'
      else if sSub = 'IF'             then sSub:='IIF'
      else if sSub = 'AVERAGE'        then sSub:='AVG'
      else if sSub = 'TRUE'           then sSub:='BoolToStr(True)'
      else if sSub = 'FALSE'          then sSub:='BoolToStr(False)'
      else if sSub = 'COUNT'          then sSub:='Count()'
      else if sSub = 'UPPER'          then sSub:='Uppercase'
      else if sSub = 'LOWER'          then sSub:='Lowercase'
      else if sSub = 'PRETTY'         then sSub:='NameCase'
      else if sSub = 'INT'            then sSub:='IntToStr'
      { change name }
      else if sSub = 'TRIM'         then sSub:='Trim'
      else if sSub = 'SUM'          then sSub:='Sum'
      else if sSub = 'MIN'          then sSub:='Min'
      else if sSub = 'MAX'          then sSub:='Max'
      else if sSub = 'DATE'         then sSub:='Date'
      else if sSub = 'TIME'         then sSub:='Time'
      else if sSub = 'COPY'         then sSub:='Copy'
      else if sSub = 'FRAC'         then sSub:='Frac'
      else if sSub = 'SQRT'         then sSub:='Sqrt' ;

      if (sSub='Page#') or (sSub='TotalPages#') or (sSub='Date') then
         result := sExpr + 'VarToStr(<' + sSub + '>)'  + sOper
      else
         result := sExpr + sSub  + sOper;

    { Field found (if not num then it will probabely a field with or without DS) }
    end
    else if (sSub<>'') and (not IsNum(sSub)) and (not bQS) then
    begin
      if sDS = '' then sDS := AReport.DataSetName;
      Result := sExpr + Format('<%s."%s">', [sDS, sSub]) + sOper ;
      sDs := '';

    { Get subString}
    end
    else
    begin
      Result := sExpr + sSub + sOper;
    end;
  end;
  //--------------------------------------------------

begin
  { init }
  sSub := '';
  bQS := False;

  { trim control chars}
  s := TrimControl(s);

  {empty expression }
  if s = '' then
  begin
    { if group band(condition), then FR needs an condition
    in GroupHeader using main dataset + '' (ex: Order."")}
    if IsCondition then
    begin
      Result := AReport.DataSetName+'.""';
    end
    else Result := '';
    exit;
  end;

  {check string}
  for i := 1 to length(s) do
  begin
    {check for operator chars}
    if MatchStr(s[i],cExprOper) then
    begin
      { Quoted string found}
      if (s[i] = '''') then
      begin
        if bQS then
        begin
          bQS := False;
          sExpr := sExpr + sSub + s[i];
        end
        else
        begin
          bQS := True;
          sExpr := sExpr + s[i];
        end;

      { DataSet found }
      end
      else if (s[i] = '.') and (not IsNum(sSub)) then
      begin
        sDS := sSub;

      { get substring }
      end
      else sExpr := GetSub(s[i]);

      sSub := '';

    { if Quoted string or no space char then add to subString}
    end
    else if bQS or (s[i]<>' ') then
    begin
      sSub := sSub + s[i];
    end;

    {add last subString if exist}
    if  (i = length(s)) and (sSub<>'') then
       sExpr := GetSub('');

  end;

  { set expression in brackets if not a condition or filter }
   if not (IsCondition or IsFilter) then
      sExpr := '[' + sExpr + ']';

  {result}
  Result:=sExpr;
end;

//----------------------------------------------------------------------------

function ReplaceMemo(BandName, ItemName, s: string): string;
var iSPos, iEPos:integer;
    sSub, sFR:string;
begin
  { get first expression}
  iSPos := Pos('%', s)+2;
  iEPos := PosEx('%' , s, iSPos);
  while (iSPos > 0) and (iEPos > iSPos) do
  begin
    { get expression}
    sSub := Copy(s, iSPos, iEPos - iSPos);

    { replace expression }
    sFR:= ReplaceExpr(BandName, ItemName, sSub,False,False);

    { insert expression }
    s:= Copy(s,1,iSPos-3) + sFR + Copy(s,iEPos+2, Length(s) - iSPos);

    { get next expression }
    iSPos := Pos('%', s)+2;
    iEPos := PosEx('%' , s, iSPos);

  end;
  Result := s;
end;

procedure AssignBandData;
 var
  B: TfrxDataBand;
 begin
   B := LastObj as TfrxDataBand;
   if B = nil then exit;
   B.DataSetName := DSName;
 end;

procedure AssignMemo();
 var
   Memo: TfrxMemoView;
   MF     : string;
 const  cMaskDate: array[1..24] of string = ( 'c' , 'd' , 'dd' , 'ddd' ,
  'dddd','ddddd' , 'dddddd' , 'm' , 'mmm' , 'mmm' , 'mmmm' ,'y', 'yyy' ,
  'h' ,'hh' , 'n', 'nn' , 's' , 'ss' , 't', 'tt' , 'am/pm' , 'a/p' , 'ampm' );

  function CntCh(InputStr: string; InputSubStr: char): integer;
  var
    i: integer;
  begin
    result := 0;
    for i := 1 to length(InputStr) do
      if InputStr[i] = InputSubStr then inc(result);
  end;
  function GetFormatKind(const S: string): TfrxFormatKind;
  begin
    if MatchStr(s,cMaskDate) or (CntCh(s,'/')=2) or (CntCh(s,'-')=2)
    or (CntCh(s,':')=1) then result:=fkDateTime
    else result:=fkNumeric;
  end;

 begin
    Memo := LastObj as TfrxMemoView;
    Memo.Name := ObjectName;

    if PropName = 'Height' then
      Memo.Height := Val
    else if PropName = 'Width' then
      Memo.Width := Val + 5
    else if PropName = 'Left' then
      Memo.Left := Val
    else if PropName = 'Top' then
      Memo.Top := Val

    else if PropName = 'Frame.Color' then
      Memo.Frame.Color :=  StringToColor(Val)

    else if PropName = 'Frame.DrawTop' then
      if GetBoolValue(Val) then
        Memo.Frame.Typ := Memo.Frame.Typ +[ftTop]
      else
        Memo.Frame.Typ := Memo.Frame.Typ -[ftTop]

    else if PropName = 'Frame.DrawBottom' then
      if GetBoolValue(Val) then
        Memo.Frame.Typ := Memo.Frame.Typ +[ftBottom]
      else
        Memo.Frame.Typ := Memo.Frame.Typ -[ftBottom]

    else if PropName = 'Frame.DrawLeft' then
      if GetBoolValue(Val) then
        Memo.Frame.Typ := Memo.Frame.Typ +[ftLeft]
      else
        Memo.Frame.Typ := Memo.Frame.Typ -[ftLeft]

    else if PropName = 'Frame.DrawRight' then
      if GetBoolValue(Val) then
        Memo.Frame.Typ := Memo.Frame.Typ +[ftRight]
      else
        Memo.Frame.Typ := Memo.Frame.Typ -[ftRight]

    else if PropName = 'Alignment' then
          begin
            if Val = 'taLeftJustify' then
              Memo.HAlign := haLeft
            else if Val = 'taRightJustify' then
              Memo.HAlign := haRight
            else if Val = 'taCenter' then
              Memo.HAlign := haCenter;
          end

    else if (PropName = 'AutoSize') then
        Memo.AutoWidth := Val
    else if PropName= 'Color' then
        Memo.Color := StringToColor(Val)

    else if (PropName = 'DataSet') then
        Memo.DataSetName := Val
    else if (PropName = 'DataField') and (Memo.Text = '') then
        Memo.DataField := Val

    else if (PropName = 'Caption') and (Memo.Text = '') then
        Memo.Text := ReplaceMemo(Parent.Name,Memo.Name,Val)

    else if (ClassName = 'TQRDBText') or (ClassName = 'TQRPDBText') then
    begin
       Memo.Text := Format('[%s."%s"]', [Memo.DataSetName, Memo.DataField]);
       if (PropName = 'Mask') then
       begin
          MF := Val;
          if MF<>'' then begin
            Memo.DisplayFormat.FormatStr:= MF;
            Memo.DisplayFormat.Kind:=GetFormatKind(MF);
          end;
       end;
    end

    else if ((ClassName = 'TQRMemo') or (ClassName = 'TQRPMemo'))
          and (PropName = 'Lines.Strings') then
        Memo.Text := Memo.Text + ReplaceMemo(Parent.Name,Memo.Name,Val)

    else if ((ClassName = 'TQRExpr') or (ClassName = 'TQRDBCalc')
            or (ClassName = 'TQRPExpr'))
          and (PropName = 'Expression') then
    begin
       Memo.Text := ReplaceExpr(Parent.Name,Memo.Name,Val,False,False);
       if (PropName = 'Mask') then
       begin
          MF := Val;
          if MF<>'' then begin
            Memo.DisplayFormat.FormatStr:= MF;
            Memo.DisplayFormat.Kind:=GetFormatKind(MF);
          end;
       end;

    end


    else if Pos('Font', PropName) = 1 then
        AssignFont

    else if PropName = 'BlankIfZero' then
        Memo.HideZeros := Val

    else if PropName = 'WordWrap' then
        Memo.WordWrap := Val

    else if (ClassName = 'TQRSysData') and (PropName = 'Data') then
         begin
                 if Val = 'qrsTime'        then   Memo.Text := '[Time]'
            else if Val = 'qrsDate'        then   Memo.Text := '[Date]'
            else if Val = 'qrsDateTime'    then   Memo.Text := '[Now]'
            else if Val = 'qrsPageNumber'  then   Memo.Text := '[Page#]'
            else if Val = 'qrsDetailNo'    then   Memo.Text := '[Line#]'
            else if Val = 'qrsDetailCount' then   Memo.Text := '[Count()]'
            else Memo.Text := 'Unknown Variable';
         end
    else if (ClassName = 'TQRHTMLLabel') then Memo.AllowHTMLTags := true;
 end;


 procedure AssignShape();
 var
   Shape: TfrxShapeView;
 begin
    Shape := LastObj as TfrxShapeView;
    Shape.Name := ObjectName;

    if PropName = 'Color' then
      Shape.Color :=  StringToColor(Val)

    else if PropName = 'Pen.Color' then
      Shape.Frame.Color :=  StringToColor(Val)

    else if PropName = 'Shape' then
         begin
                 if Val = 'qrsRectangle' then   Shape.Shape := skRectangle
            else if Val = 'qrsCircle'    then   Shape.Shape := skEllipse
            else if Val = 'qrsRoundRect' then   Shape.Shape := skRoundRectangle
         end

    else if PropName = 'Pen.Width' then
      Shape.Frame.Width := Val

    else if PropName = 'Pen.Style' then
      Shape.Frame.Style := GetFrameStyle(Val)

    else if PropName = 'Brush.Style' then
      Shape.BrushStyle  := TBrushStyle(GetEnumValue(TypeInfo(TBrushStyle), Val))

    else if PropName = 'RoundFactor' then
      Shape.Curve  := Round(Val)

 end;


 procedure AssignRich();
 var
   Rich: TfrxRichView;
 begin
    Rich := LastObj as TfrxRichView;
    Rich.Name := ObjectName;

    if Pos('Font', PropName) = 1 then
      AssignFont

    else if PropName = 'AutoStretch' then
      Rich.StretchMode := GetStretch(Val)

    else if PropName = 'Alignment' then
          begin
            if Val = 'taLeftJustify' then
              Rich.Align := baLeft
            else if Val = 'taRightJustify' then
              Rich.Align := baRight
            else if Val = 'taCenter' then
              Rich.Align := baCenter;
          end

    else if PropName = 'Color' then
        Rich.Color :=  StringToColor(Val)

    else if (PropName = 'DataSet') then
        Rich.DataSetName := Val
    else if (PropName = 'DataField') then
        Rich.DataField := Val

    else if (PropName = 'Lines.Strings') then
        Rich.RichEdit.Lines.Text := Rich.RichEdit.Lines.Text
                                + ReplaceMemo(Parent.Name,Rich.Name,Val)

    else if ClassName = 'TQRDBRichText' then
        Rich.RichEdit.Text := Format('[%s."%s"]', [Rich.DataSetName, Rich.DataField])
 end;

 procedure AssignBarcodeView();
 var
   BarCode: TfrxBarcode2DView;
 begin
    BarCode := LastObj as TfrxBarcode2DView;
    BarCode.Name := ObjectName;

    if (ClassName = 'TQRQRBarcode') or (ClassName = 'TQRQRDBBarcode') then
      BarCode.BarType := bcCodeQR
    else if (ClassName = 'TQRDMBarcode') or (ClassName = 'TQRDbDMBarcode') then
      BarCode.BarType := bcCodeDataMatrix;

    if (PropName = 'BarcodeText') or (PropName = 'Text') then
    begin
      if Val ='' then BarCode.Text :=' '
      else BarCode.Text := Val
    end
    else if (PropName = 'DataSet') then
        BarCode.DataSetName := Val
    else if (PropName = 'DataField') then
        BarCode.DataField := Val

 end;


 procedure ObjectCreator(Name:String);
 begin
    if (Name = 'TDesignQuickReport') or  (Name = 'TQuickRep')
        or  (Name = 'TQRPQuickrep') then
    begin
        LastObj := TfrxReportPage.Create(AReport);
        Parent := LastObj;
        TfrxReportPage(LastObj).CreateUniqueName;
        TfrxReportPage(LastObj).SetDefaults;
    end;
    if   (Name = 'TQRLabel')
      or (Name = 'TQRSysData')
      or (Name = 'TQRDesignDBText')
      or (Name = 'TQRExpr')
      or (Name = 'TQRMemo')
      or (Name = 'TQRDBText')
      or (Name = 'TQRExprMemo')
      or (Name = 'TQRDBCalc')
      or (Name = 'TQRHTMLLabel')

      or (Name = 'TQRPLabel')
      or (Name = 'TQRPDBText')
      or (Name = 'TQRPExpr')
      or (Name = 'TQRPMemo')
      then
    begin
      LastObj := TfrxMemoView.Create(Parent);
      LastObj.CreateUniqueName;
    end

  else if (Name = 'TQRImage')
       or (Name = 'TQRDBImage')
       or (Name = 'TQRGraphicCanvas')
       or (Name = 'TQRGrImage')
       or (Name = 'TQRGrDBImage')

       or (Name = 'TQRDBJPGlmage')
       or (Name = 'TQRPDBlmage')
       then
    begin
      LastObj := TfrxPictureView.Create(Parent);
      LastObj.CreateUniqueName;
    end

  else if (Name = 'TQRRichText') or (Name = 'TQRDBRichText')
       or (Name = 'TQRPRichtext')
      then
    begin
      LastObj := TfrxRichView.Create(Parent);
      LastObj.CreateUniqueName;
    end
  else if (Name = 'TQRQRBarcode') or (Name = 'TQRQRDBBarcode')
        or (Name = 'TQRDMBarcode') or (Name = 'TQRDbDMBarcode') then
    begin
      LastObj := TfrxBarcode2DView.Create(Parent);
      LastObj.CreateUniqueName;
    end
  else if (Name = 'TQRFrameline') then
   begin
     LastObj := TfrxLineView.Create(Parent);
     LastObj.CreateUniqueName;
   end

  else if (Name = 'TQRLineGraph') then
   begin
     LastObj := TfrxChartView.Create(Parent);
     LastObj.CreateUniqueName;
   end

 end;

 procedure BandCreator(Name:String);
 begin
    if  (Name = 'rbPageHeader') then
    begin
      LastObj := TfrxHeader.Create(Parent);
      LastObj.CreateUniqueName;
    end
    else if (Name = 'rbPageFooter') then
    begin
      LastObj := TfrxFooter.Create(Parent);
      LastObj.CreateUniqueName;
    end
    else if (Name = 'rbTitle')then
    begin
      LastObj := TfrxReportTitle.Create(Parent);
      LastObj.CreateUniqueName;
    end
    else if (Name = 'rbColumnHeader') then
    begin
      LastObj := TfrxColumnHeader.Create(Parent);
      LastObj.CreateUniqueName;
    end

    else if (Name = 'rbGroupHeader') then
    begin
      LastObj := TfrxGroupHeader.Create(Parent);
      LastObj.CreateUniqueName;
    end

    else if (Name = 'rbGroupFooter') then
    begin
      LastObj := TfrxGroupFooter.Create(Parent);
      LastObj.CreateUniqueName;
    end
    else if (Name = 'rbChild') then
    begin
      LastObj := TfrxChild.Create(Parent);
      LastObj.CreateUniqueName;
    end
     else if (Name = 'rbDetail') then
    begin
      LastObj := TfrxMasterData.Create(Parent);
      LastObj.CreateUniqueName;
    end
    else if (Name = 'rbSummary') then
    begin
      LastObj := TfrxReportSummary.Create(Parent);
      LastObj.CreateUniqueName;
    end
    else if (Name = 'rbOverlay') then
    begin
      LastObj := TfrxOverlay.Create(Parent);
      LastObj.CreateUniqueName;
    end

 end;

  procedure ShapeCreator(Name:String);
  begin
    if (Name = 'qrsVertLine')  or  (Name = 'qrpsVertLine')
      or (Name = 'qrsHorLine') or  (Name = 'qrpsHorLine')
      or (Name = 'qrsLeftDiagonal') or  (Name = 'qrpsLeftDiagonal')
      or (Name = 'qrsRightDiagonal')or  (Name = 'qrpsRightDiagonal')
      or (Name = 'qrsTopAndBottom') or  (Name = 'qrpsTopAndBottom')
      or (Name = 'qrsRightAndLeft') or  (Name = 'qrpsRightAndLeft')
    then
    begin
      LastObj := TfrxLineView.Create(Parent);
      LastObj.CreateUniqueName;
    end
    else
    if   (Name = 'qrsRectangle') or (Name = 'qrpsRectangle')
      or (Name = 'qrsCircle')    or (Name = 'qrpsCircle')
      or (Name = 'qrsRoundRect') or (Name = 'qrpsRoundRect')
      then
    begin
      LastObj := TfrxShapeView.Create(Parent);
      LastObj.CreateUniqueName;
    end;

  end;

 procedure AssignView;
 begin
     if PropName = 'Height' then
      LastObj.Height := Val
    else if PropName = 'Width' then
      LastObj.Width := Val
    else if PropName = 'Left' then
      LastObj.Left := Val
    else if PropName = 'Top' then
      LastObj.Top := Val
    else if PropName = 'Visible' then
       LastObj.Visible := Val
 end;

 procedure AssignPicture;
 var
   Stream: TMemoryStream;
   Cn: Integer;
   Image : TfrxPictureView;
 begin
    Image  := LastObj as TfrxPictureView;
    Image.Name := ObjectName;

    if PropName = 'Picture.Data' then
    begin
      Stream := TMemoryStream.Create;
      Cn := 0;
      TMemoryStream(frxInteger(Val)).Position := 0;
      TMemoryStream(frxInteger(Val)).Read(Cn, 1);
      TMemoryStream(frxInteger(Val)).Position := Cn + 1;
      Stream.SetSize(TMemoryStream(frxInteger(Val)).Size - (Cn + 1));
      Stream.CopyFrom(TMemoryStream(frxInteger(Val)), Stream.Size);
      TfrxPictureView(LastObj).LoadPictureFromStream(Stream);
      Stream.Free;
    end
    else if PropName = 'AutoSize' then
        Image.AutoSize:= Val
    else if PropName = 'Stretch' then
        Image.Stretched := Val
    else if PropName = 'Center' then
        Image.Center := Val
    else if PropName = 'Picture.Bitmap.Transparent' then
        Image.Transparent := Val
    else if PropName = 'DataField' then
        Image.DataField  := Val
    else if PropName = 'DataField' then
        Image.DataSetName:= Val

    else if (ClassName = 'TQRGrImage') or (ClassName = 'TQRGrDBImage') then
        Image.KeepAspectRatio:= true;
 end;

 procedure AssignProp;
 var FindBand : TfrxComponent;
 begin
   if Pos('DB', ClassName) = 4 then
    AssignDBProp;
   if (PropName = 'UserName') and not (LastObj is TfrxPage) then
    LastObj.Name := Val
   else if (ClassName = 'TQuickRep') or (ClassName = 'TDesignQuickReport')
        or  (ClassName = 'TQRPQuickrep') then
     AssignReport

   else if (ClassName = 'TQRDesignBand')
        or (ClassName = 'TQRBand')
        or (ClassName = 'TQRPBand')
        or (ClassName = 'TQRGroup')
        or (ClassName = 'TQRSubDetail')
        or (ClassName = 'TQRChildBand')
        or (ClassName = 'TQRPChildBand')
        or (ClassName = 'TQRLoopBand') then
         begin
           if PropName = 'Height' then
             begin
               TfrxBand(LastObj).Height := Val ;
             end
           else if (Val = 'rbGroupHeader') then
             begin
                if DataBand <> nil then
                begin
                  DataBand.FGroup := TfrxGroupHeader(LastObj);
                  LastObj.Top := DataBand.Top ;
                end
             end
           else if (Val = 'rbGroupFooter') then
             begin
                if DataBand <> nil then
                begin
                  LastObj.Top := DataBand.Top + DataBand.Height;
                end
             end

           else if PropName = 'Top' then
              begin
                LastObj.Top := Val
              end

           else if PropName = 'ForceNewPage' then
               begin
                  TfrxBand(LastObj).StartNewPage:= Val;
               end

           else if (PropName = 'ParentBand') and ((ClassName = 'TQRChildBand')
                or (ClassName = 'TQRPChildBand'))
              then
               begin
                  FindBand := AReport.FindObject(Val);
                  TfrxBand(FindBand).Child := TfrxChild(LastObj);
               end
           else if (PropName = 'PrintCount') and (ClassName = 'TQRLoopBand')
              then
               begin
                  TfrxMasterData(LastObj).RowCount := Val;
               end
           else if (PropName = 'Expression') and (ClassName = 'TQRPBand')
                and (LastObj is TfrxDataBand)
              then
               begin
                  if (Val = '') then TfrxDataBand(LastObj).Filter :=''
                  else
                  begin
                  TfrxDataBand(LastObj).Filter := ReplaceExpr(Parent.Name,
                                                 LastObj.Name,Val,False,False);
                  TfrxDataBand(LastObj).Filter :=
                        TfrxDataBand(LastObj).Filter.Substring(1,
                        TfrxDataBand(LastObj).Filter.Length-2)
                  end;
               end


         end

   else if (ClassName = 'TQRLabel')
        or (ClassName = 'TQRDBText')
        or (ClassName = 'TQRGroup')
        or (ClassName = 'TQRMemo')
        or (ClassName = 'TQRExpr')
        or (ClassName = 'TQRSysData')
        or (ClassName = 'TQRDBCalc')
        or (ClassName = 'TQRDesignDBText')
        or (ClassName = 'TQRHTMLLabel')

        or (ClassName = 'TQRPLabel')
        or (ClassName = 'TQRPDBText')
        or (ClassName = 'TQRPExpr')
        or (ClassName = 'TQRPMemo')
        then
        begin
          if(LastObj is  TfrxMemoView) then
          AssignMemo;
        end
   else if ((ClassName = 'TQRShape') or (ClassName = 'TQRPShape') )
        and (LastObj is TfrxShapeView) then
   begin
      AssignView;
      AssignShape;
   end
   else if (ClassName = 'TQRImage')
        or (ClassName = 'TQRDBImage')
        or (ClassName = 'TQRGraphicCanvas')
        or (ClassName = 'TQRGrImage')
        or (ClassName = 'TQRGrDBImage')

        or (ClassName = 'TQRDBJPGlmage')
        or (ClassName = 'TQRPDBlmage')
        then
   begin
     AssignView;
     AssignPicture;
   end
   else if (ClassName = 'TQRRichText') or (ClassName = 'TQRDBRichText')
        or (ClassName = 'TQRPRichtext') then
   begin
     AssignView;
     AssignRich;
   end
   else if (ClassName = 'TQRQRBarcode') or (ClassName = 'TQRQRDBBarcode')
          or (ClassName = 'TQRDMBarcode') or (ClassName = 'TQRDbDMBarcode')then
   begin
     AssignView;
     AssignBarcodeView;
   end
   else if (ClassName = 'TQRFrameline') then
   begin
     AssignView;
     LastObj.Anchors := [fraLeft,fraTop,fraBottom];
     LastObj.Top := 0;
     LastObj.Height := Parent.Height;
   end
   else if (ClassName = 'TQRLineGraph') then
   begin
     AssignView;
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
    Band : TfrxBand;
    Shape : TfrxShapeView;
  begin
    Reader.ReadPrefix(Flags, Position);
    if (ffInherited in Flags) or(ffInline in Flags)  then exit;
    ClassName := Reader.ReadStr;
    ObjectName := Reader.ReadStr;

    ObjectCreator(ClassName);

      if (ClassName = 'TQRDesignBand') or  (ClassName = 'TQRBand')
          or (ClassName = 'TQRPBand') then
       begin
            Band := TfrxBand.Create(Parent);
            LastObj := Band;

            while not Reader.EndOfList do
            begin
              ReadProperty;
              if PropName = 'BandType' then
              begin
                  BandCreator(Val);
                  LastObj.AssignAll(Band);
                  LastObj.Name := ObjectName;
                  FreeAndNil(Band);
              end;

              if isBin then
              begin
                TMemoryStream(frxInteger(Val)).Free;
                isBin := False;
              end;
            end;
       end;

        if (ClassName = 'TQRDesignGroup') or  (ClassName = 'TQRGroup') then
       begin
            LastObj := TfrxGroupHeader.Create(Parent);

            while not Reader.EndOfList do
            begin
              ReadProperty;
              if PropName = 'Expression' then
              begin
               TfrxGroupHeader(LastObj).Condition:=ReplaceExpr(ObjectName,
                                                  'Condition',Val,True,False);
               LastObj.Name := ObjectName;
              end;

              if isBin then
              begin
                TMemoryStream(frxInteger(Val)).Free;
                isBin := False;
              end;
            end;
         end;

       if (ClassName = 'TQRSubDetail') or (ClassName = 'TQRChildBand')
        or (ClassName = 'TQRPChildBand') or (ClassName = 'TQRLoopBand') then
       begin
            if (ClassName = 'TQRSubDetail') then
              LastObj := TfrxSubdetailData.Create(Parent)
            else if (ClassName = 'TQRChildBand')
                  or (ClassName = 'TQRPChildBand') then
              LastObj := TfrxChild.Create(Parent)
            else if (ClassName = 'TQRLoopBand') then
              LastObj := TfrxMasterData.Create(Parent);



            while not Reader.EndOfList do
            begin
              ReadProperty;
              LastObj.Name := ObjectName;

              if isBin then
              begin
                TMemoryStream(frxInteger(Val)).Free;
                isBin := False;
              end;
            end;
       end;

       if (ClassName = 'TQRDesignShape') or  (ClassName = 'TQRShape')
            or (ClassName = 'TQRPShape') then
       begin

            Shape  := TfrxShapeView.Create(nil);
            Shape.Name := ObjectName;
            LastObj := Shape;


            while not Reader.EndOfList do
            begin
              ReadProperty;

              if (PropName = 'Shape') then
              begin
                  ShapeCreator(Val);
                  LastObj.AssignAll(Shape);

                  if  (Val = 'qrsTopAndBottom') or (Val = 'qrpsTopAndBottom')
                  then
                    begin
                       LastObj.Height := 0;
                       LastObj := TfrxLineView.Create(Parent);
                       LastObj.CreateUniqueName;
                       LastObj.AssignAll(Shape);
                       LastObj.Top := LastObj.Top + LastObj.Height;
                       LastObj.Height := 0;
                    end;
                  if  (Val = 'qrsRightAndLeft') or (Val = 'qrpsRightAndLeft')
                   then
                    begin
                       LastObj.Width:=0;
                       LastObj := TfrxLineView.Create(Parent);
                       LastObj.CreateUniqueName;
                       LastObj.AssignAll(Shape);
                       LastObj.Left:= LastObj.Left + LastObj.Width;
                       LastObj.Width:=0;
                       TfrxLineView(LastObj).Diagonal := true
                    end;
                  if  (Val = 'qrsLeftDiagonal') or (Val = 'qrsRightDiagonal')
                    or (Val = 'qrpsLeftDiagonal') or (Val = 'qrpsRightDiagonal')
                  then
                    begin
                       TfrxLineView(LastObj).Diagonal := true;
                    end;

                 FreeAndNil(Shape);

              end;

              LastObj.Name := ObjectName;

              if isBin then
              begin
                TMemoryStream(frxInteger(Val)).Free;
                isBin := False;
              end;
            end;
       end;
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
    if (LastObj <> nil) and (LastObj.Parent <> nil) and not (LastObj.Parent is TfrxReport)  then
      LastObj := LastObj.Parent;
    Reader.ReadListEnd;
    while not Reader.EndOfList do
    begin
      Parent := LastParent;
      ReadObject;
    end;

    Reader.ReadListEnd;
  end;


/////////////////////////////////////////////////////

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
    LastObj := nil;
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


function TConverterQr2FrNew.DoLoad(Sender: TfrxReport; Stream: TStream): Boolean;
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
      Result := LoadFromQR(Sender, TmpStream);
    finally
      TmpStream.Free;
    end;
  end
else
  Result := LoadFromQR(Sender, Stream);
end;


initialization

  frxFR2EventsNew := TConverterQr2FrNew.Create;
  frxFR2Events.OnLoad := frxFR2EventsNew.DoLoad;
  //frxFR2Events.Filter := '*.qr2';

finalization
  frxFR2EventsNew.Free;


end.
