// Generates the 2D barcode PDF417. Supports dimensioning auto-sizing, fixed
// and variable sizes, automatic and manual error levels, raw codeword input,
// codeword size optimization and bitmap inversion.
// Author: Paulo Soares (psoares@consiste.pt)
// Modifications by Alexander Tzyganenko
//




unit frxBarcodePDF417;


interface

{$I frx.inc}

uses
{$IFDEF FPC}
  LCLType, LMessages, LazHelper, LCLIntf,
{$ELSE}
  Windows, Messages,
{$ENDIF}
  SysUtils, Types, StrUtils, Classes, Graphics, Controls, Forms, Dialogs, frxBarcode2DBase, frxPrinter;

type

     TInt = array of integer;
     PInt = ^TInt;

const

    START_PATTERN = $1fea8;
    STOP_PATTERN = $3fa29;
    START_CODE_SIZE = 17;
    STOP_SIZE = 18;
    _MOD = 929;
    ALPHA = $10000;
    LOWER = $20000;
    MIXED = $40000;
    PUNCTUATION = $80000;
    ISBYTE = $100000;
    BYTESHIFT = 913;
    PL = 25;
    LL = 27;
    _AS = 27;
    ML = 28;
    AL = 28;
    PS = 29;
    PAL = 29;
    SPACE = 26;
    TEXT_MODE = 900;
    BYTE_MODE_6 = 924;
    BYTE_MODE = 901;
    NUMERIC_MODE = 902;
    ABSOLUTE_MAX_TEXT_SIZE = 5420;
    MAX_DATA_CODEWORDS = 926;
    MACRO_SEGMENT_ID = 928;
    MACRO_LAST_SEGMENT = 922;

    MIXED_SET = '0123456789&'#13#9',:#-.$/+%*=^';
    PUNCTUATION_SET = ';<>@[\]_`~!'#13#9',:'#10'-.$/"|*()?{}''';

    CLUSTERS : array[0..2,0..928] of integer =
    (
        (
            $1d5c0, $1eaf0, $1f57c, $1d4e0, $1ea78, $1f53e, $1a8c0, $1d470,
            $1a860, $15040, $1a830, $15020, $1adc0, $1d6f0, $1eb7c, $1ace0,
            $1d678, $1eb3e, $158c0, $1ac70, $15860, $15dc0, $1aef0, $1d77c,
            $15ce0, $1ae78, $1d73e, $15c70, $1ae3c, $15ef0, $1af7c, $15e78,
            $1af3e, $15f7c, $1f5fa, $1d2e0, $1e978, $1f4be, $1a4c0, $1d270,
            $1e93c, $1a460, $1d238, $14840, $1a430, $1d21c, $14820, $1a418,
            $14810, $1a6e0, $1d378, $1e9be, $14cc0, $1a670, $1d33c, $14c60,
            $1a638, $1d31e, $14c30, $1a61c, $14ee0, $1a778, $1d3be, $14e70,
            $1a73c, $14e38, $1a71e, $14f78, $1a7be, $14f3c, $14f1e, $1a2c0,
            $1d170, $1e8bc, $1a260, $1d138, $1e89e, $14440, $1a230, $1d11c,
            $14420, $1a218, $14410, $14408, $146c0, $1a370, $1d1bc, $14660,
            $1a338, $1d19e, $14630, $1a31c, $14618, $1460c, $14770, $1a3bc,
            $14738, $1a39e, $1471c, $147bc, $1a160, $1d0b8, $1e85e, $14240,
            $1a130, $1d09c, $14220, $1a118, $1d08e, $14210, $1a10c, $14208,
            $1a106, $14360, $1a1b8, $1d0de, $14330, $1a19c, $14318, $1a18e,
            $1430c, $14306, $1a1de, $1438e, $14140, $1a0b0, $1d05c, $14120,
            $1a098, $1d04e, $14110, $1a08c, $14108, $1a086, $14104, $141b0,
            $14198, $1418c, $140a0, $1d02e, $1a04c, $1a046, $14082, $1cae0,
            $1e578, $1f2be, $194c0, $1ca70, $1e53c, $19460, $1ca38, $1e51e,
            $12840, $19430, $12820, $196e0, $1cb78, $1e5be, $12cc0, $19670,
            $1cb3c, $12c60, $19638, $12c30, $12c18, $12ee0, $19778, $1cbbe,
            $12e70, $1973c, $12e38, $12e1c, $12f78, $197be, $12f3c, $12fbe,
            $1dac0, $1ed70, $1f6bc, $1da60, $1ed38, $1f69e, $1b440, $1da30,
            $1ed1c, $1b420, $1da18, $1ed0e, $1b410, $1da0c, $192c0, $1c970,
            $1e4bc, $1b6c0, $19260, $1c938, $1e49e, $1b660, $1db38, $1ed9e,
            $16c40, $12420, $19218, $1c90e, $16c20, $1b618, $16c10, $126c0,
            $19370, $1c9bc, $16ec0, $12660, $19338, $1c99e, $16e60, $1b738,
            $1db9e, $16e30, $12618, $16e18, $12770, $193bc, $16f70, $12738,
            $1939e, $16f38, $1b79e, $16f1c, $127bc, $16fbc, $1279e, $16f9e,
            $1d960, $1ecb8, $1f65e, $1b240, $1d930, $1ec9c, $1b220, $1d918,
            $1ec8e, $1b210, $1d90c, $1b208, $1b204, $19160, $1c8b8, $1e45e,
            $1b360, $19130, $1c89c, $16640, $12220, $1d99c, $1c88e, $16620,
            $12210, $1910c, $16610, $1b30c, $19106, $12204, $12360, $191b8,
            $1c8de, $16760, $12330, $1919c, $16730, $1b39c, $1918e, $16718,
            $1230c, $12306, $123b8, $191de, $167b8, $1239c, $1679c, $1238e,
            $1678e, $167de, $1b140, $1d8b0, $1ec5c, $1b120, $1d898, $1ec4e,
            $1b110, $1d88c, $1b108, $1d886, $1b104, $1b102, $12140, $190b0,
            $1c85c, $16340, $12120, $19098, $1c84e, $16320, $1b198, $1d8ce,
            $16310, $12108, $19086, $16308, $1b186, $16304, $121b0, $190dc,
            $163b0, $12198, $190ce, $16398, $1b1ce, $1638c, $12186, $16386,
            $163dc, $163ce, $1b0a0, $1d858, $1ec2e, $1b090, $1d84c, $1b088,
            $1d846, $1b084, $1b082, $120a0, $19058, $1c82e, $161a0, $12090,
            $1904c, $16190, $1b0cc, $19046, $16188, $12084, $16184, $12082,
            $120d8, $161d8, $161cc, $161c6, $1d82c, $1d826, $1b042, $1902c,
            $12048, $160c8, $160c4, $160c2, $18ac0, $1c570, $1e2bc, $18a60,
            $1c538, $11440, $18a30, $1c51c, $11420, $18a18, $11410, $11408,
            $116c0, $18b70, $1c5bc, $11660, $18b38, $1c59e, $11630, $18b1c,
            $11618, $1160c, $11770, $18bbc, $11738, $18b9e, $1171c, $117bc,
            $1179e, $1cd60, $1e6b8, $1f35e, $19a40, $1cd30, $1e69c, $19a20,
            $1cd18, $1e68e, $19a10, $1cd0c, $19a08, $1cd06, $18960, $1c4b8,
            $1e25e, $19b60, $18930, $1c49c, $13640, $11220, $1cd9c, $1c48e,
            $13620, $19b18, $1890c, $13610, $11208, $13608, $11360, $189b8,
            $1c4de, $13760, $11330, $1cdde, $13730, $19b9c, $1898e, $13718,
            $1130c, $1370c, $113b8, $189de, $137b8, $1139c, $1379c, $1138e,
            $113de, $137de, $1dd40, $1eeb0, $1f75c, $1dd20, $1ee98, $1f74e,
            $1dd10, $1ee8c, $1dd08, $1ee86, $1dd04, $19940, $1ccb0, $1e65c,
            $1bb40, $19920, $1eedc, $1e64e, $1bb20, $1dd98, $1eece, $1bb10,
            $19908, $1cc86, $1bb08, $1dd86, $19902, $11140, $188b0, $1c45c,
            $13340, $11120, $18898, $1c44e, $17740, $13320, $19998, $1ccce,
            $17720, $1bb98, $1ddce, $18886, $17710, $13308, $19986, $17708,
            $11102, $111b0, $188dc, $133b0, $11198, $188ce, $177b0, $13398,
            $199ce, $17798, $1bbce, $11186, $13386, $111dc, $133dc, $111ce,
            $177dc, $133ce, $1dca0, $1ee58, $1f72e, $1dc90, $1ee4c, $1dc88,
            $1ee46, $1dc84, $1dc82, $198a0, $1cc58, $1e62e, $1b9a0, $19890,
            $1ee6e, $1b990, $1dccc, $1cc46, $1b988, $19884, $1b984, $19882,
            $1b982, $110a0, $18858, $1c42e, $131a0, $11090, $1884c, $173a0,
            $13190, $198cc, $18846, $17390, $1b9cc, $11084, $17388, $13184,
            $11082, $13182, $110d8, $1886e, $131d8, $110cc, $173d8, $131cc,
            $110c6, $173cc, $131c6, $110ee, $173ee, $1dc50, $1ee2c, $1dc48,
            $1ee26, $1dc44, $1dc42, $19850, $1cc2c, $1b8d0, $19848, $1cc26,
            $1b8c8, $1dc66, $1b8c4, $19842, $1b8c2, $11050, $1882c, $130d0,
            $11048, $18826, $171d0, $130c8, $19866, $171c8, $1b8e6, $11042,
            $171c4, $130c2, $171c2, $130ec, $171ec, $171e6, $1ee16, $1dc22,
            $1cc16, $19824, $19822, $11028, $13068, $170e8, $11022, $13062,
            $18560, $10a40, $18530, $10a20, $18518, $1c28e, $10a10, $1850c,
            $10a08, $18506, $10b60, $185b8, $1c2de, $10b30, $1859c, $10b18,
            $1858e, $10b0c, $10b06, $10bb8, $185de, $10b9c, $10b8e, $10bde,
            $18d40, $1c6b0, $1e35c, $18d20, $1c698, $18d10, $1c68c, $18d08,
            $1c686, $18d04, $10940, $184b0, $1c25c, $11b40, $10920, $1c6dc,
            $1c24e, $11b20, $18d98, $1c6ce, $11b10, $10908, $18486, $11b08,
            $18d86, $10902, $109b0, $184dc, $11bb0, $10998, $184ce, $11b98,
            $18dce, $11b8c, $10986, $109dc, $11bdc, $109ce, $11bce, $1cea0,
            $1e758, $1f3ae, $1ce90, $1e74c, $1ce88, $1e746, $1ce84, $1ce82,
            $18ca0, $1c658, $19da0, $18c90, $1c64c, $19d90, $1cecc, $1c646,
            $19d88, $18c84, $19d84, $18c82, $19d82, $108a0, $18458, $119a0,
            $10890, $1c66e, $13ba0, $11990, $18ccc, $18446, $13b90, $19dcc,
            $10884, $13b88, $11984, $10882, $11982, $108d8, $1846e, $119d8,
            $108cc, $13bd8, $119cc, $108c6, $13bcc, $119c6, $108ee, $119ee,
            $13bee, $1ef50, $1f7ac, $1ef48, $1f7a6, $1ef44, $1ef42, $1ce50,
            $1e72c, $1ded0, $1ef6c, $1e726, $1dec8, $1ef66, $1dec4, $1ce42,
            $1dec2, $18c50, $1c62c, $19cd0, $18c48, $1c626, $1bdd0, $19cc8,
            $1ce66, $1bdc8, $1dee6, $18c42, $1bdc4, $19cc2, $1bdc2, $10850,
            $1842c, $118d0, $10848, $18426, $139d0, $118c8, $18c66, $17bd0,
            $139c8, $19ce6, $10842, $17bc8, $1bde6, $118c2, $17bc4, $1086c,
            $118ec, $10866, $139ec, $118e6, $17bec, $139e6, $17be6, $1ef28,
            $1f796, $1ef24, $1ef22, $1ce28, $1e716, $1de68, $1ef36, $1de64,
            $1ce22, $1de62, $18c28, $1c616, $19c68, $18c24, $1bce8, $19c64,
            $18c22, $1bce4, $19c62, $1bce2, $10828, $18416, $11868, $18c36,
            $138e8, $11864, $10822, $179e8, $138e4, $11862, $179e4, $138e2,
            $179e2, $11876, $179f6, $1ef12, $1de34, $1de32, $19c34, $1bc74,
            $1bc72, $11834, $13874, $178f4, $178f2, $10540, $10520, $18298,
            $10510, $10508, $10504, $105b0, $10598, $1058c, $10586, $105dc,
            $105ce, $186a0, $18690, $1c34c, $18688, $1c346, $18684, $18682,
            $104a0, $18258, $10da0, $186d8, $1824c, $10d90, $186cc, $10d88,
            $186c6, $10d84, $10482, $10d82, $104d8, $1826e, $10dd8, $186ee,
            $10dcc, $104c6, $10dc6, $104ee, $10dee, $1c750, $1c748, $1c744,
            $1c742, $18650, $18ed0, $1c76c, $1c326, $18ec8, $1c766, $18ec4,
            $18642, $18ec2, $10450, $10cd0, $10448, $18226, $11dd0, $10cc8,
            $10444, $11dc8, $10cc4, $10442, $11dc4, $10cc2, $1046c, $10cec,
            $10466, $11dec, $10ce6, $11de6, $1e7a8, $1e7a4, $1e7a2, $1c728,
            $1cf68, $1e7b6, $1cf64, $1c722, $1cf62, $18628, $1c316, $18e68,
            $1c736, $19ee8, $18e64, $18622, $19ee4, $18e62, $19ee2, $10428,
            $18216, $10c68, $18636, $11ce8, $10c64, $10422, $13de8, $11ce4,
            $10c62, $13de4, $11ce2, $10436, $10c76, $11cf6, $13df6, $1f7d4,
            $1f7d2, $1e794, $1efb4, $1e792, $1efb2, $1c714, $1cf34, $1c712,
            $1df74, $1cf32, $1df72, $18614, $18e34, $18612, $19e74, $18e32,
            $1bef4
        ),
        (
            $1f560, $1fab8, $1ea40, $1f530, $1fa9c, $1ea20, $1f518, $1fa8e,
            $1ea10, $1f50c, $1ea08, $1f506, $1ea04, $1eb60, $1f5b8, $1fade,
            $1d640, $1eb30, $1f59c, $1d620, $1eb18, $1f58e, $1d610, $1eb0c,
            $1d608, $1eb06, $1d604, $1d760, $1ebb8, $1f5de, $1ae40, $1d730,
            $1eb9c, $1ae20, $1d718, $1eb8e, $1ae10, $1d70c, $1ae08, $1d706,
            $1ae04, $1af60, $1d7b8, $1ebde, $15e40, $1af30, $1d79c, $15e20,
            $1af18, $1d78e, $15e10, $1af0c, $15e08, $1af06, $15f60, $1afb8,
            $1d7de, $15f30, $1af9c, $15f18, $1af8e, $15f0c, $15fb8, $1afde,
            $15f9c, $15f8e, $1e940, $1f4b0, $1fa5c, $1e920, $1f498, $1fa4e,
            $1e910, $1f48c, $1e908, $1f486, $1e904, $1e902, $1d340, $1e9b0,
            $1f4dc, $1d320, $1e998, $1f4ce, $1d310, $1e98c, $1d308, $1e986,
            $1d304, $1d302, $1a740, $1d3b0, $1e9dc, $1a720, $1d398, $1e9ce,
            $1a710, $1d38c, $1a708, $1d386, $1a704, $1a702, $14f40, $1a7b0,
            $1d3dc, $14f20, $1a798, $1d3ce, $14f10, $1a78c, $14f08, $1a786,
            $14f04, $14fb0, $1a7dc, $14f98, $1a7ce, $14f8c, $14f86, $14fdc,
            $14fce, $1e8a0, $1f458, $1fa2e, $1e890, $1f44c, $1e888, $1f446,
            $1e884, $1e882, $1d1a0, $1e8d8, $1f46e, $1d190, $1e8cc, $1d188,
            $1e8c6, $1d184, $1d182, $1a3a0, $1d1d8, $1e8ee, $1a390, $1d1cc,
            $1a388, $1d1c6, $1a384, $1a382, $147a0, $1a3d8, $1d1ee, $14790,
            $1a3cc, $14788, $1a3c6, $14784, $14782, $147d8, $1a3ee, $147cc,
            $147c6, $147ee, $1e850, $1f42c, $1e848, $1f426, $1e844, $1e842,
            $1d0d0, $1e86c, $1d0c8, $1e866, $1d0c4, $1d0c2, $1a1d0, $1d0ec,
            $1a1c8, $1d0e6, $1a1c4, $1a1c2, $143d0, $1a1ec, $143c8, $1a1e6,
            $143c4, $143c2, $143ec, $143e6, $1e828, $1f416, $1e824, $1e822,
            $1d068, $1e836, $1d064, $1d062, $1a0e8, $1d076, $1a0e4, $1a0e2,
            $141e8, $1a0f6, $141e4, $141e2, $1e814, $1e812, $1d034, $1d032,
            $1a074, $1a072, $1e540, $1f2b0, $1f95c, $1e520, $1f298, $1f94e,
            $1e510, $1f28c, $1e508, $1f286, $1e504, $1e502, $1cb40, $1e5b0,
            $1f2dc, $1cb20, $1e598, $1f2ce, $1cb10, $1e58c, $1cb08, $1e586,
            $1cb04, $1cb02, $19740, $1cbb0, $1e5dc, $19720, $1cb98, $1e5ce,
            $19710, $1cb8c, $19708, $1cb86, $19704, $19702, $12f40, $197b0,
            $1cbdc, $12f20, $19798, $1cbce, $12f10, $1978c, $12f08, $19786,
            $12f04, $12fb0, $197dc, $12f98, $197ce, $12f8c, $12f86, $12fdc,
            $12fce, $1f6a0, $1fb58, $16bf0, $1f690, $1fb4c, $169f8, $1f688,
            $1fb46, $168fc, $1f684, $1f682, $1e4a0, $1f258, $1f92e, $1eda0,
            $1e490, $1fb6e, $1ed90, $1f6cc, $1f246, $1ed88, $1e484, $1ed84,
            $1e482, $1ed82, $1c9a0, $1e4d8, $1f26e, $1dba0, $1c990, $1e4cc,
            $1db90, $1edcc, $1e4c6, $1db88, $1c984, $1db84, $1c982, $1db82,
            $193a0, $1c9d8, $1e4ee, $1b7a0, $19390, $1c9cc, $1b790, $1dbcc,
            $1c9c6, $1b788, $19384, $1b784, $19382, $1b782, $127a0, $193d8,
            $1c9ee, $16fa0, $12790, $193cc, $16f90, $1b7cc, $193c6, $16f88,
            $12784, $16f84, $12782, $127d8, $193ee, $16fd8, $127cc, $16fcc,
            $127c6, $16fc6, $127ee, $1f650, $1fb2c, $165f8, $1f648, $1fb26,
            $164fc, $1f644, $1647e, $1f642, $1e450, $1f22c, $1ecd0, $1e448,
            $1f226, $1ecc8, $1f666, $1ecc4, $1e442, $1ecc2, $1c8d0, $1e46c,
            $1d9d0, $1c8c8, $1e466, $1d9c8, $1ece6, $1d9c4, $1c8c2, $1d9c2,
            $191d0, $1c8ec, $1b3d0, $191c8, $1c8e6, $1b3c8, $1d9e6, $1b3c4,
            $191c2, $1b3c2, $123d0, $191ec, $167d0, $123c8, $191e6, $167c8,
            $1b3e6, $167c4, $123c2, $167c2, $123ec, $167ec, $123e6, $167e6,
            $1f628, $1fb16, $162fc, $1f624, $1627e, $1f622, $1e428, $1f216,
            $1ec68, $1f636, $1ec64, $1e422, $1ec62, $1c868, $1e436, $1d8e8,
            $1c864, $1d8e4, $1c862, $1d8e2, $190e8, $1c876, $1b1e8, $1d8f6,
            $1b1e4, $190e2, $1b1e2, $121e8, $190f6, $163e8, $121e4, $163e4,
            $121e2, $163e2, $121f6, $163f6, $1f614, $1617e, $1f612, $1e414,
            $1ec34, $1e412, $1ec32, $1c834, $1d874, $1c832, $1d872, $19074,
            $1b0f4, $19072, $1b0f2, $120f4, $161f4, $120f2, $161f2, $1f60a,
            $1e40a, $1ec1a, $1c81a, $1d83a, $1903a, $1b07a, $1e2a0, $1f158,
            $1f8ae, $1e290, $1f14c, $1e288, $1f146, $1e284, $1e282, $1c5a0,
            $1e2d8, $1f16e, $1c590, $1e2cc, $1c588, $1e2c6, $1c584, $1c582,
            $18ba0, $1c5d8, $1e2ee, $18b90, $1c5cc, $18b88, $1c5c6, $18b84,
            $18b82, $117a0, $18bd8, $1c5ee, $11790, $18bcc, $11788, $18bc6,
            $11784, $11782, $117d8, $18bee, $117cc, $117c6, $117ee, $1f350,
            $1f9ac, $135f8, $1f348, $1f9a6, $134fc, $1f344, $1347e, $1f342,
            $1e250, $1f12c, $1e6d0, $1e248, $1f126, $1e6c8, $1f366, $1e6c4,
            $1e242, $1e6c2, $1c4d0, $1e26c, $1cdd0, $1c4c8, $1e266, $1cdc8,
            $1e6e6, $1cdc4, $1c4c2, $1cdc2, $189d0, $1c4ec, $19bd0, $189c8,
            $1c4e6, $19bc8, $1cde6, $19bc4, $189c2, $19bc2, $113d0, $189ec,
            $137d0, $113c8, $189e6, $137c8, $19be6, $137c4, $113c2, $137c2,
            $113ec, $137ec, $113e6, $137e6, $1fba8, $175f0, $1bafc, $1fba4,
            $174f8, $1ba7e, $1fba2, $1747c, $1743e, $1f328, $1f996, $132fc,
            $1f768, $1fbb6, $176fc, $1327e, $1f764, $1f322, $1767e, $1f762,
            $1e228, $1f116, $1e668, $1e224, $1eee8, $1f776, $1e222, $1eee4,
            $1e662, $1eee2, $1c468, $1e236, $1cce8, $1c464, $1dde8, $1cce4,
            $1c462, $1dde4, $1cce2, $1dde2, $188e8, $1c476, $199e8, $188e4,
            $1bbe8, $199e4, $188e2, $1bbe4, $199e2, $1bbe2, $111e8, $188f6,
            $133e8, $111e4, $177e8, $133e4, $111e2, $177e4, $133e2, $177e2,
            $111f6, $133f6, $1fb94, $172f8, $1b97e, $1fb92, $1727c, $1723e,
            $1f314, $1317e, $1f734, $1f312, $1737e, $1f732, $1e214, $1e634,
            $1e212, $1ee74, $1e632, $1ee72, $1c434, $1cc74, $1c432, $1dcf4,
            $1cc72, $1dcf2, $18874, $198f4, $18872, $1b9f4, $198f2, $1b9f2,
            $110f4, $131f4, $110f2, $173f4, $131f2, $173f2, $1fb8a, $1717c,
            $1713e, $1f30a, $1f71a, $1e20a, $1e61a, $1ee3a, $1c41a, $1cc3a,
            $1dc7a, $1883a, $1987a, $1b8fa, $1107a, $130fa, $171fa, $170be,
            $1e150, $1f0ac, $1e148, $1f0a6, $1e144, $1e142, $1c2d0, $1e16c,
            $1c2c8, $1e166, $1c2c4, $1c2c2, $185d0, $1c2ec, $185c8, $1c2e6,
            $185c4, $185c2, $10bd0, $185ec, $10bc8, $185e6, $10bc4, $10bc2,
            $10bec, $10be6, $1f1a8, $1f8d6, $11afc, $1f1a4, $11a7e, $1f1a2,
            $1e128, $1f096, $1e368, $1e124, $1e364, $1e122, $1e362, $1c268,
            $1e136, $1c6e8, $1c264, $1c6e4, $1c262, $1c6e2, $184e8, $1c276,
            $18de8, $184e4, $18de4, $184e2, $18de2, $109e8, $184f6, $11be8,
            $109e4, $11be4, $109e2, $11be2, $109f6, $11bf6, $1f9d4, $13af8,
            $19d7e, $1f9d2, $13a7c, $13a3e, $1f194, $1197e, $1f3b4, $1f192,
            $13b7e, $1f3b2, $1e114, $1e334, $1e112, $1e774, $1e332, $1e772,
            $1c234, $1c674, $1c232, $1cef4, $1c672, $1cef2, $18474, $18cf4,
            $18472, $19df4, $18cf2, $19df2, $108f4, $119f4, $108f2, $13bf4,
            $119f2, $13bf2, $17af0, $1bd7c, $17a78, $1bd3e, $17a3c, $17a1e,
            $1f9ca, $1397c, $1fbda, $17b7c, $1393e, $17b3e, $1f18a, $1f39a,
            $1f7ba, $1e10a, $1e31a, $1e73a, $1ef7a, $1c21a, $1c63a, $1ce7a,
            $1defa, $1843a, $18c7a, $19cfa, $1bdfa, $1087a, $118fa, $139fa,
            $17978, $1bcbe, $1793c, $1791e, $138be, $179be, $178bc, $1789e,
            $1785e, $1e0a8, $1e0a4, $1e0a2, $1c168, $1e0b6, $1c164, $1c162,
            $182e8, $1c176, $182e4, $182e2, $105e8, $182f6, $105e4, $105e2,
            $105f6, $1f0d4, $10d7e, $1f0d2, $1e094, $1e1b4, $1e092, $1e1b2,
            $1c134, $1c374, $1c132, $1c372, $18274, $186f4, $18272, $186f2,
            $104f4, $10df4, $104f2, $10df2, $1f8ea, $11d7c, $11d3e, $1f0ca,
            $1f1da, $1e08a, $1e19a, $1e3ba, $1c11a, $1c33a, $1c77a, $1823a,
            $1867a, $18efa, $1047a, $10cfa, $11dfa, $13d78, $19ebe, $13d3c,
            $13d1e, $11cbe, $13dbe, $17d70, $1bebc, $17d38, $1be9e, $17d1c,
            $17d0e, $13cbc, $17dbc, $13c9e, $17d9e, $17cb8, $1be5e, $17c9c,
            $17c8e, $13c5e, $17cde, $17c5c, $17c4e, $17c2e, $1c0b4, $1c0b2,
            $18174, $18172, $102f4, $102f2, $1e0da, $1c09a, $1c1ba, $1813a,
            $1837a, $1027a, $106fa, $10ebe, $11ebc, $11e9e, $13eb8, $19f5e,
            $13e9c, $13e8e, $11e5e, $13ede, $17eb0, $1bf5c, $17e98, $1bf4e,
            $17e8c, $17e86, $13e5c, $17edc, $13e4e, $17ece, $17e58, $1bf2e,
            $17e4c, $17e46, $13e2e, $17e6e, $17e2c, $17e26, $10f5e, $11f5c,
            $11f4e, $13f58, $19fae, $13f4c, $13f46, $11f2e, $13f6e, $13f2c,
            $13f26
        ),
        (
            $1abe0, $1d5f8, $153c0, $1a9f0, $1d4fc, $151e0, $1a8f8, $1d47e,
            $150f0, $1a87c, $15078, $1fad0, $15be0, $1adf8, $1fac8, $159f0,
            $1acfc, $1fac4, $158f8, $1ac7e, $1fac2, $1587c, $1f5d0, $1faec,
            $15df8, $1f5c8, $1fae6, $15cfc, $1f5c4, $15c7e, $1f5c2, $1ebd0,
            $1f5ec, $1ebc8, $1f5e6, $1ebc4, $1ebc2, $1d7d0, $1ebec, $1d7c8,
            $1ebe6, $1d7c4, $1d7c2, $1afd0, $1d7ec, $1afc8, $1d7e6, $1afc4,
            $14bc0, $1a5f0, $1d2fc, $149e0, $1a4f8, $1d27e, $148f0, $1a47c,
            $14878, $1a43e, $1483c, $1fa68, $14df0, $1a6fc, $1fa64, $14cf8,
            $1a67e, $1fa62, $14c7c, $14c3e, $1f4e8, $1fa76, $14efc, $1f4e4,
            $14e7e, $1f4e2, $1e9e8, $1f4f6, $1e9e4, $1e9e2, $1d3e8, $1e9f6,
            $1d3e4, $1d3e2, $1a7e8, $1d3f6, $1a7e4, $1a7e2, $145e0, $1a2f8,
            $1d17e, $144f0, $1a27c, $14478, $1a23e, $1443c, $1441e, $1fa34,
            $146f8, $1a37e, $1fa32, $1467c, $1463e, $1f474, $1477e, $1f472,
            $1e8f4, $1e8f2, $1d1f4, $1d1f2, $1a3f4, $1a3f2, $142f0, $1a17c,
            $14278, $1a13e, $1423c, $1421e, $1fa1a, $1437c, $1433e, $1f43a,
            $1e87a, $1d0fa, $14178, $1a0be, $1413c, $1411e, $141be, $140bc,
            $1409e, $12bc0, $195f0, $1cafc, $129e0, $194f8, $1ca7e, $128f0,
            $1947c, $12878, $1943e, $1283c, $1f968, $12df0, $196fc, $1f964,
            $12cf8, $1967e, $1f962, $12c7c, $12c3e, $1f2e8, $1f976, $12efc,
            $1f2e4, $12e7e, $1f2e2, $1e5e8, $1f2f6, $1e5e4, $1e5e2, $1cbe8,
            $1e5f6, $1cbe4, $1cbe2, $197e8, $1cbf6, $197e4, $197e2, $1b5e0,
            $1daf8, $1ed7e, $169c0, $1b4f0, $1da7c, $168e0, $1b478, $1da3e,
            $16870, $1b43c, $16838, $1b41e, $1681c, $125e0, $192f8, $1c97e,
            $16de0, $124f0, $1927c, $16cf0, $1b67c, $1923e, $16c78, $1243c,
            $16c3c, $1241e, $16c1e, $1f934, $126f8, $1937e, $1fb74, $1f932,
            $16ef8, $1267c, $1fb72, $16e7c, $1263e, $16e3e, $1f274, $1277e,
            $1f6f4, $1f272, $16f7e, $1f6f2, $1e4f4, $1edf4, $1e4f2, $1edf2,
            $1c9f4, $1dbf4, $1c9f2, $1dbf2, $193f4, $193f2, $165c0, $1b2f0,
            $1d97c, $164e0, $1b278, $1d93e, $16470, $1b23c, $16438, $1b21e,
            $1641c, $1640e, $122f0, $1917c, $166f0, $12278, $1913e, $16678,
            $1b33e, $1663c, $1221e, $1661e, $1f91a, $1237c, $1fb3a, $1677c,
            $1233e, $1673e, $1f23a, $1f67a, $1e47a, $1ecfa, $1c8fa, $1d9fa,
            $191fa, $162e0, $1b178, $1d8be, $16270, $1b13c, $16238, $1b11e,
            $1621c, $1620e, $12178, $190be, $16378, $1213c, $1633c, $1211e,
            $1631e, $121be, $163be, $16170, $1b0bc, $16138, $1b09e, $1611c,
            $1610e, $120bc, $161bc, $1209e, $1619e, $160b8, $1b05e, $1609c,
            $1608e, $1205e, $160de, $1605c, $1604e, $115e0, $18af8, $1c57e,
            $114f0, $18a7c, $11478, $18a3e, $1143c, $1141e, $1f8b4, $116f8,
            $18b7e, $1f8b2, $1167c, $1163e, $1f174, $1177e, $1f172, $1e2f4,
            $1e2f2, $1c5f4, $1c5f2, $18bf4, $18bf2, $135c0, $19af0, $1cd7c,
            $134e0, $19a78, $1cd3e, $13470, $19a3c, $13438, $19a1e, $1341c,
            $1340e, $112f0, $1897c, $136f0, $11278, $1893e, $13678, $19b3e,
            $1363c, $1121e, $1361e, $1f89a, $1137c, $1f9ba, $1377c, $1133e,
            $1373e, $1f13a, $1f37a, $1e27a, $1e6fa, $1c4fa, $1cdfa, $189fa,
            $1bae0, $1dd78, $1eebe, $174c0, $1ba70, $1dd3c, $17460, $1ba38,
            $1dd1e, $17430, $1ba1c, $17418, $1ba0e, $1740c, $132e0, $19978,
            $1ccbe, $176e0, $13270, $1993c, $17670, $1bb3c, $1991e, $17638,
            $1321c, $1761c, $1320e, $1760e, $11178, $188be, $13378, $1113c,
            $17778, $1333c, $1111e, $1773c, $1331e, $1771e, $111be, $133be,
            $177be, $172c0, $1b970, $1dcbc, $17260, $1b938, $1dc9e, $17230,
            $1b91c, $17218, $1b90e, $1720c, $17206, $13170, $198bc, $17370,
            $13138, $1989e, $17338, $1b99e, $1731c, $1310e, $1730e, $110bc,
            $131bc, $1109e, $173bc, $1319e, $1739e, $17160, $1b8b8, $1dc5e,
            $17130, $1b89c, $17118, $1b88e, $1710c, $17106, $130b8, $1985e,
            $171b8, $1309c, $1719c, $1308e, $1718e, $1105e, $130de, $171de,
            $170b0, $1b85c, $17098, $1b84e, $1708c, $17086, $1305c, $170dc,
            $1304e, $170ce, $17058, $1b82e, $1704c, $17046, $1302e, $1706e,
            $1702c, $17026, $10af0, $1857c, $10a78, $1853e, $10a3c, $10a1e,
            $10b7c, $10b3e, $1f0ba, $1e17a, $1c2fa, $185fa, $11ae0, $18d78,
            $1c6be, $11a70, $18d3c, $11a38, $18d1e, $11a1c, $11a0e, $10978,
            $184be, $11b78, $1093c, $11b3c, $1091e, $11b1e, $109be, $11bbe,
            $13ac0, $19d70, $1cebc, $13a60, $19d38, $1ce9e, $13a30, $19d1c,
            $13a18, $19d0e, $13a0c, $13a06, $11970, $18cbc, $13b70, $11938,
            $18c9e, $13b38, $1191c, $13b1c, $1190e, $13b0e, $108bc, $119bc,
            $1089e, $13bbc, $1199e, $13b9e, $1bd60, $1deb8, $1ef5e, $17a40,
            $1bd30, $1de9c, $17a20, $1bd18, $1de8e, $17a10, $1bd0c, $17a08,
            $1bd06, $17a04, $13960, $19cb8, $1ce5e, $17b60, $13930, $19c9c,
            $17b30, $1bd9c, $19c8e, $17b18, $1390c, $17b0c, $13906, $17b06,
            $118b8, $18c5e, $139b8, $1189c, $17bb8, $1399c, $1188e, $17b9c,
            $1398e, $17b8e, $1085e, $118de, $139de, $17bde, $17940, $1bcb0,
            $1de5c, $17920, $1bc98, $1de4e, $17910, $1bc8c, $17908, $1bc86,
            $17904, $17902, $138b0, $19c5c, $179b0, $13898, $19c4e, $17998,
            $1bcce, $1798c, $13886, $17986, $1185c, $138dc, $1184e, $179dc,
            $138ce, $179ce, $178a0, $1bc58, $1de2e, $17890, $1bc4c, $17888,
            $1bc46, $17884, $17882, $13858, $19c2e, $178d8, $1384c, $178cc,
            $13846, $178c6, $1182e, $1386e, $178ee, $17850, $1bc2c, $17848,
            $1bc26, $17844, $17842, $1382c, $1786c, $13826, $17866, $17828,
            $1bc16, $17824, $17822, $13816, $17836, $10578, $182be, $1053c,
            $1051e, $105be, $10d70, $186bc, $10d38, $1869e, $10d1c, $10d0e,
            $104bc, $10dbc, $1049e, $10d9e, $11d60, $18eb8, $1c75e, $11d30,
            $18e9c, $11d18, $18e8e, $11d0c, $11d06, $10cb8, $1865e, $11db8,
            $10c9c, $11d9c, $10c8e, $11d8e, $1045e, $10cde, $11dde, $13d40,
            $19eb0, $1cf5c, $13d20, $19e98, $1cf4e, $13d10, $19e8c, $13d08,
            $19e86, $13d04, $13d02, $11cb0, $18e5c, $13db0, $11c98, $18e4e,
            $13d98, $19ece, $13d8c, $11c86, $13d86, $10c5c, $11cdc, $10c4e,
            $13ddc, $11cce, $13dce, $1bea0, $1df58, $1efae, $1be90, $1df4c,
            $1be88, $1df46, $1be84, $1be82, $13ca0, $19e58, $1cf2e, $17da0,
            $13c90, $19e4c, $17d90, $1becc, $19e46, $17d88, $13c84, $17d84,
            $13c82, $17d82, $11c58, $18e2e, $13cd8, $11c4c, $17dd8, $13ccc,
            $11c46, $17dcc, $13cc6, $17dc6, $10c2e, $11c6e, $13cee, $17dee,
            $1be50, $1df2c, $1be48, $1df26, $1be44, $1be42, $13c50, $19e2c,
            $17cd0, $13c48, $19e26, $17cc8, $1be66, $17cc4, $13c42, $17cc2,
            $11c2c, $13c6c, $11c26, $17cec, $13c66, $17ce6, $1be28, $1df16,
            $1be24, $1be22, $13c28, $19e16, $17c68, $13c24, $17c64, $13c22,
            $17c62, $11c16, $13c36, $17c76, $1be14, $1be12, $13c14, $17c34,
            $13c12, $17c32, $102bc, $1029e, $106b8, $1835e, $1069c, $1068e,
            $1025e, $106de, $10eb0, $1875c, $10e98, $1874e, $10e8c, $10e86,
            $1065c, $10edc, $1064e, $10ece, $11ea0, $18f58, $1c7ae, $11e90,
            $18f4c, $11e88, $18f46, $11e84, $11e82, $10e58, $1872e, $11ed8,
            $18f6e, $11ecc, $10e46, $11ec6, $1062e, $10e6e, $11eee, $19f50,
            $1cfac, $19f48, $1cfa6, $19f44, $19f42, $11e50, $18f2c, $13ed0,
            $19f6c, $18f26, $13ec8, $11e44, $13ec4, $11e42, $13ec2, $10e2c,
            $11e6c, $10e26, $13eec, $11e66, $13ee6, $1dfa8, $1efd6, $1dfa4,
            $1dfa2, $19f28, $1cf96, $1bf68, $19f24, $1bf64, $19f22, $1bf62,
            $11e28, $18f16, $13e68, $11e24, $17ee8, $13e64, $11e22, $17ee4,
            $13e62, $17ee2, $10e16, $11e36, $13e76, $17ef6, $1df94, $1df92,
            $19f14, $1bf34, $19f12, $1bf32, $11e14, $13e34, $11e12, $17e74,
            $13e32, $17e72, $1df8a, $19f0a, $1bf1a, $11e0a, $13e1a, $17e3a,
            $1035c, $1034e, $10758, $183ae, $1074c, $10746, $1032e, $1076e,
            $10f50, $187ac, $10f48, $187a6, $10f44, $10f42, $1072c, $10f6c,
            $10726, $10f66, $18fa8, $1c7d6, $18fa4, $18fa2, $10f28, $18796,
            $11f68, $18fb6, $11f64, $10f22, $11f62, $10716, $10f36, $11f76,
            $1cfd4, $1cfd2, $18f94, $19fb4, $18f92, $19fb2, $10f14, $11f34,
            $10f12, $13f74, $11f32, $13f72, $1cfca, $18f8a, $19f9a, $10f0a,
            $11f1a, $13f3a, $103ac, $103a6, $107a8, $183d6, $107a4, $107a2,
            $10396, $107b6, $187d4, $187d2, $10794, $10fb4, $10792, $10fb2,
            $1c7ea
        ));

        ERRLVL0 : array[0..1] of integer = ( 27, 917 );
        ERRLVL1 : array[0..3] of integer = ( 522, 568, 723, 809 );
        ERRLVL2 : array[0..7] of integer = ( 237, 308, 436, 284, 646, 653, 428, 379 );
        ERRLVL3: array[0..15] of integer = ( 274, 562, 232, 755, 599, 524, 801, 132, 295, 116, 442, 428, 295, 42, 176, 65 );
        ERRLVL4 : array[0..31] of integer = ( 361, 575, 922, 525, 176, 586, 640, 321, 536, 742, 677, 742, 687, 284, 193, 517,
            273, 494, 263, 147, 593, 800, 571, 320, 803, 133, 231, 390, 685, 330, 63, 410 );
        ERRLVL5 : array[0..63] of integer = (
            539, 422, 6, 93, 862, 771, 453, 106, 610, 287, 107, 505, 733, 877, 381, 612,
            723, 476, 462, 172, 430, 609, 858, 822, 543, 376, 511, 400, 672, 762, 283, 184,
            440, 35, 519, 31, 460, 594, 225, 535, 517, 352, 605, 158, 651, 201, 488, 502,
            648, 733, 717, 83, 404, 97, 280, 771, 840, 629, 4, 381, 843, 623, 264, 543 );
       ERRLVL6 : array[0..127] of integer = (
            521, 310, 864, 547, 858, 580, 296, 379, 53, 779, 897, 444, 400, 925, 749, 415,
            822, 93, 217, 208, 928, 244, 583, 620, 246, 148, 447, 631, 292, 908, 490, 704,
            516, 258, 457, 907, 594, 723, 674, 292, 272, 96, 684, 432, 686, 606, 860, 569,
            193, 219, 129, 186, 236, 287, 192, 775, 278, 173, 40, 379, 712, 463, 646, 776,
            171, 491, 297, 763, 156, 732, 95, 270, 447, 90, 507, 48, 228, 821, 808, 898,
            784, 663, 627, 378, 382, 262, 380, 602, 754, 336, 89, 614, 87, 432, 670, 616,
            157, 374, 242, 726, 600, 269, 375, 898, 845, 454, 354, 130, 814, 587, 804, 34,
            211, 330, 539, 297, 827, 865, 37, 517, 834, 315, 550, 86, 801, 4, 108, 539 );
        ERRLVL7 : array[0..255] of integer = (
            524, 894, 75, 766, 882, 857, 74, 204, 82, 586, 708, 250, 905, 786, 138, 720,
            858, 194, 311, 913, 275, 190, 375, 850, 438, 733, 194, 280, 201, 280, 828, 757,
            710, 814, 919, 89, 68, 569, 11, 204, 796, 605, 540, 913, 801, 700, 799, 137,
            439, 418, 592, 668, 353, 859, 370, 694, 325, 240, 216, 257, 284, 549, 209, 884,
            315, 70, 329, 793, 490, 274, 877, 162, 749, 812, 684, 461, 334, 376, 849, 521,
            307, 291, 803, 712, 19, 358, 399, 908, 103, 511, 51, 8, 517, 225, 289, 470,
            637, 731, 66, 255, 917, 269, 463, 830, 730, 433, 848, 585, 136, 538, 906, 90,
            2, 290, 743, 199, 655, 903, 329, 49, 802, 580, 355, 588, 188, 462, 10, 134,
            628, 320, 479, 130, 739, 71, 263, 318, 374, 601, 192, 605, 142, 673, 687, 234,
            722, 384, 177, 752, 607, 640, 455, 193, 689, 707, 805, 641, 48, 60, 732, 621,
            895, 544, 261, 852, 655, 309, 697, 755, 756, 60, 231, 773, 434, 421, 726, 528,
            503, 118, 49, 795, 32, 144, 500, 238, 836, 394, 280, 566, 319, 9, 647, 550,
            73, 914, 342, 126, 32, 681, 331, 792, 620, 60, 609, 441, 180, 791, 893, 754,
            605, 383, 228, 749, 760, 213, 54, 297, 134, 54, 834, 299, 922, 191, 910, 532,
            609, 829, 189, 20, 167, 29, 872, 449, 83, 402, 41, 656, 505, 579, 481, 173,
            404, 251, 688, 95, 497, 555, 642, 543, 307, 159, 924, 558, 648, 55, 497, 10 );
        ERRLVL8 : array[0..511] of integer = (
            352, 77, 373, 504, 35, 599, 428, 207, 409, 574, 118, 498, 285, 380, 350, 492,
            197, 265, 920, 155, 914, 299, 229, 643, 294, 871, 306, 88, 87, 193, 352, 781,
            846, 75, 327, 520, 435, 543, 203, 666, 249, 346, 781, 621, 640, 268, 794, 534,
            539, 781, 408, 390, 644, 102, 476, 499, 290, 632, 545, 37, 858, 916, 552, 41,
            542, 289, 122, 272, 383, 800, 485, 98, 752, 472, 761, 107, 784, 860, 658, 741,
            290, 204, 681, 407, 855, 85, 99, 62, 482, 180, 20, 297, 451, 593, 913, 142,
            808, 684, 287, 536, 561, 76, 653, 899, 729, 567, 744, 390, 513, 192, 516, 258,
            240, 518, 794, 395, 768, 848, 51, 610, 384, 168, 190, 826, 328, 596, 786, 303,
            570, 381, 415, 641, 156, 237, 151, 429, 531, 207, 676, 710, 89, 168, 304, 402,
            40, 708, 575, 162, 864, 229, 65, 861, 841, 512, 164, 477, 221, 92, 358, 785,
            288, 357, 850, 836, 827, 736, 707, 94, 8, 494, 114, 521, 2, 499, 851, 543,
            152, 729, 771, 95, 248, 361, 578, 323, 856, 797, 289, 51, 684, 466, 533, 820,
            669, 45, 902, 452, 167, 342, 244, 173, 35, 463, 651, 51, 699, 591, 452, 578,
            37, 124, 298, 332, 552, 43, 427, 119, 662, 777, 475, 850, 764, 364, 578, 911,
            283, 711, 472, 420, 245, 288, 594, 394, 511, 327, 589, 777, 699, 688, 43, 408,
            842, 383, 721, 521, 560, 644, 714, 559, 62, 145, 873, 663, 713, 159, 672, 729,
            624, 59, 193, 417, 158, 209, 563, 564, 343, 693, 109, 608, 563, 365, 181, 772,
            677, 310, 248, 353, 708, 410, 579, 870, 617, 841, 632, 860, 289, 536, 35, 777,
            618, 586, 424, 833, 77, 597, 346, 269, 757, 632, 695, 751, 331, 247, 184, 45,
            787, 680, 18, 66, 407, 369, 54, 492, 228, 613, 830, 922, 437, 519, 644, 905,
            789, 420, 305, 441, 207, 300, 892, 827, 141, 537, 381, 662, 513, 56, 252, 341,
            242, 797, 838, 837, 720, 224, 307, 631, 61, 87, 560, 310, 756, 665, 397, 808,
            851, 309, 473, 795, 378, 31, 647, 915, 459, 806, 590, 731, 425, 216, 548, 249,
            321, 881, 699, 535, 673, 782, 210, 815, 905, 303, 843, 922, 281, 73, 469, 791,
            660, 162, 498, 308, 155, 422, 907, 817, 187, 62, 16, 425, 535, 336, 286, 437,
            375, 273, 610, 296, 183, 923, 116, 667, 751, 353, 62, 366, 691, 379, 687, 842,
            37, 357, 720, 742, 330, 5, 39, 923, 311, 424, 242, 749, 321, 54, 669, 316,
            342, 299, 534, 105, 667, 488, 640, 672, 576, 540, 316, 486, 721, 610, 46, 656,
            447, 171, 616, 464, 190, 531, 297, 321, 762, 752, 533, 175, 134, 14, 381, 433,
            717, 45, 111, 20, 596, 284, 736, 138, 646, 411, 877, 669, 141, 919, 45, 780,
            407, 164, 332, 899, 165, 726, 600, 325, 498, 655, 357, 752, 768, 223, 849, 647,
            63, 310, 863, 251, 366, 304, 282, 738, 675, 410, 389, 244, 31, 121, 303, 263 );



    ERROR_LEVEL : array[0..8] of PInt = ( @ERRLVL0, @ERRLVL1, @ERRLVL2, @ERRLVL3, @ERRLVL4, @ERRLVL5, @ERRLVL6, @ERRLVL7, @ERRLVL8 );


type

  /// Specifies the error correction level used for PDF417 barcode.
    PDF417ErrorCorrection =
    (
        AutoCorr,
        Level0,
        Level1,
        Level2,
        Level3,
        Level4,
        Level5,
        Level6,
        Level7,
        Level8
    );

  /// Specifies the compaction mode used for PDF417 barcode.
    PDF417CompactionMode =
    (
        AutoCompaction,
        TextComp,
        Numeric,
        Binary
    );

    Segment = class

    public

        _type  : char;
        _start,
        _end   : integer;

        constructor Create( _t : char; _s, _e : integer);

    end;


    TSegmentList = class(TObject)

    public
        List  : TList;
        constructor Create;
        destructor Destroy; override;
        procedure  Add(_type: char; _start,_end : integer);
        function   Get(idx : integer) : Segment;
        procedure  Remove( idx : integer);
        function   Size : integer;
    end;




  /// <summary>
  /// Generates the 2D PDF417 barcode.
  /// </summary>
  /// <example>This example shows how to configure the BarcodeObject to display PDF417 barcode.
  /// <code>
  /// BarcodeObject barcode;
  /// ...
  /// barcode.Barcode = new BarcodePDF417();
  /// (barcode.Barcode as BarcodePDF417).CompactionMode = PDF417CompactionMode.Text;
  /// </code>
  /// </example>
    TfrxBarcodePDF417 = class(TfrxBarcode2DBase)

     private

        codeColumns,
        FRows,
        FColumns           : integer;
        codewords          : array[0 .. MAX_DATA_CODEWORDS + 1] of integer;
        lenCodewords,
        errorLevel         : integer;
        FErrorCorrection   : PDF417ErrorCorrection;
        FCompactionMode    : PDF417CompactionMode;
        bytes              : array of byte;
        FAspectRatio       : extended;
        FCodePage,
        bitPtr,
        cwPtr              : integer;
        segmentList        : TSegmentList;

        function CheckSegmentType( var segm : Segment; typ : char) : boolean;
        function GetSegmentLength( var segm : Segment ) : integer;
        procedure OutCodeword17( codeword : integer);
        procedure OutCodeword18( codeword : integer);
        procedure OutCodeword( codeword : integer );
        procedure OutStopPattern;
        procedure OutStartPattern;
        procedure OutPaintCode;
        procedure CalculateErrorCorrection(dest : integer);
        function GetTextTypeAndValue( var input : array of byte; maxLength, idx : integer ) : integer; overload;
        function GetTextTypeAndValue(maxLength, idx : integer) : integer; overload;
        procedure TextCompaction(var input : array of byte; start, length : integer); overload;
        procedure TextCompaction( start, length : integer); overload;
        //procedure BasicNumberCompaction( start, length : integer);  overload;
        procedure BasicNumberCompaction(var input : array of byte; start, length : integer); overload;
        procedure NumberCompaction(var input : array of byte; start,length : integer); overload;
        procedure NumberCompaction( start, length : integer); overload;
        procedure ByteCompaction6( start : integer );
        procedure ByteCompaction( start, length : integer);
        procedure BreakString;
        procedure Assemble;
        function  MaxPossibleErrorLevel( remain: integer) : integer;
        function  GetMaxSquare : integer;
        procedure PaintCode;
        procedure Initialize;

        procedure SetAspectRatio(v : extended);
        procedure SetColumns(v : integer);
        procedure SetRows(v : integer);
        procedure SetErrorCorrection(v : PDF417ErrorCorrection);
        procedure SetCodePage(v : integer);
        procedure SetCompactionMode(v : PDF417CompactionMode);
    protected
        procedure SetText(v : string); override;
    public
        constructor Create; override;
        destructor Destroy; override;
        procedure Assign( source : TfrxBarcode2DBase ); override;

    published

    /// Gets or sets the barcode aspect ratio.
    /// A ratio or 0.5 will make the barcode width twice as large as the height.
        property AspectRatio : extended read FAspectRatio write SetAspectRatio;
    /// Gets or sets the number of barcode data columns.
    /// To calculate the necessary number of columns and rows, set the <see cref="Columns"/>
    /// and <see cref="Rows"/> properties to 0. In this case, the <see cref="AspectRatio"/> property
    /// should be set to desired aspect ratio.
        property Columns : integer read FColumns write SetColumns;
    /// Gets or sets the number of barcode data rows.
    /// To calculate the necessary number of columns and rows, set the <see cref="Columns"/>
    /// and <see cref="Rows"/> properties to 0. In this case, the <see cref="AspectRatio"/> property
    /// should be set to desired aspect ratio.
        property Rows : integer read FRows write SetRows;
    /// Gets or sets the error level correction used for the barcode.
    // [DefaultValue(PDF417ErrorCorrection.Auto)]
        property ErrorCorrection : PDF417ErrorCorrection read FErrorCorrection write SetErrorCorrection;
    /// Gets or sets the code page used for text conversion.
    /// Use this property to encode non-ASCII characters. For example, set this
    /// property to <b>1251</b> to use Window CP1251.
    /// [DefaultValue(437)]
        property CodePage : integer read FCodePage write SetCodePage;
    /// Gets or sets the compaction mode.
    /// [DefaultValue(PDF417CompactionMode.Auto)]
        property CompactionMode : PDF417CompactionMode read FCompactionMode write SetCompactionMode;
    /// Gets or sets the size of the pixel.

end;

implementation

uses frxUnicodeUtils;


procedure TfrxBarcodePDF417.SetText(v : string);
begin
    if( FText <> v) then
    begin
        FText := v;
        Initialize;
    end;
end;
procedure TfrxBarcodePDF417.SetAspectRatio(v : extended);
begin
    if v <> FAspectRatio then
    begin
        FAspectRatio := v;
        Initialize;
    end;
end;
procedure TfrxBarcodePDF417.SetColumns(v : integer);
begin
    if v <> FColumns then
    begin
        FColumns := v;
        Initialize;
    end;
end;
procedure TfrxBarcodePDF417.SetRows(v : integer);
begin
    if v <> FRows then
    begin
        FRows := v;
        Initialize;
    end;
end;
procedure TfrxBarcodePDF417.SetErrorCorrection(v : PDF417ErrorCorrection);
begin
    if v <> FErrorCorrection then
    begin
        FErrorCorrection := v;
        Initialize;
    end;
end;

procedure TfrxBarcodePDF417.SetCodePage(v : integer);
begin
    if v <> FCodePage then
    begin
        FCodePage := v;
        Initialize;
    end;
end;
procedure TfrxBarcodePDF417.SetCompactionMode(v : PDF417CompactionMode);
begin
    if v <> FCompactionMode then
    begin
        FCompactionMode := v;
        Initialize;
    end;
end;

procedure TfrxBarcodePDF417.Initialize;
var
  i: Integer;
  s: AnsiString;
{$IFNDEF DELPHI12}
  us: WideString;
{$ENDIF}
begin
{$IFNDEF DELPHI12}
  us := WideString(text);
  if FCodePage = 65001 then
    s := UTF8Encode(us)
  else
    s := _UnicodeToAnsi(us, DEFAULT_CHARSET, FCodePage);
{$ELSE}
  if FCodePage = 65001 then
    s := UTF8Encode(text)
  else
    s := _UnicodeToAnsi(text, DEFAULT_CHARSET, FCodePage);
{$ENDIF}
  SetLength( bytes, Length(s));
  for i := 1 to Length(s) do
    bytes[i - 1] := Ord(s[i]);

  codeColumns := FColumns;
  FHeight := FRows;
  fillChar(codeWords[0],(MAX_DATA_CODEWORDS + 1) * sizeof(integer),0);
  PaintCode();
end;

/// Initializes a new instance of the <see cref="BarcodePDF417"/> class with default settings.
constructor TfrxBarcodePDF417.Create;
begin
    inherited;
    FImage := nil;
    SetLength( bytes, 0);
    Setlength(FImage, 0);
    FPixelwidth := 2;
    FPixelHeight := 8;
    FAspectRatio := 0.5;
    FCodePage := 437;
    Columns := 0;
    Rows := 0;
    FCompactionMode := AutoCompaction;
    Initialize;
 end;


destructor TfrxBarcodePDF417.Destroy;
begin
  SetLength(bytes, 0);
  inherited;
end;

procedure TfrxBarcodePDF417.Assign( source : TfrxBarcode2DBase );
var
     src : TfrxBarcodePDF417;
begin
    inherited;
    if source is TfrxBarcodePDF417 then
    begin
        src := source as TfrxBarcodePDF417;

        AspectRatio := src.AspectRatio;
        Columns := src.Columns;
        Rows := src.Rows;
        CodePage := src.CodePage;
        CompactionMode := src.CompactionMode;
        ErrorCorrection := src.ErrorCorrection;
    end;
end;

//** Paints the barcode. If no exception was thrown a valid barcode is available. */
procedure TfrxBarcodePDF417.PaintCode;
var
    maxErr, lenErr, tot, pad : integer;
    fixedColumn, skipRowColAdjust : boolean;
    c, b, yHeight : extended;
begin
    if (bytes = nil) then
        raise Exception.Create('Text cannot be null.');
    if (Length(bytes) > ABSOLUTE_MAX_TEXT_SIZE) then
        raise Exception.Create('The text is too big.');
    segmentList := TSegmentList.Create;
    BreakString;
    Assemble;
    FreeAndNil(segmentList);
    codewords[0] := cwPtr;
    lenCodewords := cwPtr;

      // error correction level
    maxErr := MaxPossibleErrorLevel(MAX_DATA_CODEWORDS + 2 - lenCodewords);
    if (ErrorCorrection = AutoCorr ) then
    begin
        if (lenCodewords < 41) then
            errorLevel := 2
        else
            if (lenCodewords < 161) then
                errorLevel := 3
            else
                if (lenCodewords < 321) then
                     errorLevel := 4
                else
                    errorLevel := 5;
    end
    else
        errorLevel := integer(ord(ErrorCorrection) - 1);
    if (errorLevel < 0) then
         errorLevel := 0
    else
        if (errorLevel > maxErr) then
            errorLevel := maxErr;

    if (codeColumns < 1) then
         codeColumns := 1
    else
        if (codeColumns > 30) then
            codeColumns := 30;
    if (FHeight < 3) then
        FHeight := 3
    else
        if (FHeight > 90) then
            FHeight := 90;
    lenErr := 2 shl errorLevel;
    fixedColumn := FRows = 0;
    skipRowColAdjust := false;
    tot := lenCodewords + lenErr;
    if (FColumns <> 0) and (FRows <> 0) then
    begin
        tot := codeColumns * FHeight;
        if (tot > MAX_DATA_CODEWORDS + 2) then
            tot := GetMaxSquare;
        if (tot < lenCodewords + lenErr) then
            tot := lenCodewords + lenErr
        else
            skipRowColAdjust := true;
    end
    else
    begin
        fixedColumn := true;
        if (FAspectRatio < 0.001) then
            FAspectRatio := 0.001
        else
            if (FAspectRatio > 1000) then
                FAspectRatio := 1000;
        if PixelWidth = 0 then
            yHeight := 3
        else
            yHeight := PixelHeight / PixelWidth;
        b := 73 * FAspectRatio - 4;
        c := (-b + Sqrt(b * b + 4 * 17 * FAspectRatio * (lenCodewords + lenErr) * yHeight)) / (2 * 17 * FAspectRatio);
        codeColumns := trunc(c + 0.5);
        if (codeColumns < 1) then
           codeColumns := 1
        else
           if (codeColumns > 30) then
               codeColumns := 30;
    end;

    if not skipRowColAdjust then
    begin
        if (fixedColumn) then
        begin
            FHeight := (tot - 1) div codeColumns + 1;
            if (FHeight < 3) then
                FHeight := 3
            else
                if (FHeight > 90) then
                begin
                    FHeight := 90;
                    codeColumns := (tot - 1) div 90 + 1;
                end;
        end
   
        else
        begin
            codeColumns := (tot - 1) div FHeight + 1;
            if (codeColumns > 30) then
            begin
                codeColumns := 30;
                FHeight := (tot - 1) div 30 + 1;
            end;
        end;
        tot := FHeight * codeColumns;
    end;
  
    if (tot > MAX_DATA_CODEWORDS + 2) then
        tot := GetMaxSquare;
    errorLevel := MaxPossibleErrorLevel(tot - lenCodewords);
    lenErr := 2 shl errorLevel;
    pad := tot - lenErr - lenCodewords;

    cwPtr := lenCodewords;
    while (pad <> 0) do
    begin
        dec(pad);
        codewords[cwPtr] := TEXT_MODE;
        inc(cwPtr);
    end;

    codewords[0] := cwPtr;
    lenCodewords := cwPtr;
    CalculateErrorCorrection(lenCodewords);
    lenCodewords := tot;
    OutPaintCode;
end;


function TfrxBarcodePDF417.GetMaxSquare : integer;
begin
    if (codeColumns > 21) then
    begin
        codeColumns := 29;
        FHeight := 32;
    end
    else
    begin
        codeColumns := 16;
        FHeight := 58;
    end;
    result := MAX_DATA_CODEWORDS + 2;
end;

function TfrxBarcodePDF417.MaxPossibleErrorLevel( remain: integer) : integer;
var
    level, size : integer;
begin
    level := 8;
    size := 512;
    while (level > 0) do
    begin
        if (remain >= size) then
        begin
            result := level;
            exit;
        end;
        dec(level);
        size := size shr 1;
    end;
    result := 0;
end;

procedure TfrxBarcodePDF417.Assemble;
var

    k : integer;
    v : Segment;
begin

    if segmentList.Size = 0 then
        exit;
    cwPtr := 1;
    for k := 0 to segmentList.Size-1 do
    begin
        v := segmentList.Get(k);
        case v._type of

          'T': begin
                   if (k <> 0) then
                   begin
                      codewords[cwPtr] := TEXT_MODE; inc(cwPtr);
                   end;
                   TextCompaction(v._start, GetSegmentLength(v));
               end;
          'N': begin
                   codewords[cwPtr] := NUMERIC_MODE; inc(cwPtr);
                   NumberCompaction(v._start, GetSegmentLength(v));
               end;
          'B': begin
                   if (GetSegmentLength(v) mod 6) <> 0 then
                   begin
                       codewords[cwPtr] := BYTE_MODE;
                       inc(cwPtr);
                   end
                   else
                   begin
                       codewords[cwPtr] := BYTE_MODE_6;
                       inc(cwPtr);
                   end;
                   ByteCompaction(v._start, GetSegmentLength(v));
               end;
        end;
    end;
end;


procedure TfrxBarcodePDF417.BreakString;
var
    textLength, lastP, startN, nd, k, j : integer;
    c : char;
    lastTxt, txt, redo : boolean;
    v, vp, vn : Segment;
begin

    textLength := Length(bytes);
    lastP := 0;
    startN := 0;
    nd := 0;

    case CompactionMode of

       TextComp: begin
                 segmentList.Add('T', 0, textLength);
                 exit;
             end;

       Numeric:
             begin
                 segmentList.Add('N', 0, textLength);
                 exit;
             end;

       Binary:
             begin
                 segmentList.Add('B', 0, textLength);
                 exit;
             end;
    end;

    for k := 0 to textLength-1 do
    begin
        c := char((bytes[k] and $ff));
        if (c >= '0') and (c <= '9') then
        begin
            if (nd = 0) then
                startN := k;
            inc(nd);
            continue;
        end;
        if (nd >= 13) then
        begin
            if (lastP <> startN) then
            begin
                c := char((bytes[lastP] and $ff));
                lastTxt := ((c >= ' ') and (c < #127)) or ( c = #13 ) or ( c = #10 ) or ( c = #9 );
                for j := lastP to startN - 1 do
                begin
                    c := char((bytes[j] and $ff));
                    txt := ((c >= ' ') and (c < #127)) or ( c = #13 ) or ( c = #10 ) or ( c = #9 );
                    if (txt <> lastTxt) then
                    begin
                        if lastTxt then
                           segmentList.Add('T', lastP, j)
                        else
                           segmentList.Add('B', lastP, j);
                        lastP := j;
                        lastTxt := txt;
                    end;
                end;
                if lastTxt then
                    segmentList.Add('T', lastP, startN)
                else
                    segmentList.Add('B', lastP, startN);
            end;
            segmentList.Add('N', startN, k);
            lastP := k;
        end;
        nd := 0;
    end;
    if (nd < 13) then
        startN := textLength;
    if (lastP <> startN) then
    begin
        c := char((bytes[lastP] and $ff));
        lastTxt := ((c >= ' ') and (c < #127)) or (c = #10) or ( c = #13) or ( c = #9 );
        for j := lastP to startN-1 do
        begin
            c := char((bytes[j] and $ff));
            txt := ((c >= ' ') and (c < #127)) or ( c = #10 ) or ( c = #13 ) or ( c = #9 );
            if (txt <> lastTxt) then
            begin
                if lastTxt then
                    segmentList.Add('T', lastP, j)
                else
                    segmentList.Add('B', lastP, j);
                lastP := j;
                lastTxt := txt;
            end;
        end;
        if lastTxt then
            segmentList.Add('T', lastP, startN)
        else
            segmentList.Add('B', lastP, startN);
    end;
    if (nd >= 13) then
        segmentList.Add('N', startN, textLength);
      //optimize
      //merge short binary
    k := 0;
    while  k < segmentList.Size do
    begin
        v := segmentList.Get(k);
        vp := segmentList.Get(k - 1);
        vn := segmentList.Get(k + 1);
        if ( CheckSegmentType(v, 'B') and ( GetSegmentLength(v) = 1) ) then
        begin
            if CheckSegmentType(vp, 'T') and CheckSegmentType(vn, 'T')
               and (GetSegmentLength(vp) + GetSegmentLength(vn) >= 3) then
            begin
                vp._end := vn._end;
                segmentList.Remove(k);
                segmentList.Remove(k);
                k := -1;
                inc(k);
                continue;
            end;
        end;
        inc(k);
    end;
      //merge text sections
    k := 0;
    while k < segmentList.Size do
    begin
        v := segmentList.Get(k);
        vp := segmentList.Get(k - 1);
        vn := segmentList.Get(k + 1);
        if CheckSegmentType(v, 'T') and (GetSegmentLength(v) >= 5) then
        begin
            redo := false;
            if ( CheckSegmentType(vp, 'B') and (GetSegmentLength(vp) = 1)) or CheckSegmentType(vp, 'T') then
            begin
                redo := true;
                v._start := vp._start;
                segmentList.Remove(k - 1);
                dec(k);
            end;
            if ( CheckSegmentType(vn, 'B') and (GetSegmentLength(vn) = 1)) or CheckSegmentType(vn, 'T') then
            begin
                redo := true;
                v._end := vn._end;
                segmentList.Remove(k + 1);
            end;
            if (redo) then
            begin
            k := -1;
            inc(k);
            continue;
            end;
       end;
       inc(k);
    end;
    //merge binary sections
    k := 0;
    while k < segmentList.Size do
    begin
          v := segmentList.Get(k);
          vp := segmentList.Get(k - 1);
          vn := segmentList.Get(k + 1);
          if CheckSegmentType(v, 'B') then
          begin
              redo := false;
              if  (CheckSegmentType(vp, 'T') and ( GetSegmentLength(vp) < 5 ) ) or CheckSegmentType(vp, 'B') then
              begin
                  redo := true;
                  v._start := vp._start;
                  segmentList.Remove(k - 1);
                  dec(k);
              end;
              if ( CheckSegmentType(vn, 'T') and (GetSegmentLength(vn) < 5)) or CheckSegmentType(vn, 'B') then
              begin
                  redo := true;
                  v._end := vn._end;
                  segmentList.Remove(k + 1);
              end;
              if (redo) then
              begin
                  k := -1;
                  inc(k);
                  continue;
              end;
          end;
          inc(k);
    end;
    // check if all numbers
    v := segmentList.Get(0);
    if (segmentList.Size = 1) and (v._type = 'T') and ( GetSegmentLength(v) >= 8 ) then
    begin
        for k := v._start to v._end-1 do
        begin
            c := char((bytes[k] and $ff));
            if (c < '0') or ( c > '9') then
                break;
        end;
        if (k = v._end) then
            v._type := 'N';
    end;
end;

procedure TfrxBarcodePDF417.ByteCompaction( start, length : integer);
var
    k,j, size : integer;
begin
    size := (length div 6) * 5 + (length mod 6);
    if (size + cwPtr ) > MAX_DATA_CODEWORDS then
        raise Exception.Create('The text is too big.');

    inc(length,start);

    k := start;
    while k < length do
    begin
        size := length - k;
        if size>=44 then size:=6;
        if (size < 6) then
        begin
            for j := 0 to size-1 do
            begin
                codewords[cwPtr] := integer(bytes[k + j]) and $ff;
                inc(cwPtr);
            end;
        end
        else
        begin
          ByteCompaction6(k);
        end;
        inc(k, 6);
    end;
end;


procedure TfrxBarcodePDF417.ByteCompaction6( start : integer );
var
    length, ret, retLast, ni, k : integer;
begin
    length := 6;
    ret := cwPtr;
    retLast := 4;
    inc(cwPtr, retLast + 1);
    for k := 0 to retLast do
        codewords[ret + k] := 0;
    inc( length, start );
    for ni := start to length-1 do
    begin
        // multiply by 256
        for k := retLast downto 0 do
            codewords[ret + k] := codewords[ret + k] * 256;
        // add the digit
        inc(codewords[ret + retLast], integer(bytes[ni]) and $ff);
        // propagate carry
        for k := retLast downto 1 do
        begin
            inc(codewords[ret + k - 1], codewords[ret + k] div 900);
            codewords[ret + k] := codewords[ret + k] mod 900;
        end;
    end;
end;


procedure TfrxBarcodePDF417.NumberCompaction( start, length : integer);
begin
    NumberCompaction(bytes, start, length);
end;


procedure TfrxBarcodePDF417.NumberCompaction(var input : array of byte; start,length : integer);
var
    full, size, k : integer;
begin
    full := (length div 44) * 15;
    size := length mod 44;
    if (size = 0) then
       size := full
    else
       size := full + size div 3 + 1;
    if (size + cwPtr > MAX_DATA_CODEWORDS) then
        raise Exception.Create('The text is too big.');

    inc(length, start);
    k := start;
    while( k < length ) do
    begin
        size := length - k;
        if size > 44 then size := 44;
        BasicNumberCompaction(input, k, size);
        inc(k ,44);
    end;
end;

procedure TfrxBarcodePDF417.BasicNumberCompaction(var input : array of byte; start, length : integer);
var
    ret, retLast, ni, k : integer;
begin
    ret := cwPtr;
    retLast := length div 3;
    inc(cwPtr, retLast + 1);
    for k := 0 to retLast do
        codewords[ret + k] := 0;

    codewords[ret + retLast] := 1;
    inc(length, start);
    for ni := start to length-1 do
    begin
        // multiply by 10
        for k := retLast downto 0 do
            codewords[ret + k] := codewords[ret + k] * 10;
        // add the digit
        inc(codewords[ret + retLast], input[ni] - ord('0'));
        // propagate carry
        for k := retLast downto 1 do
        begin
            inc(codewords[ret + k - 1], codewords[ret + k] div 900);
            codewords[ret + k] :=  codewords[ret + k] mod 900;
        end;
    end;
end;

{procedure TfrxBarcodePDF417.BasicNumberCompaction( start, length : integer);
begin
    BasicNumberCompaction(bytes, start, length);
end;}


procedure TfrxBarcodePDF417.TextCompaction( start, length : integer);
begin
    TextCompaction(bytes, start, length);
end;

procedure TfrxBarcodePDF417.TextCompaction(var input : array of byte; start, length : integer);
var
    dest : TInt;
    mode, ptr, fullBytes, v, k, size
                                       : integer;
begin
      SetLength( dest, ABSOLUTE_MAX_TEXT_SIZE * 2 );

      FillChar(dest[0], sizeof(dest), 0);
      mode := ALPHA;
      ptr := 0;  fullBytes := 0;
      inc(length, start);
      k := start;
      while ( k < length) do
      begin
          v := GetTextTypeAndValue(input, length, k);
          if ((v and mode) <> 0) then
          begin
              dest[ptr] := v and $ff;
              inc(ptr);
              inc(k);
              continue;
          end;
          if ((v and ISBYTE) <> 0) then
          begin
              if ((ptr and 1) <> 0) then
              begin
                 //add a padding word
//                  dest[ptr] := PAL;
                   if mode and PUNCTUATION <> 0 then
                       dest[ptr] := PAL
                   else
                       dest[ptr] := PS;
                  inc(ptr);
                  if (mode and PUNCTUATION) <> 0 then mode := ALPHA;
              end;
              dest[ptr] := BYTESHIFT; inc(ptr);
              dest[ptr] := v and $ff; inc(ptr);
              inc(fullBytes, 2);
              inc(k);
              continue;
          end;
          case (mode) of
              ALPHA:  if ((v and LOWER) <> 0) then
                      begin
                          dest[ptr] := LL; inc(ptr);
                          dest[ptr] := v and $ff; inc(ptr);
                          mode := LOWER;
                      end
                      else
                          if ((v and MIXED) <> 0) then
                          begin
                              dest[ptr] := ML; inc(ptr);
                              dest[ptr] := v and $ff; inc(ptr);
                              mode := MIXED;
                          end
                          else
                              if ((GetTextTypeAndValue(input, length, k + 1)
                                   and GetTextTypeAndValue(input, length, k + 2)
                                   and PUNCTUATION) <> 0) then
                              begin
                                  dest[ptr] := ML; inc(ptr);
                                  dest[ptr] := PL; inc(ptr);
                                  dest[ptr] := v and $ff; inc(ptr);
                                  mode := PUNCTUATION;
                              end
                              else
                              begin
                                  dest[ptr] := PS; inc(ptr);
                                  dest[ptr] := v and $ff; inc(ptr);
                              end;
              LOWER:  if ((v and ALPHA) <> 0) then
                      begin
                          if ((GetTextTypeAndValue(length, k + 1)
                               and GetTextTypeAndValue(length, k + 2)
                               and ALPHA) <> 0) then
                          begin
                              dest[ptr] := ML; inc(ptr);
                              dest[ptr] := AL; inc(ptr);
                              mode := ALPHA;
                          end
                          else
                          begin
                              dest[ptr] := _AS; inc(ptr);
                          end;
                          dest[ptr] := v and $ff; inc(ptr);
                      end
                      else
                          if ((v and MIXED) <> 0) then
                          begin
                              dest[ptr] := ML; inc(ptr);
                              dest[ptr] := v and $ff; inc(ptr);
                              mode := MIXED;
                          end
                          else
                              if ((GetTextTypeAndValue(input, length, k + 1)
                                   and GetTextTypeAndValue(input, length, k + 2)
                                   and PUNCTUATION) <> 0) then
                              begin
                                  dest[ptr] := ML; inc(ptr);
                                  dest[ptr] := PL; inc(ptr);
                                  dest[ptr] := v and $ff; inc(ptr);
                                  mode := PUNCTUATION;
                              end
                              else
                              begin
                                  dest[ptr] := PS; inc(ptr);
                                  dest[ptr] := v and $ff; inc(ptr);
                              end;
              MIXED:  if ((v and LOWER) <> 0) then
                      begin
                          dest[ptr] := LL; inc(ptr);
                          dest[ptr] := v and $ff; inc(ptr);
                          mode := LOWER;
                      end
                      else
                          if ((v and ALPHA) <> 0) then
                          begin
                              dest[ptr] := AL; inc(ptr);
                              dest[ptr] := v and $ff; inc(ptr);
                              mode := ALPHA;
                          end
                          else
                              if ((GetTextTypeAndValue(input, length, k + 1)
                                   and GetTextTypeAndValue(input, length, k + 2)
                                   and PUNCTUATION) <> 0) then
                              begin
                                  dest[ptr] := PL; inc(ptr);
                                  dest[ptr] := v and $ff; inc(ptr);
                                  mode := PUNCTUATION;
                              end
                              else
                              begin
                                  dest[ptr] := PS; inc(ptr);
                                  dest[ptr] := v and $ff; inc(ptr);
                              end;
              PUNCTUATION:  begin
                                dest[ptr] := PAL; inc(ptr);
                                mode := ALPHA;
                                dec(k);
                            end;
          end; // case
          inc(k);
      end; // for
      if ((ptr and 1) <> 0) then
      begin
          dest[ptr] := PS; inc(ptr);
      end;
      size := (ptr + fullBytes) div 2;
          if (size + cwPtr > MAX_DATA_CODEWORDS) then
              raise Exception.Create('The text is too big.');
      length := ptr;
      ptr := 0;
      while (ptr < length) do
      begin
          v := dest[ptr]; inc(ptr);
          if (v >= 30) then
          begin
              codewords[cwPtr] := v; inc(cwPtr);
              codewords[cwPtr] := dest[ptr]; inc(cwPtr);
              inc(ptr);
          end
          else
          begin
              codewords[cwPtr] := v * 30 + dest[ptr];
              inc(cwPtr);
              inc(ptr);
          end;
      end;
      SetLength(dest, 0);
end;

function TfrxBarcodePDF417.GetTextTypeAndValue(maxLength, idx : integer) : integer;
begin
    result := GetTextTypeAndValue(bytes, maxLength, idx);
end;


function TfrxBarcodePDF417.GetTextTypeAndValue( var input : array of byte; maxLength, idx : integer ) : integer;
var
    c : char;
    ms,ps : integer;
begin

    if (idx >= maxLength) then begin
                                   result := 0;
                                   exit;
                               end;
    c := char(input[idx] and $ff);

    if (c >= 'A') and (c <= 'Z') then begin
                                          result := (ALPHA + ord(c) - ord('A'));
                                          exit;
                                      end;
    if (c >= 'a') and (c <= 'z') then begin
                                          result := (LOWER + ord(c) - ord('a'));
                                          exit;
                                      end;
    if (c = ' ') then begin
                          result := (ALPHA + LOWER + MIXED + SPACE);
                          exit;
                      end;

    ms := Pos(c,MIXED_SET) - 1;
    ps := Pos(c,PUNCTUATION_SET) - 1;
    if (ms < 0) and (ps < 0) then begin
                                      result := (ISBYTE + (ord(c) and $ff));
                                      exit;
                                  end;
    if (ms = ps) then begin
                          result := (MIXED + PUNCTUATION + ms);
                          exit;
                      end;
    if (ms >= 0) then begin
                          result := (MIXED + ms);
                          exit;
                      end;
    result := (PUNCTUATION + ps);

end;

procedure TfrxBarcodePDF417.CalculateErrorCorrection( dest : integer);
var
    A : TInt;
    ALength,e,k,t1,t2,t3, LastE : integer;
begin
    if (errorLevel < 0) or ( errorLevel > 8) then
        errorLevel := 0;
    A := TInt(ERROR_LEVEL[errorLevel]);
    Alength := 2 shl errorLevel;
    for k := 0 to Alength-1 do
        codewords[dest + k] := 0;
    lastE := Alength - 1;
    for k := 0 to lenCodewords-1 do
    begin
        t1 := codewords[k] + codewords[dest];
        for e := 0 to lastE do
        begin
            t2 := (t1 * A[lastE - e]) mod _MOD;
            t3 := _MOD - t2;
            if e = LastE then
                codewords[dest + e] := t3 mod _MOD
            else
                codewords[dest + e] := ((codewords[dest + e + 1]) + t3) mod _MOD;
        end;
    end;
    for k := 0 to Alength- 1 do
        codewords[dest + k] := (_MOD - codewords[dest + k]) mod _MOD;

end;

procedure TfrxBarcodePDF417.OutPaintCode;
var
    codePtr, lenBits, rowMod, edge, column, row : integer;
    cluster : ^integer;

begin
    codePtr := 0;
    FWidth := START_CODE_SIZE * (codeColumns + 3) + STOP_SIZE;
    lenBits := ((FWidth - 1) div 8 + 1) * FHeight;
    SetLength(FImage, lenBits);
    FillChar(FImage[0],length(FImage),0);
    for row := 0 to FHeight-1 do
    begin
        bitPtr := ((FWidth - 1) div 8 + 1) * 8 * row;
        rowMod := row mod 3;
        cluster := @CLUSTERS[rowMod];
        OutStartPattern;
        case (rowMod) of
            0:   edge := 30 * (row div 3) + ((FHeight - 1) div 3);
            1:   edge := 30 * (row div 3) + errorLevel * 3 + ((FHeight - 1) mod 3);
         else
                 edge := 30 * (row div 3) + codeColumns - 1;
        end;

        OutCodeword(TInt(cluster)[edge]);

        for column := 0 to codeColumns-1 do
        begin
          OutCodeword(TInt(cluster)[codewords[codePtr]]);
          inc(codePtr);
        end;

        case rowMod of
            0: edge := 30 * (row div 3) + codeColumns - 1;
            1: edge := 30 * (row div 3) + ((FHeight - 1) div 3);
          else
               edge := 30 * (row div 3) + errorLevel * 3 + ((FHeight - 1) mod 3);
        end;

        OutCodeword(TInt(cluster)[edge]);
        OutStopPattern;
    end;

end;


procedure TfrxBarcodePDF417.OutStartPattern;
begin
    OutCodeword17(START_PATTERN);
end;

procedure TfrxBarcodePDF417.OutStopPattern;
begin
    OutCodeword18(STOP_PATTERN);
end;

procedure TfrxBarcodePDF417.OutCodeword( codeword : integer );
begin
    OutCodeword17(codeword);
end;

procedure TfrxBarcodePDF417.OutCodeword18( codeword : integer);
var
     bytePtr, bit : integer;
begin
     bytePtr := bitPtr div 8;
     bit := bitPtr - bytePtr * 8;
     FImage[bytePtr] := FImage[bytePtr] or (byte((codeword shr (10 + bit))));
     inc(bytePtr);
     FImage[bytePtr] := FImage[bytePtr] or (byte(codeword shr (2 + bit)));
     inc(bytePtr);
     codeword := codeword shl 8;
     FImage[bytePtr] := FImage[bytePtr] or (byte((codeword shr (2 + bit))));
     if (bit = 7) then
     begin
        inc(bytePtr);
        FImage[bytePtr] := FImage[bytePtr] or $80;
     end;
     inc(bitPtr, 18);
end;

procedure TfrxBarcodePDF417.OutCodeword17( codeword : integer);
var
    bytePtr, bit : integer;

begin
      bytePtr := bitPtr div 8;
      bit := bitPtr - bytePtr * 8;
      FImage[bytePtr] := FImage[bytePtr] or ( byte((codeword shr (9 + bit))));
      inc(bytePtr);
      FImage[bytePtr] := FImage[bytePtr] or ( byte((codeword shr (1 + bit))));
      inc(bytePtr);
      codeword := codeword shl 8;
      FImage[bytePtr] := FImage[bytePtr] or ( byte((codeword shr (1 + bit))));
      inc(bitPtr, 17);
end;

function TfrxBarcodePDF417.GetSegmentLength(var segm : Segment ) : integer;
begin
   if (segm = nil) then
        result := 0
   else
        result := segm._end - segm._start;
end;

function TfrxBarcodePDF417.CheckSegmentType(var segm : Segment; typ : char) : boolean;
begin
    if (segm = nil) then
        result := false
    else
        result :=  segm._type = typ;
end;



constructor Segment.Create( _t : char; _s, _e : integer);
begin
    _type := _t;
    _start := _s;
    _end := _e;
end;

constructor TSegmentList.Create;
begin
  list := TList.Create;
end;

destructor TSegmentList.Destroy;
var
  i: Integer;
begin
  for i := 0 to list.Count - 1 do
    Segment(List[i]).Free;
  List.Free;
end;

procedure  TSegmentList.Add(_type: char; _start,_end : integer);
begin
    list.Add(Segment.Create(_type, _start, _end));
end;

function TSegmentList.Get(idx : integer) : Segment;
begin
    if (idx < 0) or (idx >= list.Count) then
        result := nil
    else
        result := list[idx];
end;
procedure TSegmentList.Remove( idx : integer);
begin
    if (idx < 0) or (idx >= list.Count) then
        exit;
    list.Delete(idx);
end;

function TSegmentList.Size : integer;
begin
    result := list.count;
end;

end.

