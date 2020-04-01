
{******************************************}
{                                          }
{             FastReport v5.0              }
{                Progress                  }
{                                          }
{          Copyright (c) 2004-2008         }
{          by Alexander Fediachov,         }
{             Fast Reports, Inc.           }
{                                          }
{******************************************}

unit frxProgress;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls
  {$IFDEF FPC}
  ,LResources, LMessages, LCLType
  {$ENDIF}
  ;

type
  TfrxProgress = class(TForm)
    Panel1: TPanel;
    LMessage: TLabel;
    Bar: TProgressBar;
    CancelB: TButton;
    {$IFDEF FPC}
    procedure WMNCHitTest(var Message :TLMNCHitTest); message LM_NCHITTEST;
    {$ELSE}
    procedure WMNCHitTest(var Message :TWMNCHitTest); message WM_NCHITTEST;
    {$ENDIF}
    procedure FormCreate(Sender: TObject);
    procedure CancelBClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FActiveForm: TForm;
    FTerminated: Boolean;
    FPosition: Integer;
    FMessage: String;
    FProgress: Boolean;
    procedure SetPosition(Value: Integer);
    procedure SetMessage(const Value: String);
    procedure SetTerminated(Value: Boolean);
    procedure SetProgress(Value: Boolean);
  public
    procedure Reset;
    procedure Execute(MaxValue: Integer; const Msg: String;
      Canceled: Boolean; Progress: Boolean);
    procedure Tick;
    property Terminated: Boolean read FTerminated write SetTerminated;
    property Position: Integer read FPosition write SetPosition;
    property ShowProgress: Boolean read FProgress write SetProgress;
    property Message: String read FMessage write SetMessage;
  end;


implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses frxRes;

{ TfrxProgress }

{$IFDEF FPC}
procedure TfrxProgress.WMNCHitTest(var Message :TLMNCHitTest);
{$ELSE}
procedure TfrxProgress.WMNCHitTest(var Message: TWMNCHitTest);
{$ENDIF}
begin
  inherited;
  if Message.Result = htClient then
    Message.Result := htCaption;
end;

procedure TfrxProgress.FormCreate(Sender: TObject);
begin
  CancelB.Caption := frxGet(2);
  FActiveForm := Screen.ActiveForm;
  if FActiveForm <> nil then
  begin
    FActiveForm.Enabled := False;
  end;
  Bar.Min := 0;
  Bar.Max := 100;
  Position := 0;
  if UseRightToLeftAlignment then
    FlipChildren(True);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

procedure TfrxProgress.FormDestroy(Sender: TObject);
begin
  if FActiveForm <> nil then
    FActiveForm.Enabled := True;
end;

procedure TfrxProgress.FormHide(Sender: TObject);
begin
  if FActiveForm <> nil then
    FActiveForm.Enabled := True;
end;

procedure TfrxProgress.Reset;
begin
  Position := 0;
end;

procedure TfrxProgress.SetPosition(Value: Integer);
begin
  FPosition := Value;
  Bar.Position := Value;
  BringToFront;
  Application.ProcessMessages;
end;

procedure TfrxProgress.Execute(MaxValue: Integer; const Msg: String;
  Canceled: Boolean; Progress: Boolean);
begin
  Terminated := False;
  CancelB.Visible := Canceled;
  ShowProgress := Progress;
  Bar.Min := 0;
  Reset;
  Bar.Max := MaxValue;
  Message := Msg;
  Show;
{$IFDEF Delphi6}
  if FActiveForm <> nil then
  begin
    Self.MakeFullyVisible(FActiveForm.Monitor);//DualView workground
  end;
{$ENDIF}
  Application.ProcessMessages;
end;

procedure TfrxProgress.Tick;
begin
  if (Position < Bar.Max) and (Position >= Bar.Min) then
    Position := Position + 1;
end;

procedure TfrxProgress.SetMessage(const Value: String);
begin
  FMessage := Value;
  LMessage.Caption := Value;
  LMessage.Refresh;
end;

procedure TfrxProgress.CancelBClick(Sender: TObject);
begin
  Terminated := True;
end;

procedure TfrxProgress.SetTerminated(Value: boolean);
begin
  FTerminated := Value;
  if Value then Close;
end;

procedure TfrxProgress.SetProgress(Value: boolean);
begin
  Bar.Visible := Value;
  FProgress := Value;
  if Value then
    LMessage.Top := 15
  else
    LMessage.Top := 35;
end;

end.

