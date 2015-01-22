object FormMainScript: TFormMainScript
  Left = 0
  Top = 0
  Caption = 'Altium Script Central'
  ClientHeight = 457
  ClientWidth = 973
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
  object Label2: TLabel
    Left = 730
    Top = 20
    Width = 159
    Height = 39
    Caption = 'PCB Tools'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 362
    Top = 20
    Width = 261
    Height = 39
    Caption = 'Schematic Tools'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 66
    Top = 20
    Width = 211
    Height = 39
    Caption = 'Project Tools'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel3: TPanel
    Left = 658
    Top = 64
    Width = 286
    Height = 320
    ParentBackground = False
    TabOrder = 14
  end
  object Panel2: TPanel
    Left = 346
    Top = 64
    Width = 286
    Height = 320
    ParentBackground = False
    TabOrder = 13
  end
  object Panel1: TPanel
    Left = 34
    Top = 64
    Width = 286
    Height = 320
    Ctl3D = True
    ParentBackground = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 12
  end
  object ButPushProjectParameters: TButton
    Left = 386
    Top = 176
    Width = 206
    Height = 24
    Caption = 'Push Project Parameters To Schematics'
    TabOrder = 0
    OnClick = ButtonPushProjectParametersToSchematics_Click
  end
  object ButRenumberPads: TButton
    Left = 706
    Top = 208
    Width = 206
    Height = 24
    Caption = 'Renumber Pads'
    TabOrder = 1
    OnClick = ButtonRenumberPads_Click
  end
  object Button2: TButton
    Left = 708
    Top = 238
    Width = 204
    Height = 25
    Caption = 'Resize Designators'
    TabOrder = 2
    OnClick = ButtonResizeDesignators_Click
  end
  object ButNumberSchematics: TButton
    Left = 388
    Top = 142
    Width = 204
    Height = 25
    Caption = 'Number Schematics'
    TabOrder = 3
    OnClick = ButNumberSchematics_Click
  end
  object ButRotateDesignators: TButton
    Left = 708
    Top = 270
    Width = 204
    Height = 25
    Caption = 'Rotate Designators'
    TabOrder = 4
    OnClick = ButtonRotateDesignators_Click
  end
  object ButDeleteSchParams: TButton
    Left = 388
    Top = 110
    Width = 204
    Height = 26
    Caption = 'Delete Schematic Parameters'
    TabOrder = 5
    OnClick = ButDeleteSchParams_Click
  end
  object ButAddSpecialSchematicParameters: TButton
    Left = 388
    Top = 78
    Width = 204
    Height = 25
    Caption = 'Add Special Schematic Parameters'
    TabOrder = 6
    OnClick = ButAddSpecialSchematicParameters_Click
  end
  object ButtonDisplayPcbStats: TButton
    Left = 708
    Top = 110
    Width = 204
    Height = 25
    Caption = 'Display PCB Stats'
    TabOrder = 7
    OnClick = ButtonDisplayPcbStats_Click
  end
  object ButtonViaStamper: TButton
    Left = 708
    Top = 302
    Width = 204
    Height = 26
    Caption = 'Via Stamper'
    TabOrder = 8
    OnClick = ButtonViaStamper_Click
  end
  object ButtonDrawPolygon: TButton
    Left = 708
    Top = 142
    Width = 204
    Height = 25
    Caption = 'Draw Polygon'
    TabOrder = 9
    OnClick = ButtonDrawPolygon_Click
  end
  object ButtonCurrentCalculator: TButton
    Left = 708
    Top = 78
    Width = 204
    Height = 26
    Caption = 'Current Calculator'
    TabOrder = 10
    OnClick = ButtonCurrentCalculator_Click
  end
  object ButtonRunPreReleaseChecks: TButton
    Left = 74
    Top = 112
    Width = 206
    Height = 24
    Caption = 'Run Pre-release Checks'
    TabOrder = 11
    OnClick = ButtonRunPreReleaseChecks_Click
  end
  object ButtonSwapComponents: TButton
    Left = 708
    Top = 174
    Width = 204
    Height = 26
    Caption = 'Swap Components'
    TabOrder = 15
    OnClick = ButtonSwapComponents_Click
  end
  object ButtonExitActiveCommand: TButton
    Left = 74
    Top = 80
    Width = 206
    Height = 24
    Caption = 'Exit Active Command'
    TabOrder = 16
    OnClick = ButtonExitActiveCommand_Click
  end
  object ButtonExit: TButton
    Left = 785
    Top = 408
    Width = 127
    Height = 25
    Caption = 'Exit'
    TabOrder = 17
    OnClick = ButtonExit_Click
  end
end
