{******************************************}
{                                          }
{             FastReport 5                 }
{         Converter from DMP to GDI        }
{                                          }
{           Copyright (c) 2015             }
{             by Paul Gursky               }
{            Fast Reports Inc.             }
{                                          }
{                                          }
{******************************************}

//
// Using:
//   conv := TConverterDMP2GDI.Create;
//   conv.Source := frxReport1;
//   conv.Target := frxReport2;
//   conv.Convert;
//   frxReport2.SaveToFile('converted_fromDMP.fr3');
//


unit ConverterDMP2GDI;

interface

{$I frx.inc}

uses
  frxClass, frxDMPClass;

type
  TConverterDMP2GDI = class
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
     frxCross, frxRich;

procedure TConverterDMP2GDI.Convert;
begin
  if not Assigned(Source) then
    raise Exception.Create('Source not assigned');
  if not Assigned(Target) then
    raise Exception.Create('Target not assigned');

  Target.Clear;
  DoConvert;
end;

procedure TConverterDMP2GDI.DoConvert;
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
var Memo: TfrxMemoView;
    MemoS: TfrxDMPMemoView;
begin
  Memo:=TfrxMemoView.Create(Parent);
  MemoS:=TfrxDMPMemoView(Source);
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
  Memo.Font.Style:=[];
  if fsxBold in MemoS.FontStyle then
    Memo.Font.Style:=Memo.Font.Style+[fsBold];
  if fsxItalic in MemoS.FontStyle then
    Memo.Font.Style:=Memo.Font.Style+[fsItalic];
  if fsxUnderline in MemoS.FontStyle then
    Memo.Font.Style:=Memo.Font.Style+[fsUnderline];
  {Memo.FontStyle:=[];
  if fsBold in MemoS.Font.Style then
    Memo.FontStyle:=Memo.FontStyle+[fsxBold];
  if fsItalic in MemoS.Font.Style then
    Memo.FontStyle:=Memo.FontStyle+[fsxItalic];
  if fsUnderline in MemoS.Font.Style then
    Memo.FontStyle:=Memo.FontStyle+[fsxUnderline]; }
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

procedure ConvertLineView(Parent, Source: TComponent);
var Line: TfrxLineView;
    LineS: TfrxDMPLineView;
begin
  {if not TfrxDMPLineView(c).Diagonal then
    begin}
      Line:=TfrxLineView.Create(Parent);
      LineS:=TfrxDMPLineView(Source);
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
  //  end;
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
  if (Source is TfrxDMPMemoView) {or (Source is TfrxSysMemoView)} then
    ConvertMemoView(Parent, Source)
  else
  {if Source is TfrxRichView then
    ConvertRichView(Parent, Source)
  else }
  if Source is TfrxDMPLineView then
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
     Target.DotMatrixReport:=False;
     for i:=0 to Source.Objects.Count-1 do
       begin
        c:=TComponent(Source.Objects.Items[i]);
        if c is TfrxDMPPage then
          begin
            DMPPage:=TfrxDMPPage(c);
            Target.FindObject(DMPPage.Name).Free;
            ReportPage:=TfrxReportPage.Create(Target);
            ReportPage.SetDefaults;
            ReportPage.BottomMargin:=DMPPage.BottomMargin;
            ReportPage.Columns:=DMPPage.Columns;
            ReportPage.ColumnPositions:=DMPPage.ColumnPositions;
            ReportPage.ColumnWidth:=DMPPage.ColumnWidth;
            ReportPage.DataSet:=DMPPage.DataSet;
            ReportPage.Duplex:=DMPPage.Duplex;
            ReportPage.EndlessHeight:=DMPPage.EndlessHeight;
            ReportPage.EndlessWidth:=DMPPage.EndlessWidth;
            ReportPage.LargeDesignHeight:=DMPPage.LargeDesignHeight;
            ReportPage.LeftMargin:=DMPPage.LeftMargin;
            ReportPage.MirrorMargins:=DMPPage.MirrorMargins;
            ReportPage.Name:=DMPPage.Name;
            ReportPage.Orientation:=DMPPage.Orientation;
            ReportPage.OutlineText:=DMPPage.OutlineText;
            ReportPage.PageCount:=DMPPage.PageCount;
            if DMPPage.PaperSize=256 then
              begin
                ReportPage.PaperWidth:=Round(DMPPage.PaperWidth/fr1CharX)*fr1CharX;
                ReportPage.PaperHeight:=Round(DMPPage.PaperHeight/fr1CharY)*fr1CharY;
              end
            else
              ReportPage.PaperSize:=DMPPage.PaperSize;
            ReportPage.PrintIfEmpty:=DMPPage.PrintIfEmpty;
            ReportPage.PrintOnPreviousPage:=DMPPage.PrintOnPreviousPage;
            ReportPage.ResetPageNumbers:=DMPPage.ResetPageNumbers;
            ReportPage.RightMargin:=DMPPage.RightMargin;
            ReportPage.Tag:=DMPPage.Tag;
            ReportPage.TitleBeforeHeader:=DMPPage.TitleBeforeHeader;
            ReportPage.TopMargin:=DMPPage.TopMargin;
            ReportPage.Visible:=DMPPage.Visible;
            ReportPage.OnAfterPrint:=DMPPage.OnAfterPrint;
            ReportPage.OnBeforePrint:=DMPPage.OnBeforePrint;
            ReportPage.OnManualBuild:=DMPPage.OnManualBuild;
            Target.Objects.Exchange(i, Target.Objects.Count-1);
            for j:=0 to DMPPage.Objects.Count-1 do
              begin
                c:=TComponent(DMPPage.Objects.Items[j]);
                if c is TfrxBand then
                  begin
                    BandS:=TfrxBand(c);
                    Band:=TfrxBand(TfrxBandClass(c.ClassType).NewInstance);
                    Band.Create(ReportPage);
                    Band.Name:=TfrxBand(c).Name;
                    EqualClassProperties(Band, c);
                    ConvertBand(Band, BandS);
                  end
                else
                  ConvertComponent(ReportPage, c);
              end;
          end;
       end;
     for i:=0 to Source.AllObjects.Count-1 do
       begin
        c:=TComponent(Source.AllObjects.Items[i]);
        if c is TfrxSubReport then
            TfrxSubReport(Target.FindObject(TfrxSubReport(c).Name)).Page:=TfrxReportPage(Target.FindObject(TfrxSubReport(c).Page.Name));
        if c is TfrxDMPMemoView then
          if TfrxDMPMemoView(c).FlowTo<> nil then
            TfrxMemoView(Target.FindObject(TfrxDMPMemoView(c).Name)).FlowTo:=TfrxMemoView(Target.FindObject(TfrxDMPMemoView(c).FlowTo.Name));
                if c is TfrxBand then
       if TfrxBand(c).Child <> nil then
            TfrxBand(Target.FindObject(TfrxBand(c).Name)).Child:=TfrxChild(Target.FindObject(TfrxBand(c).Child.Name));
       {if c is TfrxRichView then
          if TfrxRichView(c).FlowTo<> nil then
            TfrxDMPMemoView(Target.FindObject(TfrxRichView(c).Name)).FlowTo:=TfrxDMPMemoView(Target.FindObject(TfrxRichView(c).FlowTo.Name));}
       end;
end;

end.
