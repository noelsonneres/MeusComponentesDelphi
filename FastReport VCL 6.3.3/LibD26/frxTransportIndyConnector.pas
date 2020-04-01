
{******************************************}
{                                          }
{             FastReport v6.0              }
{          HTTP connection client          }
{                                          }
{         Copyright (c) 2006-2018          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxTransportIndyConnector;

{$I frx.inc}
interface

uses
  Windows, SysUtils, Classes, frxBaseTransportConnection,
  IdComponent, IdTCPConnection;

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxTransportIndyConnector = class(TfrxBaseTransportConnection)
  private
    procedure SetIdConnection(const Value: TIdTCPConnection);
    procedure ConnectionWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      {$IfDef INDYPARAM_INT}{$IfDef INDY10_2005} AWorkCount: Integer
      {$ELSE}
                           const AWorkCount: Integer
      {$ENDIF}
      {$Else}              AWorkCount: Int64 {$EndIf});
    procedure ConnectionWork(Sender: TObject; AWorkMode: TWorkMode;
      {$IfDef INDYPARAM_INT}{$IfDef INDY10_2005} AWorkCount: Integer
      {$ELSE}
                           const AWorkCount: Integer
      {$ENDIF}
      {$Else}              AWorkCount: Int64 {$EndIf});
  protected
    FIdConnection: TIdTCPConnection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect; override;
    procedure Disconnect; override;
    property IdConnection: TIdTCPConnection read FIdConnection write SetIdConnection;
  published
    property ProxyHost;
    property ProxyPort;
    property ProxyLogin;
    property ProxyPassword;
    property OnWork;
    property OnWorkBegin;
    property OnWorkEnd;
  end;

implementation

uses
  StrUtils,
  frxFileUtils, frxUtils
{$IFDEF DELPHI12}
  ,AnsiStrings
{$ENDIF};

{ TfrxTransportIndyConnector }

procedure TfrxTransportIndyConnector.ConnectionWork(Sender: TObject; AWorkMode: TWorkMode;
      {$IfDef INDYPARAM_INT}{$IfDef INDY10_2005} AWorkCount: Integer
      {$ELSE}
                           const AWorkCount: Integer
      {$EndIf}
      {$Else}              AWorkCount: Int64 {$EndIf});
begin
  if Assigned(OnWork) then
    OnWork(Sender, TfrxHTTPWorkMode(AWorkMode), AWorkCount);
end;

procedure TfrxTransportIndyConnector.ConnectionWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      {$IfDef INDYPARAM_INT}{$IfDef INDY10_2005} AWorkCount: Integer
      {$ELSE}
                           const AWorkCount: Integer
      {$EndIf}
      {$Else}              AWorkCount: Int64 {$EndIf});
begin
  if Assigned(OnWorkBegin) then
    OnWorkBegin(Sender, TfrxHTTPWorkMode(AWorkMode), AWorkCount);
end;

constructor TfrxTransportIndyConnector.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TfrxTransportIndyConnector.Connect;
begin
  FIdConnection.OnWorkBegin := ConnectionWorkBegin;
  FIdConnection.OnWork := ConnectionWork;
  //FIdConnection.Socket.Open;
end;

destructor TfrxTransportIndyConnector.Destroy;
begin
  FIdConnection.Disconnect;
end;

procedure TfrxTransportIndyConnector.Disconnect;
begin
  FIdConnection.Disconnect;
end;


procedure TfrxTransportIndyConnector.SetIdConnection(
  const Value: TIdTCPConnection);
begin
  FIdConnection := Value;
  FIdConnection.OnWorkBegin := ConnectionWorkBegin;
  FIdConnection.OnWork := ConnectionWork;
end;

end.
