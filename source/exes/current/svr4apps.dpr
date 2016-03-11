program svr4apps;

uses
  Forms,
  sysutils,
  ltype in '..\..\creator\current\ltype.pas' {ltypefm},
  fwall in '..\..\creator\current\fwall.pas' {fwallfm},
  apfolder in '..\..\creator\current\apfolder.pas',
  apfile in '..\..\creator\current\apfile.pas',
  settings in '..\..\creator\current\settings.pas',
  login in '..\..\receive\current\login.pas' {loginfm},
  xmSettings in '..\..\creator\current\xmSettings.pas' {frmxmSettings},
  splash in '..\..\Srv4Apps\current\splash.pas' {splashfm},
  main in '..\..\Srv4Apps\current\main.pas' {mainfm},
  about in '..\..\Srv4Apps\current\about.PAS' {AboutBox},
  wiz in '..\..\Srv4Apps\current\wiz.pas' {wizfm},
  view in '..\..\Srv4Apps\current\view.pas' {viewfm},
  share in '..\..\Cli4Apps\Current\share.pas',
  ap in '..\..\Cli4Apps\Current\ap.pas',
  recapp in '..\..\Srv4Apps\current\recapp.pas',
  remserv in '..\..\Cli4Apps\Current\remserv.pas' {remservfm},
  fsave in '..\..\CREATOR\CURRENT\fsave.pas' {fsavefm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Updater Creator';
  s:=tsettings.create;
  s.loadsettings;
  CheckDemoEnd;

  Application.CreateForm(Tmainfm, mainfm);
  Application.CreateForm(Tfwallfm, fwallfm);
  Application.CreateForm(Tltypefm, ltypefm);
  Application.CreateForm(Tloginfm, loginfm);
  Application.CreateForm(TfrmxmSettings, frmxmSettings);
  Application.CreateForm(Tsplashfm, splashfm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(Twizfm, wizfm);
  Application.CreateForm(Tviewfm, viewfm);
  Application.CreateForm(Tremservfm, remservfm);
  Application.CreateForm(Tfsavefm, fsavefm);
  Application.Run;
end.
