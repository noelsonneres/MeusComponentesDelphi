unit frxFPUMask;

interface

uses Math;

{$I frx.inc}
var
  OriginalExceptionMask: TFPUExceptionMask;

implementation

initialization
  OriginalExceptionMask := GetExceptionMask;

end.
