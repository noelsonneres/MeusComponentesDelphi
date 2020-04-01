// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxTransportHTTP.pas' rev: 33.00 (Windows)

#ifndef FrxtransporthttpHPP
#define FrxtransporthttpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <System.Win.ScktComp.hpp>
#include <frxServerUtils.hpp>
#include <frxNetUtils.hpp>
#include <System.Math.hpp>
#include <frxGZip.hpp>
#include <frxmd5.hpp>
#include <Winapi.WinSock.hpp>
#include <frxBaseTransportConnection.hpp>
#include <frxBaseSocketIOHandler.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxtransporthttp
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxHTTPRequest;
class DELPHICLASS TfrxTransportHTTP;
class DELPHICLASS TfrxHTTPServerFields;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxRequestType : unsigned char { xrtPost, xrtGet, xrtDelete };

enum DECLSPEC_DENUM TfrxHTTPContentType : unsigned char { htcNone, hctDefaultHTML, htcDefaultXML, htcDefaultApp };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxHTTPRequest : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::AnsiString FURL;
	System::AnsiString FContentType;
	System::AnsiString FAuthorization;
	TfrxRequestType FReqType;
	System::Classes::TStream* FSourceStream;
	System::AnsiString FAcceptTypes;
	TfrxHTTPContentType FDefAcceptTypes;
	System::AnsiString FEncoding;
	System::AnsiString FUserAgent;
	int FPort;
	System::AnsiString __fastcall GetText();
	void __fastcall SetText(const System::AnsiString Value);
	
protected:
	System::Classes::TStringList* FRequest;
	System::Classes::TStrings* FCustomHeader;
	void __fastcall SureEmptyLineAtEnd();
	
public:
	__fastcall TfrxHTTPRequest();
	__fastcall virtual ~TfrxHTTPRequest();
	virtual void __fastcall BuildRequest();
	void __fastcall Redirect(const System::AnsiString NewAddress);
	bool __fastcall IsValidAddress();
	System::AnsiString __fastcall Host(bool bTruncPort = true);
	System::AnsiString __fastcall GetPort();
	__property System::AnsiString Authorization = {read=FAuthorization, write=FAuthorization};
	__property TfrxRequestType ReqType = {read=FReqType, write=FReqType, nodefault};
	__property int Port = {read=FPort, write=FPort, nodefault};
	__property System::Classes::TStream* SourceStream = {read=FSourceStream, write=FSourceStream};
	__property System::AnsiString AcceptTypes = {read=FAcceptTypes, write=FAcceptTypes};
	__property System::AnsiString ContentType = {read=FContentType, write=FContentType};
	__property TfrxHTTPContentType DefAcceptTypes = {read=FDefAcceptTypes, write=FDefAcceptTypes, nodefault};
	__property System::Classes::TStrings* CustomHeader = {read=FCustomHeader};
	__property System::AnsiString Encoding = {read=FEncoding, write=FEncoding};
	__property System::AnsiString UserAgent = {read=FUserAgent, write=FUserAgent};
	__property System::AnsiString URL = {read=FURL, write=FURL};
	__property System::AnsiString Text = {read=GetText, write=SetText};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxTransportHTTP : public Frxbasetransportconnection::TfrxBaseTransportConnection
{
	typedef Frxbasetransportconnection::TfrxBaseTransportConnection inherited;
	
private:
	bool FActive;
	bool FConnected;
	System::AnsiString FRequestString;
	System::Classes::TStrings* FAnswer;
	bool FBreaked;
	System::Classes::TStrings* FErrors;
	bool FMIC;
	System::UnicodeString FProxyHost;
	int FProxyPort;
	int FRetryCount;
	int FRetryTimeOut;
	TfrxHTTPServerFields* FServerFields;
	System::Classes::TMemoryStream* FRequestStream;
	System::Classes::TMemoryStream* FRawDataStream;
	int FTimeOut;
	System::UnicodeString FProxyLogin;
	System::UnicodeString FProxyPassword;
	int FPort;
	unsigned FConnectDelay;
	unsigned FAnswerDelay;
	Frxbasesocketiohandler::TfrxCustomIOHandler* FIOHandler;
	void __fastcall ParseAnswer(System::Classes::TStream* aToDataStream);
	void __fastcall DoDisconnect(System::TObject* Sender, System::Win::Scktcomp::TCustomWinSocket* Socket);
	void __fastcall DoError(System::TObject* Sender, System::Win::Scktcomp::TCustomWinSocket* Socket, System::Win::Scktcomp::TErrorEvent ErrorEvent, int &ErrorCode);
	void __fastcall SetActive(const bool Value);
	void __fastcall SetServerFields(TfrxHTTPServerFields* const Value);
	void __fastcall SetIOHandler(Frxbasesocketiohandler::TfrxCustomIOHandler* const Value);
	
protected:
	TfrxHTTPRequest* FHTTPRequest;
	System::Win::Scktcomp::TClientSocket* FClientSocket;
	unsigned StreamSize;
	void __fastcall SetSocketDestination();
	bool __fastcall IsAnswerCodeIn(int *Answers, const int Answers_High);
	virtual System::UnicodeString __fastcall GetProxyHost();
	virtual System::UnicodeString __fastcall GetProxyLogin();
	virtual System::UnicodeString __fastcall GetProxyPassword();
	virtual int __fastcall GetProxyPort();
	virtual void __fastcall SetProxyHost(const System::UnicodeString Value);
	virtual void __fastcall SetProxyLogin(const System::UnicodeString Value);
	virtual void __fastcall SetProxyPassword(const System::UnicodeString Value);
	virtual void __fastcall SetProxyPort(const int Value);
	
public:
	__fastcall virtual TfrxTransportHTTP(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxTransportHTTP();
	virtual void __fastcall Connect();
	void __fastcall StartListening();
	virtual void __fastcall Disconnect();
	void __fastcall Open();
	void __fastcall Close();
	void __fastcall DoWrite(System::TObject* Sender, System::Win::Scktcomp::TCustomWinSocket* Socket);
	void __fastcall DoRead(System::TObject* Sender, System::Win::Scktcomp::TCustomWinSocket* Socket);
	void __fastcall Send(System::Classes::TStream* aSource);
	virtual void __fastcall SetDefaultParametersWithToken(System::UnicodeString AToken);
	void __fastcall Receive(System::Classes::TStream* aSource);
	System::AnsiString __fastcall Post(System::AnsiString aURL, System::Classes::TStream* aSource = (System::Classes::TStream*)(0x0))/* overload */;
	System::AnsiString __fastcall Get(System::AnsiString aURL, System::Classes::TStream* aSource = (System::Classes::TStream*)(0x0))/* overload */;
	System::WideString __fastcall Post(System::WideString aURL, System::Classes::TStream* aSource = (System::Classes::TStream*)(0x0))/* overload */;
	System::WideString __fastcall Get(System::WideString aURL, System::Classes::TStream* aSource = (System::Classes::TStream*)(0x0))/* overload */;
	System::AnsiString __fastcall Delete(System::AnsiString aURL)/* overload */;
	System::WideString __fastcall Delete(System::WideString aURL)/* overload */;
	__property System::Classes::TStrings* Answer = {read=FAnswer, write=FAnswer};
	__property System::Classes::TStrings* Errors = {read=FErrors, write=FErrors};
	__property System::Classes::TMemoryStream* RequestStream = {read=FRequestStream};
	__property Frxbasesocketiohandler::TfrxCustomIOHandler* IOHandler = {read=FIOHandler, write=SetIOHandler};
	
__published:
	__property bool Active = {read=FActive, write=SetActive, nodefault};
	__property System::AnsiString RequestString = {read=FRequestString, write=FRequestString};
	__property TfrxHTTPRequest* HTTPRequest = {read=FHTTPRequest};
	__property System::Win::Scktcomp::TClientSocket* ClientSocket = {read=FClientSocket};
	__property bool MIC = {read=FMIC, write=FMIC, nodefault};
	__property int Port = {read=FPort, write=FPort, nodefault};
	__property ProxyHost = {default=0};
	__property ProxyPort;
	__property ProxyLogin = {default=0};
	__property ProxyPassword = {default=0};
	__property int RetryCount = {read=FRetryCount, write=FRetryCount, nodefault};
	__property int RetryTimeOut = {read=FRetryTimeOut, write=FRetryTimeOut, nodefault};
	__property TfrxHTTPServerFields* ServerFields = {read=FServerFields, write=SetServerFields};
	__property int TimeOut = {read=FTimeOut, write=FTimeOut, nodefault};
	__property unsigned ConnectDelay = {read=FConnectDelay, nodefault};
	__property unsigned AnswerDelay = {read=FAnswerDelay, nodefault};
	__property OnWork;
	__property OnWorkBegin;
	__property OnWorkEnd;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxHTTPServerFields : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FAnswerCode;
	System::UnicodeString FContentEncoding;
	System::UnicodeString FContentMD5;
	int FContentLength;
	System::UnicodeString FLocation;
	System::UnicodeString FSessionId;
	System::UnicodeString FCookie;
	
public:
	__fastcall TfrxHTTPServerFields();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall ParseAnswer(System::AnsiString st);
	
__published:
	__property int AnswerCode = {read=FAnswerCode, write=FAnswerCode, nodefault};
	__property System::UnicodeString ContentEncoding = {read=FContentEncoding, write=FContentEncoding};
	__property System::UnicodeString ContentMD5 = {read=FContentMD5, write=FContentMD5};
	__property int ContentLength = {read=FContentLength, write=FContentLength, nodefault};
	__property System::UnicodeString Location = {read=FLocation, write=FLocation};
	__property System::UnicodeString SessionId = {read=FSessionId, write=FSessionId};
	__property System::UnicodeString Cookie = {read=FCookie, write=FCookie};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxHTTPServerFields() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define HTTP_POST L"POST"
#define HTTP_GET L"GET"
#define HTTP_DELETE L"DELETE"
#define HTTP_VER1 L"HTTP/1.0"
extern DELPHI_PACKAGE System::AnsiString HTTP_LINK_PREFIX;
extern DELPHI_PACKAGE System::AnsiString HTTPS_LINK_PREFIX;
extern DELPHI_PACKAGE System::Math::TFPUExceptionMask msc;
extern DELPHI_PACKAGE void __fastcall frxTestToken(const System::UnicodeString URL, System::UnicodeString &sToken, bool bUsePOST = false);
}	/* namespace Frxtransporthttp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXTRANSPORTHTTP)
using namespace Frxtransporthttp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxtransporthttpHPP
