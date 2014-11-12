object FormMainScript: TFormMainScript
  Left = 0
  Top = 0
  Caption = 'Altium Script Central'
  ClientHeight = 758
  ClientWidth = 1060
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormMain_Create
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
  object ButtonRunPrereleaseChecks: TButton
    Left = 266
    Top = 48
    Width = 206
    Height = 48
    Caption = 'Run Pre-release Checks'
    TabOrder = 0
    OnClick = ButtonRunPrereleaseChecksClick
  end
  object MemoStdOut: TMemo
    Left = 41
    Top = 133
    Width = 655
    Height = 259
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object MemoStdErr: TMemo
    Left = 41
    Top = 437
    Width = 655
    Height = 259
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object ButPushProjectParameters: TButton
    Left = 762
    Top = 144
    Width = 206
    Height = 24
    Caption = 'Push Project Parameters To Schematics'
    TabOrder = 3
    OnClick = MainPushProjectParametersToSchematics
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
  object ButNumberSchematics: TButton
    Left = 764
    Top = 262
    Width = 204
    Height = 25
    Caption = 'Number Schematics'
    TabOrder = 6
    OnClick = ButNumberSchematics_Click
  end
  object ButRotateDesignators: TButton
    Left = 764
    Top = 302
    Width = 204
    Height = 25
    Caption = 'Rotate Designators'
    TabOrder = 7
    OnClick = ButRotateDesignatorsClick
  end
  object ButDeleteSchParams: TButton
    Left = 764
    Top = 342
    Width = 204
    Height = 26
    Caption = 'Delete Schematic Parameters'
    TabOrder = 8
    OnClick = ButDeleteSchParamsClick
  end
  object ButAddSpecialSchematicParameters: TButton
    Left = 764
    Top = 382
    Width = 204
    Height = 25
    Caption = 'Add Special Schematic Parameters'
    TabOrder = 9
    OnClick = ButAddSpecialSchematicParametersClick
  end
  object ButtonDisplayPcbStats: TButton
    Left = 764
    Top = 422
    Width = 204
    Height = 25
    Caption = 'Display PCB Stats'
    TabOrder = 10
    OnClick = ButtonDisplayPcbStatsClick
  end
  object ButtonViaStamper: TButton
    Left = 764
    Top = 462
    Width = 204
    Height = 26
    Caption = 'Via Stamper'
    TabOrder = 11
    OnClick = ButtonViaStamperClick
  end
  object ButtonDrawPolygon: TButton
    Left = 764
    Top = 502
    Width = 204
    Height = 25
    Caption = 'Draw Polygon'
    TabOrder = 12
    OnClick = ButtonDrawPolygonClick
  end
end
