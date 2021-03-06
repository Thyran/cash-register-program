unit ServerConfirmationDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TConfirmationDialog = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    kassenNummer: Integer;
  public
    procedure setNummer(const nummer: Integer);
    procedure setText(const text: String);
  end;

var
  ConfirmationDialog: TConfirmationDialog;

implementation

uses ServerUnit;

{$R *.dfm}

procedure TConfirmationDialog.setNummer(const nummer: Integer);
begin
  kassenNummer := nummer;
end;

procedure TConfirmationDialog.setText(const text: String);
begin
  Label1.Caption := text;
end;

procedure TConfirmationDialog.Button1Click(Sender: TObject);
begin
  ServerFrame.ErrorDialogClose(true, kassenNummer);
  free();
end;

procedure TConfirmationDialog.Button2Click(Sender: TObject);
begin
  ServerFrame.ErrorDialogClose(false, kassenNummer);
  free();
end;

end.
