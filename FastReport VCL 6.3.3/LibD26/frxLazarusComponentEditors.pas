
{******************************************}
{                                          }
{             FastReport v5.0              }
{            Registration unit             }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxLazarusComponentEditors;

{$I frx.inc}
//{$I frxReg.inc}

interface


procedure Register;

implementation

uses
  SysUtils, Classes, Graphics, Controls, Forms,
  LazarusPackageIntf, ComponentEditors,
  Dialogs, frxClass, frxEditAliases, PropEdits, LResources;


{-----------------------------------------------------------------------}
type
  TfrxReportEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): String; override;
    function GetVerbCount: Integer; override;
  end;

  TfrxDataSetEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): String; override;
    function GetVerbCount: Integer; override;
  end;


{ TfrxReportEditor }

procedure TfrxReportEditor.ExecuteVerb(Index: Integer);
var
  Report: TfrxReport;
begin
  Report := TfrxReport(Component);
  if Report.Designer <> nil then
    Report.Designer.BringToFront
  else
  begin
    Report.DesignReport(Designer, Self);
    if Report.StoreInDFM then
      Designer.Modified;
  end;
end;

function TfrxReportEditor.GetVerb(Index: Integer): String;
begin
  Result := 'Edit Report...';
end;

function TfrxReportEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


{ TfrxDataSetEditor }

procedure TfrxDataSetEditor.ExecuteVerb(Index: Integer);
begin
  with TfrxAliasesEditorForm.Create(Application) do
  begin
    DataSet := TfrxCustomDBDataSet(Component);
    if ShowModal = mrOk then
      Self.Designer.Modified;
    Free;
  end;
end;

function TfrxDataSetEditor.GetVerb(Index: Integer): String;
begin
  Result := 'Edit Fields Aliases...';
end;

function TfrxDataSetEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


{-----------------------------------------------------------------------}
procedure Register;
begin
  RegisterComponentEditor(TfrxReport, TfrxReportEditor);
  RegisterComponentEditor(TfrxCustomDBDataSet, TfrxDataSetEditor);
end;

initialization
{$INCLUDE frx_ireg.lrs}

end.

