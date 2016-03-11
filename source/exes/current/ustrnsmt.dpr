program ustrnsmt;

uses
  Forms,
  windows,
  dialogs,
  main in '..\..\transmit\current\main.pas' {mainfm},
  share in '..\..\creator\current\share.pas',
  about in '..\..\transmit\current\about.pas' {AboutBox},
  fwall in '..\..\creator\current\fwall.pas' {fwallfm},
  view in '..\..\creator\current\view.pas' {viewfm},
  ap in '..\..\creator\current\ap.pas',
  apfile in '..\..\creator\current\apfile.pas',
  apfolder in '..\..\creator\current\apfolder.pas',
  settings in '..\..\creator\current\settings.pas',
  recapp in '..\..\creator\current\recapp.pas',
  ltype in '..\..\creator\current\ltype.pas' {ltypefm},
  login in '..\..\receive\current\login.pas' {loginfm},
  fsave in '..\..\creator\current\fsave.pas' {fsavefm},
  remserv in '..\..\transmit\current\remserv.pas' {remservfm},
  splash in '..\..\transmit\current\splash.pas' {splashfm},
  demo in '..\..\creator\current\demo.pas' {frmDemo};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Upgrade Suite [Transmitter]';
  s:=tsettings.create;
  s.loadsettings;

  Application.CreateForm(Tmainfm, mainfm);
  Application.CreateForm(Tviewfm, viewfm);
  Application.CreateForm(Tfsavefm, fsavefm);
  Application.CreateForm(Tfwallfm, fwallfm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(Tltypefm, ltypefm);
  Application.CreateForm(Tloginfm, loginfm);
  Application.CreateForm(Tremservfm, remservfm);
  Application.CreateForm(Tsplashfm, splashfm);
  Application.CreateForm(TfrmDemo, frmDemo);
  Application.Run;
end.
