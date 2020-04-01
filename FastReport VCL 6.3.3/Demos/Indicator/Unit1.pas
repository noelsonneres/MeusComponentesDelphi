unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  frxGaugePanel;

type
  TForm1 = class(TForm)
    frxGaugePanel1: TfrxGaugePanel;
    frxGaugePanel2: TfrxGaugePanel;
    frxGaugePanel3: TfrxGaugePanel;
    frxGaugePanel4: TfrxGaugePanel;
    frxIntervalGaugePanel1: TfrxIntervalGaugePanel;
    frxIntervalGaugePanel2: TfrxIntervalGaugePanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
