unit frxMapLayerForm;

interface

{$I frx.inc}

uses
{$IFNDEF FPC}
  Windows, Messages,
{$ELSE}
  LCLType, LCLIntf, LCLProc, LazHelper, ColorBox,
{$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, frxCtrls, frxMapHelpers {$IFDEF FPC},EditBtn{$ENDIF};

type
  TfrxMapLayerForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    rbMapFile: TRadioButton;
    edMapFile: {$IFNDEF FPC}TfrxComboEdit{$ELSE}TEditButton{$ENDIF};
    cbEmbed: TCheckBox;
    rbAppData: TRadioButton;
    lblSelect: TLabel;
    OpenDialog: TOpenDialog;
    rbInteractive: TRadioButton;
    rbGeodata: TRadioButton;
    procedure edMapFileButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function IsEmbed: Boolean;
    function LayerType: TLayerType;
    function MapFile: string;
    procedure EnableInteractive(Value: boolean);
  end;

implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  frxUtils;

{ TfrxMapLayerForm }

procedure TfrxMapLayerForm.edMapFileButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    edMapFile.Text := OpenDialog.FileName;
end;

procedure TfrxMapLayerForm.EnableInteractive(Value: boolean);
begin
  rbInteractive.Enabled := Value;
end;

procedure TfrxMapLayerForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (ModalResult = mrOk) and rbMapFile.Checked and not FileExists(edMapFile.Text) then
  begin
    frxErrorMsg('Please specify correct file name');
    CanClose := False;
  end;
end;

procedure TfrxMapLayerForm.FormCreate(Sender: TObject);
begin
  Translate(Self);
end;

function TfrxMapLayerForm.IsEmbed: Boolean;
begin
  Result := cbEmbed.Checked or (LayerType in [ltApplication, ltInteractive, ltGeodata]);
end;

function TfrxMapLayerForm.LayerType: TLayerType;
begin
  if      rbAppData.Checked then
    Result := ltApplication
  else if rbInteractive.Checked then
    Result := ltInteractive
  else if rbMapFile.Checked then
    Result := ltMapFile
  else if Self.rbGeodata.Checked then
    Result := ltGeodata
  else
    raise Exception.Create('Unknown Layer Type');
end;

function TfrxMapLayerForm.MapFile: string;
begin
  Result := edMapFile.Text;
end;

end.
