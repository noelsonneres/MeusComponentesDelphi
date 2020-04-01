
{******************************************}
{                                          }
{             FastReport v5.0              }
{            DBF export filter             }
{                                          }
{         Copyright (c) 1998-2009          }
{           by Anton Khayrudinov           }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportDBF;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, frxClass, frxExportMatrix, ShellAPI
{$IFDEF Delphi6}, Variants {$ENDIF};

type
  TfrxDBFExportDialog = class(TForm)
    OkB: TButton;
    CancelB: TButton;
    sd: TSaveDialog;
    GroupPageRange: TGroupBox;
    DescrL: TLabel;
    AllRB: TRadioButton;
    CurPageRB: TRadioButton;
    PageNumbersRB: TRadioButton;
    PageNumbersE: TEdit;
    GroupQuality: TGroupBox;
    OpenCB: TCheckBox;
    OEMCB: TCheckBox;
    gbFNames: TGroupBox;
    rbFNAuto: TRadioButton;
    rbFNManual: TRadioButton;
    btFNLoad: TButton;
    odFN: TOpenDialog;
    mmFN: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure PageNumbersEChange(Sender: TObject);
    procedure PageNumbersEKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btFNLoadClick(Sender: TObject);
  end;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxDBFExport = class(TfrxCustomExportFilter)
  private
    FOpenAfterExport: Boolean;
    FMatrix:      TfrxIEMatrix;
    Exp:          TStream;
    FOEM:         Boolean;
    FFieldNames:  TStrings;
    FFieldPrefix: AnsiString;

    procedure SetFieldNames(Value: TStrings);
    procedure ExportMatrix(Stream: TStream; mx: TfrxIEMatrix);
    procedure SetFieldPrefix(const Value: AnsiString);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    function ShowModal: TModalResult; override;
    function Start: Boolean; override;
    procedure Finish; override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
    procedure ExportObject(Obj: TfrxComponent); override;

  published
    property OEMCodepage: Boolean read FOEM write FOEM;
    property OpenAfterExport: Boolean read FOpenAfterExport write FOpenAfterExport default False;
    property OverwritePrompt;

    // If FieldNames is empty, then
    // FieldPrefix value specifies a short prefix for every DBF
    // field name. Note, that the length of FieldPrefix should not
    // exceed 6 characters. If it does, it will be truncated to 6
    // characters.
    property FieldPrefix: AnsiString read FFieldPrefix write SetFieldPrefix;

    // If FieldNames is empty, names of DBF fields are assigned automatically
    // using FieldPrefix value. If FieldNames is not empty, then it specifies
    // a list of names for DBF fields. Since the exporter canot forecast
    // names of fields in a report. The number of items in FieldNames can
    // be less than the actual number of columns in a report, in this case
    // the missing names of fields are generated automatically using FieldPrefix
    // value due to the common scheme.
    property FieldNames: TStrings read FFieldNames write SetFieldNames;
  end;

implementation

uses frxUtils, frxFileUtils, frxUnicodeUtils, frxRes, frxrcExports;

{$R *.dfm}

type

  //
  // DBF header
  // 32 bytes
  //

  TfrxDBFHeader = packed record

    Version:      Byte;

    Year:         Byte;       // date of the last update
    Month:        Byte;
    Day:          Byte;

    RecCount:     LongWord;   // records count
    HdrSize:      Word;       // header size
    RecSize:      Word;       // size of any record
    R1:           Word;
    Transaction:  Byte;
    Encoded:      Byte;
    Environment:  array [1..12] of Byte;
    Indexed:      Byte;
    Language:     Byte;       // language driver number or codepage number
    R2:           Word;

  end;

  //
  // DBF field header
  // 32 bytes
  //

  TfrxDBFFieldHeader = packed record

    Name:         array [1..10] of Byte;
    Zero:         Byte;       // null symbol ending the name
    FieldType:    Byte;

    //
    // Field data address.
    // This works in three modes:
    //
    //  - 4 bytes are written: the address is a pointer to data in virtual memory
    //  - 2 high bytes are zeros: the address is an offset from the record beginning
    //  - all bytes are zeros: the address is ignored
    //

    Address:      LongWord;

    Length:       Byte;       // field length
    Digits:       Byte;       // count of decimal digits
    R1:           Word;
    WSId:         Byte;       // workset identifier
    MultiUser:    Word;       // multi user mode
    SetField:     Byte;
    R2:           array [1..7] of Byte;
    MDX:          Byte;       // this flag means that the field is included into .mdx index

  end;

{ TfrxDBFExport }

constructor TfrxDBFExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOEM := False;
  FilterDesc := frxGet(9101);
  DefaultExt := frxGet(9103);
  FFieldNames := TStringList.Create;
end;

class function TfrxDBFExport.GetDescription: String;
begin
  Result := frxGet(9102);
end;

destructor TfrxDBFExport.Destroy;
begin
  FFieldNames.Free;
  inherited;
end;

procedure TfrxDBFExport.SetFieldPrefix(const Value: AnsiString);
begin
  FFieldPrefix := Copy(Value, 1, 6);
end;

procedure TfrxDBFExport.ExportMatrix(Stream: TStream; mx: TfrxIEMatrix);

 function StrToOem(const AnsiStr: AnsiString): AnsiString;
  begin
    SetLength(Result, Length(AnsiStr));
    if Length(Result) > 0 then
      CharToOemBuffA(PAnsiChar(AnsiStr), PAnsiChar(Result), Length(Result));
  end;

  procedure WriteVal(Data: LongInt; Len: LongInt);
  begin
    Stream.Write(Data, Len);
  end;

  procedure WriteRef(const Data; Len: LongInt);
  begin
    Stream.Write(Data, Len);
  end;

  function GetFieldName(i: LongInt): AnsiString;
  begin
    if i >= FieldNames.Count then
      Result := FieldPrefix + AnsiString(IntToStr(i + 1))
    else
      Result := AnsiString(FieldNames[i]);
  end;

  procedure ByteCopy(Dest: Pointer; const Src: AnsiString; MaxLen: Integer);
  var
    n: Integer;
  begin
    n := Length(Src);

    if n > MaxLen then
      n := MaxLen;

    CopyMemory(Dest, @Src[1], n);
  end;

const
  MaxFieldLen = 255;

var
  r, c, i:    Integer;
  Obj:        TfrxIEMObject;
  s:          AnsiString;
  h:          TfrxDBFHeader;
  fh:         TfrxDBFFieldHeader;
  y, m, d:    Word;
  buffer:     array [1..MaxFieldLen] of Byte;
  name:       AnsiString;

begin
  //
  // DBF header
  //

  DecodeDate(CreationTime, y, m, d);
  ZeroMemory(@h, Sizeof(h));

  h.Version   := 3;
  h.Year      := y - 2000;
  h.Month     := m;
  h.Day       := d;
  h.RecCount  := mx.Height - 1;
  h.HdrSize   := 32 + 32*(mx.Width - 1) + 1;
  h.RecSize   := 1 + MaxFieldLen*(mx.Width - 1);

  WriteRef(h, SizeOf(h));

  //
  // DBF fields descriptions.
  //

  for i := 1 to mx.Width - 1 do
  begin
    ZeroMemory(@fh, SizeOf(fh));
    name := GetFieldName(i - 1);

    if name <> '' then
      ByteCopy(@fh.Name[1], name, 10);

    fh.FieldType    := Ord('C');
    fh.Length       := MaxFieldLen;
    fh.SetField     := 1;
    fh.Address      := 1 + MaxFieldLen*(i - 1);

    WriteRef(fh, SizeOf(fh));
  end;

  //
  // DBF header ending symbol
  //

  WriteVal(13, 1);

  //
  // DBF records.
  //

  for r := 0 to mx.Height - 2 do
  begin
    WriteVal(32, 1);
    for c := 0 to mx.Width - 2 do
    begin
      FillChar(buffer[1], MaxFieldLen, $20);
      i := mx.GetCell(c, r);
      if i < 0 then
      begin
        WriteRef(buffer, MaxFieldLen);
        Continue;
      end;

      Obj := mx.GetObjectById(i);

      if Obj.Counter <> 0 then
      begin
        WriteRef(buffer, MaxFieldLen);
        Continue;
      end;

      s := _UnicodeToAnsi(Obj.Memo.Text, DEFAULT_CHARSET);
      if FOEM then
        s := StrToOem(s);

      if s <> '' then
        ByteCopy(@buffer[1], s, MaxFieldLen);

      WriteRef(buffer, MaxFieldLen);
      Obj.Counter := 1;
    end;
  end;

  //
  // DBF records ending symbol.
  //

  WriteVal(26, 1);
end;

function TfrxDBFExport.ShowModal: TModalResult;
begin
  if not Assigned(Stream) then
  begin
    with TfrxDBFExportDialog.Create(nil) do
    begin
      OpenCB.Visible := not SlaveExport;
      if OverwritePrompt then
        sd.Options := sd.Options + [ofOverwritePrompt];
      if SlaveExport then
        FOpenAfterExport := False;

      if (FileName = '') and (not SlaveExport) then
        sd.FileName := ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(Report.FileName)), sd.DefaultExt)
      else
        sd.FileName := FileName;

      OpenCB.Checked := FOpenAfterExport;
      OEMCB.Checked := FOEM;

      if PageNumbers <> '' then
      begin
        PageNumbersE.Text := PageNumbers;
        PageNumbersRB.Checked := True;
      end;

      if FieldNames.Count > 0 then
        begin
          mmFN.Lines := FieldNames;
          rbFNManual.Checked := True;
        end;

      Result := ShowModal;

      if Result = mrOk then
      begin
        PageNumbers := '';
        CurPage := False;
        if CurPageRB.Checked then
          CurPage := True
        else if PageNumbersRB.Checked then
          PageNumbers := PageNumbersE.Text;

        FOpenAfterExport := OpenCB.Checked;
        FOEM := OEMCB.Checked;

        if mmFN.Lines.Count > 0 then
          FieldNames := mmFN.Lines
        else
          FieldNames := nil;

        if not SlaveExport then
        begin
          if DefaultPath <> '' then
            sd.InitialDir := DefaultPath;
          if sd.Execute then
            FileName := sd.FileName
          else
            Result := mrCancel;
        end;
      end;
      Free;
    end;
  end else
    Result := mrOk;
end;

function TfrxDBFExport.Start: Boolean;
begin
  if SlaveExport and (FileName = '') then
  begin
    if Report.FileName <> '' then
      FileName := ChangeFileExt(GetTemporaryFolder +
        ExtractFileName(Report.FileName), frxGet(9103))
    else
      FileName := ChangeFileExt(GetTempFile, frxGet(9103))
  end;
  if (FileName <> '') or Assigned(Stream) then
  begin
    if (ExtractFilePath(FileName) = '') and (DefaultPath <> '') then
      FileName := DefaultPath + '\' + FileName;
    FMatrix := TfrxIEMatrix.Create(UseFileCache, Report.EngineOptions.TempDir);
    FMatrix.Background := False;
    FMatrix.BackgroundImage := False;
    FMatrix.Printable := ExportNotPrintable;
    FMatrix.RichText := True;
    FMatrix.PlainRich := True;
    FMatrix.AreaFill := False;
    FMatrix.CropAreaFill := True;
    FMatrix.Inaccuracy := 5;
    FMatrix.DeleteHTMLTags := False;
    FMatrix.Images := False;
    FMatrix.WrapText := False;
    FMatrix.ShowProgress := False;
    FMatrix.FramesOptimization := True;
    try
      if Assigned(Stream) then
        Exp := Stream
      else
        Exp := TFileStream.Create(FileName, fmCreate);
       Result := True;
    except
      Result := False;
    end;
  end
  else
    Result := False;
end;

procedure TfrxDBFExport.StartPage(Page: TfrxReportPage; Index: Integer);
begin
end;

procedure TfrxDBFExport.ExportObject(Obj: TfrxComponent);
var v: TfrxView;
begin
  inherited;
  if Obj.Page <> nil then
    Obj.Page.Top := FMatrix.Inaccuracy;

  if Obj.Name = '_pagebackground' then
    Exit;

  if Obj is TfrxView then
  begin
    v := Obj as TfrxView;

    if vsExport in v.Visibility then
      FMatrix.AddObject(v);
  end;
end;

procedure TfrxDBFExport.FinishPage(Page: TfrxReportPage; Index: Integer);
var
 p: TfrxIEMPage;
begin
  FMatrix.AddPage(Page.Orientation, Page.Width, Page.Height, Page.LeftMargin,
    Page.TopMargin, Page.RightMargin, Page.BottomMargin,
    Page.MirrorMargins, Index);

  p := FMatrix.IEPages[Index];
  if p = nil then
    Exit;

  p.PageName := Page.Name;
  p.PrintOnPreviousPage := Page.PrintOnPreviousPage;
end;

procedure TfrxDBFExport.Finish;
begin
  FMatrix.Prepare;
  ExportMatrix(Exp, FMatrix);
  FMatrix.Destroy;

  if not Assigned(Stream) then
    Exp.Free;

  if FOpenAfterExport and not Assigned(Stream) then
    ShellExecute(GetDesktopWindow, 'open', PChar(FileName),
      nil, nil, SW_SHOW);
end;

procedure TfrxDBFExport.SetFieldNames(Value: TStrings);
begin
  if Value = nil then
    FFieldNames.Clear
  else
    FFieldNames.Assign(Value);
end;

{ TfrxDBFExportDialog }

procedure TfrxDBFExportDialog.btFNLoadClick(Sender: TObject);
begin
  if not odFN.Execute then
    Exit;

  try
    mmFN.Lines.LoadFromFile(odFN.FileName);
  except
    MessageBox(
      Handle,
      PChar(frxGet(9104)),
      PChar(frxGet(9105)),
      MB_OK or MB_ICONERROR);
  end;
end;

procedure TfrxDBFExportDialog.FormCreate(Sender: TObject);
begin
  OkB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);
  GroupPageRange.Caption := frxGet(7);
  AllRB.Caption := frxGet(3);
  CurPageRB.Caption := frxGet(4);
  PageNumbersRB.Caption := frxGet(5);
  DescrL.Caption := frxGet(9);
  GroupQuality.Caption := frxGet(8302);
  OEMCB.Caption := frxGet(8304);
  OpenCB.Caption := frxGet(8706);

  Caption             := frxGet(9101);
  gbFNames.Caption    := frxGet(9106);
  rbFNAuto.Caption    := frxGet(9107);
  rbFNManual.Caption  := frxGet(9108);
  btFNLoad.Caption    := frxGet(9109);
  odFN.Filter         := frxGet(9110);
  sd.Filter           := frxGet(9111);

  if UseRightToLeftAlignment then
    FlipChildren(True);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

procedure TfrxDBFExportDialog.PageNumbersEChange(Sender: TObject);
begin
  PageNumbersRB.Checked := True;
end;

procedure TfrxDBFExportDialog.PageNumbersEKeyPress(Sender: TObject;
  var Key: Char);
begin
  case key of
    '0'..'9':;
    #8, '-', ',':;
  else
    key := #0;
  end;
end;

procedure TfrxDBFExportDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

end.
