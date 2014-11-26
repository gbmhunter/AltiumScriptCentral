object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 494
  ClientWidth = 953
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = Form1Create
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
    Height = 272
    ParentBackground = False
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 346
    Top = 64
    Width = 286
    Height = 272
    ParentBackground = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 34
    Top = 64
    Width = 286
    Height = 272
    Ctl3D = True
    ParentBackground = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 2
  end
  object ButPushProjectParameters: TButton
    Left = 386
    Top = 176
    Width = 206
    Height = 24
    Caption = 'Push Project Parameters To Schematics'
    TabOrder = 3
  end
  object ButRenumberPads: TButton
    Left = 706
    Top = 176
    Width = 206
    Height = 24
    Caption = 'Renumber Pads'
    TabOrder = 4
  end
  object Button2: TButton
    Left = 708
    Top = 206
    Width = 204
    Height = 25
    Caption = 'Resize Designators'
    TabOrder = 5
  end
  object ButNumberSchematics: TButton
    Left = 388
    Top = 142
    Width = 204
    Height = 25
    Caption = 'Number Schematics'
    TabOrder = 6
  end
  object ButRotateDesignators: TButton
    Left = 708
    Top = 238
    Width = 204
    Height = 25
    Caption = 'Rotate Designators'
    TabOrder = 7
  end
  object ButDeleteSchParams: TButton
    Left = 388
    Top = 110
    Width = 204
    Height = 26
    Caption = 'Delete Schematic Parameters'
    TabOrder = 8
  end
  object ButAddSpecialSchematicParameters: TButton
    Left = 388
    Top = 78
    Width = 204
    Height = 25
    Caption = 'Add Special Schematic Parameters'
    TabOrder = 9
  end
  object ButtonDisplayPcbStats: TButton
    Left = 708
    Top = 110
    Width = 204
    Height = 25
    Caption = 'Display PCB Stats'
    TabOrder = 10
    OnClick = ButtonDisplayPcbStatsClick
  end
  object ButtonViaStamper: TButton
    Left = 708
    Top = 270
    Width = 204
    Height = 26
    Caption = 'Via Stamper'
    TabOrder = 11
  end
  object ButtonDrawPolygon: TButton
    Left = 708
    Top = 142
    Width = 204
    Height = 25
    Caption = 'Draw Polygon'
    TabOrder = 12
  end
  object ButtonCurrentCalculator: TButton
    Left = 708
    Top = 78
    Width = 204
    Height = 26
    Caption = 'Current Calculator'
    TabOrder = 13
  end
  object ButtonRunPreReleaseChecks: TButton
    Left = 66
    Top = 80
    Width = 206
    Height = 24
    Caption = 'Run Pre-release Checks'
    TabOrder = 14
    OnClick = ButtonRunPreReleaseChecksClick
  end
end
