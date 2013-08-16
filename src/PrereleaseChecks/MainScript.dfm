object FormMainScript: TFormMainScript
  Left = 0
  Top = 0
  Caption = 'FormMainScript'
  ClientHeight = 382
  ClientWidth = 723
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 42
    Top = 40
    Width = 174
    Height = 25
    Caption = 'Run Pre-release Checks'
    TabOrder = 0
    OnClick = Button1Click
  end
  object MemoOutput: TMemo
    Left = 41
    Top = 93
    Width = 655
    Height = 259
    TabOrder = 1
  end
end
