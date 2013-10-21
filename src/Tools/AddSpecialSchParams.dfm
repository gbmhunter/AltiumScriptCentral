object FormAddSpecialSchParams: TFormAddSpecialSchParams
  Left = 0
  Top = 0
  Caption = 'Script Central'
  ClientHeight = 247
  ClientWidth = 442
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
    Left = 26
    Top = 28
    Width = 380
    Height = 39
    Caption = 'Add Special Parameters'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CbDocumentName: TCheckBox
    Left = 41
    Top = 98
    Width = 97
    Height = 17
    Caption = 'DocumentName'
    TabOrder = 0
  end
  object CbProjectName: TCheckBox
    Left = 41
    Top = 146
    Width = 97
    Height = 17
    Caption = 'ProjectName'
    TabOrder = 1
  end
  object CbModifiedDate: TCheckBox
    Left = 41
    Top = 122
    Width = 97
    Height = 17
    Caption = 'ModifiedDate'
    TabOrder = 2
  end
  object ButAdd: TButton
    Left = 76
    Top = 190
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 3
    OnClick = ButAddClick
  end
end
