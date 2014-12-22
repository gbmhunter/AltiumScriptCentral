object FormCurrentCalculator: TFormCurrentCalculator
  Left = 0
  Top = 0
  Caption = 'Current Calculator'
  ClientHeight = 201
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
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
  object Label2: TLabel
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
  object Label4: TLabel
    Left = 16
    Top = 62
    Width = 31
    Height = 13
    Caption = 'Layer:'
  end
  object LabelLayer: TLabel
    Left = 200
    Top = 62
    Width = 40
    Height = 13
    Caption = 'External'
  end
  object Label6: TLabel
    Left = 16
    Top = 78
    Width = 173
    Height = 13
    Caption = 'Track Cross-sectional Area (mm^2):'
  end
  object LabelTrackCrosssectionalAreaMm2: TLabel
    Left = 200
    Top = 78
    Width = 40
    Height = 13
    Caption = 'External'
  end
  object Label7: TLabel
    Left = 16
    Top = 134
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
    Top = 134
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
    Top = 102
    Width = 111
    Height = 13
    Caption = 'Allowed Temp Rise (C):'
  end
  object EditAllowedTempRise: TEdit
    Left = 195
    Top = 99
    Width = 69
    Height = 21
    TabOrder = 0
    Text = '20'
  end
end
