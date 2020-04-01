unit frxSelSeries;

{$I frx.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, Menus, CheckLst;

type

  { TSelSeries }

  TSelSeries = class(TForm)
    bbArea: TBitBtn;
    bbBox: TBitBtn;
    bbConst: TBitBtn;
    bbBar: TBitBtn;
    bbHBar: TBitBtn;
    bbLine: TBitBtn;
    bbPoint: TBitBtn;
    BitPie: TBitBtn;
    bbPolar: TBitBtn;
    bbBubble: TBitBtn;
    bbOHLC: TBitBtn;
    gbSel: TGroupBox;
    procedure BClick(Sender:TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    FTag:PtrInt;
  public
    { public declarations }

  end;

  function GetChTag:Integer;



implementation

function GetChTag: Integer;
var
  sls: TSelSeries;
begin
  Result := 0;
  sls := TSelSeries.Create(nil);
  try
    sls.ShowModal;
    Result := sls.Tag;
  finally
    sls.Free;
  end;
end;

{$R *.lfm}

{ TSelSeries }


procedure TSelSeries.BClick(Sender: TObject);
begin
  Tag := 0;
  Tag := (Sender as TBitBtn).Tag;
end;

procedure TSelSeries.FormCreate(Sender: TObject);
var
  I:Integer;
begin
  for I := 0 to gbSel.ControlCount - 1 do
  begin
    if gbSel.Controls[I] is TBitBtn then
    begin
      (gbSel.Controls[I] as TBitBtn).ModalResult := mrOK;
      (gbSel.Controls[I] as TBitBtn).OnClick := BClick;
      //(gbSel.Controls[I] as TBitBtn).Tag := I + 1;
    end;
  end;
end;



end.

