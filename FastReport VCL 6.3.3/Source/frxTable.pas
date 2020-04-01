unit frxTable;

interface
{$I frx.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Menus, frxClass;

type
  TfrxTableCell = class;

  TfrxCellData = class(TPersistent)
  private
    FText: WideString;
    FColSpan: Integer;
    FRowSpan: Integer;
    FCell: TfrxTableCell;
    FStyle: TfrxTableCell;
    FObjList: TList;
    FAddr: TPoint;
  public
    constructor Create;
  end;

  TfrxTableCell = class(TfrxCustomMemoView)
  private
    FColSpan: Integer;
    FRowSpan: Integer;
  published
    property ColSpan: Integer read FColSpan write FColSpan;
    property RowSpan: Integer read FRowSpan write FRowSpan;
    property AutoWidth;
    property AllowExpressions;
    property AllowHTMLTags;
    property CharSpacing;
    property Clipped;
    property DataField;
    property DataSet;
    property DataSetName;
    property DisplayFormat;
    property ExpressionDelimiters;
    property FlowTo;
    property Font;
    property Frame;
    property GapX;
    property GapY;
    property HAlign;
    property HideZeros;
    property Highlight;
    property LineSpacing;
    property Memo;
    property ParagraphGap;
    property ParentFont;
    property Rotation;
    property RTLReading;
    property Style;
    property Underlines;
    property WordBreak;
    property WordWrap;
    property Wysiwyg;
    property VAlign;
  end;
implementation

{ TfrxCellData }

constructor TfrxCellData.Create;
begin
  FColSpan := 1;
  FRowSpan := 1;
  FText = '';
end;

end.
