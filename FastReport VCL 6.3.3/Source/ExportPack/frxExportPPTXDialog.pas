
{******************************************}
{                                          }
{             FastReport v6.0              }
{            PPTX export dialog            }
{                                          }
{         Copyright (c) 1998-2017          }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportPPTXDialog;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, frxExportBaseDialog
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxPPTXExportDialog = class(TfrxBaseExportDialog)
  end;

implementation

{$R *.dfm}

end.
