program usclient;

uses
  windows,
  classes,
  controls,
  sysutils,
  dialogs,
  filectrl,
  Forms,
  registry,
  main in '..\..\receive\current\main.pas' {mainfm},
  share in '..\..\creator\current\share.pas',
  fsave in '..\..\creator\current\fsave.pas' {fsavefm},
  splash in '..\..\receive\current\splash.pas' {splashfm},
  about in '..\..\receive\current\about.pas' {AboutBox},
  fwall in '..\..\creator\current\fwall.pas' {fwallfm},
  view in '..\..\creator\current\view.pas' {viewfm},
  ap in '..\..\creator\current\ap.pas',
  apfile in '..\..\creator\current\apfile.pas',
  apfolder in '..\..\creator\current\apfolder.pas',
  recapp in '..\..\creator\current\recapp.pas',
  settings in '..\..\creator\current\settings.pas',
  remserv in '..\..\transmit\current\remserv.pas' {remservfm},
  ltype in '..\..\creator\current\ltype.pas' {ltypefm},
  login in '..\..\receive\current\login.pas' {loginfm},
  newdet in '..\..\receive\current\newdet.pas' {newdetfm},
  demo in '..\..\creator\current\demo.pas' {frmDemo},
  autoset in '..\..\receive\current\autoset.pas' {autosetfm},
  xmSettings in '..\..\creator\current\xmSettings.pas' {frmxmSettings};

var
  reg:tregistry;
  quietreg:boolean;
{$R *.RES}
begin
quietreg:=false;
Application.Initialize;
Application.Title := 'Upgrade Suite [Client]';
s:=tsettings.create;
s.loadsettings;
CheckDemoEnd;

if findwindow('tmainfm',clientcaption)<>0 then
  begin
  { keep this }
  if paramstr(1)<>'' then
    begin
    if fileexists(paramstr(1)) then
      begin
      if acceptfile(paramstr(1),true) then
        createupdatefile(globalids);
      end;
    end;
	halt;
  end;

  { Quiet registration by installer }
  if paramcount>0 then
    begin
    if paramstr(1)='registerinstall' then
      begin
      quietreg:=true;
      s.runsilent:=true;
      end;
    end;

  Application.CreateForm(Tmainfm, mainfm);
  Application.CreateForm(Tviewfm, viewfm);
  Application.CreateForm(Tfsavefm, fsavefm);
  Application.CreateForm(Tfwallfm, fwallfm);
  Application.CreateForm(Tremservfm, remservfm);
  Application.CreateForm(Tltypefm, ltypefm);
  Application.CreateForm(Tloginfm, loginfm);
  Application.CreateForm(Tnewdetfm, newdetfm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TfrmDemo, frmDemo);
  Application.CreateForm(Tsplashfm, splashfm);
  Application.CreateForm(Tautosetfm, autosetfm);
  Application.CreateForm(TfrmxmSettings, frmxmSettings);

  application.onhint:=mainfm.showhint;
  if not quietreg then
    autosetfm.setthingsgoing;
//  application.OnMinimize:=mainfm.hideTask;
//  application.OnRestore:=mainfm.hideTask;
  if s.runsilent then
    begin
    if quietreg then
      begin
      application.terminate;
      exit;
      end;
    //ShowWindow( Application.handle, SW_HIDE );
    //Application.ShowMainForm:=false;
    mainfm.formshowaction;
    mainfm.formActivateAction;
    end
  else
    begin
    { This is where the splash and everything should really be }
    //ShowWindow( Application.handle, SW_HIDE );
    splashfm.showmodal;
    splashfm.release;
    end;
  Application.Run;
end.
