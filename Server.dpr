program Server;

uses
  Forms,
  ServerUnit in 'ServerUnit.pas' {ServerFrame},
  KassenControlFrameUnit in 'KassenControlFrameUnit.pas' {KasseControl: TFrame},
  KassenUtils in 'KassenUtils.pas',
  KassenInit in 'KassenInit.pas',
  ServerConfirmationDialogUnit in 'ServerConfirmationDialogUnit.pas' {ConfirmationDialog},
  BillUnit in 'BillUnit.pas' {BillFrame},
  ServerEvaluationUnit in 'ServerEvaluationUnit.pas' {EvaluationFrame},
  ServerVerkaeuferSetupUnit in 'ServerVerkaeuferSetupUnit.pas' {VendorSetupFrame: TFrame},
  TextDrucker in 'TextDrucker.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Server';
  Application.CreateForm(TServerFrame, ServerFrame);
  Application.CreateForm(TConfirmationDialog, ConfirmationDialog);
  Application.CreateForm(TBillFrame, BillFrame);
  Application.CreateForm(TEvaluationFrame, EvaluationFrame);
  Application.Run;
end.
