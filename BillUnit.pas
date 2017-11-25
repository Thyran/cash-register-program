unit BillUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TBillFrame = class(TForm)
    RichEdit1: TRichEdit;
    ScrollBar1: TScrollBar;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    bills: Integer;
    m_kasse: Integer;
    m_server: boolean;

    procedure OnBillsChange(const bill: Integer);
    procedure OnKasseChange(const kasse: Integer);
  public
    property Rechnungen: Integer read bills write OnBillsChange;
    property Kasse: Integer read m_kasse write OnKasseChange;
    property isServer: boolean read m_server write m_server;
  end;

var
  BillFrame: TBillFrame;

implementation

uses ServerUnit, MainUnit, KassenUtils, TextDrucker;

{$R *.dfm}

procedure TBillFrame.OnBillsChange(const bill: Integer);
begin
  bills := bill;
  try
    Scrollbar1.Max := bill -1;
  except
    Scrollbar1.Max := 0;
  end;

  Panel1.Caption := 'Rechnung ' + IntToStr(ScrollBar1.Position);
end;

procedure TBillFrame.OnKasseChange(const Kasse: Integer);
begin
  m_kasse := kasse;
  Panel2.Caption := IntToStr(kasse);
end;

procedure TBillFrame.Button1Click(Sender: TObject);
begin
  close();
end;

procedure TBillFrame.FormShow(Sender: TObject);
begin
  try
    if m_server then
    begin
      richedit1.Lines.LoadFromFile(SERVER_DIR + KASSE_DIR_NAME + IntToStr(m_kasse) + '/' + BILLS_DIR +
                                   formatNummer(IntToStr(Scrollbar1.Position +1), KUNDEN_NUMMER_STELLEN) + FILE_END);
      Panel1.Caption := 'Rechnung ' + IntToStr(Scrollbar1.Position +1);
    end
    else
    begin
      richedit1.Lines.LoadFromFile(KASSE_DIR + BILLS_DIR + formatNummer(IntToStr(Scrollbar1.Position +1), KUNDEN_NUMMER_STELLEN) + FILE_END);
      Panel1.Caption := 'Rechnung ' + IntToStr(Scrollbar1.Position +1);
    end;
  except
  end;
end;

procedure TBillFrame.ScrollBar1Change(Sender: TObject);
begin
  try
    if m_server then
    begin
      richedit1.Lines.LoadFromFile(SERVER_DIR + KASSE_DIR_NAME + IntToStr(m_kasse) + '/' + BILLS_DIR +
                                   formatNummer(IntToStr(Scrollbar1.Position +1), KUNDEN_NUMMER_STELLEN) + FILE_END);
      Panel1.Caption := 'Rechnung ' + IntToStr(Scrollbar1.Position +1);
    end
    else
    begin
      richedit1.Lines.LoadFromFile(KASSE_DIR + BILLS_DIR + formatNummer(IntToStr(Scrollbar1.Position +1), KUNDEN_NUMMER_STELLEN) + FILE_END);
      Panel1.Caption := 'Rechnung ' + IntToStr(Scrollbar1.Position +1);
    end;
  except
  end;
end;

procedure TBillFrame.Button2Click(Sender: TObject);
begin
  if not (scrollbar1.Max = 0) then
    drucken(richedit1.Lines, 'Kasse' + formatNummer(IntToStr(m_kasse), KASSEN_NUMMER_STELLEN) +
      formatNummer(IntToStr(Scrollbar1.Position +1), KUNDEN_NUMMER_STELLEN));
end;

end.
