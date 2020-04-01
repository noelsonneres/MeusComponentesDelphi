{******************************************}
{                                          }
{             FastReport v6.0              }
{         frxChart Clipboard Editor        }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxChartClipboard;

interface

{$I frx.inc}
{$I tee.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  frxClass, frxChart,
{$IFDEF DELPHI16}
  VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart, VCLTee.Series, VCLTee.TeCanvas
{$ELSE}
  TeeProcs, TeEngine, Chart, Series, TeCanvas
{$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};



implementation

uses
  Math, frxRes, Types, Clipbrd, frxXML, frxXMLSerializer;

const
  ClipboardPrefix: String = '#FR6 clipboard#chart#';
  ChartName: String = 'Chart';

type
  TfrxInPlaceChartCopyPasteEditor = class(TfrxInPlaceEditor)
  public
    procedure CopyContent(CopyFrom: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType = cptDefault); override;
    procedure PasteContent(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType = cptDefault); override;
    function IsPasteAvailable(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; PasteAs: TfrxCopyPasteType = cptDefault): Boolean; override;
  end;

{ TfrxInPlaceChartCopyPasteEditor }

procedure TfrxInPlaceChartCopyPasteEditor.CopyContent(CopyFrom: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream;
  CopyAs: TfrxCopyPasteType);
var
  ss: TStringStream;
  aRoot: TfrxXMLItem;
  wr: TfrxXMLWriter;
  Writer: TfrxXMLSerializer;
  i, Index: Integer;
  aChart: TCustomChart;

  procedure WriteItem(aObject: TPersistent);
  begin
    with aRoot.Add do
    begin
      Name := aObject.ClassName;
      Text := Writer.ObjToXML(aObject);
    end;
  end;

begin
  if not(CopyFrom is TfrxChartView) or (CopyAs <> cptDefault) or
    not Assigned(EventParams.SelectionList) or
    (EventParams.SelectionList.Count < 1) then
    Exit;
  aChart := TfrxChartView(CopyFrom).Chart;
  Index := -1;
  for i := 0 to aChart.SeriesCount - 1 do
    if EventParams.SelectionList.InspSelectedObjects.IndexOf
      (aChart.Series[i]) <> -1 then
    begin
      Index := i;
      Break;
    end;

  if Index = -1 then
    Exit;

  ss := TStringStream.Create('');
  Writer := TfrxXMLSerializer.Create(nil);
  aRoot := TfrxXMLItem.Create;
  aRoot.Name := ChartName;
  ss.WriteString(ClipboardPrefix);
  wr := TfrxXMLWriter.Create(ss);
  try
    Writer.Owner := nil;
    WriteItem(aChart.Series[Index]);
    WriteItem(TfrxChartView(CopyFrom).SeriesData.Items[Index]);
    wr.WriteRootItem(aRoot);
    Clipboard.AsText := ss.DataString;
  finally
    aRoot.Free;
    wr.Free;
    ss.Free;
    Writer.Free;
  end;

end;

function TfrxInPlaceChartCopyPasteEditor.IsPasteAvailable(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams;
  PasteAs: TfrxCopyPasteType): Boolean;

  function FastCheck: Boolean;
  var
    I, MaxLen: Integer;
    sText: String;
  begin
    MaxLen := Length(ClipboardPrefix);
    sText := Clipboard.AsText;
    Result := False;
    if MaxLen > Length(sText) then
      Exit;
    Result := True;
    for i := 1 to MaxLen do
      if sText[i] <> ClipboardPrefix[i] then
      begin
        Result := False;
        break;
      end;
  end;
begin
  Result := (Clipboard.HasFormat(CF_TEXT) or Clipboard.HasFormat(CF_UNICODETEXT)) and FastCheck;
end;

procedure TfrxInPlaceChartCopyPasteEditor.PasteContent(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream;
  PasteAs: TfrxCopyPasteType);
var
  aChart: TfrxChartView;
  ss: TStringStream;
  aRoot: TfrxXMLItem;
  wr: TfrxXMLReader;
  Writer: TfrxXMLSerializer;
  aClass: TClass;
  Series: TChartSeries;
begin
  if PasteTo is TfrxChartView then
  begin
    aChart := TfrxChartView(PasteTo);
    ss := TStringStream.Create(Clipboard.AsText);
    Writer := TfrxXMLSerializer.Create(nil);
    aRoot := TfrxXMLItem.Create;
    wr := TfrxXMLReader.Create(ss);
    try
      wr.ReadRootItem(aRoot);
      if SameText(aRoot.Name, ChartName) then
      begin
        aClass := FindClass(aRoot.Items[0].Name);
        Series := TChartSeries(aClass.NewInstance);
        Series.Create(aChart.Chart);
        aChart.Chart.AddSeries(Series);
        Writer.Owner := aChart;
        Writer.ReadPersistentStr(aChart.Chart, Series, aRoot.Items[0].Text);
        Writer.ReadPersistentStr(aChart.Chart, aChart.SeriesData.Add,
          aRoot.Items[1].Text);
      end;
    finally
      aRoot.Free;
      wr.Free;
      ss.Free;
      Writer.Free;
    end;
    aChart.UpdateSeriesData;
    EventParams.Modified := True;
    EventParams.Refresh := True;
  end;
end;

initialization
  frxRegEditorsClasses.Register(TfrxChartView, [TfrxInPlaceChartCopyPasteEditor], [[evDesigner]]);

end.
