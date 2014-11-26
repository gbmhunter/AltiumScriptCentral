object FormStats: TFormStats
  Left = 0
  Top = 0
  Caption = 'PCB Stats'
  ClientHeight = 301
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
    Width = 76
    Height = 13
    Caption = 'Number of Vias:'
  end
  object LabelNumOfVias: TLabel
    Left = 202
    Top = 33
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label1: TLabel
    Left = 26
    Top = 49
    Width = 155
    Height = 13
    Caption = 'Num. of Pads With Plated Holes:'
  end
  object LabelNumOfPadsWithPlatedHoles: TLabel
    Left = 202
    Top = 49
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label3: TLabel
    Left = 26
    Top = 81
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
    Top = 81
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
    Top = 153
    Width = 115
    Height = 13
    Caption = 'Min. Annular Ring (mm):'
  end
  object LabelMinAnnularRingMm: TLabel
    Left = 154
    Top = 153
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label5: TLabel
    Left = 26
    Top = 169
    Width = 111
    Height = 13
    Caption = 'Min. Track Width (mm):'
  end
  object LabelMinTrackWidthMm: TLabel
    Left = 154
    Top = 169
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label6: TLabel
    Left = 26
    Top = 185
    Width = 102
    Height = 13
    Caption = 'Num. Copper Layers:'
  end
  object LabelNumCopperLayers: TLabel
    Left = 154
    Top = 185
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label7: TLabel
    Left = 26
    Top = 217
    Width = 189
    Height = 13
    Caption = 'Board Width (bounding rectangle, mm):'
  end
  object Label8: TLabel
    Left = 26
    Top = 233
    Width = 192
    Height = 13
    Caption = 'Board Height (bounding rectangle, mm):'
  end
  object LabelBoardWidthMm: TLabel
    Left = 234
    Top = 217
    Width = 6
    Height = 13
    Caption = '0'
  end
  object LabelBoardHeightMm: TLabel
    Left = 234
    Top = 233
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label9: TLabel
    Left = 26
    Top = 121
    Width = 151
    Height = 13
    Caption = 'Number of Different Hole Sizes:'
  end
  object LabelNumDiffHoleSizes: TLabel
    Left = 186
    Top = 121
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label10: TLabel
    Left = 26
    Top = 249
    Width = 198
    Height = 13
    Caption = 'Board Area (bounding rectangle, mm^2):'
  end
  object LabelBoardAreaMm: TLabel
    Left = 234
    Top = 249
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label11: TLabel
    Left = 26
    Top = 65
    Width = 168
    Height = 13
    Caption = 'Num. of Pads With Unplated Holes:'
  end
  object LabelNumOfPadsWithUnplatedHoles: TLabel
    Left = 202
    Top = 65
    Width = 6
    Height = 13
    Caption = '0'
  end
end
