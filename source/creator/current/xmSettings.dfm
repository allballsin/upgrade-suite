object frmxmSettings: TfrmxmSettings
  Left = 331
  Top = 188
  Width = 321
  Height = 194
  HelpContext = 137
  Caption = 'Transmitter Settings'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 297
    Height = 113
  end
  object cbSilent: TCheckBox
    Left = 16
    Top = 24
    Width = 185
    Height = 17
    Caption = 'Run Transmitter Silently'
    TabOrder = 0
  end
  object cbClose: TCheckBox
    Left = 16
    Top = 56
    Width = 225
    Height = 17
    Caption = 'Close Transmitter when completed'
    TabOrder = 1
  end
  object cbSave: TButton
    Left = 144
    Top = 135
    Width = 75
    Height = 25
    Caption = '&Save'
    TabOrder = 3
    OnClick = cbSaveClick
  end
  object cbCancel: TButton
    Left = 232
    Top = 135
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 4
    OnClick = cbCancelClick
  end
  object cbForceAll: TCheckBox
    Left = 16
    Top = 88
    Width = 233
    Height = 17
    Caption = 'Deploy all files'
    TabOrder = 2
  end
end
