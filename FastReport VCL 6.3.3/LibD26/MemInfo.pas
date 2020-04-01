unit MemInfo;

interface

uses
  Windows;

type
  PROCESS_MEMORY_COUNTERS_EX = packed record
    cb: DWORD;
    PageFaultCount: DWORD;
    PeakWorkingSetSize: DWORD;
    WorkingSetSize: DWORD;
    QuotaPeakPagedPoolUsage: DWORD;
    QuotaPagedPoolUsage: DWORD;
    QuotaPeakNonPagedPoolUsage: DWORD;
    QuotaNonPagedPoolUsage: DWORD;
    PageFileUsage: DWORD;
    PeakPageFileUsage: DWORD;
    PrivateUsage: DWORD;
  end;

  TGetProcessMemoryInfo = function (Process: THandle; out Counters; cb: DWORD): BOOL stdcall;

function GetPrivateMemoryUsage: DWORD;
function GetMemInfo: PROCESS_MEMORY_COUNTERS_EX;

implementation

var
  hPSAPI: THandle;
  _GetProcessMemoryInfo: TGetProcessMemoryInfo;

function GetProcessMemoryInfo(Process: THandle; out Counters; cb: DWORD): BOOL;
begin
  Result := _GetProcessMemoryInfo(Process, Counters, cb)
end;

function GetMemInfo: PROCESS_MEMORY_COUNTERS_EX;
begin
  Assert(GetProcessMemoryInfo(GetCurrentProcess, Result, SizeOf(Result)))
end;

function GetPrivateMemoryUsage: DWORD;
begin
  Result := GetMemInfo.PrivateUsage
end;

initialization

hPSAPI := LoadLibrary('PSAPI.dll');
Assert(hPSAPI >= 32);
@_GetProcessMemoryInfo := GetProcAddress(hPSAPI, 'GetProcessMemoryInfo');

end.
