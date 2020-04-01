
{******************************************}
{                                          }
{             FastReport v5.0              }
{       Generalized Markup Language        }
{           Reading/Writing API            }
{                                          }
{         Copyright (c) 1998-2011          }
{           by Anton Khayrudinov           }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

{ This module contains API for reading and
  writing documents that have syntax defined
  in the ISO 8879 standard. }

unit frxGML;

{ The implementation has the following simple
  idea. The source document is represented as
  a tree of nodes. The document written as a
  string is assumed to be the root node. Any
  node can be of two kinds:

    - a plain text node
    - a node that contains a list of subnodes

  Any node has the following main fields:

    - Reference to a part of the source
      document that represents the header of
      the node. This reference is a pair of
      values: a zero based index to the first
      character of the header and a count of
      characters in the header. Example of
      headers:

        - b, i, table (HTML)
        - ul, ansi, f (RTF)

    - Reference to the body of the node.

    - List of subnodes ordered in the same
      way as they are ordered in the document.

  Note, that the sum of the header and the body
  not equals to the whole node. An example is:

    <td class="c">text with an <a>anchor</a></td>

  In this example the header is "td", the body
  is "text with an <a>anchor</a>". }

interface

{$I frx.inc}

uses
  Classes, Types;

const

  { Values for TGmlEaResult
    Obselete }

  GmlEaFailure    = 0;  // the node failed to expand
  GmlEaSuccess    = 1;  // the node and all subnodes expanded
  GmlEaIncomplete = 2;  // the node expanded but not all subnodes expanded

  { Values for TGmlElValue }

  GmlElNone       = 0;  // leave the node unexpanded
  GmlElOne        = 1;  // expand the first level of subnodes
  GmlElAll        = -1; // build the complete tree of nodes

  { RTF special characters.
    The choosen values for these
    constants don't have special
    meaning and can be replaced with
    any other values that not equal
    to known codes of characters. }

  GmlRtfScEscape: AnsiChar = #$81;  // backslash "\"
  GmlRtfScOpen:   AnsiChar = #$82;  // opening brace "{"
  GmlRtfScClose:  AnsiChar = #$83;  // closing brace "}"

  { Maximum count of characters in an Rtf
    control word, e.g. in \lang the
    count is 4. }

  GmlRtfMaxControl = 32;

  { Maximum count of characters in an Rtf
    control word's argument, i.e. in \lang123
    the count is 3. }

  GmlRtfMaxControlArg = 10;

type

  TGmlEaResult = LongInt;
  TGmlElValue = LongInt;

  { List of TObject instances }

  TGmlList = class(TList)
  public

    procedure Clear; override;

  end;

  { String reference.
    This auxiliary structure represents a string
    in the source document. The string can be represented
    in two ways:

      • Indirect. In this case the string is defined
        by two numbers: an index to its first character
        within a source document, and the length of
        the string.

      • Direct. In this case the string is represented
        by AnsiString object.

    If TGmlStr.Data field is not empty, then the direct
    way is used. Otherwise the indirect way is used. }

  TGmlStr = record

    Pos:        LongInt;    // zero based
    Len:        LongInt;    // can be zero
    Data:       AnsiString; // can be empty

  end;

  { Abstract node. }

  TGmlNode = class
  private

    procedure SetHeader(const s: AnsiString);
    procedure SetBody(const s: AnsiString);

  protected

    FHeader:    TGmlStr;  // can has zero length
    FBody:      TGmlStr;  // can has zero length

    function GetHeader: AnsiString; virtual; abstract;
    function GetBody: AnsiString; virtual; abstract;

  public

    FParent:    TGmlNode; // can be nil
    FSubNodes:  TList;    // can be nil or empty

    destructor Destroy; override;

    { Default destructor doesn't delete subnodes. }

    procedure DestroyTree;

    { Returns True if a subnode exists.
      Returns False if there're subnodes. }

    function Empty: Boolean;

    { Walks over all subnodes and updates
      their FParent field. Then calls the Update
      routine of theirs. }

    procedure UpdateParent;

    { Removes itself from the list of subnodes of its
      parent. Optionally, deletes itself from memory
      and all its subnodes. }

    procedure Remove(DestroyItself: Boolean = True);

    { This node is contained in a list of
      subnodes of a parent of this node.
      This routine returns the index to this node
      in the list. If this node doesn't have
      a parent node, -1 is returned. }

    function SelfSubIndex: LongInt;

    { Copies a range of subnodes.
      Arguments:

        - First - index to the first subnodes from
          which the search should be started

        - Last - index to the last subnode, if it
          equals to -1 all subnodes from First till
          the end will be copied }

    function Select(First: LongInt; Last: LongInt = -1): TList;

    function NodesCount: LongInt;

    property Header: AnsiString read GetHeader write SetHeader;
    property Body: AnsiString read GetBody write SetBody;

  end;

  { RTF nodes.

    The following classes represents different
    kinds of nodes in an RTF documents. }

  TGmlRtf = class;

  TGmlRtfNode = class(TGmlNode)
  protected

    function GetHeader: AnsiString; override;
    function GetBody: AnsiString; override;

  public

    FDoc: TGmlRtf;

    { Serializes this node and all subnodes
      to an output text stream. }

    procedure Serialize(Stream: TStream); virtual;

    { Serializes a range of subnodes.
      The Last argument can be -1, in this
      case all subnodes from First will be
      serialized. }

    procedure SerializeSubNodes(Stream: TStream; First, Last: LongInt);

    { Returns a specified node.
      If the specified node doesn't exist,
      the result is nil. }

    function Node(Index: LongInt): TGmlRtfNode;

    { Finds a subnode with a specified header.
      The routine looks for all subnodes, not only
      immediate subnodes. }

    function Find(const Hdr: AnsiString): TGmlRtfNode;
    function FindAll(const Hdr: AnsiString;
      MaxCount: LongInt = 0): TList {of TGmlRtfNode};

  end;

  TGmlRtfGroup = class(TGmlRtfNode)
  public
    procedure Serialize(Stream: TStream); override;
  end;

  TGmlRtfText = class(TGmlRtfNode)
  public
    procedure Serialize(Stream: TStream); override;
  end;

  TGmlRtfControl = class(TGmlRtfNode)
  private

    FArg: Boolean;
    FArgValue: LongInt;

    procedure SetValue(x: LongInt);
    function GetValue: LongInt;

  public

    procedure Serialize(Stream: TStream); override;

    { RTF control word can be without a value.
      If you try to read value of such a control,
      an exception will be raised. }

    property Value: LongInt read GetValue write SetValue;

  end;

  TGmlRtfNumber = class(TGmlRtfNode)
  public
    FValue: LongInt;
    procedure Serialize(Stream: TStream); override;
  end;

  { RTF Control Symbol

    A control symbol consists of a backslash followed
    by a single, nonalphabetic character. For example,
    \~ represents a nonbreaking space.
    Control symbols take no delimiters. }

  TGmlRtfSymbol = class(TGmlRtfNode)
  public
    Symbol: AnsiChar;
    procedure Serialize(Stream: TStream); override;
  end;

  { RTF font.

    RTF document keeps descriptions of fonts
    in a list of group nodes. Each group node
    has a list of subnodes which defines
    properties of a font. }

  TGmlRtfFont = class(TGmlRtfNode)
  private

    function GetIndex: LongInt;
    function GetCharset: LongInt;
    function GetName: AnsiString;

  public

    { Access to any of these properties
      will perform a search in the list
      of subnodes. }

    property Index: LongInt read GetIndex {default -1};
    property Charset: LongInt read GetCharset {default 0};
    property Name: AnsiString read GetName {default ''};

  end;

  { RTF color.

    Color in an RTF document is represented by
    three consequent nodes \red100\green200\blue50
    where a value of a node is the saturation
    of the corresponding color component.  }

  TGmlRtfColor = class
  public
    R, G, B: TGmlRtfControl;
    function Serialize: AnsiString;
  end;

  { RTF document }

  TGmlRtf = class
  private

    { The following is used everywhere.  }

    FText:  AnsiString;     // the whole document
    FRoot:  TGmlRtfNode;    // the root Rtf node

    { The following data is used by the Rtf parser. }

    FStack: TList;          // list of saved pointers to the document
    FPos:   LongInt;        // current pointer to the source document
    FLast:  LongInt;        // last available position for parsing

    FFontList: TList {of TGmlRtfFont};
    FColorList: TGmlList {of TGmlRtfColor};

    { Skips "invisible" symbols and returns the first
      visible character. The current position points
      to the returned character. }

    function Current(SkipInvisibles: Boolean = False): AnsiChar;

    { Returns the first visible character.
      The current position points after the
      returned character. }

    function Get: AnsiChar;

    { Returns the first visible character.
      This function notes the escaping symbol '\'
      and converts special symbols to their
      GmlRtfSc values. }

    function Prepare: AnsiChar;

    { Saves parser's state }

    procedure Push;

    { Takes the last saved state of the parser.
      If Discard = False, the last saved state
      is loaded to the parser. If Discard = True,
      the last saved state is not loaded.
      Anyway, the last saved state is removed from
      the stack of saved states. }

    procedure Pop(Discard: Boolean = False);

    { Simple operations on characters. }

    function IsVisible(c: AnsiChar): Boolean; cdecl;
    function Escape(c: AnsiChar): AnsiChar;
    function IsSpecChar(c: AnsiChar): Boolean; cdecl;
    function IsAlpha(c: AnsiChar): Boolean; cdecl;
    function IsDigit(c: AnsiChar): Boolean; cdecl;
    function HexDigit(c: AnsiChar): Byte; cdecl;

    { Parsing routines. }

    function SkipAlpha: Boolean;        // 'A'..'Z' | 'a'..'z'
    function SkipDigit: Boolean;        // '0'..'9'
    function SkipControl: TGmlRtfNode;  // '\' <word>[<integer>][<space>]
    function SkipGroup: TGmlRtfNode;    // '{' {<node>} '}'
    function SkipNumber: TGmlRtfNode;   // "\'" <hexdigit><hexdigit>
    function SkipText: TGmlRtfNode;     // {^<specsym>}
    function SkipControlSymbol: TGmlRtfNode; // '\' <nonalpha>
    function SkipList: TList;           // {<node>}

    { Parses a specified selection of the document and
      returns a list of Rtf nodes that represent the
      selection. }

    function Parse(First, Last: LongInt): TList;

    { Looks for \fonttbl node and updates FFontList.
      If \fonttbl doesn't exist, FFontList is set to nil. }

    procedure LoadFonts;
    procedure LoadColors;

  public

    constructor Create(const Text: AnsiString);
    destructor Destroy; override;

    { Returns the count of characters in the document. }

    function Length: LongInt;

    { This routine copies a substring from the
      source document. Arguments:

        - Pos - a zero based index to the first
          character in the string in the document

        - Len - a count of characters in the string

        - Dest - a resulting buffer that is capable
          to store Len characters

        - Returned value - the number of characters
          that is copied to resulting buffer

      Implementation of this routine must not raise
      an exception. }

    function Copy(Pos: LongInt; Len: LongInt; Dest: PAnsiChar): LongInt; overload;

    { Copies a string from the document.
      If the specified location of the string is out
      of bounds, an empty string is returned. }

    function Copy(Pos: LongInt; Len: LongInt): AnsiString; overload;
    function Copy(Str: TGmlStr): AnsiString; overload;

    { Returns a character at a specified position.
      The position is zero based.
      This routine must raise an exception if the
      specified position is out of bounds. }

    function Char(Pos: LongInt): AnsiChar;

    { Writes this document in the Rtf format. }

    procedure Serialize(Stream: TStream);

    { Returns the top level node.
      Normally, this node contains a subnode TGmlRtfGroup,
      that contains a list of subnodes with document
      contents. }

    property Root: TGmlRtfNode read FRoot;

    { Returns count of fonts in the font table.
      If the table doesn't exist, zero is returned. }

    function FontsCount: LongInt;

    { Returns a font by its index.
      Note, that this index is not the same as
      the font index. The font index is an attribute
      of a font. If the font doesn't exist,
      nil is returned. }

    function Font(i: LongInt): TGmlRtfFont;

    { Returns count of colors in the color table.
      If the table doesn't exist, zero is returned. }

    function ColorsCount: LongInt;

    { Returns a color by its index.
      If the color doesn't exist,
      nil is returned. }

    function Color(i: LongInt): TGmlRtfColor;

  end;

implementation

uses
  SysUtils;

procedure WriteStr(const s: AnsiString; f: TStream);
begin
  if s = '' then
    Exit;

  f.Write(s[1], Length(s));
end;

{ TGmlList }

procedure TGmlList.Clear;
var
  i: LongInt;
begin
  for i := 0 to Count - 1 do
    TObject(Items[i]).Free;

  inherited;
end;

{ TGmlRtf }

constructor TGmlRtf.Create(const Text: AnsiString);

  procedure PropagateDoc(Node: TGmlRtfNode);
  var
    i: LongInt;
  begin
    with Node do
    begin
      FDoc := Self;
      for i := 0 to NodesCount - 1 do
        PropagateDoc(Node(i));
    end;
  end;

begin
  FText := Text;

  FRoot := TGmlRtfNode.Create;
  with FRoot do
  begin
    FBody.Pos := 0;
    FBody.Len := Length;
    FSubNodes := Parse(0, Length - 1);
    UpdateParent;
  end;

  PropagateDoc(FRoot);

  if not FRoot.Empty then
  begin
    LoadFonts;
    LoadColors;
  end;
end;

destructor TGmlRtf.Destroy;
begin
  FRoot.DestroyTree;
  FRoot.Free;
  FFontList.Free;
  FColorList.Free;
end;

procedure TGmlRtf.LoadFonts;
var
  t, p: TGmlRtfNode;
  i: LongInt;
begin
  FFontList.Free;
  FFontList := nil;

  t := FRoot.Find('fonttbl');
  if t = nil then
    Exit;

  FFontList := TList.Create;
  p := t.FParent as TGmlRtfNode;
  for i := t.SelfSubIndex + 1 to p.NodesCount - 1 do
    if p.Node(i) is TGmlRtfGroup then
      FFontList.Add(p.Node(i));
end;

procedure TGmlRtf.LoadColors;
var
  r, g, b: TGmlRtfControl;

  procedure Assign(out cc: TGmlRtfControl; c: TGmlRtfControl);
  begin
    if cc <> nil then
      raise Exception.Create('Invalid RTF color table');

    cc := c;
  end;

  procedure PopColor;
  var
    c: TGmlRtfColor;
  begin
    if (r = nil) and (g = nil) and (b = nil) then
      Exit;

    if (r = nil) or (g = nil) or (b = nil) then
      raise Exception.Create('Invalid RTF color table');

    c := TGmlRtfColor.Create;
    c.R := r;
    c.G := g;
    c.B := b;

    FColorList.Add(c);

    r := nil;
    g := nil;
    b := nil;
  end;

  procedure PushColor(Node: TGmlNode);
  var
    c: TGmlRtfControl;
    h: AnsiString;
  begin
    if not (Node is TGmlRtfControl) then
      Exit;

    c := Node as TGmlRtfControl;
    h := c.Header;

    if h = 'red' then Assign(r, c);
    if h = 'green' then Assign(g, c);
    if h = 'blue' then Assign(b, c);

    if (r <> nil) and (g <> nil) and (b <> nil) then
      PopColor;
  end;

var
  t, p: TGmlRtfNode;
  i: LongInt;
begin
  FColorList.Free;
  FColorList := nil;

  t := FRoot.Find('colortbl');
  if t = nil then
    Exit;

  FColorList := TGmlList.Create;
  r := nil;
  g := nil;
  b := nil;
  p := t.FParent as TGmlRtfNode;
  for i := t.SelfSubIndex + 1 to p.NodesCount - 1 do
    PushColor(p.Node(i));

  PopColor;
end;

function TGmlRtf.Copy(Pos: LongInt; Len: LongInt): AnsiString;
begin
  if Len = 0 then
  begin
    Result := '';
    Exit;
  end;

  try
    SetLength(Result, Len);
  except
    raise Exception.CreateFmt('Failed to allocate %d bytes', [Len]);
  end;

  Len := Copy(Pos, Len, @Result[1]);
  SetLength(Result, Len);
end;

function TGmlRTF.Copy(Str: TGmlStr): AnsiString;
begin
  if Str.Data = '' then
    Result := Copy(Str.Pos, Str.Len)
  else
    Result := Str.Data;
end;

function TGmlRtf.Length: LongInt;
begin
  Result := System.Length(FText);
end;

function TGmlRtf.Copy(Pos: LongInt; Len: LongInt; Dest: PAnsiChar): LongInt;
begin
  if Pos + Len > Length then
    Len := Length - Pos;

  if Len <= 0 then
  begin
    Result := 0;
    Exit;
  end;

  Move(FText[Pos + 1], Dest^, Len);
  Result := Len;
end;

function TGmlRtf.Char(Pos: LongInt): AnsiChar;
begin
  if (Pos < 0) or (Pos >= Length) then
    raise Exception.CreateFmt('The specified index %d is out of bounds [%d, %d]',
      [Pos, 0, Length - 1]);

  Result := FText[Pos + 1];
end;

function TGmlRtf.Escape(c: AnsiChar): AnsiChar;
begin
  case c of
    '\': Result := GmlRtfScEscape;
    '{': Result := GmlRtfScOpen;
    '}': Result := GmlRtfScClose;
    else Result := c;
  end;
end;

function TGmlRtf.IsSpecChar(c: AnsiChar): Boolean;
begin
  Result := c in [#0, '\', '{', '}']
end;

function TGmlRtf.IsAlpha(c: AnsiChar): Boolean;
begin
  Result := c in ['a'..'z', 'A'..'Z']
end;

function TGmlRtf.IsDigit(c: AnsiChar): Boolean;
begin
  Result := c in ['0'..'9']
end;

function TGmlRtf.HexDigit(c: AnsiChar): Byte;
begin
  case c of
    '0'..'9': Result := Ord(c) - Ord('0');
    'a'..'f': Result := Ord(c) - Ord('a') + 10;
    'A'..'F': Result := Ord(c) - Ord('A') + 10;
    else      Result := $ff;
  end
end;

function TGmlRtf.Parse(First, Last: LongInt): TList;
begin
  if (First < 0) or (Last >= Length) or (First >= Last) then
    raise Exception.CreateFmt('Range for parsing [%d, %d) is out of bounds [%d, %d)',
      [First, Last + 1, 0, Length]);

  FStack := TList.Create;
  FPos := First;
  FLast := Last;
  Result := SkipList;
  FStack.Free;
  FStack := nil;
end;

function TGmlRtf.IsVisible(c: AnsiChar): Boolean;
begin
  Result := not (c in [#10, #13])  
end;

function TGmlRtf.Current(SkipInvisibles: Boolean): AnsiChar;
begin
  if FPos > FLast then
  begin
    Result := #0;
    Exit;
  end;

  Result := AnsiChar(Char(FPos));

  if SkipInvisibles then
    while (FPos <= FLast) and not IsVisible(Result) do
    begin
      Inc(FPos);
      if FPos <= FLast then
        Result := Char(FPos)
      else
        Result := #0;
    end;
end;

function TGmlRtf.Get: AnsiChar;
begin
  Result := Current;
  if Result <> #0 then
    Inc(FPos);
end;

procedure TGmlRtf.Push;
begin
  FStack.Add(Pointer(FPos));
end;

procedure TGmlRtf.Pop(Discard: Boolean);
begin
  if FStack.Count = 0 then
    raise Exception.Create('Parser stack is empty');

  if not Discard then
    FPos := LongInt(FStack.Last);

  FStack.Count := FStack.Count - 1;
end;

function TGmlRtf.Prepare: AnsiChar;
var
  c: AnsiChar;
begin
  c := Get;

  case c of
    #0: Result := #0;

    '\':
      begin
        c := Get;

        case c of
          #0: Result := Escape('\');

          '{', '}', '\': Result := c;

          else
          begin
            Result := Escape('\');
            Dec(FPos);
          end
        end
      end;

    else Result := Escape(c)
  end
end;

function TGmlRtf.SkipAlpha: Boolean;
begin
  Result := IsAlpha(AnsiChar(Current));
  if Result then Get;
end;

function TGmlRtf.SkipDigit: Boolean;
begin
  Result := IsDigit(AnsiChar(Current));
  if Result then Get;
end;

function TGmlRtf.SkipControlSymbol: TGmlRtfNode;
var
  c: AnsiChar;
begin
  Result := nil;
  if Current <> '\' then
    Exit;

  Push;
  Get;
  c := Get;

  if IsAlpha(c) then
  begin
    Pop;
    Exit;
  end;

  Result := TGmlRtfSymbol.Create;
  with TGmlRtfSymbol(Result) do
    Symbol := c;

  Pop(True);
end;

function TGmlRtf.SkipList: TList;
var
  r: TGmlRtfNode;
begin
  Result := TList.Create;

  repeat
    r := nil;

    if r = nil then r := SkipControl;
    if r = nil then r := SkipGroup;
    if r = nil then r := SkipNumber;
    if r = nil then r := SkipControlSymbol;
    if r = nil then r := SkipText;

    if r <> nil then
      Result.Add(r);
  until r = nil;

  if Result.Count = 0 then
  begin
    Result.Free;
    Result := nil;
  end;
end;

function TGmlRtf.SkipControl: TGmlRtfNode;
var
  n, v, p: LongInt;
  Neg, Arg: Boolean;
  a: TGmlStr;
begin
  Push;
  Result := nil;

  { '\' character }

  if Prepare <> GmlRtfScEscape then
  begin
    Pop;
    Exit;
  end;

  { control word }

  n := 0;
  a.Pos := FPos;
  while (n < GmlRtfMaxControl) and SkipAlpha do
    Inc(n);

  if n = 0 then
  begin
    Pop;
    Exit;
  end;

  a.Len := n;

  { sign }

  Neg := False;
  if Current = '-' then
    Neg := True;

  if Current in ['-', '+'] then
    Get;

  { argument }

  n := 0;
  p := FPos;
  while (n < GmlRtfMaxControlArg) and SkipDigit do
    Inc(n);

  Arg := False;
  v := 0;
  if n > 0 then
  begin
    Arg := True;

    try
      v := StrToInt(string(Copy(p, n)));
    finally
      if Neg then
        v := -v;
    end;
  end;

  { space }

  if Current = ' ' then
    Get;

  { update stack }

  Pop(True);

  { create a node }

  Result := TGmlRtfControl.Create;
  with TGmlRtfControl(Result) do
  begin
    FArg := Arg;
    FArgValue := v;
    FHeader := a;
  end;
end;

function TGmlRtf.SkipGroup: TGmlRtfNode;
begin
  Push;
  Result := nil;

  { opening brace }

  if Prepare <> GmlRtfScOpen then
  begin
    Pop;
    Exit;
  end;

  { body }

  Result := TGmlRtfGroup.Create;
  with Result do
  begin
    FBody.Pos := FPos;
    FSubNodes := SkipList;
  end;

  if Result.FSubNodes = nil then
  begin
    Result.Free;
    Result := nil;
    Pop;
    Exit;
  end;

  with Result.FBody do
    Len := FPos - Pos - 1;

  { closing brace }

  if Prepare <> GmlRtfScClose then
  begin
    Result.Free;
    Result := nil;
    Pop;
    Exit;
  end;

  { update stack }

  Pop(True);
end;

function TGmlRtf.SkipNumber: TGmlRtfNode;
var
  s: array[1..4] of AnsiChar;
  h1, h2: Byte;
begin
  Result := nil;

  if Copy(FPos, 4, @s[1]) < 4 then
    Exit;

  if (s[1] = '\') and (s[2] = '''') then
  begin
    h1 := HexDigit(AnsiChar(s[3]));
    h2 := HexDigit(AnsiChar(s[4]));
    if (h1 < 16) and (h2 < 16) then
    begin
      Result := TGmlRtfNumber.Create;
      with TGmlRtfNumber(Result) do
        FValue := (h1 shl 4) or h2;

      Inc(FPos, 4);
      Exit;
    end;
  end;
end;

function TGmlRtf.SkipText: TGmlRtfNode;
var
  s: TGmlStr;
begin
  s.Pos := FPos;
  while not IsSpecChar(Current) do
    Get;

  s.Len := FPos - s.Pos;
  if s.Len = 0 then
  begin
    Result := nil;
    Exit;
  end;

  Result := TGmlRtfText.Create;
  Result.FBody := s;
end;

procedure TGmlRtf.Serialize(Stream: TStream);
begin
  FRoot.Serialize(Stream);
end;

function TGmlRtf.Font(i: LongInt): TGmlRtfFont;
begin
  if (i < 0) or (i >= FontsCount) then
    Result := nil
  else
    Result := TGmlRtfFont(FFontList[i]);
end;

function TGmlRtf.FontsCount: LongInt;
begin
  if FFontList = nil then
    Result := 0
  else
    Result := FFontList.Count;
end;

function TGmlRtf.ColorsCount: LongInt;
begin
  if FColorList = nil then
    Result := 0
  else
    Result := FColorList.Count;
end;

function TGmlRtf.Color(i: LongInt): TGmlRtfColor;
begin
  if (i < 0) or (i >= ColorsCount) then
    Result := nil
  else
    Result := TGmlRtfColor(FColorList[i]);
end;

{ TGmlNode }

procedure TGmlNode.SetHeader(const s: AnsiString);
begin
  FHeader.Data := s;
end;

procedure TGmlNode.SetBody(const s: AnsiString);
begin
  FBody.Data := s;
end;

destructor TGmlNode.Destroy;
begin
  FSubNodes.Free;
end;

procedure TGmlNode.DestroyTree;
var
  i: LongInt;
begin
  for i := 0 to NodesCount - 1 do
    with TGmlNode(FSubNodes[i]) do
    begin
      DestroyTree;
      Free;
    end;
end;

function TGmlNode.Empty: Boolean;
begin
  Result := True;
  if FSubNodes <> nil then
    Result := FSubNodes.Count = 0;
end;

procedure TGmlNode.UpdateParent;
var
  i: LongInt;
begin
  if FSubNodes <> nil then
    for i := 0 to FSubNodes.Count - 1 do
      with TGmlNode(FSubNodes[i]) do
      begin
        FParent := Self;
        UpdateParent;
      end;
end;

procedure TGmlNode.Remove(DestroyItself: Boolean = True);
begin
  if FParent <> nil then
    FParent.FSubNodes.Remove(Self);

  if DestroyItself then
  begin
    DestroyTree;
    Free;
  end;
end;

function TGmlNode.SelfSubIndex: LongInt;
var
  i: LongInt;
begin
  Result := -1;
  if FParent = nil then
    Exit;

  with FParent.FSubNodes do
    for i := 0 to Count - 1 do
      if Items[i] = Self then
      begin
        Result := i;
        Exit;
      end;

  raise Exception.Create('RTF node is not contained in the list of parent''s subnodes');
end;

function TGmlNode.Select(First: LongInt; Last: LongInt): TList;
begin
  if Last = -1 then
    Last := NodesCount - 1;

  if (First < 0) or (First > Last) or (Last >= NodesCount) then
    raise Exception.CreateFmt('Invalid range of subnodes [%d, %d]',
      [First, Last]);

  Result := TList.Create;
  while First <= Last do
  begin
    Result.Add(FSubNodes[First]);
    Inc(First);
  end;
end;

function TGmlNode.NodesCount: LongInt;
begin
  if FSubNodes = nil then
    Result := 0
  else
    Result := FSubNodes.Count;
end;

{ TGmlRtfNode }

function TGmlRtfNode.GetBody: AnsiString;
begin
  Result := FDoc.Copy(FBody)
end;

function TGmlRtfNode.GetHeader: AnsiString;
begin
  Result := FDoc.Copy(FHeader)
end;

procedure TGmlRtfNode.Serialize(Stream: TStream);
begin
  SerializeSubNodes(Stream, 0, -1);
end;

procedure TGmlRtfNode.SerializeSubNodes(Stream: TStream; First, Last: LongInt);
var
  i: LongInt;
  n2, n3: TGmlRtfNode;
begin
  if NodesCount = 0 then
    Exit;

  if Last = -1 then
    Last := NodesCount - 1;

  if (First < 0) or (Last >= NodesCount) or (First > Last) then
    raise Exception.CreateFmt('Invalid range [%d, %d] for serialization',
      [First, Last]);

  for i := First to Last do
  begin
    n2 := Node(i);
    n3 := Node(i + 1);

    {$IFDEF DEBUG}
    if (i > 0) and (n2 is TGmlRtfGroup) then
      WriteStr(#10, Stream);
    {$ENDIF}

    n2.Serialize(Stream);

    if (n2 is TGmlRtfControl) and (n3 is TGmlRtfText) then
      WriteStr(' ', Stream);
  end;
end;

function TGmlRtfNode.Node(Index: LongInt): TGmlRtfNode;
begin
  with FSubNodes do
    if (Index >= 0) and (Index < Count) then
      Result := TGmlRtfNode(Items[Index])
    else
      Result := nil;
end;

function TGmlRtfNode.FindAll(const Hdr: AnsiString;
  MaxCount: LongInt): TList {of TGmlRtfNode};
var
  List: TList;

  function FindTree(r: TGmlRtfNode): Boolean;
  var
    i: LongInt;
    h: AnsiString;
  begin
    Result := False;
    if (MaxCount > 0) and (List.Count = MaxCount) then
      Exit;

    h := r.Header;
    if (Hdr = '') or (h = Hdr) then
      List.Add(r);

    Result := True;

    for i := 0 to r.NodesCount - 1 do
      if not FindTree(r.Node(i) as TGmlRtfNode) then
        Break;
  end;

begin
  List := TList.Create;
  FindTree(Self);
  Result := List;
end;

function TGmlRtfNode.Find(const Hdr: AnsiString): TGmlRtfNode;
var
  i: LongInt;
  p: TGmlRtfNode;
  h: AnsiString;
begin
  Result := nil;
  if FSubNodes <> nil then
    with FSubNodes do
      for i := 0 to Count - 1 do
      begin
        p := TGmlRtfNode(Items[i]);
        h := p.Header;
        if h = Hdr then
        begin
          Result := p;
          Exit;
        end;

        p := p.Find(Hdr);
        if p <> nil then
        begin
          Result := p;
          Exit;
        end;
      end;
end;

{ TGmlRtfGroup }

procedure TGmlRtfGroup.Serialize(Stream: TStream);
begin
  WriteStr('{', Stream);
  inherited;
  WriteStr('}', Stream);
end;

{ TGmlRtfText }

procedure TGmlRtfText.Serialize(Stream: TStream);

  { Removes symbols #10 and #13 }

  procedure Clean(var s: AnsiString);
  var
    i, j: Integer;
  begin
    i := 1;

    for j := 1 to Length(s) do
      if (s[j] <> #10) and (s[j] <> #13) then
      begin
        s[i] := s[j];
        Inc(i);
      end;

    SetLength(s, i - 1);
  end;

var
  s: AnsiString;
begin
  s := FDoc.Copy(FBody);

  if s = '' then
    Exit;

  Clean(s);
  WriteStr(s, Stream);
end;

{ TGmlRtfControl }

procedure TGmlRtfControl.Serialize(Stream: TStream);
var
  h: AnsiString;
begin
  h := Header;

  {$IFDEF DEBUG}
  if (h = 'par') or (h = 'pard') then
    WriteStr(#10, Stream);
  {$ENDIF}

  WriteStr('\', Stream);
  WriteStr(h, Stream);

  if FArg then
    WriteStr(AnsiString(IntToStr(Value)), Stream);
end;

function TGmlRtfControl.GetValue: LongInt;
begin
  if not FArg then
    raise Exception.Create('RTF control word doesn''t have a value');

  Result := FArgValue;
end;

procedure TGmlRtfControl.SetValue(x: LongInt);
begin
  FArg := True;
  FArgValue := x;
end;

{ TGmlRtfNumber }

procedure TGmlRtfNumber.Serialize(Stream: TStream);

  function HexDigit(x: Byte): AnsiChar;
  begin
    case x of
      0..9:   Result := AnsiChar(x + Ord('0'));
      10..15: Result := AnsiChar(x - 10 + Ord('a'));
      else    Result := '?'
    end
  end;

var
  s: AnsiString;
  v: LongWord;
begin
  WriteStr('\''', Stream);

  s := '';
  v := LongWord(FValue);
  while v > 0 do
  begin
    s := HexDigit(v and $f) + s;
    v := v shr 4;
  end;

  while Length(s) < 2 do
    s := '0' + s;

  WriteStr(s, Stream);
end;

{ TGmlRtfSymbol }

procedure TGmlRtfSymbol.Serialize(Stream: TStream);
begin
  WriteStr(AnsiString('\' + Symbol), Stream);
end;

{ TGmlRtfFont }

function TGmlRtfFont.GetIndex: LongInt;
var
  r: TGmlRtfNode;
begin
  r := Find('f');

  if r = nil then
    Result := -1
  else
    Result := (r as TGmlRtfControl).Value;
end;

function TGmlRtfFont.GetCharset: LongInt;
var
  r: TGmlRtfNode;
begin
  r := Find('fcharset');

  if r = nil then
    Result := 0
  else
    Result := (r as TGmlRtfControl).Value;
end;

function TGmlRtfFont.GetName: AnsiString;

  procedure Clean(var s: AnsiString);
  begin
    if s = '' then
      Exit;

    if s[Length(s)] = ';' then
      SetLength(s, Length(s) - 1);
  end;

var
  i: LongInt;
begin
  Result := '';
  if not Empty then
    with FSubNodes do
      for i := 0 to Count - 1 do
        if Node(i) is TGmlRtfText then
        begin
          Result := Node(i).Body;
          Clean(Result);
          Exit;
        end;
end;

{ TGmlRtfColor }

function TGmlRtfColor.Serialize: AnsiString;
begin
  Result := AnsiString(Format('\red%d\green%d\blue%d',
    [R.Value, G.Value, B.Value]));
end;

end.
