object KasseControl: TKasseControl
  Left = 0
  Top = 0
  Width = 350
  Height = 200
  TabOrder = 0
  object Container: TPanel
    Left = 11
    Top = 11
    Width = 330
    Height = 177
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object KassePanel: TPanel
      Left = 8
      Top = 8
      Width = 137
      Height = 161
      Caption = 'KassenControl'
      TabOrder = 0
      OnClick = KassePanelClick
    end
    object KassenstandButton: TButton
      Left = 144
      Top = 8
      Width = 105
      Height = 41
      Caption = 'Kassenstand'
      TabOrder = 1
      OnClick = KassenstandButtonClick
    end
    object BillButton: TButton
      Left = 144
      Top = 48
      Width = 105
      Height = 41
      Caption = 'Rechnungen'
      TabOrder = 2
      OnClick = BillButtonClick
    end
    object AutoConnectButton: TPanel
      Left = 144
      Top = 128
      Width = 105
      Height = 41
      BevelOuter = bvSpace
      Caption = 'AutoConnect'
      TabOrder = 3
      OnClick = AutoConnectButtonClick
    end
    object KundenPanel: TPanel
      Left = 256
      Top = 8
      Width = 65
      Height = 57
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Caption = 'Kunden'
      TabOrder = 4
    end
    object ErrorPanel: TPanel
      Left = 256
      Top = 112
      Width = 65
      Height = 57
      BevelInner = bvRaised
      TabOrder = 5
      OnClick = ErrorPanelClick
    end
    object EnableButton: TPanel
      Left = 144
      Top = 88
      Width = 105
      Height = 41
      BevelOuter = bvSpace
      Caption = 'Enable/Disable'
      TabOrder = 6
      OnClick = EnableButtonClick
    end
  end
end
