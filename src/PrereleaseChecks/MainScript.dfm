object FormMainScript: TFormMainScript
  Left = 0
  Top = 0
  Caption = 'Script Main'
  ClientHeight = 383
  ClientWidth = 1002
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ButRunPreReleaseChecks: TButton
    Left = 58
    Top = 72
    Width = 166
    Height = 25
    Caption = 'Run Pre-Release Checks'
    TabOrder = 0
    OnClick = ButRunPreReleaseChecksClick
  end
  object MemoInfo: TMemo
    Left = 57
    Top = 115
    Width = 871
    Height = 189
    TabOrder = 1
  end
end
