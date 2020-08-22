unit uDWDatamodule;

interface

Uses
  SysUtils, Classes, SysTypes, uSystemEvents, uDWJSONObject, uDWConstsData, uDWConstsCharset, uRESTDWServerEvents;

 Type
  TRESTDWClientInfo = Class(TObject)
 Private
  vip,
  vipVersion,
  vUserAgent : String;
  vport      : Integer;
  Procedure  SetClientInfo(ip, ipVersion, UserAgent : String; port : Integer);
 Protected
 Public
  Constructor Create;
//  Procedure   Assign(Source : TPersistent); Override;
 Published
  Property ip        : String  Read vip;
  Property UserAgent : String  Read vUserAgent;
  Property port      : Integer Read vport;
 End;

 Type
  TServerMethodDataModule = Class(TDataModule)
  Private
   vClientWelcomeMessage : String;
   vReplyEvent           : TReplyEvent;
   vWelcomeMessage       : TWelcomeMessage;
   vMassiveProcess       : TMassiveProcess;
   vOnMassiveBegin,
   vOnMassiveAfterStartTransaction,
   vOnMassiveAfterBeforeCommit,
   vOnMassiveAfterAfterCommit,
   vOnMassiveEnd         : TMassiveEvent;
   vEncoding             : TEncodeSelect;
   vRESTDWClientInfo     : TRESTDWClientInfo;
  Public
   Procedure   SetClientWelcomeMessage(Value : String);
   Procedure   SetClientInfo(ip, ipVersion, UserAgent : String; port : Integer);
   Constructor Create(Sender : TComponent);Override;
   Destructor  Destroy;override;
  Published
   Property ClientWelcomeMessage           : String            Read vClientWelcomeMessage;
   Property ClientInfo                     : TRESTDWClientInfo Read vRESTDWClientInfo;
   Property Encoding                       : TEncodeSelect     Read vEncoding                       Write vEncoding;
   Property OnReplyEvent                   : TReplyEvent       Read vReplyEvent                     Write vReplyEvent;
   Property OnWelcomeMessage               : TWelcomeMessage   Read vWelcomeMessage                 Write vWelcomeMessage;
   Property OnMassiveProcess               : TMassiveProcess   Read vMassiveProcess                 Write vMassiveProcess;
   Property OnMassiveBegin                 : TMassiveEvent     Read vOnMassiveBegin                 Write vOnMassiveBegin;
   Property OnMassiveAfterStartTransaction : TMassiveEvent     Read vOnMassiveAfterStartTransaction Write vOnMassiveAfterStartTransaction;
   Property OnMassiveAfterBeforeCommit     : TMassiveEvent     Read vOnMassiveAfterBeforeCommit     Write vOnMassiveAfterBeforeCommit;
   Property OnMassiveAfterAfterCommit      : TMassiveEvent     Read vOnMassiveAfterAfterCommit      Write vOnMassiveAfterAfterCommit;
   Property OnMassiveEnd                   : TMassiveEvent     Read vOnMassiveEnd                   Write vOnMassiveEnd;
 End;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

{ TServerMethodDataModule }

Destructor TServerMethodDataModule.Destroy;
Begin
 FreeAndNil(vRESTDWClientInfo);
 Inherited;
End;

Procedure TServerMethodDataModule.SetClientInfo(ip, ipVersion, UserAgent : String; port : Integer);
Begin
 vRESTDWClientInfo.SetClientInfo(Trim(ip), ipVersion, Trim(UserAgent), Port);
End;

Constructor TServerMethodDataModule.Create(Sender: TComponent);
Begin
 Inherited Create(Sender);
 vRESTDWClientInfo := TRESTDWClientInfo.Create;
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
  Encoding         := esUtf8;
 {$ELSE}
  Encoding         := esAscii;
 {$IFEND}
 {$ELSE}
  Encoding         := esUtf8;
 {$ENDIF}
End;

Procedure TServerMethodDataModule.SetClientWelcomeMessage(Value: String);
Begin
 vClientWelcomeMessage := Value;
End;

{ TRESTDWClientInfo }
{
Procedure TRESTDWClientInfo.Assign(Source : TPersistent);
Var
 Src : TRESTDWClientInfo;
Begin
 If Source is TRESTDWClientInfo Then
  Begin
   Src        := TRESTDWClientInfo(Source);
   vip        := Trim(Src.ip);
   vUserAgent := Trim(Src.UserAgent);
   vport      := Src.Port;
  End
 Else
  Inherited;
End;
}
Constructor TRESTDWClientInfo.Create;
Begin
 Inherited;
 vip        := '0.0.0.0';
 vUserAgent := 'Undefined';
 vport      := 0;
End;

Procedure TRESTDWClientInfo.SetClientInfo(ip, ipVersion, UserAgent: String; port: Integer);
Begin
 vip        := Trim(ip);
 vUserAgent := Trim(UserAgent);
 vipVersion := Trim(ipVersion);
 vport      := Port;
End;

end.
