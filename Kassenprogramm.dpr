program Kassenprogramm;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {KasseFrame},
  KassenUtils in 'KassenUtils.pas',
  KassenInit in 'KassenInit.pas',
  KassePayUnit in 'KassePayUnit.pas' {KassePayFrame: TFrame},
  BillUnit in 'BillUnit.pas' {BillFrame},
  randomBillCreator in 'randomBillCreator.pas',
  TextDrucker in 'TextDrucker.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '';
  Application.CreateForm(TKasseFrame, KasseFrame);
  Application.CreateForm(TBillFrame, BillFrame);
  Application.Run;
end.
