unit frxlazdbfeditor;

{$I frx.inc}

interface

uses
  Classes, SysUtils, Forms, Dialogs,
  frxDsgnIntf, frxlazdbfcomp, frxRes, db, dbf;



implementation

type

  { TfrxDBFFilePathProperty }

  TfrxDBFFilePathProperty = class(TfrxStringProperty)
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
  end;

  { TfrxDBFTableNameProperty }

  TfrxDBFTableNameProperty = class (TfrxStringProperty)
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
  end;



{ TfrxDBFTableNameProperty }

function TfrxDBFTableNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paDialog];
end;

function TfrxDBFTableNameProperty.Edit: Boolean;
begin
  with TOpenDialog.Create(nil) do
  begin
  TfrxDBFTable(Component).FilePath;
    InitialDir := TfrxDBFTable(Component).FilePath;
    Result := Execute;
    if Result then
      TfrxDBFTable(Component).TableName := FileName;
  end;
end;

{ TfrxDBFFilePathProperty }

function TfrxDBFFilePathProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paDialog];
end;

function TfrxDBFFilePathProperty.Edit: Boolean;
begin
  with TSelectDirectoryDialog.Create(nil) do
  begin
    InitialDir := GetCurrentDir;
    Result := Execute;
    if Result then
      TfrxDBFTable(Component).FilePath := FileName;
  end;
end;

initialization

  frxPropertyEditors.Register(TypeInfo(String), TfrxDBFTable, 'FilePath',
    TfrxDBFFilePathProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxDBFTable, 'TableName',
    TfrxDBFTableNameProperty);

end.

