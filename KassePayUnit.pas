unit KassePayUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls;

type
  TKassePayFrame = class(TFrame)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    Edit2: TEdit;
    Panel2: TPanel;
    Label1: TLabel;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Panel3: TPanel;
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure FrameEnter(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
  private
    m_betrag: Real;

    procedure OnBetragChange(const betrag: Real);
  public
    property Betrag: Real write OnBetragChange;
  end;

implementation

uses MainUnit, KassenUtils;

{$R *.dfm}

procedure TKassePayFrame.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(VK_SPACE) then
  begin
    key := chr(0);
    kasseFrame.closePayFrame();
  end;
end;

procedure TKassePayFrame.OnBetragChange(const betrag: Real);
begin
  m_betrag := betrag;

  Label1.Caption := formatPreis(FloatToStr(betrag), PREIS_PRE_STELLEN);
end;

procedure TKassePayFrame.FrameEnter(Sender: TObject);
begin
  edit2.SetFocus();
end;

procedure TKassePayFrame.Edit2Change(Sender: TObject);
begin
  Label2.Caption := formatPreis(FloatToStr(StrToFloat(edit2.Text) - StrToFloat(Label1.Caption)), PREIS_PRE_STELLEN);
end;

end.
