// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportDropboxBase.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportdropboxbaseHPP
#define FrxiotransportdropboxbaseHPP

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
#include <frxClass.hpp>
#include <frxIOTransportHelpers.hpp>
#include <frxBaseTransportConnection.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportdropboxbase
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxDropboxIOTransportForm;
class DELPHICLASS TfrxBaseDropboxIOTransport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxDropboxIOTransportForm : public Frxiotransporthelpers::TfrxBaseTransportDialog
{
	typedef Frxiotransporthelpers::TfrxBaseTransportDialog inherited;
	
__published:
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TLabel* RequiredLabel;
	Vcl::Stdctrls::TCheckBox* RememberPropertiesCheckBox;
	Vcl::Comctrls::TPageControl* PageControl;
	Vcl::Comctrls::TTabSheet* GeneralTabSheet;
	Vcl::Stdctrls::TEdit* ClientIDEdit;
	Vcl::Stdctrls::TLabel* ClientIDLabel;
	Vcl::Stdctrls::TComboBox* RemoteDirComboBox;
	Vcl::Stdctrls::TLabel* RemoteDirLabel;
	Vcl::Comctrls::TTabSheet* ProxyTabSheet;
	Vcl::Stdctrls::TCheckBox* UseProxyServerCheckBox;
	Vcl::Stdctrls::TLabel* ProxyPasswordLabel;
	Vcl::Stdctrls::TLabel* ProxyUserNameLabel;
	Vcl::Stdctrls::TLabel* ProxyPortLabel;
	Vcl::Stdctrls::TLabel* ProxyHostLabel;
	Vcl::Stdctrls::TEdit* ProxyPasswordEdit;
	Vcl::Stdctrls::TEdit* ProxyUserNameEdit;
	Vcl::Stdctrls::TComboBox* ProxyPortComboBox;
	Vcl::Stdctrls::TComboBox* ProxyHostComboBox;
	Vcl::Stdctrls::TLabel* UserNameLabel;
	Vcl::Stdctrls::TLabel* PasswordLabel;
	Vcl::Stdctrls::TEdit* UserNameEdit;
	Vcl::Stdctrls::TEdit* PasswordEdit;
	Vcl::Stdctrls::TCheckBox* PassLoginCB;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall OkBClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall ProxyPortComboBoxKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall PassLoginCBClick(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	
protected:
	bool __fastcall IsFinalURL(System::UnicodeString URL);
	void __fastcall DocumentComplet(System::TObject* Sender);
	void __fastcall UpdateControls();
	virtual void __fastcall InitControlsFromFilter(Frxiotransporthelpers::TfrxInternetIOTransport* TransportFilter);
	virtual void __fastcall InitFilterFromDialog(Frxiotransporthelpers::TfrxInternetIOTransport* TransportFilter);
	
private:
	System::UnicodeString FAccessToken;
	System::UnicodeString FErrorMessage;
	void __fastcall RequireIf(Vcl::Stdctrls::TLabel* L, bool Flag, int MR = 0x0);
	bool __fastcall IsGetToken();
	
public:
	__property System::UnicodeString AccessToken = {read=FAccessToken};
	__property System::UnicodeString ErrorMessage = {read=FErrorMessage};
public:
	/* TfrxBaseTransportDialog.Destroy */ inline __fastcall virtual ~TfrxDropboxIOTransportForm() { }
	
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxDropboxIOTransportForm(System::Classes::TComponent* AOwner) : Frxiotransporthelpers::TfrxBaseTransportDialog(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxDropboxIOTransportForm(System::Classes::TComponent* AOwner, int Dummy) : Frxiotransporthelpers::TfrxBaseTransportDialog(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxDropboxIOTransportForm(HWND ParentWindow) : Frxiotransporthelpers::TfrxBaseTransportDialog(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfrxBaseDropboxIOTransport : public Frxiotransporthelpers::TfrxHTTPIOTransport
{
	typedef Frxiotransporthelpers::TfrxHTTPIOTransport inherited;
	
private:
	void __fastcall SetRemoteDir(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetRemoteDir();
	
protected:
	virtual System::UnicodeString __fastcall FilterSection();
	virtual void __fastcall TestRemoteDir();
	virtual void __fastcall DialogDirChange(System::UnicodeString Name, System::UnicodeString Id, System::Classes::TStrings* DirItems);
	virtual void __fastcall DialogDirCreate(System::UnicodeString Name, System::Classes::TStrings* DirItems);
	virtual void __fastcall DialogFileDelete(System::UnicodeString Name, System::UnicodeString Id, System::Classes::TStrings* DirItems);
	virtual void __fastcall DialogDirDelete(System::UnicodeString Name, System::UnicodeString Id, System::Classes::TStrings* DirItems);
	virtual System::UnicodeString __fastcall FolderAPI(const System::UnicodeString URL, const System::UnicodeString Source) = 0 ;
	System::UnicodeString __fastcall GetListFolder();
	System::UnicodeString __fastcall GetListFolderContinue(System::UnicodeString Cursor);
	void __fastcall CreateFolder(System::UnicodeString Dir);
	virtual void __fastcall CreateRemoteDir(System::UnicodeString DirName, bool ChangeDir = true);
	void __fastcall DeleteFileOrFolder(System::UnicodeString Name);
	virtual bool __fastcall IsDeleteSupported();
	
public:
	__fastcall virtual TfrxBaseDropboxIOTransport(System::Classes::TComponent* AOwner);
	virtual void __fastcall AssignSharedProperties(Frxclass::TfrxCustomIOTransport* Source);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxiotransporthelpers::TfrxBaseTransportDialogClass __fastcall TransportDialogClass();
	virtual void __fastcall GetDirItems(System::Classes::TStrings* DirItems, System::UnicodeString aFilter = System::UnicodeString());
	
__published:
	__property System::UnicodeString RemoteDir = {read=GetRemoteDir, write=SetRemoteDir};
public:
	/* TfrxHTTPIOTransport.Destroy */ inline __fastcall virtual ~TfrxBaseDropboxIOTransport() { }
	
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxBaseDropboxIOTransport() : Frxiotransporthelpers::TfrxHTTPIOTransport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define FRX_DBOX_DL_URL L"https://content.dropboxapi.com/2/files/download"
#define FRX_DBOX_UL_URL L"https://content.dropboxapi.com/2/files/upload"
}	/* namespace Frxiotransportdropboxbase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTDROPBOXBASE)
using namespace Frxiotransportdropboxbase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportdropboxbaseHPP
