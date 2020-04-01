// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportGoogleDriveBase.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportgoogledrivebaseHPP
#define FrxiotransportgoogledrivebaseHPP

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

namespace Frxiotransportgoogledrivebase
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxGoogleDriveIOTransportForm;
class DELPHICLASS TfrxBaseGoogleDriveIOTransport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxGoogleDriveIOTransportForm : public Frxiotransporthelpers::TfrxBaseTransportDialog
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
	Vcl::Stdctrls::TEdit* ClientSecretEdit;
	Vcl::Stdctrls::TLabel* ClientSecretLabel;
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
	/* TfrxBaseTransportDialog.Destroy */ inline __fastcall virtual ~TfrxGoogleDriveIOTransportForm() { }
	
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxGoogleDriveIOTransportForm(System::Classes::TComponent* AOwner) : Frxiotransporthelpers::TfrxBaseTransportDialog(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxGoogleDriveIOTransportForm(System::Classes::TComponent* AOwner, int Dummy) : Frxiotransporthelpers::TfrxBaseTransportDialog(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxGoogleDriveIOTransportForm(HWND ParentWindow) : Frxiotransporthelpers::TfrxBaseTransportDialog(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfrxBaseGoogleDriveIOTransport : public Frxiotransporthelpers::TfrxHTTPIOTransport
{
	typedef Frxiotransporthelpers::TfrxHTTPIOTransport inherited;
	
protected:
	System::UnicodeString FClientSecret;
	Frxiotransporthelpers::TDirStack* FDirStack;
	virtual System::UnicodeString __fastcall FilterSection();
	virtual void __fastcall DialogDirChange(System::UnicodeString Name, System::UnicodeString Id, System::Classes::TStrings* DirItems);
	virtual void __fastcall DialogDirCreate(System::UnicodeString Name, System::Classes::TStrings* DirItems);
	virtual void __fastcall DialogFileDelete(System::UnicodeString Name, System::UnicodeString Id, System::Classes::TStrings* DirItems);
	virtual void __fastcall DialogDirDelete(System::UnicodeString Name, System::UnicodeString Id, System::Classes::TStrings* DirItems);
	virtual void __fastcall CreateRemoteDir(System::UnicodeString DirName, bool ChangeDir = true);
	virtual void __fastcall ChangeDirUP();
	virtual System::UnicodeString __fastcall GetListFolder(System::UnicodeString aFilter = System::UnicodeString()) = 0 ;
	virtual System::UnicodeString __fastcall GetListFolderContinue(System::UnicodeString NextPageToken, System::UnicodeString aFilter = System::UnicodeString()) = 0 ;
	virtual void __fastcall CreateFolder(System::UnicodeString Dir) = 0 ;
	virtual void __fastcall DeleteFileOrFolder(const System::UnicodeString Id) = 0 ;
	
public:
	__fastcall virtual TfrxBaseGoogleDriveIOTransport(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxBaseGoogleDriveIOTransport();
	__classmethod virtual Frxiotransporthelpers::TfrxBaseTransportDialogClass __fastcall TransportDialogClass();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall GetDirItems(System::Classes::TStrings* DirItems, System::UnicodeString aFilter = System::UnicodeString());
	virtual System::UnicodeString __fastcall GetAccessToken(System::UnicodeString AuthorizationCode, System::UnicodeString ClientId, System::UnicodeString ClientSecret, System::UnicodeString &ErrorMsg) = 0 ;
	
__published:
	__property System::UnicodeString ClientSecret = {read=FClientSecret, write=FClientSecret};
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxBaseGoogleDriveIOTransport() : Frxiotransporthelpers::TfrxHTTPIOTransport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define frx_GoogleDrive_RootFolderId L"root"
#define frx_GoogleDrive_MimeFolder L"application/vnd.google-apps.folder"
#define frx_GoogleDrive_CreateDir_URL L"https://www.googleapis.com/drive/v3/files"
#define frx_GoogleDrive_Delete_URL L"https://www.googleapis.com/drive/v3/files/%s"
#define frx_GoogleDrive_Download_URL L"https://www.googleapis.com/drive/v3/files/%s?alt=media"
#define frx_GoogleDrive_GetToken_URL L"https://www.googleapis.com/oauth2/v4/token"
#define frx_GoogleDrive_ListDir_URL L"https://www.googleapis.com/drive/v3/files?q='%s'+in+parent"\
	L"s%s"
#define frx_GoogleDrive_ListDirContinue_URL L"https://www.googleapis.com/drive/v3/files?q='%s'+in+parent"\
	L"s%s&pageToken=%s"
#define frx_GoogleDrive_Upload_URL L"https://www.googleapis.com/upload/drive/v3/files?uploadTyp"\
	L"e=multipart"
}	/* namespace Frxiotransportgoogledrivebase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTGOOGLEDRIVEBASE)
using namespace Frxiotransportgoogledrivebase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportgoogledrivebaseHPP
