// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportFTP.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportftpHPP
#define FrxiotransportftpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <frxIOTransportHelpers.hpp>
#include <frxBaseTransportConnection.hpp>
#include <frxTransportIndyConnector.hpp>
#include <IdFTP.hpp>
#include <IdComponent.hpp>
#include <IdTCPConnection.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportftp
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxFTPIOTransportForm;
class DELPHICLASS TfrxTransportIndyFTPConnector;
class DELPHICLASS TfrxFTPIOTransport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxFTPIOTransportForm : public Frxiotransporthelpers::TfrxBaseTransportDialog
{
	typedef Frxiotransporthelpers::TfrxBaseTransportDialog inherited;
	
__published:
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TLabel* RequiredLabel;
	Vcl::Stdctrls::TCheckBox* RememberPropertiesCheckBox;
	Vcl::Comctrls::TPageControl* PageControl;
	Vcl::Comctrls::TTabSheet* GeneralTabSheet;
	Vcl::Stdctrls::TLabel* HostLabel;
	Vcl::Stdctrls::TLabel* PortLabel;
	Vcl::Stdctrls::TLabel* UserNameLabel;
	Vcl::Stdctrls::TLabel* PasswordLabel;
	Vcl::Stdctrls::TLabel* RemoteDirLabel;
	Vcl::Stdctrls::TComboBox* HostComboBox;
	Vcl::Stdctrls::TComboBox* PortComboBox;
	Vcl::Stdctrls::TEdit* PasswordEdit;
	Vcl::Stdctrls::TEdit* UserNameEdit;
	Vcl::Stdctrls::TCheckBox* PassiveCheckBox;
	Vcl::Stdctrls::TComboBox* RemoteDirComboBox;
	Vcl::Comctrls::TTabSheet* ProxyTabSheet;
	Vcl::Stdctrls::TEdit* ProxyPasswordEdit;
	Vcl::Stdctrls::TEdit* ProxyUserNameEdit;
	Vcl::Stdctrls::TComboBox* ProxyPortComboBox;
	Vcl::Stdctrls::TComboBox* ProxyHostComboBox;
	Vcl::Stdctrls::TLabel* ProxyPasswordLabel;
	Vcl::Stdctrls::TLabel* ProxyUserNameLabel;
	Vcl::Stdctrls::TLabel* ProxyPortLabel;
	Vcl::Stdctrls::TLabel* ProxyHostLabel;
	Vcl::Stdctrls::TLabel* ProxyTypeLabel;
	Vcl::Stdctrls::TComboBox* ProxyTypeComboBox;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall OkBClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall PortComboBoxKeyPress(System::TObject* Sender, System::WideChar &Key);
	
protected:
	virtual void __fastcall InitControlsFromFilter(Frxiotransporthelpers::TfrxInternetIOTransport* TransportFilter);
	virtual void __fastcall InitFilterFromDialog(Frxiotransporthelpers::TfrxInternetIOTransport* TransportFilter);
	
private:
	void __fastcall RequireIf(Vcl::Stdctrls::TLabel* L, bool Flag, int MR = 0x0);
public:
	/* TfrxBaseTransportDialog.Destroy */ inline __fastcall virtual ~TfrxFTPIOTransportForm() { }
	
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxFTPIOTransportForm(System::Classes::TComponent* AOwner) : Frxiotransporthelpers::TfrxBaseTransportDialog(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxFTPIOTransportForm(System::Classes::TComponent* AOwner, int Dummy) : Frxiotransporthelpers::TfrxBaseTransportDialog(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxFTPIOTransportForm(HWND ParentWindow) : Frxiotransporthelpers::TfrxBaseTransportDialog(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfrxTransportIndyFTPConnector : public Frxtransportindyconnector::TfrxTransportIndyConnector
{
	typedef Frxtransportindyconnector::TfrxTransportIndyConnector inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetProxyHost();
	virtual System::UnicodeString __fastcall GetProxyLogin();
	virtual System::UnicodeString __fastcall GetProxyPassword();
	virtual int __fastcall GetProxyPort();
	virtual void __fastcall SetProxyHost(const System::UnicodeString Value);
	virtual void __fastcall SetProxyLogin(const System::UnicodeString Value);
	virtual void __fastcall SetProxyPassword(const System::UnicodeString Value);
	virtual void __fastcall SetProxyPort(const int Value);
	
public:
	virtual void __fastcall SetDefaultParametersWithToken(System::UnicodeString AToken);
public:
	/* TfrxTransportIndyConnector.Create */ inline __fastcall virtual TfrxTransportIndyFTPConnector(System::Classes::TComponent* AOwner) : Frxtransportindyconnector::TfrxTransportIndyConnector(AOwner) { }
	/* TfrxTransportIndyConnector.Destroy */ inline __fastcall virtual ~TfrxTransportIndyFTPConnector() { }
	
};


class PASCALIMPLEMENTATION TfrxFTPIOTransport : public Frxiotransporthelpers::TfrxInternetIOTransport
{
	typedef Frxiotransporthelpers::TfrxInternetIOTransport inherited;
	
private:
	System::UnicodeString FHost;
	int FPort;
	System::UnicodeString FUserName;
	System::UnicodeString FPassword;
	bool FPassive;
	Idftp::TIdFtpProxyType FProxyType;
	System::UnicodeString FRemoteDir;
	void __fastcall FTPDeleteFile(System::UnicodeString Name);
	void __fastcall FTPDeleteFolder(System::UnicodeString Name);
	void __fastcall FTPSetHost();
	void __fastcall FTPSetProxy();
	
protected:
	Idftp::TIdFTP* FFTP;
	TfrxTransportIndyFTPConnector* FConnector;
	virtual Frxbasetransportconnection::TfrxBaseTransportConnection* __fastcall Connection();
	virtual System::UnicodeString __fastcall FilterSection();
	virtual void __fastcall DialogDirChange(System::UnicodeString Name, System::UnicodeString Id, System::Classes::TStrings* DirItems);
	virtual void __fastcall DialogDirCreate(System::UnicodeString Name, System::Classes::TStrings* DirItems);
	virtual void __fastcall DialogFileDelete(System::UnicodeString Name, System::UnicodeString Id, System::Classes::TStrings* DirItems);
	virtual void __fastcall DialogDirDelete(System::UnicodeString Name, System::UnicodeString Id, System::Classes::TStrings* DirItems);
	virtual bool __fastcall CreateConnector();
	virtual void __fastcall DisposeConnector();
	virtual bool __fastcall DoConnectorConncet();
	virtual bool __fastcall DoBeforeSent();
	virtual void __fastcall Upload(System::Classes::TStream* const Source, System::UnicodeString DestFileName = System::UnicodeString());
	virtual void __fastcall Download(const System::UnicodeString SourceFileName, System::Classes::TStream* const Source);
	virtual void __fastcall CreateRemoteDir(System::UnicodeString DirName, bool ChangeDir = true);
	virtual void __fastcall ChangeDirUP();
	
public:
	__fastcall virtual TfrxFTPIOTransport(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxFTPIOTransport();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall GetDirItems(System::Classes::TStrings* DirItems, System::UnicodeString aFilter = System::UnicodeString());
	__classmethod virtual Frxiotransporthelpers::TfrxBaseTransportDialogClass __fastcall TransportDialogClass();
	virtual Frxbasetransportconnection::TfrxBaseTransportConnectionClass __fastcall GetConnectorInstance();
	
__published:
	__property System::UnicodeString Host = {read=FHost, write=FHost};
	__property int Port = {read=FPort, write=FPort, nodefault};
	__property System::UnicodeString UserName = {read=FUserName, write=FUserName};
	__property System::UnicodeString Password = {read=FPassword, write=FPassword};
	__property bool Passive = {read=FPassive, write=FPassive, nodefault};
	__property Idftp::TIdFtpProxyType ProxyType = {read=FProxyType, write=FProxyType, nodefault};
	__property System::UnicodeString RemoteDir = {read=FRemoteDir, write=FRemoteDir};
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxFTPIOTransport() : Frxiotransporthelpers::TfrxInternetIOTransport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxiotransportftp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTFTP)
using namespace Frxiotransportftp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportftpHPP
