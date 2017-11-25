unit PrinterControl;

interface

uses
  Classes, SysUtils, WinSpool;

type
  TJobs  = array [0..1000] of JOB_INFO_1;
  PJobs = ^TJobs;

function listPrinterJobs(): TStrings;
function getFirstJobStatus(): JOB_INFO_1;
function SavePChar(p: PChar): PChar;

implementation

uses Printers;

function GetCurrentPrinterHandle: THandle;
var
  Device, Driver, Port: array[0..255] of Char;
  hDeviceMode: THandle;
begin
  Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
  if not OpenPrinter(@Device, Result, nil) then
    RaiseLastWin32Error;
end;

function SavePChar(p: PChar): PChar;
const
  error: PChar = 'Nil';
begin
  if not Assigned(p) then
    Result := error
  else
    Result := p;
end;

function listPrinterJobs(): TStrings;
var
  hPrinter: THandle;
  bytesNeeded, numJobs, i: Cardinal;
  pJ: PJobs;
  help: TStrings;
begin
  help := TStrings.Create();
  hPrinter := GetCurrentPrinterHandle;
  try
    EnumJobs(hPrinter, 0, 1000, 1, nil, 0, bytesNeeded,
      numJobs);
    pJ := AllocMem(bytesNeeded);
    if not EnumJobs(hPrinter, 0, 1000, 1, pJ, bytesNeeded,
      bytesNeeded, numJobs) then
      RaiseLastWin32Error;
    if numJobs = 0 then
      help.Add('No jobs in queue')
    else
      for i := 0 to Pred(numJobs) do
        help.Add(Format('Printer %s, Job %s, Status (%d): %s',
          [SavePChar(pJ^[i].pPrinterName), SavePChar(pJ^[i].pDocument),
          pJ^[i].Status, SavePChar(pJ^[i].pStatus)]));
  finally
    ClosePrinter(hPrinter);
  end;
  result := help;
  help.Free();
end;

function getFirstJobStatus(): JOB_INFO_1;
var
  hPrinter: THandle;
  bytesNeeded, numJobs: Cardinal;
  pJ: PJobs;
begin
  hPrinter := GetCurrentPrinterHandle;
  try
    EnumJobs(hPrinter, 0, 1000, 1, nil, 0, bytesNeeded,
      numJobs);
    pJ := AllocMem(bytesNeeded);
    if not EnumJobs(hPrinter, 0, 1000, 1, pJ, bytesNeeded,
      bytesNeeded, numJobs) then
      RaiseLastWin32Error;
  finally
    ClosePrinter(hPrinter);
  end;
  result := pJ^[0];
end;

end.
