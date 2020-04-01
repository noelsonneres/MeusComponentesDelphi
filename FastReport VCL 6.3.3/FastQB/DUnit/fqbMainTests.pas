unit fqbMainTests;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TestFrameWork, fqbClass, fqbBDEEngine, fqbUtils;

type
  TfqbShifrTests = class(TTestCase)
  published
    procedure TestFqbTrim;
    procedure TestCRC32;
    procedure TestUniqueFileName;
    procedure TestComressDecompress;
  end;

  TfqbObjectTests = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSQL;
    procedure TestFieldName;
    procedure TestFieldList;
    procedure TestLinkList;
    procedure TestLinkSellect;
    procedure TestNotification;
    procedure TestTableDel;
    procedure TestClear;
    procedure TestResize;
    procedure TestExchange;
  end;

  TfqbBugTests = class(TTestCase)
  published
    procedure Test0000022;
    procedure Test10188;
    procedure Test000027;
  end;

  crTfqbTableArea = class (TfqbTableArea);
  crTfqbTable = class (TfqbTable);
  crTfqbLink = class (TfqbLink);
  crTfqGrid = class (TfqbGrid);
  ctTfqbCheckListBox = class (TfqbCheckListBox);

implementation

uses DBTables, ComCtrls;

{ TfqbTests }

procedure TfqbObjectTests.SetUp;
begin
  inherited;
end;

procedure TfqbObjectTests.TearDown;
begin
  inherited;
end;

procedure TfqbObjectTests.TestClear;
  var
    frm: TForm;
    ar: TfqbTableArea;
    eng: TfqbBDEEngine;
    gr: TfqbGrid;
    db: TDatabase;
begin
  frm := TForm.Create(nil);
  db:= TDatabase.Create(frm);
  db.DatabaseName := 'test2';
  db.AliasName := 'BCDEMOS';

  ar := TfqbTableArea.Create(frm);

  ar.Parent := frm;

  eng := TfqbBDEEngine.Create(frm);

  gr := TfqbGrid.Create(frm);
  gr.Parent := frm;

  fqbCore.Engine := eng;
  fqbCore.TableArea := ar;
  fqbCore.Grid := gr;
  eng.DatabaseName := db.DatabaseName;

  ar.InsertTable('country.db');
  gr.AddColumn;

  fqbCore.Clear;

  Check(ar.ComponentCount = 0, 'Error clear table!');
  Check(crTfqGrid(gr).Items.Count = 0, 'Error clear grid!');

  db.Free;
  frm.Free;
end;

procedure TfqbObjectTests.TestExchange;
  var
    tmp: TfqbGrid;
    frm: TForm;
    itm: TListItem;
begin
  frm:= TForm.Create(nil);

  tmp := TfqbGrid.Create(frm);
  tmp.Parent := frm;

  itm := tmp.Items.Add;
  itm.Caption := 'Item1';
  itm.Data := Pointer(1);

  itm := tmp.Items.Add;
  itm.Caption := 'Item2';
  itm.Data := Pointer(2);

  tmp.Exchange(0, 1);

  CheckEquals(tmp.Items[0].Caption, 'Item2');
  CheckEquals(tmp.Items[1].Caption, 'Item1');

  frm.Free;
end;

procedure TfqbObjectTests.TestFieldList;
  var
    tmp: TfqbFieldList;
begin
  tmp:= TfqbFieldList.Create(nil, TfqbField);
  tmp.Add;
  Check(tmp.Count = 1, 'Error in TfqbFieldList');
  tmp[0].FieldName:= 'Test';
  tmp.Free
end;

procedure TfqbObjectTests.TestFieldName;
  var
    tmp: TfqbField;
begin
  tmp:= TfqbField.Create(nil);
  tmp.FieldName:= 'Test';
  Check(tmp.FieldName = 'Test','Error in TfqbField.GetFieldName');
  tmp.FieldName:= 'New Test';
  Check(tmp.FieldName = '"New Test"','Error in TfqbField.GetFieldName');
  tmp.Free;
end;

procedure TfqbObjectTests.TestLinkList;
  var
    tmp: TfqbLinkList;
    tbl: TfqbField;
begin
  tbl := TfqbField.Create(nil);
  tmp:= TfqbLinkList.Create(nil, TfqbLink);
  tmp.Add;
  crTfqbLink(tmp[0]).FDestField := tbl;
  crTfqbLink(tmp[0]).FSourceField := tbl;

  Check(tmp.Count = 1, 'Error in TfqbLinkList');
  tmp.Free;
  tbl.Free
end;

procedure TfqbObjectTests.TestLinkSellect;
  var
    tmp: TfqbLinkList;
    tbl: TfqbField;
begin
  tbl := TfqbField.Create(nil);
  tmp:= TfqbLinkList.Create(nil, TfqbLink);
  tmp.Add;
  tmp.Add;
  tmp.Add;

  crTfqbLink(tmp[0]).FDestField := tbl;
  crTfqbLink(tmp[0]).FSourceField := tbl;
  crTfqbLink(tmp[1]).FDestField := tbl;
  crTfqbLink(tmp[1]).FSourceField := tbl;
  crTfqbLink(tmp[2]).FDestField := tbl;
  crTfqbLink(tmp[2]).FSourceField := tbl;

  tmp[1].Selected := true;
  CheckTrue(tmp[1].Selected, 'Error in SetSelected #1');
  tmp[2].Selected := true;
  CheckFalse(tmp[1].Selected, 'Error in SetSelected #2');
  CheckFalse(tmp[0].Selected, 'Error in SetSelected #3');
  CheckTrue(tmp[2].Selected, 'Error in SetSelected #4');
  tmp.Free;
  tbl.Free
end;

procedure TfqbObjectTests.TestNotification;
  var
    tmpDlg: TfqbDialog;
    tmpEng: TfqbBDEEngine;
begin
  tmpDlg := TfqbDialog.Create(nil);
  tmpEng := TfqbBDEEngine.Create(nil);

  tmpDlg.Engine := tmpEng;
  tmpEng.Free;
  CheckNull(tmpDlg.Engine, 'Error - Not notification!');
  tmpDlg.Free
end;


procedure TfqbObjectTests.TestResize;
  var
    tmp: TfqbGrid;
    frm: TForm;
    s1 : Integer;

  function GetSumWidth: Integer;
    var
      i: Integer;
  begin
    Result := 0;
    for i:= 0 to tmp.Columns.Count - 1 do
      Result := tmp.Column[i].Width + Result
  end;

begin
  Exit;
  frm := TForm.Create(nil);
  tmp := TfqbGrid.Create(frm);
  tmp.Parent := frm;
  tmp.Anchors := tmp.Anchors + [akRight];

  s1 := GetSumWidth;
  CheckEquals(s1, tmp.Width);

  tmp.Width := 400;

  s1 := GetSumWidth;
  Check(s1 > tmp.Width);

  frm.Width := frm.Width + 40;

  s1 := GetSumWidth;
  Check(s1 > tmp.Width);

  frm.ShowModal;

  FreeAndNil(frm);
end;

procedure TfqbObjectTests.TestSQL;
var
  dlg: TfqbDialog;
  tmp1, tmp2: string;
begin
  dlg := TfqbDialog.Create(nil);

  tmp1 := 'SELECT i.ItemNo, i.PartNo FROM items.db i'#$D#$A;
  tmp2 := '/*_FQBMODEL'#$D#$A'eAGLdkksSXRKLE6N5eVycbJ1cXJx9fUP5uUKDvSxNTIyMTI2MbA0MOTlig5JTMpJLQaqyrTNLEnNLdZLSdIxNdIxAiIDAx1DUwOgGveizBSgCk+gvF8+QlmmjqGOARjycgUkFpXgkov2yczLBlkBANqbKHk='#$D#$A'_FQBEND*/';

  dlg.SchemaInsideSQL := True;

  dlg.SQL := tmp1 + tmp2;

  CheckEquals(tmp1 + tmp2, dlg.SQL, 'Error dlg.SchemaInsideSQL := True');

  dlg.SchemaInsideSQL := False;
  CheckEquals(tmp1, dlg.SQL, 'Eror eng.SchemaInsideSQL := False');

  tmp2 := 'eAGLdkksSXRKLE6N5eVycbJ1cXJx9fUP5uUKDvSxNTIyMTI2MbA0MOTlig5JTMpJLQaqyrTNLEnNLdZLSdIxNdIxAiIDAx1DUwOgGveizBSgCk+gvF8+QlmmjqGOARjycgUkFpXgkov2yczLBlkBANqbKHk=';
  CheckEquals(tmp2, dlg.SQLSchema, 'Error dlg.SchemaInsideSQL := False');

  dlg.Free;
end;

procedure TfqbObjectTests.TestTableDel;
  var
    frm: TForm;
    ar: TfqbTableArea;
    eng: TfqbBDEEngine;
    gr: TfqbGrid;
begin
  frm := TForm.Create(nil);
  ar := TfqbTableArea.Create(frm);

  gr := TfqbGrid.Create(frm);
  gr.Parent := frm;

  ar.Parent := frm;
  eng := TfqbBDEEngine.Create(frm);
  fqbCore.Engine := eng;
  fqbCore.Grid := gr;
  fqbCore.TableArea := ar; 

  eng.DatabaseName := 'BCDEMOS';

  ar.InsertTable('country.db');
  Check(ar.ComponentCount = 1, 'Error insert table!');
  crTfqbTable(ar.Components[0]).ChBox.Checked[2]:= True;
  ctTfqbCheckListBox(crTfqbTable(ar.Components[0]).ChBox).ItemIndex := 2;
  ctTfqbCheckListBox(crTfqbTable(ar.Components[0]).ChBox).ClickCheck;
  Check(gr.Items.Count = 1, 'Error');
  crTfqbTable(ar.Components[0]).Free;
  Check(ar.ComponentCount = 0, 'Error delete table!');
  Check(gr.Items.Count = 0, 'Error');

  frm.Free;
end;

{ TfqbShifrTests }

procedure TfqbShifrTests.TestComressDecompress;
  var s, s2, s3: string;
begin
  s := 'Test string for comress. procedure TfqbShifrTests.TestComressDecompress';
  s2 := fqbCompress(s);
  s3 := fqbDeCompress(s2);
  CheckEquals(s,s3,'Error in compress/decomress agoritm');
end;

procedure TfqbShifrTests.TestCRC32;
  var
    c,c2: Cardinal;
begin
  c:= fqbStringCRC32('Test');
  Check(c = 2018365746, 'Error in CRC32');
  c2:= fqbStringCRC32('Anozer Test');
  CheckNotEquals(c, c2, 'Error in CRC32');
end;

procedure TfqbShifrTests.TestFqbTrim;
  var
    tmp: string;
begin
  tmp:= '222'#10#13'2222'#10'2222'#13'2222'#10#13#13#10;
  tmp := fqbTrim(tmp, [#10,#13]);
  CheckEquals(tmp, '222222222222222', 'Error in fqbTrim');

  tmp := 'asdas  asdas      asd';
  tmp := fqbTrim(tmp, [#10,#13]);
  CheckEquals(tmp, 'asdas asdas asd', 'Error in fqbTrim');
end;

procedure TfqbShifrTests.TestUniqueFileName;
  var
    str1, str2 : string;
begin
  str1 := fqbGetUniqueFileName('fqb');
  str2 := fqbGetUniqueFileName('fqb');
  CheckNotEquals(str1, str2, 'Error create UniqueFileName'); 
end;

procedure TfqbBugTests.Test0000022;
  var
    frm: TForm;
    ar: TfqbTableArea;
    eng: TfqbBDEEngine;
    gr: TfqbGrid;
    db: TDatabase;
    tbl: TfqbTableListBox;
begin
{http://localhost/mantis/view.php?id=22}
  frm := TForm.Create(nil);
  db:= TDatabase.Create(frm);
  db.DatabaseName := 'test__';
  db.AliasName := 'BCDEMOS';

  ar := TfqbTableArea.Create(frm);
  ar.Parent := frm;

  tbl:= TfqbTableListBox.Create(frm);
  tbl.Parent:= frm;

  eng := TfqbBDEEngine.Create(frm);

  gr := TfqbGrid.Create(frm);
  gr.Parent := frm;

  fqbCore.Engine := eng;
  fqbCore.TableArea := ar;
  fqbCore.Grid := gr;
  eng.DatabaseName := db.DatabaseName;

  fqbCore.LoadFromFile('test1.sql');
  Check(ar.ComponentCount = 1,'Load script fail');
  Check(gr.Items.Count = 2,'Load script fail');

  fqbCore.Clear;

  fqbCore.LoadFromFile('test2.sql');
  Check(ar.ComponentCount = 2,'Load script fail');
  Check(gr.Items.Count = 3,'Load script fail');
  CheckNotEquals(ar.LinkList.Items[0].SourceField.FieldName, ar.LinkList.Items[0].DestField.FieldName, 'Bug not fix');

  frm.Free;
end;


procedure TfqbBugTests.Test000027;
  var
    frm: TForm;
    ar: TfqbTableArea;
    eng: TfqbBDEEngine;
    gr: TfqbGrid;
    tbl: TfqbTableListBox;
    sql, schema: string;
begin
{http://frx:8089/mantis/view.php?id=27}
  frm := TForm.Create(nil);

  ar := TfqbTableArea.Create(frm);
  ar.Parent := frm;

  tbl:= TfqbTableListBox.Create(frm);
  tbl.Parent:= frm;

  eng := TfqbBDEEngine.Create(frm);
  eng.DatabaseName := 'BCDEMOS';

  gr := TfqbGrid.Create(frm);
  gr.Parent := frm;

  fqbCore.Engine := eng;
  fqbCore.TableArea := ar;
  fqbCore.Grid := gr;
  fqbCore.SchemaInsideSQL := false;

  ar.InsertTable('country.db');
  crTfqbTable(ar.Components[0]).ChBox.Checked[0]:= True;
  ctTfqbCheckListBox(crTfqbTable(ar.Components[0]).ChBox).ItemIndex := 0;
  ctTfqbCheckListBox(crTfqbTable(ar.Components[0]).ChBox).ClickCheck;

  ar.InsertTable('customer.db');
  crTfqbTable(ar.Components[1]).ChBox.Checked[0]:= True;
  ctTfqbCheckListBox(crTfqbTable(ar.Components[1]).ChBox).ItemIndex := 0;
  ctTfqbCheckListBox(crTfqbTable(ar.Components[1]).ChBox).ClickCheck;

  fqbCore.GenerateSQL;
  sql := fqbCore.SQL;
  schema := fqbCore.SQLSchema;
end;

procedure TfqbBugTests.Test10188;
  var
    frm: TForm;
    ar: TfqbTableArea;
    eng: TfqbBDEEngine;
    gr: TfqbGrid;
    tbl: TfqbTableListBox;
    str: TStringList;
begin
{http://www.fast-report.com/bitrix/admin/ticket_edit.php?ID=10188&lang=ru}
  frm := TForm.Create(nil);

  ar := TfqbTableArea.Create(frm);
  ar.Parent := frm;

  tbl:= TfqbTableListBox.Create(frm);
  tbl.Parent:= frm;

  eng := TfqbBDEEngine.Create(frm);
  eng.DatabaseName := 'BCDEMOS';

  gr := TfqbGrid.Create(frm);
  gr.Parent := frm;

  fqbCore.Engine := eng;
  fqbCore.TableArea := ar;
  fqbCore.Grid := gr;

  ar.InsertTable('country.db');
  crTfqbTable(ar.Components[0]).ChBox.Checked[0]:= True;
  ctTfqbCheckListBox(crTfqbTable(ar.Components[0]).ChBox).ItemIndex := 0;
  ctTfqbCheckListBox(crTfqbTable(ar.Components[0]).ChBox).ClickCheck;

  ar.InsertTable('customer.db');
  crTfqbTable(ar.Components[1]).ChBox.Checked[0]:= True;
  ctTfqbCheckListBox(crTfqbTable(ar.Components[1]).ChBox).ItemIndex := 0;
  ctTfqbCheckListBox(crTfqbTable(ar.Components[1]).ChBox).ClickCheck;

  str := TStringList.Create;
  fqbCore.SaveToStr(Str);
  fqbCore.Clear;
  fqbCore.LoadFromStr(Str);

  CheckTrue(crTfqbTable(ar.Components[0]).ChBox.Checked[0], 'Table 1 * not selected');
  CheckTrue(crTfqbTable(ar.Components[1]).ChBox.Checked[0], 'Table 2 * not selected');  

  str.Free;
  frm.Free;
end;

initialization

  TestFramework.RegisterTest('MainTests Suite',
    TfqbObjectTests.Suite);

  TestFramework.RegisterTest('ShifrTests Suite',
      TfqbShifrTests.Suite);

  TestFramework.RegisterTest('BugTests Suite',
      TfqbBugTests.Suite);

end.


