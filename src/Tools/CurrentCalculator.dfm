object FormCurrentCalculator: TFormCurrentCalculator
  Left = 0
  Top = 0
  Caption = 'Current Calculator'
  ClientHeight = 367
  ClientWidth = 288
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LabelTrackThicknessUmText: TLabel
    Left = 16
    Top = 30
    Width = 104
    Height = 13
    Caption = 'Track Thickness (um):'
  end
  object LabelTrackThicknessUm: TLabel
    Left = 200
    Top = 30
    Width = 12
    Height = 13
    Caption = '35'
  end
  object LabelTrackWidthMmTitle: TLabel
    Left = 16
    Top = 46
    Width = 88
    Height = 13
    Caption = 'Track Width (mm):'
  end
  object LabelTrackWidthMm: TLabel
    Left = 200
    Top = 46
    Width = 16
    Height = 13
    Caption = '0.4'
  end
  object LabelTrackLayerTitle: TLabel
    Left = 16
    Top = 62
    Width = 60
    Height = 13
    Caption = 'Track Layer:'
  end
  object LabelTrackLayer: TLabel
    Left = 200
    Top = 62
    Width = 40
    Height = 13
    Caption = 'External'
  end
  object LabelTrackCrossSectionalAreaMm2Title: TLabel
    Left = 16
    Top = 78
    Width = 173
    Height = 13
    Caption = 'Track Cross-sectional Area (mm^2):'
  end
  object LabelTrackCrosssectionalAreaMm2: TLabel
    Left = 200
    Top = 78
    Width = 28
    Height = 13
    Caption = '0.008'
  end
  object Label7: TLabel
    Left = 16
    Top = 278
    Width = 111
    Height = 16
    Caption = 'Max Current (A):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelMaxCurrentA: TLabel
    Left = 200
    Top = 278
    Width = 30
    Height = 16
    Caption = '1.2A'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 16
    Top = 254
    Width = 111
    Height = 13
    Caption = 'Allowed Temp Rise (C):'
  end
  object LabelViaFinishedHoleDiameterMmTitle: TLabel
    Left = 16
    Top = 118
    Width = 157
    Height = 13
    Caption = 'Via Finished Hole Diameter (mm):'
  end
  object LabelViaHeightMmTitle: TLabel
    Left = 16
    Top = 166
    Width = 79
    Height = 13
    Caption = 'Via Height (mm):'
  end
  object LabelViaStartLayerTitle: TLabel
    Left = 16
    Top = 134
    Width = 75
    Height = 13
    Caption = 'Via Start Layer:'
  end
  object LabelViaStopLayerTitle: TLabel
    Left = 16
    Top = 150
    Width = 73
    Height = 13
    Caption = 'Via Stop Layer:'
  end
  object LabelViaFinishedHoleDiameterMm: TLabel
    Left = 200
    Top = 118
    Width = 16
    Height = 13
    Caption = '0.2'
  end
  object LabelViaStartLayer: TLabel
    Left = 200
    Top = 134
    Width = 48
    Height = 13
    Caption = 'Top Layer'
  end
  object LabelViaStopLayer: TLabel
    Left = 200
    Top = 150
    Width = 64
    Height = 13
    Caption = 'Bottom Layer'
  end
  object LabelViaHeightMm: TLabel
    Left = 200
    Top = 166
    Width = 16
    Height = 13
    Caption = '1.6'
  end
  object LabelViaPlatingThicknessUmTitle: TLabel
    Left = 16
    Top = 182
    Width = 127
    Height = 13
    Caption = 'Via Plating Thickness (um):'
  end
  object LabelViaCrossSectionalAreaMm2Title: TLabel
    Left = 16
    Top = 206
    Width = 161
    Height = 13
    Caption = 'Via Cross-sectional Area (mm^2):'
  end
  object LabelViaCrossSectionalAreaMm2: TLabel
    Left = 200
    Top = 206
    Width = 28
    Height = 13
    Caption = '0.002'
  end
  object EditAllowedTempRise: TEdit
    Left = 195
    Top = 251
    Width = 69
    Height = 21
    TabOrder = 0
    Text = '20'
    OnChange = EditAllowedTempRiseChange
  end
  object ButtonFindAnotherTrack: TButton
    Left = 82
    Top = 313
    Width = 134
    Height = 25
    Caption = 'Find Another Track/Via'
    TabOrder = 1
    OnClick = ButtonFindAnotherTrackClick
  end
  object EditViaPlatingThicknessUm: TEdit
    Left = 198
    Top = 180
    Width = 66
    Height = 21
    TabOrder = 2
    Text = '35'
  end
end
