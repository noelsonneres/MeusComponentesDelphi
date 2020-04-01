unit frxConnType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrxConnTypeEdit = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    ADOCB: TRadioButton;
    FIBCB: TRadioButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frxConnTypeEdit: TfrxConnTypeEdit;

implementation

{$R *.dfm}

end.
