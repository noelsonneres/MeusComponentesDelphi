
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Registration unit             }
{                                          }
{  (c) 2003-2019 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_ifdreg;

{$i fs.inc}

interface


procedure Register;

implementation

uses
  Classes, DesignIntf, Controls, fs_ifdrtti;

{-----------------------------------------------------------------------}

procedure Register;
begin
  RegisterComponents('FastScript', [TfsFDRTTI]);
end;

end.
