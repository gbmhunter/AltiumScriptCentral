object FormStats: TFormStats
  Left = 0
  Top = 0
  Caption = 'PCB Stats'
  ClientHeight = 411
  ClientWidth = 320
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
    Width = 155
    Height = 13
    Caption = 'Num. of Pads With Plated Holes:'
  end
  object LabelNumOfPadsWithPlatedHoles: TLabel
    Left = 202
    Top = 113
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label3: TLabel
    Left = 26
    Top = 145
    Width = 111
    Height = 13
    Caption = 'Total num. of Holes:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelTotalNumOfHoles: TLabel
    Left = 202
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
    Top = 241
    Width = 115
    Height = 13
    Caption = 'Min. Annular Ring (mm):'
  end
  object LabelMinAnnularRingMm: TLabel
    Left = 154
    Top = 241
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label5: TLabel
    Left = 26
    Top = 257
    Width = 111
    Height = 13
    Caption = 'Min. Track Width (mm):'
  end
  object LabelMinTrackWidthMm: TLabel
    Left = 154
    Top = 257
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label6: TLabel
    Left = 26
    Top = 273
    Width = 102
    Height = 13
    Caption = 'Num. Copper Layers:'
  end
  object LabelNumCopperLayers: TLabel
    Left = 154
    Top = 273
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label7: TLabel
    Left = 26
    Top = 305
    Width = 189
    Height = 13
    Caption = 'Board Width (bounding rectangle, mm):'
  end
  object Label8: TLabel
    Left = 26
    Top = 321
    Width = 192
    Height = 13
    Caption = 'Board Height (bounding rectangle, mm):'
  end
  object LabelBoardWidthMm: TLabel
    Left = 234
    Top = 305
    Width = 6
    Height = 13
    Caption = '0'
  end
  object LabelBoardHeightMm: TLabel
    Left = 234
    Top = 321
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label9: TLabel
    Left = 26
    Top = 209
    Width = 151
    Height = 13
    Caption = 'Number of Different Hole Sizes:'
  end
  object LabelNumDiffHoleSizes: TLabel
    Left = 186
    Top = 209
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label10: TLabel
    Left = 26
    Top = 337
    Width = 198
    Height = 13
    Caption = 'Board Area (bounding rectangle, mm^2):'
  end
  object LabelBoardAreaMm: TLabel
    Left = 234
    Top = 337
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label11: TLabel
    Left = 26
    Top = 129
    Width = 168
    Height = 13
    Caption = 'Num. of Pads With Unplated Holes:'
  end
  object LabelNumOfPadsWithUnplatedHoles: TLabel
    Left = 202
    Top = 129
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label12: TLabel
    Left = 26
    Top = 193
    Width = 113
    Height = 13
    Caption = 'Largest Hole Size (mm):'
  end
  object Label13: TLabel
    Left = 26
    Top = 177
    Width = 116
    Height = 13
    Caption = 'Smallest Hole Size (mm):'
  end
  object LabelLargestHoleSizeMm: TLabel
    Left = 186
    Top = 193
    Width = 6
    Height = 13
    Caption = '0'
  end
  object LabelSmallestHoleSizeMm: TLabel
    Left = 186
    Top = 177
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
end
