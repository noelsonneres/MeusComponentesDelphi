
{******************************************}
{                                          }
{             FastReport v5.0              }
{             Design interface             }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxIOTransportZip;

interface

{$I frx.inc}

uses
  SysUtils, Classes, frxClass, Dialogs
{$IFDEF FPC}
  ,LCLType, LazHelper, LCLProc
{$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxSaveToZipFilter = class(TfrxIOTransportFile)
  private
    FDocFolder: String;
  protected
    procedure SetVisibility(const Value: TfrxFilterVisibility); override;
  public
    function OpenFilter: Boolean; override;
    procedure CloseFilter; override;
    function GetStream(aFileName: String = ''): TStream; override;
    procedure FreeStream(aStream: TStream; aFileName: String = ''); override;
    class function GetDescription: String; override;
    function DoFilterSave(aStream: TStream): Boolean; override;
  end;

implementation

uses frxUtils, frxRes, frxIOTransportIntf, frxZip, frxFileUtils;

{ TfrxSaveToFileDialogFilter }

procedure TfrxSaveToZipFilter.CloseFilter;
var
  Zip: TfrxZipArchive;
  FileNames: TStringList;
  f: TStream;
begin
  begin
    Zip := TfrxZipArchive.Create;
    try

      FileNames := TStringList.Create;
  { close files }
      TempFilter.FilterAccess := faRead;
      TempFilter.LoadClosedStreams;
      FileNames.Clear;
      TempFilter.CopyStreamsNames(FileNames, True);
      f := inherited GetStream(FileName);
      Zip.RootFolder := AnsiString(FDocFolder + '/' );
      Zip.SaveToStreamFromList(f, FileNames);
    finally
      inherited FreeStream(f);
      Zip.Free;
      TempFilter.CloseAllStreams;
      TempFilter.CloseFilter;
    end;
  end;
end;

function TfrxSaveToZipFilter.DoFilterSave(aStream: TStream): Boolean;
begin
  Result := TempFilter.DoFilterSave(aStream);
end;

procedure TfrxSaveToZipFilter.FreeStream(aStream: TStream; aFileName: String);
begin
  TempFilter.FreeStream(aStream, aFileName)
end;

class function TfrxSaveToZipFilter.GetDescription: String;
begin
  Result := 'Save to Zip file';
end;

function TfrxSaveToZipFilter.GetStream(aFileName: String): TStream;
begin
  Result := TempFilter.GetStream(aFileName)
end;

function TfrxSaveToZipFilter.OpenFilter: Boolean;
var
  FilterList: TStringList;
  i: Integer;
begin
  Result := TempFilter.OpenFilter;
  FDocFolder := TempFilter.BasePath;
end;

procedure TfrxSaveToZipFilter.SetVisibility(
  const Value: TfrxFilterVisibility);
begin
  FVisibility := Value;
end;

initialization

finalization

end.
