
{******************************************}
{                                          }
{             FastReport v6.0              }
{            Registration unit             }
{                                          }
{         Copyright (c) 1998-2017          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxReg;

{$I frx.inc}
//{$I frxReg.inc}

interface


procedure Register;

implementation

uses
{$IFNDEF FPC}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
{$IFNDEF Delphi6}
  DsgnIntf,
{$ELSE}
  DesignIntf, DesignEditors,
{$ENDIF}
{$IFDEF Delphi9}
  ToolsAPI,
{$ENDIF}
  Dialogs, frxClass, 
  frxDock, frxCtrls, frxDesgnCtrls,
  frxDesgn, frxPreview, frxRes,
  frxRich, 
  frxOLE, frxBarCode,
  frxChBox, frxDMPExport, 
{$IFNDEF FR_VER_BASIC}
  frxDCtrl, 
{$ENDIF}
{$IFNDEF RAD_ED}
  frxGaugePanel, frxCross, frxGaugeView, frxTableObject, frxMap, frxCellularTextObject,
{$ENDIF}
{$IFNDEF WIN64}
 frxRichEdit, 
{$ENDIF}
frxGradient,
  frxGZip, frxEditAliases, 
{$IFNDEF WIN64}
frxCrypt
{$ENDIF}
{$IFDEF RAD_ED}
{$IFDEF Delphi22}
 , frxEULAForm , Registry 
{$ENDIF}
{$ENDIF}
{$ELSE}
SysUtils, Classes, Graphics, Controls, Forms,
PropEdits, LazarusPackageIntf, LResources,
ComponentEditors,
frxLazarusComponentEditors,
Dialogs, frxClass,
frxDock, frxCtrls, frxDesgnCtrls,
frxDesgn, frxPreview, frxRes,
frxDBSet,
frxBarCode,
frxChBox,
frxGaugePanel,
frxMap,
frxDCtrl,
frxCross, frxGaugeView, frxTableObject, frxCellularTextObject,
frxGradient,
frxGZip, frxEditAliases,
frxCrypt

{$ENDIF}
;
{$IFNDEF FPC}
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
{$IFDEF RAD_ED}
{$IFDEF Delphi22}
  mRes: Boolean;
  reg: TRegistry;
{$ENDIF}
{$ENDIF}
begin
  Report := TfrxReport(Component);
{$IFDEF RAD_ED}
{$IFDEF Delphi22}
  reg := TRegistry.Create;
  mRes := false;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey('\Software\Fast Reports\XE8', true) then
      try
        mRes := reg.ReadBool('EULA');
      except
        mRes := False;
      end;
    if not mRes then
    begin
      with TfrxEULAConfirmForm.Create(nil) do
		  begin
		    mRes := (ShowModal = mrOk);
		    if mRes then
			    reg.WriteBool('EULA', true);
		    Free;
		  end;
	  end;
  finally
		reg.Free;
  end;
	if not mRes then Exit;
{$ENDIF}
{$ENDIF}
  
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
  Result := frxResources.Get('rpEditRep');
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
  Result := frxResources.Get('rpEditAlias');
end;

function TfrxDataSetEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;
{$ENDIF}

{-----------------------------------------------------------------------}
procedure Register;
begin
{$IFNDEF FPC}
{$IFDEF Delphi9}
  ForceDemandLoadState(dlDisable);
  SplashScreenServices.AddPluginBitmap('Fast Report ' +{$I frxVersion.inc},
    LoadBitmap(HInstance, 'SPLASH_ICON'), False, 'Registered');
{$ENDIF}

{$IFDEF DELPHI16}
//  StartClassGroup(TControl);
//  ActivateClassGroup(TControl);
//  GroupDescendentsWith(TfrxReport, TControl);
//  GroupDescendentsWith(TfrxUserDataSet, TControl);
//  GroupDescendentsWith(TfrxRichObject, TControl);
//  GroupDescendentsWith(TfrxCrypt, TControl);
//  GroupDescendentsWith(TfrxCheckBoxObject, TControl);
//  GroupDescendentsWith(TfrxGradientObject, TControl);
//  GroupDescendentsWith(TfrxGZipCompressor, TControl);
//  GroupDescendentsWith(TfrxDotMatrixExport, TControl);
//  GroupDescendentsWith(TfrxBarCodeObject, TControl);
//  GroupDescendentsWith(TfrxOLEObject, TControl);
  
//  GroupDescendentsWith(TfrxDockSite, TControl);
//  GroupDescendentsWith(TfrxTBPanel, TControl);
//  GroupDescendentsWith(TfrxComboEdit, TControl);
//  GroupDescendentsWith(TfrxComboBox, TControl);
//  GroupDescendentsWith(TfrxFontComboBox, TControl);
//  GroupDescendentsWith(TfrxRuler, TControl);
//  GroupDescendentsWith(TfrxScrollBox, TControl);
{$ENDIF}

  RegisterComponents('FastReport 6.0',
    [TfrxReport, TfrxUserDataset,
{$IFNDEF FR_VER_BASIC}
{$IFNDEF ACADEMIC_ED}
     TfrxDesigner,
{$ENDIF}
{$ENDIF}
     TfrxPreview,
     TfrxBarcodeObject, TfrxOLEObject,
{$IFNDEF WIN64}
     TfrxRichObject,
{$ENDIF}
{$IFNDEF RAD_ED}
     TfrxGaugePanel, TfrxIntervalGaugePanel, TfrxCrossObject, TfrxGaugeObject, TfrxReportTableObject, TfrxMapObject, TfrxReportCellularTextObject, 
{$ENDIF}
     TfrxCheckBoxObject, TfrxGradientObject,
     TfrxDotMatrixExport
{$IFNDEF FR_VER_BASIC}
   , TfrxDialogControls
{$ENDIF}     
   , TfrxGZipCompressor
{$IFNDEF WIN64}
, TfrxCrypt
{$ENDIF}
     ]);
{$ELSE}
  RegisterComponents('FastReport 6.0',[
    TfrxReport, TfrxUserDataset, TfrxDesigner, TfrxPreview,
    TfrxDBDataSet,
    TfrxBarcodeObject, TfrxGaugePanel, TfrxIntervalGaugePanel,
    TfrxCrossObject, TfrxGaugeObject, TfrxReportTableObject, TfrxReportCellularTextObject,
     TfrxMapObject, TfrxCheckBoxObject, TfrxGradientObject,
     TfrxDialogControls, TfrxGZipCompressor, TfrxCrypt
    ]);
{$ENDIF}
  RegisterComponents('FR6 tools',
    [TfrxDockSite, TfrxTBPanel, TfrxComboEdit,
     TfrxComboBox, TfrxFontComboBox, TfrxRuler, TfrxScrollBox, TfrxColorComboBox]);


  {$IFNDEF FPC}
  RegisterComponentEditor(TfrxReport, TfrxReportEditor);
  RegisterComponentEditor(TfrxCustomDBDataSet, TfrxDataSetEditor);
  {$ENDIF}
end;

{$IFDEF FPC}
initialization
  {$INCLUDE frx_ireg.lrs}
{$ENDIF}

end.
