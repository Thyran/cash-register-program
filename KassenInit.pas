unit KassenInit;

interface

uses
  Classes, SysUtils;

type
  TKasseInit = class
  private
    initList: TStringlist;
  public
    constructor Create();

    function readFromInit(const name: String): String;

    procedure loadInit(const fileName: String);
    procedure saveInit(const fileName: String);
    procedure writeInInit(const name, value: String);
  end;

var
  init: TKasseInit;

implementation

constructor TKasseInit.Create();
begin
  initList := TStringlist.Create();
end;

function TKasseInit.readFromInit(const name: String): String;
begin
  result := trim(initList.Values[name]);
end;

procedure TKasseInit.loadInit(const fileName: String);
begin
  initList.Clear();
  initList.NameValueSeparator := ':';
  try
    initList.LoadFromFile(fileName);
  except
  end;
end;

procedure TKasseInit.saveInit(const fileName: String);
begin
  initList.SaveToFile(fileName);
  initList.Clear();
end;

procedure TKasseInit.writeInInit(const name, value: String);
var
  i: Integer;
begin
  if (initList.Values[name] = '') then
    initList.Add(name + ': ' + value)
  else
    for i := 0 to initList.Count -1 do
      if copy(initList[i], 1, length(name)) = name then
        initList.Strings[i] := name + ': ' + value;
end;

initialization

begin
  init := TKasseInit.Create();
end;

finalization

begin
  init.Free();
end;

end.
