
{******************************************}
{                                          }
{     FastReport v2.4 - Dialog designer    }
{         Standard Dialog controls         }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxDCtrl;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages, CommCtrl,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, StdCtrls,
  ExtCtrls, Forms, Menus, Dialogs, Comctrls, Buttons,
  {$IFDEF FPC}
  LMessages,MaskEdit, LCLType, LCLIntf, LCLProc,LazHelper, LazarusPackageIntf,
  {$ELSE}
  Mask,
  {$ENDIF}
  CheckLst, frxClass
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxDialogControls = class(TComponent) // fake component
  end;

  TfrxLabelControl = class(TfrxDialogControl)
  private
    FLabel: TLabel;
    function GetAlignment: TAlignment;
    function GetAutoSize: Boolean;
    function GetWordWrap: Boolean;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetAutoSize(const Value: Boolean);
    procedure SetWordWrap(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    procedure BeforeStartReport; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    property LabelCtl: TLabel read FLabel;
  published
    property Alignment: TAlignment read GetAlignment write SetAlignment
      default taLeftJustify;
    property AutoSize: Boolean read GetAutoSize write SetAutoSize default True;
    property Caption;
    property Color;
    property WordWrap: Boolean read GetWordWrap write SetWordWrap default False;

    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxOnChangingEvent = type String;
  
  TfrxPageControl = class(TfrxDialogControl)
  private
    FPageControl: TPageControl;
    FOnChange: TfrxNotifyEvent;
    FOnChanging: TfrxOnChangingEvent;
    function GetMultiLine: Boolean;
    {$IFNDEF FPC}
    function GetRaggedRight: Boolean;
    function GetScrollOpposite: Boolean;
    function GetStyle: TTabStyle;
    {$ENDIF}
    function GetTabHeight: Smallint;
    function GetTabIndex: Integer;
    function GetTabOrder: Integer;
    function GetTabPosition: TTabPosition;
    function GetTabWidth: Smallint;
    procedure SetMultiLine(const Value: Boolean);
    {$IFNDEF FPC}
    procedure SetRaggedRight(const Value: Boolean);
    procedure SetScrollOpposite(const Value: Boolean);
    procedure SetStyle(const Value: TTabStyle);
    {$ENDIF}
    procedure SetTabHeight(const Value: Smallint);
    procedure SetTabIndex(const Value: Integer);
    procedure SetTabOrder(const Value: Integer);
    procedure SetTabPosition(const Value: TTabPosition);
    procedure SetTabWidth(const Value: Smallint);
    {$IFNDEF FPC}
    function GetHotTrack: Boolean;
    procedure SetHotTrack(const Value: Boolean);
    {$ENDIF}
    procedure DoOnChange(Sender: TObject);
    procedure DoOnChanging(Sender: TObject; var AllowChange: Boolean);
  protected
    procedure SetParent(AParent: TfrxComponent); override;
    procedure SetWidth(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
    procedure UpdateSize;
  public
    constructor Create(AOwner: TComponent); override;
    function IsAcceptControl(aControl: TfrxComponent): Boolean; override;
    function DoMouseDown(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams)
      : Boolean; override;
    property PageControl: TPageControl read FPageControl;
  published
    {$IFNDEF FPC}
    property HotTrack: Boolean read GetHotTrack write SetHotTrack default False;
    {$ENDIF}
    property MultiLine: Boolean read GetMultiLine write SetMultiLine default False;
    {$IFNDEF FPC}
    property RaggedRight: Boolean read GetRaggedRight write SetRaggedRight default False;
    property ScrollOpposite: Boolean read GetScrollOpposite
      write SetScrollOpposite default False;
    property Style: TTabStyle read GetStyle write SetStyle default tsTabs;
    {$ENDIF}
    property TabHeight: Smallint read GetTabHeight write SetTabHeight default 0;
    property TabIndex: Integer read GetTabIndex write SetTabIndex stored False;
    property TabPosition: TTabPosition read GetTabPosition write SetTabPosition
      default tpTop;
    property TabWidth: Smallint read GetTabWidth write SetTabWidth default 0;
    property TabOrder: Integer read GetTabOrder write SetTabOrder;
    property TabStop;
    property OnChange: TfrxNotifyEvent read FOnChange write FOnChange;
    property OnChanging: TfrxOnChangingEvent read FOnChanging write FOnChanging;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxTabSheet = class(TfrxDialogControl)
  private
    FTabSheet: TTabSheet;
    function GetBorderWidth: Integer;
    {$IFNDEF FPC}
    function GetHighlighted: Boolean;
    {$ENDIF}
    function GetImageIndex: Integer;
    function GetPageIndex: Integer;
    function GetTabVisible: Boolean;
    procedure SetBorderWidth(const Value: Integer);
    {$IFNDEF FPC}
    procedure SetHighlighted(const Value: Boolean);
    {$ENDIF}
    procedure SetImageIndex(const Value: Integer);
    procedure SetPageIndex(const Value: Integer);
    procedure SetTabVisible(const Value: Boolean);
  protected
    procedure SetParent(AParent: TfrxComponent); override;
    procedure SetLeft(Value: Extended); override;
    procedure SetTop(Value: Extended); override;
    procedure SetWidth(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
    procedure UpdateSize;
  public
    constructor Create(AOwner: TComponent); override;
    function IsAcceptAsChild(aParent: TfrxComponent): Boolean; override;
    function IsOwnerDraw: Boolean; override;
    function IsContain(X, Y: Extended): Boolean; override;
    function GetContainedComponent(X, Y: Extended; IsCanContain: TfrxComponent = nil): TfrxComponent; override;
    property TabSheet: TTabSheet read FTabSheet;
    // todo
    property ImageIndex: Integer read GetImageIndex write SetImageIndex default 0;
  published
    property Caption;
    property TabStop;
    property BorderWidth: Integer read GetBorderWidth write SetBorderWidth ;
    property TabVisible: Boolean read GetTabVisible write SetTabVisible default True;
    property PageIndex: Integer read GetPageIndex write SetPageIndex stored False;
    {$IFNDEF FPC}
    property Highlighted: Boolean read GetHighlighted write SetHighlighted default False;
    {$ENDIF}
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxCustomEditControl = class(TfrxDialogControl)
  private
    FOnChange: TfrxNotifyEvent;
    function GetMaxLength: Integer;
    function GetPasswordChar: Char;
    function GetReadOnly: Boolean;
    function GetText: String;
    procedure DoOnChange(Sender: TObject);
    procedure SetMaxLength(const Value: Integer);
    procedure SetPasswordChar(const Value: Char);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetText(const Value: String);
  protected
    FCustomEdit: TCustomEdit;
    function GetCharCase: TEditCharCase; virtual;
    procedure SetCharCase(const Value: TEditCharCase); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property CharCase: TEditCharCase read GetCharCase write SetCharCase default ecNormal;   
    property MaxLength: Integer read GetMaxLength write SetMaxLength;
    property PasswordChar: Char read GetPasswordChar write SetPasswordChar;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property Text: String read GetText write SetText;
    property OnChange: TfrxNotifyEvent read FOnChange write FOnChange;
  end;

  TfrxEditControl = class(TfrxCustomEditControl)
  private
    FEdit: TEdit;
  protected
    function GetCharCase: TEditCharCase; override;
    procedure SetCharCase(const Value: TEditCharCase); override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property Edit: TEdit read FEdit;
  published
    property CharCase;
    property Color;
    property MaxLength;
    property PasswordChar;
    property ReadOnly;
    property TabStop;
    property Text;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxMemoControl = class(TfrxCustomEditControl)
  private
    FMemo: TMemo;
    function GetLines: TStrings;
    procedure SetLines(const Value: TStrings);
    function GetScrollStyle: TScrollStyle;
    function GetWordWrap: Boolean;
    procedure SetScrollStyle(const Value: TScrollStyle);
    procedure SetWordWrap(const Value: Boolean);
 protected
    function GetCharCase: TEditCharCase; override;
    procedure SetCharCase(const Value: TEditCharCase); override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property Memo: TMemo read FMemo;
  published
    property CharCase;
    property Color;
    property Lines: TStrings read GetLines write SetLines;
    property MaxLength;
    property ReadOnly;
    property ScrollBars: TScrollStyle read GetScrollStyle write SetScrollStyle default ssNone;
    property TabStop;
    property WordWrap: Boolean read GetWordWrap write SetWordWrap default True;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxButtonControl = class(TfrxDialogControl)
  private
    FButton: TButton;
    function GetCancel: Boolean;
    function GetDefault: Boolean;
    function GetModalResult: TModalResult;
    procedure SetCancel(const Value: Boolean);
    procedure SetDefault(const Value: Boolean);
    procedure SetModalResult(const Value: TModalResult);
{$IFDEF Delphi7}
    function GetWordWrap: Boolean;
    procedure SetWordWrap(const Value: Boolean);
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property Button: TButton read FButton;
  published
    property Cancel: Boolean read GetCancel write SetCancel default False;
    property Caption;
    property Default: Boolean read GetDefault write SetDefault default False;
    property ModalResult: TModalResult read GetModalResult write SetModalResult default mrNone;
{$IFDEF Delphi7}
    property WordWrap: Boolean read GetWordWrap write SetWordWrap default False;
{$ENDIF}
    property TabStop;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxCheckBoxControl = class(TfrxDialogControl)
  private
    FCheckBox: TCheckBox;
    function GetAlignment: TAlignment;
    function GetAllowGrayed: Boolean;
    function GetChecked: Boolean;
    function GetState: TCheckBoxState;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetAllowGrayed(const Value: Boolean);
    procedure SetChecked(const Value: Boolean);
    procedure SetState(const Value: TCheckBoxState);
{$IFDEF Delphi7}
    function GetWordWrap: Boolean;
    procedure SetWordWrap(const Value: Boolean);
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property CheckBox: TCheckBox read FCheckBox;
  published
    property Alignment: TAlignment read GetAlignment write SetAlignment
      default taRightJustify;
    property Caption;
    property Checked: Boolean read GetChecked write SetChecked default False;
    property AllowGrayed: Boolean read GetAllowGrayed write SetAllowGrayed default False;
    property State: TCheckBoxState read GetState write SetState default cbUnchecked;
    property TabStop;
{$IFDEF Delphi7}
    property WordWrap: Boolean read GetWordWrap write SetWordWrap default False;
{$ENDIF}
    property Color;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxRadioButtonControl = class(TfrxDialogControl)
  private
    FRadioButton: TRadioButton;
    function GetAlignment: TAlignment;
    function GetChecked: Boolean;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetChecked(const Value: Boolean);
{$IFDEF Delphi7}
    function GetWordWrap: Boolean;
    procedure SetWordWrap(const Value: Boolean);
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property RadioButton: TRadioButton read FRadioButton;
  published
    property Alignment: TAlignment read GetAlignment write SetAlignment
      default taRightJustify;
    property Caption;
    property Checked: Boolean read GetChecked write SetChecked default False;
    property TabStop;
{$IFDEF Delphi7}
    property WordWrap: Boolean read GetWordWrap write SetWordWrap default False;
{$ENDIF}
    property Color;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxListBoxControl = class(TfrxDialogControl)
  private
    FListBox: TListBox;
    function GetItems: TStrings;
    procedure SetItems(const Value: TStrings);
    function GetItemIndex: Integer;
    procedure SetItemIndex(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property ListBox: TListBox read FListBox;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
  published
    property Color;
    property Items: TStrings read GetItems write SetItems;
    property TabStop;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxComboBoxControl = class(TfrxDialogControl)
  private
    FComboBox: TComboBox;
    FOnChange: TfrxNotifyEvent;
    function GetItemIndex: Integer;
    function GetItems: TStrings;
    function GetStyle: TComboBoxStyle;
    function GetText: String;
    procedure DoOnChange(Sender: TObject);
    procedure SetItemIndex(const Value: Integer);
    procedure SetItems(const Value: TStrings);
    procedure SetStyle(const Value: TComboBoxStyle);
    procedure SetText(const Value: String);
  protected
    function GetCharCase: TEditCharCase; virtual;
    procedure SetCharCase(const Value: TEditCharCase); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property ComboBox: TComboBox read FComboBox;
  published
    property CharCase: TEditCharCase read GetCharCase write SetCharCase default ecNormal;
    property Color;
    property Items: TStrings read GetItems write SetItems;
    property Style: TComboBoxStyle read GetStyle write SetStyle default csDropDown;
    property TabStop;
    property Text: String read GetText write SetText;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property OnChange: TfrxNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  TfrxPanelControl = class(TfrxDialogControl)
  private
    FPanel: TPanel;
    function GetAlignment: TAlignment;
    function GetBevelInner: TPanelBevel;
    function GetBevelOuter: TPanelBevel;
    function GetBevelWidth: Integer;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetBevelInner(const Value: TPanelBevel);
    procedure SetBevelOuter(const Value: TPanelBevel);
    procedure SetBevelWidth(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property Panel: TPanel read FPanel;
  published
    property Alignment: TAlignment read GetAlignment write SetAlignment default taCenter;
    property BevelInner: TPanelBevel read GetBevelInner write SetBevelInner default bvNone;
    property BevelOuter: TPanelBevel read GetBevelOuter write SetBevelOuter default bvRaised;
    property BevelWidth: Integer read GetBevelWidth write SetBevelWidth default 1;
    property Caption;
    property Color;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxGroupBoxControl = class(TfrxDialogControl)
  private
    FGroupBox: TGroupBox;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property GroupBox: TGroupBox read FGroupBox;
  published
    property Caption;
    property Color;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxDateEditControl = class(TfrxDialogControl)
  private
    FDateEdit: TDateTimePicker;
    FOnChange: TfrxNotifyEvent;
    FWeekNumbers: Boolean;
    function GetDate: TDate;
    function GetTime: TTime;
    function GetDateFormat: TDTDateFormat;
    function GetKind: TDateTimeKind;
    procedure DoOnChange(Sender: TObject);
    procedure SetDate(const Value: TDate);
    procedure SetTime(const Value: TTime);
    procedure SetDateFormat(const Value: TDTDateFormat);
    procedure SetKind(const Value: TDateTimeKind);
    procedure DropDown(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property DateEdit: TDateTimePicker read FDateEdit;
  published
    property Color;
    property Date: TDate read GetDate write SetDate;
    property DateFormat: TDTDateFormat read GetDateFormat write SetDateFormat
      default dfShort;
    property Kind: TDateTimeKind read GetKind write SetKind default dtkDate;
    property TabStop;
    property Time: TTime read GetTime write SetTime;
    property WeekNumbers: Boolean read FWeekNumbers write FWeekNumbers;
    property OnChange: TfrxNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  TfrxImageControl = class(TfrxDialogControl)
  private
    FImage: TImage;
    function GetAutoSize: Boolean;
    function GetCenter: Boolean;
    function GetPicture: TPicture;
    function GetStretch: Boolean;
    procedure SetAutoSize(const Value: Boolean);
    procedure SetCenter(const Value: Boolean);
    procedure SetPicture(const Value: TPicture);
    procedure SetStretch(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property Image: TImage read FImage;
  published
    property AutoSize: Boolean read GetAutoSize write SetAutoSize default False;
    property Center: Boolean read GetCenter write SetCenter default False;
    property Picture: TPicture read GetPicture write SetPicture;
    property Stretch: Boolean read GetStretch write SetStretch default False;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxBevelControl = class(TfrxDialogControl)
  private
    FBevel: TBevel;
    function GetBevelShape: TBevelShape;
    function GetBevelStyle: TBevelStyle;
    procedure SetBevelShape(const Value: TBevelShape);
    procedure SetBevelStyle(const Value: TBevelStyle);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property Bevel: TBevel read FBevel;
  published
    property Shape: TBevelShape read GetBevelShape write SetBevelShape default bsBox;
    property Style: TBevelStyle read GetBevelStyle write SetBevelStyle default bsLowered;
  end;

  TfrxBitBtnControl = class(TfrxDialogControl)
  private
    FBitBtn: TBitBtn;
    function GetGlyph: TBitmap;
    function GetKind: TBitBtnKind;
    function GetLayout: TButtonLayout;
    function GetMargin: Integer;
    function GetModalResult: TModalResult;
    function GetSpacing: Integer;
    procedure SetGlyph(const Value: TBitmap);
    procedure SetKind(const Value: TBitBtnKind);
    procedure SetLayout(const Value: TButtonLayout);
    procedure SetMargin(const Value: Integer);
    procedure SetModalResult(const Value: TModalResult);
    procedure SetSpacing(const Value: Integer);
    function GetNumGlyphs: Integer;
    procedure SetNumGlyphs(const Value: Integer);
{$IFDEF Delphi7}
    function GetWordWrap: Boolean;
    procedure SetWordWrap(const Value: Boolean);
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property BitBtn: TBitBtn read FBitBtn;
  published
    property Glyph: TBitmap read GetGlyph write SetGlyph;
    property Kind: TBitBtnKind read GetKind write SetKind default bkCustom;
    property Caption; // should be after Kind prop
    property Layout: TButtonLayout read GetLayout write SetLayout default blGlyphLeft;
    property Margin: Integer read GetMargin write SetMargin default -1;
    property ModalResult: TModalResult read GetModalResult write SetModalResult default mrNone;
    property NumGlyphs: Integer read GetNumGlyphs write SetNumGlyphs default 1;
    property Spacing: Integer read GetSpacing write SetSpacing default 4;
{$IFDEF Delphi7}
    property WordWrap: Boolean read GetWordWrap write SetWordWrap default False;
{$ENDIF}
    property TabStop;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxSpeedButtonControl = class(TfrxDialogControl)
  private
    FSpeedButton: TSpeedButton;
    function GetAllowAllUp: Boolean;
    function GetDown: Boolean;
    function GetFlat: Boolean;
    function GetGlyph: TBitmap;
    function GetGroupIndex: Integer;
    function GetLayout: TButtonLayout;
    function GetMargin: Integer;
    function GetSpacing: Integer;
    procedure SetAllowAllUp(const Value: Boolean);
    procedure SetDown(const Value: Boolean);
    procedure SetFlat(const Value: Boolean);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetGroupIndex(const Value: Integer);
    procedure SetLayout(const Value: TButtonLayout);
    procedure SetMargin(const Value: Integer);
    procedure SetSpacing(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property SpeedButton: TSpeedButton read FSpeedButton;
  published
    property AllowAllUp: Boolean read GetAllowAllUp write SetAllowAllUp default False;
    property Caption;
    property Down: Boolean read GetDown write SetDown default False;
    property Flat: Boolean read GetFlat write SetFlat default False;
    property Glyph: TBitmap read GetGlyph write SetGlyph;
    property GroupIndex: Integer read GetGroupIndex write SetGroupIndex;
    property Layout: TButtonLayout read GetLayout write SetLayout default blGlyphLeft;
    property Margin: Integer read GetMargin write SetMargin default -1;
    property Spacing: Integer read GetSpacing write SetSpacing default 4;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxMaskEditControl = class(TfrxCustomEditControl)
  private
    FMaskEdit: TMaskEdit;
    function GetEditMask: String;
    procedure SetEditMask(const Value: String);
protected
    function GetCharCase: TEditCharCase; override;
    procedure SetCharCase(const Value: TEditCharCase); override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property MaskEdit: TMaskEdit read FMaskEdit;
  published
    property CharCase;
    property Color;
    property EditMask: String read GetEditMask write SetEditMask;
    property MaxLength;
    property ReadOnly;
    property TabStop;
    property Text;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxCheckListBoxControl = class(TfrxDialogControl)
  private
    FCheckListBox: TCheckListBox;
    function GetAllowGrayed: Boolean;
    function GetItems: TStrings;
    function GetSorted: Boolean;
    function GetChecked(Index: Integer): Boolean;
    function GetState(Index: Integer): TCheckBoxState;
    procedure SetAllowGrayed(const Value: Boolean);
    procedure SetItems(const Value: TStrings);
    procedure SetSorted(const Value: Boolean);
    procedure SetChecked(Index: Integer; const Value: Boolean);
    procedure SetState(Index: Integer; const Value: TCheckBoxState);
    function GetItemIndex: Integer;
    procedure SetItemIndex(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property CheckListBox: TCheckListBox read FCheckListBox;
    property Checked[Index: Integer]: Boolean read GetChecked write SetChecked;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property State[Index: Integer]: TCheckBoxState read GetState write SetState;
  published
    property AllowGrayed: Boolean read GetAllowGrayed write SetAllowGrayed default False;
    property Color;
    property Items: TStrings read GetItems write SetItems;
    property Sorted: Boolean read GetSorted write SetSorted default False;
    property TabStop;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

{$IFDEF FPC}
  procedure Register;
{$ENDIF}

implementation

uses frxDCtrlRTTI, frxUtils, frxDsgnIntf, frxRes;

type
  THackCustomEdit = class(TCustomEdit);
  THackControl = class(TControl);

  TfrxPageControlEditor = class(TfrxComponentEditor)
  public
    procedure GetMenuItems; override;
    function Execute(Tag: Integer; Checked: Boolean): Boolean; override;
  end;

{ TfrxLabelControl }

constructor TfrxLabelControl.Create(AOwner: TComponent);
begin
  inherited;
  FLabel := TLabel.Create(nil);
  InitControl(FLabel);
end;

class function TfrxLabelControl.GetDescription: String;
begin
  Result := frxResources.Get('obLabel');
end;

procedure TfrxLabelControl.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
begin
  if FLabel.AutoSize then
  begin
    Width := FLabel.Width;
    Height := FLabel.Height;
  end
  else
  begin
    FLabel.Width := Round(Width);
    FLabel.Height := Round(Height);
  end;
  inherited;
end;

function TfrxLabelControl.GetAlignment: TAlignment;
begin
  Result := FLabel.Alignment;
end;

function TfrxLabelControl.GetAutoSize: Boolean;
begin
  Result := FLabel.AutoSize;
end;

function TfrxLabelControl.GetWordWrap: Boolean;
begin
  Result := FLabel.WordWrap;
end;

procedure TfrxLabelControl.SetAlignment(const Value: TAlignment);
begin
  FLabel.Alignment := Value;
end;

procedure TfrxLabelControl.SetAutoSize(const Value: Boolean);
begin
  FLabel.AutoSize := Value;
end;

procedure TfrxLabelControl.SetWordWrap(const Value: Boolean);
begin
  FLabel.WordWrap := Value;
end;

procedure TfrxLabelControl.BeforeStartReport;
begin
  if not FLabel.AutoSize then
  begin
    FLabel.Width := Round(Width);
    FLabel.Height := Round(Height);
  end;
end;


{ TfrxCustomEditControl }

constructor TfrxCustomEditControl.Create(AOwner: TComponent);
begin
  inherited;
  THackCustomEdit(FCustomEdit).OnChange := DoOnChange;
  InitControl(FCustomEdit);
end;

function TfrxCustomEditControl.GetMaxLength: Integer;
begin
  Result := THackCustomEdit(FCustomEdit).MaxLength;
end;

function TfrxCustomEditControl.GetPasswordChar: Char;
begin
  Result := THackCustomEdit(FCustomEdit).PasswordChar;
end;

function TfrxCustomEditControl.GetReadOnly: Boolean;
begin
  Result := THackCustomEdit(FCustomEdit).ReadOnly;
end;

function TfrxCustomEditControl.GetText: String;
begin
  Result := THackCustomEdit(FCustomEdit).Text;
end;

procedure TfrxCustomEditControl.SetMaxLength(const Value: Integer);
begin
  THackCustomEdit(FCustomEdit).MaxLength := Value;
end;

procedure TfrxCustomEditControl.SetPasswordChar(const Value: Char);
begin
  THackCustomEdit(FCustomEdit).PasswordChar := Value;
end;

procedure TfrxCustomEditControl.SetReadOnly(const Value: Boolean);
begin
  THackCustomEdit(FCustomEdit).ReadOnly := Value;
end;

procedure TfrxCustomEditControl.SetText(const Value: String);
begin
  THackCustomEdit(FCustomEdit).Text := Value;
end;

procedure TfrxCustomEditControl.DoOnChange(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnChange, True);
end;

function TfrxCustomEditControl.GetCharCase: TEditCharCase;
begin
  Result := ecNormal; //Modify on inherited classes
end;

procedure TfrxCustomEditControl.SetCharCase(const Value: TEditCharCase);
begin
   //Modify on inherited classes
end;

{ TfrxEditControl }

constructor TfrxEditControl.Create(AOwner: TComponent);
begin
  FEdit := TEdit.Create(nil);
  FCustomEdit := FEdit;
  inherited;

  Width := 121;
  Height := 21;
end;

class function TfrxEditControl.GetDescription: String;
begin
  Result := frxResources.Get('obEdit');
end;

function TfrxEditControl.GetCharCase: TEditCharCase;
begin
  Result := FEdit.CharCase;
end;

procedure TfrxEditControl.SetCharCase(const Value: TEditCharCase);
begin
  FEdit.CharCase := Value;
end;

{ TfrxMemoControl }

constructor TfrxMemoControl.Create(AOwner: TComponent);
begin
  FMemo := TMemo.Create(nil);
  FCustomEdit := FMemo;
  inherited;

  Width := 185;
  Height := 89;
end;

class function TfrxMemoControl.GetDescription: String;
begin
  Result := frxResources.Get('obMemoC');
end;

function TfrxMemoControl.GetLines: TStrings;
begin
  Result := FMemo.Lines;
end;

function TfrxMemoControl.GetScrollStyle: TScrollStyle;
begin
  Result := FMemo.ScrollBars;
end;

function TfrxMemoControl.GetWordWrap: Boolean;
begin
  Result := FMemo.WordWrap;
end;

procedure TfrxMemoControl.SetLines(const Value: TStrings);
begin
  FMemo.Lines := Value;
end;

procedure TfrxMemoControl.SetScrollStyle(const Value: TScrollStyle);
begin
  FMemo.ScrollBars := Value;
end;

procedure TfrxMemoControl.SetWordWrap(const Value: Boolean);
begin
  FMemo.WordWrap := Value;
end;

function TfrxMemoControl.GetCharCase: TEditCharCase;
begin
  Result := THackCustomEdit(FMemo).CharCase;
end;

procedure TfrxMemoControl.SetCharCase(const Value: TEditCharCase);
begin
  THackCustomEdit(FMemo).CharCase := Value;
end;

{ TfrxButtonControl }

constructor TfrxButtonControl.Create(AOwner: TComponent);
begin
  inherited;
  FButton := TButton.Create(nil);
  InitControl(FButton);

  Width := 75;
  Height := 25;
end;

class function TfrxButtonControl.GetDescription: String;
begin
  Result := frxResources.Get('obButton');
end;

function TfrxButtonControl.GetCancel: Boolean;
begin
  Result := FButton.Cancel;
end;

function TfrxButtonControl.GetDefault: Boolean;
begin
  Result := FButton.Default;
end;

function TfrxButtonControl.GetModalResult: TModalResult;
begin
  Result := FButton.ModalResult;
end;

procedure TfrxButtonControl.SetCancel(const Value: Boolean);
begin
  FButton.Cancel := Value;
end;

procedure TfrxButtonControl.SetDefault(const Value: Boolean);
begin
  FButton.Default := Value;
end;

procedure TfrxButtonControl.SetModalResult(const Value: TModalResult);
begin
  FButton.ModalResult := Value;
end;

{$IFDEF Delphi7}
function TfrxButtonControl.GetWordWrap: Boolean;
begin
  Result := FButton.WordWrap;
end;

procedure TfrxButtonControl.SetWordWrap(const Value: Boolean);
begin
  FButton.WordWrap := Value;
end;
{$ENDIF}

{ TfrxCheckBoxControl }

constructor TfrxCheckBoxControl.Create(AOwner: TComponent);
begin
  inherited;
  FCheckBox := TCheckBox.Create(nil);
  InitControl(FCheckBox);

  Width := 97;
  Height := 17;
  Alignment := taRightJustify;
end;

class function TfrxCheckBoxControl.GetDescription: String;
begin
  Result := frxResources.Get('obChBoxC');
end;

function TfrxCheckBoxControl.GetAlignment: TAlignment;
begin
  {$IFDEF FPC}
  Result := taLeftJustify;
  {$ELSE}
  Result := FCheckBox.Alignment;
  {$ENDIF}
end;

function TfrxCheckBoxControl.GetAllowGrayed: Boolean;
begin
  Result := FCheckBox.AllowGrayed;
end;

function TfrxCheckBoxControl.GetChecked: Boolean;
begin
  Result := FCheckBox.Checked;
end;

function TfrxCheckBoxControl.GetState: TCheckBoxState;
begin
  Result := FCheckBox.State;
end;

procedure TfrxCheckBoxControl.SetAlignment(const Value: TAlignment);
begin
  {$IFNDEF FPC}
  FCheckBox.Alignment := Value;
  {$ENDIF}
end;

procedure TfrxCheckBoxControl.SetAllowGrayed(const Value: Boolean);
begin
  FCheckBox.AllowGrayed := Value;
end;

procedure TfrxCheckBoxControl.SetChecked(const Value: Boolean);
begin
  FCheckBox.Checked := Value;
end;

procedure TfrxCheckBoxControl.SetState(const Value: TCheckBoxState);
begin
  FCheckBox.State := Value;
end;

{$IFDEF Delphi7}
function TfrxCheckBoxControl.GetWordWrap: Boolean;
begin
  Result := FCheckBox.WordWrap;
end;

procedure TfrxCheckBoxControl.SetWordWrap(const Value: Boolean);
begin
  FCheckBox.WordWrap := Value;
end;
{$ENDIF}


{ TfrxRadioButtonControl }

constructor TfrxRadioButtonControl.Create(AOwner: TComponent);
begin
  inherited;
  FRadioButton := TRadioButton.Create(nil);
  InitControl(FRadioButton);

  Width := 113;
  Height := 17;
  Alignment := taRightJustify;
end;

class function TfrxRadioButtonControl.GetDescription: String;
begin
  Result := frxResources.Get('obRButton');
end;

function TfrxRadioButtonControl.GetAlignment: TAlignment;
begin
  {$IFDEF FPC}
  Result := taLeftJustify;
  {$ELSE}
  Result := FRadioButton.Alignment;
  {$ENDIF}
end;

function TfrxRadioButtonControl.GetChecked: Boolean;
begin
  Result := FRadioButton.Checked;
end;

procedure TfrxRadioButtonControl.SetAlignment(const Value: TAlignment);
begin
  {$IFNDEF FPC}
  FRadioButton.Alignment := Value;
  {$ENDIF}
end;

procedure TfrxRadioButtonControl.SetChecked(const Value: Boolean);
begin
  FRadioButton.Checked := Value;
end;

{$IFDEF Delphi7}
function TfrxRadioButtonControl.GetWordWrap: Boolean;
begin
  Result := FRadioButton.WordWrap;
end;

procedure TfrxRadioButtonControl.SetWordWrap(const Value: Boolean);
begin
  FRadioButton.WordWrap := Value;
end;
{$ENDIF}


{ TfrxListBoxControl }

constructor TfrxListBoxControl.Create(AOwner: TComponent);
begin
  inherited;
  FListBox := TListBox.Create(nil);
  InitControl(FListBox);

  Width := 121;
  Height := 97;
end;

class function TfrxListBoxControl.GetDescription: String;
begin
  Result := frxResources.Get('obLBox');
end;

function TfrxListBoxControl.GetItems: TStrings;
begin
  Result := FListBox.Items;
end;

function TfrxListBoxControl.GetItemIndex: Integer;
begin
  Result := FListBox.ItemIndex;
end;

procedure TfrxListBoxControl.SetItems(const Value: TStrings);
begin
  FListBox.Items := Value;
end;

procedure TfrxListBoxControl.SetItemIndex(const Value: Integer);
begin
  FListBox.ItemIndex := Value;
end;


{ TfrxComboBoxControl }

constructor TfrxComboBoxControl.Create(AOwner: TComponent);
begin
  inherited;
  FComboBox := TComboBox.Create(nil);
  FComboBox.OnChange := DoOnChange;
  InitControl(FComboBox);

  Width := 145;
  Height := 21;
end;

class function TfrxComboBoxControl.GetDescription: String;
begin
  Result := frxResources.Get('obCBox');
end;

function TfrxComboBoxControl.GetItems: TStrings;
begin
  Result := FComboBox.Items;
end;

function TfrxComboBoxControl.GetItemIndex: Integer;
begin
  Result := FComboBox.ItemIndex;
end;

function TfrxComboBoxControl.GetStyle: TComboBoxStyle;
begin
  Result := FComboBox.Style;
end;

function TfrxComboBoxControl.GetText: String;
begin
  Result := FComboBox.Text;
end;

procedure TfrxComboBoxControl.SetItems(const Value: TStrings);
begin
  FComboBox.Items := Value;
end;

procedure TfrxComboBoxControl.SetItemIndex(const Value: Integer);
begin
  FComboBox.ItemIndex := Value;
end;

procedure TfrxComboBoxControl.SetStyle(const Value: TComboBoxStyle);
begin
  FComboBox.Style := Value;
end;

procedure TfrxComboBoxControl.SetText(const Value: String);
begin
  FComboBox.Text := Value;
end;

procedure TfrxComboBoxControl.DoOnChange(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnChange, True);
end;

function TfrxComboBoxControl.GetCharCase: TEditCharCase;
begin
  Result := FComboBox.CharCase;
end;

procedure TfrxComboBoxControl.SetCharCase(const Value: TEditCharCase);
begin
  FComboBox.CharCase := Value;
end;

{ TfrxDateEditControl }

constructor TfrxDateEditControl.Create(AOwner: TComponent);
begin
  inherited;
  FDateEdit := TDateTimePicker.Create(nil);
  FDateEdit.OnChange := DoOnChange;
  {$IFNDEF FPC}
  FDateEdit.OnDropDown := DropDown;
  {$ENDIF}
  InitControl(FDateEdit);

  Width := 145;
  Height := 21;
end;

class function TfrxDateEditControl.GetDescription: String;
begin
  Result := frxResources.Get('obDateEdit');
end;

function TfrxDateEditControl.GetDate: TDate;
begin
  Result := FDateEdit.Date;
end;

function TfrxDateEditControl.GetTime: TTime;
begin
  Result := FDateEdit.Time;
end;

function TfrxDateEditControl.GetDateFormat: TDTDateFormat;
begin
  Result := FDateEdit.DateFormat;
end;

function TfrxDateEditControl.GetKind: TDateTimeKind;
begin
  Result := FDateEdit.Kind;
end;

procedure TfrxDateEditControl.SetDate(const Value: TDate);
begin
  FDateEdit.Date := Value;
end;

procedure TfrxDateEditControl.SetTime(const Value: TTime);
begin
  FDateEdit.Time := Value;
end;

procedure TfrxDateEditControl.SetDateFormat(const Value: TDTDateFormat);
begin
  FDateEdit.DateFormat := Value;
end;

procedure TfrxDateEditControl.SetKind(const Value: TDateTimeKind);
begin
  FDateEdit.Kind := Value;
end;

procedure TfrxDateEditControl.DoOnChange(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnChange, True);
end;

procedure TfrxDateEditControl.DropDown(Sender: TObject);
{$IFNDEF FPC}
var
 CalHandle: HWND;
 CalStyle: Cardinal;
 CalRect: TRect;
 CalMaxWidth: Integer;
 ClassName: array[0..256] of Char;
{$ENDIF}
begin
  if not FWeekNumbers then Exit;
  {$IFNDEF FPC}
  CalHandle := SendMessage(FDateEdit.Handle, DTM_GETMONTHCAL, 0, 0);
  CalStyle := GetWindowLong (CalHandle, GWL_STYLE);
  SetWindowLong(CalHandle, GWL_STYLE, CalStyle or MCS_WEEKNUMBERS);
  FillChar(CalRect, SizeOf (TRect), 0);
  SendMessage(CalHandle, MCM_GETMINREQRECT, 0, frxInteger(@CalRect));
  CalMaxWidth := SendMessage(CalHandle, MCM_GETMAXTODAYWIDTH, 0, 0);
  if CalMaxWidth > CalRect.Right then
    CalRect.Right := CalMaxWidth;
  GetClassName(GetParent(CalHandle), ClassName, sizeof(ClassName));
  if AnsiSameText(ClassName, 'DropDown') then
    SetWindowPos(GetParent(CalHandle), 0, 0, 0, CalRect.Right + 6, CalRect.Bottom + 6, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOZORDER)
  else
    SetWindowPos(CalHandle, 0, 0, 0, CalRect.Right, CalRect.Bottom, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOZORDER);
  {$ENDIF}
end;

{ TfrxImageControl }

constructor TfrxImageControl.Create(AOwner: TComponent);
begin
  inherited;
  FImage := TImage.Create(nil);
  InitControl(FImage);

  Width := 100;
  Height := 100;
end;

class function TfrxImageControl.GetDescription: String;
begin
  Result := frxResources.Get('obImageC');
end;

function TfrxImageControl.GetAutoSize: Boolean;
begin
  Result := FImage.AutoSize;
end;

function TfrxImageControl.GetCenter: Boolean;
begin
  Result := FImage.Center;
end;

function TfrxImageControl.GetPicture: TPicture;
begin
  Result := FImage.Picture;
end;

function TfrxImageControl.GetStretch: Boolean;
begin
  Result := FImage.Stretch;
end;

procedure TfrxImageControl.SetAutoSize(const Value: Boolean);
begin
  FImage.AutoSize := Value;
end;

procedure TfrxImageControl.SetCenter(const Value: Boolean);
begin
  FImage.Center := Value;
end;

procedure TfrxImageControl.SetPicture(const Value: TPicture);
begin
  FImage.Picture.Assign(Value);
end;

procedure TfrxImageControl.SetStretch(const Value: Boolean);
begin
  FImage.Stretch := Value;
end;


{ TfrxBevelControl }

constructor TfrxBevelControl.Create(AOwner: TComponent);
begin
  inherited;
  FBevel := TBevel.Create(nil);
  InitControl(FBevel);

  Width := 50;
  Height := 50;
end;

class function TfrxBevelControl.GetDescription: String;
begin
  Result := frxResources.Get('obBevel');
end;

function TfrxBevelControl.GetBevelShape: TBevelShape;
begin
  Result := FBevel.Shape;
end;

function TfrxBevelControl.GetBevelStyle: TBevelStyle;
begin
  Result := FBevel.Style;
end;

procedure TfrxBevelControl.SetBevelShape(const Value: TBevelShape);
begin
  FBevel.Shape := Value;
end;

procedure TfrxBevelControl.SetBevelStyle(const Value: TBevelStyle);
begin
  FBevel.Style := Value;
end;


{ TfrxPanelControl }

constructor TfrxPanelControl.Create(AOwner: TComponent);
begin
  inherited;
  FPanel := TPanel.Create(nil);
  InitControl(FPanel);
{$IFDEF Delphi9}
  FPanel.ParentColor := False;
  FPanel.ParentBackground := False;
{$ENDIF}
  Width := 185;
  Height := 41;
end;

class function TfrxPanelControl.GetDescription: String;
begin
  Result := frxResources.Get('obPanel');
end;

function TfrxPanelControl.GetAlignment: TAlignment;
begin
  Result := FPanel.Alignment;
end;

function TfrxPanelControl.GetBevelInner: TPanelBevel;
begin
  Result := FPanel.BevelInner;
end;

function TfrxPanelControl.GetBevelOuter: TPanelBevel;
begin
  Result := FPanel.BevelOuter;
end;

function TfrxPanelControl.GetBevelWidth: Integer;
begin
  Result := FPanel.BevelWidth;
end;

procedure TfrxPanelControl.SetAlignment(const Value: TAlignment);
begin
  FPanel.Alignment := Value;
end;

procedure TfrxPanelControl.SetBevelInner(const Value: TPanelBevel);
begin
  FPanel.BevelInner := Value;
end;

procedure TfrxPanelControl.SetBevelOuter(const Value: TPanelBevel);
begin
  FPanel.BevelOuter := Value;
end;

procedure TfrxPanelControl.SetBevelWidth(const Value: Integer);
begin
  FPanel.BevelWidth := Value;
end;


{ TfrxGroupBoxControl }

constructor TfrxGroupBoxControl.Create(AOwner: TComponent);
begin
  inherited;
  FGroupBox := TGroupBox.Create(nil);
  InitControl(FGroupBox);

  Width := 185;
  Height := 105;
end;

class function TfrxGroupBoxControl.GetDescription: String;
begin
  Result := frxResources.Get('obGrBox');
end;


{ TfrxBitBtnControl }

constructor TfrxBitBtnControl.Create(AOwner: TComponent);
begin
  inherited;
  FBitBtn := TBitBtn.Create(nil);
  InitControl(FBitBtn);

  Width := 75;
  Height := 25;
end;

class function TfrxBitBtnControl.GetDescription: String;
begin
  Result := frxResources.Get('obBBtn');
end;

function TfrxBitBtnControl.GetGlyph: TBitmap;
begin
  Result := FBitBtn.Glyph;
end;

function TfrxBitBtnControl.GetKind: TBitBtnKind;
begin
  Result := FBitBtn.Kind;
end;

function TfrxBitBtnControl.GetLayout: TButtonLayout;
begin
  Result := FBitBtn.Layout;
end;

function TfrxBitBtnControl.GetMargin: Integer;
begin
  Result := FBitBtn.Margin;
end;

function TfrxBitBtnControl.GetModalResult: TModalResult;
begin
  Result := FBitBtn.ModalResult;
end;

function TfrxBitBtnControl.GetNumGlyphs: Integer;
begin
  Result := FBitBtn.NumGlyphs;
end;

function TfrxBitBtnControl.GetSpacing: Integer;
begin
  Result := FBitBtn.Spacing;
end;

{$IFDEF Delphi7}
function TfrxBitBtnControl.GetWordWrap: Boolean;
begin
  Result := FBitBtn.WordWrap;
end;
{$ENDIF}

procedure TfrxBitBtnControl.SetGlyph(const Value: TBitmap);
begin
  FBitBtn.Glyph := Value;
end;

procedure TfrxBitBtnControl.SetKind(const Value: TBitBtnKind);
begin
  FBitBtn.Kind := Value;
end;

procedure TfrxBitBtnControl.SetLayout(const Value: TButtonLayout);
begin
  FBitBtn.Layout := Value;
end;

procedure TfrxBitBtnControl.SetMargin(const Value: Integer);
begin
  FBitBtn.Margin := Value;
end;

procedure TfrxBitBtnControl.SetModalResult(const Value: TModalResult);
begin
  FBitBtn.ModalResult := Value;
end;

procedure TfrxBitBtnControl.SetNumGlyphs(const Value: Integer);
begin
  FBitBtn.NumGlyphs := Value;
end;

procedure TfrxBitBtnControl.SetSpacing(const Value: Integer);
begin
  FBitBtn.Spacing := Value;
end;

{$IFDEF Delphi7}
procedure TfrxBitBtnControl.SetWordWrap(const Value: Boolean);
begin
  FBitBtn.WordWrap := Value;
end;
{$ENDIF}

{ TfrxSpeedButtonControl }

constructor TfrxSpeedButtonControl.Create(AOwner: TComponent);
begin
  inherited;
  FSpeedButton := TSpeedButton.Create(nil);
  InitControl(FSpeedButton);

  Width := 22;
  Height := 22;
end;

class function TfrxSpeedButtonControl.GetDescription: String;
begin
  Result := frxResources.Get('obSBtn');
end;

function TfrxSpeedButtonControl.GetAllowAllUp: Boolean;
begin
  Result := FSpeedButton.AllowAllUp;
end;

function TfrxSpeedButtonControl.GetDown: Boolean;
begin
  Result := FSpeedButton.Down;
end;

function TfrxSpeedButtonControl.GetFlat: Boolean;
begin
  Result := FSpeedButton.Flat;
end;

function TfrxSpeedButtonControl.GetGlyph: TBitmap;
begin
  Result := FSpeedButton.Glyph;
end;

function TfrxSpeedButtonControl.GetGroupIndex: Integer;
begin
  Result := FSpeedButton.GroupIndex;
end;

function TfrxSpeedButtonControl.GetLayout: TButtonLayout;
begin
  Result := FSpeedButton.Layout;
end;

function TfrxSpeedButtonControl.GetMargin: Integer;
begin
  Result := FSpeedButton.Margin;
end;

function TfrxSpeedButtonControl.GetSpacing: Integer;
begin
  Result := FSpeedButton.Spacing;
end;

procedure TfrxSpeedButtonControl.SetAllowAllUp(const Value: Boolean);
begin
  FSpeedButton.AllowAllUp := Value;
end;

procedure TfrxSpeedButtonControl.SetDown(const Value: Boolean);
begin
  FSpeedButton.Down := Value;
end;

procedure TfrxSpeedButtonControl.SetFlat(const Value: Boolean);
begin
  FSpeedButton.Flat := Value;
end;

procedure TfrxSpeedButtonControl.SetGlyph(const Value: TBitmap);
begin
  FSpeedButton.Glyph := Value;
end;

procedure TfrxSpeedButtonControl.SetGroupIndex(const Value: Integer);
begin
  FSpeedButton.GroupIndex := Value;
end;

procedure TfrxSpeedButtonControl.SetLayout(const Value: TButtonLayout);
begin
  FSpeedButton.Layout := Value;
end;

procedure TfrxSpeedButtonControl.SetMargin(const Value: Integer);
begin
  FSpeedButton.Margin := Value;
end;

procedure TfrxSpeedButtonControl.SetSpacing(const Value: Integer);
begin
  FSpeedButton.Spacing := Value;
end;


{ TfrxMaskEditControl }

constructor TfrxMaskEditControl.Create(AOwner: TComponent);
begin
  FMaskEdit := TMaskEdit.Create(nil);
  FCustomEdit := FMaskEdit;
  inherited;

  Width := 121;
  Height := 21;
end;

class function TfrxMaskEditControl.GetDescription: String;
begin
  Result := frxResources.Get('obMEdit');
end;

function TfrxMaskEditControl.GetEditMask: String;
begin
  Result := FMaskEdit.EditMask;
end;

procedure TfrxMaskEditControl.SetEditMask(const Value: String);
begin
  FMaskEdit.EditMask := Value;
end;

function TfrxMaskEditControl.GetCharCase: TEditCharCase;
begin
  Result := FMaskEdit.CharCase;
end;

procedure TfrxMaskEditControl.SetCharCase(const Value: TEditCharCase);
begin
  FMaskEdit.CharCase := Value;
end;

{ TfrxCheckListBoxControl }

constructor TfrxCheckListBoxControl.Create(AOwner: TComponent);
begin
  inherited;
  FCheckListBox := TCheckListBox.Create(nil);
  InitControl(FCheckListBox);

  Width := 121;
  Height := 97;
end;

class function TfrxCheckListBoxControl.GetDescription: String;
begin
  Result := frxResources.Get('obChLB');
end;

function TfrxCheckListBoxControl.GetAllowGrayed: Boolean;
begin
  Result := FCheckListBox.AllowGrayed;
end;

function TfrxCheckListBoxControl.GetItems: TStrings;
begin
  Result := FCheckListBox.Items;
end;

function TfrxCheckListBoxControl.GetSorted: Boolean;
begin
  Result := FCheckListBox.Sorted;
end;

function TfrxCheckListBoxControl.GetChecked(Index: Integer): Boolean;
begin
  Result := FCheckListBox.Checked[Index];
end;

function TfrxCheckListBoxControl.GetState(Index: Integer): TCheckBoxState;
begin
  Result := FCheckListBox.State[Index];
end;

procedure TfrxCheckListBoxControl.SetAllowGrayed(const Value: Boolean);
begin
  FCheckListBox.AllowGrayed := Value;
end;

procedure TfrxCheckListBoxControl.SetItems(const Value: TStrings);
begin
  FCheckListBox.Items := Value;
end;

procedure TfrxCheckListBoxControl.SetSorted(const Value: Boolean);
begin
  FCheckListBox.Sorted := Value;
end;

procedure TfrxCheckListBoxControl.SetChecked(Index: Integer; const Value: Boolean);
begin
  FCheckListBox.Checked[Index] := Value;
end;

procedure TfrxCheckListBoxControl.SetState(Index: Integer; const Value: TCheckBoxState);
begin
  FCheckListBox.State[Index] := Value;
end;

function TfrxCheckListBoxControl.GetItemIndex: Integer;
begin
  Result := FCheckListBox.ItemIndex;
end;

procedure TfrxCheckListBoxControl.SetItemIndex(const Value: Integer);
begin
  FCheckListBox.ItemIndex := Value;
end;


{$IFDEF FPC}
procedure RegisterUnitfrxDCtrl;
begin
  RegisterComponents('Fast Report 6',[TfrxDialogControls]);
end;

procedure Register;
begin
  RegisterUnit('frxDCtrl',@RegisterUnitfrxDCtrl);
end;
{$ENDIF}

{ TfrxPageControl }

constructor TfrxPageControl.Create(AOwner: TComponent);
begin
  inherited;
  FPageControl := TPageControl.Create(nil);
  InitControl(FPageControl);
  FPageControl.OnChange := DoOnChange;
  FPageControl.OnChanging := DoOnChanging;
  frComponentStyle := frComponentStyle - [csAcceptsFrxComponents];
  FPageControl.SetSubComponent(True);
  FBaseName := FBaseName + 'Control';
  Width := 185;
  Height := 105;
end;

function TfrxPageControl.DoMouseDown(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
  if FPageControl = nil then Exit;
  { send message to the control window }
  SendMessage(FPageControl.Handle, {$IFNDEF FPC}WM_LBUTTONDOWN{$ELSE}LM_LBUTTONDOWN{$ENDIF}, MK_LBUTTON, MakeLong(X - Round(AbsLeft), Y - round(AbsTop)));
  SendMessage(FPageControl.Handle, {$IFNDEF FPC}WM_LBUTTONUP{$ELSE}LM_LBUTTONUP{$ENDIF}, MK_LBUTTON, MakeLong(X - Round(AbsLeft), Y - round(AbsTop)));
  EventParams.Refresh := True;
end;

procedure TfrxPageControl.DoOnChange(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnChange, True);
end;

procedure TfrxPageControl.DoOnChanging(Sender: TObject; var AllowChange: Boolean);
var
  arr: Variant;
begin
  if FOnChanging <> '' then
  begin
    arr := VarArrayOf([frxInteger(Sender), AllowChange]);
    if Report <> nil then
      Report.DoParamEvent(FOnChanging, arr, True);
    AllowChange := arr[1];
  end;
end;

{$IFNDEF FPC}
function TfrxPageControl.GetHotTrack: Boolean;
begin
  Result := FPageControl.HotTrack;
end;
{$ENDIF}

function TfrxPageControl.GetMultiLine: Boolean;
begin
  Result := FPageControl.MultiLine;
end;

{$IFNDEF FPC}
function TfrxPageControl.GetRaggedRight: Boolean;
begin
  Result := FPageControl.RaggedRight;
end;

function TfrxPageControl.GetScrollOpposite: Boolean;
begin
  Result := FPageControl.ScrollOpposite;
end;

function TfrxPageControl.GetStyle: TTabStyle;
begin
  Result := FPageControl.Style;
end;
{$ENDIF}

function TfrxPageControl.GetTabHeight: Smallint;
begin
  Result := FPageControl.TabHeight;
end;

function TfrxPageControl.GetTabIndex: Integer;
begin
  Result := FPageControl.TabIndex;
end;

function TfrxPageControl.GetTabOrder: Integer;
begin
  Result := FPageControl.TabOrder;
end;

function TfrxPageControl.GetTabPosition: TTabPosition;
begin
  Result := FPageControl.TabPosition;
end;

function TfrxPageControl.GetTabWidth: Smallint;
begin
  Result := FPageControl.TabWidth;
end;

function TfrxPageControl.IsAcceptControl(aControl: TfrxComponent): Boolean;
begin
  Result := (aControl = nil) or (aControl is TfrxTabSheet);
end;

procedure TfrxPageControl.SetHeight(Value: Extended);
begin
  inherited;
  UpdateSize;
end;

{$IFNDEF FPC}
procedure TfrxPageControl.SetHotTrack(const Value: Boolean);
begin
  FPageControl.HotTrack := Value;
end;
{$ENDIF}

procedure TfrxPageControl.SetMultiLine(const Value: Boolean);
begin
  FPageControl.MultiLine := Value;
  UpdateSize;
end;


procedure TfrxPageControl.SetParent(AParent: TfrxComponent);
begin
  inherited;
end;

{$IFNDEF FPC}
procedure TfrxPageControl.SetRaggedRight(const Value: Boolean);
begin
  FPageControl.RaggedRight := Value;
end;

procedure TfrxPageControl.SetScrollOpposite(const Value: Boolean);
begin
  FPageControl.ScrollOpposite := Value;
end;

procedure TfrxPageControl.SetStyle(const Value: TTabStyle);
begin
  FPageControl.Style := Value;
  UpdateSize;
end;
{$ENDIF}

procedure TfrxPageControl.SetTabHeight(const Value: Smallint);
begin
  FPageControl.TabHeight := Value;
  UpdateSize;
end;

procedure TfrxPageControl.SetTabIndex(const Value: Integer);
begin
  FPageControl.TabIndex := Value;
end;

procedure TfrxPageControl.SetTabOrder(const Value: Integer);
begin
  FPageControl.TabOrder := Value;
end;

procedure TfrxPageControl.SetTabPosition(const Value: TTabPosition);
begin
  FPageControl.TabPosition := Value;
  UpdateSize;
end;

procedure TfrxPageControl.SetTabWidth(const Value: Smallint);
begin
  FPageControl.TabWidth := Value;
  UpdateSize;
end;

procedure TfrxPageControl.SetWidth(Value: Extended);
begin
  inherited;
  UpdateSize;
end;

procedure TfrxPageControl.UpdateSize;
var
  i: Integer;
begin
  for i := 0 to Objects.Count - 1 do
    if TObject(Objects[i]) is TfrxTabSheet then
      TfrxTabSheet(Objects[i]).UpdateSize;
end;

{ TfrxTabSheet }

constructor TfrxTabSheet.Create(AOwner: TComponent);
begin
  inherited;
  FTabSheet := TTabSheet.Create(nil);
  InitControl(FTabSheet);
  { component may accept others }
  frComponentStyle := frComponentStyle + [csAcceptsFrxComponents];
end;

function TfrxTabSheet.GetBorderWidth: Integer;
begin
  Result := FTabSheet.BorderWidth;
end;

function TfrxTabSheet.GetContainedComponent(X, Y: Extended;
  IsCanContain: TfrxComponent): TfrxComponent;
begin
  Result := nil;
  { check only active tab }
  if (FTabSheet = nil) or (FTabSheet.PageControl = nil) or
    not(FTabSheet.PageControl.ActivePage = FTabSheet) then Exit;
  Result := inherited GetContainedComponent(X, Y, IsCanContain);
end;

{$IFNDEF FPC}
function TfrxTabSheet.GetHighlighted: Boolean;
begin
  Result := FTabSheet.Highlighted;
end;
{$ENDIF}

function TfrxTabSheet.GetImageIndex: Integer;
begin
  Result := FTabSheet.ImageIndex;
end;

function TfrxTabSheet.GetPageIndex: Integer;
begin
  Result := FTabSheet.PageIndex;
end;

function TfrxTabSheet.GetTabVisible: Boolean;
begin
  Result := FTabSheet.TabVisible;
end;

function TfrxTabSheet.IsAcceptAsChild(aParent: TfrxComponent): Boolean;
begin
  { do not accept TfrxTabSheet class as parent }
  Result := inherited IsAcceptAsChild(aParent) and not (aParent is TfrxTabSheet);
end;

function TfrxTabSheet.IsContain(X, Y: Extended): Boolean;
begin
  Result := False;
  { check only active tab }
  if (FTabSheet = nil) or (FTabSheet.PageControl = nil) or
    not(FTabSheet.PageControl.ActivePage = FTabSheet) then
    Exit;
  Result := inherited IsContain(X, Y);
end;

function TfrxTabSheet.IsOwnerDraw: Boolean;
begin
  { do not draw components from invisible tabs in the report designer }
  Result := (FTabSheet = nil) or (FTabSheet.PageControl = nil) or
    not(FTabSheet.PageControl.ActivePage = FTabSheet);
end;

procedure TfrxTabSheet.SetBorderWidth(const Value: Integer);
begin
  FTabSheet.BorderWidth := Value;
end;

procedure TfrxTabSheet.SetHeight(Value: Extended);
begin
  // do not resize
end;

{$IFNDEF FPC}
procedure TfrxTabSheet.SetHighlighted(const Value: Boolean);
begin
  FTabSheet.Highlighted := Value;
end;
{$ENDIF}

procedure TfrxTabSheet.SetImageIndex(const Value: Integer);
begin
  FTabSheet.ImageIndex := Value;
end;

procedure TfrxTabSheet.SetLeft(Value: Extended);
begin
  // do not resize
end;

procedure TfrxTabSheet.SetPageIndex(const Value: Integer);
begin
  FTabSheet.PageIndex := Value;
end;

procedure TfrxTabSheet.SetParent(AParent: TfrxComponent);
begin
  inherited;
  { link tabs with PageControl }
  if (AParent is TfrxPageControl) and Assigned(FTabSheet) then
  begin
    FTabSheet.PageControl := TfrxPageControl(AParent).FPageControl;
    UpdateSize;
  end;
  if AParent = nil then
    FTabSheet.PageControl := nil;
end;

procedure TfrxTabSheet.SetTabVisible(const Value: Boolean);
begin
  FTabSheet.TabVisible := Value;
end;

procedure TfrxTabSheet.SetTop(Value: Extended);
begin
  // do not resize
end;

procedure TfrxTabSheet.SetWidth(Value: Extended);
begin
  // do not resize
end;

procedure TfrxTabSheet.UpdateSize;
begin
  if Assigned(FTabSheet) then
  begin
    inherited SetLeft(FTabSheet.Left);
    inherited SetTop(FTabSheet.Top);
    inherited SetWidth(FTabSheet.Width);
    inherited SetHeight(FTabSheet.Height);
  end;
end;

{ TfrxPageControlEditor }

function TfrxPageControlEditor.Execute(Tag: Integer; Checked: Boolean): Boolean;
var
  Tab: TfrxTabSheet;
begin
  Result := inherited Execute(Tag, Checked);
  if Tag = 0 then
  begin
    Tab := TfrxTabSheet.Create(Component);
    Tab.CreateUniqueName;
    Tab.FTabSheet.PageControl := TfrxPageControl(Component).FPageControl;
    Result := True;
  end;
end;

procedure TfrxPageControlEditor.GetMenuItems;
begin
  inherited;
  AddItem(frxResources.Get('6372'), 0);
end;

initialization
{$IFDEF DELPHI16}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfrxDialogControls, TControl);
{$ENDIF}
  frxObjects.RegisterObject1(TfrxLabelControl, nil, '', '', 0, 12);
  frxObjects.RegisterObject1(TfrxEditControl, nil, '', '', 0, 13);
  frxObjects.RegisterObject1(TfrxMemoControl, nil, '', '', 0, 14);
  frxObjects.RegisterObject1(TfrxButtonControl, nil, '', '', 0, 15);
  frxObjects.RegisterObject1(TfrxCheckBoxControl, nil, '', '', 0, 16);
  frxObjects.RegisterObject1(TfrxRadioButtonControl, nil, '', '', 0, 17);
  frxObjects.RegisterObject1(TfrxListBoxControl, nil, '', '', 0, 18);
  frxObjects.RegisterObject1(TfrxComboBoxControl, nil, '', '', 0, 19);
  frxObjects.RegisterObject1(TfrxPanelControl, nil, '', '', 0, 44);
  frxObjects.RegisterObject1(TfrxGroupBoxControl, nil, '', '', 0, 43);

  frxObjects.RegisterObject1(TfrxPageControl, nil, '', '', 0, 75);
  frxObjects.RegisterObject1(TfrxTabSheet, nil, '', '', 0, 76, [ctNone]);

  frxObjects.RegisterObject1(TfrxDateEditControl, nil, '', '', 0, 20);
  frxObjects.RegisterObject1(TfrxImageControl, nil, '', '', 0, 3);
  frxObjects.RegisterObject1(TfrxBevelControl, nil, '', '', 0, 33);
  frxObjects.RegisterObject1(TfrxBitBtnControl, nil, '', '', 0, 45);
  frxObjects.RegisterObject1(TfrxSpeedButtonControl, nil, '', '', 0, 46);
  frxObjects.RegisterObject1(TfrxMaskEditControl, nil, '', '', 0, 47);
  frxObjects.RegisterObject1(TfrxCheckListBoxControl, nil, '', '', 0, 48);

  frxComponentEditors.Register(TfrxPageControl, TfrxPageControlEditor);
  frxResources.Add('TfrxOnChangingEvent',
    'PascalScript=(Sender: TObject; var AllowChange: Boolean);' + #13#10 +
    'C++Script=(int RowIndex, bool &AllowChange)' + #13#10 +
    'BasicScript=(RowIndex, byref AllowChange)' + #13#10 +
    'JScript=(RowIndex, &AllowChange)');

end.
