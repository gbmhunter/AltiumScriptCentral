object FormPreReleaseChecks: TFormPreReleaseChecks
  Left = 0
  Top = 0
  Caption = 'Pre-release Checks'
  ClientHeight = 654
  ClientWidth = 844
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormPreReleaseChecksCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblErrors: TLabel
    Left = 42
    Top = 324
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
    Top = 12
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
  object MemoStdOut: TMemo
    Left = 33
    Top = 61
    Width = 655
    Height = 259
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object MemoStdErr: TMemo
    Left = 33
    Top = 373
    Width = 655
    Height = 259
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
