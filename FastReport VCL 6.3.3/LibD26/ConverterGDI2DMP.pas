{******************************************}
{                                          }
{             FastReport 5                 }
{         Converter from GDI to DMP        }
{                                          }
{           Copyright (c) 2015             }
{             by Paul Gursky               }
{            Fast Reports Inc.             }
{                                          }
{                                          }
{******************************************}

//
// Using:
//   conv := TConverterGDI2DMP.Create;
//   conv.Source := frxReport1;
//   conv.Target := frxReport2;
//   conv.Convert;
//   frxReport2.SaveToFile('converted_fromGDI.fr3');
//


unit ConverterGDI2DMP;

interface

{$I frx.inc}

uses
  frxClass, frxDMPClass, Variants;

type
  TConverterGDI2DMP = class
  private
    FTarget: TfrxReport;
    FSource: TfrxReport;
  protected
    procedure DoConvert;
  public
    property Source: TfrxReport read FSource write FSource;
    property Target: TfrxReport read FTarget write FTarget;

    procedure Convert;
  end;

implementation

uses SysUtils, Controls, Classes, Graphics, frxDCtrl, frxDBSet, TypInfo,
     frxCross, frxRich, frxUnicodeUtils, frxADOComponents;

procedure TConverterGDI2DMP.Convert;
begin
  if not Assigned(Source) then
    raise Exception.Create('Source not assigned');
  if not Assigned(Target) then
    raise Exception.Create('Target not assigned');

  Target.Clear;
  DoConvert;
end;

procedure TConverterGDI2DMP.DoConvert;
Var i, j: integer;
    c: TComponent;
    ReportPage: TfrxReportPage;
    DMPPage: TfrxDMPPage;
    Band, BandS: TfrxBand;
    Stream: TMemoryStream;

procedure EqualClassProperties(AClass1, AClass2: TObject);
var
  PropList: PPropList;
  ClassTypeInfo: PTypeInfo;
  ClassTypeData: PTypeData;
  PropClassTypeData: PTypeData;
  i, j: integer;
  APersistent: TPersistent;
begin
  if AClass1.ClassInfo <> AClass2.ClassInfo then
    exit;
  ClassTypeInfo := AClass1.ClassInfo;
  ClassTypeData := GetTypeData(ClassTypeInfo);
  if ClassTypeData.PropCount <> 0 then
  begin
    GetMem(PropList, SizeOf(PPropInfo) * ClassTypeData.PropCount);
    try
      GetPropInfos(AClass1.ClassInfo, PropList);
      for i := 0 to ClassTypeData.PropCount - 1 do
        if not (PropList[i]^.PropType^.Kind = tkMethod) then
          if PropList[i]^.Name <> 'Name' then
            if (PropList[i]^.PropType^.Kind = tkClass) then
              begin
                APersistent := TPersistent(GetObjectProp(AClass1, PropList[i]^.Name, TPersistent));
                if PropList[i]^.Name <> 'FillGap' then
                  if (APersistent <> nil) then
                    APersistent.Assign(TPersistent(GetObjectProp(AClass2, PropList[i]^.Name, TPersistent)));
              end
            else
            if (PropList[i]^.PropType^.Kind = tkEnumeration) then
              begin
                PropClassTypeData := GetTypeData(PropList[i]^.PropType^);
                j := GetEnumValue(PropClassTypeData^.BaseType^, GetPropValue(AClass2, PropList[i]^.Name));
                SetOrdProp(AClass1, PropList[i]^.Name, j);
              end
            else
              begin
                SetPropValue(AClass1, PropList[i]^.Name, GetPropValue(AClass2,
                  PropList[i]^.Name));
              end;
    finally
      FreeMem(PropList, SizeOf(PPropInfo) * ClassTypeData.PropCount);
    end;
  end;
end;

procedure ConvertMemoView(Parent, Source: TComponent);
var Memo: TfrxDMPMemoView;
    MemoS: TfrxCustomMemoView;
begin
  Memo:=TfrxDMPMemoView.Create(Parent);
  MemoS:=TfrxCustomMemoView(Source);
  Memo.Name:=MemoS.Name;
  Memo.SetBounds(MemoS.Left, MemoS.Top, MemoS.Width, MemoS.Height);
  Memo.Align:=MemoS.Align;
  Memo.AllowExpressions:=MemoS.AllowExpressions;
  Memo.AutoWidth:=MemoS.AutoWidth;
  Memo.Cursor:=MemoS.Cursor;
  Memo.DataField:=MemoS.DataField;
  Memo.DataSet:=MemoS.DataSet;
  Memo.Description:=MemoS.Description;
  Memo.DisplayFormat:=MemoS.DisplayFormat;
  Memo.ExpressionDelimiters:=MemoS.ExpressionDelimiters;
  Memo.FontStyle:=[];
  if fsBold in MemoS.Font.Style then
    Memo.FontStyle:=Memo.FontStyle+[fsxBold];
  if fsItalic in MemoS.Font.Style then
    Memo.FontStyle:=Memo.FontStyle+[fsxItalic];
  if fsUnderline in MemoS.Font.Style then
    Memo.FontStyle:=Memo.FontStyle+[fsxUnderline];
  Memo.Frame:=MemoS.Frame;
  Memo.HAlign:=MemoS.HAlign;
  Memo.HideZeros:=MemoS.HideZeros;
  Memo.Hint:=MemoS.Hint;
  Memo.Memo:=MemoS.Memo;
  Memo.ParentFont:=MemoS.ParentFont;
  Memo.Printable:=MemoS.Printable;
  Memo.Restrictions:=MemoS.Restrictions;
  Memo.RTLReading:=MemoS.RTLReading;
  Memo.ShiftMode:=MemoS.ShiftMode;
  Memo.ShowHint:=MemoS.ShowHint;
  Memo.StretchMode:=MemoS.StretchMode;
  Memo.Tag:=MemoS.Tag;
  Memo.TagStr:=MemoS.TagStr;
  Memo.URL:=MemoS.URL;
  Memo.VAlign:=MemoS.VAlign;
  Memo.Visible:=MemoS.Visible;
  Memo.WordWrap:=MemoS.WordWrap;
  Memo.OnAfterData:=MemoS.OnAfterData;
  Memo.OnAfterPrint:=MemoS.OnAfterPrint;
  Memo.OnBeforePrint:=MemoS.OnBeforePrint;
  Memo.OnPreviewClick:=MemoS.OnPreviewClick;
  Memo.OnPreviewDblClick:=MemoS.OnPreviewDblClick;
end;

procedure ConvertRichView(Parent, Source: TComponent);
var Memo: TfrxDMPMemoView;
    RichS: TfrxRichView;
begin
  Memo:=TfrxDMPMemoView.Create(Parent);
  RichS:=TfrxRichView(Source);
  Memo.Name:=RichS.Name;
  Memo.SetBounds(RichS.Left, RichS.Top, RichS.Width, RichS.Height);
  Memo.Align:=RichS.Align;
  Memo.AllowExpressions:=RichS.AllowExpressions;
  Memo.Cursor:=RichS.Cursor;
  Memo.DataField:=RichS.DataField;
  Memo.DataSet:=RichS.DataSet;
  Memo.Description:=RichS.Description;
  Memo.ExpressionDelimiters:=RichS.ExpressionDelimiters;
  Memo.FontStyle:=[];
  if fsBold in RichS.Font.Style then
    Memo.FontStyle:=Memo.FontStyle+[fsxBold];
  if fsItalic in RichS.Font.Style then
    Memo.FontStyle:=Memo.FontStyle+[fsxItalic];
  if fsUnderline in RichS.Font.Style then
    Memo.FontStyle:=Memo.FontStyle+[fsxUnderline];
  Memo.Frame:=RichS.Frame;
  Memo.Hint:=RichS.Hint;
  {$IFDEF Delphi10}
  Memo.Memo:=TfrxWideStrings(RichS.RichEdit.Lines);
  {$ELSE}
  Memo.Memo:=TWideStrings(RichS.RichEdit.Lines);
  {$ENDIF}
  Memo.ParentFont:=RichS.ParentFont;
  Memo.Printable:=RichS.Printable;
  Memo.Restrictions:=RichS.Restrictions;
  Memo.ShiftMode:=RichS.ShiftMode;
  Memo.ShowHint:=RichS.ShowHint;
  Memo.StretchMode:=RichS.StretchMode;
  Memo.Tag:=RichS.Tag;
  Memo.TagStr:=RichS.TagStr;
  Memo.URL:=RichS.URL;
  Memo.Visible:=RichS.Visible;
  Memo.OnAfterData:=RichS.OnAfterData;
  Memo.OnAfterPrint:=RichS.OnAfterPrint;
  Memo.OnBeforePrint:=RichS.OnBeforePrint;
  Memo.OnPreviewClick:=RichS.OnPreviewClick;
  Memo.OnPreviewDblClick:=RichS.OnPreviewDblClick;
end;

procedure ConvertLineView(Parent, Source: TComponent);
var Line: TfrxDMPLineView;
    LineS: TfrxLineView;
begin
  if not TfrxLineView(c).Diagonal then
    begin
      Line:=TfrxDMPLineView.Create(Parent);
      LineS:=TfrxLineView(Source);
      Line.Name:=LineS.Name;
      Line.SetBounds(Lines.Left, LineS.Top, LineS.Width, LineS.Height);
      Line.Align:=LineS.Align;
      Line.Description:=LineS.Description;
      Line.Hint:=LineS.Hint;
      Line.ParentFont:=LineS.ParentFont;
      Line.Printable:=LineS.Printable;
      Line.Restrictions:=LineS.Restrictions;
      Line.ShiftMode:=LineS.ShiftMode;
      Line.ShowHint:=LineS.ShowHint;
      Line.StretchMode:=LineS.StretchMode;
      Line.Tag:=LineS.Tag;
      Line.TagStr:=LineS.TagStr;
      Line.Visible:=LineS.Visible;
      Line.OnAfterData:=LineS.OnAfterData;
      Line.OnAfterPrint:=LineS.OnAfterPrint;
      Line.OnBeforePrint:=LineS.OnBeforePrint;
      Line.OnPreviewClick:=LineS.OnPreviewClick;
      Line.OnPreviewDblClick:=LineS.OnPreviewDblClick;
    end;
end;

procedure ConvertCrossView(Parent, Source: TComponent);
var Cross: TfrxCrossView;
begin
  Cross:=TfrxCrossView.Create(Parent);
  Cross.Name:=TfrxCrossView(Source).Name;
  EqualClassProperties(Cross, Source);
end;

procedure ConvertDBCrossView(Parent, Source: TComponent);
var DBCross: TfrxDBCrossView;
begin
  DBCross:=TfrxDBCrossView.Create(Parent);
  DBCross.Name:=TfrxDBCrossView(Source).Name;
  EqualClassProperties(DBCross, Source);
end;

procedure ConvertSubReport(Parent, Source: TComponent);
var SubReport: TfrxSubReport;
begin
  SubReport:=TfrxSubReport.Create(Parent);
  SubReport.Name:=TfrxSubReport(Source).Name;
  EqualClassProperties(SubReport, Source);
end;

procedure ConvertComponent(Parent, Source: TComponent);
begin
  if (Source is TfrxMemoView) or (Source is TfrxSysMemoView) then
    ConvertMemoView(Parent, Source)
  else
  if Source is TfrxRichView then
    ConvertRichView(Parent, Source)
  else
  if Source is TfrxLineView then
    ConvertLineView(Parent, Source)
  else
  if Source is TfrxCrossView then
    ConvertCrossView(Parent, Source)
  else
  if Source is TfrxDBCrossView then
    ConvertDBCrossView(Parent, Source)
  else
  if Source is TfrxSubReport then
    ConvertSubReport(Parent, Source);
end;

procedure ConvertBand(Destination, Source: TfrxBand);
var  i: integer;
     c: TComponent;
begin
  for i:=0 to Source.Objects.Count-1 do
    begin
      c:=TComponent(Source.Objects.Items[i]);
      ConvertComponent(Destination, c);
    end;
end;

begin
     Stream:=TMemoryStream.Create;
     Source.SaveToStream(Stream);
     Stream.Position:=0;
     Target.LoadFromStream(Stream);
     Target.DotMatrixReport:=True;
     for i:=0 to Source.Objects.Count-1 do
       begin
        c:=TComponent(Source.Objects.Items[i]);
        if c is TfrxReportPage then
          begin
            ReportPage:=TfrxReportPage(c);
            Target.FindObject(ReportPage.Name).Free;
            DMPPage:=TfrxDMPPage.Create(Target);
            DMPPage.SetDefaults;
            DMPPage.BottomMargin:=ReportPage.BottomMargin;
            DMPPage.Columns:=ReportPage.Columns;
            DMPPage.ColumnPositions:=ReportPage.ColumnPositions;
            DMPPage.ColumnWidth:=ReportPage.ColumnWidth;
            DMPPage.DataSet:=ReportPage.DataSet;
            DMPPage.Duplex:=ReportPage.Duplex;
            DMPPage.EndlessHeight:=ReportPage.EndlessHeight;
            DMPPage.EndlessWidth:=ReportPage.EndlessWidth;
            DMPPage.LargeDesignHeight:=ReportPage.LargeDesignHeight;
            DMPPage.LeftMargin:=ReportPage.LeftMargin;
            DMPPage.MirrorMargins:=ReportPage.MirrorMargins;
            DMPPage.Name:=ReportPage.Name;
            DMPPage.Orientation:=ReportPage.Orientation;
            DMPPage.OutlineText:=ReportPage.OutlineText;
            DMPPage.PageCount:=ReportPage.PageCount;
            if ReportPage.PaperSize=256 then
              begin
                DMPPage.PaperWidth:=Round(ReportPage.PaperWidth/fr1CharX)*fr1CharX;
                DMPPage.PaperHeight:=Round(ReportPage.PaperHeight/fr1CharY)*fr1CharY;
              end
            else
              DMPPage.PaperSize:=ReportPage.PaperSize;
            DMPPage.PrintIfEmpty:=ReportPage.PrintIfEmpty;
            DMPPage.PrintOnPreviousPage:=ReportPage.PrintOnPreviousPage;
            DMPPage.ResetPageNumbers:=ReportPage.ResetPageNumbers;
            DMPPage.RightMargin:=ReportPage.RightMargin;
            DMPPage.Tag:=ReportPage.Tag;
            DMPPage.TitleBeforeHeader:=ReportPage.TitleBeforeHeader;
            DMPPage.TopMargin:=ReportPage.TopMargin;
            DMPPage.Visible:=ReportPage.Visible;
            DMPPage.OnAfterPrint:=ReportPage.OnAfterPrint;
            DMPPage.OnBeforePrint:=ReportPage.OnBeforePrint;
            DMPPage.OnManualBuild:=ReportPage.OnManualBuild;
            Target.Objects.Exchange(i, Target.Objects.Count-1);
            for j:=0 to ReportPage.Objects.Count-1 do
              begin
                c:=TComponent(ReportPage.Objects.Items[j]);
                if c is TfrxBand then
                  begin
                    BandS:=TfrxBand(c);
                    Band:=TfrxBand(TfrxBandClass(c.ClassType).NewInstance);
                    Band.Create(DMPPage);
                    Band.Name:=TfrxBand(c).Name;
                    EqualClassProperties(Band, c);
                    ConvertBand(Band, BandS);
                  end
                else
                  ConvertComponent(DMPPage, c);
              end;
          end;
       end;
     for i:=0 to Source.AllObjects.Count-1 do
       begin
        c:=TComponent(Source.AllObjects.Items[i]);
        if c is TfrxSubReport then
            TfrxSubReport(Target.FindObject(TfrxSubReport(c).Name)).Page:=TfrxDMPPage(Target.FindObject(TfrxSubReport(c).Page.Name));
        if c is TfrxMemoView then
          if TfrxMemoView(c).FlowTo <> nil then
            TfrxDMPMemoView(Target.FindObject(TfrxMemoView(c).Name)).FlowTo:=TfrxDMPMemoView(Target.FindObject(TfrxMemoView(c).FlowTo.Name));
        if c is TfrxRichView then
          if TfrxRichView(c).FlowTo <> nil then
            TfrxDMPMemoView(Target.FindObject(TfrxRichView(c).Name)).FlowTo:=TfrxDMPMemoView(Target.FindObject(TfrxRichView(c).FlowTo.Name));
        if c is TfrxBand then
          if TfrxBand(c).Child <> nil then
            TfrxBand(Target.FindObject(TfrxBand(c).Name)).Child:=TfrxChild(Target.FindObject(TfrxBand(c).Child.Name));
       end;
end;

end.
