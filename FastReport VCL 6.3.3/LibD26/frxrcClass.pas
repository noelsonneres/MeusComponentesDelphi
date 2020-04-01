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

unit frxrcClass;

interface

implementation

uses frxRes;

const resXML =
'<?xml version="1.1" encoding="utf-8"?><Resources CodePage="1252"><StrRes Name="1" Text="OK"/><StrRes Name="2" Text="Cancel"/><StrRes Name="3" Text="Al' + 
'l"/><StrRes Name="4" Text="Current page"/><StrRes Name="5" Text="Pages:"/><StrRes Name="6" Text="Page breaks"/><StrRes Name="7" Text="Page range"/><St' + 
'rRes Name="8" Text="Export settings"/><StrRes Name="9" Text="Enter page numbers and/or page ranges, separated by commas. For example, 1,3,5-12"/><StrR' + 
'es Name="100" Text="Preview"/><StrRes Name="101" Text="Print"/><StrRes Name="102" Text="Print"/><StrRes Name="103" Text="Open"/><StrRes Name="104" Tex' + 
't="Open"/><StrRes Name="105" Text="Save"/><StrRes Name="106" Text="Save"/><StrRes Name="107" Text="Export"/><StrRes Name="108" Text="Export"/><StrRes ' + 
'Name="109" Text="Find"/><StrRes Name="110" Text="Find"/><StrRes Name="111" Text="Whole Page"/><StrRes Name="112" Text="Whole Page"/><StrRes Name="113"' + 
' Text="Page Width"/><StrRes Name="114" Text="Page Width"/><StrRes Name="115" Text="100%"/><StrRes Name="116" Text="100%"/><StrRes Name="117" Text="Two' + 
' Pages"/><StrRes Name="118" Text="Two Pages"/><StrRes Name="119" Text="Zoom"/><StrRes Name="120" Text="Page Settings"/><StrRes Name="121" Text="Page S' + 
'ettings"/><StrRes Name="122" Text="Outline"/><StrRes Name="123" Text="Outline"/><StrRes Name="124" Text="Zoom In"/><StrRes Name="125" Text="Zoom In"/>' + 
'<StrRes Name="126" Text="Zoom Out"/><StrRes Name="127" Text="Zoom Out"/><StrRes Name="128" Text="Outline"/><StrRes Name="129" Text="Report outline"/><' + 
'StrRes Name="130" Text="Thumbnails"/><StrRes Name="131" Text="Thumbnails"/><StrRes Name="132" Text="Edit"/><StrRes Name="133" Text="Edit Page"/><StrRe' + 
's Name="134" Text="First"/><StrRes Name="135" Text="First Page"/><StrRes Name="136" Text="Prior"/><StrRes Name="137" Text="Prior Page"/><StrRes Name="' + 
'138" Text="Next"/><StrRes Name="139" Text="Next Page"/><StrRes Name="140" Text="Last"/><StrRes Name="141" Text="Last Page"/><StrRes Name="142" Text="P' + 
'age Number"/><StrRes Name="149" Text="Full Screen"/><StrRes Name="150" Text="Full Screen"/><StrRes Name="151" Text="Export to PDF"/><StrRes Name="152"' + 
' Text="Send by E-mail"/><StrRes Name="153" Text="E-mail"/><StrRes Name="154" Text="PDF"/><StrRes Name="zmPageWidth" Text="Page width"/><StrRes Name="z' + 
'mWholePage" Text="Whole page"/><StrRes Name="200" Text="Print"/><StrRes Name="201" Text="Printer"/><StrRes Name="202" Text="Pages"/><StrRes Name="203"' + 
' Text="Number of copies"/><StrRes Name="204" Text="Collate"/><StrRes Name="205" Text="Copies"/><StrRes Name="206" Text="Print"/><StrRes Name="207" Tex' + 
't="!Other"/><StrRes Name="208" Text="Where:"/><StrRes Name="209" Text="Properties..."/><StrRes Name="210" Text="Print to file"/><StrRes Name="211" Tex' + 
't="!Order"/><StrRes Name="212" Text="Name:"/><StrRes Name="213" Text="Print mode"/><StrRes Name="214" Text="Print on sheet"/><StrRes Name="216" Text="' + 
'Duplex"/><StrRes Name="ppAll" Text="All pages"/><StrRes Name="ppOdd" Text="Odd pages"/><StrRes Name="ppEven" Text="Even pages"/><StrRes Name="pgDefaul' + 
't" Text="Default"/><StrRes Name="pmDefault" Text="Default"/><StrRes Name="pmSplit" Text="Split big pages"/><StrRes Name="pmJoin" Text="Join small page' + 
's"/><StrRes Name="pmScale" Text="Scale"/><StrRes Name="poDirect" Text="!Direct (1-9)"/><StrRes Name="poReverse" Text="!Reverse (9-1)"/><StrRes Name="3' + 
'00" Text="Find Text"/><StrRes Name="301" Text="Text to find:"/><StrRes Name="302" Text="Search options"/><StrRes Name="303" Text="Replace with"/><StrR' + 
'es Name="304" Text="Search from beginning"/><StrRes Name="305" Text="Case sensitive"/><StrRes Name="400" Text="Page Settings"/><StrRes Name="401" Text' + 
'="Width"/><StrRes Name="402" Text="Height"/><StrRes Name="403" Text="Size"/><StrRes Name="404" Text="Orientation"/><StrRes Name="405" Text="Left"/><St' + 
'rRes Name="406" Text="Top"/><StrRes Name="407" Text="Right"/><StrRes Name="408" Text="Bottom"/><StrRes Name="409" Text="Margins"/><StrRes Name="410" T' + 
'ext="Portrait"/><StrRes Name="411" Text="Landscape"/><StrRes Name="412" Text="Other"/><StrRes Name="413" Text="Apply to the current page"/><StrRes Nam' + 
'e="414" Text="Apply to all pages"/><StrRes Name="500" Text="Print"/><StrRes Name="501" Text="Printer"/><StrRes Name="502" Text="Pages"/><StrRes Name="' + 
'503" Text="Copies"/><StrRes Name="504" Text="Number of copies"/><StrRes Name="505" Text="Options"/><StrRes Name="506" Text="Escape commands"/><StrRes ' + 
'Name="507" Text="Print to file"/><StrRes Name="508" Text="OEM codepage"/><StrRes Name="509" Text="Pseudographic"/><StrRes Name="510" Text="Printer fil' + 
'e (*.prn)|*.prn"/><StrRes Name="mbConfirm" Text="Confirm"/><StrRes Name="mbError" Text="Error"/><StrRes Name="mbInfo" Text="Information"/><StrRes Name' + 
'="xrCantFindClass" Text="Cannot find class"/><StrRes Name="prVirtual" Text="Virtual"/><StrRes Name="prDefault" Text="Default"/><StrRes Name="prCustom"' + 
' Text="Custom"/><StrRes Name="enUnconnHeader" Text="Unconnected header/footer"/><StrRes Name="enUnconnGroup" Text="No data band for the group"/><StrRe' + 
's Name="enUnconnGFooter" Text="No group header for"/><StrRes Name="enBandPos" Text="Incorrect band position:"/><StrRes Name="dbNotConn" Text="DataSet ' + 
'%s is not connected to data"/><StrRes Name="dbFldNotFound" Text="Field not found:"/><StrRes Name="clDSNotIncl" Text="(dataset is not included in Repor' + 
't.DataSets)"/><StrRes Name="clUnknownVar" Text="Unknown variable or datafield:"/><StrRes Name="clScrError" Text="Script error at %s: %s"/><StrRes Name' + 
'="clDSNotExist" Text="Dataset &#38;#34;%s&#38;#34; does not exist"/><StrRes Name="clErrors" Text="The following error(s) have occured:"/><StrRes Name=' + 
'"clExprError" Text="Error in expression"/><StrRes Name="clFP3files" Text="Prepared Report"/><StrRes Name="clComprPreparedRepFilter" Text="Compressed p' + 
'repared report (*.fp3)|*.fp3"/><StrRes Name="clSaving" Text="Saving file..."/><StrRes Name="clCancel" Text="Cancel"/><StrRes Name="clClose" Text="Clos' + 
'e"/><StrRes Name="clPrinting" Text="Printing page"/><StrRes Name="clLoading" Text="Loading file..."/><StrRes Name="clPageOf" Text="Page %d of %d"/><St' + 
'rRes Name="clOf" Text="of %d"/><StrRes Name="clFirstPass" Text="First pass: page "/><StrRes Name="clNoPrinters" Text="No printers installed on your sy' + 
'stem"/><StrRes Name="clDecompressError" Text="Stream decompress error"/><StrRes Name="crFillMx" Text="Filling the cross-tab..."/><StrRes Name="crBuild' + 
'Mx" Text="Building the cross-tab..."/><StrRes Name="prRunningFirst" Text="First pass: page %d"/><StrRes Name="prRunning" Text="Preparing page %d"/><St' + 
'rRes Name="prPrinting" Text="Printing page %d"/><StrRes Name="prExporting" Text="Exporting page %d"/><StrRes Name="uCm" Text="cm"/><StrRes Name="uInch' + 
'" Text="in"/><StrRes Name="uPix" Text="px"/><StrRes Name="uChar" Text="chr"/><StrRes Name="dupDefault" Text="Default"/><StrRes Name="dupVert" Text="Ve' + 
'rtical"/><StrRes Name="dupHorz" Text="Horizontal"/><StrRes Name="dupSimpl" Text="Simplex"/><StrRes Name="SLangNotFound" Text="Language ''%s'' not found"' + 
'/><StrRes Name="SInvalidLanguage" Text="Invalid language definition"/><StrRes Name="SIdRedeclared" Text="Identifier redeclared: "/><StrRes Name="SUnkn' + 
'ownType" Text="Unknown type: "/><StrRes Name="SIncompatibleTypes" Text="Incompatible types"/><StrRes Name="SIdUndeclared" Text="Undeclared identifier:' + 
' "/><StrRes Name="SClassRequired" Text="Class type required"/><StrRes Name="SIndexRequired" Text="Index required"/><StrRes Name="SStringError" Text="S' + 
'trings do not have properties or methods"/><StrRes Name="SClassError" Text="Class %s does not have a default property"/><StrRes Name="SArrayRequired" ' + 
'Text="Array type required"/><StrRes Name="SVarRequired" Text="Variable required"/><StrRes Name="SNotEnoughParams" Text="Not enough actual parameters"/' + 
'><StrRes Name="STooManyParams" Text="Too many actual parameters"/><StrRes Name="SLeftCantAssigned" Text="Left side cannot be assigned to"/><StrRes Nam' + 
'e="SForError" Text="For loop variable must be numeric variable"/><StrRes Name="SEventError" Text="Event handler must be a procedure"/><StrRes Name="60' + 
'0" Text="Expand all"/><StrRes Name="601" Text="Collapse all"/><StrRes Name="clStrNotFound" Text="Text not found"/><StrRes Name="clCantRen" Text="Could' + 
' not rename %s, it was introduced in the ancestor report"/><StrRes Name="rave0" Text="Rave Import"/><StrRes Name="rave1" Text="The Rave file doesn''t c' + 
'ontain TRaveReport items."/><StrRes Name="rave2" Text="The Rave file contains %d reports. Each report will be converted to one fr3 file. Choose a dire' + 
'ctory where fr3 files will be saved. Note that only the last report will be opened in the designer."/><StrRes Name="rave3" Text="Cannot create %s."/><' + 
'StrRes Name="rave4" Text="Report %s, page %s."/><StrRes Name="701" Text="Highlight editable text"/><StrRes Name="702" Text="Highlight"/><StrRes Name="' + 
'clCirRefNotAllow" Text="Circular child reference is not allowed"/><StrRes Name="clDupName" Text="Duplicate name"/><StrRes Name="clErrorInExp" Text="Er' + 
'ror in Calc expression:"/><StrRes Name="expMtm" Text="Timeout expired"/><StrRes Name="erInvalidImg" Text="Invalid image format"/><StrRes Name="ReportT' + 
'itle" Text="ReportTitle"/><StrRes Name="ReportSummary" Text="ReportSummary"/><StrRes Name="PageHeader" Text="PageHeader"/><StrRes Name="PageFooter" Te' + 
'xt="PageFooter"/><StrRes Name="Header" Text="Header"/><StrRes Name="Footer" Text="Footer"/><StrRes Name="MasterData" Text="MasterData"/><StrRes Name="' + 
'DetailData" Text="DetailData"/><StrRes Name="SubdetailData" Text="SubdetailData"/><StrRes Name="Data4" Text="Data4"/><StrRes Name="Data5" Text="Data5"' + 
'/><StrRes Name="Data6" Text="Data6"/><StrRes Name="GroupHeader" Text="GroupHeader"/><StrRes Name="GroupFooter" Text="GroupFooter"/><StrRes Name="Child' + 
'" Text="Child"/><StrRes Name="ColumnHeader" Text="ColumnHeader"/><StrRes Name="ColumnFooter" Text="ColumnFooter"/><StrRes Name="Overlay" Text="Overlay' + 
'"/><StrRes Name="2_5_interleaved" Text="2_5_interleaved"/><StrRes Name="2_5_industrial" Text="2_5_industrial"/><StrRes Name="2_5_matrix" Text="2_5_mat' + 
'rix"/><StrRes Name="Code39" Text="Code39"/><StrRes Name="Code39 Extended" Text="Code39 Extended"/><StrRes Name="Code128A" Text="Code128A"/><StrRes Nam' + 
'e="Code128B" Text="Code128B"/><StrRes Name="Code128C" Text="Code128C"/><StrRes Name="Code93" Text="Code93"/><StrRes Name="Code93 Extended" Text="Code9' + 
'3 Extended"/><StrRes Name="MSI" Text="MSI"/><StrRes Name="PostNet" Text="PostNet"/><StrRes Name="Codebar" Text="Codebar"/><StrRes Name="EAN8" Text="EA' + 
'N8"/><StrRes Name="EAN13" Text="EAN13"/><StrRes Name="UPC_A" Text="UPC_A"/><StrRes Name="UPC_E0" Text="UPC_E0"/><StrRes Name="UPC_E1" Text="UPC_E1"/><' + 
'StrRes Name="UPC Supp2" Text="UPC Supp2"/><StrRes Name="UPC Supp5" Text="UPC Supp5"/><StrRes Name="EAN128A" Text="EAN128A"/><StrRes Name="EAN128B" Tex' + 
't="EAN128B"/><StrRes Name="EAN128C" Text="EAN128C"/><StrRes Name="rpEditRep" Text="Edit Report..."/><StrRes Name="rpEditAlias" Text="Edit Fields Alias' + 
'es..."/><StrRes Name="160" Text="Copy content"/><StrRes Name="161" Text="Paste content"/><StrRes Name="162" Text="Save to"/><StrRes Name="163" Text="F' + 
'ile"/></Resources>' + 
' ';

initialization
  frxResources.AddXML(resXML);

end.
