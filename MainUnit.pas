unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ScktComp, StdCtrls, KassenUtils, Menus, ComCtrls,
  KassePayUnit, BillUnit, randomBillCreator;

type
  TClientMessage = (cmCONNECT = 0, cmDISCONNECT = 1, cmBUY = 2,
                    cmDUMMY_CONNECT = 3, cmKASSENSTAND = 4,
                    cmAUTO_CONNECT_ON = 5, cmAUTO_CONNECT_OFF = 6,
                    cmREGISTER = 7, cmSEND_KUNDEN = 8, cmINC_KASSENSTAND = 9);

  TKasseFrame = class(TForm)
    AutoConnectPanel: TPanel;
    EnabledPanel: TPanel;
    MainMenu1: TMainMenu;
    DateiTab: TMenuItem;
    LadeInit1: TMenuItem;
    Verbindung1: TMenuItem;
    ConnectedPanel: TPanel;
    Informationen1: TMenuItem;
    Verbindung2: TMenuItem;
    Verbinden1: TMenuItem;
    Automatischverbinden1: TMenuItem;
    RichEdit1: TRichEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    GroupBox3: TGroupBox;
    Panel5: TPanel;
    Label1: TLabel;
    Kasse1: TMenuItem;
    Informationen2: TMenuItem;
    Rechnungen1: TMenuItem;
    Kassenstand1: TMenuItem;
    Zusammenfassungerstellen1: TMenuItem;
    est1: TMenuItem;
    StarteTest1: TMenuItem;
    GroupBox4: TGroupBox;
    Panel6: TPanel;
    PrinterSetupDialog1: TPrinterSetupDialog;
    Drucker1: TMenuItem;
    Beenden1: TMenuItem;
    drucken1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure AutoConnectPanelClick(Sender: TObject);
    procedure LadeInit1Click(Sender: TObject);
    procedure Verbindung1Click(Sender: TObject);
    procedure Verbinden1Click(Sender: TObject);
    procedure Automatischverbinden1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure RichEdit1Enter(Sender: TObject);
    procedure RichEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure RichEdit1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Informationen2Click(Sender: TObject);
    procedure Rechnungen1Click(Sender: TObject);
    procedure Kassenstand1Click(Sender: TObject);
    procedure Zusammenfassungerstellen1Click(Sender: TObject);
    procedure StarteTest1Click(Sender: TObject);
    procedure Drucker1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure drucken1Click(Sender: TObject);
  private
    Client: TClientSocket;
    Dummy: TClientSocket;
    Timer: TTimer;
    Kasse: TKasse;
    rechnungenFrame: TBillFrame;
    rbc: TRandomBillCreator;
    verkaeuferInfo: TVerkaeuferInfo;

    clientConnected: boolean;
    clientAutoConnected: boolean;
    clientEnabled: boolean;
    print: boolean;

    serverIP: String;

    function checkNummer(const nummer: String): boolean;
    function checkPreis(const preis: String): boolean;

    procedure setup();
    procedure checkConnection();
    procedure loadData();
    procedure saveData();

    procedure DummyConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DummyRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure DummyError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);

    procedure ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);

    procedure OnTimer(Sender: TObject);
    procedure OnConnectedChange(const connected: boolean);
    procedure OnEnabledChange(const enabled: boolean);
    procedure OnAutoConnectedChange(const autoConnected: boolean);

    property Connected: boolean read clientConnected write OnConnectedChange;
    property Enabled: boolean read clientEnabled write OnEnabledChange;
    property AutoConnected: boolean read clientAutoConnected
                                    write OnAutoConnectedChange;
  public
    payFrame: TKassePayFrame;

    procedure closePayFrame();
    procedure closeBillFrame();
  end;

const
  cMessage: Array[TClientMessage] of Integer = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9);

var
  KasseFrame: TKasseFrame;

implementation

{$R *.dfm}

uses ServerUnit, KassenInit, TextDrucker;

procedure TKasseFrame.setup();
begin
  rbc := TRandomBillCreator.Create();
  Kasse := TKasse.Create(0);

  serverIP := '127.0.0.1';
  verkaeuferInfo.anzahlVerkaeufer := 0;
  verkaeuferInfo.offsetVerkaeufer := 0;
  loadData();

  Dummy := TClientSocket.Create(self);
  Dummy.Host := serverIP;
  Dummy.Port := SERVER_PORT;
  Dummy.OnConnect := DummyConnect;
  Dummy.OnRead := DummyRead;
  Dummy.OnError := DummyError;

  Client := TClientSocket.Create(self);
  Client.Host := serverIP;
  Client.Port := SERVER_PORT;
  Client.OnConnect := ClientConnect;
  Client.OnDisconnect := ClientDisconnect;
  Client.OnRead := ClientRead;
  Client.OnError := ClientError;

  Timer := TTimer.Create(self);
  Timer.Interval := 3000;
  Timer.OnTimer := OnTimer;
  Timer.Enabled := true;

  Label1.Caption := '0';
  Panel6.Caption := IntToStr(Kasse.Kunden);

  KasseFrame.Caption := 'Kasse' + IntToStr(Kasse.Nummer);

  Connected := false;
  AutoConnected := true;
  Enabled := false;
  print := false;

  checkConnection();
end;

procedure TKasseFrame.checkConnection();
begin
  Dummy.Open();
end;

procedure TKasseFrame.loadData();
begin
  try
    init.loadInit(KASSE_DIR + DATA_FILE);
    Kasse.Nummer := StrToInt(init.readFromInit(KASSEN_NUMMER_STR));
    Kasse.Kunden := StrToInt(init.readFromInit(KUNDEN_ANZAHL_STR));
    Kasse.KassenStand := StrToFloat(init.readFromInit(KASSENSTAND_STR));
    serverIP := init.readFromInit(SERVER_IP_STR);
    verkaeuferInfo.anzahlVerkaeufer := StrToInt(init.readFromInit(MAX_VERK_STR));
    verkaeuferInfo.offsetVerkaeufer := StrToInt(init.readFromInit(MIN_VERK_STR));
  except
  end;
end;

procedure TKasseFrame.saveData();
begin
  init.loadInit(KASSE_DIR + DATA_FILE);
  init.writeInInit(KASSEN_NUMMER_STR, IntToStr(Kasse.Nummer));
  init.writeInInit(KUNDEN_ANZAHL_STR, IntToStr(Kasse.Kunden));
  init.writeInInit(KASSENSTAND_STR, FloatToStr(Kasse.KassenStand));
  init.writeInInit(SERVER_IP_STR, serverIP);
  init.writeInInit(MAX_VERK_STR, IntToStr(verkaeuferInfo.anzahlVerkaeufer));
  init.writeInInit(MIN_VERK_STR, IntToStr(verkaeuferInfo.offsetVerkaeufer));
  if not directoryExists(KASSE_DIR_NAME) then
    mkDir(KASSE_DIR_NAME);
  init.saveInit(KASSE_DIR + DATA_FILE);
end;

procedure TKasseFrame.DummyConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Dummy.Socket.SendText(prepareMsgString(cMessage[cmDUMMY_CONNECT]));
end;

procedure TKasseFrame.DummyRead(Sender: TObject; Socket: TCustomWinSocket);
var
  mString: String;
begin
  mString := Dummy.Socket.ReceiveText();
  if not (mString = '') then
  begin
    if (copy(mString, 0, Pos(';', mString) -1) = MESSAGE_ID) then
    begin
      mString := copy(mString, Pos(';', mString) +1, length(mString));
      try
        if StrToInt(copy(mString, 0, MESSAGE_NUMMER_STELLEN)) = sMessage[smCONNECT] then
        begin
          Dummy.Close();
          Client.Open();
          Connected := true;
        end;
      finally
        Dummy.Close();
      end;
    end;
  end;
end;

procedure TKasseFrame.DummyError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Dummy.Close();
  ErrorCode := 0;
end;

procedure TKasseFrame.ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  if (Kasse.Nummer <= 0) then
    Client.Socket.SendText(prepareMsgString(cMessage[cmREGISTER]))
  else
  begin
    Client.Socket.SendText(prepareMsgString(cMessage[cmCONNECT]) +
                           formatNummer(IntToStr(Kasse.Nummer),
                           KASSEN_NUMMER_STELLEN) + ';');
    Timer.Enabled := false;

    sleep(PAUSE_MSEC);

    if clientAutoConnected then
      Client.Socket.SendText(prepareMsgString(cMessage[cmAUTO_CONNECT_ON]) +
                             formatNummer(IntToStr(Kasse.Nummer),
                             KASSEN_NUMMER_STELLEN) + ';')
    else
      Client.Socket.SendText(prepareMsgString(cMessage[cmAUTO_CONNECT_OFF]) +
                             formatNummer(IntToStr(Kasse.Nummer),
                             KASSEN_NUMMER_STELLEN) + ';');

    sleep(PAUSE_MSEC);

    Client.Socket.SendText(prepareMsgString(cMessage[cmSEND_KUNDEN]) +
                           formatNummer(IntToStr(Kasse.Nummer),
                           KASSEN_NUMMER_STELLEN) + ';' +
                           formatNummer(IntToStr(Kasse.Kunden),
                           KUNDEN_NUMMER_STELLEN) + ';');
  end;
end;

procedure TKasseFrame.ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Client.Socket.SendText(prepareMsgString(cMessage[cmDISCONNECT]) +
                         formatNummer(IntToStr(Kasse.Nummer),
                         KASSEN_NUMMER_STELLEN) + ';');
  Timer.Enabled := true;

  Enabled := false;
  Connected := false;
end;

procedure TKasseFrame.ClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  mString: String;
begin
  mString := Client.Socket.ReceiveText();
  if not (mString = '') then
  begin
    if (copy(mString, 0, Pos(';', mString) -1) = MESSAGE_ID) then
    begin
      mString := copy(mString, Pos(';', mString) +1, length(mString));
      case StrToInt(copy(mString, 0, MESSAGE_NUMMER_STELLEN)) of
        0: // ENABLE_CLIENT
        begin
          Enabled := true;
        end;
        1: // DISABLE_CLIENT
        begin
          Enabled := false;
        end;
        2: // CONNECT
        begin
        end;
        3: // DISCONNECT
        begin
          Client.Socket.Close();
        end;
        4: // KASSENSTAND
        begin
        end;
        5: // ENABLE_AUTO_CONNECT
        begin
          AutoConnected := true;
        end;
        6: // DISABLE_AUTO_CONNECT
        begin
          AutoConnected := false;
        end;
        7: // SEND_NUMMER
        begin
          mString := copy(mString, Pos(';', mString) +1, length(mString));
          Kasse.Nummer := StrToInt(copy(mString, 0, KASSEN_NUMMER_STELLEN));
          self.Caption := KASSE_DIR_NAME + IntToStr(kasse.Nummer);
          saveData();
          Client.Close();
          checkConnection();
        end;
        8: // ERROR
        begin
          mString := copy(mString, Pos(';', mString) +1, length(mString) -1);
          ShowMessage(mString);
        end;
        9: // SEND_VENDOR_DATA
        begin
          mString := copy(mString, Pos(';', mString) +1, length(mString));
          verkaeuferInfo.AnzahlVerkaeufer := StrToInt(copy(mString, 1, KUNDEN_NUMMER_STELLEN));
          verkaeuferInfo.OffsetVerkaeufer := StrToInt(copy(mString, Pos('/', mString) + 1, KUNDEN_NUMMER_STELLEN));
          saveData();
        end;
      end;
    end;
  end;
end;

procedure TKasseFrame.ClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TKasseFrame.OnTimer(Sender: TObject);
begin
  if AutoConnected then
    if not Client.Socket.Connected then
      checkConnection();
end;

procedure TKasseFrame.OnConnectedChange(const connected: boolean);
begin
  clientConnected := connected;

  if clientConnected then
  begin
    connectedPanel.Color := clGreen;
    connectedPanel.Caption := 'Verbunden';
    verbinden1.Caption := 'Verbindung lösen';
  end
  else
  begin
    connectedPanel.Color := clRed;
    connectedPanel.Caption := 'Nicht verbunden';
    verbinden1.Caption := 'Verbinden';
  end;
end;

procedure TKasseFrame.OnEnabledChange(const enabled: boolean);
begin
  clientEnabled := enabled;

  if clientEnabled then
  begin
    enabledPanel.Color := clGreen;
    enabledPanel.Caption := 'Aktiviert';
    edit1.Enabled := true;
    edit1.SetFocus();
    edit2.Enabled := true;
    richedit1.Enabled := true;
  end
  else
  begin
    enabledPanel.Color := clRed;
    enabledPanel.Caption := 'Deaktiviert';
    edit1.Enabled := false;
    edit2.Enabled := false;
    richedit1.Enabled := false;
  end;
end;

procedure TKasseFrame.OnAutoConnectedChange(const autoConnected: boolean);
begin
  clientAutoConnected := autoConnected;

  if clientAutoConnected then
  begin
    AutoConnectPanel.Color := clGreen;
    AutomatischVerbinden1.Checked := true;
    if Client.Socket.Connected then
      Client.Socket.SendText(prepareMsgString(cMessage[cmAUTO_CONNECT_ON]) +
                             formatNummer(IntToStr(Kasse.Nummer),
                             KASSEN_NUMMER_STELLEN) + ';');
  end
  else
  begin
    AutoConnectPanel.Color := clRed;
    AutomatischVerbinden1.Checked := false;
    if Client.Socket.Connected then
      Client.Socket.SendText(prepareMsgString(cMessage[cmAUTO_CONNECT_OFF]) +
                             formatNummer(IntToStr(Kasse.Nummer),
                             KASSEN_NUMMER_STELLEN) + ';');
  end;
end;

procedure TKasseFrame.FormShow(Sender: TObject);
begin
  setup();
  if edit1.Enabled then
    edit1.SetFocus()
end;

procedure TKasseFrame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Client.Socket.Close();
  saveData();
end;

procedure TKasseFrame.FormCreate(Sender: TObject);
begin
  randomize();
  setup();
end;

procedure TKasseFrame.AutoConnectPanelClick(Sender: TObject);
begin
  AutoConnected := not AutoConnected;
end;

procedure TKasseFrame.LadeInit1Click(Sender: TObject);
var
  open: TOpendialog;
begin
  open := TOpendialog.Create(self);
  open.InitialDir := ExtractFilePath(ParamStr(0));
  try
    open.Execute;
    init.loadInit(open.FileName);
    serverIP := init.readFromInit(SERVER_IP_STR);
  except
  end;

  Client.Host := serverIP;
  Dummy.Host := serverIP;
  checkConnection();
  open.Free();
end;

procedure TKasseFrame.Verbindung1Click(Sender: TObject);
begin
  ShowMessage(serverIP);
end;

procedure TKasseFrame.Verbinden1Click(Sender: TObject);
begin
  if not clientConnected then
    checkConnection()
  else
    Client.Socket.Close();
end;

procedure TKasseFrame.Automatischverbinden1Click(Sender: TObject);
begin
  AutoConnected := not clientAutoConnected;
end;

procedure TKasseFrame.Edit1Change(Sender: TObject);
begin
  if length(Edit1.Text) > 2 then
    edit2.SetFocus();
end;

procedure TKasseFrame.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(VK_RETURN) then
  begin
    if ((not (Edit1.Text = '')) and (not (Edit2.Text = ''))) then
    begin
      if checkNummer(edit1.Text) and checkPreis(edit2.Text) then
      begin
        Richedit1.Lines.Add(KASSE_LEER_START + edit1.Text + KASSE_LEERSTRICH +
                            formatPreis(edit2.Text, PREIS_PRE_STELLEN) + '€');
        Label1.Caption := formatPreis(FloatToStr(StrToFloat(Label1.Caption) +
                                    StrToFloat(edit2.Text)), PREIS_PRE_STELLEN);
      end
      else if StrToInt(edit1.Text) = 0 then
        try
          Kasse.KassenStand := Kasse.KassenStand + StrToFloat(edit2.Text);
          if Client.Socket.Connected then
            Client.Socket.SendText(prepareMsgString(cMessage[cmINC_KASSENSTAND]) +
              formatNummer(IntToStr(Kasse.Nummer), KASSEN_NUMMER_STELLEN) + ';' + edit2.Text + ';');
        except
        end;

      edit1.SetFocus();
      edit1.Clear();
      edit2.Clear();
      key := chr(0);
    end;
  end;
end;

procedure TKasseFrame.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  rechnung: TRechnung;
begin
  if Key = chr(VK_SPACE) then
  begin
    rechnung := TRechnung.Create(richedit1.Lines);
    if Client.Socket.Connected then
      Client.Socket.SendText(prepareMsgString(cMessage[cmBUY]) +
                            formatNummer(IntToStr(Kasse.Nummer),
                            KASSEN_NUMMER_STELLEN) + ';' +
                            rechnung.createString + ';');
    Kasse.buy(rechnung);

    Panel6.Caption := IntToStr(StrToInt(Panel6.Caption) +1);
    Richedit1.Lines.Add(KASSE_LEER_START + KASSE_TRENNSTRICH);
    Richedit1.Lines.Add(KASSE_LEER_START + 'Ges' + KASSE_LEERSTRICH +
                        formatPreis(Label1.Caption, PREIS_PRE_STELLEN) + '€');

    payFrame := TKassePayFrame.Create(self);
    payFrame.Parent := self;
    payFrame.Left := 21;
    payFrame.Top := 51;
    payFrame.Betrag := StrToFloat(Label1.Caption);
    payFrame.SetFocus();
    payFrame.Show();

    Enabled := false;

    key := chr(0);
  end;
end;

procedure TKasseFrame.RichEdit1Enter(Sender: TObject);
begin
  if edit1.Enabled then
    edit1.SetFocus()
  else
    panel1.SetFocus();
end;

procedure TKasseFrame.RichEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  key := chr(0);
end;

procedure TKasseFrame.RichEdit1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if edit1.Enabled then
    edit1.SetFocus()
  else
    panel1.SetFocus();
end;

procedure TKasseFrame.Informationen2Click(Sender: TObject);
begin
  ShowMessage('Kassennummer: ' + IntToStr(Kasse.Nummer) + sLineBreak +
              'Kundenanzahl: ' + IntToStr(Kasse.Kunden) + sLineBreak +
              'Verkäuferanzahl: ' + IntToStr(verkaeuferInfo.anzahlVerkaeufer) + sLineBreak +
              'Startnummer: ' + IntToStr(verkaeuferInfo.offsetVerkaeufer));
end;

procedure TKasseFrame.closePayFrame();
begin
  if assigned(payFrame) then
  begin
    payFrame.Free();

    if print then
      drucken(richedit1.Lines, 'Kasse' + formatNummer(IntToStr(Kasse.Nummer), KASSEN_NUMMER_STELLEN) +
        formatNummer(IntToStr(Kasse.Kunden), KUNDEN_NUMMER_STELLEN));

    richedit1.Clear();
    Label1.Caption := '0';
  end;
end;

procedure TKasseFrame.Rechnungen1Click(Sender: TObject);
begin
  if not assigned(rechnungenFrame) then
    rechnungenFrame := TBillFrame.Create(self);
  rechnungenFrame.Kasse := Kasse.Nummer;
  rechnungenFrame.Rechnungen := Kasse.Kunden;
  rechnungenFrame.isServer := false;
  rechnungenFrame.Show();
end;

procedure TKasseFrame.closeBillFrame();
begin
  rechnungenFrame.Free();
end;

procedure TKasseFrame.Kassenstand1Click(Sender: TObject);
begin
  ShowMessage(FloatToStr(Kasse.KassenStand) + '€');
end;

procedure TKasseFrame.Zusammenfassungerstellen1Click(Sender: TObject);
begin
  Kasse.createSummary();
end;

procedure TKasseFrame.StarteTest1Click(Sender: TObject);
begin
  if StarteTest1.Tag = 0 then
  begin
    if Connected then
    begin
      rbc.setInfo(verkaeuferInfo);
      rbc.start();
      starteTest1.Tag := 1;
      starteTest1.Caption := 'Stoppe Test';
    end;
  end
  else if StarteTest1.Tag = 1 then
  begin
    rbc.stop();
    starteTest1.Tag := 0;
    starteTest1.Caption := 'Starte Test';
  end;
end;

function TKasseFrame.checkNummer(const nummer: String): boolean;
var
  vendorNummer: Integer;
  help: boolean;
begin
  help := false;
  try
    vendorNummer := StrToInt(nummer);
    if vendorNummer >= verkaeuferInfo.offsetVerkaeufer then
      if (vendorNummer < verkaeuferInfo.anzahlVerkaeufer + verkaeuferInfo.offsetVerkaeufer) then
        help := true;
    if vendorNummer = 0 then
      help := false;
  except
    help := false;
  end;

  result := help;
end;

function TKasseFrame.checkPreis(const preis: String): boolean;
begin
  try
    StrToFloat(preis);
  except
    result := false;
    exit;
  end;

  result := true;
end;

procedure TKasseFrame.Drucker1Click(Sender: TObject);
begin
  PrinterSetupDialog1.Execute();
end;

procedure TKasseFrame.Beenden1Click(Sender: TObject);
begin
  Close();
end;

procedure TKasseFrame.drucken1Click(Sender: TObject);
begin
  print := not print;
  drucken1.Checked := print;
end;

end.
