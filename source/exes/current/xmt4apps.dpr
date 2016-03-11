program xmt4apps;

uses
  Forms,
  windows,
  dialogs,
  fwall in '..\..\creator\current\fwall.pas' {fwallfm},
  apfile in '..\..\creator\current\apfile.pas',
  apfolder in '..\..\creator\current\apfolder.pas',
  settings in '..\..\creator\current\settings.pas',
  ltype in '..\..\creator\current\ltype.pas' {ltypefm},
  login in '..\..\receive\current\login.pas' {loginfm},
  fsave in '..\..\creator\current\fsave.pas' {fsavefm},
  splash in '..\..\Xmt4Apps\current\splash.pas' {splashfm},
  main in '..\..\Xmt4Apps\current\main.pas' {mainfm},
  remserv in '..\..\Xmt4Apps\current\remserv.pas' {remservfm},
  share in '..\..\Cli4Apps\Current\share.pas',
  ap in '..\..\Cli4Apps\Current\ap.pas',
  view in '..\..\Srv4Apps\current\view.pas' {viewfm},
  recapp in '..\..\Srv4Apps\current\recapp.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Updater Deployer';
  s:=tsettings.create;
  s.loadsettings;

  Application.CreateForm(Tmainfm, mainfm);
  Application.CreateForm(Tfsavefm, fsavefm);
  Application.CreateForm(Tfwallfm, fwallfm);
  Application.CreateForm(Tltypefm, ltypefm);
  Application.CreateForm(Tloginfm, loginfm);
  Application.CreateForm(Tsplashfm, splashfm);
  Application.CreateForm(Tremservfm, remservfm);
  Application.CreateForm(Tviewfm, viewfm);
  Application.Run;
end.
