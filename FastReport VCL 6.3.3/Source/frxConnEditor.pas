
{******************************************}
{                                          }
{             FastReport v5.0              }
{          Connection list editor          }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxConnEditor;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, frxClass, frxConnItemEdit
  {$IFDEF FPC}
  , LCLType
  {$ENDIF}
{$IFDEF FR_FIB}
  , ADODB, frxConnType, frxFIBConnItemEdit, frxFIBComponents
{$ENDIF}
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxConnEditorForm = class(TForm)
    NewB: TButton;
    DeleteB: TButton;
    ConnLV: TListView;
    OKB: TButton;
    EditB: TButton;
    TestB: TButton;
    procedure NewBClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DeleteBClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure OKBClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditBClick(Sender: TObject);
    procedure TestBClick(Sender: TObject);
  private
    { Private declarations }
    {$IFNDEF FPC}
    procedure ReadADOConnections;
    procedure SaveADOConnections;
    {$ENDIF}
{$IFDEF FR_FIB}
    procedure ReadFIBConnections;
    procedure SaveFIBConnections;
{$ENDIF}
  public
    { Public declarations }
    Report: TfrxReport;
  end;


implementation
{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

uses
  frxRes
  {$IFNDEF FPC}, frxDesgn, IniFiles, Registry{$ENDIF}{$IFDEF FR_FIB}, FIBDatabase{$ENDIF};

procedure TfrxConnEditorForm.FormShow(Sender: TObject);
begin
  Caption := frxGet(5800);
  NewB.Caption := frxGet(5801);
  DeleteB.Caption := frxGet(5802);
  OKB.Caption := frxResources.Get('clClose');
  EditB.Caption := frxGet(132);
  ConnLV.Columns[0].Caption := frxResources.Get('cpName');
//  ConnLV.Columns[2].Caption := frxResources.Get('cpConnStr');
  {$IFNDEF FPC}
  ReadADOConnections;
  {$ENDIF}
{$IFDEF FR_FIB}
  ReadFIBConnections;
{$ENDIF}
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

procedure TfrxConnEditorForm.FormHide(Sender: TObject);
begin
  if ModalResult <> mrOk then Exit;
  {$IFNDEF FPC}
  SaveADOConnections;
  {$ENDIF}
{$IFDEF FR_FIB}
  SaveFIBConnections;
{$ENDIF}
end;

procedure TfrxConnEditorForm.NewBClick(Sender: TObject);
var
  li: TListItem;
{$IFDEF FR_FIB}
  fib: TfrxFIBDatabase;
{$ENDIF}
begin
{$IFDEF FR_FIB}
  frxConnTypeEdit := TfrxConnTypeEdit.Create(Self);
  try
    if frxConnTypeEdit.ShowModal = mrOk then
    begin
      if frxConnTypeEdit.ADOCB.Checked then
      begin
{$ENDIF}
        frxConnectionItemEdit := TfrxConnectionItemEdit.Create(Self);
        try
          frxConnectionItemEdit.Report := Report;
          if frxConnectionItemEdit.ShowModal = mrOk then
          begin
            li := ConnLV.Items.Add;
            li.Caption := frxConnectionItemEdit.NameE.Text;
            if frxConnectionItemEdit.SystemRB.Checked then
              li.SubItems.Add('System')
            else
              li.SubItems.Add('User');
            li.SubItems.Add('ADO Database');
            li.SubItems.Add(frxConnectionItemEdit.ConnE.Text);
            ConnLV.Selected := li;
          end;
        finally
          frxConnectionItemEdit.Free;
        end;
{$IFDEF FR_FIB}
      end else
      if frxConnTypeEdit.FIBCB.Checked then
      begin
        frxFIBConnItem := TfrxFIBConnItem.Create(Self);
        fib := TfrxFIBDatabase.Create(nil);
        frxFIBConnItem.LibE.Text := fib.Database.LibraryName;
        try
          if frxFIBConnItem.ShowModal = mrOk then
          begin
            li := ConnLV.Items.Add;
            li.Caption := frxFIBConnItem.NameE.Text;
            if frxFIBConnItem.SystemRB.Checked then
              li.SubItems.Add('System')
            else
              li.SubItems.Add('User');
            li.SubItems.Add('Firebird/Interbase');
            fib.Database.DBParams.Clear;
            fib.Database.DBName := frxFIBConnItem.BaseE.Text;
            fib.Database.AliasName := frxFIBConnItem.AliasE.Text;
            fib.Database.ConnectParams.UserName := frxFIBConnItem.UserNameE.Text;
            fib.Database.ConnectParams.Password := frxFIBConnItem.PasswordE.Text;
            fib.Database.ConnectParams.RoleName := frxFIBConnItem.RoleE.Text;
            fib.Database.DBParams.AddStrings(frxFIBConnItem.AddM.Lines);
            fib.Database.LibraryName := frxFIBConnItem.LibE.Text;
            li.SubItems.Add(fib.ToString);
          end;
        finally
          frxFIBConnItem.Free;
          fib.Free;
        end;
      end;
    end;
  finally
    frxConnTypeEdit.Free;
  end;
{$ENDIF}
end;

procedure TfrxConnEditorForm.DeleteBClick(Sender: TObject);
var
  li: TListItem;
begin
  li := ConnLV.Selected;
  if li <> nil then
    if MessageDlg('Delete connection ' + li.Caption + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      li.Free;
end;

procedure TfrxConnEditorForm.OKBClick(Sender: TObject);
begin
  ConnLV.Selected := nil;
end;

procedure TfrxConnEditorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxConnEditorForm.EditBClick(Sender: TObject);
var
  li: TListItem;
{$IFDEF FR_FIB}
  fib: TfrxFIBDatabase;
  i: Integer;
{$ENDIF}
begin
  li := ConnLV.Selected;
  if li <> nil then
  begin
    if (li.SubItems[1] = 'ADO Database') then
    begin
      frxConnectionItemEdit := TfrxConnectionItemEdit.Create(Self);
      try
        frxConnectionItemEdit.Report := Report;
        frxConnectionItemEdit.NameE.Text := li.Caption;
        frxConnectionItemEdit.SystemRB.Checked := li.SubItems[0] = 'System';
        frxConnectionItemEdit.UserRB.Checked := li.SubItems[0] = 'User';
        frxConnectionItemEdit.ConnE.Text := li.SubItems[2];
        if frxConnectionItemEdit.ShowModal = mrOk then
        begin
          li.Caption := frxConnectionItemEdit.NameE.Text;
          if frxConnectionItemEdit.SystemRB.Checked then
            li.SubItems[0] := 'System'
          else
            li.SubItems[0] := 'User';
          li.SubItems[2] := frxConnectionItemEdit.ConnE.Text;
          ConnLV.Selected := li;
        end;
      finally
        frxConnectionItemEdit.Free;
      end;
    end
{$IFDEF FR_FIB}
    else if (li.SubItems[1] = 'Firebird/Interbase') then
    begin
      frxFIBConnItem := TfrxFIBConnItem.Create(Self);
      fib := TfrxFIBDatabase.Create(nil);
      try
        frxFIBConnItem.NameE.Text := li.Caption;
        frxFIBConnItem.SystemRB.Checked := li.SubItems[0] = 'System';
        frxFIBConnItem.UserRB.Checked := li.SubItems[0] = 'User';
        fib.FromString(li.SubItems[2]);
        frxFIBConnItem.BaseE.Text := fib.Database.DBName;
        frxFIBConnItem.AliasE.Text := fib.Database.AliasName;
        frxFIBConnItem.UserNameE.Text := fib.Database.ConnectParams.UserName;
        frxFIBConnItem.PasswordE.Text := fib.Database.ConnectParams.Password;
        frxFIBConnItem.RoleE.Text := fib.Database.ConnectParams.RoleName;
        frxFIBConnItem.AddM.Lines.Assign(fib.Database.DBParams);
        i := frxFIBConnItem.AddM.Lines.IndexOfName('password');
        if i <> -1 then
          frxFIBConnItem.AddM.Lines.Delete(i);
        i := frxFIBConnItem.AddM.Lines.IndexOfName('user_name');
        if i <> -1 then
          frxFIBConnItem.AddM.Lines.Delete(i);
        i := frxFIBConnItem.AddM.Lines.IndexOfName('sql_role_name');
        if i <> -1 then
          frxFIBConnItem.AddM.Lines.Delete(i);
        frxFIBConnItem.LibE.Text := fib.Database.LibraryName;
        if frxFIBConnItem.ShowModal = mrOk then
        begin
          li.Caption := frxFIBConnItem.NameE.Text;
          if frxFIBConnItem.SystemRB.Checked then
            li.SubItems[0] := 'System'
          else
            li.SubItems[0] := 'User';
          fib.Database.DBParams.Clear;
          fib.Database.DBName := frxFIBConnItem.BaseE.Text;
          fib.Database.AliasName := frxFIBConnItem.AliasE.Text;
          fib.Database.ConnectParams.UserName := frxFIBConnItem.UserNameE.Text;
          fib.Database.ConnectParams.Password := frxFIBConnItem.PasswordE.Text;
          fib.Database.ConnectParams.RoleName := frxFIBConnItem.RoleE.Text;
          fib.Database.DBParams.AddStrings(frxFIBConnItem.AddM.Lines);
          fib.Database.LibraryName := frxFIBConnItem.LibE.Text;
          li.SubItems[2] := fib.ToString;
          ConnLV.Selected := li;
        end;
      finally
        frxFIBConnItem.Free;
        fib.Free;
      end;
    end;
{$ENDIF}
  end;
end;

{$IFNDEF FPC}
procedure TfrxConnEditorForm.ReadADOConnections;
var
  i: Integer;
  ini: TRegistry;
  sl: TStringList;
  li: TListItem;
begin
  ini := TRegistry.Create;
  try
    ini.RootKey := HKEY_LOCAL_MACHINE;
    sl := TStringList.Create;
    try
      if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS) then
      begin
        ini.GetValueNames(sl);
        for i := 0 to sl.Count - 1 do
        begin
          li := ConnLV.Items.Add;
          li.Caption := sl[i];
          li.SubItems.Add('System');
          li.SubItems.Add('ADO Database');
          li.SubItems.Add(Ini.ReadString(sl[i]));
        end;
      end;
      ini.RootKey := HKEY_CURRENT_USER;
      if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS) then
      begin
        ini.GetValueNames(sl);
        for i := 0 to sl.Count - 1 do
        begin
          li := ConnLV.Items.Add;
          li.Caption := sl[i];
          li.SubItems.Add('User');
          li.SubItems.Add('ADO Database');
          li.SubItems.Add(Ini.ReadString(sl[i]));
        end;
      end;
    finally
      sl.Free;
    end;
  finally
    ini.Free;
  end;
end;

procedure TfrxConnEditorForm.SaveADOConnections;
var
  i: Integer;
  ini: TRegistry;
  li: TListItem;
begin
  ini := TRegistry.Create;
  try
    ini.RootKey := HKEY_LOCAL_MACHINE;
    ini.DeleteKey(DEF_REG_CONNECTIONS);
    if ini.OpenKey(DEF_REG_CONNECTIONS, true) then
      for i := 0 to ConnLV.Items.Count - 1 do
      begin
        li := ConnLV.Items[i];
        if (li.SubItems[1] = 'ADO Database') and (li.SubItems[0] = 'System') then
          ini.WriteString(li.Caption, li.SubItems[2]);
      end;
    ini.RootKey := HKEY_CURRENT_USER;
    ini.DeleteKey(DEF_REG_CONNECTIONS);
    if ini.OpenKey(DEF_REG_CONNECTIONS, true) then
      for i := 0 to ConnLV.Items.Count - 1 do
      begin
        li := ConnLV.Items[i];
        if (li.SubItems[1] = 'ADO Database') and (li.SubItems[0] = 'User') then
          ini.WriteString(li.Caption, li.SubItems[2]);
      end;
  finally
    ini.Free;
  end;
end;
{$ENDIF}

{$IFDEF FR_FIB}
procedure TfrxConnEditorForm.ReadFIBConnections;
var
  i: Integer;
  ini: TRegistry;
  sl: TStringList;
  li: TListItem;
begin
  ini := TRegistry.Create;
  try
    ini.RootKey := HKEY_LOCAL_MACHINE;
    sl := TStringList.Create;
    try
      if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS + 'FIB') then
      begin
        ini.GetValueNames(sl);
        for i := 0 to sl.Count - 1 do
        begin
          li := ConnLV.Items.Add;
          li.Caption := sl[i];
          li.SubItems.Add('System');
          li.SubItems.Add('Firebird/Interbase');
          li.SubItems.Add(Ini.ReadString(sl[i]));
        end;
      end;
      ini.RootKey := HKEY_CURRENT_USER;
      if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS + 'FIB') then
      begin
        ini.GetValueNames(sl);
        for i := 0 to sl.Count - 1 do
        begin
          li := ConnLV.Items.Add;
          li.Caption := sl[i];
          li.SubItems.Add('User');
          li.SubItems.Add('Firebird/Interbase');
          li.SubItems.Add(Ini.ReadString(sl[i]));
        end;
      end;
    finally
      sl.Free;
    end;
  finally
    ini.Free;
  end;
end;

procedure TfrxConnEditorForm.SaveFIBConnections;
var
  i: Integer;
  ini: TRegistry;
  li: TListItem;
begin
  ini := TRegistry.Create;
  try
    ini.RootKey := HKEY_LOCAL_MACHINE;
    ini.DeleteKey(DEF_REG_CONNECTIONS + 'FIB');
    if ini.OpenKey(DEF_REG_CONNECTIONS + 'FIB', true) then
      for i := 0 to ConnLV.Items.Count - 1 do
      begin
        li := ConnLV.Items[i];
        if (li.SubItems[1] = 'Firebird/Interbase') and (li.SubItems[0] = 'System') then
          ini.WriteString(li.Caption, li.SubItems[2]);
      end;
    ini.RootKey := HKEY_CURRENT_USER;
    ini.DeleteKey(DEF_REG_CONNECTIONS + 'FIB');
    if ini.OpenKey(DEF_REG_CONNECTIONS + 'FIB', true) then
      for i := 0 to ConnLV.Items.Count - 1 do
      begin
        li := ConnLV.Items[i];
        if (li.SubItems[1] = 'Firebird/Interbase') and (li.SubItems[0] = 'User') then
          ini.WriteString(li.Caption, li.SubItems[2]);
      end;
  finally
    ini.Free;
  end;
end;
{$ENDIF}

procedure TfrxConnEditorForm.TestBClick(Sender: TObject);
var
  li: TListItem;
{$IFDEF FR_FIB}
  ado: TADOConnection;
  fib: TfrxFIBDatabase;
{$ENDIF}
begin
  li := ConnLV.Selected;
  if li <> nil then
  begin
{$IFDEF FR_FIB}
    if (li.SubItems[1] = 'ADO Database') then
    begin
      ado := TADOConnection.Create(nil);
      ado.LoginPrompt := False;
      try
        ado.ConnectionString := li.SubItems[2];
        try
          ado.Open;
          ShowMessage('Connected!');
        except
          on E: Exception do
            ShowMessage(E.Message);
        end;
      finally
        ado.Free;
      end;
    end
    else if (li.SubItems[1] = 'Firebird/Interbase') then
    begin
      frxFIBConnItem := TfrxFIBConnItem.Create(Self);
      fib := TfrxFIBDatabase.Create(nil);
      fib.LoginPrompt := False;
      try
        fib.FromString(li.SubItems[2]);
        try
          fib.Database.Open;
          ShowMessage('Connected!');
        except
          on E: Exception do
            ShowMessage(E.Message);
        end;
      finally
        frxFIBConnItem.Free;
        fib.Free;
      end;
    end;
{$ENDIF}
  end;
end;

end.
