unit KassenControlFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, ScktComp, KassenUtils,
  ServerConfirmationDialogUnit, BillUnit;

type
  TClientStatus = (csCONNECTED, csENABLED, csAUTO_CONNECT, csERROR);
  TStatusControl = set of TClientStatus;

  TKasseControl = class(TFrame)
    Container: TPanel;
    KassePanel: TPanel;
    KassenstandButton: TButton;
    BillButton: TButton;
    AutoConnectButton: TPanel;
    KundenPanel: TPanel;
    ErrorPanel: TPanel;
    EnableButton: TPanel;
    procedure KassePanelClick(Sender: TObject);
    procedure AutoConnectButtonClick(Sender: TObject);
    procedure EnableButtonClick(Sender: TObject);
    procedure ErrorPanelClick(Sender: TObject);
    procedure BillButtonClick(Sender: TObject);
    procedure KassenstandButtonClick(Sender: TObject);
  private
    kassenSocket: TCustomWinSocket;
    kassenNummer: Integer;
    StatusControl: TStatusControl;
    kassenObject: TKasse;
    errorDialog: TConfirmationDialog;
    rechnungenFrame: TBillFrame;

    lastError: String;

    procedure OnNummerChange(const nummer: Integer);
    procedure OnControlChange(const SControl: TStatusControl);
  public
    constructor Create(AOwner: TComponent); override;

    procedure errorMessage(const msg: String);
    procedure removeError();
    procedure load();
    procedure save();
    procedure focusErrorDialog();
    procedure openBillFrame();
    procedure closeBillFrame();

    function checkErrorDialogOpen(): boolean;

    property Kasse: TKasse read kassenObject write kassenObject;
    property Socket: TCustomWinSocket read KassenSocket write KassenSocket;
    property Nummer: Integer read kassenNummer write OnNummerChange;
    property Control: TStatusControl read StatusControl write OnControlChange;
  end;

implementation

{$R *.dfm}

uses ServerUnit, KassenInit;

constructor TKasseControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  kassenNummer := 0;
  lastError := '';
  StatusControl := [];
  kassenSocket := TCustomWinSocket.Create(0);
  kassenObject := TKasse.Create(kassenNummer);

  OnNummerChange(kassenNummer);
  OnControlChange(StatusControl);

  ServerFrame.Log.Lines.Add('Neues KassenControl erstellt');
end;

function TKasseControl.checkErrorDialogOpen(): boolean;
begin
  result := assigned(errorDialog);
end;

procedure TKasseControl.errorMessage(const msg: String);
begin
  Control := StatusControl + [csERROR];
  lastError := msg;
  Socket.SendText(prepareMsgString(sMessage[smDISABLE_CLIENT]));
  Control := StatusControl - [csENABLED];
  sleep(PAUSE_MSEC);
  Socket.SendText(prepareMsgString(sMessage[smERROR]) + msg + ';');
end;

procedure TKasseControl.removeError();
begin
  Control := StatusControl - [csERROR];
  lastError := '';
  Socket.SendText(prepareMsgString(sMessage[smENABLE_CLIENT]));
  Control := StatusControl + [csENABLED];
end;

procedure TKasseControl.load();
begin
  try
    init.loadInit(SERVER_DIR + KASSE_DIR_NAME + IntToStr(KassenObject.Nummer) + '/' + DATA_FILE);
    KassenObject.KassenStand := StrToFloat(init.readFromInit(KASSENSTAND_STR));
  except
  end;
end;

procedure TKasseControl.save();
begin
  KundenPanel.Caption := IntToSTr(KassenObject.Kunden);
  init.writeInInit(KASSEN_NUMMER_STR, IntToStr(KassenObject.Nummer));
  init.writeInInit(KUNDEN_ANZAHL_STR, IntToStr(KassenObject.Kunden));
  init.writeInInit(KASSENSTAND_STR, FloatToStr(KassenObject.KassenStand));

  if not directoryExists(SERVER_DIR_NAME) then
      mkDir(SERVER_DIR_NAME);
    if not directoryExists(SERVER_DIR + KASSE_DIR_NAME + IntToStr(KassenObject.Nummer)) then
      mkDir(SERVER_DIR + KASSE_DIR_NAME + IntToStr(KassenObject.Nummer));

  init.saveInit(SERVER_DIR + KASSE_DIR_NAME + IntToStr(KassenObject.Nummer) + '/' + DATA_FILE);
end;

procedure TKasseControl.OnNummerChange(const nummer: Integer);
begin
  kassenNummer := nummer;
  KassePanel.Caption := 'Kasse' + IntToStr(kassenNummer);
  kassenObject.Nummer := nummer;

  try
    init.loadInit(SERVER_DIR + KASSE_DIR_NAME + IntToStr(nummer) + '/' + DATA_FILE);
    kassenObject.Kunden := StrToInt(init.readFromInit(KUNDEN_ANZAHL_STR));
  except
    kassenObject.Kunden := 0;
  end;

  KundenPanel.Caption := IntToStr(KassenObject.Kunden);
end;

procedure TKasseControl.OnControlChange(const SControl: TStatusControl);
begin
  StatusControl := SControl;
  KundenPanel.Caption := IntToStr(KassenObject.Kunden);

  if csCONNECTED in StatusControl then
  begin
    KassePanel.Color := clGreen;
    EnableButton.Enabled := true;
    KassenstandButton.Enabled := true;
    AutoConnectButton.Enabled := true;
    BillButton.Enabled := true;
  end
  else
  begin
    KassePanel.Color := clRed;
    EnableButton.Enabled := false;
    KassenstandButton.Enabled := false;
    AutoConnectButton.Enabled := false;
    BillButton.Enabled := false;
  end;

  if csENABLED in StatusControl then
  begin
    EnableButton.Caption := 'Deaktivieren';
    EnableButton.Color := clGreen;
  end
  else
  begin
    EnableButton.Caption := 'Aktivieren';
    EnableButton.Color := clRed;
  end;

  if csAUTO_CONNECT in StatusControl then
    AutoConnectButton.Color := clGreen
  else
    AutoConnectButton.Color := clRed;

  if csERROR in StatusControl then
    ErrorPanel.Color := clRed
  else
    ErrorPanel.Color := clGreen;
end;

procedure TKasseControl.KassePanelClick(Sender: TObject);
begin
  if csCONNECTED in Control then
    kassenSocket.SendText(prepareMsgString(sMessage[smDISCONNECT]));
  ServerFrame.Log.Lines.Add('Trennmeldung an Kasse' + IntToStr(Kasse.Nummer) + ' gesendet');
end;

procedure TKasseControl.AutoConnectButtonClick(Sender: TObject);
begin
  if (csAUTO_CONNECT in StatusControl) and (csCONNECTED in StatusControl) then
  begin
    Socket.SendText(prepareMsgString(sMessage[smDISABLE_AUTO_CONNECT]));
    Control := StatusControl - [csAUTO_CONNECT];
  end
  else if not (csAUTO_CONNECT in StatusControl) then
  begin
    Socket.SendText(prepareMsgString(sMessage[smENABLE_AUTO_CONNECT]));
    Control := StatusControl + [csAUTO_CONNECT];
  end;
  ServerFrame.Log.Lines.Add('AutoConnectänderung and Kasse' + IntToStr(Kasse.Nummer) + ' gesendet');
end;

procedure TKasseControl.EnableButtonClick(Sender: TObject);
begin
  if csENABLED in StatusControl then
  begin
    Socket.SendText(prepareMsgString(sMessage[smDISABLE_CLIENT]));
    Control := StatusControl - [csENABLED];
  end
  else
  begin
    Socket.SendText(prepareMsgString(sMessage[smENABLE_CLIENT]));
    Control := StatusControl + [csEnabled];
  end;
  ServerFrame.Log.Lines.Add('Enableänderung an Kasse' + IntToStr(Kasse.Nummer) + ' gesendet');
end;

procedure TKasseControl.ErrorPanelClick(Sender: TObject);
begin
  if csERROR in StatusControl then
  begin
    if not assigned(errorDialog) then
      errorDialog := TConfirmationDialog.Create(self);
    errorDialog.setText('Fehler behoben?');
    errorDialog.setNummer(kassenNummer);
    errorDialog.Show();
  end;
end;

procedure TKasseControl.focusErrorDialog();
begin
  errorDialog.SetFocus();
end;

procedure TKasseControl.openBillFrame();
begin
  if not assigned(rechnungenFrame) then
    rechnungenFrame := TBillFrame.Create(self);
  rechnungenFrame.Kasse := Kasse.Nummer;
  rechnungenFrame.Rechnungen := Kasse.Kunden;
  rechnungenFrame.isServer := true;
  rechnungenFrame.Show();
end;

procedure TKasseControl.closeBillFrame();
begin
  rechnungenFrame.Free();
end;

procedure TKasseControl.BillButtonClick(Sender: TObject);
begin
  openBillFrame();
end;

procedure TKasseControl.KassenstandButtonClick(Sender: TObject);
begin
  ShowMessage(FloatToStr(Kasse.KassenStand) + '€');
end;

end.
