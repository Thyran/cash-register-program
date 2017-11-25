unit randomBillCreator;

interface

uses
  ExtCtrls, Classes, SysUtils, KassenUtils, Windows;

type
  TRandomBillCreator = class
  private
    timer: TTimer;
    info: TVerkaeuferInfo;

    procedure createRandomBill(Sender: TObject);
  public
    constructor Create();

    procedure setInfo(const info: TVerkaeuferInfo);
    procedure start();
    procedure stop();
  end;

implementation

uses MainUnit, KassePayUnit;

constructor TRandomBillCreator.Create();
begin
  timer := TTimer.Create(nil);

  timer.OnTimer := createRandomBill;
  timer.Interval := 2000;
  timer.Enabled := false;
end;

procedure TRandomBillCreator.setInfo(const info: TVerkaeuferInfo);
begin
  self.info := info;
end;

procedure TRandomBillCreator.createRandomBill(Sender: TObject);
var
  key: char;
  i: Integer;
begin
  for i := 1 to random(RBC_MAX_KUNDEN) do
  begin
    key := chr(VK_RETURN);
    KasseFrame.Edit1.Text := IntToStr(random(info.anzahlVerkaeufer) + info.offsetVerkaeufer);
    KasseFrame.Edit2.Text := IntToStr(random(RBC_MAX_PREIS)) + ',' + IntToStr(random(100));
    KasseFrame.Edit2KeyPress(nil, key);
  end;
  key := chr(VK_SPACE);
  KasseFrame.Edit1KeyPress(nil, key);
  sleep(5);
  key := chr(VK_SPACE);
  KasseFrame.payFrame.Edit2KeyPress(nil, key);
end;

procedure TRandomBillCreator.start();
begin
  timer.Enabled := true;
end;

procedure TRandomBillCreator.stop();
begin
  timer.Enabled := false;
end;

end.
