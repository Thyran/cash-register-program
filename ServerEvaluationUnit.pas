unit ServerEvaluationUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls, KassenUtils, Menus;

type
  TEvaluationFrame = class(TForm)
    RichEdit1: TRichEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    SpinEdit1: TSpinEdit;
    Button5: TButton;
    PrinterSetupDialog1: TPrinterSetupDialog;
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    Schlieen1: TMenuItem;
    Drucker1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Drucker1Click(Sender: TObject);
    procedure Schlieen1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    kassen: Integer;
    info: TVerkaeuferInfo;

    function getProvision(const nummer: Integer): Real;
  public
    property AnzKassen: Integer write kassen;
    property VerkaeuferInfo: TVerkaeuferInfo write info;
  end;

var
  EvaluationFrame: TEvaluationFrame;

implementation

uses ServerUnit, TextDrucker;

{$R *.dfm}

function TEvaluationFrame.getProvision(const nummer: Integer): Real;
var
  help: Real;
  vList, tmp: TStringlist;
  i: Integer;
begin
  help := 1;

  try
    vList := TStringlist.Create();
    vList.LoadFromFile(SERVER_DIR + VERK_FILE);

    for i := 0 to vList.Count -1 do
    begin
      tmp := TStringlist.Create();
      split(' ', vList[i], tmp);

      if StrToInt(tmp[0]) = nummer then
        help := StrToFloat(copy(tmp[2], 1, length(tmp[2]) -1)) / 100;

      tmp.Free();
    end;

    vList.Free();
  except
    help := 1;
  end;

  result := help;
end;

procedure TEvaluationFrame.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ServerFrame.closeEvaluationFrame();
end;

procedure TEvaluationFrame.FormActivate(Sender: TObject);
begin
  button1.SetFocus();
end;

procedure TEvaluationFrame.Button1Click(Sender: TObject);
type
  TKArray = Array of Array[0..2] of String;
  TIArray = Array of Integer;

  procedure checkKunden(const kList: TKArray; var indices: TIArray; const offset:  Integer);
  var
    i, j: Integer;
  begin
    for i := 0 to length(kList) -1 do
      if StrToFloat(kList[i][2]) < 0 then
        for j := 0 to i -1 do
          if abs(StrToFloat(kList[j][2])) = abs(StrToFloat(kList[i][2])) then
            if kList[j][0] = kList[i][0] then
              if kList[j][1] = kList[i][1] then
              begin
                setLength(indices, length(indices) +2);
                indices[length(indices) -2] := j + offset;
                indices[length(indices) -1] := i + offset;
              end;
  end;
var
  tmp, all: TStringlist;
  kList: TKArray;
  i, anz: Integer;
  lastKunde: String;
  indeces: TIArray;
begin
  tmp := TStringlist.Create();
  all := TStringlist.Create();

  for i := 1 to kassen do
  begin
    ServerFrame.createSummary(i);
    tmp.LoadFromFile(SERVER_DIR + KASSE_DIR_NAME + IntToStr(i) + FILE_END);
    all.AddStrings(tmp);
  end;

  all.SaveToFile(SERVER_DIR + KASSEN_FILE);
  tmp.Clear();

  setLength(kList, 0);
  setLength(indeces, 0);
  for i := 0 to all.Count -1 do
  begin
    split(';', all.Strings[i], tmp);
    tmp[3] := copy(tmp[3], 1, length(tmp[3]) -1);

    if tmp[0] <> lastKunde then
    begin
      checkKunden(kList, indeces, i - length(kList));
      setLength(kList, 0);
    end;

    setLength(kList, length(kList) +1);
    kList[length(kList) -1][0] := tmp[0];
    kList[length(kList) -1][1] := tmp[1];
    kList[length(kList) -1][2] := tmp[3];

    lastKunde := tmp[0];
  end;
  checkKunden(kList, indeces, all.Count - length(kList));

  for i := 0 to length(indeces) -1 do
    all.Strings[indeces[i]] := '';

  anz := 0;
  while anz < all.Count do
  begin
    if StrToFloat(copy(all.Strings[anz], 13, length(all.Strings[anz]) -13)) < 0 then
      richedit1.Lines.Add(all.Strings[0]);
    if all.Strings[anz] = '' then
    begin
      all.Delete(anz);
      dec(anz);
    end;
    inc(anz);
  end;

  if richedit1.Lines.Count = 0 then
  begin
    all.saveToFile(SERVER_DIR + EVAL_FILE);
    button2.Visible := true;
    button4.Visible := true;
    button5.Visible := true;
    spinedit1.Visible := true;
  end;

  all.Free();
  tmp.Free();
end;

procedure TEvaluationFrame.Button3Click(Sender: TObject);
begin
  self.Hide();
end;

procedure TEvaluationFrame.Button2Click(Sender: TObject);
  procedure createBeleg(const nummer: Integer; list: TStringlist);
  var
    i: Integer;
    tmp: TStringlist;
    total: Real;
  begin
    tmp := TStringlist.Create();
    total := 0;

    for i := 0 to list.Count -1 do
      total := total + StrToFloat(list[i]);

    tmp.Add('');
    tmp.Add('Verk�ufer: ' + IntToStr(nummer));
    tmp.Add('');
    tmp.Add('+--------+       Auszahlung ergibt sich');
    tmp.Add('|' + formatPreis(FloatToStr(total * (1 - getProvision(nummer))), PREIS_PRE_STELLEN) + '�|       aus ' +
      formatPreis(FloatToStr(total), PREIS_PRE_STELLEN) + '�' + ' Umsatz');
    tmp.Add('+--------+       abz�glich ' + FloatToStr(100 * getProvision(nummer)) + '%' + ' Provision');
    tmp.Add('');
    tmp.Add('Einzelpositionen:');
    for i := 1 to (list.Count div 3) do
      tmp.Add('   ' + list[3 * i -3] + '     ' + list[3 * i -2] + '     ' + list[3 * i -1] + '   ');
    if (list.Count mod 3) = 1 then
      tmp.Add('   ' + list[list.Count -1] + '   ')
    else if (list.Count mod 3) = 2 then
      tmp.Add('   ' + list[list.Count -2] + '     ' + list[list.Count -1] + '   ');
    tmp.Add('Auszahlung: ' + formatPreis(FloatToStr(total * (1 - getProvision(nummer))), PREIS_PRE_STELLEN) + '�');

    tmp.SaveToFile(SERVER_DIR + BELEGE_DIR + formatNummer(IntToStr(nummer), KUNDEN_NUMMER_STELLEN) + FILE_END);
    tmp.Free();
  end;
var
  i: Integer;
  all, tmp: TStringlist;
  kunden: Array of TStringlist;
begin
  tmp := TStringlist.Create();
  all := TStringlist.Create();
  all.LoadFromFile(SERVER_DIR + EVAL_FILE);

  setLength(kunden, info.anzahlVerkaeufer);
  for i := 0 to length(kunden) -1 do
    kunden[i] := TStringlist.Create();

  for i := 0 to all.Count -1 do
  begin
    split(';', all.Strings[i], tmp);
    tmp[3] := copy(tmp[3], 1, length(tmp[3]) -1);

    kunden[StrToInt(tmp[1]) - info.offsetVerkaeufer].Add(tmp[3]);
  end;

  if not directoryExists(SERVER_DIR + VERK_DIR_NAME) then
    mkDir(SERVER_DIR + VERK_DIR_NAME);
  if not directoryExists(SERVER_DIR + BELEGE_DIR_NAME) then
    mkDir(SERVER_DIR + BELEGE_DIR_NAME);

  for i := 0 to length(kunden) -1 do
  begin
    kunden[i].SaveToFile(SERVER_DIR + VERK_DIR + formatNummer(IntToStr(i + info.offsetVerkaeufer), KUNDEN_NUMMER_STELLEN) + FILE_END);
    createBeleg(i + info.offsetVerkaeufer, kunden[i]);
    kunden[i].Free();
  end;

  all.Free();
  tmp.Free();
end;

procedure TEvaluationFrame.Button5Click(Sender: TObject);
var
  i: Integer;
  tmp: TStringlist;
begin
  tmp := TStringlist.Create();

  for i := info.offsetVerkaeufer to info.anzahlVerkaeufer + info.offsetVerkaeufer -1 do
  begin
    try
      tmp.LoadFromFile(SERVER_DIR + BELEGE_DIR + formatNummer(IntToStr(i), KUNDEN_NUMMER_STELLEN) + FILE_END);
      drucken(tmp, 'Beleg' + formatNummer(IntToStr(i), KUNDEN_NUMMER_STELLEN));
    except
    end;
  end;
end;

procedure TEvaluationFrame.Drucker1Click(Sender: TObject);
begin
  PrinterSetupDialog1.Execute();
end;

procedure TEvaluationFrame.Schlieen1Click(Sender: TObject);
begin
  self.Hide();
end;

procedure TEvaluationFrame.Button4Click(Sender: TObject);
var
  tmp: TStringlist;
begin
  tmp := TStringlist.Create();
  if (StrToInt(Spinedit1.Text) >= info.offsetVerkaeufer) and (StrToInt(Spinedit1.Text) <= (info.offsetVerkaeufer + info.anzahlVerkaeufer)) then
    try
      tmp.LoadFromFile(SERVER_DIR + BELEGE_DIR + formatNummer(Spinedit1.Text, KUNDEN_NUMMER_STELLEN) + FILE_END);
      drucken(tmp, 'Beleg' + formatNummer(Spinedit1.Text, KUNDEN_NUMMER_STELLEN));
    except
    end;
  tmp.Free();
end;

end.
