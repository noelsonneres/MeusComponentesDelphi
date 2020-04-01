{******************************************}
{                                          }
{             FastReport v4.0              }
{          Language resource file          }
{                                          }
{         Copyright (c) 1998-2008          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxrcInsp;

interface

implementation

uses frxRes;

const resXML =
'<?xml version="1.1" encoding="utf-8"?><Resources CodePage="1252"><StrRes Name="propActive" Text="Specifies if a dataset is open"/><StrRes Name="propAc' + 
'tive.TfrxHighlight" Text="Specifies if a highlight is active"/><StrRes Name="propAliasName" Text="The name of the DB alias"/><StrRes Name="propAlign" ' + 
'Text="Determines the alignment of the object relative to band or page"/><StrRes Name="propAlignment" Text="The alignment of the object''s text"/><StrRe' + 
's Name="propAllowAllUp" Text="Specifies if all speed buttons in the group can be unselected at the same time"/><StrRes Name="propAllowEdit" Text="Dete' + 
'rmines if the user may edit the prepared report pages"/><StrRes Name="propAllowExpressions" Text="Determines if the text object may contain expression' + 
's inside the text"/><StrRes Name="propAllowGrayed" Text="Allows grayed state of the control checkboxes"/><StrRes Name="propAllowHTMLTags" Text="Determ' + 
'ines if the text object may contain HTML tags inside the text"/><StrRes Name="propAllowSplit" Text="Determines if the band may split its contents acro' + 
'ss pages"/><StrRes Name="propAuthor" Text="The author of the report"/><StrRes Name="propAutoSize.TfrxPictureView" Text="Determines if the picture shou' + 
'ld handle its size automatically"/><StrRes Name="propAutoWidth" Text="Determines if the text object should handle its width automatically"/><StrRes Na' + 
'me="propBackPicture" Text="The background page picture"/><StrRes Name="propBarType" Text="The type of the barcode"/><StrRes Name="propBevelInner" Text' + 
'="The type of the inner bevel"/><StrRes Name="propBevelOuter" Text="The type of the outer bevel"/><StrRes Name="propBevelWidth" Text="The width of the' + 
' bevel"/><StrRes Name="propBorder" Text="Determines if outer border is shown"/><StrRes Name="propBorderStyle" Text="The style of the window"/><StrRes ' + 
'Name="propBottomMargin" Text="The size of the bottom page margin"/><StrRes Name="propBrushStyle" Text="The style of the brush used for object''s backgr' + 
'ound"/><StrRes Name="propCalcCheckSum" Text="Determines if the barcode should calculate the checksum digit"/><StrRes Name="propCancel" Text="Determine' + 
's if the button should be activated when Esc key pressed"/><StrRes Name="propCaption" Text="The caption of the control"/><StrRes Name="propCellFields"' + 
' Text="Names of DB fields represents the cross cells"/><StrRes Name="propCellLevels" Text="Number of cell levels"/><StrRes Name="propCenter" Text="Det' + 
'ermines if the image should be centered inside the control"/><StrRes Name="propCharset" Text="The font charset"/><StrRes Name="propCharSpacing" Text="' + 
'Amount of pixels between two characters"/><StrRes Name="propCheckColor" Text="The color of the check mark"/><StrRes Name="propChecked" Text="Indicates' + 
' if the control is checked"/><StrRes Name="propCheckStyle" Text="The style of the check mark"/><StrRes Name="propChild" Text="Child band connected to ' + 
'this band"/><StrRes Name="propClipped" Text="Determines if the text should be clipped inside the objects bounds"/><StrRes Name="propCollate" Text="Def' + 
'ault setting of collation"/><StrRes Name="propColor.TFont" Text="The color of the text"/><StrRes Name="propColor" Text="The color of the object"/><Str' + 
'Res Name="propColor.TfrxFrame" Text="The color of the frame"/><StrRes Name="propColor.TfrxHighlight" Text="Determines the color of the object if highl' + 
'ight is active"/><StrRes Name="propColumnFields" Text="Names of DB fields represents the cross columns"/><StrRes Name="propColumnGap" Text="The gap be' + 
'tween band columns"/><StrRes Name="propColumnLevels" Text="Number of column levels"/><StrRes Name="propColumns" Text="Number of columns in the band"/>' + 
'<StrRes Name="propColumnWidth" Text="The width of the band column"/><StrRes Name="propCondition" Text="The grouping condition. The group will break if' + 
' value of this expression changed"/><StrRes Name="propCondition.TfrxHighlight" Text="Expression string. If this expression is True, the highlight will' + 
' be active"/><StrRes Name="propConnected" Text="Indicates if the database connection is active"/><StrRes Name="propConvertNulls" Text="Determines if n' + 
'ull DB values will converted to 0, False or empty string"/><StrRes Name="propCopies" Text="The default number of copies"/><StrRes Name="propCursor" Te' + 
'xt="The cursor of the object"/><StrRes Name="propDatabaseName" Text="The name of the database"/><StrRes Name="propDataField" Text="Specifies the field' + 
' from which the object gets data"/><StrRes Name="propDataSet" Text="Links the object to the dataset that contains the field it represents"/><StrRes Na' + 
'me="propDate" Text="The date value of the control"/><StrRes Name="propDateFormat" Text="Specifies format in which the date is presented"/><StrRes Name' + 
'="propDecimalSeparator" Text="The decimal separator"/><StrRes Name="propDefault" Text="Determines if the button is the default button"/><StrRes Name="' + 
'propDefHeight" Text="Default height of the row"/><StrRes Name="propDescription.TfrxReportOptions" Text="The report description"/><StrRes Name="propDes' + 
'cription" Text="Object''s description"/><StrRes Name="propDiagonal" Text="Indicates that the line is diagonal"/><StrRes Name="propDisplayFormat" Text="' + 
'The format of the displayed value"/><StrRes Name="propDoublePass" Text="Determines if the report engine should perform the second pass"/><StrRes Name=' + 
'"propDown" Text="Determines if the speed button is pressed or not"/><StrRes Name="propDownThenAcross" Text="Determines how a large cross table will be' + 
' split across pages"/><StrRes Name="propDriverName" Text="The name of the BDE driver"/><StrRes Name="propDropShadow" Text="Determines if the objects h' + 
'as a shadow"/><StrRes Name="propDuplex" Text="Specifies the duplex mode for the page"/><StrRes Name="propEditMask" Text="Specifies the mask that repre' + 
'sents what text is valid for the masked edit control"/><StrRes Name="propEnabled" Text="Determines if the control is enabled"/><StrRes Name="propEngin' + 
'eOptions" Text="The engine options of the report"/><StrRes Name="propExpression" Text="Value of this expression will be shown in the object"/><StrRes ' + 
'Name="propExpressionDelimiters" Text="The characters that will be used for enclosing the expressions contained in the text"/><StrRes Name="propFieldAl' + 
'iases" Text="The dataset field''s aliases"/><StrRes Name="propFilter" Text="The filtering condition for the dataset"/><StrRes Name="propFiltered" Text=' + 
'"Determines if the dataset should filter the records using the condition in the Filter property"/><StrRes Name="propFlowTo" Text="The text object that' + 
' will show the text that not fit in the object"/><StrRes Name="propFont" Text="The font attributes of the object"/><StrRes Name="propFooterAfterEach" ' + 
'Text="Determines if the footer band should be shown after each data row"/><StrRes Name="propFormatStr" Text="The formatting string"/><StrRes Name="pro' + 
'pFrame" Text="The frame attributes of the object"/><StrRes Name="propGapX" Text="The left indent of the text"/><StrRes Name="propGapY" Text="The top i' + 
'ndent of the text"/><StrRes Name="propGlyph" Text="The image of the control"/><StrRes Name="propGroupIndex" Text="Allows speed buttons to work togethe' + 
'r as a group"/><StrRes Name="propHAlign" Text="The horizontal alignment of the text"/><StrRes Name="propHeight" Text="The height of the object"/><StrR' + 
'es Name="propHideZeros" Text="Determines if the text object will hide the zero values"/><StrRes Name="propHighlight" Text="The conditional highlight a' + 
'ttributes"/><StrRes Name="propIndexName" Text="The name of the index"/><StrRes Name="propInitString" Text="Printer init string for dot-matrix reports"' + 
'/><StrRes Name="propItems" Text="List items of the object"/><StrRes Name="propKeepAspectRatio" Text="Keep the original aspect ratio of the image"/><St' + 
'rRes Name="propKeepChild" Text="Determines if the band will be printed together with its child"/><StrRes Name="propKeepFooter" Text="Determines if the' + 
' band will be printed together with its footer"/><StrRes Name="propKeepHeader" Text="Determines if the band will be printed together with its header"/' + 
'><StrRes Name="propKeepTogether" Text="Determines if the band will be printed together with all its subbands"/><StrRes Name="propKind.TfrxFormat" Text' + 
'="The kind of formatting"/><StrRes Name="propKind" Text="The kind of the button"/><StrRes Name="propLargeDesignHeight" Text="Determines if the page wi' + 
'll have large height in the design mode"/><StrRes Name="propLayout" Text="The layout of the button glyph"/><StrRes Name="propLeft" Text="The left coor' + 
'dinate of the object"/><StrRes Name="propLeftMargin" Text="The size of the left page margin"/><StrRes Name="propLines" Text="The text of the object"/>' + 
'<StrRes Name="propLineSpacing" Text="The amount of pixels between two lines of text"/><StrRes Name="propLoginPrompt" Text="Determines if to show the l' + 
'ogin dialog"/><StrRes Name="propMargin" Text="Determines the number of pixels between the edge of the image and the edge of the button"/><StrRes Name=' + 
'"propMaster" Text="The master dataset"/><StrRes Name="propMasterFields" Text="The fields linked by master-detail relationship"/><StrRes Name="propMaxL' + 
'ength" Text="Max length of the text"/><StrRes Name="propMaxWidth" Text="Max width of the column"/><StrRes Name="propMemo" Text="The text of the object' + 
'"/><StrRes Name="propMinWidth" Text="Min width of the column"/><StrRes Name="propMirrorMargins" Text="Mirror the page margins on the even pages"/><Str' + 
'Res Name="propModalResult" Text="Determines if and how the button closes its modal form"/><StrRes Name="propName.TFont" Text="The name of the font"/><' + 
'StrRes Name="propName.TfrxReportOptions" Text="The name of the report"/><StrRes Name="propName" Text="The name of the object"/><StrRes Name="propNumGl' + 
'yphs" Text="Indicates the number of images that are in the graphic specified in the Glyph property"/><StrRes Name="propOpenDataSource" Text="Determine' + 
's if to open datasource automatically or not"/><StrRes Name="propOrientation" Text="The orientation of the page"/><StrRes Name="propOutlineText" Text=' + 
'"The text that will be shown in the preview outline control"/><StrRes Name="propOutlineVisible" Text="The visibility of the preview outline control"/>' + 
'<StrRes Name="propOutlineWidth" Text="The width of the preview outline control"/><StrRes Name="propPageNumbers.TfrxPrintOptions" Text="The numbers of ' + 
'the pages to be printed"/><StrRes Name="propPaperHeight" Text="The height of the page"/><StrRes Name="propPaperWidth" Text="The width of the page"/><S' + 
'trRes Name="propParagraphGap" Text="The indent of the first line of paragraph"/><StrRes Name="propParams.TfrxBDEDatabase" Text="The parameters of the ' + 
'connection"/><StrRes Name="propParams" Text="The parameters of the query"/><StrRes Name="propParentFont" Text="Determines if the object will use paren' + 
't''s font"/><StrRes Name="propPassword" Text="The report password"/><StrRes Name="propPasswordChar" Text="Indicates the character, if any, to display i' + 
'n place of the actual characters typed in the control"/><StrRes Name="propPicture" Text="The picture"/><StrRes Name="propPicture.TfrxReportOptions" Te' + 
'xt="The description picture of the report"/><StrRes Name="propPosition" Text="The initial position of the window"/><StrRes Name="propPreviewOptions" T' + 
'ext="The preview options of the report"/><StrRes Name="propPrintable" Text="Printability of the object. Objects with the Printable=False will be previ' + 
'ewed, but not printed"/><StrRes Name="propPrintChildIfInvisible" Text="Determines if the child band will be printed if its parent band is invisible"/>' + 
'<StrRes Name="propPrinter" Text="The name of the printer that will be selected when open or run this report"/><StrRes Name="propPrintIfDetailEmpty" Te' + 
'xt="Determines if the databand will be printed if its subband is empty"/><StrRes Name="propPrintIfEmpty" Text="Determines if the page will be printed ' + 
'if all its datasets are empty"/><StrRes Name="propPrintOnFirstPage" Text="Determines if the band will be printed on the first page"/><StrRes Name="pro' + 
'pPrintOnLastPage" Text="Determines if the band will be printed on the last page"/><StrRes Name="propPrintOnParent" Text="Determines if the subreport c' + 
'an print itself on parent band"/><StrRes Name="propPrintOnPreviousPage" Text="Determines if the page can be generated on the free space of previously ' + 
'generated page"/><StrRes Name="propPrintOptions" Text="Print options of the report"/><StrRes Name="propPrintPages" Text="Determines if to print all, o' + 
'dd or even pages"/><StrRes Name="propRangeBegin" Text="Determines the start point of dataset navigation"/><StrRes Name="propRangeEnd" Text="Determines' + 
' the end point of dataset navigation"/><StrRes Name="propRangeEndCount" Text="Determines the number of records in the dataset if RangeEnd is reCount"/' + 
'><StrRes Name="propReadOnly" Text="Determines if the text object is read-only"/><StrRes Name="propRepeatHeaders" Text="Determines if the column and ro' + 
'w headers will be reprinted on new page"/><StrRes Name="propReportOptions" Text="The options of the report"/><StrRes Name="propReprintOnNewPage" Text=' + 
'"Determines if the band will be reprinted on new page"/><StrRes Name="propRestrictions" Text="Set of restriction flags"/><StrRes Name="propRightMargin' + 
'" Text="The size of the right page margin"/><StrRes Name="propRotation.TfrxBarCodeView" Text="The orientation of the barcode"/><StrRes Name="propRotat' + 
'ion" Text="The text rotation"/><StrRes Name="propRowCount" Text="Number of virtual records in the databand"/><StrRes Name="propRowFields" Text="Names ' + 
'of DB fields represents the cross rows"/><StrRes Name="propRowLevels" Text="Number of row levels"/><StrRes Name="propRTLReading" Text="Determines if t' + 
'he text object will show its text in right-to-left direction"/><StrRes Name="propSessionName" Text="The name of the BDE session"/><StrRes Name="propSh' + 
'adowColor" Text="The color of the shadow"/><StrRes Name="propShadowWidth" Text="The width of the shadow"/><StrRes Name="propShape" Text="The type of t' + 
'he shape"/><StrRes Name="propShiftMode" Text="Shift behavior of the object"/><StrRes Name="propShowColumnHeader" Text="Determines if the cross will sh' + 
'ow column headers"/><StrRes Name="propShowColumnTotal" Text="Determines if the cross will show column grand total"/><StrRes Name="propShowRowHeader" T' + 
'ext="Determines if the cross will show row headers"/><StrRes Name="propShowRowTotal" Text="Determines if the cross will show row grand total"/><StrRes' + 
' Name="propShowDialog" Text="Determines if the print dialog will be shown in the preview window"/><StrRes Name="propShowText" Text="Determines if the ' + 
'barcode object will show a readable text"/><StrRes Name="propSize" Text="The size of the font"/><StrRes Name="propSorted" Text="Determines if the item' + 
's are sorted or not"/><StrRes Name="propSpacing" Text="Determines the number of pixels between the image and the text"/><StrRes Name="propSQL" Text="T' + 
'he SQL statement"/><StrRes Name="propStartNewPage" Text="Starts a new page before printing a band"/><StrRes Name="propStretch" Text="Stretches the pic' + 
'ture to fit the object bounds"/><StrRes Name="propStretched" Text="Determines if the object can be stretched"/><StrRes Name="propStretchMode" Text="St' + 
'retch behavior of the object"/><StrRes Name="propStyle.TFont" Text="The style of the font"/><StrRes Name="propStyle" Text="The style of the control"/>' + 
'<StrRes Name="propStyle.TfrxFrame" Text="The style of the object''s frame"/><StrRes Name="propSuppressRepeated" Text="Suppresses repeated values"/><Str' + 
'Res Name="propTableName" Text="The name of the data table"/><StrRes Name="propTag" Text="Tag number of the object"/><StrRes Name="propTagStr" Text="Ta' + 
'g string of the object"/><StrRes Name="propText" Text="The text of the object"/><StrRes Name="propTitleBeforeHeader" Text="Determines if report title ' + 
'shown before page header"/><StrRes Name="propTop" Text="The top coordinate of the object"/><StrRes Name="propTopMargin" Text="The size of the top page' + 
' margin"/><StrRes Name="propTyp" Text="The type of the frame"/><StrRes Name="propUnderlines" Text="Determines if the text object will show under lines' + 
' after each text line"/><StrRes Name="propURL" Text="The URL of the object"/><StrRes Name="propUserName" Text="User name of the data object. This name' + 
' will be shown in the data tree"/><StrRes Name="propVAlign" Text="The vertical alignment of the text"/><StrRes Name="propVersionBuild" Text="Version i' + 
'nfo, build"/><StrRes Name="propVersionMajor" Text="Version info, major version"/><StrRes Name="propVersionMinor" Text="Version info, minor version"/><' + 
'StrRes Name="propVersionRelease" Text="Version info, release"/><StrRes Name="propVisible" Text="Visibility of the object"/><StrRes Name="propWidth" Te' + 
'xt="Width of the object"/><StrRes Name="propWidth.TfrxFrame" Text="The width of the frame"/><StrRes Name="propWindowState" Text="Initial state of the ' + 
'window"/><StrRes Name="propWordBreak" Text="Break russian words"/><StrRes Name="propWordWrap" Text="Determines if the text object inserts soft carriag' + 
'e returns so text wraps at the right margin"/><StrRes Name="propZoom.TfrxBarCodeView" Text="Zooms the barcode"/><StrRes Name="propConnectionName" Text' + 
'="Name of the connection to the database used in the report"/><StrRes Name="propCurve" Text="Curvature of the roundrectangle edges"/><StrRes Name="pro' + 
'pDrillDown" Text="Determines if the group can be drilled down"/><StrRes Name="propFontStyle" Text="Dot-matrix font style"/><StrRes Name="propHideIfSin' + 
'gleDataRecord" Text="Hide the footer if a group has only one data record"/><StrRes Name="propOutlineExpand" Text="Determines if the report outline exp' + 
'ands or not"/><StrRes Name="propPlainCells" Text="Determines whether to print several cells side-by-side or stacked"/><StrRes Name="propPrintMode" Tex' + 
't="Print mode: normal, split big pages to small one, or print several small pages on a big one"/><StrRes Name="propPrintOnSheet" Text="Paper size to p' + 
'rint report on. Used if PrintMode is not pmDefault"/><StrRes Name="propResetPageNumbers" Text="Reset page number/total pages numbers when print a grou' + 
'p. Should be used with StartNewPage option set to true"/><StrRes Name="propReverse" Text="Determines if pages print in reverse order"/><StrRes Name="p' + 
'ropShowFooterIfDrillDown" Text="Determines if group footer is shown if group is drilldown"/><StrRes Name="propSizeMode" Text="Display mode of the OLE ' + 
'object"/><StrRes Name="propVersion" Text="Version of the FastReport"/><StrRes Name="propWideBarRatio" Text="Relative with of wide bars of the barcode"' + 
'/><StrRes Name="propWysiwyg" Text="Determines if the object should use the printer canvas to format the text. A printer should be installed and ready.' + 
'"/><StrRes Name="propArrowEnd" Text="Determines if an arrow is shown at end of a line"/><StrRes Name="propArrowLength" Text="Length of the arrow"/><St' + 
'rRes Name="propArrowSolid" Text="Determines if arrow has solid-fill "/><StrRes Name="propArrowStart" Text="Determines if an arrow is shown at the star' + 
't of a line"/><StrRes Name="propArrowWidth" Text="Width of the arrow"/><StrRes Name="propCloseDataSource" Text="Determines whether to close the datase' + 
't when report is finished"/><StrRes Name="propDatabase" Text="Database connection"/><StrRes Name="propIndexFieldNames" Text="Names of index fields"/><' + 
'StrRes Name="propCommandTimeOut" Text="Amount of time needed to execute a query"/><StrRes Name="propExpandDrillDown" Text="Determines if all drill-dow' + 
'n elements are expanded at first start of a report"/><StrRes Name="propWysiwyg.TfrxMemoView" Text="Determines if text is displayed in WYSIWYG mode"/><' + 
'StrRes Name="propLeftLine" Text="Left line of a frame"/><StrRes Name="propTopLine" Text="Top line of a frame"/><StrRes Name="propRightLine" Text="Righ' + 
't line of a frame"/><StrRes Name="propBottomLine" Text="Bottom line of a frame"/><StrRes Name="propColor.TfrxFrameLine" Text="The color of the frame l' + 
'ine"/><StrRes Name="propStyle.TfrxFrameLine" Text="The style of the frame line"/><StrRes Name="propWidth.TfrxFrameLine" Text="The width of the frame l' + 
'ine"/><StrRes Name="propFileLink" Text="Expression or name of the file containing a picture"/><StrRes Name="propEndlessWidth" Text="Endless page mode.' + 
' If true, page will grow depending on number of data records on it"/><StrRes Name="propEndlessHeight" Text="Endless page mode. If true, page will grow' + 
' depending on number of data records on it"/><StrRes Name="propAddHeight" Text="Adds specified amount of space to the cell height"/><StrRes Name="prop' + 
'AddWidth" Text="Adds specified amount of space to the cell width"/><StrRes Name="propAllowDuplicates" Text="Determines if the cell can accept duplicat' + 
'e string values"/><StrRes Name="propJoinEqualCells" Text="Determines if the crosstab should join cells with equal values"/><StrRes Name="propNextCross' + 
'" Text="Pointer to the next crosstab that will be displayed side-by-side"/><StrRes Name="propNextCrossGap" Text="Gap between side-by-side crosstabs"/>' + 
'<StrRes Name="propShowCorner" Text="Determines if the crosstab should display a left-top corner elements"/><StrRes Name="propSuppressNullRecords" Text' + 
'="!Determines if the crosstab should suppress records with all NULL values"/><StrRes Name="propShowTitle" Text="!Determines if the crosstab should dis' + 
'play a title"/><StrRes Name="propAutoSize" Text="!Determines if the crosstab should handle its size automatically"/><StrRes Name="propShowHint" Text="' + 
'Determines if object should show hint when move cursor on it"/><StrRes Name="propHint" Text="Hint text"/><StrRes Name="propPaperSize" Text="PaperSize"' + 
'/><StrRes Name="propPageCount" Text="Count of pages"/><StrRes Name="propBackPictureVisible" Text="Determines if the page should display a background p' + 
'icture"/><StrRes Name="propBackPicturePrintable" Text="Determines if the page should print a background picture"/><StrRes Name="propHightQuality" Text' + 
'="Show picture in high quality"/><StrRes Name="propLockType" Text="Specifies the lock type to use when opening a dataset"/><StrRes Name="propIgnoreDup' + 
'Params" Text="Ignore duplicate parameters in ParamEditor"/><StrRes Name="propTransparent" Text="Determinates if the picture can be transparent"/><StrR' + 
'es Name="propTransparentColor" Text="Transparent color"/><StrRes Name="propIgnoreNulls" Text="Allow to ingnore Nulls values in Chart"/><StrRes Name="p' + 
'ropShowClildIfDrillDown" Text="Determinates if child band shown if group is drilldown"/><StrRes Name="propUnderlinesTextMode" Text="Determines the tex' + 
't object under lines mode"/><StrRes Name="propCanShrink" Text="Determines the text object can shrink"/></Resources>' + 
' ';

initialization
  frxResources.AddXML(resXML);

end.
