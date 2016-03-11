program usdstmgr;

uses
  Forms,
  main in '..\..\distmgr\current\main.pas' {mainfm},
  about in '..\..\distmgr\current\about.pas' {AboutBox},
  splash in '..\..\distmgr\current\splash.pas' {splashfm},
  share in '..\..\creator\current\share.pas',
  settings in '..\..\creator\current\settings.pas',
  ap in '..\..\creator\current\ap.pas',
  apfile in '..\..\creator\current\apfile.pas',
  apfolder in '..\..\creator\current\apfolder.pas',
  fsave in '..\..\creator\current\fsave.pas' {fsavefm},
  recapp in '..\..\creator\current\recapp.pas',
  remserv in '..\..\transmit\current\remserv.pas' {remservfm},
  view in '..\..\creator\current\view.pas' {viewfm},
  login in '..\..\receive\current\login.pas' {loginfm},
  ltype in '..\..\creator\current\ltype.pas' {ltypefm},
  editDT in '..\..\distmgr\current\editDT.pas' {frmEditDT},
  newDT in '..\..\distmgr\current\newDT.pas' {frmNewDT},
  demo in '..\..\creator\current\demo.pas' {frmDemo},
  fwall in '..\..\creator\current\fwall.pas' {fwallfm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Upgrade Suite [Distribution Manager]';
  s:=tsettings.create;
  s.loadsettings;
  CheckDemoend;

  Application.CreateForm(Tmainfm, mainfm);
  Application.CreateForm(Tviewfm, viewfm);
  Application.CreateForm(Tfsavefm, fsavefm);
  Application.CreateForm(Tloginfm, loginfm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TfrmEditDT, frmEditDT);
  Application.CreateForm(TfrmNewDT, frmNewDT);
  Application.CreateForm(Tsplashfm, splashfm);
  Application.CreateForm(Tremservfm, remservfm);
  Application.CreateForm(Tltypefm, ltypefm);
  Application.CreateForm(TfrmDemo, frmDemo);
  Application.CreateForm(Tfwallfm, fwallfm);
  Application.Run;
end.
