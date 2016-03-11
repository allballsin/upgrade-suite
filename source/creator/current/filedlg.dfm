object frmfiledlg: Tfrmfiledlg
  Left = 564
  Top = 249
  BorderStyle = bsNone
  Caption = 'frmfiledlg'
  ClientHeight = 256
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object fdialog: TApOpenDialog
    CustDlgParams.PosParams.ShiftX = 0
    CustDlgParams.PosParams.ShiftY = 0
    CustDlgParams.PosParams.FitToScreen = False
    VisibleControls = [dcFolderCombo, dcFolderLabel, dcSelectionCtrl, dcOkBtn, dcCancelBtn, dcFileName, dcFileNameLabel, dcFileType, dcFileTypeLabel, dcToolBar]
    ListViewStyles.lvHotTrack = False
    ListViewStyles.lvHotTrackStyles = []
    ListViewStyles.lvFlatScrollBars = False
    ListViewStyles.lvGridLines = False
    ListViewStyles.lvRowSelect = False
    ListViewStyles.lvEnableEdit = True
    ListViewStyles.lvEnableDelete = True
    ListViewStyles.lvPopupOnEmpty = True
    ListViewStyles.lvPopupOnSelection = True
    PlacesBar.Places = <>
    PlacesBar.Visible = False
    PlacesBar.AllowEdit = True
    PlacesBar.AllowDelete = True
    PlacesBar.AllowDrop = True
    PlacesBar.AutoScroll = True
    ExtFilter.ShowFolders = True
    ExtFilter.Enabled = False
    Left = 72
    Top = 64
  end
end
