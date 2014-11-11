object FormDrawHexagon: TFormDrawHexagon
  Left = 0
  Top = 0
  Caption = 'Draw Hexagon'
  ClientHeight = 389
  ClientWidth = 575
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LabelRotationDeg: TLabel
    Left = 33
    Top = 201
    Width = 74
    Height = 13
    Caption = 'Rotation (deg):'
  end
  object LabelLineThickness: TLabel
    Left = 33
    Top = 49
    Width = 99
    Height = 13
    Caption = 'Line Thickness (mm):'
  end
  object Label2: TLabel
    Left = 33
    Top = 273
    Width = 59
    Height = 13
    Caption = 'Draw Layer:'
  end
  object EditVertexRadiusMm: TEdit
    Left = 148
    Top = 94
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '10'
  end
  object EditRotationDeg: TEdit
    Left = 148
    Top = 198
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object ButtonDrawOnPcb: TButton
    Left = 107
    Top = 315
    Width = 165
    Height = 25
    Caption = 'Draw On PCB'
    TabOrder = 2
    OnClick = ButtonDrawOnPcbClick
  end
  object EditLineThicknessMm: TEdit
    Left = 148
    Top = 46
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '0.2'
  end
  object Memo1: TMemo
    Left = 283
    Top = 43
    Width = 250
    Height = 42
    Lines.Strings = (
      'The desired thickness (in mm) of the lines the '
      'hexagon will be drawn with.')
    TabOrder = 4
  end
  object Memo2: TMemo
    Left = 283
    Top = 91
    Width = 250
    Height = 42
    Lines.Strings = (
      'The radius (in mm) of a theoretical circle that '
      'touches all of the hexagon'#39's verticies.')
    TabOrder = 5
  end
  object Memo3: TMemo
    Left = 283
    Top = 195
    Width = 250
    Height = 63
    Lines.Strings = (
      'The clockwise rotation (in degrees) that the '
      'hexagon will be drawn at. An angle of 0 is when '
      'one of the hexagon sides is horizontal and at the '
      'top of the shape.')
    TabOrder = 6
  end
  object ButtonCancel: TButton
    Left = 315
    Top = 315
    Width = 165
    Height = 25
    Caption = 'Cancel'
    TabOrder = 7
    OnClick = ButtonCancelClick
  end
  object EditDrawLayer: TEdit
    Left = 148
    Top = 270
    Width = 121
    Height = 21
    TabOrder = 8
    Text = 'Top Layer'
  end
  object Memo4: TMemo
    Left = 283
    Top = 267
    Width = 250
    Height = 21
    Lines.Strings = (
      'PCB layer to draw the hexagon onto.')
    TabOrder = 9
  end
  object RadioButtonVertexRadiusMm: TRadioButton
    Left = 15
    Top = 95
    Width = 113
    Height = 17
    Caption = 'Vertex Radius (mm):'
    Checked = True
    TabOrder = 10
    TabStop = True
  end
  object RadioButtonEdgeRadiusMm: TRadioButton
    Left = 15
    Top = 143
    Width = 113
    Height = 17
    Caption = 'Edge Radius (mm):'
    TabOrder = 11
  end
  object EditEdgeRadiusMm: TEdit
    Left = 148
    Top = 142
    Width = 121
    Height = 21
    TabOrder = 12
    Text = '10'
  end
  object Memo5: TMemo
    Left = 283
    Top = 139
    Width = 250
    Height = 42
    Lines.Strings = (
      'The radius (in mm) of a theoretical circle that '
      'touches all of the hexagon'#39's edges.')
    TabOrder = 13
  end
end
