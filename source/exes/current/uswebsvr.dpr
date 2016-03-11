program uswebsvr;

uses
  Forms,
  sysutils,
  main in '..\..\creator\current\main.pas' {mainfm},
  wiz in '..\..\creator\current\wiz.pas' {wizfm},
  view in '..\..\creator\current\view.pas' {viewfm},
  share in '..\..\creator\current\share.pas',
  ltype in '..\..\creator\current\ltype.pas' {ltypefm},
  fwall in '..\..\creator\current\fwall.pas' {fwallfm},
  ap in '..\..\creator\current\ap.pas',
  recapp in '..\..\creator\current\recapp.pas',
  apfolder in '..\..\creator\current\apfolder.pas',
  apfile in '..\..\creator\current\apfile.pas',
  settings in '..\..\creator\current\settings.pas',
  remserv in '..\..\transmit\current\remserv.pas' {remservfm},
  login in '..\..\receive\current\login.pas' {loginfm},
  fsave in '..\..\creator\current\fsave.pas' {fsavefm},
  GroupSelect in '..\..\creator\current\GroupSelect.pas' {frmGroupSelect},
  demo in '..\..\creator\current\demo.pas' {frmDemo},
  xmSettings in '..\..\creator\current\xmSettings.pas' {frmxmSettings},
  filedlg in '..\..\CREATOR\CURRENT\filedlg.pas' {frmfiledlg},
  about in '..\..\creator\current\about.PAS' {AboutBox},
  splash in '..\..\creator\current\splash.pas' {splashfm};

{$R *.RES}
                                                       
begin
  Application.Initialize;
  Application.Title := 'Upgrade Suite [Server]';
  s:=tsettings.create;
  s.loadsettings;
  CheckDemoEnd;

  Application.CreateForm(Tmainfm, mainfm);
  Application.CreateForm(Tviewfm, viewfm);
  Application.CreateForm(Tfsavefm, fsavefm);
  Application.CreateForm(Tfwallfm, fwallfm);
  Application.CreateForm(Tltypefm, ltypefm);
  Application.CreateForm(Tfrmfiledlg, frmfiledlg);
  Application.CreateForm(Twizfm, wizfm);
  Application.CreateForm(Tremservfm, remservfm);
  Application.CreateForm(Tloginfm, loginfm);
  Application.CreateForm(TfrmGroupSelect, frmGroupSelect);
  Application.CreateForm(TfrmDemo, frmDemo);
  Application.CreateForm(TfrmxmSettings, frmxmSettings);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(Tsplashfm, splashfm);
  Application.Run;
end.
