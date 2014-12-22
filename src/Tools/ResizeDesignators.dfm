object FormResizeDesignators: TFormResizeDesignators
  Left = 0
  Top = 0
  Caption = 'Resize Designators'
  ClientHeight = 201
  ClientWidth = 304
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
    Left = 40
    Top = 78
    Width = 59
    Height = 13
    Caption = 'Width (mm):'
  end
  object Label2: TLabel
    Left = 40
    Top = 46
    Width = 62
    Height = 13
    Caption = 'Height (mm):'
  end
  object EditWidthMm: TEdit
    Left = 115
    Top = 75
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '0.2'
  end
  object EditHeightMm: TEdit
    Left = 115
    Top = 43
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '0.7'
  end
  object ButtonOk: TButton
    Left = 50
    Top = 152
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = ButtonOkClick
  end
  object ButtonCancel: TButton
    Left = 170
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = ButtonCancelClick
  end
  object CheckBoxOnlyModifyDefaultSizedDesignators: TCheckBox
    Left = 39
    Top = 116
    Width = 217
    Height = 17
    Caption = 'Only modify default-sized designators'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
end
