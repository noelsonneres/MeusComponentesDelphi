// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxTrueTypeFont.pas' rev: 33.00 (Windows)

#ifndef FrxtruetypefontHPP
#define FrxtruetypefontHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <TTFHelpers.hpp>
#include <frxCmapTableClass.hpp>
#include <frxFontHeaderClass.hpp>
#include <frxGlyphTableClass.hpp>
#include <frxGlyphSubstitutionClass.hpp>
#include <frxHorizontalHeaderClass.hpp>
#include <frxHorizontalMetrixClass.hpp>
#include <frxIndexToLocationClass.hpp>
#include <frxKerningTableClass.hpp>
#include <frxNameTableClass.hpp>
#include <frxPostScriptClass.hpp>
#include <frxMaximumProfileClass.hpp>
#include <frxOS2WindowsMetricsClass.hpp>
#include <System.Classes.hpp>
#include <frxTrueTypeTable.hpp>
#include <frxPreProgramClass.hpp>
#include <Winapi.Windows.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxtruetypefont
{
//-- forward type declarations -----------------------------------------------
struct TTableSortHelper;
struct TableDirectory;
class DELPHICLASS TrueTypeFont;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM ChecksumFaultAction : unsigned char { ChecksumFaultAction_IgnoreChecksum, ChecksumFaultAction_ThrowException, ChecksumFaultAction_Warn };

enum DECLSPEC_DENUM TablesID : unsigned int { TablesID_CMAP = 1885433187, TablesID_ControlValueTable = 544503395, TablesID_DigitalSignature = 1195987780, TablesID_EmbedBitmapLocation = 1129071173, TablesID_EmbededBitmapData = 1413759557, TablesID_FontHeader = 1684104552, TablesID_FontProgram = 1835495526, TablesID_Glyph = 1719233639, TablesID_GlyphDefinition = 1178944583, TablesID_GlyphPosition = 1397706823, TablesID_GlyphSubstitution = 1112888135, TablesID_GridFittingAndScanConversion = 1886609767, TablesID_HorizontakDeviceMetrix = 2020435048, TablesID_HorizontalHeader = 1634035816, TablesID_HorizontalMetrix = 2020896104, TablesID_IndexToLocation = 1633906540, TablesID_Justification = 1179931466, TablesID_KerningTable = 1852990827, TablesID_LinearThreshold = 1213420620, 
	TablesID_MaximumProfile = 1886937453, TablesID_Name = 1701667182, TablesID_OS2Table = 841962319, TablesID_PCL5Table = 1414284112, TablesID_Postscript = 1953722224, TablesID_PreProgram = 1885696624, TablesID_VerticalDeviceMetrix = 1481458774, TablesID_VerticalMetrix = 2020896118, TablesID_VertivalMetrixHeader = 1634035830 };

typedef System::DynamicArray<System::Byte> TByteArray;

typedef System::Classes::TList TTagList;

struct DECLSPEC_DRECORD TTableSortHelper
{
public:
	unsigned Offset;
	unsigned TAG;
};


typedef TTableSortHelper *PTableSortHelper;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TableDirectory
{
public:
	unsigned sfntversion;
	System::Word numTables;
	System::Word searchRange;
	System::Word entrySelector;
	System::Word rangeShift;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TrueTypeFont : public Ttfhelpers::TTF_Helpers
{
	typedef Ttfhelpers::TTF_Helpers inherited;
	
private:
	void *beginfile_ptr;
	Frxcmaptableclass::CmapTableClass* cmap_table;
	TableDirectory dir;
	Frxfontheaderclass::FontHeaderClass* font_header;
	Frxglyphtableclass::GlyphTableClass* glyph_table;
	Frxglyphsubstitutionclass::GlyphSubstitutionClass* gsub_table;
	Frxhorizontalheaderclass::HorizontalHeaderClass* horizontal_header;
	Frxhorizontalmetrixclass::HorizontalMetrixClass* horizontal_metrix_table;
	Frxindextolocationclass::IndexToLocationClass* index_to_location;
	Frxkerningtableclass::KerningTableClass* kerning_table;
	Frxnametableclass::NameTableClass* name_table;
	Frxpostscriptclass::PostScriptClass* postscript;
	Frxmaximumprofileclass::MaximumProfileClass* profile;
	void *selector_ptr;
	Frxos2windowsmetricsclass::OS2WindowsMetricsClass* windows_metrix;
	Frxpreprogramclass::PreProgramClass* preprogram_table;
	System::Classes::TList* ListOfTables;
	System::Classes::TList* ListOfUsedGlyphs;
	System::Classes::TList* GlyphWidths;
	System::Classes::TList* Indices;
	System::UnicodeString FSubstitutionName;
	unsigned __fastcall CalcTableChecksum(void * font, Frxtruetypetable::TrueTypeTable* entry, bool debug);
	void __fastcall CalculateFontChecksum(void * start_offset, unsigned font_length);
	void __fastcall ChangeEndian();
	void __fastcall CheckTablesChecksum();
	System::Classes::TList* __fastcall GetTablesOrder();
	void __fastcall LoadCoreTables();
	void __fastcall LoadDescriptors(System::Classes::TList* skip_array);
	void __fastcall ReorderGlyphTable(void * position, bool uniscribe);
	void __fastcall SaveDescriptors(void * position);
	void __fastcall set_UsedGlyphs(System::Classes::TList* dict);
	unsigned __fastcall get_GlyphWidth(int glph);
	unsigned __fastcall get_Glyph(int idx);
	System::WideString __fastcall GetFamilyName();
	
public:
	ChecksumFaultAction checksum_action;
	__fastcall TrueTypeFont(void * bgn, void * font, ChecksumFaultAction action);
	__fastcall virtual ~TrueTypeFont();
	void __fastcall AddCharacterToKeepList(System::WideChar ch);
	void __fastcall ParseSingleGlyph(System::Word idx);
	void __fastcall BuildGlyphIndexList(System::Classes::TList* used_glyphs, bool uniscribe, bool decompose, bool collate, bool use_kerning);
	TByteArray __fastcall PackFont(Frxfontheaderclass::FontType translate_to, bool uniscribe);
	void __fastcall PrepareFont(System::Classes::TList* skip_list);
	__property Frxnametableclass::NameTableClass* Names = {read=name_table};
	__property System::Classes::TList* UsedGlyphs = {write=set_UsedGlyphs};
	__property System::Classes::TList* Widths = {read=GlyphWidths};
	__property unsigned Width[int glph] = {read=get_GlyphWidth};
	__property unsigned Glyph[int idx] = {read=get_Glyph};
	__property System::UnicodeString SubstitutionName = {read=FSubstitutionName, write=FSubstitutionName};
	__property System::WideString FamilyName = {read=GetFamilyName};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall AddIgnoreChecksum(System::UnicodeString FamilyName);
extern DELPHI_PACKAGE void __fastcall DeleteIgnoreChecksum(System::UnicodeString FamilyName);
}	/* namespace Frxtruetypefont */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXTRUETYPEFONT)
using namespace Frxtruetypefont;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxtruetypefontHPP
