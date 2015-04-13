object FormStats: TFormStats
  Left = 0
  Top = 0
  Caption = 'PCB Stats'
  ClientHeight = 470
  ClientWidth = 378
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 26
    Top = 33
    Width = 87
    Height = 13
    Caption = 'Num. Normal Vias:'
  end
  object LabelNumNormalVias: TLabel
    Left = 202
    Top = 33
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label1: TLabel
    Left = 26
    Top = 113
    Width = 194
    Height = 13
    Caption = 'Num. of Pads With Circular Plated Holes:'
  end
  object LabelNumOfPadsWithCircularPlatedHoles: TLabel
    Left = 242
    Top = 113
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label3: TLabel
    Left = 26
    Top = 145
    Width = 218
    Height = 13
    Caption = 'Total Num. of Circular Holes (incl. vias):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelTotalNumOfCircularHoles: TLabel
    Left = 266
    Top = 145
    Width = 7
    Height = 13
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 26
    Top = 321
    Width = 115
    Height = 13
    Caption = 'Min. Annular Ring (mm):'
  end
  object LabelMinAnnularRingMm: TLabel
    Left = 154
    Top = 321
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label5: TLabel
    Left = 26
    Top = 337
    Width = 111
    Height = 13
    Caption = 'Min. Track Width (mm):'
  end
  object LabelMinTrackWidthMm: TLabel
    Left = 154
    Top = 337
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label6: TLabel
    Left = 26
    Top = 353
    Width = 102
    Height = 13
    Caption = 'Num. Copper Layers:'
  end
  object LabelNumCopperLayers: TLabel
    Left = 154
    Top = 353
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label7: TLabel
    Left = 26
    Top = 385
    Width = 189
    Height = 13
    Caption = 'Board Width (bounding rectangle, mm):'
  end
  object Label8: TLabel
    Left = 26
    Top = 401
    Width = 192
    Height = 13
    Caption = 'Board Height (bounding rectangle, mm):'
  end
  object LabelBoardWidthMm: TLabel
    Left = 234
    Top = 385
    Width = 6
    Height = 13
    Caption = '0'
  end
  object LabelBoardHeightMm: TLabel
    Left = 234
    Top = 401
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label9: TLabel
    Left = 26
    Top = 289
    Width = 151
    Height = 13
    Caption = 'Number of Different Hole Sizes:'
  end
  object LabelNumDiffHoleSizes: TLabel
    Left = 186
    Top = 289
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label10: TLabel
    Left = 26
    Top = 417
    Width = 198
    Height = 13
    Caption = 'Board Area (bounding rectangle, mm^2):'
  end
  object LabelBoardAreaMm: TLabel
    Left = 234
    Top = 417
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label11: TLabel
    Left = 26
    Top = 129
    Width = 207
    Height = 13
    Caption = 'Num. of Pads With Circular Unplated Holes:'
  end
  object LabelNumOfPadsWithCircularUnplatedHoles: TLabel
    Left = 242
    Top = 129
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label12: TLabel
    Left = 26
    Top = 273
    Width = 113
    Height = 13
    Caption = 'Largest Hole Size (mm):'
  end
  object Label13: TLabel
    Left = 26
    Top = 257
    Width = 116
    Height = 13
    Caption = 'Smallest Hole Size (mm):'
  end
  object LabelLargestHoleSizeMm: TLabel
    Left = 186
    Top = 273
    Width = 6
    Height = 13
    Caption = '0'
  end
  object LabelSmallestHoleSizeMm: TLabel
    Left = 186
    Top = 257
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label14: TLabel
    Left = 26
    Top = 49
    Width = 76
    Height = 13
    Caption = 'Num. Blind Vias:'
  end
  object LabelNumBlindVias: TLabel
    Left = 202
    Top = 49
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label20: TLabel
    Left = 26
    Top = 65
    Width = 84
    Height = 13
    Caption = 'Num. Buried Vias:'
  end
  object LabelNumBuriedVias: TLabel
    Left = 202
    Top = 65
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label15: TLabel
    Left = 26
    Top = 81
    Width = 104
    Height = 13
    Caption = 'Total Num. Of Vias:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelTotalNumOfVias: TLabel
    Left = 202
    Top = 81
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label16: TLabel
    Left = 26
    Top = 169
    Width = 192
    Height = 13
    Caption = 'Num. of Pads With Slotted Plated Holes:'
  end
  object Label17: TLabel
    Left = 26
    Top = 185
    Width = 205
    Height = 13
    Caption = 'Num. of Pads With Slotted Unplated Holes:'
  end
  object Label18: TLabel
    Left = 26
    Top = 201
    Width = 155
    Height = 13
    Caption = 'Total Num. of Slotted Holes:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label19: TLabel
    Left = 26
    Top = 225
    Width = 233
    Height = 13
    Caption = 'Total Num. of Holes (circular and slotted):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelNumOfPadsWithSlottedPlatedHoles: TLabel
    Left = 250
    Top = 169
    Width = 6
    Height = 13
    Caption = '0'
  end
  object LabelNumOfPadsWithSlottedUnplatedHoles: TLabel
    Left = 250
    Top = 185
    Width = 6
    Height = 13
    Caption = '0'
  end
  object LabelTotalNumOfSlottedHoles: TLabel
    Left = 250
    Top = 201
    Width = 6
    Height = 13
    Caption = '0'
  end
  object LabelTotalNumOfHoles: TLabel
    Left = 282
    Top = 225
    Width = 7
    Height = 13
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
end
