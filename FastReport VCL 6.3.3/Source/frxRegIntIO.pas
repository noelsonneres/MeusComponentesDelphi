
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

unit frxRegIntIO;

{$I frx.inc}

interface


procedure Register;

implementation

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
{$IFNDEF Delphi6}
  DsgnIntf,
{$ELSE}
  DesignIntf, DesignEditors,
{$ENDIF}
  frxIOTransportDropbox, frxIOTransportOneDrive, 
  frxIOTransportBoxCom, frxIOTransportGoogleDrive;

procedure Register;
begin
  RegisterComponents('FastReport 6.0 Internet transports',
    [TfrxDropboxIOTransport, TfrxOneDriveIOTransport, TfrxBoxComIOTransport, TfrxGoogleDriveIOTransport]);
end;

end.
