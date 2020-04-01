unit frxSaveFilterBrowser;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls,
  frxFPUMask {save Exception mask SHDocVw changes it },
  SHDocVw, Math;

type
  TTestURLEvent = function(URL: String): Boolean of object;

  TBrowserForm = class(TForm)
    WebBrowser: TWebBrowser;
    procedure FormShow(Sender: TObject);
    {$IfDef Delphi16}
    procedure WebBrowserNavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    {$Else}
    procedure WebBrowserNavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    {$EndIf}

    procedure NavigateError(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant;
      const Frame: OleVariant; const StatusCode: OleVariant;
      var Cancel: WordBool);
    procedure FormCreate(Sender: TObject);
  private
    FURL: String;
    FNavigateHistory: TStringList;
    FOnTestURL: TTestURLEvent;
    FOnDocumentComplet: TNotifyEvent;
{$IfDef Delphi16}
    procedure DocumentComplet(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
{$Else}
    procedure DocumentComplet(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
{$EndIf}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property URL: String read FURL write FURL;
    property NavigateHistory: TStringList read FNavigateHistory;
    property OnTestURL: TTestURLEvent read FOnTestURL write FOnTestURL;
    property OnDocumentComplet: TNotifyEvent read FOnDocumentComplet write FOnDocumentComplet;
  end;

implementation

{$R *.dfm}

uses
  frxMapHelpers;

{$IfDef Delphi16}
procedure TBrowserForm.DocumentComplet(ASender: TObject; const pDisp: IDispatch;
  const URL: OleVariant);
{$Else}
procedure TBrowserForm.DocumentComplet(ASender: TObject; const pDisp: IDispatch;
  var URL: OleVariant);
{$EndIf}
begin
  if Assigned(OnDocumentComplet) then
    OnDocumentComplet(Self);
end;

constructor TBrowserForm.Create(AOwner: TComponent);
begin
  inherited;
  FNavigateHistory := TStringList.Create;
end;

destructor TBrowserForm.Destroy;
begin
  FreeAndnil(FNavigateHistory);
  inherited;
end;

procedure TBrowserForm.FormCreate(Sender: TObject);
begin
  Translate(Self);
  WebBrowser.OnNavigateComplete2 := WebBrowserNavigateComplete2;
  WebBrowser.OnDocumentComplete := DocumentComplet;
{$IfDef Delphi16}
  WebBrowser.OnNavigateError := NavigateError;
{$EndIf}
end;

procedure TBrowserForm.FormShow(Sender: TObject);
begin
  WebBrowser.Navigate(URL);
end;

procedure TBrowserForm.NavigateError(ASender: TObject; const pDisp: IDispatch;
  const URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
begin
  FNavigateHistory.Add(URL + '&ReturnCode|' + VarToStr(StatusCode));
end;

{$IfDef Delphi16}
procedure TBrowserForm.WebBrowserNavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
{$Else}
procedure TBrowserForm.WebBrowserNavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
{$EndIf}
begin
  FNavigateHistory.Add(URL);
  if Assigned(OnTestURL) and OnTestURL(URL) then
    ModalResult := mrOK;
end;

initialization
  SetExceptionMask(OriginalExceptionMask);

end.
