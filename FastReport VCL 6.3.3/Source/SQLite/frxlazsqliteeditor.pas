unit frxlazsqliteeditor;

{$I frx.inc}

interface


implementation

uses
  Classes, SysUtils, Forms, Dialogs, frxlazsqlitecomp, frxCustomDB,
  frxDsgnIntf, frxRes, db, sqldb ;

type

  { TfrxDatabaseNameProperty }

  TfrxDatabaseNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
  end;

  { TfrxDatabaseConnectorTypeProperty }


  { TfrxDatabaseProperty }

  TfrxDatabaseProperty = class(TfrxComponentProperty)
  public
    function GetValue: String; override;
  end;

  { TfrxDatabaseProperty }

  function TfrxDatabaseProperty.GetValue: String;
  var
    db: TfrxLazSqliteDatabase;
  begin
    db := TfrxLazSqliteDatabase(GetOrdValue);
    if db = nil then
    begin
      if (LazSqliteComponents <> nil) and (LazSqliteComponents.DefaultDatabase <> nil) then
        Result := LazSqliteComponents.DefaultDatabase.Name
      else
        Result := frxResources.Get('prNotAssigned');
    end
    else
      Result := inherited GetValue;
  end;

  { TfrxDatabaseNameProperty }

  function TfrxDatabaseNameProperty.GetAttributes: TfrxPropertyAttributes;
  begin
    Result := [paDialog];
  end;

  function TfrxDatabaseNameProperty.Edit: Boolean;
  var
    SaveConnected: Boolean;
  begin
    with TOpenDialog.Create(nil) do
    begin
      InitialDir := GetCurrentDir;
      Filter := frxResources.Get('ftDB')  +
        frxResources.Get('ftAllFiles') + ' (*.*)|*.*';
      Result := Execute;
      if Result then
        with TfrxLazSqliteDatabase(Component).Database do
        begin
          SaveConnected := Connected;
          Connected := False;
          DatabaseName := FileName;
          Connected := SaveConnected;
        end;
      Free;
    end;
  end;


  initialization
    frxPropertyEditors.Register(TypeInfo(String), TfrxLazSqliteDataBase, 'DatabaseName',
      TfrxDataBaseNameProperty);
    frxPropertyEditors.Register(TypeInfo(TfrxLazSqliteDatabase), TfrxLazSqliteQuery, 'Database',
      TfrxDatabaseProperty);
end.

