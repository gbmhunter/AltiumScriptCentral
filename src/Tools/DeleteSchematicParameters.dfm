object FormDeleteSchematicParameters: TFormDeleteSchematicParameters
  Left = 0
  Top = 0
  Caption = 'Delete Schematic Parameters'
  ClientHeight = 311
  ClientWidth = 406
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
    Left = 74
    Top = 80
    Width = 84
    Height = 13
    Caption = 'Parameter Name:'
  end
  object RadioGroupWhichSchematics: TRadioGroup
    Left = 29
    Top = 152
    Width = 283
    Height = 105
    Caption = 'From Which Schematics?'
    ItemIndex = 0
    Items.Strings = (
      'Delete From Active Schematic'
      'Delete From All Schematics Of Active Project')
    TabOrder = 4
  end
  object RadioGroupWhichParameters: TRadioGroup
    Left = 29
    Top = 24
    Width = 283
    Height = 121
    Caption = 'Which Parameters?'
    ItemIndex = 0
    Items.Strings = (
      'Delete Specific Parameter'
      'Delete All Parameters')
    TabOrder = 3
  end
  object TEditParameterName: TEdit
    Left = 165
    Top = 77
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'DrawnBy'
  end
  object ButtonExit: TButton
    Left = 300
    Top = 266
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 1
    OnClick = ButtonExit_Click
  end
  object ButtonDelete: TButton
    Left = 212
    Top = 266
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 2
    OnClick = ButtonDelete_Click
  end
end
