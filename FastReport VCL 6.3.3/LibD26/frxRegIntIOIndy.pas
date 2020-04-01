
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

unit frxRegIntIOIndy;

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
  frxIOTransportFTP, frxIOTransportDropboxIndy, frxIOTransportOneDriveIndy, 
  frxIOTransportBoxComIndy, frxIOTransportGoogleDriveIndy;

procedure Register;
begin
  RegisterComponents('FastReport 6.0 Internet transports',
    [TfrxFTPIOTransport, TfrxDropboxIOTransportIndy, TfrxOneDriveIOTransportIndy, TfrxBoxComIOTransportIndy, TfrxGoogleDriveIOTransportIndy]);
end;

end.
