{ --------------------------------------------------------------------------- }
{ FireDAC FastReport v 4.0 enduser components                                  }
{                                                                             }
{ (c)opyright DA-SOFT Technologies 2004-2013.                                 }
{ All rights reserved.                                                        }
{                                                                             }
{ Initially created by: Serega Glazyrin <glserega@mezonplus.ru>               }
{ Extended by: Francisco Armando Duenas Rodriguez <fduenas@gmxsoftware.com>   }
{                                                                             }
{ Extended by: Copyright (c) 2018 by Stalker SoftWare <stalker4zx@gmail.com>  }
{ --------------------------------------------------------------------------- }
{$I frx.inc}

unit frxFDEditor;

interface

implementation

uses
  Windows, Classes, SysUtils, Forms, Dialogs, Controls, Variants,
  frxFDComponents, frxCustomDB, frxEditQueryParams, frxCustomDBEditor, 
  frxDsgnIntf, frxRes, FireDAC.Comp.Client, FireDAC.VCLUI.ConnEdit, 
  FireDAC.Stan.ResStrs;

type
  TfrxFDDatabaseNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
    function ShowConnEditDlg(AConn: TFDCustomConnection; const ACaption: String; 
      AHideOptionsTab: Boolean = False): Boolean;
  end;

  TfrxFDDatabaseProperty = class(TfrxComponentProperty)
  public
    function GetValue: String; override;
    procedure SetValue(const AValue: String); override;
  end;

  TfrxFDDriverNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    procedure GetValues; override;
    procedure SetValue(const AValue: String); override;
  end;

  TfrxFDConnectionDefNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    procedure GetValues; override;
    procedure SetValue(const AValue: String); override;
  end;

  TfrxFDPackageNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    procedure GetValues; override;
    procedure SetValue(const AValue: String); override;
  end;

  TfrxFDStoredProcNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    procedure GetValues; override;
    procedure SetValue(const AValue: String); override;
  end;

  TfrxFDTableNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    procedure GetValues; override;
    procedure SetValue(const AValue: String); override;
  end;

  TfrxFDIndexNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    procedure GetValues; override;
  end;

  TfrxFDParamsProperty = class(TfrxClassProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
  end;

  TfrxFDMacrosProperty = class(TfrxClassProperty)
  public
    function GetAttributes() :TfrxPropertyAttributes; override;
    function Edit() :Boolean; override;
  end;

{-------------------------------------------------------------------------------}
{ TfrxFDDatabaseProperty                                                        }
{-------------------------------------------------------------------------------}
function TfrxFDDatabaseProperty.GetValue: String;
var
  db: TfrxFDDatabase;
begin
  db := TfrxFDDatabase(GetOrdValue);
  if db = nil then begin
    if (GFDComponents <> nil) and (GFDComponents.DefaultDatabase <> nil) then
      Result := GFDComponents.DefaultDatabase.Name
    else
      Result := frxResources.Get('prNotAssigned');
  end
  else
    Result := inherited GetValue;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDDatabaseProperty.SetValue(const AValue: String);
begin
  inherited SetValue(AValue);
  Designer.UpdateDataTree;
end;

{-------------------------------------------------------------------------------}
{ TfrxFDDriverNameProperty                                                      }
{-------------------------------------------------------------------------------}
function TfrxFDDriverNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDDriverNameProperty.GetValues;
begin
  inherited GetValues;
  FDManager.GetDriverNames(Values);
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDDriverNameProperty.SetValue(const AValue: String);
begin
  inherited SetValue(AValue);
  Designer.UpdateDataTree;
end;

{-------------------------------------------------------------------------------}
{ TfrxFDConnectionDefNameProperty                                               }
{-------------------------------------------------------------------------------}
function TfrxFDConnectionDefNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDConnectionDefNameProperty.GetValues;
begin
  inherited GetValues;
  FDManager.GetConnectionDefNames(Values);
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDConnectionDefNameProperty.SetValue(const AValue: String);
begin
  inherited SetValue(AValue);
  Designer.UpdateDataTree;
end;

{-------------------------------------------------------------------------------}
{ TfrxFDPackageNameProperty                                                     }
{-------------------------------------------------------------------------------}
function TfrxFDPackageNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDPackageNameProperty.GetValues;
begin
  inherited GetValues;
  with TfrxFDStoredProc(Component).StoredProc do
    if Connection <> nil then
      Connection.GetPackageNames(CatalogName, SchemaName, '', Values);
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDPackageNameProperty.SetValue(const AValue: String);
begin
  inherited SetValue(AValue);
  Designer.UpdateDataTree;
end;

{-------------------------------------------------------------------------------}
{ TfrxFDStoredProcNameProperty                                                  }
{-------------------------------------------------------------------------------}
function TfrxFDStoredProcNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProcNameProperty.GetValues;
begin
  inherited GetValues;
  with TfrxFDStoredProc(Component).StoredProc do
    if Connection <> nil then
      Connection.GetStoredProcNames(CatalogName, SchemaName, PackageName, '', Values);
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProcNameProperty.SetValue(const AValue: String);
begin
  inherited SetValue(AValue);
  Designer.UpdateDataTree;
end;

{-------------------------------------------------------------------------------}
{ TfrxFDTableNameProperty                                                       }
{-------------------------------------------------------------------------------}
function TfrxFDTableNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDTableNameProperty.GetValues;
begin
  inherited GetValues;
  with TfrxFDTable(Component).Table do
    if Connection <> nil then
      Connection.GetTableNames(CatalogName, SchemaName, '', Values);
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDTableNameProperty.SetValue(const AValue: String);
begin
  inherited SetValue(AValue);
  Designer.UpdateDataTree;
end;

{-------------------------------------------------------------------------------}
{ TfrxFDIndexNameProperty                                                       }
{-------------------------------------------------------------------------------}
function TfrxFDIndexNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList];
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDIndexNameProperty.GetValues;
var
  i: Integer;
begin
  inherited GetValues;
  try
    with TfrxFDTable(Component).Table do
      if (TableName <> '') and (IndexDefs <> nil) then begin
        IndexDefs.Update;
        for i := 0 to IndexDefs.Count - 1 do
          if IndexDefs[i].Name <> '' then
            Values.Add(IndexDefs[i].Name);
      end;
  except
  end;
end;

{-------------------------------------------------------------------------------}
{ TfrxFDParamsProperty                                                          } 
{-------------------------------------------------------------------------------}
function TfrxFDParamsProperty.Edit: Boolean;
var
  oProc: TfrxCustomStoredProc;
begin
  Result := False;
  oProc := TfrxCustomStoredProc(Component);
  if oProc.Params.Count <> 0 then
    with TfrxParamsEditorForm.Create(Designer) do 
    try
      Params := oProc.Params;
      Result := ShowModal = mrOk;
      if Result then begin
        oProc.UpdateParams;
        Self.Designer.UpdateDataTree;
      end;
    finally
      Free;
    end;
end;

{-------------------------------------------------------------------------------}
function TfrxFDParamsProperty.GetAttributes: TfrxPropertyAttributes;
begin
 Result := [paDialog, paReadOnly];
end;

{-------------------------------------------------------------------------------}
{ TfrxFDMacrosProperty                                                          }
{-------------------------------------------------------------------------------}
function TfrxFDMacrosProperty.Edit() :Boolean;
var
  q :TfrxFDQuery;

begin

 Result := False;
 q := TfrxFDQuery(Component);

 if q.Macros.Count <> 0 then
   with TfrxParamsEditorForm.Create(Designer) do begin

     Params := q.Macros;
     Result := (ShowModal = mrOk);

     if Result then
       q.UpdateParams();

     Free;

   end;

end;

{-------------------------------------------------------------------------------}
function TfrxFDMacrosProperty.GetAttributes() :TfrxPropertyAttributes;
begin
 Result := [paDialog, paReadOnly];
end;

{-------------------------------------------------------------------------------}
{ TfrxFDDatabaseNameProperty                                                    }
{-------------------------------------------------------------------------------}
function TfrxFDDatabaseNameProperty.Edit: Boolean;
var
  lSaveConnected: Boolean;
  oConn: TFDCustomConnection;
begin
  oConn := TfrxFDDatabase(Component).Database;
  lSaveConnected := oConn.Connected;
  oConn.Connected := False;

  Result := ShowConnEditDlg(oConn, TfrxFDDatabase(Component).Name, True);

  if Result then begin
    TfrxFDDatabase(Component).Params.Text := oConn.Params.Text;
{$IFDEF DELPHI21}
    TfrxFDDatabase(Component).DatabaseName := oConn.ResultConnectionDef.Params.Database;
    TfrxFDDatabase(Component).DriverName := oConn.ResultConnectionDef.Params.DriverID;
{$ELSE}
    TfrxFDDatabase(Component).DatabaseName := oConn.ResultConnectionDef.Database;
    TfrxFDDatabase(Component).DriverName := oConn.ResultConnectionDef.DriverID;
{$ENDIF}
    TfrxFDDatabase(Component).ConnectionDefName := oConn.ConnectionDefName;
    TfrxFDDatabase(Component).LoginPrompt := oConn.LoginPrompt;
  end;

  oConn.Connected := lSaveConnected;
end;

{-------------------------------------------------------------------------------}
function TfrxFDDatabaseNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
 Result := [paDialog];
end;

{-------------------------------------------------------------------------------}
function TfrxFDDatabaseNameProperty.ShowConnEditDlg(AConn: TFDCustomConnection;
  const ACaption: String; AHideOptionsTab: Boolean): Boolean;
var
  oFrm: TfrmFDGUIxFormsConnEdit;
begin
  { Show Standard AnyDAC connection dialog 
  improved options should be implemented for:
  a) Hide Connection 'Options Tab' or
     add an optional parameter to TfrmFDGUIxFormsConnEdit.Execute to pass an already
     instantiated TfrmFDGUIxFormsConnEdit object where Specified tabs can be Hidden
     before showing the connection editor
  b) Or Implement the same TFDConnection properties to tfrxFDDatabase so editing
     any advanced options in the Dialog can be assigned to TfrxFDDatabase }
  oFrm := TfrmFDGUIxFormsConnEdit.Create(nil);
  try
    oFrm.tsOptions.TabVisible := not AHideOptionsTab;
    Result := TfrmFDGUIxFormsConnEdit.Execute(AConn, ACaption, oFrm);
  finally
    oFrm.Free;
  end;
end;

{-------------------------------------------------------------------------------}
initialization
  frxPropertyEditors.Register(TypeInfo(String), TfrxFDDataBase, 'DatabaseName',
    TfrxFDDataBaseNameProperty);

  frxPropertyEditors.Register(TypeInfo(String), TfrxFDDatabase, 'DriverName',
    TfrxFDDriverNameProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxFDDatabase, 'ConnectionDefName',
    TfrxFDConnectionDefNameProperty);

  frxPropertyEditors.Register(TypeInfo(TfrxFDDatabase), TfrxFDQuery, 'Database',
    TfrxFDDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(TfrxParams), TfrxFDQuery, 'Macros',
    TfrxFDMacrosProperty);

  frxPropertyEditors.Register(TypeInfo(TfrxFDDatabase), TfrxFDTable, 'Database',
    TfrxFDDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxFDTable, 'TableName',
    TfrxFDTableNameProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxFDTable, 'IndexName',
    TfrxFDIndexNameProperty);

  frxPropertyEditors.Register(TypeInfo(TfrxFDDatabase), TfrxFDStoredProc, 'Database',
    TfrxFDDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxFDStoredProc, 'PackageName',
    TfrxFDPackageNameProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxFDStoredProc, 'StoredProcName',
    TfrxFDStoredProcNameProperty);
  frxPropertyEditors.Register(TypeInfo(TfrxParams), TfrxCustomStoredProc, 'Params',
    TfrxFDParamsProperty);
end.
