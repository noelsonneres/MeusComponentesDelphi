unit frxDelphiMaxiCode;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}Windows,{$ENDIF} Graphics, SysUtils;

(* Copyright 2014-2015 Robin Stuart, Daniel Gredler
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.

 * Implements MaxiCode according to ISO 16023:2000.
 *
 * MaxiCode employs a pattern of hexagons around a central 'bulls-eye'
 * finder pattern. Encoding in several modes is supported, but encoding in
 * Mode 2 and 3 require primary messages to be set. Input characters can be
 * any from the ISO 8859-1 (Latin-1) character set.
 *
 * TODO: Add ECI functionality.
 *
 * @author <a href="mailto:rstuart114@gmail.com">Robin Stuart</a>
 * @author Daniel Gredler
 *)

type
  TMaxicodeEncoder = class
  private
    FData: WideString;
    FMode: Integer;

    procedure SetData(const Value: WideString);
    procedure SetMode(const Value: Integer);
    function GetIsBlack(Row, Column: integer): Boolean;
  protected
    FBitmap: TBitmap;

    procedure Update;
  public
    constructor Create;
    destructor Destroy; override;
    function Width: Integer;
    function Height: Integer;
    function GetScanLine(Column: Integer): PByteArray;

    property IsBlack[Row, Column: integer]: Boolean read GetIsBlack;
    property Data: WideString read FData write SetData;
    property Mode: Integer read FMode write SetMode;
  end;

implementation

uses
  Math, Classes, Types, frxUnicodeUtils, frxClass, frxUtils;

const
  INK_SPREAD = 0.9;
  OFFSET_X: array[0..5] of Extended = (0.0, 0.866, 0.866, 0.0, -0.866, -0.866);
  OFFSET_Y: array[0..5] of Extended = (1.0, 0.5,  -0.5,  -1.0, -0.5,    0.5);

type
  TLongIntArray = array of LongInt;

  TMaxiCodeImpl = class
  private
    FStructuredAppendPosition: LongInt;
    FStructuredAppendTotal: LongInt;
    FPrimaryData: AnsiString;
    FHexagonCount: Integer;

    procedure SetStructuredAppendPosition(const Value: Integer);
    procedure SetStructuredAppendTotal(const Value: Integer);
    function GetHexagonPoint(i, j: Integer): TfrxPoint;
    function GetEllipceCount: Integer;
    function GetEllipseRect(i: Integer): TfrxRect;
  protected
    FMode: Integer;
    eciMode: LongInt;
    FHexagonCenter: array[0..33 * 30] of TfrxPoint;
    FEllipseRect: array[0..2] of TfrxRect;
    codewords: TLongIntArray;
    source: TLongIntArray;
    sourcelen: Integer;
    Fset: array[0..144-1] of LongInt;
    character: array[0..144-1] of LongInt;
    grid: array[0..33-1, 0..30-1] of Boolean;

    function IsNumeral(str: AnsiString; i: Integer): Boolean;
    function Substring(str: AnsiString; startIndex: Integer; len: Integer = -1): AnsiString;
    function IndexOf(str, substr: AnsiString): integer;
    function IntParse(str: AnsiString; startIndex: Integer = 0; len: Integer = -1): Integer;

    function processText: Boolean;
    function getPrimaryCodewords: TLongIntArray;
    function getErrorCorrection(codewords: TLongIntArray; ecclen: Integer): TLongIntArray;
    procedure plotSymbol;
    function getMode2PrimaryCodewords(postcode: AnsiString; country, service: Integer): TLongIntArray;
    function getMode3PrimaryCodewords(postcode: AnsiString; country, service: Integer): TLongIntArray;
    function bestSurroundingSet(index, len: Integer; valid: array of Integer): Integer;
  public
    constructor Create;

    function Encode(inputBytes: AnsiString; Mode: Integer): Boolean;
    function HexagonCenter(Row, Col: Integer): TfrxPoint;
    function HexagonPointByIndex(Center: TfrxPoint; Index: Integer): TfrxPoint;

    property StructuredAppendPosition: LongInt read FStructuredAppendPosition write SetStructuredAppendPosition;
    property StructuredAppendTotal: LongInt read FStructuredAppendTotal write SetStructuredAppendTotal;
    property PrimaryData: AnsiString read FPrimaryData write FPrimaryData;

    property HexagonCount: Integer read FHexagonCount;
    property HexagonPoint[i, j: Integer]: TfrxPoint read GetHexagonPoint;
    property EllipceCount: Integer read GetEllipceCount;
    property EllipseRect[i: Integer]: TfrxRect read GetEllipseRect;
  end;

  TReedSolomon = class
  private
    logmod: LongInt;
    rlen: LongInt;
    logt: TLongIntArray;
    alog: TLongIntArray;
    rspoly: TLongIntArray;
  public
    res: TLongIntArray;

    function getResult(count: LongInt): LongInt;
    procedure init_gf(poly: LongInt);
    procedure init_code(nsym, index: LongInt);
    procedure encode(len: LongInt; data: TLongIntArray);

  end;

const
  //* MaxiCode module sequence, from ISO/IEC 16023 Figure 5 (30 x 33 data grid).
  MAXICODE_GRID: array [0..990-1] of integer = (
    122, 121, 128, 127, 134, 133, 140, 139, 146, 145, 152, 151, 158, 157, 164, 163, 170, 169, 176, 175, 182, 181, 188, 187, 194, 193, 200, 199, 0,   0,
    124, 123, 130, 129, 136, 135, 142, 141, 148, 147, 154, 153, 160, 159, 166, 165, 172, 171, 178, 177, 184, 183, 190, 189, 196, 195, 202, 201, 817, 0,
    126, 125, 132, 131, 138, 137, 144, 143, 150, 149, 156, 155, 162, 161, 168, 167, 174, 173, 180, 179, 186, 185, 192, 191, 198, 197, 204, 203, 819, 818,
    284, 283, 278, 277, 272, 271, 266, 265, 260, 259, 254, 253, 248, 247, 242, 241, 236, 235, 230, 229, 224, 223, 218, 217, 212, 211, 206, 205, 820, 0,
    286, 285, 280, 279, 274, 273, 268, 267, 262, 261, 256, 255, 250, 249, 244, 243, 238, 237, 232, 231, 226, 225, 220, 219, 214, 213, 208, 207, 822, 821,
    288, 287, 282, 281, 276, 275, 270, 269, 264, 263, 258, 257, 252, 251, 246, 245, 240, 239, 234, 233, 228, 227, 222, 221, 216, 215, 210, 209, 823, 0,
    290, 289, 296, 295, 302, 301, 308, 307, 314, 313, 320, 319, 326, 325, 332, 331, 338, 337, 344, 343, 350, 349, 356, 355, 362, 361, 368, 367, 825, 824,
    292, 291, 298, 297, 304, 303, 310, 309, 316, 315, 322, 321, 328, 327, 334, 333, 340, 339, 346, 345, 352, 351, 358, 357, 364, 363, 370, 369, 826, 0,
    294, 293, 300, 299, 306, 305, 312, 311, 318, 317, 324, 323, 330, 329, 336, 335, 342, 341, 348, 347, 354, 353, 360, 359, 366, 365, 372, 371, 828, 827,
    410, 409, 404, 403, 398, 397, 392, 391, 80,  79,  0,   0,   14,  13,  38,  37,  3,   0,   45,  44,  110, 109, 386, 385, 380, 379, 374, 373, 829, 0,
    412, 411, 406, 405, 400, 399, 394, 393, 82,  81,  41,  0,   16,  15,  40,  39,  4,   0,   0,   46,  112, 111, 388, 387, 382, 381, 376, 375, 831, 830,
    414, 413, 408, 407, 402, 401, 396, 395, 84,  83,  42,  0,   0,   0,   0,   0,   6,   5,   48,  47,  114, 113, 390, 389, 384, 383, 378, 377, 832, 0,
    416, 415, 422, 421, 428, 427, 104, 103, 56,  55,  17,  0,   0,   0,   0,   0,   0,   0,   21,  20,  86,  85,  434, 433, 440, 439, 446, 445, 834, 833,
    418, 417, 424, 423, 430, 429, 106, 105, 58,  57,  0,   0,   0,   0,   0,   0,   0,   0,   23,  22,  88,  87,  436, 435, 442, 441, 448, 447, 835, 0,
    420, 419, 426, 425, 432, 431, 108, 107, 60,  59,  0,   0,   0,   0,   0,   0,   0,   0,   0,   24,  90,  89,  438, 437, 444, 443, 450, 449, 837, 836,
    482, 481, 476, 475, 470, 469, 49,  0,   31,  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   1,   54,  53,  464, 463, 458, 457, 452, 451, 838, 0,
    484, 483, 478, 477, 472, 471, 50,  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   466, 465, 460, 459, 454, 453, 840, 839,
    486, 485, 480, 479, 474, 473, 52,  51,  32,  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   2,   0,   43,  468, 467, 462, 461, 456, 455, 841, 0,
    488, 487, 494, 493, 500, 499, 98,  97,  62,  61,  0,   0,   0,   0,   0,   0,   0,   0,   0,   27,  92,  91,  506, 505, 512, 511, 518, 517, 843, 842,
    490, 489, 496, 495, 502, 501, 100, 99,  64,  63,  0,   0,   0,   0,   0,   0,   0,   0,   29,  28,  94,  93,  508, 507, 514, 513, 520, 519, 844, 0,
    492, 491, 498, 497, 504, 503, 102, 101, 66,  65,  18,  0,   0,   0,   0,   0,   0,   0,   19,  30,  96,  95,  510, 509, 516, 515, 522, 521, 846, 845,
    560, 559, 554, 553, 548, 547, 542, 541, 74,  73,  33,  0,   0,   0,   0,   0,   0,   11,  68,  67,  116, 115, 536, 535, 530, 529, 524, 523, 847, 0,
    562, 561, 556, 555, 550, 549, 544, 543, 76,  75,  0,   0,   8,   7,   36,  35,  12,  0,   70,  69,  118, 117, 538, 537, 532, 531, 526, 525, 849, 848,
    564, 563, 558, 557, 552, 551, 546, 545, 78,  77,  0,   34,  10,  9,   26,  25,  0,   0,   72,  71,  120, 119, 540, 539, 534, 533, 528, 527, 850, 0,
    566, 565, 572, 571, 578, 577, 584, 583, 590, 589, 596, 595, 602, 601, 608, 607, 614, 613, 620, 619, 626, 625, 632, 631, 638, 637, 644, 643, 852, 851,
    568, 567, 574, 573, 580, 579, 586, 585, 592, 591, 598, 597, 604, 603, 610, 609, 616, 615, 622, 621, 628, 627, 634, 633, 640, 639, 646, 645, 853, 0,
    570, 569, 576, 575, 582, 581, 588, 587, 594, 593, 600, 599, 606, 605, 612, 611, 618, 617, 624, 623, 630, 629, 636, 635, 642, 641, 648, 647, 855, 854,
    728, 727, 722, 721, 716, 715, 710, 709, 704, 703, 698, 697, 692, 691, 686, 685, 680, 679, 674, 673, 668, 667, 662, 661, 656, 655, 650, 649, 856, 0,
    730, 729, 724, 723, 718, 717, 712, 711, 706, 705, 700, 699, 694, 693, 688, 687, 682, 681, 676, 675, 670, 669, 664, 663, 658, 657, 652, 651, 858, 857,
    732, 731, 726, 725, 720, 719, 714, 713, 708, 707, 702, 701, 696, 695, 690, 689, 684, 683, 678, 677, 672, 671, 666, 665, 660, 659, 654, 653, 859, 0,
    734, 733, 740, 739, 746, 745, 752, 751, 758, 757, 764, 763, 770, 769, 776, 775, 782, 781, 788, 787, 794, 793, 800, 799, 806, 805, 812, 811, 861, 860,
    736, 735, 742, 741, 748, 747, 754, 753, 760, 759, 766, 765, 772, 771, 778, 777, 784, 783, 790, 789, 796, 795, 802, 801, 808, 807, 814, 813, 862, 0,
    738, 737, 744, 743, 750, 749, 756, 755, 762, 761, 768, 767, 774, 773, 780, 779, 786, 785, 792, 791, 798, 797, 804, 803, 810, 809, 816, 815, 864, 863
  );

  //* ASCII character to Code Set mapping, from ISO/IEC 16023 Appendix A.
  //* 1 = Set A, 2 = Set B, 3 = Set C, 4 = Set D, 5 = Set E.
  //* 0 refers to special characters that fit into more than one set (e.g. GS).
  MAXICODE_SET: array [0..256-1] of integer = (
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 5, 5, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 5, 0, 2, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2,
    2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4,
    4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
    5, 4, 5, 5, 5, 5, 5, 5, 4, 5, 3, 4, 3, 5, 5, 4, 4, 3, 3, 3,
    4, 3, 5, 4, 4, 3, 3, 4, 3, 3, 3, 4, 3, 3, 3, 3, 3, 3, 3, 3,
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
    3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
  );

  //* ASCII character to symbol value, from ISO/IEC 16023 Appendix A.
  MAXICODE_SYMBOL_CHAR: array [0..256-1] of integer = (
    0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 26, 30, 28, 29, 30, 35, 32, 53, 34, 35, 36, 37, 38, 39,
    40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 37,
    38, 39, 40, 41, 52, 1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 42, 43, 44, 45, 46, 0,  1,  2,  3,
    4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
    24, 25, 26, 32, 54, 34, 35, 36, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 47, 48,
    49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 36,
    37, 37, 38, 39, 40, 41, 42, 43, 38, 44, 37, 39, 38, 45, 46, 40, 41, 39, 40, 41,
    42, 42, 47, 43, 44, 43, 44, 45, 45, 46, 47, 46, 0,  1,  2,  3,  4,  5,  6,  7,
    8,  9,  10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 32,
    33, 34, 35, 36, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 32, 33, 34, 35, 36
  );

{ TMaxiCodeImpl }

function TMaxiCodeImpl.bestSurroundingSet(index, len: Integer;
  valid: array of Integer): Integer;

  function contains(values: array of Integer; value: integer): boolean;
  var
    i: Integer;
  begin
    Result := True;
    for i := 0 to High(values) do
      if values[i] = value then
        Exit;
    Result := False;
  end;

var
  option1, option2: Integer;
begin
  option1 := Fset[index - 1];
  if index + 1 < len then // we have two options to check
  begin
    option2 := Fset[index + 1];
    if      contains(valid, option1) and contains(valid, option2) then
      Result := Min(option1, option2)
    else if contains(valid, option1) then
      Result := option1
    else if contains(valid, option2) then
      Result := option2
    else
      Result := valid[0];
  end
  else // we only have one option to check
  begin
    if contains(valid, option1) then
      Result := option1
    else
      Result := valid[0];
  end;
end;

constructor TMaxiCodeImpl.Create;
const
  radii: array [0..2] of Extended = (9.91, 6.16, 2.37);
var
  i: Integer;
begin
  FMode := 4;

  eciMode := 3;
  structuredAppendPosition := 1;
  structuredAppendTotal := 1;
  PrimaryData := '';

  FHexagonCount := 0;

  for i := 0 to High(radii) do
    FEllipseRect[i] := frxRect(35.76 - radii[i], 35.60 - radii[i],
                               35.76 + radii[i], 35.60 + radii[i]);
end;

function TMaxiCodeImpl.Encode(inputBytes: AnsiString; Mode: Integer): Boolean;

  function insert(original: TLongIntArray; index: Integer; inserted: TLongIntArray): TLongIntArray;

    function ArrayCopy(sourceArray: TLongIntArray; sourceIndex: Integer;
      destinationArray: TLongIntArray; destinationIndex, len: Integer): TLongIntArray;
    begin
      Move(sourceArray[sourceIndex], destinationArray[destinationIndex],
        len * SizeOf(sourceArray[0]));
    end;

  var
    modified: TLongIntArray;
  begin
    SetLength(modified, Length(original) + Length(inserted));
    ArrayCopy(original, 0, modified, 0, index);
    ArrayCopy(inserted, 0, modified, index, Length(inserted));
    ArrayCopy(original, index, modified, index + Length(inserted), Length(modified) - index - Length(inserted));
    result := modified;
  end;

var
  i, j, index, secondaryMax, secondaryECMax, totalMax, block, bit: Integer;
  _primary, flag, primary, primaryCheck, secondary, secondaryOdd, secondaryEven,
  secondaryECOdd, secondaryECEven, bit_pattern: TLongIntArray;
begin
  sourcelen := Length(inputBytes);
  FMode := Mode;
  SetLength(source, sourcelen);
  for i := 0 to sourcelen - 1 do
    source[i] := Ord(inputBytes[i + 1]); // i + 1: delphi string is 1-based

  // mode 2 -> mode 3 if postal code isn't strictly numeric
  if FMode = 2 then
    for i := 0 to Min(9, Length(PrimaryData) - 1) do
      if not IsNumeral(PrimaryData, i) then
      begin
        FMode := 3;
        Break;
      end;

  // initialize the set and character arrays
  if not processText then
    raise Exception.Create('Input data too long');

  // start building the codeword array, starting with a copy of the character data
  // insert primary message if this is a structured carrier message; insert mode otherwise
  SetLength(codewords, Length(character));
  Move(character[0], codewords[0], Length(character) * SizeOf(character[0]));
  if FMode in [2..3] then
  begin
    _primary := getPrimaryCodewords;
    if Length(_primary) = 0 then
    begin
      Result := False;
      Exit;
    end;
    codewords := insert(codewords, 0, _primary);
  end
  else
  begin
    SetLength(_primary, 1);
    _primary[0] := FMode;
    codewords := insert(codewords, 0, _primary);
  end;

  // insert structured append flag if necessary
  if StructuredAppendTotal > 1 then
  begin
    SetLength(flag, 2);
    flag[0] := 33; // padding
    flag[1] := ((StructuredAppendTotal - 1) shl 3) or (structuredAppendTotal - 1); // position + total
    if FMode in [2..3] then
      index := 10 // first two data symbols in the secondary message
    else
      index := 1; // first two data symbols in the primary message (first symbol at index 0 isn't a data symbol)
    codewords := insert(codewords, index, flag);
  end;

  if FMode = 5 then // 68 data codewords, 56 error corrections in secondary message
  begin
    secondaryMax := 68;
    secondaryECMax := 56;
  end
  else // 84 data codewords, 40 error corrections in secondary message
  begin
    secondaryMax := 84;
    secondaryECMax := 40;
  end;

  // truncate data codewords to maximum data space available
  totalMax := secondaryMax + 10;
  if (Length(codewords) > totalMax) then
    SetLength(codewords, totalMax);

  // insert primary error correction between primary message and secondary message (always EEC)
  primary := Copy(codewords, 0, 10);
  primaryCheck := getErrorCorrection(primary, 10);
  codewords := insert(codewords, 10, primaryCheck);

  // calculate secondary error correction
  secondary := Copy(codewords, 20, Length(codewords) - 20);
  SetLength(secondaryOdd, Length(secondary) div 2);
  SetLength(secondaryEven, Length(secondary) div 2);
  for i := 0 to Length(secondary) - 1 do
    if Odd(i) then
      secondaryOdd[(i - 1) div 2] := secondary[i]
    else
      secondaryEven[i div 2] := secondary[i];

  secondaryECOdd := getErrorCorrection(secondaryOdd, secondaryECMax div 2);
  secondaryECEven := getErrorCorrection(secondaryEven, secondaryECMax div 2);

  // add secondary error correction after secondary message
  SetLength(codewords, Length(codewords) + Length(secondaryECOdd) + Length(secondaryECEven));
  for i := 0 to Length(secondaryECOdd) - 1 do
    codewords[20 + secondaryMax + (2 * i) + 1] := secondaryECOdd[i];
  for i := 0 to Length(secondaryECEven) - 1 do
    codewords[20 + secondaryMax + (2 * i)] := secondaryECEven[i];

  // copy data into symbol grid
  SetLength(bit_pattern, 7);
  for i := 0 to 33 - 1 do
    for j := 0 to 30 - 1 do
    begin
      block := (MAXICODE_GRID[(i * 30) + j] + 5) div 6;
      bit := (MAXICODE_GRID[(i * 30) + j] + 5) mod 6;
      if block <> 0 then
      begin
        bit_pattern[0] := (codewords[block - 1] and $20) shr 5;
        bit_pattern[1] := (codewords[block - 1] and $10) shr 4;
        bit_pattern[2] := (codewords[block - 1] and  $8) shr 3;
        bit_pattern[3] := (codewords[block - 1] and  $4) shr 2;
        bit_pattern[4] := (codewords[block - 1] and  $2) shr 1;
        bit_pattern[5] := (codewords[block - 1] and  $1);
        grid[i, j] := bit_pattern[bit] <> 0;
      end;
    end;

    // add orientation markings
    grid[ 0, 28] := True;  // top right filler
    grid[ 0, 29] := True;
    grid[ 9, 10] := True;  // top left marker
    grid[ 9, 11] := True;
    grid[10, 11] := True;
    grid[15,  7] := True;  // left hand marker
    grid[16,  8] := True;
    grid[16, 20] := True; // right hand marker
    grid[17, 20] := True;
    grid[22, 10] := True; // bottom left marker
    grid[23, 10] := True;
    grid[22, 17] := True; // bottom right marker
    grid[23, 17] := True;

    plotSymbol;

    Result := True;
end;

function TMaxiCodeImpl.GetEllipceCount: Integer;
begin
  Result := 3;
end;

function TMaxiCodeImpl.GetEllipseRect(i: Integer): TfrxRect;
begin
  Result := FEllipseRect[i];
end;

function TMaxiCodeImpl.getErrorCorrection(codewords: TLongIntArray;
  ecclen: Integer): TLongIntArray;
var
  results: TLongIntArray;
  rs: TReedSolomon;
  i: Integer;
begin
  rs := TReedSolomon.Create;
  rs.init_gf($43);
  rs.init_code(ecclen, 1);
  rs.encode(Length(codewords), codewords);
  SetLength(results, ecclen);
  for i := 0 to ecclen - 1 do
    results[i] := rs.getResult(Length(results) - 1 - i);
  Result := results;
  rs.Free;
end;

function TMaxiCodeImpl.GetHexagonPoint(i, j: Integer): TfrxPoint;
begin
  Result := HexagonPointByIndex(FHexagonCenter[i], j);
end;

function TMaxiCodeImpl.getMode2PrimaryCodewords(postcode: AnsiString; country,
  service: Integer): TLongIntArray;
var
  i, postcodeNum: LongInt;
  primary: TLongIntArray;
begin
  for i := 0 to Length(postcode) - 1 do
    if not IsNumeral(postcode, i) then
    begin
      postcode := Substring(postcode, 0, i);
      Break;
    end;

  postcodeNum := IntParse(postcode);
  SetLength(primary, 10);
  primary[0] := ((postcodeNum and $03) shl 4) or 2;
  primary[1] := ((postcodeNum and $fc) shr 2);
  primary[2] := ((postcodeNum and $3f00) shr 8);
  primary[3] := ((postcodeNum and $fc000) shr 14);
  primary[4] := ((postcodeNum and $3f00000) shr 20);
  primary[5] := ((postcodeNum and $3c000000) shr 26) or ((Length(postcode) and $3) shl 4);
  primary[6] := ((Length(postcode) and $3c) shr 2) or ((country and $3) shl 4);
  primary[7] := (country and $fc) shr 2;
  primary[8] := ((country and $300) shr 8) or ((service and $f) shl 2);
  primary[9] := ((service and $3f0) shr 4);

  Result := primary;
end;

function TMaxiCodeImpl.getMode3PrimaryCodewords(postcode: AnsiString; country,
  service: Integer): TLongIntArray;
var
  postcodeNums: TLongIntArray;
  i: Integer;
  primary: TLongIntArray;
begin
  SetLength(postcodeNums, Length(postcode));
  postcode := AnsiString(UpperCase(String(postcode)));

  for i := 0 to Length(postcode) - 1 do
  begin
    postcodeNums[i] := Ord(postcode[i + 1]); // i + 1: delphi string is 1-based
    if (postcode[i + 1] >= 'A') and (postcode[i + 1] <= 'Z') then
      // (Capital) letters shifted to Code Set A values
      postcodeNums[i] := postcodeNums[i] - 64;
    if (postcodeNums[i] in [27, 31, 33]) or (postcodeNums[i] >= 59) then
      // Not a valid postal code character, use space instead
      postcodeNums[i] := 32;
    // Input characters lower than 27 (NUL - SUB) in postal code are interpreted as capital
    // letters in Code Set A (e.g. LF becomes 'J')
  end;

  SetLength(primary, 10);
  primary[0] := ((postcodeNums[5] and $03) shl 4) or 3;
  primary[1] := ((postcodeNums[4] and $03) shl 4) or ((postcodeNums[5] and $3c) shr 2);
  primary[2] := ((postcodeNums[3] and $03) shl 4) or ((postcodeNums[4] and $3c) shr 2);
  primary[3] := ((postcodeNums[2] and $03) shl 4) or ((postcodeNums[3] and $3c) shr 2);
  primary[4] := ((postcodeNums[1] and $03) shl 4) or ((postcodeNums[2] and $3c) shr 2);
  primary[5] := ((postcodeNums[0] and $03) shl 4) or ((postcodeNums[1] and $3c) shr 2);
  primary[6] := ((postcodeNums[0] and $3c) shr 2) or ((country and $3) shl 4);
  primary[7] := (country and $fc) shr 2;
  primary[8] := ((country and $300) shr 8) or ((service and $f) shl 2);
  primary[9] := ((service and $3f0) shr 4);

  Result := primary;
end;

function TMaxiCodeImpl.getPrimaryCodewords: TLongIntArray;
var
  i, index, country, service: Integer;
  postcode: AnsiString;
begin
  if Length(PrimaryData) <> 15 then
    raise Exception.Create('Invalid Primary String');

  for i := 9 to 15 do // check that country code and service are numeric
    if not IsNumeral(PrimaryData, i) then
      raise Exception.Create('Invalid Primary String');

  if FMode = 2 then
  begin
    postcode := Substring(PrimaryData, 0, 9);
    index := IndexOf(PrimaryData, ' ');
    if index > -1 then
      postcode := Substring(postcode, 0, index);
  end
  else // FMode = 3
    postcode := Substring(PrimaryData, 0, 6);

  country := IntParse(PrimaryData, 9, 3);
  service := IntParse(PrimaryData, 12, 3);

  if FMode = 2 then
    Result := getMode2PrimaryCodewords(postcode, country, service)
  else // Mode = 3
    Result := getMode3PrimaryCodewords(postcode, country, service);
end;

function TMaxiCodeImpl.HexagonCenter(Row, Col: Integer): TfrxPoint;
begin
  Result := frxPoint((2.46 * Col) + 1.23 + (Row and $1) * 1.23,
                     (2.135 * Row) + 1.43);
end;

function TMaxiCodeImpl.HexagonPointByIndex(Center: TfrxPoint;
  Index: Integer): TfrxPoint;
begin
  with Center do
  begin
    Result.X := X + OFFSET_X[Index] * INK_SPREAD;
    Result.Y := Y + OFFSET_Y[Index] * INK_SPREAD;
  end;
end;

function TMaxiCodeImpl.IndexOf(str, substr: AnsiString): integer;
begin
  Result := Pos(substr, str) - 1; // zero based index
end;

function TMaxiCodeImpl.IntParse(str: AnsiString; startIndex: Integer = 0;
  len: Integer = -1): Integer;
begin
  Result := StrToInt(String(Substring(str, startIndex, len)));
end;

function TMaxiCodeImpl.IsNumeral(str: AnsiString; i: Integer): Boolean;
begin
  Result := str[i + 1] in ['0'..'9']; // i + 1: delphi string is 1-based
end;

procedure TMaxiCodeImpl.plotSymbol;
var
  row, col: Integer;
begin
  // hexagons
  FHexagonCount := 0;
  for row := 0 to 33 - 1 do
    for col := 0 to 30 - 1 do
      if grid[row, col] then
      begin
        FHexagonCenter[FHexagonCount] := HexagonCenter(row, col);
        FHexagonCount := FHexagonCount + 1;
      end;
end;

function TMaxiCodeImpl.processText: Boolean;

  procedure insert(position, c: Integer);
  var
    i: Integer;
  begin
    for i := 144 - 1 downto position + 1 do
    begin
      FSet[i] := FSet[i - 1];
      character[i] := character[i - 1];
    end;
    character[position] := c;
  end;

var
  i, j, len, count, current_set: Integer;
  value: LongInt;
begin
  Result := False;
  if sourcelen > 138 then
    Exit;
  len := sourcelen;
  for i := 0 to 144 - 1 do
  begin
    Fset[i] := -1;
    character[i] := 0;
  end;
  for i := 0 to len - 1 do
  begin
    // Look up characters in table from Appendix A - this gives
    // value and code set for most characters
    Fset[i] := MAXICODE_SET[source[i]];
    character[i] := MAXICODE_SYMBOL_CHAR[source[i]];
  end;

  // If a character can be represented in more than one code set, pick which version to use.
  if Fset[0] = 0 then
  begin
    if character[0] = 13 then
      character[0] := 0;
    Fset[0] := 1;
  end;

  for i := 1 to len - 1 do
    if Fset[i] = 0 then
      // Special character that can be represented in more than one code set.
      if      character[i] = 13 then // Carriage Return
      begin
        Fset[i] := bestSurroundingSet(i, len, [1, 5]);
        if Fset[i] = 5 then character[i] := 13
        else                character[i] := 0;
      end
      else if character[i] = 28 then // FS
      begin
        Fset[i] := bestSurroundingSet(i, len, [1, 2, 3, 4, 5]);
        if Fset[i] = 5 then character[i] := 32;
      end
      else if character[i] = 29 then // GS
      begin
        Fset[i] := bestSurroundingSet(i, len, [1, 2, 3, 4, 5]);
        if Fset[i] = 5 then character[i] := 33;
      end
      else if character[i] = 30 then // RS
      begin
        Fset[i] := bestSurroundingSet(i, len, [1, 2, 3, 4, 5]);
        if Fset[i] = 5 then character[i] := 34;
      end
      else if character[i] = 32 then // Space
      begin
        Fset[i] := bestSurroundingSet(i, len, [1, 2, 3, 4, 5]);
        if      Fset[i] = 1 then character[i] := 32
        else if Fset[i] = 2 then character[i] := 47
        else                     character[i] := 59;
      end
      else if character[i] = 44 then // Comma
      begin
        Fset[i] := bestSurroundingSet(i, len, [1, 2]);
        if Fset[i] = 2 then character[i] := 48;
      end
      else if character[i] = 46 then // Full Stop
      begin
        Fset[i] := bestSurroundingSet(i, len, [1, 2]);
        if Fset[i] = 2 then character[i] := 49;
      end
      else if character[i] = 47 then // Slash
      begin
        Fset[i] := bestSurroundingSet(i, len, [1, 2]);
        if Fset[i] = 2 then character[i] := 50;
      end
      else if character[i] = 58 then // Colon
      begin
        Fset[i] := bestSurroundingSet(i, len, [1, 2]);
        if Fset[i] = 2 then character[i] := 51;
      end;

  for i := len to Length(Fset) - 1 do // Add the padding
  begin
    if Fset[len - 1] = 2 then Fset[i] := 2
    else                      Fset[i] := 1;
    character[i] := 33;
  end;

  // Find candidates for number compression (not allowed in primary message in modes 2 and 3).
  if FMode in [2, 3] then j := 9
  else                    j := 0;
  count := 0;
  for i := j to 144 - 1 do
  begin
    if (Fset[i] = 1) and (character[i] in [48..57]) then // Character is a number
      count := count + 1
    else
      count := 0;
    if count = 9 then // Nine digits in a row can be compressed
    begin
      Fset[i]     := 6; Fset[i - 1] := 6; Fset[i - 2] := 6;
      Fset[i - 3] := 6; Fset[i - 4] := 6; Fset[i - 5] := 6;
      Fset[i - 6] := 6; Fset[i - 7] := 6; Fset[i - 8] := 6;
      count := 0;
    end;
  end;

  // Add shift and latch characters
  current_set := 1;
  i := 0;
  repeat
    if (Fset[i] <> current_set) and (Fset[i] <> 6) then
    begin
      case Fset[i] of
        1:
          if (i + 1 < Length(Fset)) and (Fset[i + 1] = 1) then
          begin
            if (i + 2 < Length(Fset)) and (Fset[i + 2] = 1) then
            begin
              if (i + 3 < Length(Fset)) and (Fset[i + 3] = 1) then // Latch A
              begin
                insert(i, 63);
                current_set := 1;
                len := len + 1;
                i := i + 3;
              end
              else // 3 Shift A
              begin
                insert(i, 57);
                len := len + 1;
                i := i + 2;
              end;
            end
            else // 2 Shift A
            begin
              insert(i, 56);
              len := len + 1;
              i := i + 1;
            end;
          end
          else // Shift A
          begin
            insert(i, 59);
            len := len + 1;
          end;
        2:
          if (i + 1 < Length(Fset)) and (Fset[i + 1] = 2) then //
          begin
            insert(i, 63);
            current_set := 2;
            len := len + 1;
            i := i + 1;
          end
          else // Shift B
          begin
            insert(i, 59);
            len := len + 1;
          end;
        3:
          if (i + 3 < Length(Fset)) and
             (Fset[i + 1] = 3) and (Fset[i + 2] = 3) and (Fset[i + 3] = 3) then // Lock In C
          begin
            insert(i, 60);
            insert(i, 60);
            current_set := 3;
            len := len + 1;
            i := i + 3;
          end
          else // Shift C
          begin
            insert(i, 60);
            len := len + 1;
          end;
        4:
          if (i + 3 < Length(Fset)) and
             (Fset[i + 1] = 4) and (Fset[i + 2] = 4) and (Fset[i + 3] = 4) then // Lock In D
          begin
            insert(i, 61);
            insert(i, 61);
            current_set := 4;
            len := len + 1;
            i := i + 3;
          end
          else // Shift D
          begin
            insert(i, 61);
            len := len + 1;
          end;
        5:
          if (i + 3 < Length(Fset)) and
             (Fset[i + 1] = 5) and (Fset[i + 2] = 5) and (Fset[i + 5] = 4) then // Lock In E
          begin
            insert(i, 62);
            insert(i, 62);
            current_set := 5;
            len := len + 1;
            i := i + 3;
          end
          else // Shift E
          begin
            insert(i, 62);
            len := len + 1;
          end;
      else
        raise Exception.Create('Unexpected set ' + IntToStr(Fset[i]) + ' at index ' + IntToStr(i));
      end;
      i := i + 1;
    end;
    i := i + 1;
  until i >= Length(Fset);

  // Number compression has not been forgotten! It's handled below.
  i := 0;
  repeat
    if Fset[i] = 6 then // Number compression
    begin
      value := 0;
      for j := 0 to 9 - 1 do
      begin
        value := value * 10;
        value := value + (character[i + j] - Ord('0'));
      end;
      character[i] := 31; // NS
      character[i + 1] := (value and $3f000000) shr 24;
      character[i + 2] := (value and $fc0000) shr 18;
      character[i + 3] := (value and $3f000) shr 12;
      character[i + 4] := (value and $fc0) shr 6;
      character[i + 5] := (value and $3f);
      i := i + 6;
      for j := i to 140 - 1 do
      begin
        Fset[j] := Fset[j + 3];
        character[j] := character[j + 3];
      end;
      len := len - 3;
    end
    else
      i := i + 1;
  until i >= Length(Fset);

  // Inject ECI codes to beginning of data, according to Table
  if eciMode <> 3 then
  begin
    insert(0, 27); // ECI

    if eciMode in [0..31] then
    begin
      insert(1, eciMode and $1F);
      len := len + 2;
    end;

    if (eciMode >= 32) and (eciMode <= 1023) then
    begin
      insert(1, $20 + (eciMode shr 6));
      insert(2, eciMode and $3F);
      len := len + 3;
    end;

    if (eciMode >= 1024) and (eciMode <= 32767) then
    begin
      insert(1, $30 + (eciMode shr 12));
      insert(2, (eciMode shr 6) and $3F);
      insert(3, eciMode and $3F);
      len := len + 4;
    end;

    if (eciMode >= 32768) and (eciMode <= 999999) then
    begin
      insert(1, $38 + (eciMode shr 18));
      insert(2, (eciMode shr 12) and $3F);
      insert(3, (eciMode shr 6) and $3F);
      insert(4, eciMode and $3F);
      len := len + 5;
    end;
  end;

  if (FMode in [2, 3]) and (len > 84) or
     (FMode in [4, 6]) and (len > 93) or
     (FMode = 5) and (len > 77) then
    Result := False
  else
    Result := True;
end;

procedure TMaxiCodeImpl.SetStructuredAppendPosition(const Value: Integer);
begin
  if not (Value in [1..8]) then
    raise Exception.Create('Invalid MaxiCode structured append position: ' + IntToStr(Value));
  if FStructuredAppendPosition <> Value then
    FStructuredAppendPosition := Value;
end;

procedure TMaxiCodeImpl.SetStructuredAppendTotal(const Value: Integer);
begin
  if not (Value in [1..8]) then
    raise Exception.Create('Invalid MaxiCode structured append total: ' + IntToStr(Value));
  if FStructuredAppendTotal <> Value then
    FStructuredAppendTotal := Value;
end;

function TMaxiCodeImpl.Substring(str: AnsiString; startIndex: Integer;
  len: Integer = -1): AnsiString;
begin
  if len = -1 then
    len := Length(str);
  Result := Copy(str, startIndex + 1, len); // i + 1: delphi string is 1-based
end;

{ TReedSolomon }

procedure TReedSolomon.encode(len: LongInt; data: TLongIntArray);
var
  i, k, m: LongInt;
begin
  SetLength(res, rlen);
  for i := 0 to rlen - 1 do
    res[i] := 0;
  for i := 0 to len - 1 do
  begin
    m := res[rlen - 1] xor data[i];
    for k := rlen - 1 downto 1 do
      if (m <> 0) and (rspoly[k] <> 0) then
        res[k] := res[k - 1] xor (alog[(logt[m] + logt[rspoly[k]]) mod logmod])
      else
        res[k] := res[k - 1];
    if (m <> 0) and (rspoly[0] <> 0) then
      res[0] := alog[(logt[m] + logt[rspoly[0]]) mod logmod]
    else
      res[0] := 0;
  end;
end;

function TReedSolomon.getResult(count: LongInt): LongInt;
begin
  Result := res[count];
end;

procedure TReedSolomon.init_code(nsym, index: LongInt);
var
  i, k: LongInt;
begin
  SetLength(rspoly, nsym + 1);
  rlen := nsym;
  rspoly[0] := 1;
  for i := 1 to nsym do
  begin
    rspoly[i] := 1;
    for k := i-1 downto 1 do
    begin
      if rspoly[k] <> 0 then
        rspoly[k] := alog[(logt[rspoly[k]] + index) mod logmod];
      rspoly[k] := rspoly[k] xor rspoly[k - 1];
    end;
    rspoly[0] := alog[(logt[rspoly[0]] + index) mod logmod];
    index := index + 1;
  end;
end;

procedure TReedSolomon.init_gf(poly: LongInt);
var
  m, b, p, v: LongInt;
begin
  // Find the top bit, and hence the symbol size
  b := 1;
  m := 0;
  while b <= poly do
  begin
    b := b shl 1;
    m := m + 1;
  end;
  b := b shr 1;
  m := m - 1;
  // Calculate the log/alog tables
  logmod := (1 shl m) - 1;
  SetLength(logt, logmod + 1);
  SetLength(alog, logmod);
  p := 1;
  v := 0;
  while v < logmod do
  begin
    alog[v] := p;
    logt[p] := v;
    p := p shl 1;
    if (p and b) <> 0 then
      p := p xor poly;
    v := v + 1;
  end;
end;

{ TMaxicodeEncoder }

const
  FieldSizeFactor = 2.47;
  PenSizeFactor = 4.5;
  HalfPen = PenSizeFactor / 2;

constructor TMaxicodeEncoder.Create;
begin
  FData := '';
  FMode := 4;

  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf1Bit;
end;

destructor TMaxicodeEncoder.Destroy;
begin
  FBitmap.Free;

  inherited;
end;

function TMaxicodeEncoder.GetScanLine(Column: Integer): PByteArray;
begin
  Result := PByteArray(FBitmap.ScanLine[Column]);
end;

function TMaxicodeEncoder.GetIsBlack(Row, Column: integer): Boolean;
begin
  Result := FBitmap.Canvas.Pixels[Row, Column] = clBlack;
end;

function TMaxicodeEncoder.Height: Integer;
begin
  Result := FBitmap.Height;
end;

procedure TMaxicodeEncoder.SetData(const Value: WideString);
begin
  if FData <> Value then
  begin
    FData := Value;
    Update;
  end;
end;

procedure TMaxicodeEncoder.SetMode(const Value: Integer);
begin
  if not (Value in [2..6]) then
    raise Exception.Create('Invalid MaxiCode mode: ' + IntToStr(Value));
  if FMode <> Value then
  begin
    FMode := Value;
    Update;
  end;
end;

procedure TMaxicodeEncoder.Update;
var
  AnsiSt: AnsiString;
  Encoder: TMaxiCodeImpl;
  MaxSize: Extended;
  i, j: Integer;
  DrawPoints: array [0..5] of TPoint;
begin
{$IFDEF Delphi12}
  AnsiSt := _UnicodeToAnsi(Data, DEFAULT_CHARSET);
{$ELSE}
  AnsiSt := AnsiString(Data);
{$ENDIF}
  Encoder := TMaxiCodeImpl.Create;
  try
    Encoder.Encode(AnsiSt, Mode);

    // CalcBounds
    MaxSize := 0;
    for j := 0 to 5 do
    with Encoder.HexagonPointByIndex(Encoder.HexagonCenter(33 - 1, 30 - 1), j)  do
      MaxSize := Max(MaxSize, Max(X, y));

    FBitmap.Width := Round(FieldSizeFactor * MaxSize) + 1;
    FBitmap.Height := FBitmap.Width;

    FBitmap.Canvas.Brush.Color := clWhite;
    FBitmap.Canvas.FillRect(FBitmap.Canvas.ClipRect);

    // Draw
    FBitmap.Canvas.Brush.Color := clBlack;
    FBitmap.Canvas.Pen.Color := clBlack;
    FBitmap.Canvas.Pen.Width := 1;

    for i := 0 to Encoder.HexagonCount - 1 do
    begin
      for j := 0 to 5 do
        with Encoder.HexagonPoint[i, j] do
          DrawPoints[j] := Point(Round(FieldSizeFactor * X), Round(FieldSizeFactor * Y));
      FBitmap.Canvas.Polygon(DrawPoints);
    end;

    FBitmap.Canvas.Brush.Color := clWhite;
    FBitmap.Canvas.Pen.Width := Round(PenSizeFactor);
    for i := 0 to Encoder.EllipceCount - 1 do
      with Encoder.EllipseRect[i] do
        FBitmap.Canvas.Ellipse(Round(FieldSizeFactor * Left  ),
                               Round(FieldSizeFactor * Top   ),
                               Round(FieldSizeFactor * Right ) + 1,
                               Round(FieldSizeFactor * Bottom) + 1);
  finally
    Encoder.Free;
  end;
end;

function TMaxicodeEncoder.Width: Integer;
begin
  Result := FBitmap.Width;
end;

end.
