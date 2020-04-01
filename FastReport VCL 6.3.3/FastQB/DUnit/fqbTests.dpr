// Uncomment the following directive to create a console application
// or leave commented to create a GUI application...
{$IFDEF CONSOLE}
  {$APPTYPE CONSOLE}
{$ENDIF}

program fqbTests;

uses
  TestFramework {$IFDEF LINUX},
  QForms,
  QGUITestRunner {$ELSE},
  Forms,
  GUITestRunner {$ENDIF},
  TextTestRunner,
  fqbMainTests in 'fqbMainTests.pas',
  fqbClass in '..\fqbClass.pas';

{$R *.RES}

begin
  Application.Initialize;


{$IFDEF LINUX}
  QGUITestRunner.RunRegisteredTests;
{$ELSE}
  if System.IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
{$ENDIF}

end.

 