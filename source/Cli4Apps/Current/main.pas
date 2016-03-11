unit main;

interface

uses

  windows, ShellLnk, inifiles,
  Menus, Dialogs,  pmupgrade,
   GoToWeb, ATShell, ImgList,
  controls, ExtCtrls, Md5b,
  StdCtrls, ComCtrls, ToolWin, FileCtrl,
  share,recapp,sysutils, registry,
  shellapi, Classes,forms, ap,
  Psock,NMHttp,nmftp, ActnList, ZLIBArchive,
  ltype,login, ExFile, TBNArea, PBFolderDialog, appexec, MMJRasConnect;

type

  Tmainfm = class(TForm)
    md5: TCustomMD5;
    SmallImages: TImageList;
    gtw1: TGoToWeb;
    od1: TOpenDialog;
    pme1: TPopupMenu;
    Backup2: TMenuItem;
    Revert2: TMenuItem;
    Uninstall2: TMenuItem;
    RemoveCompletely1: TMenuItem;
    N9: TMenuItem;
    Redeploy2: TMenuItem;
    Mirror2: TMenuItem;
    PullDown2: TMenuItem;
    Run2: TMenuItem;
    N10: TMenuItem;
    Install3: TMenuItem;
    Check1: TMenuItem;
    Upgrade2: TMenuItem;
    RemoveBackup2: TMenuItem;
    ClearStagingArea2: TMenuItem;
    ClearWorkingArea2: TMenuItem;
    ftp1: TNMFTP;
    http1: TNMHTTP;
    flb1: TFileListBox;
    ats1: TATShell;
    pmTaskBar: TPopupMenu;
    ShowClient1: TMenuItem;
    Exit2: TMenuItem;
    N3: TMenuItem;
    HideClient1: TMenuItem;
    timListFail: TTimer;
    pm1: Tpatchmaker;
    timICtimeout: TTimer;
    za: TZLBArchive;
    fdlg: TPBFolderDialog;
    AppExec1: TAppExec;
    ras: TMMJRasConnect;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TBNArea1: TTBNArea;
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FileSaver1Click(Sender: TObject);
    procedure UpgradeReceiverHelp1Click(Sender: TObject);
    procedure Troubleshooting1Click(Sender: TObject);
    procedure GotoCustomerSupport1Click(Sender: TObject);
    procedure GottoWebsite1Click(Sender: TObject);
    procedure LicenceInformation1Click(Sender: TObject);
    procedure LicenceUpgradeReceiverNow1Click(Sender: TObject);
    procedure ProxyFirewallSettings1Click(Sender: TObject);
    procedure tbt20Click(Sender: TObject);
    procedure tbt21Click(Sender: TObject);
    procedure tbt22Click(Sender: TObject);
    procedure tbt23Click(Sender: TObject);
    procedure ShowResults1Click(Sender: TObject);
    procedure AutoSettings1Click(Sender: TObject);
    procedure ftp1Success(Trans_Type: TCmdType);
    procedure ftp1Connect(Sender: TObject);
    procedure ftp1ConnectionFailed(Sender: TObject);
    procedure ftp1Disconnect(Sender: TObject);
    procedure ftp1Error(Sender: TComponent; Errno: Word; Errmsg: String);
    procedure ftp1Failure(var Handled: Boolean; Trans_Type: TCmdType);
    procedure ftp1HostResolved(Sender: TComponent);
    procedure ftp1InvalidHost(var Handled: Boolean);
    procedure ftp1ListItem(Listing: String);
    procedure ftp1PacketRecvd(Sender: TObject);
    procedure ftp1PacketSent(Sender: TObject);
    procedure ftp1TransactionStart(Sender: TObject);
    procedure ftp1TransactionStop(Sender: TObject);
    procedure ftp1UnSupportedFunction(Trans_Type: TCmdType);
    procedure http1Connect(Sender: TObject);
    procedure http1ConnectionFailed(Sender: TObject);
    procedure http1Disconnect(Sender: TObject);
    procedure http1Failure(Cmd: CmdType);
    procedure http1HostResolved(Sender: TComponent);
    procedure http1InvalidHost(var Handled: Boolean);
    procedure http1PacketRecvd(Sender: TObject);
    procedure http1PacketSent(Sender: TObject);
    procedure http1Status(Sender: TComponent; Status: String);
    procedure http1Success(Cmd: CmdType);
    procedure ftp1Status(Sender: TComponent; Status: String);
    procedure pm1ProgressEvent(Sender: TObject; Progress: Real);
    procedure OpenProjectDefinitionFile1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TBNArea1DblClick(Sender: TObject);
    procedure ShowClient1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure hideTask(sender:tobject);
    procedure HideClient1Click(Sender: TObject);
    procedure timListFailTimer(Sender: TObject);
    procedure EmergencyExit1Click(Sender: TObject);
    procedure TransmitterSettings1Click(Sender: TObject);
    procedure timICtimeoutTimer(Sender: TObject);
    procedure ShowHints1Click(Sender: TObject);
  private
    { Private declarations }
    startup:boolean;
    startup2:boolean;

    ProcessingQueueItem:boolean;
    ProcessingAutoUpgrades:boolean;
    ProcessingScheduling:boolean;
    ProcessingUpgradeFile:boolean;
    UpdatingListViews:boolean;
    QueuingApp:boolean;

    Root: TTreeNode;
    curapp:tap;
    olditemchecked:boolean;

    { Timer settings }

    oldQueue:boolean;
    oldUpdateFile:boolean;
    oldScheduling:boolean;
    oldListFail:boolean;
    oldAutoUpgrade:boolean;
    procedure stopTimers;
    procedure startTimers;

    procedure assignhints;
    function removeexts(var tsl:tstringlist): boolean;
    function clearrectemp: boolean;
    { Special Client 4 Apps }
    procedure GetApp;

    { HTTP procedures }

    { Hints }
    procedure setHintBox;

    { new version functions }
  public
    { Public declarations }

    function assoccheck(ext:string):boolean;


    procedure OpenPDF;
    procedure showsimpleinterface;
    procedure showadvancedinterface;

    procedure formshowaction;
    procedure showapplication;

    { Timer procedures }
    function SetAutoTimer:boolean;
  end;

const
  recname='Receiver';
  FTPServer = 0;
  Folder = 1;
  OpenFolder = 2;
  { hints }
  { menu }
  { file menu }
  hfile='|Open a Project Definition File, or exit the program.';
  hopenproj='|User can open a Project Definition File that is anywhere on the network, and then be able to install that Project on their computer.';
  hexit='|Exit Upgrade Receiver';

  { queue menu }
  hqueue='|Start and stop the queue, move items up and down in priority, or remove them.';
  hqstart='Start Queue|Start the queue.';
  hqstop='Stop Queue|Stop the queue.';
  hqup='Move Project Up|Move highlighted Project up in order of processing.';
  hqdown='Move Project Down|Move highlighted Project down in order of processing. ';
  hqremove='Remove Project|Remove Project from queue.This has the effect of cancelling an installation or an upgrade.';

  { project menu }
  hproject='|Install, run, upgrade a Project.Visit the Project Administrator''s website, send email, etc.';
  hrun='Execute Project|Run the highlighted Project.';
  hreadme='View Readme|View the highlighted Project''s readme file.';
  hlreadme='Retrieve/View Readme|Retrieve the highlighted Project''s latest version of readme file and view it.';
  hwebsite='Go to Project Administrator''s Website|Visit the Project Administrator''s website.';
  hinstall='Install Project|Install the highlighted Project.If a Project is already installed, Upgrade Suite Client will look for new version.';
  hcheck='Check Installation Status|Check the status of the highlighted Project.';
  hemail='Email Project Administrator|Email the Project''s Administrator.';
  hupgrade='Upgrade/Install Project|Upgrade/install the highlighted Project.';

  { installation menu }
  hinstallation='|Backup, redeploy, uninstall Projects, etc.';
  hbackup='Backup Project|Create a backup of the current installation of the highlighted Project.';
  hrevert='Rollback Project|Revert to the backup version of the highlighted Project.';
  huninstall='Uninstall Project|Uninstall a Project.';
  hremcomplete='Delete Project Completely|Remove a Project completely.Backups and Redeployments of the Project will also be deleted.Project will not even appear in the Uninstalled Project list.';
  hredeploy='Redeploy Project|Redeploy a Project.Useful if you want to redeploy an Internet-based project across a LAN or Intranet.';

  hmirror='Refresh Redeployment|Bring a redeployed Project up to date with the version currently installed on this computer';
  hpulldown='Pull Down Redeployment|Remove a redeployed Project from it''s Deployment Area.';
  hremovedep='Completely Delete Redeployment|Deletes redeployment of project and all associated files.';

  hrembackup='Delete Project Backup|Remove the back-up of this Project.';
  hclearworkarea='Clear Working Files|Remove working files for the installation if they seem to become corrupt.';
  hclearstage='Clear Staging Area|Remove files from the Staging Area for a redeployment';

  { tools menu }
  htools='|Access the File Saver, view version checking results, set a Project''s installation directory etc.';
  hfilesaver='|Restore Windows or System files that were accidently deleted through uninstalling or totally removing a Project from the computer.';
  hviewresults='Show Log|View results of version checking, or installation operations.';
  hviewproj='|View a Project''s ASCII Project Definition File.';
  hsetinstalldir='|Set a Project''s installation directory.This is useful is a Project was installed before a Project Definition File was obtained.';

  { options menu }
  hoptions='|Set Normal or Advanced mode, program preferences, or proxy server settings for FTP/HTTP operations.';
  hnormal='|Normal mode.';
  hadvanced='|View internal program information to track down problems with installations.';
  hprefs='|Change program preferences, for example, how often to check for new versions of Projects.';
  hproxy='|Change Internet settings for FTP/HTTP operations.';

  { help menu }
  hhelp='|Help, product licensing, website access, etc.';
  hhtmlhelp='|View help file.Access the glossary of terms.';
  hdswebsite='|Visit PC Blues website.';
  hcswebsite='|Visit PC Blues Customer Support website.';
  hlicinf='|View product licencing information.';
  hlicnow='|Go to the PC Blues website to licence products.';
  habout='|About this product.';

  { other interface hints }
  hlv1='|Projects queued for installation/update. The topmost item is taken off the queue first.';
  hlv2='|Installed Projects. When an installed Project is uninstalled, it disappears from this list and appears in the Uninstalled Projects list.';
  hlv3='|Uninstalled or partially installed Projects. When a Project is installed successfully, it disappears from this list and appears in the Installed Projects list.';
  hlv4='|Redeployed Projects.';
  hhint='|Automatic hint box.';

  { popupmenu }
  phproject='Install, run, upgrade a Project.Visit the Project Administrator''s website, send email, etc.';
  phrun='Run the highlighted Project.';
  phreadme='View the highlighted Project''s readme file.';
  phlreadme='Retrieve the highlighted Project''s latest version of readme file and view it.';
  phwebsite='Visit the Project Administrator''s website.';
  phinstall='Install the highlighted Project.If a Project is already installed, Upgrade Suite Client will look for new version.';
  phcheck='Check the status of the highlighted Project.';
  phemail='Email the Project''s Administrator.';
  phupgrade='Upgrade/install the highlighted Project.';
  phinstallation='Backup, redeploy, uninstall Projects, etc.';
  phbackup='Create a backup of the current installation of the highlighted Project.';
  phrevert='Revert to the backup version of the highlighted Project.';
  phuninstall='Uninstall a Project.';
  phremcomplete='Remove a Project completely.Backups and Redeployments of the Project will also be deleted.Project will not even appear in the Uninstalled Project list.';
  phredeploy='Redeploy a Project.Useful if you want to redeploy an Internet-based project across a LAN or Intranet.';
  phmirror='Bring a redeployed Project up to date with the version currently installed on this computer';
  phpulldown='Remove a redeployed Project from it''s Deployment Area.';
  phrembackup='Remove the back-up of this Project.';
  phclearworkarea='Remove working files for the installation if they seem to become corrupt.';
  phclearstage='Remove files from the Staging Area for a redeployment';


var
	cb:tbutton;
  Data: String;
  mainfm: Tmainfm;


implementation

uses fsave, fwall, settings, view, remserv, autoset, newdet,
  xmSettings;

{$R *.DFM}


function FixCase(Path: String): String;
var
  OrdValue: byte;
begin
  if Length(Path) = 0 then exit;
  OrdValue := Ord(Path[1]);
  if (OrdValue >= Ord('a')) and (OrdValue <= Ord('z')) then
    Result := Path
  else
  begin
    Result := AnsiLowerCaseFileName(Path);
    Result[1] := UpCase(Result[1]);
  end;
end;




{ END GLOBAL FUNCTIONS }






{ END PRIVATE FUNCTIONS }

{ PUBLIC FUNCTIONS }
{ END PUBLIC FUNCTIONS }


procedure Tmainfm.FormCreate(Sender: TObject);
begin
ProcessingQueueItem:=false;
ProcessingAutoUpgrades:=false;
ProcessingScheduling:=false;
ProcessingUpgradeFile:=false;
UpdatingListViews:=false;
QueuingApp:=false;

connectionerror:=false;
CAption:=c4appsCaption;
startup:=true;
startup2:=true; // for queue items that are set to receiving
revertingnow:=false;
assignhints;
end;


procedure Tmainfm.Exit1Click(Sender: TObject);
begin
close;
end;


{ install project right away }
procedure Tmainfm.FormShow(Sender: TObject);
begin
formshowaction;
end;

procedure Tmainfm.FileSaver1Click(Sender: TObject);
begin
fsavefm.show;
end;


procedure Tmainfm.UpgradeReceiverHelp1Click(Sender: TObject);
begin
application.HelpContext(18);
{if shellexecute(0,'open','index.html',nil,pchar(s.rcpath+'docs'),SW_SHOWNORMAL)<=32 then
	showmessagenotsilent('Error 212. Could not open HTML help in your default browser.');}
end;

procedure Tmainfm.Troubleshooting1Click(Sender: TObject);
begin
if shellexecute(0,'open','rtshoot.html',nil,pchar(s.ugpath+'docs'),SW_SHOWNORMAL)<=32 then
	showmessagenotsilent('Error 213. Could not open Troubleshooting HTML page in your default browser.');
end;

procedure Tmainfm.GotoCustomerSupport1Click(Sender: TObject);
begin
{ Go to Customer Support Page on PC Blues website }
gtw1.url:='http://www.pcblues.com/support/index.html';
if gtw1.execute=false then
	showmessagenotsilent('Error 214. Could not open the PC Blues Customer Support Website in your '+
  'default web browser. Open your favourite browser and go to http://www.pcblues.com/support/index.html');
end;

procedure Tmainfm.GottoWebsite1Click(Sender: TObject);
begin
{ open web page help }
gtw1.url:='http://www.pcblues.com/index.html';
if gtw1.execute=false then
	showmessagenotsilent('Error 215. Could not open the PC Blues Website in your '+
  'default web browser. Open your favourite browser and go to http://www.pcblues.com/index.html');
end;

procedure Tmainfm.LicenceInformation1Click(Sender: TObject);
begin
if shellexecute(0,'open','clicence.html',nil,pchar(s.rcpath+'docs'),SW_SHOWNORMAL)<=32 then
	showmessagenotsilent('Error 255. Could not open Licence Information HTML page in your default browser.');
end;

procedure Tmainfm.LicenceUpgradeReceiverNow1Click(Sender: TObject);
begin
{ open web page help }
gtw1.url:='http://www.pcblues.com/sales/index.html';
if gtw1.execute=false then
	showmessagenotsilent('Error 216. Could not open the PC Blues Sales Website in your '+
  'default web browser. Open your favourite browser and go to http://www.pcblues.com/sales/index.html');
end;

procedure Tmainfm.ProxyFirewallSettings1Click(Sender: TObject);
begin
fwallfm.showmodal;
end;





procedure Tmainfm.tbt20Click(Sender: TObject);
begin
viewfm.show;
end;

procedure Tmainfm.tbt21Click(Sender: TObject);
begin
viewfm.show;
end;

procedure Tmainfm.tbt22Click(Sender: TObject);
begin
viewfm.show;
end;

procedure Tmainfm.tbt23Click(Sender: TObject);
begin
viewfm.show;
end;


procedure Tmainfm.ShowResults1Click(Sender: TObject);
begin
viewfm.show;
end;




procedure Tmainfm.AutoSettings1Click(Sender: TObject);
begin
autosetfm.showmodal;
end;

function Tmainfm.clearrectemp: boolean;
begin
{ careful checks here }
if (directoryexists(rectemppath)) and (rectemppath<>'') and (pos('temp',rectemppath)<>0) then
  begin
  { clear temp rec file }
  viewfm.m1.lines.add('');
  viewfm.m1.lines.add('DELETING UPGRADE SUITE CLIENT TEMP DIRECTORY ['+datetimetostr(now)+']');
  recdirdel(rectemppath);
  forcedirectories(rectemppath);
  viewfm.m1.lines.add('  Deleted: Upgrade Client Temp directory "'+rectemppath+'" ['+datetimetostr(now)+']');
  viewfm.m1.lines.add('');
  end;
end;


function Tmainfm.removeexts(var tsl:tstringlist): boolean;
var
  cnt,cntm:integer;
begin
cntm:=tsl.count-1;
for cnt:=cntm downto 0 do
  begin
//  if (pos('.pbu',tsl[cnt])<>0)or (pos('.rdp',tsl[cnt])<>0) then
  if (pos('.pbu',tsl[cnt])<>0) then
    tsl.Delete(cnt);
  end;
end;

procedure Tmainfm.assignhints;
begin
end;





function tmainfm.assoccheck(ext:string):boolean;
var
  bres:boolean;
  res:integer;
  assoc,ridold:boolean;
begin
result:=true;
{ check if associated with .upg files }
ats1.Extension:=ext;
assoc:=false;
ridold:=false;
bres:=ats1.GetAssociation;
if bres=false then
	begin
  {associate}
  assoc:=true;
  end
else if (ats1.pathtoapp<>paramstr(0)) then
  begin
  if s.runsilent then
    res:=mryes  else
    res:=messagedlg('A file association already exists for '+ext+' files. It may be a previous installation of Upgrade Receiver.'+#13#10#13#10+
    'Do you want to associate '+ext+' files with Upgrade Suite Client? (Recommended)',mtconfirmation,[mbYes,mbNo],0);
	if res=mrYes then
  	begin
    ridold:=true;
    {associate}
    assoc:=true;
    end;
  end;
if assoc then
	begin
  ats1.IconPath:=paramstr(0)+',0';
  ats1.KeyName:='upgrade_pdf';
  ats1.PathToApp:=paramstr(0);
  ats1.TypeName:='Upgrade Project Definition File';
  { not sure about this }
  ats1.Quickview:=true;
  ats1.ShowInNew:=false;
  if ridold then
    ats1.RemoveAssociation(true,false);
  ats1.CreateAssociation;
  end;
end;

procedure Tmainfm.ftp1Success(Trans_Type: TCmdType);
begin
sFTP1Success(trans_type);
end;

procedure Tmainfm.ftp1Connect(Sender: TObject);
begin
sFTP1Connect(Sender);
end;

procedure Tmainfm.ftp1ConnectionFailed(Sender: TObject);
begin
sFTP1ConnectionFailed(Sender);
end;

procedure Tmainfm.ftp1Disconnect(Sender: TObject);
begin
sFTP1Disconnect(Sender);
end;

procedure Tmainfm.ftp1Error(Sender: TComponent; Errno: Word;
  Errmsg: String);
begin
sFTP1Error(Sender,Errno,Errmsg);
end;

procedure Tmainfm.ftp1Failure(var Handled: Boolean; Trans_Type: TCmdType);
begin
sFTP1Failure(handled,Trans_Type);
end;

procedure Tmainfm.ftp1HostResolved(Sender: TComponent);
begin
sFTP1HostResolved(Sender);
end;

procedure Tmainfm.ftp1InvalidHost(var Handled: Boolean);
begin
sFTP1InvalidHost(handled);
end;

procedure Tmainfm.ftp1ListItem(Listing: String);
begin
sFTP1ListItem(Listing);
end;

procedure Tmainfm.ftp1PacketRecvd(Sender: TObject);
begin
sFTP1PacketRecvd(Sender);
end;

procedure Tmainfm.ftp1PacketSent(Sender: TObject);
begin
sFTP1PacketSent(Sender);
end;

procedure Tmainfm.ftp1TransactionStart(Sender: TObject);
begin
sFTP1TransactionStart(Sender);
end;

procedure Tmainfm.ftp1TransactionStop(Sender: TObject);
begin
sFTP1TransactionStop(Sender);
end;

procedure Tmainfm.ftp1UnSupportedFunction(Trans_Type: TCmdType);
begin
sFTP1UnSupportedFunction(Trans_Type);
end;

procedure Tmainfm.http1Connect(Sender: TObject);
begin
sHTTP1Connect(Sender);
end;

procedure Tmainfm.http1ConnectionFailed(Sender: TObject);
begin
sHTTP1ConnectionFailed(Sender);
end;

procedure Tmainfm.http1Disconnect(Sender: TObject);
begin
sHTTP1Disconnect(Sender);
end;

procedure Tmainfm.http1Failure(Cmd: CmdType);
begin
sHTTP1Failure(Cmd);
end;

procedure Tmainfm.http1HostResolved(Sender: TComponent);
begin
sHTTP1HostResolved(Sender);
end;

procedure Tmainfm.http1InvalidHost(var Handled: Boolean);
begin
sHTTP1InvalidHost(handled);
end;

procedure Tmainfm.http1PacketRecvd(Sender: TObject);
begin
sHTTP1PacketRecvd(Sender);
end;

procedure Tmainfm.http1PacketSent(Sender: TObject);
begin
sHTTP1PacketSent(Sender);
end;

procedure Tmainfm.http1Status(Sender: TComponent; Status: String);
begin
sHTTP1Status(Sender,Status);
end;

procedure Tmainfm.http1Success(Cmd: CmdType);
begin
sHTTP1Success(Cmd);
end;

procedure Tmainfm.ftp1Status(Sender: TComponent; Status: String);
begin
putview(status);
end;



procedure Tmainfm.pm1ProgressEvent(Sender: TObject; Progress: Real);
begin
label2.caption:=pm1.oldFile+': '+inttostr(trunc(progress*100)+1)+'%';
application.processmessages;
end;

procedure Tmainfm.OpenPDF;
begin
end;

procedure Tmainfm.OpenProjectDefinitionFile1Click(Sender: TObject);
begin
OpenPDF;
end;


procedure Tmainfm.showadvancedinterface;
begin
end;

procedure Tmainfm.showsimpleinterface;
begin
end;


procedure Tmainfm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
	cntm,cnt:integer;
begin
canclose:=true;
//httptimeout:=true;
//ftptimeout:=true;
if DialUpConnected then
  HangUp;

{ check if doing anything? }
ftpabort( ftp1);
httpabort(http1);
{ change queue settings to waiting }
end;

procedure Tmainfm.TBNArea1DblClick(Sender: TObject);
begin
showapplication;
end;

procedure Tmainfm.formshowaction;
begin
{ Open .upg file }
flb1.mask:='*.upg';
flb1.FileType:=[ftnormal,ftreadonly];
flb1.directory:=s.rcpath;
flb1.Refresh;
if flb1.filename<>'' then
  begin
  { flb1.FileName is the file you want? }
  acceptfile(flb1.filename,true);
  { This sets globalids }
  GetApp;
  end
else
  showmessage('Updater Client could not find an update file. Contact software vendor.');
application.terminate;
end;


procedure Tmainfm.ShowClient1Click(Sender: TObject);
begin
{ Show client }
showapplication;
end;

procedure Tmainfm.showapplication;
begin
application.restore;
show;
application.bringtofront;
hidetask(application);
end;

procedure Tmainfm.Exit2Click(Sender: TObject);
begin
close;
end;

procedure Tmainfm.hideTask(sender: tobject);
begin
//ShowWindow( Application.handle, SW_HIDE );
end;

procedure Tmainfm.HideClient1Click(Sender: TObject);
begin
application.minimize;
end;

function Tmainfm.SetAutoTimer: boolean;
begin
end;

procedure Tmainfm.timListFailTimer(Sender: TObject);
begin
timListFail.enabled:=false;
ListFailed:=true;

end;

procedure Tmainfm.EmergencyExit1Click(Sender: TObject);
begin
if messagedlg('Exit program and any network processes?',mtconfirmation,[mbyes,mbno],0)=mryes then
  halt;
end;

procedure Tmainfm.TransmitterSettings1Click(Sender: TObject);
begin
frmxmSettings.showmodal;
end;

procedure Tmainfm.timICtimeoutTimer(Sender: TObject);
begin
dec(ictimeout);
if ictimeout<=0 then
  begin
	Screen.Cursor := crDefault;
  timICtimeout.enabled:=false;
  label3.caption:='';
  application.processmessages;
  end
else
  begin
  label3.caption:=inttostr(ictimeout);
  application.processmessages;
  end;
end;

procedure Tmainfm.startTimers;
begin
{timQueue.enabled:=oldQueue;
timUpdatefile.enabled:=oldUpdateFile;
timScheduling.enabled:=oldScheduling;
timListFail.enabled:= oldListFail;
timAutoUpgrade.enabled:=oldAutoUpgrade;
}
end;

procedure Tmainfm.stopTimers;
begin
{oldQueue:=timQueue.enabled;
timQueue.enabled:=false;
oldUpdateFile:=timUpdatefile.enabled;
timUpdatefile.enabled:=false;
oldScheduling:=timScheduling.enabled;
timScheduling.enabled:=false;
oldListFail:=timListFail.enabled;
timListFail.enabled:=false;
oldAutoUpgrade:=timAutoUpgrade.enabled;
timAutoUpgrade.enabled:=false;
}
end;

procedure Tmainfm.ShowHints1Click(Sender: TObject);
begin
s.showhints:=not s.showhints;
SetHintBox;
end;

procedure Tmainfm.setHintBox;
begin
// is this OK?
s.savesettings;
end;

procedure Tmainfm.GetApp;
var
  oldverstatus: tverstatus;
//  dltype:integer; // download type: 0 - http, 1 - ftp, 2 - local/network
//  tp:string;
  posn:integer;
  tempra:trecapp;
  res:integer;
  tempap:tap;
  defloc:string;
  goon:boolean;
  install:boolean;
begin
{ If the upgrade is not successful, create this file
  with a message }
goon:=true;
deletefile(extractfilepath(paramstr(0))+'\upglog.txt');
{ check for commandline options }
if (paramstr(2)='cio') then
  begin
  if  not ras.IsConnected then
    begin
    { Skip install }
    goon:=false;
    end;
  end;

if goon then
  begin
  { This installs app with ID of GUID }
  install:=true;
  { check if item ready to download }
  stopTimers;
  tempra:=trecapp.create;
  if tempra.loadfromreg(globalids)=false then
    begin
    showmessagenotsilent('Critical update error. Please contact the vendor of this software.');
    goon:=false;
    tempra.qstatus:=qsNotqueued;
    tempra.autoupg:=false;
    tempra.savetoreg;
    end;
  if goon then
    begin
    tempra.getlatestpdf(http1,ftp1,rectemppath,s.rdpath,true);
    tempra.checkinstall(s.projpath);
    if (tempra.inststatus<>isInstalled) or (tempra.verstatus<>vsUptodate) then
      begin
      tempra.install(http1,ftp1,true,s.projpath,true);
      tempra.checkinstall(s.projpath);
      if (tempra.inststatus=isInstalled) and (tempra.verstatus=vsUptodate) then
        begin
        tempra.prevver:=tempra.instver;
        tempra.instver:=tempra.latver;
        tempra.savetoreg;
        showmessagenotsilent('Update complete. Restart this program for update to take effect.');
        end
      else
        begin
        if (tempra.inststatus=isInstalled) and (tempra.verstatus<>vsUptodate) then
          begin
          if rebootnow=true then
            begin
            showmessage('Your computer must be rebooted for update to take effect.');
            rebootnow:=false;
            tempra.qstatus:=qsNotqueued;
            tempra.savetoreg;
            end
          else
            begin
            showmessage('This update contains errors in it''s configuration. Please contact the vendor of this software.');
            tempra.qstatus:=qsNotqueued;
            if not s.runsilent then
              tempra.autoupg:=false;
            tempra.savetoreg;
            end;
          end
        else
          begin
          showmessage('Update was unsuccessful');
          tempra.qstatus:=qsNotqueued;
          if not s.runsilent then
            tempra.autoupg:=false;
          tempra.savetoreg;
          end;
        end;
      end
    else
      begin
      showmessagenotsilent('Update cancelled');
      end;
    end;
  starttimers;
  end;
end;


end.

