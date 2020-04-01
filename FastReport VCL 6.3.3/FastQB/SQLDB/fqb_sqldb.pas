{ Этот файл был автоматически создан Lazarus. Не редактировать!
Исходный код используется только для компиляции и установки пакета.
 }

unit fqb_sqldb; 

interface

uses
  fqbSqlDBEngine, fqbRegSqlDB, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('fqbRegSqlDB', @fqbRegSqlDB.Register); 
end; 

initialization
  RegisterPackage('fqb_sqldb', @Register); 
end.
