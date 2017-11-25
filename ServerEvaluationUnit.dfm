object EvaluationFrame: TEvaluationFrame
  Left = 530
  Top = 212
  Width = 673
  Height = 307
  BorderIcons = [biSystemMenu]
  Caption = 'EvaluationFrame'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit1: TRichEdit
    Left = 144
    Top = 8
    Width = 369
    Height = 233
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    HideScrollBars = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 129
    Height = 73
    Caption = 'Pr'#252'fe Kassen'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 88
    Width = 129
    Height = 73
    Caption = 'Speichern'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Visible = False
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 520
    Top = 168
    Width = 129
    Height = 73
    Caption = 'Schlie'#223'en'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 168
    Width = 73
    Height = 73
    Caption = 'Drucke Beleg Nr'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Visible = False
    WordWrap = True
    OnClick = Button4Click
  end
  object SpinEdit1: TSpinEdit
    Left = 88
    Top = 192
    Width = 57
    Height = 30
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    MaxValue = 0
    MinValue = 0
    ParentFont = False
    TabOrder = 5
    Value = 0
    Visible = False
  end
  object Button5: TButton
    Left = 520
    Top = 88
    Width = 129
    Height = 73
    Caption = 'Drucke alle Belege'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Visible = False
    WordWrap = True
    OnClick = Button5Click
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 520
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 552
    Top = 8
    object Datei1: TMenuItem
      Caption = 'Datei'
      object Schlieen1: TMenuItem
        Caption = 'Schlie'#223'en'
        OnClick = Schlieen1Click
      end
    end
    object Drucker1: TMenuItem
      Caption = 'Drucker'
      OnClick = Drucker1Click
    end
  end
end
