unit ServerVerkaeuferSetupUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin;

type
  TVendorSetupFrame = class(TFrame)
    GroupBox1: TGroupBox;
    SpinEdit1: TSpinEdit;
    GroupBox2: TGroupBox;
    SpinEdit2: TSpinEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    m_minVerk: Integer;
    m_maxVerk: Integer;

    procedure onMinVerkChange(const value: Integer);
    procedure onMaxVerkChange(const value: Integer);
  public
    property minVerk: Integer write onMinVerkChange;
    property maxVerk: Integer write onMaxVerkChange;
  end;

implementation

uses ServerUnit, KassenUtils;

{$R *.dfm}

procedure TVendorSetupFrame.onMinVerkChange(const value: Integer);
begin
  m_minVerk := value;
  spinedit2.Text := IntToStr(value);
end;

procedure TVendorSetupFrame.onMaxVerkChange(const value: Integer);
begin
  m_maxVerk := value;
  spinedit1.Text := IntToStr(value);
end;

procedure TVendorSetupFrame.Button1Click(Sender: TObject);
var
  info: TVerkaeuferInfo;
begin
  info.anzahlVerkaeufer := StrToInt(Spinedit1.Text);
  info.offsetVerkaeufer := StrToInt(Spinedit2.Text);

  ServerFrame.closeVendorSetupFrame(info);
end;

end.
