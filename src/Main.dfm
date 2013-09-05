object FormMainScript: TFormMainScript
  Left = 0
  Top = 0
  Caption = 'Script Central'
  ClientHeight = 758
  ClientWidth = 1060
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblErrors: TLabel
    Left = 50
    Top = 396
    Width = 98
    Height = 39
    Caption = 'Errors'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 42
    Top = 92
    Width = 101
    Height = 39
    Caption = 'Status'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 762
    Top = 92
    Width = 86
    Height = 39
    Caption = 'Tools'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 266
    Top = 48
    Width = 206
    Height = 48
    Caption = 'Run Pre-release Checks'
    TabOrder = 0
    OnClick = ButRunChecks
  end
  object MemoStdOut: TMemo
    Left = 41
    Top = 133
    Width = 655
    Height = 259
    TabOrder = 1
  end
  object MemoStdErr: TMemo
    Left = 41
    Top = 437
    Width = 655
    Height = 259
    TabOrder = 2
  end
  object ButPushProjectParameters: TButton
    Left = 762
    Top = 144
    Width = 206
    Height = 24
    Caption = 'Push Project Parameters To Schematics'
    TabOrder = 3
  end
  object ButRenumberPads: TButton
    Left = 762
    Top = 184
    Width = 206
    Height = 24
    Caption = 'Renumber Pads'
    TabOrder = 4
    OnClick = MainRenumberPads
  end
  object Button2: TButton
    Left = 764
    Top = 222
    Width = 204
    Height = 25
    Caption = 'Resize Designators'
    TabOrder = 5
    OnClick = MainResizeDesignators
  end
end
