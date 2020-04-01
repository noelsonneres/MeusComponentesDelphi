
{******************************************}
{                                          }
{             FastScript v1.9              }
{ Function/Classes tree FMX visual control }
{                                          }
{  (c) 2003-2011 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMX.fs_tree;

interface

{$I fs.inc}

uses
    FMX.Types,
  System.SysUtils, System.Classes, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMX.ExtCtrls, FMX.fs_synmemo, FMX.Objects,
  FMX.fs_XML, FMX.fs_iinterpreter, FMX.TreeView, FMX.Memo, System.UITypes, System.Types
{$IFDEF DELPHI18}
  ,FMX.StdCtrls
{$ENDIF}
{$IFDEF DELPHI19}
  , FMX.Graphics
{$ENDIF};

type
  TfsTreeViewItem = class(TTreeViewItem)
  private
    FButton: TCustomButton;
    FCloseImageIndex: Integer;
    FOpenImageIndex: Integer;
    FImgPos: Single;
    function GetBitmap():TBitmap;
  protected
    procedure ApplyStyle; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    property CloseImageIndex: Integer read FCloseImageIndex write FCloseImageIndex;
    property OpenImageIndex: Integer read FOpenImageIndex write FOpenImageIndex;
  end;

[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]

  TfsTreeView = class(TTreeView)
  private
    FPicBitmap: TBitmap;
    FIconWidth: Integer;
    FIconHeight: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadResouces(Stream: TStream; IconWidth, IconHeight: Integer);
    property PicPitmap: TBitmap read FPicBitmap write FPicBitmap;
    property IconWidth: Integer read FIconWidth write FIconWidth;
    property IconHeight: Integer read FIconHeight write FIconHeight;
    function GetBitmapRect(Index: Integer): TRectF;
    procedure DragOver(const Data: TDragObject; const Point: TPointF; {$IFNDEF DELPHI20}var Accept: Boolean{$ELSE} var Operation: TDragOperation{$ENDIF}); override;
    procedure DragDrop(const Data: TDragObject; const Point: TPointF); override;
  published
    property StyleLookup;
    property CanFocus default True;
    property DisableFocusEffect;
    property TabOrder;
    property AllowDrag default False;
    property AlternatingRowBackground default False;
    property ItemHeight;
//    property HideSelectionUnfocused default False;
    property MultiSelect default False;
    property ShowCheckboxes default False;
    property Sorted default False;
    property OnChange;
    property OnChangeCheck;
    property OnCompare;
    property OnDragChange;
  end;

[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
  TfsTree = class(TPanel)
  private
    Tree: TfsTreeView;
    FXML: TfsXMLDocument;
    FScript: TfsScript;
    FImages: TList;
    FShowFunctions: boolean;
    FShowClasses: boolean;
    FShowTypes: Boolean;
    FShowVariables: Boolean;
    FExpanded: boolean;
    FExpandLevel : integer;
    FMemo: TfsSyntaxMemo;
    FUpdating: Boolean;
    procedure FillTree;

    procedure SetMemo(Value: TfsSyntaxMemo);

    procedure SetScript(const Value: TfsScript);
  protected
 {$IFDEF DELPHI19}
    procedure CreateImageFromRes(Image: TImage; Bmp: FMX.Graphics.TBitmap;
                                  Width, Height: Integer; Index: Integer);
 {$ELSE}
    procedure CreateImageFromRes(Image: TImage; Bmp: FMX.Types.TBitmap;
                                  Width, Height: Integer; Index: Integer);
{$ENDIF}
    
    procedure TreeChange(Sender: TObject; Node: TTreeViewItem);
    procedure TreeDblClick(Sender: TObject);
    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetColor(Color: TAlphaColor);
    procedure UpdateItems;
    function GetFieldName: String;
  published
    property Align;
    property Anchors;
    property DragMode;
    property Enabled;
    property PopupMenu;
    property Script: TfsScript read FScript write SetScript;
    property ShowHint;
    property TabOrder;
    property Visible;

    property SyntaxMemo: TfsSyntaxMemo read FMemo write SetMemo;
    property ShowClasses: boolean read FShowClasses write FShowClasses;
    property ShowFunctions: boolean read FShowFunctions write FShowFunctions;
    property ShowTypes: boolean read FShowTypes write FShowTypes;
    property ShowVariables: boolean read FShowVariables write FShowVariables;
    property Expanded: boolean read FExpanded write FExpanded;
    property ExpandLevel: integer read FExpandLevel write FExpandLevel;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Left;
    property Top;
    property Width;
    property Height;
  end;

implementation

{$IFNDEF FPC}
  {$R fs_tree.res}
{$ENDIF}

uses FMX.fs_iTools;

constructor TfsTree.Create(AOwner: TComponent);
var
  S: TResourceStream;
begin
  inherited;
  DragMode := TDragMode.dmManual;
  Tree := TfsTreeView.Create(Self);
  Tree.Stored := False;
  with Tree do
  begin
    Parent := Self;
    DragMode := TDragMode.dmAutomatic;
    Align := TAlignLayout.alClient;
    TabOrder := 0;
  end;
  FImages := TList.Create();
  S := TResourceStream.Create(HInstance, 'FSTREEFMX', RT_RCDATA);//RT_RCDATA
  S.Position := 0;
  Tree.LoadResouces(S, 16, 16);
  S.Free;
  Tree.OnDblClick := TreeDblClick;
  FXML := TfsXMLDocument.Create;
  Expanded := True;
  ExpandLevel := 0;
  ShowClasses := True;
  ShowFunctions := True;
  ShowTypes := True;
  ShowVariables := True;
  UpdateItems;
  Top := 0;
  Left := 0;
  Height := 250;
  Width := 200;
end;


  {$IFDEF DELPHI19}
procedure TfsTree.CreateImageFromRes(Image: TImage; Bmp: FMX.Graphics.TBitmap;
  Width, Height, Index: Integer);
 {$ELSE}
procedure TfsTree.CreateImageFromRes(Image: TImage; Bmp: FMX.Types.TBitmap;
  Width, Height, Index: Integer);
{$ENDIF}
begin
    Image.Width := Width;
    Image.Height := Height;
    Image.Bitmap.SetSize(Width, Height);
    Image.Bitmap.Canvas.BeginScene;
    Image.Bitmap.Canvas.DrawBitmap(Bmp, RectF(Width * Index  , 0, Width * Index + Width , Height), RectF(0, 0, Width, Height), 1 );
    Image.Bitmap.Canvas.EndScene;
    //Image.Bitmap.BitmapChanged;
end;

destructor TfsTree.Destroy;
begin
  FImages.Free;
  Tree.Free;
  FUpdating := True;
  FXML.Free;
  inherited;
end;

procedure TfsTree.FillTree;

  function GetCategoryByName(s: String): String;
  begin
    if s = 'ctConv' then  result := 'Conversion'
    else if s = 'ctFormat' then result := 'Formatting'
    else if s = 'ctDate' then result := 'Date/Time'
    else if s = 'ctString' then result := 'String routines'
    else if s = 'ctMath' then result := 'Mathematical'
    else if s = 'ctOther' then result := 'Other'
    else result := s;
  end;

  procedure AddClasses(xi: TfsXMLItem; Root: TfsTreeViewItem);
  var
    i: Integer;
    Node: TfsTreeViewItem;
    s: String;
  begin
    s := xi.Prop['text'];
    Node := TfsTreeViewItem.Create(Tree);
    Node.Text := s;
    if Root <> nil then
      Node.Parent := Root
    else
      Node.Parent := Tree;
    Node.Parent.AddObject(Node);
    if Root = nil then
      Node.Text := xi.Name;
    if xi.Count = 0 then
    begin
       Node.OpenImageIndex := 1;
       Node.CloseImageIndex := 1;
    end
    else
    begin
       Node.OpenImageIndex := 3;
       Node.CloseImageIndex := 2;
    end;
    for i := 0 to xi.Count - 1 do
      AddClasses(xi[i], Node);
  end;

  procedure AddFunctions(xi: TfsXMLItem; Root: TfsTreeViewItem);
  var
    i: Integer;
    Node: TfsTreeViewItem;
    s: String;
  begin
    s := xi.Prop['text'];
    if xi.Count = 0 then
      s := Copy(s, Pos(' ', s) + 1, 255) else  { function }
      s := GetCategoryByName(s);               { category }
    Node := TfsTreeViewItem.Create(Tree);
    Node.DragMode := TDragMode.dmAutomatic;
    Node.Text := s;
    if Root <> nil then
      Node.Parent := Root
    else
      Node.Parent := Tree;
    Node.Parent.AddObject(Node);
    if Root = nil then
      Node.Text := xi.Name;
    if xi.Count = 0 then
    begin
       Node.OpenImageIndex := 0;
       Node.CloseImageIndex := 0;
    end
    else
    begin
       Node.OpenImageIndex := 3;
       Node.CloseImageIndex := 2;
    end;
    for i := 0 to xi.Count - 1 do
      AddFunctions(xi[i], Node);
  end;

  procedure AddTypes(xi: TfsXMLItem; Root: TfsTreeViewItem);
  var
    i: Integer;
    Node: TfsTreeViewItem;
    s: String;
  begin
    s := Copy(xi.Prop['text'], 1, 255);
    Node := TfsTreeViewItem.Create(Tree);
    Node.Text := s;
    if Root <> nil then
      Node.Parent := Root
    else
      Node.Parent := Tree;
    Node.Parent.AddObject(Node);
    if Root = nil then
      Node.Text := xi.Name;
    if xi.Count = 0 then
    begin
       Node.OpenImageIndex := 0;
       Node.CloseImageIndex := 0;
    end
    else
    begin
       Node.OpenImageIndex := 3;
       Node.CloseImageIndex := 2;
    end;
    for i := 0 to xi.Count - 1 do
      AddTypes(xi[i], Node);
  end;

  procedure AddVariables(xi: TfsXMLItem; Root: TfsTreeViewItem);
  var
    i: Integer;
    Node: TfsTreeViewItem;
    s: String;
  begin
    s := xi.Prop['text'];
    Node := TfsTreeViewItem.Create(Tree);
    Node.Text := s;
    if Root <> nil then
      Node.Parent := Root
    else
      Node.Parent := Tree;
    Node.Parent.AddObject(Node);
    if Root = nil then
      Node.Text := xi.Name;
    if xi.Count = 0 then
    begin
       Node.OpenImageIndex := 0;
       Node.CloseImageIndex := 0;
    end
    else
    begin
       Node.OpenImageIndex := 3;
       Node.CloseImageIndex := 2;
    end;
    for i := 0 to xi.Count - 1 do
      AddVariables(xi[i], Node);
  end;

  procedure ExpandNodes(level: integer);
  var
    j : integer;

    procedure ExpandNode(Node: TTreeViewItem; level: integer);
    var
      j : integer;
    begin
      if Node.Level < level then
        for j := 0 to Node.Count - 1 do
        begin
          if Node.Items[j].Level < Level then
            Node.Items[j].IsExpanded := True;
          ExpandNode(Node.Items[j], Level);
        end;
    end;
  begin
    if level > 0 then
      for j := 0 to Tree.Count - 1 do
      begin
        if Tree.Items[j].Level <= Level then
           Tree.Items[j].IsExpanded := True;
        ExpandNode(Tree.Items[j], Level);
      end;
  end;

begin
  FUpdating := True;
  FXML.Root.Clear;

  GenerateXMLContents(fsGlobalUnit, FXML.Root);
  if FScript <> nil then
    GenerateXMLContents(FScript, FXML.Root);

  Tree.BeginUpdate;
  Tree.Clear;

  if ShowClasses then
    AddClasses(FXML.Root.FindItem('Classes'), nil);

  if ShowFunctions then
    AddFunctions(FXML.Root.FindItem('Functions'), nil);

  if ShowTypes then
    AddTypes(FXML.Root.FindItem('Types'), nil);

  if ShowVariables then
    AddVariables(FXML.Root.FindItem('Variables'), nil);

  if Expanded then
     ExpandNodes(ExpandLevel);
  Tree.EndUpdate;
  FUpdating := False;
end;

procedure TfsTree.UpdateItems;
begin
  FillTree;
end;

procedure TfsTree.TreeChange(Sender: TObject;
  Node: TTreeViewItem);
begin
  if FUpdating then Exit;
end;

procedure TfsTree.TreeDblClick(Sender: TObject);
begin
  //if Assigned(SyntaxMemo) then
    //if Tree.Selected.Count = 0 then
   //   SyntaxMemo.SelText := Tree.Selected.Text;
  if Assigned(OnDblClick) then OnDblClick(Self);
end;

function TfsTree.GetFieldName: String;
var
  i, n: Integer;
  s: String;
begin
  Result := '';
  if (Tree.Selected <> nil) and (Tree.Selected.Count = 0) then
  begin
    s := Tree.Selected.Text;
    if Pos('(', s) <> 0 then
      n := 1 else
      n := 0;
    for i := 1 to Length(s) do
{$IFDEF Delphi12}
      if (s[i] = ',') or (s[i] = ';') then
{$ELSE}
      if s[i] in [',', ';'] then
{$ENDIF}
        Inc(n);

    if n = 0 then
      s := Copy(s, 1, Pos(':', s) - 1)
    else
    begin
      s := Copy(s, 1, Pos('(', s));
      for i := 1 to n - 1 do
        s := s + ',';
      s := s + ')';
    end;
    Result := s;
  end;
end;

procedure TfsTree.Loaded;
begin
  Inherited;

end;

procedure TfsTree.SetColor(Color: TAlphaColor);
begin
  //Tree.Canvas.Stroke.Color := TAlphaColorRec.Azure;
 // Tree.Color := Color;
end;

procedure TfsTree.SetMemo(Value: TfsSyntaxMemo);
begin
  FMemo := Value;
end;

procedure TfsTree.SetScript(const Value: TfsScript);
begin
  FScript := Value;
  UpdateItems;
end;

procedure TfsTree.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
    if AComponent = FScript then
      FScript := nil
    else if AComponent = FMemo then
      FMemo := nil
end;

{ TfsTreeViewItem }

procedure TfsTreeViewItem.ApplyStyle;
var
  B: TFmxObject;
  Offset: Single;
begin
  inherited;
  B := FindStyleResource('button');
  if (B <> nil) and (B is TCustomButton) then
  begin
    FButton := TCustomButton(B);
    B := FindStyleResource('text');
    Offset := 0;
    if Self.TreeView is TfsTreeView then
      Offset := TfsTreeView(Self.TreeView).IconWidth;

    if (B <> nil) and (B is TText) then
    begin
{$IFDEF DELPHI17}
      TText(B).Margins.Left := Offset;
{$ELSE}
      TText(B).Padding.Left :=  Offset;
{$ENDIF}
    end;
      FImgPos := FButton.Position.X + FButton.Width - 2;
  end;
end;


constructor TfsTreeViewItem.Create(AOwner: TComponent);
begin
  inherited;
  FImgPos := 0;
  FCloseImageIndex := -1;
  FOpenImageIndex := -1;
end;

function TfsTreeViewItem.GetBitmap: TBitmap;
begin
  Result := nil;
  if TreeView is TfsTreeView then
  begin
    Result := TfsTreeView(TreeView).FPicBitmap;
  end;
end;

procedure TfsTreeViewItem.Paint;
var
  Bmp: TBitmap;
  IconRect: TRectF;
  Index: Integer;
begin
  inherited Paint;
  if IsExpanded then
    Index := FOpenImageIndex
  else
    Index := FCloseImageIndex;

  if Index = -1 then Exit;

  Bmp := GetBitmap;
  if TreeView is TfsTreeView then
  begin
    IconRect := TfsTreeView(TreeView).GetBitmapRect(Index);
  end;
  if (Bmp <> nil) and (FImgPos > 0)then
    Canvas.DrawBitmap(Bmp, IconRect, RectF(16, 0, 34, 16), 1 );
end;

{ TfsTreeView }

constructor TfsTreeView.Create(AOwner: TComponent);
begin
  inherited;
  FPicBitmap := nil;
  FIconWidth := 0;
  FIconHeight := 0;
end;

destructor TfsTreeView.Destroy;
begin
  if FPicBitmap <> nil then
    FPicBitmap.Free;

  inherited;
end;

procedure TfsTreeView.DragDrop(const Data: TDragObject; const Point: TPointF);
begin
  //inherited;
  // don't use TTreeView handlers
end;

procedure TfsTreeView.DragOver(const Data: TDragObject; const Point: TPointF;
  {$IFNDEF DELPHI20}var Accept: Boolean{$ELSE} var Operation: TDragOperation{$ENDIF});
begin
  //inherited;
  //don't use TTreeView handlers
end;

function TfsTreeView.GetBitmapRect(Index: Integer): TRectF;
var
  maxX, maxY, i: Integer;
  PosX, PosY: Integer;
begin
  Result := RectF(0, 0, 0, 0);
  if FPicBitmap = nil then Exit;
  PosX := 0;
  PosY := 0;
  maxX := FPicBitmap.Width div FIconWidth;
  maxY := FPicBitmap.Height div FIconHeight;

  for i := 0 to maxY - 1 do
  begin
    if Index < maxX then
    begin
      PosX := FIconWidth * Index;
      break;
    end;
    Index := Index div maxY;
    Inc(PosY);
    if PosY > maxY then
    begin
      PosX := 0;
      PosY := 0;
      break;
    end;
  end;
  Result := RectF(PosX, PosY, PosX + FIconWidth, PosY + FIconHeight);
end;

procedure TfsTreeView.LoadResouces(Stream: TStream; IconWidth,
  IconHeight: Integer);
begin
  FIconWidth := IconWidth;
  FIconHeight := IconHeight;
  if FPicBitmap = nil then
    FPicBitmap := TBitmap.CreateFromStream(Stream)
  else
    FPicBitmap.LoadFromStream(Stream);
end;

initialization
  StartClassGroup(TFmxObject);
  ActivateClassGroup(TFmxObject);
  GroupDescendentsWith(TfsTreeViewItem, TFmxObject);
  GroupDescendentsWith(TfsTreeView, TFmxObject);
  GroupDescendentsWith(TfsTree, TFmxObject);
  RegisterFmxClasses([TfsTreeViewItem, TfsTreeView]);

end.
