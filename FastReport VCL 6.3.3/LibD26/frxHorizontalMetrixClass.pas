unit frxHorizontalMetrixClass;

interface

{$I frx.inc}

uses TTFHelpers, frxTrueTypeTable;

type
    longHorMetric = packed record
        advanceWidth: Word;
        lsb: Smallint;
    end;

    THorMetricArray = array of longHorMetric;

  HorizontalMetrixClass = class(TrueTypeTable)
    private MetrixTable: THorMetricArray;
    public NumberOfMetrics: Word;

    public constructor Create(src: TrueTypeTable);
    public procedure Load(font: Pointer); override;
    public function GetItem(index : integer): longHorMetric;

    public property Item[index: Integer]: longHorMetric read GetItem;


end;

implementation

    constructor HorizontalMetrixClass.Create(src: TrueTypeTable);
    begin
      inherited Create(src);
    end;

    function HorizontalMetrixClass.GetItem(index : integer): longHorMetric;
    begin
      if index >= NumberOfMetrics then
        Result := MetrixTable[NumberOfMetrics - 1]
      else
        Result := MetrixTable[index];
    end;

    procedure HorizontalMetrixClass.Load(font: Pointer);
    var
      h_metrix: ^longHorMetric;
      i: Integer;
    begin

        SetLength(self.MetrixTable, self.NumberOfMetrics);
        h_metrix := TTF_Helpers.Increment(font, self.entry.offset);
        i := 0;
        while ((i < self.NumberOfMetrics)) do
        begin
            self.MetrixTable[i].advanceWidth := TTF_Helpers.SwapUInt16( h_metrix.advanceWidth );
            self.MetrixTable[i].lsb := TTF_Helpers.SwapInt16( h_metrix.lsb);
            Inc(h_metrix); // Check incremet size - must be record size
            inc(i)
        end
    end;
end.
