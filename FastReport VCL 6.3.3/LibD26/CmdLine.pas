unit CmdLine;

interface

uses
  Classes,
  SysUtils;

function ArgCount: Integer;
function ArgName(i: Integer): string;
function ArgValue(i: Integer): string; overload;
function ArgValue(Name: string): string; overload;
function ArgValue(Name, Default: string): string; overload;
function ArgIndex(Name: string): Integer;
function ArgExists(Name: string): Boolean;
function ArgsByName(List: TStrings; Name: string): Boolean;

implementation

var
  Props, Values: TStrings;

procedure ReadCmdArgs;

  procedure AddCmdArg(s: string);
  var
    p: Integer;
  begin
    p := Pos(':', s);

    if p = 0 then
      Exit;

    Props.Add(Copy(s, 1, p - 1));
    Values.Add(Copy(s, p + 1));
  end;

var
  i: Integer;
begin
  for i := 1 to ParamCount do
    AddCmdArg(ParamStr(i))
end;

function ArgCount: Integer;
begin
  Result := Props.Count
end;

function ArgName(i: Integer): string;
begin
  Result := Props[i - 1]
end;

function ArgValue(i: Integer): string;
begin
  Result := Values[i - 1]
end;

function ArgIndex(Name: string): Integer;
begin
  for Result := 1 to ArgCount do
    if ArgName(Result) = Name then
      Exit;

  Result := 0
end;

function ArgExists(Name: string): Boolean;
begin
  Result := ArgIndex(Name) > 0
end;

function ArgValue(Name: string): string;
begin
  Result := ArgValue(ArgIndex(Name))
end;

function ArgValue(Name, Default: string): string;
begin
  if ArgExists(Name) then
    Result := ArgValue(Name)
  else
    Result := Default
end;

function ArgsByName(List: TStrings; Name: string): Boolean;
var
  i: Integer;
begin
  List.Clear;

  for i := 1 to ArgCount do
    if ArgName(i) = Name then
      List.Add(ArgValue(i));

  Result := List.Count > 0
end;

initialization

Props := TStringList.Create;
Values := TStringList.Create;

ReadCmdArgs;

finalization

Props.Free;
Values.Free;

end.
