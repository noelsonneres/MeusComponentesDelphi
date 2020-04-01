unit frxEULAForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrxEULAConfirmForm = class(TForm)
    RichEdit1: TRichEdit;
    GroupBox1: TGroupBox;
    AcceptBtn: TButton;
    DeclineBtn: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
{$R frxEULA.res}

procedure TfrxEULAConfirmForm.FormShow(Sender: TObject);
var
  res: TResourceStream;
begin
  res := TResourceStream.Create(hInstance, 'FREULA', RT_RCDATA);
  RichEdit1.Lines.LoadFromStream(res);
  res.Free;
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

end.
