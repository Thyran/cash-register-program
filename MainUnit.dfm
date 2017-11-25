object KasseFrame: TKasseFrame
  Left = 191
  Top = 124
  Width = 667
  Height = 494
  BorderIcons = [biSystemMenu]
  Caption = 'KasseFrame'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AutoConnectPanel: TPanel
    Left = 540
    Top = 10
    Width = 89
    Height = 57
    Caption = 'AutoConnect'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = AutoConnectPanelClick
  end
  object EnabledPanel: TPanel
    Left = 356
    Top = 10
    Width = 73
    Height = 57
    Caption = 'Disabled'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object ConnectedPanel: TPanel
    Left = 436
    Top = 10
    Width = 93
    Height = 57
    Caption = 'ConnectedPanel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object RichEdit1: TRichEdit
    Left = 20
    Top = 50
    Width = 320
    Height = 370
    Cursor = crArrow
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 3
    OnEnter = RichEdit1Enter
    OnKeyPress = RichEdit1KeyPress
    OnMouseDown = RichEdit1MouseDown
  end
  object Panel1: TPanel
    Left = 20
    Top = 10
    Width = 160
    Height = 41
    Caption = 'Nummer'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object Panel2: TPanel
    Left = 179
    Top = 10
    Width = 160
    Height = 41
    Caption = 'Preis'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object GroupBox1: TGroupBox
    Left = 356
    Top = 170
    Width = 273
    Height = 73
    Caption = 'Verk'#228'ufer:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    object Edit1: TEdit
      Left = 8
      Top = 24
      Width = 217
      Height = 40
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -25
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = Edit1Change
      OnKeyPress = Edit1KeyPress
    end
    object Panel3: TPanel
      Left = 224
      Top = 24
      Width = 41
      Height = 40
      BevelInner = bvLowered
      BevelOuter = bvLowered
      Caption = #8364
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 356
    Top = 250
    Width = 273
    Height = 73
    Caption = 'Preis:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    object Edit2: TEdit
      Left = 8
      Top = 24
      Width = 217
      Height = 40
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -25
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnKeyPress = Edit2KeyPress
    end
    object Panel4: TPanel
      Left = 224
      Top = 24
      Width = 41
      Height = 40
      BevelInner = bvLowered
      BevelOuter = bvLowered
      Caption = #8364
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object GroupBox3: TGroupBox
    Left = 356
    Top = 330
    Width = 273
    Height = 73
    Caption = 'Summe:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 217
      Height = 40
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Panel5: TPanel
      Left = 224
      Top = 24
      Width = 41
      Height = 40
      BevelInner = bvLowered
      BevelOuter = bvLowered
      Caption = #8364
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object GroupBox4: TGroupBox
    Left = 404
    Top = 80
    Width = 157
    Height = 81
    Caption = 'Kunden:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    object Panel6: TPanel
      Left = 8
      Top = 24
      Width = 139
      Height = 49
      Caption = '0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 360
    Top = 88
    object DateiTab: TMenuItem
      Caption = 'Datei'
      object LadeInit1: TMenuItem
        Caption = 'Lade Init'
        OnClick = LadeInit1Click
      end
      object Drucker1: TMenuItem
        Caption = 'Drucker'
        OnClick = Drucker1Click
      end
      object Zusammenfassungerstellen1: TMenuItem
        Caption = 'Zusammenfassung erstellen'
        OnClick = Zusammenfassungerstellen1Click
      end
      object Beenden1: TMenuItem
        Caption = 'Beenden'
        OnClick = Beenden1Click
      end
    end
    object Verbindung1: TMenuItem
      Caption = 'Verbindung'
      object Informationen1: TMenuItem
        Caption = 'Informationen'
        OnClick = Verbindung1Click
      end
      object Verbindung2: TMenuItem
        Caption = 'Verbindung'
        object Verbinden1: TMenuItem
          Caption = 'Verbinden'
          OnClick = Verbinden1Click
        end
        object Automatischverbinden1: TMenuItem
          Caption = 'Automatisch verbinden'
          Checked = True
          OnClick = Automatischverbinden1Click
        end
      end
    end
    object Kasse1: TMenuItem
      Caption = 'Kasse'
      object Informationen2: TMenuItem
        Caption = 'Informationen'
        OnClick = Informationen2Click
      end
      object Rechnungen1: TMenuItem
        Caption = 'Rechnungen'
        OnClick = Rechnungen1Click
      end
      object Kassenstand1: TMenuItem
        Caption = 'Kassenstand'
        OnClick = Kassenstand1Click
      end
      object drucken1: TMenuItem
        Caption = 'drucken'
        OnClick = drucken1Click
      end
    end
    object est1: TMenuItem
      Caption = 'Test'
      object StarteTest1: TMenuItem
        Caption = 'StarteTest'
        OnClick = StarteTest1Click
      end
    end
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 360
    Top = 112
  end
end
