unit uDWConstsData;

{$I uRESTDW.inc}

interface

Uses
 SysUtils,  Classes,  DB, uDWDataset, uDWConstsCharset, FMTBcd, Variants
 {$IFDEF FPC}
  {$IFDEF LAZDRIVER}
   , memds
  {$ENDIF}
  {$IFDEF UNIDACMEM}
  , DADump, UniDump, VirtualTable, MemDS
  {$ENDIF}
  ;
 {$ELSE}
   {$IFDEF CLIENTDATASET}
    ,  DBClient
   {$ENDIF}
   {$IFDEF UNIDACMEM}
   , DADump, UniDump, VirtualTable, MemDS
   {$ENDIF}
   {$IFDEF RESTKBMMEMTABLE}
    , kbmmemtable
   {$ENDIF}
   {$IF CompilerVersion > 22} // Delphi 2010 pra cima
    {$IFDEF RESTFDMEMTABLE}
     , FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
     FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
     FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageBin
    {$ENDIF}
   {$IFEND};
 {$ENDIF}

{$IFNDEF FPC}
 {$IFDEF OLDINDY}
 Type
  TIdSSLVersions = set of TIdSSLVersion;
 {$ENDIF}
{$ENDIF}

Type
 {$IFDEF FPC}
  DWInteger       = Longint;
  DWInt64         = Int64;
  DWFloat         = Real;
  DWFieldTypeSize = Longint;
 {$ELSE}
  DWInteger       = Integer;
  DWInt64         = Int64;
  DWFloat         = Real;
  DWFieldTypeSize = Integer;
 {$ENDIF}
 {$IFNDEF FPC}
  {$IF (CompilerVersion >= 26) And (CompilerVersion <= 30)}
   {$IF Defined(HAS_FMX)}
    DWString     = String;
    DWWideString = String;
   {$ELSE}
    DWString     = Utf8String;
    DWWideString = Utf8String;
   {$IFEND}
  {$ELSE}
   {$IF Defined(HAS_FMX)}
    DWString     = Utf8String;
    DWWideString = Utf8String;
   {$ELSE}
    DWString     = AnsiString;
    DWWideString = WideString;
   {$IFEND}
  {$IFEND}
 {$ELSE}
  DWString     = AnsiString;
  DWWideString = WideString;
 {$ENDIF}

Type
 TDWParamsHeader = Packed Record
  VersionNumber,
  RecordCount,
  ParamsCount    : DWInteger; //new for ver15
  DataSize       : DWInt64; //new for ver15
End;

Type
 TDWAboutInfo    = (DWAbout);
 TMassiveDataset = Class
End;

Type
 TOnWriterProcess  = Procedure (DataSet : TDataSet; RecNo, RecordCount : Integer; Var AbortProcess : Boolean) Of Object;

Type
 TResultErro = Record
  Status,
  MessageText: String;
End;

Type
 TArguments = Array Of String;

Type
 TStreamType = (stMetaData, stAll);

Type
 TPrivateClass = Class
 End;
 {$IFDEF FPC}
  {$IFDEF LAZDRIVER}
  TRESTDWClientSQLBase   = Class(TMemDataset)                   //Classe com as funcionalidades de um DBQuery
  {$ENDIF}
  {$IFDEF UNIDACMEM}
  TRESTDWClientSQLBase   = Class(TVirtualTable)
  {$ENDIF}
  {$IFDEF DWMEMTABLE}
  TRESTDWClientSQLBase   = Class(TDWMemtable)                 //Classe com as funcionalidades de um DBQuery
  {$ENDIF}
 {$ELSE}
  {$IFDEF CLIENTDATASET}
  TRESTDWClientSQLBase   = Class(TClientDataSet)                 //Classe com as funcionalidades de um DBQuery
  {$ENDIF}
  {$IFDEF RESTKBMMEMTABLE}
  TRESTDWClientSQLBase   = Class(TKbmMemtable)                 //Classe com as funcionalidades de um DBQuery
  {$ENDIF}
  {$IFDEF UNIDACMEM}
  TRESTDWClientSQLBase   = Class(TVirtualTable)
  {$ENDIF}
  {$IFDEF RESTFDMEMTABLE}
  TRESTDWClientSQLBase   = Class(TFDMemtable)                 //Classe com as funcionalidades de um DBQuery
  {$ENDIF}
  {$IFDEF DWMEMTABLE}
  TRESTDWClientSQLBase   = Class(TDWMemtable)                 //Classe com as funcionalidades de um DBQuery
  {$ENDIF}
 {$ENDIF}
 Private
  fsAbout: TDWAboutInfo;
  vComponentTag,
  vSequenceField,
  vSequenceName : String;
  vLoadFromStream,
  vBinaryCompatibleMode,
  vOnLoadStream,
  vBinaryLoadRequest : Boolean;
  vOnWriterProcess                   : TOnWriterProcess;
  {$IFDEF FPC}
  vDatabaseCharSet                   : TDatabaseCharSet;
  Procedure SetDatabaseCharSet(Value : TDatabaseCharSet);
  Function  GetDatabaseCharSet : TDatabaseCharSet;
  {$ENDIF}
  Function  OnEditingState : Boolean;
  Class Procedure SaveRecordToStream(Dataset : TDataset;
                                     Stream  : TStream);
  Class Procedure SaveToStreamFromDataset(Dataset           : TDataset;
                                          Const StreamValue : TMemoryStream);
  Procedure LoadFromStreamToDataset      (Const StreamValue : TMemoryStream;
                                          DataType          : TStreamType = stAll);
 Public
  Procedure   BaseOpen;
  Procedure   BaseClose;
  Procedure   ForceInternalCalc;
  Procedure   SetComponentTAG;
  Procedure   SaveToStream     (Var Value   : TMemoryStream);Overload;
  Class Procedure SaveToStream (Dataset     : TDataset;
                                Var Value   : TMemoryStream);Overload;
  Procedure   LoadFromStream   (Value       : TMemoryStream;
                                DataType    : TStreamType = stAll);
  Procedure   SetInDesignEvents(Const Value : Boolean);Virtual;Abstract;
  Procedure   SetInBlockEvents (Const Value : Boolean);Virtual;Abstract;
  Procedure   SetInitDataset   (Const Value : Boolean);Virtual;Abstract;
  Procedure   PrepareDetailsNew;                       Virtual;Abstract;
  Procedure   PrepareDetails(ActiveMode : Boolean);    Virtual;Abstract;
  Constructor Create(AOwner: TComponent);Override;
  Property    InLoadFromStream  : Boolean       Read vLoadFromStream;
  Property    BinaryLoadRequest : Boolean       Read vBinaryLoadRequest;
  Property    OnLoadStream      : Boolean       Read vOnLoadStream       Write vOnLoadStream;
  Property    Componenttag      : String        Read vComponentTag;
  {$IFDEF FPC}
  Property DatabaseCharSet      : TDatabaseCharSet Read GetDatabaseCharSet Write SetDatabaseCharSet;
  {$ENDIF}
 Published
  Property BinaryCompatibleMode : Boolean          Read vBinaryCompatibleMode  Write vBinaryCompatibleMode;
  Property    SequenceName      : String           Read vSequenceName          Write vSequenceName;
  Property    SequenceField     : String           Read vSequenceField         Write vSequenceField;
  Property    OnWriterProcess   : TOnWriterProcess Read vOnWriterProcess       Write vOnWriterProcess;
  Property    AboutInfo         : TDWAboutInfo     Read fsAbout                Write fsAbout Stored False;
End;

Type
 TRESTDWDatasetArray = Array of TRESTDWClientSQLBase;

Type
 TSendEvent       = (seGET,       sePOST,
                     sePUT,       seDELETE,
                     sePatch);
 TTypeRequest     = (trHttp,      trHttps);
 TObjectDirection = (odIN, odOUT, odINOUT);
 TDatasetEvents   = Procedure (DataSet: TDataSet) Of Object;

implementation

uses uDWConsts, uDWJSONTools, uRESTDWPoolerDB;


Function RPos(const Substr, S: string): Integer;
Var
 I, X, Len: Integer;
Begin
 Len := Length(SubStr);
 I := Length(S) - Len + 1;
 If (I <= 0) Or (Len = 0) Then
  Begin
   RPos := 0;
   Exit;
  End
 Else
  Begin
   While I > 0 Do
    Begin
     If S[I] = SubStr[1] Then
      Begin
       X := 1;
       While (X < Len) And (S[I + X] = SubStr[X + 1]) Do
        Inc(X);
       If (X = Len) Then
        Begin
         RPos := I;
         exit;
        End;
      End;
     Dec(I);
    End;
   RPos := 0;
  End;
End;

Procedure TRESTDWClientSQLBase.BaseClose;
Begin
  {$IFDEF FPC}
   {$IFDEF DWMEMTABLE}
    TDWMemtable(Self).Close;
   {$ENDIF}
   {$IFDEF UNIDACMEM}
    TVirtualTable(Self).Close;
   {$ENDIF}
   {$IFDEF LAZDRIVER}
    TMemDataset(Self).Close;
   {$ENDIF}
  {$ELSE}
  {$IFDEF CLIENTDATASET}
   TClientDataset(Self).Close;
  {$ENDIF}
  {$IFDEF RESJEDI}
   TJvMemoryData(Self).Close;
  {$ENDIF}
  {$IFDEF RESTKBMMEMTABLE}
   Tkbmmemtable(Self).Close;
  {$ENDIF}
  {$IFDEF RESTFDMEMTABLE}
   TFDmemtable(Self).Close;
  {$ENDIF}
  {$IFDEF DWMEMTABLE}
   TDWMemtable(Self).Close;
  {$ENDIF}
  {$IFDEF UNIDACMEM}
   TVirtualTable(Self).Close;
  {$ENDIF}
  {$ENDIF}
End;

Procedure TRESTDWClientSQLBase.BaseOpen;
Begin
  {$IFDEF FPC}
   {$IFDEF DWMEMTABLE}
    TDWMemtable(Self).Open;
   {$ENDIF}
   {$IFDEF UNIDACMEM}
    TVirtualTable(Self).Open;
   {$ENDIF}
   {$IFDEF LAZDRIVER}
    TMemDataset(Self).Open;
   {$ENDIF}
  {$ELSE}
  {$IFDEF CLIENTDATASET}
   TClientDataset(Self).Open;
  {$ENDIF}
  {$IFDEF RESJEDI}
   TJvMemoryData(Self).Open;
  {$ENDIF}
  {$IFDEF RESTKBMMEMTABLE}
   TKbmmemtable(Self).Open;
  {$ENDIF}
  {$IFDEF RESTFDMEMTABLE}
   TFDmemtable(Self).Open;
  {$ENDIF}
  {$IFDEF DWMEMTABLE}
   TDWMemtable(Self).Open;
  {$ENDIF}
  {$IFDEF UNIDACMEM}
   TVirtualTable(Self).Open;
  {$ENDIF}
  {$ENDIF}
End;

Constructor TRESTDWClientSQLBase.Create(AOwner: TComponent);
Begin
 Inherited;
 vOnWriterProcess      := Nil;
 vBinaryCompatibleMode := False;
 vLoadFromStream       := False;
 {$IFDEF DWMEMTABLE}
  vBinaryCompatibleMode := True;
  {$IFNDEF FPC}
   {$IF CompilerVersion > 21}
    Encoding            := esUtf8;
   {$ELSE}
    Encoding            := esAscii;
   {$IFEND}
  {$ELSE}
   Encoding             := esUtf8;
  {$ENDIF}
 {$ENDIF}
End;

{$IFDEF FPC}
Function  TRESTDWClientSQLBase.GetDatabaseCharSet : TDatabaseCharSet;
Begin
 Result := vDatabaseCharSet;
End;

Procedure TRESTDWClientSQLBase.SetDatabaseCharSet(Value : TDatabaseCharSet);
Begin
 vDatabaseCharSet := Value;
 {$IFDEF DWMEMTABLE}
  TDWMemtable(Self).DatabaseCharSet := Value; //Classe com as funcionalidades de um DBQuery
 {$ENDIF}
End;
{$ENDIF}

Function TRESTDWClientSQLBase.OnEditingState: Boolean;
Begin
 Result := (State in [dsEdit, dsInsert]);
 If Result then
  Edit;
End;

Procedure TRESTDWClientSQLBase.SaveToStream (Var Value   : TMemoryStream);
Begin
 If Not Assigned(Value) Then
  Value := TMemoryStream.Create;
 TRESTDWClientSQLBase.SaveToStreamFromDataset(Self, Value);
 Value.Position := 0;
End;

Class Procedure TRESTDWClientSQLBase.SaveToStream(Dataset    : TDataset;
                                                  Var Value  : TMemoryStream);
Begin
 If Not Assigned(Value) Then
  Value := TMemoryStream.Create;
 TRESTDWClientSQLBase.SaveToStreamFromDataset(Dataset, Value);
 Value.Position := 0;
End;

Class Procedure TRESTDWClientSQLBase.SaveRecordToStream(Dataset : TDataset;
                                                        Stream  : TStream);
Var
 X, I    : Integer;
 J, L    : DWInt64;
 S       : DWString;
 E       : Extended;
 F       : DWFloat;
 Bool    : Boolean;
 B       : TBcd;
 P       : TMemoryStream;
 T       : DWFieldTypeSize;
 D       : TDateTime;
Begin
 P := Nil;
 For I := 0 to Dataset.FieldCount - 1 do
  Begin
   If fkCalculated = Dataset.Fields[I].FieldKind Then Continue;
   T := DWFieldTypeSize(Dataset.Fields[I].DataType);
   Stream.Write(T, Sizeof(DWFieldTypeSize));
   Case TFieldType(T) Of
      ftMemo,
      {$IFNDEF FPC}{$IF CompilerVersion > 21}ftWideMemo,{$IFEND}{$ENDIF}
      ftFmtMemo,
      ftFixedChar,
      ftWideString,
      ftString : Begin
                  {$IFDEF COMPILER14}
                  {$WARNINGS OFF}
                   S := UnicodeString(Dataset.Fields[I].AsString);
                  {$WARNINGS ON}
                  {$ELSE}
                   {$IFNDEF FPC}
                    {$IF Defined(HAS_FMX)}
                     S := Dataset.Fields[I].AsString;
                    {$ELSE}
                     S := Dataset.Fields[I].AsString;
                    {$IFEND}
                   {$ELSE}
                    S := Dataset.Fields[I].AsString;
                   {$ENDIF}
                  {$ENDIF}
                  If (Length(S) > Dataset.Fields[I].Size) And
                     (Dataset.Fields[I].DataType In [ftString, ftFixedChar]) Then
                   SetLength(S, Dataset.Fields[I].Size);
                  S := Utf8Encode(S);
                  L := Length(S);
                  Stream.Write(L, Sizeof(L));
                  {$IFNDEF FPC}
                  If L <> 0 Then Stream.Write(S[InitStrPos], L);
                  {$ELSE}
                  If L <> 0 Then Stream.Write(S[1], L);
                  {$ENDIF}
                 End;
      {$IFDEF COMPILER12_UP}
      ftByte,
      ftShortint : Begin
                    J := Dataset.Fields[I].AsInteger;
                    Stream.Write(J, Sizeof(DWInteger));
                   End;
      {$ENDIF}
      ftSmallint : Begin
                    If Not(Dataset.Fields[I].IsNull) Then
                     Begin
                      Bool := False;
                      Stream.Write(Bool, Sizeof(Byte));
                      X := Dataset.Fields[I].AsInteger;
                      Stream.Write(X, Sizeof(DWInteger));
                     End
                    Else
                     Begin
                      Bool := True;
                      Stream.Write(Bool, Sizeof(Byte));
                     End;
                   End;
      ftWord,
      ftInteger,
      ftAutoInc :  Begin
                    If Not(Dataset.Fields[I].IsNull) Then
                     Begin
                      Bool := False;
                      Stream.Write(Bool, Sizeof(Byte));
                      J := Dataset.Fields[I].AsInteger;
                      Stream.Write(J, Sizeof(DWInteger));
                     End
                    Else
                     Begin
                      Bool := True;
                      Stream.Write(Bool, Sizeof(Byte));
                     End;
                   End;
      ftFloat,
      ftFMTBcd,
      ftCurrency,
      {$IFNDEF FPC}{$IF CompilerVersion >= 21}ftExtended, ftSingle, {$IFEND}{$ENDIF}
      ftBCD     : Begin
                    If Not(Dataset.Fields[I].IsNull) Then
                     Begin
                      Bool := False;
                      Stream.Write(Bool, Sizeof(Byte));
                      F := Dataset.Fields[I].AsFloat;
                      Stream.Write(F, Sizeof(DWFloat));
                     End
                    Else
                     Begin
                      Bool := True;
                      Stream.Write(Bool, Sizeof(Byte));
                     End;
                  End;
      ftDate,
      ftTime,
      ftDateTime,
      {$IFNDEF FPC}{$IF CompilerVersion >= 21}ftTimeStampOffset, {$IFEND}{$ENDIF}
      ftTimeStamp : Begin
                     If Not Dataset.Fields[I].IsNull Then
                      J := DateTimeToUnix(Dataset.Fields[I].AsDateTime)
                     Else
                      J := 0;
                     Stream.Write(J, Sizeof(DWInt64));
                    End;
      {$IFNDEF FPC}{$IF CompilerVersion >= 21}ftLongWord,{$IFEND}{$ENDIF}
      ftLargeint : Begin
                    If Not(Dataset.Fields[I].IsNull) Then
                     Begin
                      Bool := False;
                      Stream.Write(Bool, Sizeof(Byte));
                      {$IFNDEF FPC}
                       {$IF CompilerVersion > 21}
                        J := Dataset.Fields[I].AsLargeInt;
                       {$ELSE}
                        J := Dataset.Fields[I].AsInteger;
                       {$IFEND}
                      {$ELSE}
                       J := Dataset.Fields[I].AsLargeInt;
                      {$ENDIF}
                      Stream.Write(J, Sizeof(DWInt64));
                     End
                    Else
                     Begin
                      Bool := True;
                      Stream.Write(Bool, Sizeof(Byte));
                     End;
                   End;
      ftBoolean  : Begin
                    If Dataset.Fields[I].isnull Then
                     Begin
                      Bool := False;
                      Stream.Write(Bool, Sizeof(Byte));
                     End
                    Else
                     Begin
                      Bool := Dataset.Fields[I].AsBoolean;
                      Stream.Write(Bool, Sizeof(Byte));
                     End;
                   End;
      ftVariant,
      ftInterface,
      ftIDispatch,
      ftGuid  :  Begin
                  {$IFDEF COMPILER14}
                  {$WARNINGS OFF}
                   S := UnicodeString(Dataset.Fields[I].AsString);
                  {$WARNINGS ON}
                  {$ELSE}
                   {$IFNDEF FPC}
                    {$IF Defined(HAS_FMX)}
                     S := Dataset.Fields[I].AsString;
                    {$ELSE}
                     S := Dataset.Fields[I].AsString;
                    {$IFEND}
                   {$ELSE}
                    S := Dataset.Fields[I].AsString;
                   {$ENDIF}
                  {$ENDIF}
                  If (Length(S) > Dataset.Fields[I].Size) And
                     (Dataset.Fields[I].DataType In [ftString, ftFixedChar]) Then
                   SetLength(S, Dataset.Fields[I].Size);
                  S := Utf8Encode(S);
                  L := Length(S);
                  Stream.Write(L, Sizeof(L));
                  {$IFNDEF FPC}
                  If L <> 0 Then Stream.Write(S[InitStrPos], L);
                  {$ELSE}
                  If L <> 0 Then Stream.Write(S[1], L);
                  {$ENDIF}
                 End;
      ftBlob,
      {$IFNDEF FPC}{$IF CompilerVersion > 21}ftStream,{$IFEND}{$ENDIF}
      ftBytes : Begin
                 P := TMemoryStream.Create;
                 Try
                  If Not Dataset.Fields[I].isnull Then
                   TBlobField(Dataset.Fields[I]).SaveToStream(P);
                  If Assigned(P) Then
                   Begin
                    L := P.Size;
                    Stream.Write(L, Sizeof(DWInt64));
                    P.Position := 0;
                    If L <> 0 then
                     Stream.CopyFrom(P, L);
                   End
                  Else
                   Begin
                    L := 0;
                    Stream.Write(L, Sizeof(DWInt64));
                   End;
                 Finally
                  FreeAndNil(P);
                 End;
                End;
      Else
       Begin
       {$IFNDEF COMPILER11_UP}
        If Not Dataset.Fields[I].isnull Then Continue;
        Case Integer(Dataset.Fields[I].DataType) Of
         dwftLongWord : Begin
                         J := Dataset.Fields[I].AsInteger;
                         Stream.Write(J, Sizeof(DWInteger));
                        End;
         dwftExtended,
         dwftSingle   : Begin
                         If Not(Dataset.Fields[I].IsNull) Then
                          Begin
                           Bool := False;
                           Stream.Write(Bool, Sizeof(Byte));
                           F := Dataset.Fields[I].AsFloat;
                           Stream.Write(F, Sizeof(DWFloat));
                          End
                         Else
                          Begin
                           Bool := True;
                           Stream.Write(Bool, Sizeof(Byte));
                          End;
                        End;
         dwftTimeStampOffset: Begin
                              If Not Dataset.Fields[I].IsNull Then
                               J := DateTimeToUnix(Dataset.Fields[I].AsDateTime)
                              Else
                               J := 0;
                              Stream.Write(J, Sizeof(DWInt64));
                             End;
        End;
       {$ENDIF}
       End;
   End;
  End;
End;

Class Procedure TRESTDWClientSQLBase.SaveToStreamFromDataset(Dataset           : TDataset;
                                                             Const StreamValue : TMemoryStream);
Var
 ParamsHeader : TDWParamsHeader;
 {$IFNDEF FPC}
  {$if CompilerVersion < 21}
   aStream    : TMemoryStream;
  {$IFEND}
 {$ENDIF}
 I, Temp      : Integer;
 EndPos,
 StartPos     : Int64;
 {$IFNDEF FPC}
  {$IF (CompilerVersion >= 26) And (CompilerVersion <= 30)}
   {$IF Defined(HAS_FMX)}
    S, W : String;
   {$ELSE}
    S, W : Utf8String;
   {$IFEND}
  {$ELSE}
   {$IF Defined(HAS_FMX)}
    S, W : Utf8String;
   {$ELSE}
    S, W : AnsiString;
   {$IFEND}
  {$IFEND}
 {$ELSE}
  S, W   : AnsiString;
 {$ENDIF}
 {$IFDEF FPC}
 Function GetDefinitions(Dataset : TDataset) : AnsiString;
 {$ELSE}
 {$IF CompilerVersion < 25}
 Function GetDefinitions(Dataset : TDataset) : AnsiString;
 {$ELSE}
 Function GetDefinitions(Dataset : TDataset) : String;
 {$IFEND}
 {$ENDIF}
 Var
  I : Integer;
  S, S2: string;
  L : TStrings;
 Begin
  L := TStringList.Create;
  Try
   For I := 0 To Dataset.FieldCount - 1 Do
    Begin
     S := Dataset.Fields[I].FieldName + '=' + GetFieldTypeB(Dataset.Fields[I].DataType);
     If fkLookup = Dataset.Fields[I].FieldKind then
      S := S + ':lookup'
     Else If fkCalculated = Dataset.Fields[I].FieldKind then
      S := S + ':calc';
     If (Dataset.Fields[I].Size > 0) and (Dataset.Fields[I].DataType <> ftGuid) Then
      S2 := IntToStr(Dataset.Fields[I].Size)
     Else
      S2 := '';
     If Dataset.Fields[I].Required Then
      Begin
       If S2 <> '' Then
        S := S + ',' + S2 + ':nn'
       Else
        S := S + ',nn';
      End
     Else
      Begin
       If S2 <> '' Then
         S := S + ',' + S2;
      End;
     L.Add(S);
    End;
   {$IFNDEF FPC}
    {$IF Defined(HAS_FMX)}
     Result := String(L.Text);
    {$ELSE}
     Result := AnsiString(L.Text);
    {$IFEND}
   {$ELSE}
    Result := AnsiString(L.Text);
   {$ENDIF}
  Finally
   L.Free;
  End;
 End;
Begin
 Try
  If Not Dataset.Active Then
   Dataset.Active := True;
  Dataset.DisableControls;
  Dataset.First;
  {$IFNDEF FPC}
   {$if CompilerVersion < 21}
    aStream := TMemoryStream.Create;
    Try
     If Not Assigned(StreamValue) Then
      Exit;
     //Write init Header
     StartPos := StreamValue.Position;
     With ParamsHeader Do
      Begin
       VersionNumber := DwParamsHeaderVersion;
       DataSize      := 0;
       ParamsCount   := Dataset.FieldCount;
       RecordCount   := Dataset.RecordCount;
      End;
     //Write dwParamsBinList
     {$IFNDEF FPC}
      {$IF Defined(HAS_FMX)}
       {$IF Defined(HAS_UTF8)} //TODO
        S := String(GetDefinitions(Dataset));
       {$ELSE}
        S := AnsiString(GetDefinitions(Dataset));
       {$IFEND}
      {$ELSE}
       S := AnsiString(GetDefinitions(Dataset));
      {$IFEND}
     {$ELSE}
      S := AnsiString(GetDefinitions(Dataset));
     {$ENDIF}
    // SwapString(S);
     I := Length(S);
     StreamValue.WriteBuffer(I, SizeOf(I));
     StreamValue.WriteBuffer(S[InitStrPos], I);
     For I := 0 To ParamsHeader.RecordCount - 1 Do
      Begin
       SaveRecordToStream(Dataset, StreamValue);
       Dataset.Next;
      End;
     //Remap Bin size
     EndPos := aStream.Size;
     ParamsHeader.DataSize    := EndPos;
     ParamsHeader.ParamsCount := Dataset.FieldCount;
     ParamsHeader.RecordCount := Dataset.RecordCount;
     //Rewrite init Header
     StreamValue.Position := 0;
     aStream.Position := 0;
     StreamValue.WriteBuffer(ParamsHeader, SizeOf(ParamsHeader));
     StreamValue.CopyFrom(aStream, aStream.Size);
     StreamValue.Position := 0;
    Finally
     FreeAndNil(aStream);
    End;
   {$ELSE}
    If Not Assigned(StreamValue) Then
     Exit;
    //Write init Header
    StartPos := StreamValue.Position;
    With ParamsHeader Do
     Begin
      VersionNumber := DwParamsHeaderVersion;
      DataSize      := 0;
      ParamsCount   := Dataset.FieldCount;
      RecordCount   := Dataset.RecordCount;
     End;
    StreamValue.WriteBuffer(ParamsHeader, SizeOf(ParamsHeader));
    {$IFNDEF FPC}
     {$IF Defined(HAS_FMX)}
      {$IF Defined(HAS_UTF8)} //TODO
       S := String(GetDefinitions(Dataset));
      {$ELSE}
       S := AnsiString(GetDefinitions(Dataset));
      {$IFEND}
     {$ELSE}
      S := AnsiString(GetDefinitions(Dataset));
     {$IFEND}
    {$ELSE}
     S := AnsiString(GetDefinitions(Dataset));
    {$ENDIF}
    I := Length(S);
    StreamValue.WriteBuffer(I, SizeOf(I));
    StreamValue.WriteBuffer(S[InitStrPos], I);
    For I := 0 To ParamsHeader.RecordCount - 1 Do
     Begin
      SaveRecordToStream(Dataset, StreamValue);
      Dataset.Next;
     End;
    //Remap Bin size
    EndPos := StreamValue.Position;
    ParamsHeader.DataSize    := EndPos - StartPos - SizeOf(ParamsHeader);
    ParamsHeader.ParamsCount := Dataset.FieldCount;
    ParamsHeader.RecordCount := Dataset.RecordCount;
    //Rewrite init Header
    StreamValue.Position := StartPos;
    StreamValue.WriteBuffer(ParamsHeader, SizeOf(ParamsHeader));
    StreamValue.Position := 0;
   {$IFEND}
  {$ELSE}
  If Not Assigned(StreamValue) Then
   Exit;
  //Write init Header
  StartPos := StreamValue.Position;
  With ParamsHeader Do
   Begin
    VersionNumber := DwParamsHeaderVersion;
    DataSize      := 0;
    ParamsCount   := Dataset.FieldCount;
    RecordCount   := Dataset.RecordCount;
   End;
  StreamValue.WriteBuffer(ParamsHeader, SizeOf(ParamsHeader));
  {$IFNDEF FPC}
   {$IF Defined(HAS_FMX)}
    {$IF Defined(HAS_UTF8)} //TODO
     S := String(GetDefinitions(Dataset));
    {$ELSE}
     S := AnsiString(GetDefinitions(Dataset));
    {$IFEND}
   {$ELSE}
    S := AnsiString(GetDefinitions(Dataset));
   {$IFEND}
  {$ELSE}
   S := AnsiString(GetDefinitions(Dataset));
  {$ENDIF}
  I := Length(S);
  StreamValue.WriteBuffer(I, SizeOf(I));
  StreamValue.WriteBuffer(S[InitStrPos], I);
  For I := 0 To ParamsHeader.RecordCount - 1 Do
   Begin
    SaveRecordToStream(Dataset, StreamValue);
    Dataset.Next;
   End;
  //Remap Bin size
  EndPos := StreamValue.Position;
  ParamsHeader.DataSize    := EndPos - StartPos - SizeOf(ParamsHeader);
  ParamsHeader.ParamsCount := Dataset.FieldCount;
  ParamsHeader.RecordCount := Dataset.RecordCount;
  //Rewrite init Header
  StreamValue.Position := StartPos;
  StreamValue.WriteBuffer(ParamsHeader, SizeOf(ParamsHeader));
  StreamValue.Position := 0;
  {$ENDIF}
 Finally
  If Dataset.Active Then
   Begin
    Dataset.First;
    Dataset.EnableControls;
   End;
 End;
End;

Procedure TRESTDWClientSQLBase.LoadFromStreamToDataset(Const StreamValue : TMemoryStream;
                                                       DataType          : TStreamType = stAll);
Var
 ParamsHeader   : TDWParamsHeader;
 AbortProcess   : Boolean;
 FPrecision,
 I, VersionNumber,
 RecordsCount,
 ParamsCount,
 L              : Integer;
 S              : DWString;
 vFieldList     : TStringList;
 DataSize,
 aSize,
 StartPos       : Int64;
 Function AppendField(FieldDef,
                      Size, Precision : Integer;
                      Attributes      : TDataAttributes;
                      Const Name      : String) : Integer;
 Var
  vFieldDef : TFieldDef;
 Begin
  Result := FieldDefs.Count;
  If (FieldDefs.IndexOf(Name) > -1) Then
   Begin
    Result := FieldDefs.IndexOf(Name);
    Exit;
   End;
  If (Fields.Count > 0) Then
   Begin
    If (FindField(Name) <> Nil) Then
     Begin
      Result := FieldByName(Name).Index;
      Exit;
     End;
   End;
  vFieldDef            := FieldDefs.AddFieldDef;
  vFieldDef.Name       := Name;
  vFieldDef.DataType   := ObjectValueToFieldType(TObjectValue(FieldDef));
  If (Not(vFieldDef.DataType in [ftFloat, ftCurrency, ftBCD, ftFMTBcd
                                 {$IFNDEF FPC}{$IF CompilerVersion > 21}, ftSingle{$IFEND}{$ENDIF}])) Then
   vFieldDef.Size      := Size
  Else
   vFieldDef.Size      := 0;
  If (vFieldDef.DataType In [ftFloat, ftCurrency, ftBCD,
                             {$IFNDEF FPC}{$IF CompilerVersion > 21}ftExtended, ftSingle,
                             {$IFEND}{$ENDIF} ftFMTBcd]) Then
   vFieldDef.Precision := Precision;
   If dwNotNull in Attributes Then
    vFieldDef.Required          := True;
   If dwInternalCalc in Attributes Then
    vFieldDef.InternalCalcField := True;
//  vFieldDef.CreateField(Self);
 End;
 {$IFNDEF FPC}
 {$IF Defined(HAS_FMX)}
 Procedure Init(const Definitions : String);
 {$ELSE}
 Procedure Init(const Definitions : AnsiString);
 {$IFEND}
 {$ELSE}
 Procedure Init(const Definitions : AnsiString);
 {$ENDIF}
 Var
  I, P, Sz: Integer;
  N, S1, S2: string;
  B: Boolean;
  A: TDataAttributes;
  L: TStrings;
 Begin
  L := TStringList.Create;
  FieldDefs.Clear;
  FieldDefs.BeginUpdate;
  Try
   L.Text := String(Definitions);
   For I := 0 to L.Count - 1 do
    Begin
     If Pos('=', L[I]) = 0 Then Continue;
     N := L.Names[I];
     S1 := Trim(L.ValueFromIndex[I]);
     P := Pos(',', S1);
     If P > 0 Then
      Begin
       S2 := Trim(LowerCase(Copy(S1, P + 1, MaxInt)));
       SetLength(S1, P - 1);
       S1 := Trim(S1);
       B := Pos('nn:', S2) = 1;
       If B Then
        {$IFDEF CIL}Borland.Delphi.{$ENDIF}System.Delete(S2, 1, 3)
       Else
        Begin
         P := RPos(':nn', S2);
         B := P > 0;
         If B Then
          {$IFDEF CIL}Borland.Delphi.{$ENDIF}System.Delete(S2, P, 3)
         Else
          Begin
           B := S2 = 'nn';
           If B Then
            S2 := '';
          End;
        End;
       Sz := StrToIntDef(S2, 0);
      End
     Else
      Begin
       B := False;
       Sz := 0;
      End;
     If B Then
      A := [dwNotNull]
     Else
      A := [];
     P := RPos(':calc', LowerCase(S1));
     If P > 0 Then
      Begin
       SetLength(S1, P - 1);
       S1 := Trim(S1);
       Include(A, dwCalcField);
      End
     Else
      Begin
       P := RPos(':lookup', LowerCase(S1));
       If P > 0 Then
        Begin
         SetLength(S1, P - 1);
         S1 := Trim(S1);
         Include(A, dwCalcField);
         Include(A, dwLookup);
        End;
      End;
     vFieldList.Add(N);
     AppendField(StringToFieldType(S1), Sz, FPrecision, A, N);
    End;
  Finally
   FieldDefs.EndUpdate;
//   FieldDefs.Assign(vTempDataset.FieldDefs); // CopyDataSet(vTempDataset, [coRestart]);
//   FreeAndNil(vTempDataset);
   TRESTDWClientSQL(Self).Inactive := True;
   TRESTDWClientSQL(Self).CreateDataSet;
   TRESTDWClientSQL(Self).Inactive := False;
   L.Free;
  End;
 End;
 Procedure LoadRecordFromStream(FieldList : TStringList;
                                Stream    : TStream);
 Var
  X, I    : Integer;
  J, L    : DWInt64;
  S, W    : DWString;
  E       : Extended;
  F       : DWFloat;
  Bool    : Boolean;
  B       : TBcd;
  P       : TMemoryStream;
  T       : DWFieldTypeSize;
  D       : TDateTime;
  vField  : TField;
 Begin
  For I := 0 To FieldList.Count -1 Do
   Begin
    vField := FindField(FieldList[I]);
    If vField = Nil Then
     Continue;
    If (fkCalculated = vField.FieldKind) Or
       (fkLookup     = vField.FieldKind) Then
     Continue;
    S := '';
    L := 0;
    J := 0;
    Stream.ReadBuffer(T, Sizeof(DWFieldTypeSize));
    T := Integer(vField.DataType);
    Case TFieldType(T) Of
      ftMemo,
      {$IFNDEF FPC}{$IF CompilerVersion > 21}ftWideMemo,{$IFEND}{$ENDIF}
      ftFmtMemo,
      ftFixedChar,
      ftWideString,
      ftString : Begin
                  Stream.Read(L, Sizeof(L));
                  If L > 0 Then
                   Begin
                    SetLength(S, L);
                    {$IFDEF FPC}
                     If L <> 0 Then
                      Stream.ReadBuffer(Pointer(S)^, L);
                     S := GetStringEncode(S, vDatabaseCharSet);
                    {$ELSE}
                     If L <> 0 Then
                      Stream.Read(S[InitStrPos], L);
                    {$ENDIF}
                   End;
                  If (Length(S) > vField.Size) And
                     (vField.DataType In [ftString, ftFixedChar]) Then
                    vField.AsString := S;
                   {$IFNDEF FPC}
                    {$IF Defined(HAS_FMX)}
                     {$IFDEF WINDOWS}
                      If SourceSide = dwDelphi Then
                       vField.AsString := {$IFDEF FPC}GetStringEncode(S, vDatabaseCharSet){$ELSE}S{$ENDIF}
                      Else If SourceSide = dwLazarus Then
                       vField.AsString := {$IFDEF FPC}GetStringEncode(S, vDatabaseCharSet){$ELSE}Utf8Decode(S){$ENDIF}
                     {$ELSE}
                       vField.AsString := S;
                     {$ENDIF}
                    {$ELSE}
                     vField.AsString := {$IFDEF FPC}GetStringEncode(S, vDatabaseCharSet){$ELSE}Utf8Decode(S){$ENDIF};
                    {$IFEND}
                   {$ELSE}
                    vField.AsString := {$IFDEF FPC}GetStringEncode(S, vDatabaseCharSet){$ELSE}Utf8Decode(S){$ENDIF};
                   {$ENDIF}
                 End;
      {$IFDEF COMPILER12_UP}
      ftByte,
      ftShortint : Begin
                    Stream.ReadBuffer(J, Sizeof(DWInteger));
                    vField.AsInteger := J;
                   End;
      {$ENDIF}
      ftSmallint : Begin
                    Stream.ReadBuffer(Bool, Sizeof(Byte));
                    If Not Bool Then
                     Begin
                      Stream.ReadBuffer(X, Sizeof(DWInteger));
                      vField.AsInteger := X;
                     End;
                   End;
      ftWord,
      ftInteger,
      ftAutoInc :  Begin
                    Stream.ReadBuffer(Bool, Sizeof(Byte));
                    If Not Bool Then
                     Begin
                      Stream.ReadBuffer(J, Sizeof(DWInteger));
                      vField.AsInteger := J;
                     End;
                   End;
      ftFloat,
      ftFMTBcd,
      ftCurrency,
      {$IFNDEF FPC}{$IF CompilerVersion >= 21}ftExtended, ftSingle, {$IFEND}{$ENDIF}
      ftBCD     : Begin
                   F := 0;
                   Stream.ReadBuffer(Bool, Sizeof(Byte));
                   If Not Bool Then
                    Begin
                     Stream.ReadBuffer(F, Sizeof(DWFloat));
                     vField.Value := F;
                    End;
                  End;
      ftDate,
      ftTime,
      ftDateTime,
      {$IFNDEF FPC}{$IF CompilerVersion >= 21}ftTimeStampOffset, {$IFEND}{$ENDIF}
      ftTimeStamp : Begin
                     Stream.ReadBuffer(J, Sizeof(DWInt64));
                     If J <> 0 Then
                      vField.AsDateTime := UnixToDateTime(J);
                    End;
      {$IFNDEF FPC}{$IF CompilerVersion >= 21}ftLongWord,{$IFEND}{$ENDIF}
      ftLargeint : Begin
                    Stream.ReadBuffer(Bool, Sizeof(Byte));
                    If Not Bool Then
                     Begin
                     Stream.ReadBuffer(J, Sizeof(DWInt64));
                     {$IFNDEF FPC}
                      {$IF CompilerVersion > 21}
                       vField.AsLargeInt := J;
                      {$ELSE}
                       vField.AsInteger := J;
                      {$IFEND}
                     {$ELSE}
                      vField.AsLargeInt := J;
                     {$ENDIF}
                     End;
                   End;
      ftBoolean  : Begin
                    Stream.ReadBuffer(Bool, Sizeof(Byte));
                    vField.AsBoolean := Bool;
                   End;
      ftVariant,
      ftInterface,
      ftIDispatch,
      ftGuid   : Begin
                  Stream.Read(L, Sizeof(L));
                  If L > 0 Then
                   Begin
                    SetLength(S, L);
                    {$IFDEF FPC}
                     If L <> 0 Then
                      Stream.ReadBuffer(Pointer(S)^, L);
                     S := GetStringEncode(S, vDatabaseCharSet);
                    {$ELSE}
                     If L <> 0 Then
                      Stream.Read(S[InitStrPos], L);
                    {$ENDIF}
                   End;
                  If (Length(S) > vField.Size) And
                     (vField.DataType In [ftString, ftFixedChar]) Then
                    Begin
                     vField.AsString := S;
                    End;
                   {$IFNDEF FPC}
                    {$IF Defined(HAS_FMX)}
                     {$IFDEF WINDOWS}
                      If SourceSide = dwDelphi Then
                       vField.AsString := {$IFDEF FPC}GetStringEncode(S, vDatabaseCharSet){$ELSE}S{$ENDIF}
                      Else If SourceSide = dwLazarus Then
                       vField.AsString := {$IFDEF FPC}GetStringEncode(S, vDatabaseCharSet){$ELSE}Utf8Decode(S){$ENDIF}
                     {$ELSE}
                       vField.AsString := S;
                     {$ENDIF}
                    {$ELSE}
                     vField.AsString := {$IFDEF FPC}GetStringEncode(S, vDatabaseCharSet){$ELSE}Utf8Decode(S){$ENDIF};
                    {$IFEND}
                   {$ELSE}
                    vField.AsString := {$IFDEF FPC}GetStringEncode(S, vDatabaseCharSet){$ELSE}Utf8Decode(S){$ENDIF};
                   {$ENDIF}
                 End;
      ftBlob,
      {$IFNDEF FPC}{$IF CompilerVersion > 21}ftStream,{$IFEND}{$ENDIF}
      ftBytes : Begin
                 Stream.ReadBuffer(J, Sizeof(DWInt64));
                 If J > 0 Then
                  Begin
                   P := TMemoryStream.Create;
                   Try
                    P.CopyFrom(Stream, J);
                    P.position := 0;
                    If P.Size > 0 Then
                     TBlobField(vField).LoadFromStream(P)
                    Else
                     TBlobField(vField).Clear;
                   Finally
                    P.Free;
                   End;
                  End;
                End;
      Else
       Begin
       {$IFNDEF COMPILER11_UP}
        If Not vField.isnull Then Continue;
        Case Integer(T) Of
         dwftWideMemo : Begin
                         Stream.Read(L, Sizeof(L));
                         If L > 0 Then
                          Begin
                           SetLength(S, L);
                           {$IFDEF FPC}
                            If L <> 0 Then
                             Stream.ReadBuffer(Pointer(S)^, L);
                            S := GetStringEncode(S, vDatabaseCharSet);
                           {$ELSE}
                            If L <> 0 Then
                             Stream.Read(S[InitStrPos], L);
                           {$ENDIF}
                          End;
                         If (Length(S) > vField.Size) And
                            (vField.DataType In [ftString, ftFixedChar]) Then
                          Begin
                           vField.AsString := S;
                          End;
                         {$IFNDEF FPC}
                          {$IF Defined(HAS_FMX)}
                           {$IFDEF WINDOWS}
                            If SourceSide = dwDelphi Then
                             vField.AsString := {$IFDEF FPC}GetStringEncode(S, vDatabaseCharSet){$ELSE}S{$ENDIF}
                            Else If SourceSide = dwLazarus Then
                             vField.AsString := {$IFDEF FPC}GetStringEncode(S, vDatabaseCharSet){$ELSE}Utf8Decode(S){$ENDIF}
                           {$ELSE}
                             vField.AsString := S;
                           {$ENDIF}
                          {$ELSE}
                           vField.AsString := {$IFDEF FPC}GetStringEncode(S, vDatabaseCharSet){$ELSE}Utf8Decode(S){$ENDIF};
                          {$IFEND}
                         {$ELSE}
                          vField.AsString := {$IFDEF FPC}GetStringEncode(S, vDatabaseCharSet){$ELSE}Utf8Decode(S){$ENDIF};
                         {$ENDIF}
                        End;
         dwftLongWord : Begin
                         Stream.ReadBuffer(J, Sizeof(DWInteger));
                         vField.AsInteger := J;
                        End;
         dwftExtended,
         dwftSingle   : Begin
                         F := 0;
                         Stream.ReadBuffer(Bool, Sizeof(Byte));
                         If Not Bool Then
                          Begin
                           Stream.ReadBuffer(F, Sizeof(DWFloat));
                           vField.Value := F;
                          End;
                        End;
         dwftTimeStampOffset: Begin
                               Stream.ReadBuffer(J, Sizeof(DWInt64));
                               If J <> 0 Then
                                vField.AsDateTime := UnixToDateTime(J);
                              End;
        End;
       {$ENDIF}
       End;
    End;
   End;
 End;
Begin
 FPrecision           := 0;
 StreamValue.Position := FPrecision;
 AbortProcess         := False;
 vFieldList           := Nil;
 If StreamValue.Size > 0 Then
  Begin
   StreamValue.ReadBuffer(ParamsHeader, Sizeof(TDWParamsHeader));
   VersionNumber   := ParamsHeader.VersionNumber;
   ParamsCount     := ParamsHeader.ParamsCount;
   RecordsCount    := ParamsHeader.RecordCount;
   DataSize        := ParamsHeader.DataSize;
   StartPos        := StreamValue.Position;
   aSize           := StreamValue.Size;
   S := '';
   StreamValue.ReadBuffer(I, SizeOf(I));
   If (I > ParamsHeader.DataSize) Or
      (I > MAXSHORT)              Or
      (I < 0)                     Then
    Raise DWTableError.Create(SCorruptedDefinitions);
   SetLength(S, I);
   {$IFDEF FPC}
    If I <> 0 Then
     StreamValue.ReadBuffer(Pointer(S)^, I);
    S := GetStringEncode(S, vDatabaseCharSet);
   {$ELSE}
    If I <> 0 Then
     StreamValue.Read(S[InitStrPos], I);
   {$ENDIF}
   //Init FieldDefs
   vFieldList := TStringList.Create;
   //Load Data
   DisableControls;
   TRESTDWClientSQL(Self).SetInBlockEvents(True);
   Init(S);
   If DataType = stAll Then
    Begin
     Try
      For I := 0 To RecordsCount - 1 Do
       Begin
        Append;
        LoadRecordFromStream(vFieldList, StreamValue);
        If Assigned(OnWriterProcess) Then
         OnWriterProcess(Self, I +1, RecordsCount, AbortProcess);
        If AbortProcess Then
         Break;
        Post;
       End;
     Finally
      First;
      EnableControls;
      TRESTDWClientSQL(Self).SetInBlockEvents(False);
     End;
    End;
  End
 Else
  Raise Exception.Create(cInvalidBinaryRequest);
 If Assigned(vFieldList) Then
  FreeAndNil(vFieldList);
End;

Procedure TRESTDWClientSQLBase.LoadFromStream(Value    : TMemoryStream;
                                              DataType : TStreamType = stAll);
Var
 I : Integer;
{$IFNDEF DWMEMTABLE}
 vMemBRequest :  TdwMemtable;
 Procedure CopyData;
 Begin
  vMemBRequest.First;
  {$IFDEF UNIDACMEM}
  Try
   AssignDataSet(vMemBRequest);
  {$ELSE}
  Try
   While Not vMemBRequest.Eof Do
    Begin
     Append;
     CopyRecord(vMemBRequest);
     Post;
     vMemBRequest.Next;
    End;
  {$ENDIF}
  Finally
  End;
 End;
{$ENDIF}
Begin
 vLoadFromStream := True;
 Try
  Try
 //  SetInitDataset(True);
  {$IFDEF FPC}
   {$IFDEF DWMEMTABLE}
    vBinaryLoadRequest := True;
    DisableControls;
    Close;
    Try
     Value.Position := 0;
     If Not vBinaryCompatibleMode Then
      Begin
       TdwMemtable(Self).Encoding        := TRESTDWClientSQL(Self).Encoding;
       TdwMemtable(Self).OnWriterProcess := vOnWriterProcess;
       If Value.Size > 0 Then
        Begin
         TdwMemtable(Self).LoadFromStream(Value);
         TdwMemtable(Self).Active := True;
        End;
      End
     Else
      LoadFromStreamToDataset(Value, DataType);
    Finally
     vOnLoadStream     := False;
     vBinaryLoadRequest := False;
     EnableControls;
    End;
   {$ENDIF}
   {$IFDEF UNIDACMEM}
    vBinaryLoadRequest := True;
    DisableControls;
    Close;
    Try
     Value.Position := 0;
     If Not vBinaryCompatibleMode Then
      Begin
       TVirtualTable(Self).LoadFromStream(Value);
       TVirtualTable(Self).Active := True;
      End
     Else
      LoadFromStreamToDataset(Value, DataType);
    Finally
     vOnLoadStream      := False;
     vBinaryLoadRequest := False;
     EnableControls;
    End;
   {$ENDIF}
  {$ELSE}
   {$IFDEF CLIENTDATASET}
    Raise Exception.Create(cInvalidBinaryRequest);
   {$ENDIF}
   {$IFDEF RESTKBMMEMTABLE}
    Raise Exception.Create(cInvalidBinaryRequest);
   {$ENDIF}
   {$IFDEF UNIDACMEM}
    DisableControls;
    Close;
    vBinaryLoadRequest := True;
    Try
     Value.Position := 0;
     If vBinaryCompatibleMode Then
      LoadFromStreamToDataset(Value, DataType)
     Else
      Begin
       If Value.Size > 0 Then
        Begin
         TVirtualTable(Self).LoadFromStream(Value, TVirtualTable(Self).Fields.Count = 0);
         TVirtualTable(Self).Active := True;
        End;
      End;
    Finally
     vOnLoadStream     := False;
     vBinaryLoadRequest := False;
     EnableControls;
    End;
   {$ENDIF}
   {$IFDEF RESTFDMEMTABLE}
    DisableControls;
    Close;
    Try
     vBinaryLoadRequest := True;
     If vBinaryCompatibleMode Then
      LoadFromStreamToDataset(Value, DataType)
     Else
      Begin
       Try
        If Value.Size > 0 Then
         Begin
          If DataType = stAll Then
           TFDMemtable(Self).ResourceOptions.StoreItems := [siMeta, siData, siDelta]
          Else
           TFDMemtable(Self).ResourceOptions.StoreItems := [siMeta, siDelta];
          TFDMemtable(Self).LoadFromStream(Value, sfBinary);
         End;
        vOnLoadStream     := True;
       Finally
        vOnLoadStream     := False;
        vBinaryLoadRequest := False;
       End;
      End;
    Finally
     EnableControls;
    End;
   {$ENDIF}
   {$IFDEF DWMEMTABLE}
    DisableControls;
    vBinaryLoadRequest := True;
    Try
     Value.Position := 0;
     If Not vBinaryCompatibleMode Then
      Begin
       TdwMemtable(Self).Encoding        := TRESTDWClientSQL(Self).Encoding;
       TdwMemtable(Self).OnWriterProcess := vOnWriterProcess;
       If Value.Size > 0 Then
        Begin
         TdwMemtable(Self).LoadFromStream(Value);
         TdwMemtable(Self).Active := True;
        End;
      End
     Else
      LoadFromStreamToDataset(Value, DataType);
    Finally
     vOnLoadStream     := False;
     vBinaryLoadRequest := False;
     EnableControls;
    End;
   {$ENDIF}
  {$ENDIF}
  Finally
   vLoadFromStream := False;
 //  SetInitDataset(False);
  End;
 Except
   Raise Exception.Create(cInvalidBinaryRequest);
 End;
End;

Procedure TRESTDWClientSQLBase.SetComponentTAG;
Begin
 vComponentTag := EncodeStrings(RandomString(10){$IFDEF FPC}, csUndefined{$ENDIF});
End;

Procedure TRESTDWClientSQLBase.ForceInternalCalc;
Var
 needsPost : Boolean;
 saveState : TDataSetState;
Begin
 needsPost := OnEditingState;
 saveState := setTempState(dsInternalCalc);
 Try
  RefreshInternalCalcFields(ActiveBuffer);
 Finally
  RestoreState(saveState);
 End;
 If needsPost Then
  Post;
End;

end.
