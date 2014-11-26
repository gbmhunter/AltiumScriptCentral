object FormStatsD: TFormStatsD
  Left = 0
  Top = 0
  Caption = 'FormStatsD'
  ClientHeight = 270
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormStatsDShow
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
    Left = 154
    Top = 33
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label1: TLabel
    Left = 26
    Top = 49
    Width = 122
    Height = 13
    Caption = 'Num. of Pads With Holes:'
  end
  object LabelNumOfPadsWithHoles: TLabel
    Left = 154
    Top = 49
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label3: TLabel
    Left = 26
    Top = 65
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
    Left = 154
    Top = 65
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
    Top = 129
    Width = 115
    Height = 13
    Caption = 'Min. Annular Ring (mm):'
  end
  object LabelMinAnnularRingMm: TLabel
    Left = 154
    Top = 129
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label5: TLabel
    Left = 26
    Top = 145
    Width = 111
    Height = 13
    Caption = 'Min. Track Width (mm):'
  end
  object LabelMinTrackWidthMm: TLabel
    Left = 154
    Top = 145
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label6: TLabel
    Left = 26
    Top = 161
    Width = 102
    Height = 13
    Caption = 'Num. Copper Layers:'
  end
  object LabelNumCopperLayers: TLabel
    Left = 154
    Top = 161
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label7: TLabel
    Left = 26
    Top = 193
    Width = 189
    Height = 13
    Caption = 'Board Width (bounding rectangle, mm):'
  end
  object Label8: TLabel
    Left = 26
    Top = 209
    Width = 192
    Height = 13
    Caption = 'Board Height (bounding rectangle, mm):'
  end
  object LabelBoardWidthMm: TLabel
    Left = 234
    Top = 193
    Width = 6
    Height = 13
    Caption = '0'
  end
  object LabelBoardHeightMm: TLabel
    Left = 234
    Top = 209
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label9: TLabel
    Left = 26
    Top = 97
    Width = 151
    Height = 13
    Caption = 'Number of Different Hole Sizes:'
  end
  object LabelNumDiffHoleSizes: TLabel
    Left = 186
    Top = 97
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label10: TLabel
    Left = 26
    Top = 225
    Width = 198
    Height = 13
    Caption = 'Board Area (bounding rectangle, mm^2):'
  end
  object LabelBoardAreaMm: TLabel
    Left = 234
    Top = 225
    Width = 6
    Height = 13
    Caption = '0'
  end
end
