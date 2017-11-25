object KassePayFrame: TKassePayFrame
  Left = 0
  Top = 0
  Width = 318
  Height = 368
  TabOrder = 0
  OnEnter = FrameEnter
  object GroupBox1: TGroupBox
    Left = 9
    Top = 13
    Width = 300
    Height = 105
    Caption = 'Betrag:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 233
      Height = 40
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Panel1: TPanel
      Left = 240
      Top = 40
      Width = 41
      Height = 40
      BevelInner = bvLowered
      BevelOuter = bvLowered
      Caption = #8364
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 9
    Top = 133
    Width = 300
    Height = 105
    Caption = 'Gegeben:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Edit2: TEdit
      Left = 8
      Top = 40
      Width = 233
      Height = 40
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -25
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = Edit2Change
      OnKeyPress = Edit2KeyPress
    end
    object Panel2: TPanel
      Left = 240
      Top = 40
      Width = 41
      Height = 40
      BevelInner = bvLowered
      BevelOuter = bvLowered
      Caption = #8364
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object GroupBox3: TGroupBox
    Left = 9
    Top = 253
    Width = 300
    Height = 105
    Caption = 'Zur'#252'ck'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 233
      Height = 40
      Alignment = taCenter
      AutoSize = False
      Caption = '- - -'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Panel3: TPanel
      Left = 240
      Top = 40
      Width = 41
      Height = 40
      BevelInner = bvLowered
      BevelOuter = bvLowered
      Caption = #8364
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
end
