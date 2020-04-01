// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportOneDriveBase.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportonedrivebaseHPP
#define FrxiotransportonedrivebaseHPP

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
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportonedrivebase
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxOneDriveIOTransportForm;
class DELPHICLASS TfrxBaseOneDriveIOTransport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxOneDriveIOTransportForm : public Frxiotransporthelpers::TfrxBaseTransportDialog
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
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall OkBClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall ProxyPortComboBoxKeyPress(System::TObject* Sender, System::WideChar &Key);
	
protected:
	bool __fastcall IsFinalURL(System::UnicodeString URL);
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
	/* TfrxBaseTransportDialog.Destroy */ inline __fastcall virtual ~TfrxOneDriveIOTransportForm() { }
	
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxOneDriveIOTransportForm(System::Classes::TComponent* AOwner) : Frxiotransporthelpers::TfrxBaseTransportDialog(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxOneDriveIOTransportForm(System::Classes::TComponent* AOwner, int Dummy) : Frxiotransporthelpers::TfrxBaseTransportDialog(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxOneDriveIOTransportForm(HWND ParentWindow) : Frxiotransporthelpers::TfrxBaseTransportDialog(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfrxBaseOneDriveIOTransport : public Frxiotransporthelpers::TfrxHTTPIOTransport
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
	virtual void __fastcall CreateRemoteDir(System::UnicodeString DirName, bool ChangeDir = true);
	virtual System::UnicodeString __fastcall GetListFolder() = 0 ;
	virtual System::UnicodeString __fastcall GetListFolderContinue(System::UnicodeString NextLink) = 0 ;
	virtual void __fastcall CreateFolder(System::UnicodeString Dir) = 0 ;
	virtual void __fastcall DeleteFileOrFolder(System::UnicodeString Name) = 0 ;
	
public:
	__fastcall virtual TfrxBaseOneDriveIOTransport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxiotransporthelpers::TfrxBaseTransportDialogClass __fastcall TransportDialogClass();
	virtual void __fastcall GetDirItems(System::Classes::TStrings* DirItems, System::UnicodeString aFilter = System::UnicodeString());
	
__published:
	__property System::UnicodeString RemoteDir = {read=GetRemoteDir, write=SetRemoteDir};
public:
	/* TfrxHTTPIOTransport.Destroy */ inline __fastcall virtual ~TfrxBaseOneDriveIOTransport() { }
	
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxBaseOneDriveIOTransport() : Frxiotransporthelpers::TfrxHTTPIOTransport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define frx_OneD_UP_URL L"https://api.onedrive.com/v1.0/drive/root:%s:/children"
#define frx_OneD_LF_URL L"https://api.onedrive.com/v1.0/drive/root:%s:/children?sele"\
	L"ct=name,folder,file"
#define frx_OneD_DL_URL L"https://api.onedrive.com/v1.0/drive/root:%s/%s:/content"
#define frx_OneD_DEL_URL L"https://api.onedrive.com/v1.0/drive/root:%s"
#define frx_OneD_CreateDir_URL L"https://api.onedrive.com/v1.0/drive/root:%s:/children"
#define frx_OneD_Boundary L"560310243403"
}	/* namespace Frxiotransportonedrivebase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTONEDRIVEBASE)
using namespace Frxiotransportonedrivebase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportonedrivebaseHPP
