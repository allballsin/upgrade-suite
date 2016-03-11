program cli4apps;

uses
  windows,
  classes,
  controls,
  sysutils,
  dialogs,
  filectrl,
  Forms,
  registry,
  apfile in '..\..\creator\current\apfile.pas',
  apfolder in '..\..\creator\current\apfolder.pas',
  ltype in '..\..\creator\current\ltype.pas' {ltypefm},
  login in '..\..\receive\current\login.pas' {loginfm},
  newdet in '..\..\receive\current\newdet.pas' {newdetfm},
  xmSettings in '..\..\creator\current\xmSettings.pas' {frmxmSettings},
  main in '..\..\Cli4Apps\Current\main.pas' {mainfm},
  settings in '..\..\Cli4Apps\Current\settings.pas',
  fsave in '..\..\Cli4Apps\Current\fsave.pas' {fsavefm},
  fwall in '..\..\Cli4Apps\Current\fwall.pas' {fwallfm},
  remserv in '..\..\Cli4Apps\Current\remserv.pas' {remservfm},
  autoset in '..\..\Cli4Apps\Current\autoset.pas' {autosetfm},
  share in '..\..\Cli4Apps\Current\share.pas',
  ap in '..\..\Cli4Apps\Current\ap.pas',
  view in '..\..\Srv4Apps\current\view.pas' {viewfm},
  recapp in '..\..\Srv4Apps\current\recapp.pas';

var
  reg:tregistry;
  quietreg:boolean;
{$R *.RES}
begin
//quietreg:=false;
Application.Initialize;
Application.Title := 'Updater Installer';
  s:=tsettings.create;
s.loadsettings;
CheckDemoEnd;

Application.CreateForm(Tmainfm, mainfm);
  Application.CreateForm(Tltypefm, ltypefm);
  Application.CreateForm(Tloginfm, loginfm);
  Application.CreateForm(Tnewdetfm, newdetfm);
  Application.CreateForm(TfrmxmSettings, frmxmSettings);
  Application.CreateForm(Tfsavefm, fsavefm);
  Application.CreateForm(Tfwallfm, fwallfm);
  Application.CreateForm(Tremservfm, remservfm);
  Application.CreateForm(Tautosetfm, autosetfm);
  Application.CreateForm(Tviewfm, viewfm);
  Application.Run;
end.
