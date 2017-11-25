object ServerFrame: TServerFrame
  Left = 189
  Top = 124
  Width = 746
  Height = 314
  BorderIcons = [biSystemMenu]
  Caption = 'Server'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Log: TRichEdit
    Left = 390
    Top = 55
    Width = 320
    Height = 180
    Cursor = crArrow
    DragCursor = crArrow
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    HideScrollBars = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnEnter = LogEnter
    OnKeyPress = LogKeyPress
  end
  object Edit1: TEdit
    Left = 390
    Top = 28
    Width = 320
    Height = 20
    AutoSize = False
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnEnter = Edit1Enter
    OnKeyPress = Edit1KeyPress
  end
  object MainMenu1: TMainMenu
    Left = 192
    Top = 96
    object Datei1: TMenuItem
      Caption = 'Datei'
      object InitDateierstellen1: TMenuItem
        Caption = 'Init Datei erstellen'
        OnClick = InitDateierstellen1Click
      end
      object Drucker1: TMenuItem
        Caption = 'Drucker'
        OnClick = Drucker1Click
      end
      object Beenden1: TMenuItem
        Caption = 'Beenden'
        OnClick = Beenden1Click
      end
    end
    object Auswertung1: TMenuItem
      Caption = 'Auswertung'
      object KompletteAuswertung1: TMenuItem
        Caption = 'Komplette Auswertung'
        OnClick = KompletteAuswertung1Click
      end
      object EinzelneAuswertung1: TMenuItem
        Caption = 'Einzelne Auswertung'
      end
    end
    object Setup1: TMenuItem
      Caption = 'Setup'
      object Verkaeuferinfoseinstellen1: TMenuItem
        Caption = 'Verk'#228'ufereinstellungen'
        OnClick = Verkaeuferinfoseinstellen1Click
      end
      object LadeVerkuferliste1: TMenuItem
        Caption = 'Lade Verk'#228'uferliste'
        OnClick = LadeVerkuferliste1Click
      end
    end
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 192
    Top = 72
  end
end
