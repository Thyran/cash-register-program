unit TextDrucker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, Printers;

procedure Drucken(sl: TStrings; Titel: string);

implementation

procedure Drucken(sl: TStrings; Titel: string);
var zeile, x, y: integer;
    breite, hoehe, randlinks, randoben: integer;
begin

    Printer.Title := Titel;
    Printer.BeginDoc; //Druckjob beginnen
    SetMapMode(Printer.Canvas.Handle, MM_LOMETRIC); //Umstellen auf 1/10 mm

    //Schrift-Einstellungen:
    Printer.Canvas.Font.Name:='Courier New';
    Printer.Canvas.Brush.Color:=clWhite;
    Printer.Canvas.Font.Height:=40; //4 mm

    //Blattgöße in 1/10 mm ermitteln:
    breite:=GetDeviceCaps(Printer.Canvas.Handle, HORZSIZE)*10;
    hoehe:=GetDeviceCaps(Printer.Canvas.Handle, VERTSIZE)*10;

    randlinks:=200; //2,0 cm
    randoben:=150; //1,5 cm

    x:=randlinks;
    y:=randoben*-1;

    for zeile:=0 to sl.Count-1 do begin

//      if -y>(hoehe-2*randoben) then begin
      if -y>(hoehe-randoben) then begin
        y:=randoben*-1;
        Printer.NewPage;
      end;

      if y=-randoben then begin
        Printer.Canvas.Font.Style:=[fsbold];
        Printer.Canvas.TextOut(x, y, Titel + '  Seite '+
          IntToStr(Printer.PageNumber));
        y:=y-Printer.Canvas.TextHeight(sl[zeile]);
        Printer.Canvas.TextOut(x, y, '   am ' + DateToStr(Date));
        Printer.Canvas.Font.Style:=[];
        y:=y-2*Printer.Canvas.TextHeight(sl[zeile]);
      end;

      Printer.Canvas.TextOut(x, y, sl[zeile]);

      y:=y-Printer.Canvas.TextHeight(sl[zeile]);

    end;
    Printer.EndDoc;
end;

end.
