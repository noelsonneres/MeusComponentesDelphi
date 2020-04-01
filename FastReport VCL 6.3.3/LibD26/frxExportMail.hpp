// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportMail.pas' rev: 33.00 (Windows)

#ifndef FrxexportmailHPP
#define FrxexportmailHPP

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
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <frxClass.hpp>
#include <System.IniFiles.hpp>
#include <Vcl.ComCtrls.hpp>
#include <frxSMTP.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportmail
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxMailExportDialog;
class DELPHICLASS TfrxMailExport;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TMailTransport : unsigned char { SMTP, MAPI, MSOutlook };

enum DECLSPEC_DENUM TSMTPStartCommand : unsigned char { EHLO, HELO };

typedef System::UnicodeString __fastcall (__closure *TfrxOnSendMailEvent)(const System::UnicodeString Server, const int Port, const System::UnicodeString UserField, const System::UnicodeString PasswordField, System::WideString FromField, System::WideString ToField, System::WideString SubjectField, System::WideString CompanyField, System::WideString TextField, System::Classes::TStringList* FileNames, int Timeout, bool ConfurmReading, System::WideString MailCc, System::WideString MailBcc);

typedef void __fastcall (__closure *TfrxOnAfterSendMailEvent)(const System::UnicodeString MailResult);

class PASCALIMPLEMENTATION TfrxMailExportDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Comctrls::TPageControl* PageControl1;
	Vcl::Comctrls::TTabSheet* ExportSheet;
	Vcl::Stdctrls::TGroupBox* MessageGroup;
	Vcl::Stdctrls::TLabel* AddressLB;
	Vcl::Stdctrls::TLabel* SubjectLB;
	Vcl::Stdctrls::TLabel* MessageLB;
	Vcl::Stdctrls::TMemo* MessageM;
	Vcl::Stdctrls::TGroupBox* AttachGroup;
	Vcl::Stdctrls::TComboBox* ExportsCombo;
	Vcl::Stdctrls::TLabel* FormatLB;
	Vcl::Stdctrls::TCheckBox* SettingCB;
	Vcl::Comctrls::TTabSheet* AccountSheet;
	Vcl::Stdctrls::TGroupBox* MailGroup;
	Vcl::Stdctrls::TCheckBox* RememberCB;
	Vcl::Stdctrls::TGroupBox* AccountGroup;
	Vcl::Stdctrls::TEdit* FromNameE;
	Vcl::Stdctrls::TLabel* FromNameLB;
	Vcl::Stdctrls::TEdit* FromAddrE;
	Vcl::Stdctrls::TLabel* FromAddrLB;
	Vcl::Stdctrls::TLabel* OrgLB;
	Vcl::Stdctrls::TEdit* OrgE;
	Vcl::Stdctrls::TLabel* SignatureLB;
	Vcl::Stdctrls::TMemo* SignatureM;
	Vcl::Stdctrls::TLabel* HostLB;
	Vcl::Stdctrls::TEdit* HostE;
	Vcl::Stdctrls::TEdit* PortE;
	Vcl::Stdctrls::TLabel* PortLB;
	Vcl::Stdctrls::TLabel* LoginLB;
	Vcl::Stdctrls::TEdit* LoginE;
	Vcl::Stdctrls::TEdit* PasswordE;
	Vcl::Stdctrls::TLabel* PasswordLB;
	Vcl::Stdctrls::TButton* SignBuildBtn;
	Vcl::Stdctrls::TComboBox* AddressE;
	Vcl::Stdctrls::TComboBox* SubjectE;
	Vcl::Stdctrls::TLabel* ReqLB;
	Vcl::Stdctrls::TLabel* TimeoutLB;
	Vcl::Stdctrls::TEdit* TimeoutE;
	Vcl::Stdctrls::TCheckBox* ReadingCB;
	Vcl::Stdctrls::TRadioButton* Radio_SMTP;
	Vcl::Stdctrls::TRadioButton* Radio_MAPI;
	Vcl::Stdctrls::TRadioButton* Radio_Outlook;
	Vcl::Stdctrls::TLabel* MailTransportLB;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall SignBuildBtnClick(System::TObject* Sender);
	void __fastcall OkBClick(System::TObject* Sender);
	void __fastcall PortEKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall PageControl1Change(System::TObject* Sender);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxMailExportDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxMailExportDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxMailExportDialog() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxMailExportDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfrxMailExport : public Frxclass::TfrxCustomExportFilter
{
	typedef Frxclass::TfrxCustomExportFilter inherited;
	
private:
	Frxclass::TfrxCustomExportFilter* FExportFilter;
	System::UnicodeString FAddress;
	System::UnicodeString FSubject;
	System::Classes::TStrings* FMessage;
	bool FShowExportDialog;
	bool FOldSlaveStatus;
	System::UnicodeString FFromName;
	System::UnicodeString FFromMail;
	System::UnicodeString FFromCompany;
	System::Classes::TStrings* FSignature;
	System::UnicodeString FSmtpHost;
	int FSmtpPort;
	System::UnicodeString FLogin;
	System::UnicodeString FPassword;
	bool FUseIniFile;
	System::UnicodeString FLogFile;
	int FTimeOut;
	bool FConfurmReading;
	TMailTransport FUseMAPI;
	TSMTPStartCommand FSMTPStartCommand;
	TfrxOnSendMailEvent FOnSendMail;
	TfrxOnAfterSendMailEvent FOnAfterSendMail;
	System::UnicodeString FMailCc;
	System::UnicodeString FMailBcc;
	int FMAPISendFlag;
	void __fastcall SetMessage(System::Classes::TStrings* const Value);
	void __fastcall SetSignature(System::Classes::TStrings* const Value);
	
protected:
	__property DefaultPath = {default=0};
	__property Stream;
	__property CurPage;
	__property PageNumbers = {default=0};
	__property FileName = {default=0};
	__property UseFileCache;
	__property ExportNotPrintable = {default=0};
	
public:
	__fastcall virtual TfrxMailExport(System::Classes::TComponent* AOwner);
	virtual Frxclass::TfrxCustomIOTransport* __fastcall CreateDefaultIOTransport();
	__fastcall virtual ~TfrxMailExport();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual System::Uitypes::TModalResult __fastcall ShowModal();
	virtual bool __fastcall Start();
	System::UnicodeString __fastcall Mail(const System::UnicodeString Server, const int Port, const System::UnicodeString UserField, const System::UnicodeString PasswordField, System::WideString FromField, System::WideString ToField, System::WideString SubjectField, System::WideString CompanyField, System::WideString TextField, System::Classes::TStringList* FileNames, int Timeout = 0x3c, bool ConfurmReading = false, System::WideString MailCc = System::WideString(), System::WideString MailBcc = System::WideString());
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	__property Frxclass::TfrxCustomExportFilter* ExportFilter = {read=FExportFilter, write=FExportFilter};
	__property TSMTPStartCommand SMTPStartCommand = {read=FSMTPStartCommand, write=FSMTPStartCommand, nodefault};
	
__published:
	__property System::UnicodeString Address = {read=FAddress, write=FAddress};
	__property System::UnicodeString Subject = {read=FSubject, write=FSubject};
	__property System::Classes::TStrings* Lines = {read=FMessage, write=SetMessage};
	__property bool ShowExportDialog = {read=FShowExportDialog, write=FShowExportDialog, nodefault};
	__property System::UnicodeString FromMail = {read=FFromMail, write=FFromMail};
	__property System::UnicodeString FromName = {read=FFromName, write=FFromName};
	__property System::UnicodeString FromCompany = {read=FFromCompany, write=FFromCompany};
	__property System::Classes::TStrings* Signature = {read=FSignature, write=SetSignature};
	__property System::UnicodeString SmtpHost = {read=FSmtpHost, write=FSmtpHost};
	__property int SmtpPort = {read=FSmtpPort, write=FSmtpPort, nodefault};
	__property System::UnicodeString Login = {read=FLogin, write=FLogin};
	__property System::UnicodeString Password = {read=FPassword, write=FPassword};
	__property bool UseIniFile = {read=FUseIniFile, write=FUseIniFile, nodefault};
	__property System::UnicodeString LogFile = {read=FLogFile, write=FLogFile};
	__property int TimeOut = {read=FTimeOut, write=FTimeOut, nodefault};
	__property bool ConfurmReading = {read=FConfurmReading, write=FConfurmReading, nodefault};
	__property TfrxOnSendMailEvent OnSendMail = {read=FOnSendMail, write=FOnSendMail};
	__property TfrxOnAfterSendMailEvent OnAfterSendMail = {read=FOnAfterSendMail, write=FOnAfterSendMail};
	__property TMailTransport UseMAPI = {read=FUseMAPI, write=FUseMAPI, nodefault};
	__property System::UnicodeString MailCc = {read=FMailCc, write=FMailCc};
	__property System::UnicodeString MailBcc = {read=FMailBcc, write=FMailBcc};
	__property int MAPISendFlag = {read=FMAPISendFlag, write=FMAPISendFlag, nodefault};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxMailExport() : Frxclass::TfrxCustomExportFilter() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportmail */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTMAIL)
using namespace Frxexportmail;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportmailHPP
