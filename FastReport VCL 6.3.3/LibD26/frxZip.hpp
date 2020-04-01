// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxZip.pas' rev: 33.00 (Windows)

#ifndef FrxzipHPP
#define FrxzipHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Winapi.Windows.hpp>
#include <System.ZLib.hpp>
#include <frxGZip.hpp>
#include <frxUtils.hpp>
#include <frxFileUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxzip
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxZipArchive;
class DELPHICLASS TfrxZipLocalFileHeader;
class DELPHICLASS TfrxZipCentralDirectory;
class DELPHICLASS TfrxZipFileHeader;
class DELPHICLASS TfrxZipLocalFile;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxZipArchive : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::AnsiString FRootFolder;
	System::Classes::TStringList* FErrors;
	System::Classes::TStringList* FFileList;
	System::AnsiString FComment;
	System::Classes::TNotifyEvent FProgress;
	int __fastcall GetCount();
	
public:
	__fastcall TfrxZipArchive();
	__fastcall virtual ~TfrxZipArchive();
	void __fastcall Clear();
	void __fastcall AddFile(const System::AnsiString FileName);
	void __fastcall AddDir(const System::AnsiString DirName);
	void __fastcall SaveToFile(const System::AnsiString Filename);
	void __fastcall SaveToStream(System::Classes::TStream* const Stream);
	void __fastcall SaveToStreamFromList(System::Classes::TStream* const Stream, System::Classes::TStrings* FileStreams);
	__property System::Classes::TStringList* Errors = {read=FErrors};
	__property System::AnsiString Comment = {read=FComment, write=FComment};
	__property System::AnsiString RootFolder = {read=FRootFolder, write=FRootFolder};
	__property int FileCount = {read=GetCount, nodefault};
	__property System::Classes::TNotifyEvent OnProgress = {read=FProgress, write=FProgress};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxZipLocalFileHeader : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	unsigned FLocalFileHeaderSignature;
	System::Word FVersion;
	System::Word FGeneralPurpose;
	System::Word FCompressionMethod;
	unsigned FCrc32;
	System::Word FLastModFileDate;
	System::Word FLastModFileTime;
	unsigned FCompressedSize;
	unsigned FUnCompressedSize;
	System::AnsiString FExtraField;
	System::AnsiString FFileName;
	System::Word FFileNameLength;
	System::Word FExtraFieldLength;
	void __fastcall SetExtraField(const System::AnsiString Value);
	void __fastcall SetFileName(const System::AnsiString Value);
	
public:
	__fastcall TfrxZipLocalFileHeader();
	void __fastcall SaveToStream(System::Classes::TStream* const Stream);
	__property unsigned LocalFileHeaderSignature = {read=FLocalFileHeaderSignature, nodefault};
	__property System::Word Version = {read=FVersion, write=FVersion, nodefault};
	__property System::Word GeneralPurpose = {read=FGeneralPurpose, write=FGeneralPurpose, nodefault};
	__property System::Word CompressionMethod = {read=FCompressionMethod, write=FCompressionMethod, nodefault};
	__property System::Word LastModFileTime = {read=FLastModFileTime, write=FLastModFileTime, nodefault};
	__property System::Word LastModFileDate = {read=FLastModFileDate, write=FLastModFileDate, nodefault};
	__property unsigned Crc32 = {read=FCrc32, write=FCrc32, nodefault};
	__property unsigned CompressedSize = {read=FCompressedSize, write=FCompressedSize, nodefault};
	__property unsigned UnCompressedSize = {read=FUnCompressedSize, write=FUnCompressedSize, nodefault};
	__property System::Word FileNameLength = {read=FFileNameLength, write=FFileNameLength, nodefault};
	__property System::Word ExtraFieldLength = {read=FExtraFieldLength, write=FExtraFieldLength, nodefault};
	__property System::AnsiString FileName = {read=FFileName, write=SetFileName};
	__property System::AnsiString ExtraField = {read=FExtraField, write=SetExtraField};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxZipLocalFileHeader() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxZipCentralDirectory : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	unsigned FEndOfChentralDirSignature;
	System::Word FNumberOfTheDisk;
	System::Word FTotalOfEntriesCentralDirOnDisk;
	System::Word FNumberOfTheDiskStartCentralDir;
	System::Word FTotalOfEntriesCentralDir;
	unsigned FSizeOfCentralDir;
	unsigned FOffsetStartingDiskDir;
	System::AnsiString FComment;
	System::Word FCommentLength;
	void __fastcall SetComment(const System::AnsiString Value);
	
public:
	__fastcall TfrxZipCentralDirectory();
	void __fastcall SaveToStream(System::Classes::TStream* const Stream);
	__property unsigned EndOfChentralDirSignature = {read=FEndOfChentralDirSignature, nodefault};
	__property System::Word NumberOfTheDisk = {read=FNumberOfTheDisk, write=FNumberOfTheDisk, nodefault};
	__property System::Word NumberOfTheDiskStartCentralDir = {read=FNumberOfTheDiskStartCentralDir, write=FNumberOfTheDiskStartCentralDir, nodefault};
	__property System::Word TotalOfEntriesCentralDirOnDisk = {read=FTotalOfEntriesCentralDirOnDisk, write=FTotalOfEntriesCentralDirOnDisk, nodefault};
	__property System::Word TotalOfEntriesCentralDir = {read=FTotalOfEntriesCentralDir, write=FTotalOfEntriesCentralDir, nodefault};
	__property unsigned SizeOfCentralDir = {read=FSizeOfCentralDir, write=FSizeOfCentralDir, nodefault};
	__property unsigned OffsetStartingDiskDir = {read=FOffsetStartingDiskDir, write=FOffsetStartingDiskDir, nodefault};
	__property System::Word CommentLength = {read=FCommentLength, write=FCommentLength, nodefault};
	__property System::AnsiString Comment = {read=FComment, write=SetComment};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxZipCentralDirectory() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxZipFileHeader : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	unsigned FCentralFileHeaderSignature;
	unsigned FRelativeOffsetLocalHeader;
	unsigned FUnCompressedSize;
	unsigned FCompressedSize;
	unsigned FCrc32;
	unsigned FExternalFileAttribute;
	System::AnsiString FExtraField;
	System::AnsiString FFileComment;
	System::AnsiString FFileName;
	System::Word FCompressionMethod;
	System::Word FDiskNumberStart;
	System::Word FLastModFileDate;
	System::Word FLastModFileTime;
	System::Word FVersionMadeBy;
	System::Word FGeneralPurpose;
	System::Word FFileNameLength;
	System::Word FInternalFileAttribute;
	System::Word FExtraFieldLength;
	System::Word FVersionNeeded;
	System::Word FFileCommentLength;
	void __fastcall SetExtraField(const System::AnsiString Value);
	void __fastcall SetFileComment(const System::AnsiString Value);
	void __fastcall SetFileName(const System::AnsiString Value);
	
public:
	__fastcall TfrxZipFileHeader();
	void __fastcall SaveToStream(System::Classes::TStream* const Stream);
	__property unsigned CentralFileHeaderSignature = {read=FCentralFileHeaderSignature, nodefault};
	__property System::Word VersionMadeBy = {read=FVersionMadeBy, nodefault};
	__property System::Word VersionNeeded = {read=FVersionNeeded, nodefault};
	__property System::Word GeneralPurpose = {read=FGeneralPurpose, write=FGeneralPurpose, nodefault};
	__property System::Word CompressionMethod = {read=FCompressionMethod, write=FCompressionMethod, nodefault};
	__property System::Word LastModFileTime = {read=FLastModFileTime, write=FLastModFileTime, nodefault};
	__property System::Word LastModFileDate = {read=FLastModFileDate, write=FLastModFileDate, nodefault};
	__property unsigned Crc32 = {read=FCrc32, write=FCrc32, nodefault};
	__property unsigned CompressedSize = {read=FCompressedSize, write=FCompressedSize, nodefault};
	__property unsigned UnCompressedSize = {read=FUnCompressedSize, write=FUnCompressedSize, nodefault};
	__property System::Word FileNameLength = {read=FFileNameLength, write=FFileNameLength, nodefault};
	__property System::Word ExtraFieldLength = {read=FExtraFieldLength, write=FExtraFieldLength, nodefault};
	__property System::Word FileCommentLength = {read=FFileCommentLength, write=FFileCommentLength, nodefault};
	__property System::Word DiskNumberStart = {read=FDiskNumberStart, write=FDiskNumberStart, nodefault};
	__property System::Word InternalFileAttribute = {read=FInternalFileAttribute, write=FInternalFileAttribute, nodefault};
	__property unsigned ExternalFileAttribute = {read=FExternalFileAttribute, write=FExternalFileAttribute, nodefault};
	__property unsigned RelativeOffsetLocalHeader = {read=FRelativeOffsetLocalHeader, write=FRelativeOffsetLocalHeader, nodefault};
	__property System::AnsiString FileName = {read=FFileName, write=SetFileName};
	__property System::AnsiString ExtraField = {read=FExtraField, write=SetExtraField};
	__property System::AnsiString FileComment = {read=FFileComment, write=SetFileComment};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxZipFileHeader() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxZipLocalFile : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TfrxZipLocalFileHeader* FLocalFileHeader;
	System::Classes::TMemoryStream* FFileData;
	unsigned FOffset;
	
public:
	__fastcall TfrxZipLocalFile();
	__fastcall virtual ~TfrxZipLocalFile();
	void __fastcall SaveToStream(System::Classes::TStream* const Stream);
	__property TfrxZipLocalFileHeader* LocalFileHeader = {read=FLocalFileHeader};
	__property System::Classes::TMemoryStream* FileData = {read=FFileData, write=FFileData};
	__property unsigned Offset = {read=FOffset, write=FOffset, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxzip */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXZIP)
using namespace Frxzip;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxzipHPP
