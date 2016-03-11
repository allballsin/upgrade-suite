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
    mnu1: TMainMenu;
    File1: TMenuItem;
    help1: TMenuItem;
    Exit1: TMenuItem;
    sb1: TStatusBar;
    timQueue: TTimer;
    SmallImages: TImageList;
    timUpdateFile: TTimer;
    pc1: TPageControl;
    tsqueue: TTabSheet;
    tsinst: TTabSheet;
    tsunin: TTabSheet;
    lv1: TListView;
    p1: TPanel;
    m1: TMemo;
    s3: TSplitter;
    ToolBar1: TToolBar;
    Label5: TLabel;
    tsredep: TTabSheet;
    lv2: TListView;
    tb4: TToolBar;
    tb3: TToolBar;
    tb2: TToolBar;
    Start: TToolButton;
    tbt2: TToolButton;

    tbt3: TToolButton;
    tbt4: TToolButton;
    tbt5: TToolButton;
    tbt6: TToolButton;
    tbt9: TToolButton;
    tbt10: TToolButton;
    lv3: TListView;
    Tools1: TMenuItem;
    FileSaver1: TMenuItem;
    Options1: TMenuItem;
    tbt11: TToolButton;
    tbt12: TToolButton;
    tbt13: TToolButton;
    tbt14: TToolButton;
    tbt15: TToolButton;
    gtw1: TGoToWeb;
    AboutUpgradeReceiver1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    UpgradeReceiverHelp1: TMenuItem;
    GotoCustomerSupport1: TMenuItem;
    GottoWebsite1: TMenuItem;
    tbt16: TToolButton;
    ProxyFirewallSettings1: TMenuItem;
    Queue1: TMenuItem;
    Start1: TMenuItem;
    Stop1: TMenuItem;
    Up1: TMenuItem;
    Down1: TMenuItem;
    Remove1: TMenuItem;
    Run1: TMenuItem;
    Uninstall1: TMenuItem;
    Upgrade1: TMenuItem;
    Revert1: TMenuItem;
    Readme1: TMenuItem;
    Email1: TMenuItem;
    Website1: TMenuItem;
    Redeploy1: TMenuItem;
    Readme2: TMenuItem;
    Install1: TMenuItem;
    Check2: TMenuItem;
    Project1: TMenuItem;
    N5: TMenuItem;
    ToolBar2: TToolBar;
    tbt19: TToolButton;
    lv4: TListView;
    Mirror1: TMenuItem;
    N6: TMenuItem;
    PullDown1: TMenuItem;
    Backup1: TMenuItem;
    OpenProjectDefinitionFile1: TMenuItem;
    N7: TMenuItem;
    od1: TOpenDialog;
    tbt20: TToolButton;
    tbt21: TToolButton;
    tbt22: TToolButton;
    tbt23: TToolButton;
    Remove2: TMenuItem;
    ShowResults1: TMenuItem;
    Install2: TMenuItem;
    SetInstallDirectory1: TMenuItem;
    AutoSettings1: TMenuItem;
    ViewProjectFile1: TMenuItem;
    N8: TMenuItem;
    N4: TMenuItem;
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
    tbt17: TToolButton;
    tbt18: TToolButton;
    RemoveBackup1: TMenuItem;
    RemoveBackup2: TMenuItem;
    ClearStagingArea1: TMenuItem;
    ClearStagingArea2: TMenuItem;
    ClearWorkingArea1: TMenuItem;
    ClearWorkingArea2: TMenuItem;
    ftp1: TNMFTP;
    http1: TNMHTTP;
    flb1: TFileListBox;
    timScheduling: TTimer;
    ats1: TATShell;
    TBNArea1: TTBNArea;
    pmTaskBar: TPopupMenu;
    ShowClient1: TMenuItem;
    Exit2: TMenuItem;
    N3: TMenuItem;
    HideClient1: TMenuItem;
    NetworkConnection1: TMenuItem;
    timAutoUpgrade: TTimer;
    timListFail: TTimer;
    N11: TMenuItem;
    EmergencyExit1: TMenuItem;
    TransmitterSettings1: TMenuItem;
    pm1: Tpatchmaker;
    N12: TMenuItem;
    RefreshDisplay1: TMenuItem;
    timICtimeout: TTimer;
    za: TZLBArchive;
    N13: TMenuItem;
    ShowHints1: TMenuItem;
    fdlg: TPBFolderDialog;
    N14: TMenuItem;
    AppExec1: TAppExec;
    ras: TMMJRasConnect;
    procedure FormCreate(Sender: TObject);
    procedure timQueueTimer(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure timUpdateFileTimer(Sender: TObject);
    procedure tbt3Click(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure tbt10Click(Sender: TObject);
    procedure tbt6Click(Sender: TObject);
    procedure tbt9Click(Sender: TObject);
    procedure tbt8Click(Sender: TObject);
    procedure lv2Click(Sender: TObject);
    procedure lv3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FileSaver1Click(Sender: TObject);
    procedure tbt11Click(Sender: TObject);
    procedure tbt12Click(Sender: TObject);
    procedure tbt7Click(Sender: TObject);
    procedure tbt2Click(Sender: TObject);
    procedure tbt4Click(Sender: TObject);
    procedure tbt5Click(Sender: TObject);
    procedure tbt15Click(Sender: TObject);
    procedure tbt14Click(Sender: TObject);
    procedure AboutUpgradeReceiver1Click(Sender: TObject);
    procedure UpgradeReceiverHelp1Click(Sender: TObject);
    procedure Troubleshooting1Click(Sender: TObject);
    procedure GotoCustomerSupport1Click(Sender: TObject);
    procedure GottoWebsite1Click(Sender: TObject);
    procedure LicenceInformation1Click(Sender: TObject);
    procedure LicenceUpgradeReceiverNow1Click(Sender: TObject);
    procedure tbt16Click(Sender: TObject);
    procedure ProxyFirewallSettings1Click(Sender: TObject);
    procedure tbt17Click(Sender: TObject);
    procedure tbt13Click(Sender: TObject);
    procedure Run1Click(Sender: TObject);
    procedure Readme1Click(Sender: TObject);
    procedure Readme2Click(Sender: TObject);
    procedure Website1Click(Sender: TObject);
    procedure Email1Click(Sender: TObject);
    procedure Install1Click(Sender: TObject);
    procedure Check2Click(Sender: TObject);
    procedure Upgrade1Click(Sender: TObject);
    procedure Revert1Click(Sender: TObject);
    procedure Uninstall1Click(Sender: TObject);
    procedure Redeploy1Click(Sender: TObject);
    procedure lv3Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lv2Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure Backup1Click(Sender: TObject);
    procedure Mirror1Click(Sender: TObject);
    procedure tbt18Click(Sender: TObject);
    procedure tbt19Click(Sender: TObject);
    procedure PullDown1Click(Sender: TObject);
    procedure lv4Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lv2DblClick(Sender: TObject);
    procedure lv3DblClick(Sender: TObject);
    procedure lv4DblClick(Sender: TObject);
    procedure tbt20Click(Sender: TObject);
    procedure tbt21Click(Sender: TObject);
    procedure tbt22Click(Sender: TObject);
    procedure tbt23Click(Sender: TObject);
    procedure pc1Change(Sender: TObject);
    procedure Remove2Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Up1Click(Sender: TObject);
    procedure Down1Click(Sender: TObject);
    procedure Remove1Click(Sender: TObject);
    procedure ShowResults1Click(Sender: TObject);
    procedure SetInstallDirectory1Click(Sender: TObject);
    procedure AutoSettings1Click(Sender: TObject);
    procedure ViewProjectFile1Click(Sender: TObject);
    procedure RemoveBackup1Click(Sender: TObject);
    procedure ClearStagingArea1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ClearWorkingArea1Click(Sender: TObject);
    procedure ClearWorkingArea2Click(Sender: TObject);
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
    procedure lv2Changing(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure lv3Changing(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure pm1ProgressEvent(Sender: TObject; Progress: Real);
    procedure OpenProjectDefinitionFile1Click(Sender: TObject);
    procedure timSchedulingTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TBNArea1DblClick(Sender: TObject);
    procedure ShowClient1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure hideTask(sender:tobject);
    procedure HideClient1Click(Sender: TObject);
    procedure timAutoUpgradeTimer(Sender: TObject);
    procedure timListFailTimer(Sender: TObject);
    procedure EmergencyExit1Click(Sender: TObject);
    procedure TransmitterSettings1Click(Sender: TObject);
    procedure timICtimeoutTimer(Sender: TObject);
    procedure RefreshDisplay1Click(Sender: TObject);
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

    function projrembackup(lv:tlistview):boolean;
    procedure assignhints;
    function removeexts(var tsl:tstringlist): boolean;
    function lvsel(lv:tlistview;li:tlistitem): boolean;
    function clearrectemp: boolean;
    function projremove(lv:tlistview): boolean;
    function setsaveautoupgrade(li:tlistitem): boolean;
    function loadlistitemr(fname:string;tli:tlistitem): boolean;
    function projpulldown(lv:tlistview): boolean;
    function projmirror(lv:tlistview): boolean;
    function projbackup(id:string):boolean;
    function setsaveautomirror(li:tlistitem): boolean;
    function getli(lv:tlistview;id:string): tlistitem;
    function getlivs(li:tlistitem): tverstatus;
    function getliis(li:tlistitem): tinststatus;
    function getliqs(li:tlistitem): tqstatus;
    function loadlistitemq(tempra:trecapp;var li:tlistitem):boolean;
    function loadlistitem(tempra:trecapp;var li:tlistitem):boolean;
    function getid(li:tlistitem):string;
    function setsavevs(li:tlistitem;vs:tverstatus): boolean;
    function setsaveis(li:tlistitem;ins:tinststatus): boolean;
    function setsaveqs(li:tlistitem;qs:tqstatus): boolean;
    function isinstalling(li:tlistitem): boolean;
    function getvislv:tlistview;
    function projinstall(lv:tlistview): boolean;
    function projreadmelatest(lv:tlistview): boolean;
    function projredeploy(lv:tlistview;wt:boolean): boolean;
    function projwebsite(lv:tlistview): boolean;
    function projemail(lv:tlistview): boolean;
    function projreadme(lv:tlistview): boolean;
    function projrevert(lv:tlistview): boolean;
    function projupgrade(lv:tlistview): boolean;
    function projuninstall(lv:tlistview): boolean;
    function projcheck(lv:tlistview): boolean;
    function projrun(lv:tlistview): boolean;
    function projremworkarea(lv:tlistview): boolean;
    function queueremove: boolean;
    function queuemovedown: boolean;
    function queuemoveup: boolean;
    procedure queueapp(id:string;forceaccept:boolean);
    procedure getqdapp;

    { HTTP procedures }

    function updatelvs(sel:tlistitem):boolean;
    function projclearstage(lv:tlistview): boolean;

    { Hints }
    procedure setHintBox;

    { new version functions }
  public
    { Public declarations }

    function assoccheck(ext:string):boolean;

    function readactionfile:boolean;
    function queuestop: boolean;
    function queuestart: boolean;
    procedure pollstart;
    procedure pollstop;
    function projsetinstalldir(lv:tlistview): boolean;
		procedure showhint(sender:tobject);
    function autoupgrade(scheduling:boolean):boolean;

    procedure OpenPDF;
    procedure showsimpleinterface;
    procedure showadvancedinterface;

    procedure formshowaction;
    procedure formActivateAction;
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

uses fsave, about, fwall, settings, view, remserv, autoset, newdet,
  splash, xmSettings;

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



function Tmainfm.projrun(lv:tlistview): boolean;
var
  res: integer;
	id:String;
  tempar:trecapp;
  instsuccess:boolean;
begin
result:=false;
{ run main project file }
if lvsel(lv,lv.selected) then
	begin
  id:=getid(lv.selected);
  if id='' then
  	showmessagenotsilent('Could not retrieve Project ID.')
  else
  	begin
    instsuccess:=true;
    if not isidregified(id) then
    	begin
      instsuccess:=false;
      if s.runsilent then
        res:=mryes
      else
      	res:=messagedlg('Project must be retrieved and installed first. Install?',mtconfirmation,[mbyes,mbno],0);
	    if res=mryes then
      	begin
        if projinstall(lv) then
        	instsuccess:=true;
        end;
      end;
    if instsuccess then
    	begin
			tempar:=trecapp.create;
      tempar.loadfromreg(id);
      tempar.runproj;
      tempar.free;
      result:=true;
      end;
    end;
  end;
end;

function Tmainfm.queueremove: boolean;
begin
result:=false;
{ remove the Project from the queue }
if (lv1.selected<>nil) and not ((lv1.selected=lv1.TopItem) and (isinstalling(lv1.topitem)) ) then
	begin
  setsaveqs(lv1.selected,qsNotqueued);
  result:=true;
  end;
end;

function Tmainfm.queuemovedown: boolean;
var
  posn:integer;
begin
result:=false;
{ swap with one below }
if lv1.selected<>nil then
	if (lv1.selected<>lv1.items[lv1.Items.count-1]) and
  not ((lv1.selected=lv1.topitem) and (isinstalling(lv1.selected))) then
  	begin
    posn:=lv1.selected.index;
    lv1.Items.Insert(posn);
    lv1.items[posn]:=lv1.items[posn+2];
    lv1.items.Delete(posn+2);
    lv1.Update;
    result:=true;
    end;
end;

function Tmainfm.queuemoveup: boolean;
var
  posn:integer;
begin
result:=false;
{ swap with one above }
if lv1.selected<>nil then
	if (lv1.selected<>lv1.TopItem) and
  not ((lv1.selected=lv1.topitem) and (isinstalling(lv1.selected))) then
  	begin
    posn:=lv1.selected.index;
    lv1.Items.Insert(posn+1);
    lv1.items[posn+1]:=lv1.items[posn-1];
    lv1.items.Delete(posn-1);
    lv1.Update;
    result:=true;
    end;
end;

function Tmainfm.queuestop: boolean;
begin
result:=false;
//if not isinstalling(lv1.topitem) then
//	begin
//	showmessagenotsilent('Not installing anything. Command will have no effect.');
// end
//else
//	begin
  setsaveqs(lv1.TopItem,qsWaiting);
  sb1.panels[1].text:='Queue Halted';
  timQueue.enabled:=false;
  result:=true;
//  end;
end;

function Tmainfm.queuestart: boolean;
begin
result:=false;
//if isinstalling(lv1.topitem) then
//  begin
//  { Already installing }
//  showmessagenotsilent('Already installing a Project.'#13#10#13#10+
//  'If you want to install a different Project, "Stop" the current one, then'+
//  ' click on the desired Project, and click "Start"');
//  end
//else
//  begin
  { this should be done by the timer. }
  sb1.panels[1].text:='Queue Running';
  timQueue.enabled:=true;
  result:=true;
//  end;
end;



{ END GLOBAL FUNCTIONS }


procedure tmainfm.queueapp(id:string;forceaccept:boolean);
var
  goon:boolean;
  cntm,cnt:integer;
  res:integer;
  tempra:trecapp;
  c,cm:integer;
  fnd:boolean;
begin
{ check if id file exists }
if not QueuingApp then
  begin
  QueuingApp:=true;
  goon:=true;
  tempra:=trecapp.create;
  if not tempra.projregified(s.projpath+id) then
    begin
    goon:=false;
    showmessagenotsilent('Project Definition not found in registry.');
    end;
  if goon then
    begin
    tempra.loadfromreg(id);
    { Check if allowed to be installed }
    if tempra.tempap.TargetDistID.count>0 then
      begin
      fnd:=false;
      cm:=autosetfm.cbID.Items.count-1;
      for c:=0 to cm do
        begin
        if tempra.tempap.TargetDistID.IndexOf(autosetfm.cbID.items[c])>-1 then
          fnd:=true;
        end;
      if not fnd then
        begin
        goon:=false;
        if not s.runsilent then
          showmessagE('This version of '+tempra.name+' is not targetted to your client.'+#10+
          'If you believe this to be in error, please contact the Project Administrator.');
        end;
      end;
    if goon then
      begin
      { check if there already }
      cntm:=lv1.items.count-1;
      res:=mrYes;
      for cnt:=0 to cntm do
        begin
        if (lv1.items[cnt].subitems[2]=tempra.id) and (forceaccept=false) then
          begin
          if s.runsilent then
            res:=mrno
          else
            res:=messagedlg('Project with same ID is already in queue. Add it anyway?',mtconfirmation,[mbYes,mbNo],0);
          end;
        end;
      if res=mrYes then
        begin
        { Check scheduling }
        if tempra.useScheduling then
          begin
          if (tempra.ScheduleTime+tempra.ScheduleDate)>now then
            begin
            res:=mrno;
            if not s.runsilent then
              showmessage('Project "'+tempra.name+'" is not due to be installed yet.');
            end;
          end;
        { Check if parents? }
        if res=mryes then
          if not tempra.checkdeps then
            res:=mrno;
        if res=mryes then
          begin
          tempra.qstatus:=qswaiting;
          tempra.savetoreg;
          updatelvs(nil);
          end;
        end;
      end;
    end;
  tempra.free;
  QueuingApp:=false;
  end;
end;

procedure tmainfm.getqdapp;
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
goon:=true;
install:=true;
{ check if item ready to download }
stopTimers;
tempra:=trecapp.create;
if lv1.Items.count>0 then
  begin
  posn:=0;
  if tempra.loadfromreg(lv1.items[posn].subitems[2])=false then
  	begin
		showmessagenotsilent('Error 127. Unrecognised Project ID.');
    goon:=false;
    tempra.qstatus:=qsNotqueued;
    tempra.autoupg:=false;
    tempra.savetoreg;
    updatelvs(nil);
    end
  end
else
  begin
  goon := False;
  end;
if goon then
  begin
  if tempra.qstatus<>qsWaiting then
    begin
    { not ready to start downloading }
    //showmessagenotsilent('Top item is busy.');
    goon:=false;
    end
  end;
if goon then
  begin
  { Check installation }
  tempra.checkinstall(s.projpath);
  updatelvs(nil);
  if tempra.inststatus=isInstalled then
    begin
    { check version }
    if tempra.verstatus=vsUptodate then
      begin
      { up to date }
      showmessagenotsilent('"'+tempra.name+'" is installed and up to date.');
      goon:=false;
      tempra.qstatus:=qsNotqueued;
      tempra.savetoreg;
      updatelvs(nil);
      end
    else
      begin
      { offer to keep old version }
      if s.runsilent then
        res:=mrno
      else
        res:=messagedlg('About to install/upgrade "'+tempra.name+'"'+#13#10#13#10+
      'Do you want to back up your old version in case the new installation fails?',mtconfirmation,[mbyes,mbno],0);
      if res=mryes then
        begin
        tempra.savetoreg;
        updatelvs(nil);
        projbackup(tempra.id);
        tempra.loadfromreg(tempra.id);
        end;
      { update }
      end;
    end
  end;
if goon=true then
  begin
  if install then
    begin
    if tempra.installdir='' then
      begin
      { if no install dir}
      tempap:=tap.create;
      tempap.loadfromfile(s.projpath+tempra.id);
      defloc:=tempap.deflocdir;
      tempap.free;
      res:=mrno;
      if defloc<>'' then
        begin
        if s.runsilent then
          res:=mryes
        else
          res:=messagedlg('Installing "'+tempra.name+'"'#13#10#13#10'Default installation directory is:'#13#10+defloc+#13#10#13#10'Do you want to use this directory?',mtconfirmation,[mbyes,mbno],0);
        if res=mryes then
          begin
          forcedirectories(defloc);
          tempra.installdir:=defloc;
          end;
        end;
      if res=mrno then
        begin
        fdlg.LabelCaptions.clear;
        fdlg.LabelCaptions.add('Default=Select Installation Directory for '+tempra.name);
        if fdlg.Execute then
          begin
          { install }
          tempra.installdir:=fdlg.Folder;
          end
        else
          begin
          { cancel install }
          //tempra.installdir:=defloc;
          goon:=false;
          tempra.qstatus:=qsNotQueued;
          tempra.savetoreg;
          updatelvs(nil);
          end;
        end;
      end;
    if goon then
      begin
      { actually install }
      tempra.qstatus:=qsinstalling;
      tempra.savetoreg;
      updatelvs(nil);
      tempra.install(http1,ftp1,false,s.projpath,autosetfm.c5.checked);
      updatelvs(nil);
      tempra.checkinstall(s.projpath);
      updatelvs(nil);
      if (tempra.inststatus=isInstalled) and (tempra.verstatus=vsUptodate) then
        begin
        tempra.prevver:=tempra.instver;
        tempra.instver:=tempra.latver;
        tempra.savetoreg;
        updatelvs(nil);
        showmessagenotsilent(tempra.name+' installation complete.');
        //mainfm.pc1.activepage:=tsinst;
        { check for automirror }
        if tempra.automirror then
          begin
          if tempra.redeploy<>'' then
            begin
            tempap:=tap.create;
            if tempap.loadfromfile(s.rdpath+tempra.redeploy) then
              begin
              tempap.loadserfromfile(s.rdpath+tempra.redeploy+'.ser');
              tempap.mirror(recstagepath,tempra.instver);
              tempap.savetofile;
              end;
            tempap.free;
            end;
          end;
        { offer to show readme }
        tempra.viewreadme;
        end
      else
        begin
        if (tempra.inststatus=isInstalled) and (tempra.verstatus<>vsUptodate) then
          begin
          if rebootnow=true then
            begin
            showmessagenotsilent('You must reboot your computer to complete this Installation.');
            rebootnow:=false;
            tempra.qstatus:=qsNotqueued;
            tempra.savetoreg;
            updatelvs(nil);
            end
          else
            begin
            showmessagenotsilent('"'+tempra.name+'" Installation complete, but Upgrade Suite Client detects one of the Project''s files is still out of date. Contact the Project Administrator.');
            tempra.qstatus:=qsNotqueued;
            if not s.runsilent then
              tempra.autoupg:=false;
            tempra.savetoreg;
            updatelvs(nil);
            end;
          end
        else
          begin
          showmessagenotsilent(tempra.name+' installation unsuccessful.');
          tempra.qstatus:=qsNotqueued;
          if not s.runsilent then
            tempra.autoupg:=false;
          tempra.savetoreg;
          updatelvs(nil);
          end;
        end;
      end
    else
      begin
      showmessagenotsilent('Installation cancelled.');
      end;
    end;
  end;
starttimers;
end;




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
CAption:=clientCaption;
startup:=true;
startup2:=true; // for queue items that are set to receiving
revertingnow:=false;
application.helpfile:=s.rcpath+'usuite.hlp';
assoccheck('.upg');
assoccheck('.rdp');
assignhints;
end;

{ get highlighted Project, if any }
procedure Tmainfm.timQueueTimer(Sender: TObject);
begin
timQueue.enabled:=false;
if (not UpdatingListviews) and
   (not ProcessingAutoUpgrades) and
   (not ProcessingScheduling) and
   (not ProcessingUpgradeFile) and
   (not QueuingApp) and
   (not ProcessingQueueItem) then
  begin
  try
  { make sure queue running is showing }
  sb1.panels[1].text:='Queue Running';
  if lv1.items.count>0 then
    begin
    if lv1.topitem<>nil then
      begin
      try
      if getliqs(lv1.topitem)=qsWaiting then
        begin
        ProcessingQueueItem:=true;
        getqdapp;
        ProcessingQueueItem:=false;
        updatelvs(nil);
        end;
      except
      end;
      end;
    end;
  except
  end;
  end;
timQueue.enabled:=true;
end;

procedure Tmainfm.Exit1Click(Sender: TObject);
begin
close;
end;



procedure Tmainfm.timUpdateFileTimer(Sender: TObject);
var
  ts:string;
  ids:string;
  fl:textfile;
begin
if (not UpdatingListviews) and
   (not ProcessingAutoUpgrades) and
   (not ProcessingScheduling) and
   (not ProcessingQueueItem) and
   (not ProcessingUpgradeFile) then
  begin
  ProcessingUpgradeFile:=true;
  timUpdateFile.enabled:=false;
  try
  { check for update }
  ts:=makedpath(s.rcpath)+updatefile;
  if fileexists(ts) then
    begin
    assignfile(fl,ts);
    reset(fl);
    readln(fl,ids);
    closefile(fl);
    { maybe should save first? }
    { update lv's }
{    if updatelvs(nil)=false then
      showmessagenotsilent('Error 123. Could not update views.');}
    { delete file }
    deletefile(ts);
    if ids<>'' then
      begin
      application.restore;
      application.bringtofront;
      queueapp(ids,true);
      end;
    end;
  finally
  timUpdateFile.enabled:=true;
  end;
  ProcessingUpgradeFile:=false;
  end;
end;

procedure Tmainfm.tbt3Click(Sender: TObject);
begin
queuemovedown;
end;

procedure tmainfm.showhint(sender:tobject);
var
  ts:string;
  posn,oldposn:integer;
begin
m1.lines.clear;
ts:=application.hint;
posn:=0;
oldposn:=0;
if ts<>'' then
  begin
  while posn<>length(ts) do
    begin
    inc(posn);
    if (ts[posn]='.') or (posn=length(ts)) then
      begin
      m1.lines.add(copy(ts,oldposn+1,posn-oldposn));
      m1.lines.adD('');
      oldposn:=posn;
      end;
    end;
  end;
end;

function tmainfm.updatelvs(sel:tlistitem):boolean;
var
	tempra:trecapp;
  cnt,cntm:integer;
  tsl:tstringlist;
  reg:tregistry;
  tli:tlistitem;
  selid:string;
  sellv:tlistview;
  thisonce:boolean;
begin
thisonce:=false;
if startup2 then
  begin
  startup2:=false;
  thisonce:=true;
  end;
result:=true;
try
{ get selected }
if (not UpdatingListViews) and
   //(not ProcessingQueueItem) and
   (not ProcessingAutoUpgrades) and
   (not ProcessingScheduling) and
   (not ProcessingUpgradeFile) then
  begin
  UpdatingListViews:=true;
  if sel<>nil then
    begin
    sellv:=tlistview(sel.listview);
    selid:=getid(sel);
    end
  else
    begin
    sellv:=nil;
    selid:='';
    end;

  { go through each lv list and add/remove as necessary according to registry settings }
  reg:=tregistry.create;
  tsl:=tstringlist.create;
  tempra:=trecapp.create;

  lv1.Items.Clear;
  lv2.items.clear;
  lv3.items.clear;
  lv4.items.clear;

  reg.RootKey:=HKEY_LOCAL_MACHINE;
  reg.openkey(recprojroot,true);
  reg.GetKeyNames(tsl);
  { remove .pbu }
  if tsl.count>0 then
    begin
    removeexts(tsl);
    cntm:=tsl.count-1;
    { this could be really modularized and optimized }
    for cnt:=0 to cntm do
      begin
      tempra.loadfromreg(tsl[cnt]);
      if tempra.inststatus=isinstalled then
        begin
        { add to lv2 }
        if tempra.id<>'' then
          begin
          tli:=lv2.Items.add;
          loadlistitem(tempra,tli);
          end;
        end
      else
        begin
        { add to lv3 }
        if tempra.id<>'' then
          begin
          tli:=lv3.Items.Add;
          loadlistitem(tempra,tli);
          end;
        end;
      if (tempra.qstatus<>qsnotqueued) and (tempra.qstatus<>qsunknown) then
        begin
        { add to lv1 }
        if tempra.id<>'' then
          begin
          tli:=lv1.items.add;
          if thisonce and (tempra.qstatus=qsinstalling) then
            begin
            tempra.qstatus:=qsWaiting;
            tempra.savetoreg;
            updatelvs(nil);
            end;
          loadlistitemq(tempra,tli);
          end;
        end;
      end;
    end;
  tempra.free;
  tsl.free;
  reg.closekey;
  reg.free;


  { do lv4 update }
  flb1.directory:=s.rdpath;
  flb1.update;
  flb1.filetype:=[ftnormal,ftreadonly];
  flb1.mask:='*.rdp';
  cntm := flb1.items.count-1;
  for cnt := 0 to cntm do    // Iterate
    begin
    tli:=lv4.items.add;
    loadlistitemr(s.rdpath+flb1.Items[cnt],tli);
    end;    // for

  { highlight selected item }
  if sellv<>nil then
    begin
    sellv.selected:=getli(sellv,selid);
    sellv.ItemFocused:=getli(sellv,selid);
    end
  else
    begin
    sellv:=getvislv;
    if sellv.Items.count>0 then
      sellv.itemfocused:=sellv.topitem;
    end;
  application.processmessages;
  UpdatingListViews:=false;
  end;
except
result:=false;
showmessagenotsilent('Error 126. Could not update views.');
end;
end;



procedure Tmainfm.StartClick(Sender: TObject);
begin
queuestart;
end;

procedure Tmainfm.tbt10Click(Sender: TObject);
begin
queuestop;
end;

procedure Tmainfm.tbt6Click(Sender: TObject);
begin
projcheck(lv2);
end;

{ install project right away }
procedure Tmainfm.tbt9Click(Sender: TObject);
begin
projinstall(lv3);
end;

procedure Tmainfm.tbt8Click(Sender: TObject);
begin
projredeploy(lv2,true);
end;

procedure Tmainfm.lv2Click(Sender: TObject);
var
  ts:string;
  tempra:trecapp;
  cnt,cntm:integer;
begin
tempra:=trecapp.create;
{ check all checkboxes }
cntm:=lv2.items.count-1;
for cnt:=0 to cntm do
	begin
  ts:=lv2.items[cnt].subitems[5];
  tempra.loadfromreg(ts);
  tempra.autoupg:=lv2.items[cnt].checked;
  end;
{ save the item and reload the lot }
tempra.savetoreg;
tempra.Free;
updatelvs(lv2.selected);
end;


procedure Tmainfm.lv3Click(Sender: TObject);
var
  ts:string;
  tempra:trecapp;
  cnt,cntm:integer;
begin
tempra:=trecapp.create;
{ check all checkboxes }
cntm:=lv3.items.count-1;
for cnt:=0 to cntm do
	begin
  ts:=lv3.items[cnt].subitems[5];
  tempra.loadfromreg(ts);
  tempra.autoupg:=lv3.items[cnt].checked;
  end;
{ save the item and reload the lot }
tempra.savetoreg;
tempra.Free;
updatelvs(lv3.selected);
end;

procedure Tmainfm.FormShow(Sender: TObject);
begin
formshowaction;
end;

procedure Tmainfm.FileSaver1Click(Sender: TObject);
begin
fsavefm.show;
end;


procedure Tmainfm.tbt11Click(Sender: TObject);
begin
projupgrade(lv2);
end;

procedure Tmainfm.tbt12Click(Sender: TObject);
begin
projcheck(lv3);
end;

procedure Tmainfm.tbt7Click(Sender: TObject);
begin
projuninstall(lv2);
end;

procedure Tmainfm.tbt2Click(Sender: TObject);
begin
queuemoveup;
end;

procedure Tmainfm.tbt4Click(Sender: TObject);
begin
queueremove;
end;

procedure Tmainfm.tbt5Click(Sender: TObject);
begin
projrun(lv2);
end;

procedure Tmainfm.tbt15Click(Sender: TObject);
begin
projemail(lv2);
end;

procedure Tmainfm.tbt14Click(Sender: TObject);
begin
projwebsite(lv2);
end;


procedure Tmainfm.AboutUpgradeReceiver1Click(Sender: TObject);
begin
aboutbox.showmodal;
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

procedure Tmainfm.tbt16Click(Sender: TObject);
begin
projreadmelatest(lv3);
end;

procedure Tmainfm.ProxyFirewallSettings1Click(Sender: TObject);
begin
fwallfm.showmodal;
end;

procedure Tmainfm.tbt17Click(Sender: TObject);
begin
projmirror(lv4);
end;

function Tmainfm.projcheck(lv:tlistview): boolean;
var
	tempra:trecapp;
  id:string;
  res:integer;
  ts:string;
begin
stopTimers;
{ check install }
result:=false;
if lvsel(lv,lv.selected) then
  begin
  id:=getid(lv.Selected);
  if id<>'' then
    begin
    { offer to get latest pdf }
    if s.runsilent then
      res:=mryes
    else
      res:=messagedlg('Do you want to get the latest Project Definition File?',mtconfirmation,[mbyes,mbno],0);
    tempra:=trecapp.create;
    tempra.loadfromreg(id);
    Screen.Cursor := crHourGlass;
    if res=mryes then
      begin
      clearrectemp;
      if lv=lv4 then
        ts:=tempra.getlatestpdf(http1,ftp1,rectemppath,s.rdpath,autosetfm.c5.checked)
      else
        ts:=tempra.getlatestpdf(http1,ftp1,rectemppath,s.projpath,autosetfm.c5.checked);
      if ts<>'' then
        if fileexists(ts) then
          begin
          { something here may allow for a project to change it's ID? }
          acceptfile(ts,true);
          tempra.loadfromreg(tempra.id);
          end
        else
          showmessagenotsilent('Downloaded but then lost latest Project Definition File.')
      else
        begin
        showmessagenotsilent('Could not get latest Project Definition File.');
        if not s.runsilent then
          tempra.autoupg:=false;
        tempra.savetoreg;
        end;
      end;
    { checkinstall }
    tempra.checkinstall(s.projpath);
  	Screen.Cursor := crDefault;
    result:=true;
    end;
  updatelvs(nil);
  end;
starttimers;
end;

function Tmainfm.projuninstall(lv:tlistview): boolean;
var
	res:integer;
  ts:string;
  tempra:trecapp;
begin
result:=false;
{ uninstall Project }
if lvsel(lv,lv.selecteD)  then
  begin
  if (lv.selected.listview=lv2) or (lv.selected.listview=lv3) then
    begin
    ts:=getid(lv.selected);
    if ts<>'' then
      begin
      tempra:=trecapp.create;
      tempra.loadfromreg(ts);
      res:=messagedlg('Are you sure you want to uninstall "'+tempra.name+'" ?',mtwarning,[mbyes,mbno],0);
      if res=mryes then
        begin
        result:=tempra.uninstall(s.projpath);
        { offer to get rid of backup }
        ts:=tempra.backupid;
        if ts<>'' then
          begin
          if isprojinstalled(ts) then
            begin
            res:=messagedlg('Do you want to delete the backed up version of this Project?',mtconfirmation,[mbyes,mbno],0);
            if res=mryes then
              begin
              tempra.loadfromreg(ts);
              tempra.uninstall(s.projpath);
              end;
            end;
          end;
        end;
      tempra.free;
      end;
    updatelvs(nil);
    end
  else
    begin
    showmessagenotsilent('You cannot Uninstall from here.');
    end;
  end;
end;

function Tmainfm.projupgrade(lv:tlistview): boolean;
var
  res: integer;
  tempra:trecapp;
  ts:string;
  tempid:string;
begin
stoptimers;
result:=false;
//goon:=true;
if lvsel(lv,lv.selected) then
	begin
  tempra:=trecapp.create;
  tempid:=getid(lv.selected);
  if tempid='' then
    begin
    showmessagenotsilent('Error during Project Upgrade. Operation cancelled.');
    end
  else
    begin
    tempra.loadfromreg(getid(lv.selected));
    { check install }
    clearrectemp;
    if lv=lv4 then
      ts:=tempra.getlatestpdf(http1,ftp1,rectemppath,s.rdpath,autosetfm.c5.checked)
    else
      ts:=tempra.getlatestpdf(http1,ftp1,rectemppath,s.projpath,autosetfm.c5.checked);
    if ts<>'' then
      begin
      if fileexists(ts) then
        begin
        acceptfile(ts,true);
        tempra.loadfromreg(tempra.id);
        tempra.checkinstall(s.projpath);
        updatelvs(nil);
        res:=mryes;
        if tempra.verstatus=vsuptodate then
          begin
          { if installed then offer to update }
          if s.runsilent then
            res:=mryes
          else
            res:=messagedlg('The latest version of this Project has been already installed. Continue anyway?',mtconfirmation,[mbyes,mbno],0);
          end;
        { install }
        if res=mryes then
          begin
          { add to the queue }
          queueapp(tempra.id,false);
          end;
        result:=true;
        end
      else
        begin
        showmessagenotsilent('Downloaded but then lost latest Project Definition File.')
        end
      end
    else
      begin
      showmessagenotsilent('Could not get latest Project Definition File.');
      end;
    tempra.free;
    end;
  end;
starttimers;
end;

function tmainfm.projbackup(id:string):boolean;
var
	oldra:trecapp;
  newra:trecapp;
  newap:tap;
  oldap:tap;
  goon:boolean;
begin
result:=false;
goon:=true;
oldra:=trecapp.create;
oldap:=tap.create;
newap:=tap.create;
{ create/regify backup project }
{ you don't backup redeployments because they aren't
	installed }
if oldap.loadfromfile(s.projpath+id) then
	begin
  if oldra.loadfromreg(id) then
    begin
    { check if installed }
    oldra.checkinstall(s.projpath);
    updatelvs(nil);
    if oldra.inststatus=isUnInstalled then
      begin
      showmessagenotsilent('Cannot back up Project because it is not fully installed.');
      goon:=false;
      end;
    if (oldra.inststatus=isPartUnInstalled) or (oldra.inststatus=isPartInstalled) then
      begin
      showmessagenotsilent('Cannot back up Project because it is not fully installed.');
      goon:=false;
      end;
    end
  else
    begin
    goon:=false;
    end;
  end
else
	begin
  goon:=false;
  end;

if goon then
	begin
  newap.makebackup(oldap);
  oldra.backupid:=newap.id;
  newap.ownloc:=oldap.ownloc;
  oldra.savetoreg;
  updatelvs(nil);
  newap.savetofile;
  if not fileexists(newap.ffname) then
    begin
    goon:=false;
    showmessagenotsilent('Upgrade Suite Client has lost the new Project Definition File.');
    end
  else
    begin
    newra:=trecapp.create;
    newra.regify(newap.ffname);
    newra.autoupg:=false;
    newra.installdir:=oldra.installdir;
    newra.savetoreg;
    updatelvs(nil);
    newap.bucketdir:=oldra.installdir;
    newap.deflocdir:=oldra.installdir;
    //newap.savetofile;
    newra.free;
    end;
  end;
if goon then
  begin
  if not newap.compile(recstagepath,false,'Preparing Backup',false,true) then
    begin
    showmessagenotsilent('Preparation of Project Backup was not successful. Backup failed.');
    end
  else
    begin
    newap.deploy(recstagepath,true,true,true,'Deploying Backup',false,false,'',S.xmRunSilent,s.xmCloseEnd,false);
    newap.clearstagingarea(recstagepath,'Click yes to complete Project Backup.',true);
    result:=true;
    end;
  end;
newap.free;
oldap.free;
oldra.free;
end;

function Tmainfm.projrevert(lv:tlistview): boolean;
var
	id:string;
  oldra:trecapp;
  newra:trecapp;
  buid:string;
  oldap:tap;
  bufn:string;
begin
result:=false;
if lvsel(lv,lv.selected) then
	begin
  stopTimers;
  id:=getid(lv.selected);
  { revert to previous version }
  oldra:=trecapp.create;
  oldra.loadfromreg(id);
  { check if there is a backup version }
  buid:=oldra.backupid;
  if buid='' then
    begin
    showmessagenotsilent('"'+oldra.name+'" does not have a backup.');
    end
  else
  	begin
    { may need to check if deployed }
    { turn off auto update }
    oldra.savetoreg;
    updatelvs(nil);

    bufn:=makedpath(s.bupath)+makedpath(buid)+buid;
    if not fileexists(bufn) then
      begin
      showmessagenotsilent('Back-up Project Definition File does not exist.');
      end
    else
      begin
      acceptfile(bufn,true);

      newra:=trecapp.create;
      newra.loadfromreg(buid);
      revertingnow:=true;
      result:=newra.install(http1,ftp1,true,makedpath(s.bupath)+buid,autosetfm.c5.checked);
      updatelvs(nil);
      oldra.checkinstall(s.projpath);
      updatelvs(nil);
      oldra.instver:=newra.latver;
      newra.free;
      if (oldra.inststatus=isInstalled) and (oldra.verstatus<>vsUptodate) then
        begin
        if rebootnow=true then
          begin
          showmessagenotsilent('You must reboot your computer to complete this Reversion.');
          result:=true;
          rebootnow:=false;
          end
        else
          begin
          showmessagenotsilent('Reversion complete.');
          result:=true;
          end;
        end
      else
        begin
        if (oldra.inststatus<>isInstalled) then
          begin
          showmessagenotsilent('Reversion failed.');
          end;
        end;
      revertingnow:=false;
      { makerevert out of ap file }
  //    newra.regify(s.projpath+id);
  //    //newra.checkinstall(s.projpath);
  //    newra.instver:=oldra.latver;
  //    newra.savetoreg;
  //    newra.free;
      oldra.backupid:=buid;
      oldra.savetoreg;
      updatelvs(nil);
      { check for automirror }
      if oldra.automirror then
        begin
        if oldra.redeploy<>'' then
          begin
          oldap:=tap.create;
          if oldap.loadfromfile(s.rdpath+oldra.redeploy) then
            begin
            oldap.loadserfromfile(s.rdpath+oldra.redeploy+'.ser');
            oldap.mirror(recstagepath,oldra.instver);
            oldap.savetofile;
            end;
          oldap.free;
          end;
        end;
      end;
    end;
  oldra.free;
  updatelvs(nil);
  starttimers;
  end;
end;


procedure Tmainfm.tbt13Click(Sender: TObject);
begin
projreadme(lv2);
end;

function Tmainfm.projreadme(lv:tlistview): boolean;
{ view readme file }
var
	id,ts:String;
  tempra:trecapp;
  ap:tap;
  res:integer;
  goon:boolean;
begin
goon:=true;
result:=false;
{ retrieve readme from Project }
{ view readme }
if lvsel(lv,lv.selected) then
	begin
  id:=getid(lv.selected);
  if id<>'' then
  	begin
    tempra:=trecapp.create;
    tempra.loadfromreg(id);
    ap:=tap.create;
    ap.loadfromfile(s.projpath+id);
    goon:=true;
    if ap.readmefile='' then
    	begin
      showmessagenotsilent('There is no Readme file for this Project.');
      goon:=false;
      end;
    if goon then
    	begin
	    ts:=makedpath(tempra.installdir)+ap.readmefile;
  	  if not fileexists(ts) then
    		begin
      	showmessagenotsilent('Could not find Readme file. Make sure Project is installed and up to date.');
        goon:=false;
        end;
      end;
    if goon then
    	begin
      if shellexecute(0,'open',pchar(ts),nil,pchar(tempra.installdir),SW_SHOWNORMAL)<=32 then
        begin
        if s.runsilent then
          res:=mryes
        else
          res:=messagedlg('Could not open file '+ap.readmefile+' in associated application. Use Notepad instead?',mtconfirmation,[mbyes,mbno],0);
        if res=mryes then
          begin
          if shellexecute(0,'open','notepad.exe',pchar(ts),pchar(s.windir),0)>32 then
          	result:=true;
          end;
        end
      else
      	begin
        result:=true;
        end;
      end;
    ap.free;
    tempra.free;
    result:=true;
    end;
  end;
end;

function Tmainfm.projemail(lv:tlistview): boolean;
var
	id,ts:string;
  tempap:tap;
begin
result:=false;
{ email vendor }
if lvsel(lv,lv.selected) then
	begin
  id:=getid(lv.selected);
  tempap:=tap.create;
  tempap.loadfromfile(s.projpath+id);
  ts:=tempap.vendemail;
  if ts='' then
    begin
    showmessagenotsilent('Project Administrator did not include an email address in the Project Definition. Check inside the program or it''s documentation for contact details.');
    end
  else
    begin
    gtw1.url:='mailto:'+ts;
    if gtw1.execute=false then
      begin
      showmessagenotsilent('Error 209. Could not open default email program to email Project Administrator.'+#13#10#13#10 +
      'Email Project Administrator at this email address: '+ts);
      end
    else
      begin
      result:=true;
      end;
    end;
  tempap.free;
  end;
end;

function Tmainfm.projwebsite(lv:tlistview): boolean;
var
	id,ts:string;
  tempap:tap;
begin
result := False;
{ goto vendor's website }
if lvsel(lv,lv.selected) then
	begin
  id:=getid(lv.selected);
  tempap:=tap.create;
  tempap.loadfromfile(s.projpath+id);
  ts:=tempap.vendwebsite;
  if ts='' then
    begin
    showmessagenotsilent('Project Administrator did not include an web address in the Project Definition. Check inside the program or it''s documentation for contact details.');
    end
  else
    begin
    gtw1.url:=ts;
    if gtw1.execute=false then
      begin
      showmessagenotsilent('Error 210. Could not open default web browser to go to Project Administrator''s website.'+#13#10#13#10 +
      'Project Administrator''s website is at: '+ts);
      end
    else
      begin
      result:=true;
      end;
    end;
  tempap.free;
  end;
end;

function Tmainfm.projredeploy(lv:tlistview;wt:boolean): boolean;
var
	oldra,newra:trecapp;
  oldap,newap:tap;
  oldapfile,oldserfile:string;
  id:string;
  rid:string;
  goon:boolean;
  dlt:turltype;
  oldqueue:boolean;
begin
oldqueue:=timQueue.enabled;
if oldqueue then
  queuestop;
result:=false;
goon:=true;
if lvsel(lv,lv.selected) then
	begin
	oldra:=trecapp.create;
//  newra:=trecapp.create;
	id:=getid(lv.selected);
  oldra.loadfromreg(id);
  newap:=tap.create;
  oldap:=tap.create;
  oldapfile:=makedpath(s.rdpath)+oldra.redeploy;
  oldserfile:=oldapfile+'.ser';
  oldap.loadfromfile(s.projpath+id);
  if (oldra.redeploy<>'') and (fileexists(oldapfile)) and (fileexists(oldserfile)) then
    begin
    newap.loadfromfile(oldapfile);
    newap.loadserfromfile(oldserfile);
    end
  else
    begin
    newap.makeredeploy(oldap);
    end;
  { load values into remservfm }
  remservfm.ediServer.text:=newap.server;
  remservfm.e18.text:=newap.username;
  remservfm.e19.text:=newap.password;
  remservfm.ediDepDir.text:=newap.remdir;
  remservfm.rg1.itemindex:=newap.transtype;
  if remservfm.showmodal=mrok then
    begin
    newap.server:=remservfm.ediServer.text;
    newap.username:=remservfm.e18.text;
    newap.password:=remservfm.e19.text;
    newap.remdir:=remservfm.ediDepdir.text;
    newap.transtype:=remservfm.rg1.itemindex;
    dlt:=getdltype(newap.server);
    if (dlt=utFTP) or (dlt=utHTTP) then
      newap.baseurl:=makewpath(newap.server)+newap.remdir
    else
      newap.baseurl:=makedpath(newap.server)+newap.remdir;
    newap.ownloc:=newap.baseurl+newap.id;
    end
  else
    begin
    goon:=false;
    end;
  if goon then
    begin
    { new form }
    { load dets }
    newdetfm.e1.text:=oldap.vendwebsite;
    newdetfm.e2.text:=oldap.vendemail;
    newdetfm.e4.text:=oldap.baseurl;
    if oldap.zipfiles=1 then
      begin
      newdetfm.c1.checked:=true;
      end
    else
      begin
      newdetfm.c1.checked:=false;
      end;
    newdetfm.e3.text:=inttostr(oldap.ugdepth);
    if newdetfm.showmodal=mrOK then
      begin
      newap.ugdepth:=strtoint(newdetfm.e3.text);
      if newdetfm.c1.checked then
        begin
        newap.zipfiles:=1;
        end
      else
        begin
        newap.zipfiles:=0;
        end;
      newap.vendwebsite:=newdetfm.e1.text;
      newap.vendemail:=newdetfm.e2.text;
      newap.baseurl:=newdetfm.e4.text;
      end
    else
      begin
      goon:=false;
      end;
    end;
  if goon then
    begin
    newap.savetofile;
    newap.loadfromfile(newap.ffname);
    newap.loadserfromfile(newap.ffname+'.ser');
    newap.version:=oldra.instver;
    oldra.redeploy:=newap.id;
    oldra.savetoreg;
    updatelvs(nil);
    newap.redeploy(recstagepath,wt);
    end
  else
    begin
    showmessagenotsilent('Redeployment Cancelled');
    goon:=false;
    end;
	oldra.free;
  oldap.free;
  newap.free;
  updatelvs(nil);
  end;
if oldqueue then
  queuestart;
end;

function Tmainfm.projreadmelatest(lv:tlistview): boolean;
{ retrieve latest readme file and view it}
var
	id:String;
  tempar:trecapp;
begin
stoptimers;
result := False;
{ retrieve readme from Project }
{ view readme }
if lvsel(lv,lv.selected) then
	begin
  id:=getid(lv.selected);
  if id<>'' then
  	begin
    tempar:=trecapp.create;
    tempar.loadfromreg(id);
    tempar.getviewlatestreadme(http1,ftp1,autosetfm.c5.checked);
    tempar.free;
    result := True;
    end;
  end;
starttimers;
end;

function Tmainfm.projinstall(lv:tlistview): boolean;
var
	tempra:trecapp;
  //goon:boolean;
  res:integer;
  tempid:string;
begin
//goon:=true;
result := False;
if lvsel(lv,lv.selected) then
	begin
  tempra:=trecapp.create;
  tempid:=getid(lv.selected);
  if tempid='' then
    begin
    showmessagenotsilent('Error during Project Install. Operation cancelled.');
    end
  else
    begin
    tempra.loadfromreg(getid(lv.selected));
    { check install }
    tempra.checkinstall(s.projpath);
    updatelvs(nil);
    res:=mryes;
    if tempra.inststatus=isinstalled  then
      begin
      { if installed then offer to update }
      if s.runsilent then
        res:=mryes
      else
        res:=messagedlg('This Project is already installed. Do you want to bring all the files up to date?',mtconfirmation,[mbyes,mbno],0);
      end;
    { install }
    if res=mryes then
      begin
      { add to the queue }
      queueapp(tempra.id,false);
      end;
    tempra.free;
    result := True;
    end;
  end;
end;

function tmainfm.getvislv:tlistview;
begin
result:=nil;
if pc1.activepage=tsinst then
	result:=lv2
else if pc1.activepage=tsunin then
	result:=lv3
else if pc1.activepage=tsqueue then
	result:=lv1
else if pc1.activepage=tsredep then
  result:=lv4;
end;

procedure Tmainfm.Run1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if (lv<>nil) and (lv<>lv4) then
	projrun(lv);
end;

procedure Tmainfm.Readme1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if getvislv<>nil then
	projreadme(lv);
end;

procedure Tmainfm.Readme2Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projreadmelatest(lv);
end;

procedure Tmainfm.Website1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projwebsite(lv);
end;

procedure Tmainfm.Email1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projemail(lv);
end;

procedure Tmainfm.Install1Click(Sender: TObject);
var
	lv:Tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projinstall(lv);

end;

procedure Tmainfm.Check2Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projcheck(lv);
end;

procedure Tmainfm.Upgrade1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projupgrade(lv);
end;

procedure Tmainfm.Revert1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projrevert(lv);
end;

procedure Tmainfm.Uninstall1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projuninstall(lv);
end;

procedure Tmainfm.Redeploy1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projredeploy(lv,true);
end;

function Tmainfm.getliqs(li:tlistitem): tqstatus;
begin
result:=qsUnknown;
if (li<>nil) and (li.ListView=lv1) then
	result:=eng2qs(li.subitems[0]);
end;

function Tmainfm.getlivs(li:tlistitem): tverstatus;
begin
result:=vsUnknown;
if (li<>nil) and (li.ListView<>lv1) then
	result:=eng2vs(li.subitems[2]);
end;

function Tmainfm.getliis(li:tlistitem): tinststatus;
begin
result:=isUnknown;
if (li<>nil) and (li.ListView<>lv1) then
	result:=eng2is(li.subitems[3]);
end;

function Tmainfm.isinstalling(li:tlistitem): boolean;
begin
result:=false;
if li<>nil then
	if getliqs(li)=qsInstalling then
  	result:=true;
end;

function Tmainfm.setsaveqs(li:tlistitem;qs:tqstatus): boolean;
var
	id:string;
  tempra:trecapp;
begin
result := False;
id:=getid(li);
if id<>'' then
	begin
  //updatelvs(li.listview.selected);
  tempra:=trecapp.create;
  tempra.loadfromreg(id);
  tempra.qstatus:=qs;
  tempra.savetoreg;
  updatelvs(li.ListView.Selected);
  tempra.free;
  result := True;
  end;
end;

function Tmainfm.setsaveis(li:tlistitem;ins:tinststatus): boolean;
var
	id:string;
  tempra:trecapp;
begin
result := False;
id:=getid(li);
if id<>'' then
	begin
  //updatelvs(li.listview.selected);
  tempra:=trecapp.create;
  tempra.loadfromreg(id);
  tempra.inststatus:=ins;
  tempra.savetoreg;
  updatelvs(li.listview.selected);
  tempra.free;
  result := True;
  end;
end;

function Tmainfm.setsavevs(li:tlistitem;vs:tverstatus): boolean;
var
	id:string;
  tempra:trecapp;
begin
result := False;
id:=getid(li);
if id<>'' then
	begin
  //updatelvs(li.listview.selected);
  tempra:=trecapp.create;
  tempra.loadfromreg(id);
  tempra.verstatus:=vs;
  tempra.savetoreg;
  updatelvs(li.listview.selected);
  tempra.free;
  result := True;
  end;
end;

function tmainfm.getid(li:tlistitem):string;
begin
result:='';
if li<>nil then
  begin
	if li.ListView=lv1 then
    begin
  	result:=li.subitems[2];
    end
  else
    begin
    if (li.listview=lv2) or (li.listview=lv3) then
      begin
  		result:=li.SubItems[5];
      end
    else
      begin
      if (li.listview=lv4) then
        begin
        result:=li.subitems[2];
        end
      end;
    end;
  end;
end;

function Tmainfm.loadlistitem(tempra:trecapp;var li:tlistitem):boolean;
begin
result:=false;
if tempra.id<>'' then
  begin
  li.caption:='';
  li.subitems.adD(tempra.name);
  li.subitems.add(tempra.instver);
  li.subitems.add(tempra.vs2eng(tempra.verstatus));
  li.subitems.adD(tempra.is2eng(tempra.inststatus));
  li.subitems.adD(tempra.installdir);
  li.subitems.add(tempra.id);
  li.checked:=tempra.autoupg;
  result:=true;
  end;
end;

function Tmainfm.loadlistitemq(tempra:trecapp;var li:tlistitem):boolean;
begin
result:=false;
if tempra.id<>'' then
  begin
  tempra.loadfromreg(tempra.id);
  li.caption:=tempra.name;
  li.SubItems.add(tempra.qs2eng(tempra.qstatus));
  li.subitems.adD(tempra.installdir);
  li.subitems.add(tempra.id);
  result:=true;
  end;
end;

function Tmainfm.getli(lv:tlistview;id:string): tlistitem;
var
	cnt,cntm:integer;
begin
result:=nil;
if lv<>nil then
	begin
  cntm:=lv.Items.count-1;
  for cnt := 0 to cntm do    // Iterate
    begin
    if getid(lv.Items[cnt])=id then
      result:=lv.items[cnt];
    end;    // for
	end;
end;

procedure Tmainfm.lv3Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
if not UpdatingListViews then
  setsaveautoupgrade(item);
end;

function Tmainfm.setsaveautoupgrade(li:tlistitem): boolean;
var
	id:string;
  tempra:trecapp;
begin
result := False;
if ((li.listview=lv2)or (li.listview=lv3)) and (li.subitems.count=6) then
	begin
  id:=getid(li);
  if id<>'' then
    begin
    if isidregified(id) then
      begin
      tempra:=trecapp.create;
      tempra.loadfromreg(id);
      if tempra.autoupg<>li.checked then
        begin
        tempra.autoupg:=li.checked;
        tempra.savetoreg;
        updatelvs(nil);
        end;
      tempra.free;
      end;
    end;
  end;
end;

function Tmainfm.setsaveautomirror(li:tlistitem): boolean;
var
	id:string;
  tempra:trecapp;
begin
result:=true;
if (li.listview=lv4) and (li.subitems.count=3) then
	begin
  id:=getid(li);
  if id<>'' then
    begin
    tempra:=trecapp.create;
    { to get actual Project's automirror }
    id:=extractfilenamenoext(id);
    tempra.loadfromreg(id);
    if tempra.automirror<>li.checked then
      begin
      tempra.automirror:=li.checked;
      tempra.savetoreg;
      updatelvs(li.listview.selected);
      end;
    tempra.free;
    end;
  end;
end;

procedure Tmainfm.lv2Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
if not UpdatingListViews then
  setsaveautoupgrade(item);
end;

procedure Tmainfm.Backup1Click(Sender: TObject);
var
	id:string;
  lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	begin
  if lvsel(lv,lv.selected) then
  	begin
	  id:=getid(lv.selected);
		projbackup(id);
    end;
  end;
end;

procedure Tmainfm.Mirror1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projmirror(lv);
end;

function Tmainfm.projmirror(lv:tlistview): boolean;
var
	tempra:trecapp;
  goon:boolean;
  id,rid:string;
  oldra:trecapp;
  newap:tap;
  oldqueue:boolean;
begin
goon:=true;
oldqueue:=timQueue.enabled;
if oldqueue then
  queuestop;
tempra:=trecapp.create;
if (lvsel(lv,lv.selected))and (lv<>lv1) then
  begin
  if lv=lv4 then
    begin
    { get id }
    id:=getid(lv.selected);
    { don't know about this }
    tempra.loadfromreg(extractfilenamenoext(id));
    end
  else
    begin
    id:=getid(lv.selected);
    tempra.loadfromreg(id);
    id:=tempra.redeploy;
    end;
  if id='' then
	  goon:=false;
  { check if redeployed }
  if goon then
	  begin
    if lvsel(lv,lv.selected) then
      begin
      newap:=tap.create;
      goon:=newap.loadfromfile(s.rdpath+id);
      if goon then
        begin
        goon:=newap.loadserfromfile(s.rdpath+id+'.ser');
        end;
      if goon then
        begin
        newap.version:=tempra.instver;
        newap.mirror(recstagepath,newap.version);
        newap.savetofile;
        end;
      newap.free;
      end;
    end
  else
    begin
    showmessagenotsilent('"'+tempra.name+'" has not been Redeployed.');
    end;
  updatelvs(nil);
  end;
tempra.free;
if oldqueue then
  queuestart;
end;

procedure Tmainfm.tbt18Click(Sender: TObject);
begin
projremove(lv4);
end;

procedure Tmainfm.tbt19Click(Sender: TObject);
begin
{ pull down a redeployment }
if (lvsel(lv4,lv4.selected))then
  if lv4.selected<>nil then
	  projpulldown(lv4);
end;

function Tmainfm.projpulldown(lv:tlistview): boolean;
var
  ap: tap;
  rid:string;
  id:string;
  tempra:trecapp;
  goon:boolean;
begin
goon:=false;
{ pull down a redeployment }
if (lvsel(lv,lv.selected)) and (lv=lv2) then
	begin
  tempra:=trecapp.create;
  id:=getid(lv.Selected);
  tempra.loadfromreg(id);
  rid:=tempra.redeploy;
  tempra.free;
  goon:=true;
  tempra.redeploy:='';
  tempra.savetoreg;
  updatelvs(nil);
  end;
if (lvsel(lv,lv.selected)) and (lv=lv4) then
	begin
  rid:=getid(lv.selected);
  goon:=true;
  end;
if goon then
	begin
  ap:=tap.create;
  ap.loadfromfile(s.rdpath+rid);
	ap.pulldown(recstagepath,false,s.xmRunSilent,s.xmCloseEnd);

  end;
end;

procedure Tmainfm.PullDown1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lvsel(lv,lv.selected) then
	projpulldown(lv);
end;

function Tmainfm.loadlistitemr(fname:string;tli:tlistitem): boolean;
var
	ap:tap;
  tempra:trecapp;
begin
result:=false;
ap:=tap.create;
if ap.loadfromfile(fname) then
  begin
  tempra:=trecapp.create;
  tempra.loadfromreg(extractfilenamenoext(ap.id));
  tli.caption:='';
  tli.subitems.add(ap.nname);
  tli.subitems.add(ap.version);
  tli.SubItems.add(ap.id);
  tli.checked:=tempra.automirror;
  tempra.free;
  result:=true;
  end;
ap.free;
end;


procedure Tmainfm.lv4Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
setsaveautomirror(item);
end;

procedure Tmainfm.lv2DblClick(Sender: TObject);
begin
projrun(lv2);
end;

procedure Tmainfm.lv3DblClick(Sender: TObject);
begin
projinstall(lv3);
end;

procedure Tmainfm.lv4DblClick(Sender: TObject);
begin
{ mirror project }
if lv4.selected<>nil then
	projmirror(lv4);
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

procedure Tmainfm.pc1Change(Sender: TObject);
var
	lv:tlistview;
  procedure enablepi;
  var
    c,cm:integer;
  begin
  project1.enabled:=true;
  install2.enabled:=true;
  cm:=project1.count-1;
  for c:=0 to cm do
    begin
    tmenuitem(project1[c]).enabled:=true;
    end;
  cm:=install2.count-1;
  for c:=0 to cm do
    begin
    tmenuitem(install2[c]).enabled:=true;
    end;
  cm:=pme1.Items.count-1;
  for c:=0 to cm do
    begin
    tmenuitem(pme1.items[c]).enabled:=true;
    end;
  end;

  procedure disablepi;
  var
    c,cm:integer;
  begin
  cm:=project1.count-1;
  for c:=0 to cm do
    begin
    tmenuitem(project1[c]).enabled:=false;
    end;

  cm:=install2.count-1;
  for c:=0 to cm do
    begin
    tmenuitem(install2[c]).enabled:=false;
    end;

  cm:=pme1.Items.count-1;
  for c:=0 to cm do
    begin
    tmenuitem(pme1.items[c]).enabled:=false;
    end;
  end;

  procedure enableq;
  begin
  up1.enabled:=true;
  down1.enabled:=true;
  remove1.enabled:=true;
  end;

  procedure disableq;
  begin
  up1.enabled:=false;
  down1.enabled:=false;
  remove1.enabled:=false;
  end;

  procedure disablepi1;
  begin
  disablepi;
  project1.enabled:=false;
  install2.enabled:=false;
  end;

  procedure disablepi23;
  begin
  ClearStagingArea1.enabled:=false;
  ClearStagingArea2.enabled:=false;
  end;

  procedure disablepi4;
  begin
  disablepi;
  remove2.enabled:=true;
  removecompletely1.enabled:=true;
  mirror1.enabled:=true;
  pulldown1.enabled:=true;
  mirror2.enabled:=true;
  pulldown2.enabled:=true;
  ClearStagingArea1.enabled:=true;
  ClearStagingArea2.enabled:=true;
  end;

begin
lv:=getvislv;
if lv<>nil then
  begin
	if lv.Items.count>0 then
  	begin
    lv.itemfocused:=lv.TopItem;
    end;
  { enable / disable menu items }
  if (lv=lv2) or (lv=lv3) then
    begin
    { enable all menu items }
    enablepi;
    disablepi23;
    disableq;
    end;
  if (lv=lv1) then
    begin
    enablepi;
    disablepi1;
    enableq;
    { disable heaps of menu items }
    end;
  if (lv=lv4) then
    begin
    enablepi;
    disablepi4;
    disableq;
    { disable a fre menu items }
    end;
  end;


end;

procedure Tmainfm.Remove2Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projremove(lv);
end;

function Tmainfm.projremove(lv:tlistview): boolean;
var
	tempra:trecapp;
  ap:tap;
  res:integer;
  tempid:string;
  bres:boolean;
  goon:boolean;
  tli:tlistitem;
begin
result:=false;
goon:=true;
{ remove project from registry and projects directory }
if lvsel(lv,lv.selected) then
	begin
  tli:=lv.selected;
  tempid:=getid(tli);
  tempra:=trecapp.create;
  if tempid='' then
    begin
    showmessagenotsilent('Error during Project Removal. Operation cancelled.');
    end
  else
    begin
    if tli.ListView=lv4 then
      begin
      { remove redeployment }
      ap:=tap.create;
      ap.loadfromfile(makedpath(s.rdpath)+tempid);
      res:=messagedlg('Are you sure you want to completely remove "'+ap.nname+'" ?',mtconfirmation,[mbyes,mbno],0);
      if res=mryes then
        begin
        tempra.loadfromreg(extractfilenamenoext(tempid));
        tempra.redeploy:='';
        tempra.savetoreg;
        updatelvs(nil);
        ap.pulldown(recstagepath,true,s.xmRunSilent,s.xmCloseEnd);
        ap.projectdelete(recstagepath);
        end;
      ap.free;
      end
    else if (tli.listview=lv3) or (tli.listview=lv2) then
      begin
      tempra.loadfromreg(tempid);
      res:=messagedlg('Are you sure you want to completely remove "'+tempra.name+'" ?',mtconfirmation,[mbyes,mbno],0);
      if res=mryes then
        begin
        { first remove backup }
        if tempra.backupid='' then
          begin
          goon:=true;
          end
        else
          begin
          goon:=false;
          bres:=tempra.loadfromreg(tempra.backupid);
          if bres then
            begin
            res:=messagedlg('This Project is backed up. Do you want to continue, removing the back up?',mtconfirmation,[mbyes,mbno],0);
            if res=mryes then
              begin
              ap:=tap.create;
              ap.loadfromfile(s.projpath+tempra.id);
              ap.pulldown(s.bupath+ap.id,true,s.xmRunSilent,s.xmCloseEnd);
              ap.free;
              goon:=true;
              end
            else
              begin
              goon:=false;
              end
            end
          end;
        if goon then
          begin
          tempra.loadfromreg(tempid);
          { check install }
          tempra.checkinstall(s.projpath);
          updatelvs(nil);
          res:=mryes;
          if tempra.inststatus=isinstalled  then
            begin
            { if installed then offer to update }
            if s.runsilent then
              res:=mryes
            else
              res:=messagedlg('This Project is installed. Do you want to continue?',mtconfirmation,[mbyes,mbno],0);
            if res=mryes then
              tempra.uninstall(s.projpath);
            end;
          if res=mryes then
            begin
            { remove workarea}
            tempra.remworkarea;
            tempra.unregify;
            tempra.removepdf(s.projpath);
            result:=true;
            showmessagenotsilent('"'+tempra.name+'" Removal completed.'#13#10#13#10'This Project will no longer appear in the Upgrade Suite Client.');
            end;
          end;
        end;
      end;
    end;
  tempra.free;
  updatelvs(nil);
  end;
{ reload everything }
end;

procedure Tmainfm.Start1Click(Sender: TObject);
begin
queuestart;
end;

procedure Tmainfm.Stop1Click(Sender: TObject);
begin
queuestop;
end;

procedure Tmainfm.Up1Click(Sender: TObject);
begin
queuemoveup;
end;

procedure Tmainfm.Down1Click(Sender: TObject);
begin
queuemovedown;
end;

procedure Tmainfm.Remove1Click(Sender: TObject);
begin
queueremove;
end;

procedure Tmainfm.ShowResults1Click(Sender: TObject);
begin
viewfm.show;
end;

procedure Tmainfm.SetInstallDirectory1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projsetinstalldir(lv);
end;

function Tmainfm.projsetinstalldir(lv:tlistview): boolean;
var
  tempra:trecapp;
  tempid:string;
begin
result:=false;
if lvsel(lv,lv.selected) then
	begin
  tempra:=trecapp.create;
  tempid:=getid(lv.selected);
  if tempid='' then
    begin
    showmessagenotsilent('Error during setting of Project''s Install Directory. Operation cancelled.');
    end
  else
    begin
    tempra.loadfromreg(tempid);
    if directoryexists(tempra.installdir) then
      begin
      fdlg.Folder:=tempra.installdir;
      end;
    fdlg.LabelCaptions.clear;
    fdlg.LabelCaptions.add('Default=Select Installation Directory for Project');
    if fdlg.Execute then
      begin
      tempra.installdir:=makedpath(fdlg.Folder);
      tempra.savetoreg;
      updatelvs(nil);
      end;
    end;
  end;
end;

function tmainfm.readactionfile:boolean;
var
  actini:tinifile;
  ts:string;
  tempra:trecapp;
  tsl:tstringlist;
  cnt,cntm:integer;
begin
stoptimers;
actini:=tinifile.create(s.rcpath+'action.ini');
{ get list of regified ids }
tsl:=tstringlist.create;
actini.ReadSectionValues('install',tsl);
cntm:=tsl.count-1;
tempra:=trecapp.create;
for cnt := 0 to cntm do
  begin
  ts:=copy(tsl[cnt],1,length(tsl[cnt])-4) ;
  if isidregified(ts) then
    begin
    tempra.loadfromreg(ts);
    tempra.install(http1,ftp1,true,s.projpath,autosetfm.c5.checked);
    updatelvs(nil);
    tempra.checkinstall(s.projpath);
    updatelvs(nil);
    { remove from action file ? }
    actini.DeleteKey('install',ts);
    end;
  end;    // for
tempra.free;
tsl.free;
actini.free;
starttimers;
end;

function tmainfm.autoupgrade(scheduling:boolean):boolean;
var
  cnt,cntm:integer;
  res,res3: integer;
  tempra:trecapp;
  ts:string;
  ts2:string;
  res2:integer;
  tempid:string;

  procedure ugnow(li:tlistitem);
  var
    goon:boolean;
	begin
  tempid:=getid(li);
  if tempid='' then
    begin
    showmessagenotsilent('Error while AutoUpgrading. Operation cancelled.');
    end
  else
    begin
    tempra.loadfromreg(tempid);
    goon:=false;
    if scheduling then
      begin
      if (tempra.useScheduling) and
      ((tempra.ScheduleTime+tempra.ScheduleDate)<now) then
        goon:=true;
      end
    else
      begin
      if tempra.autoupg then
        goon:=true;
      end;
    if goon then
      begin
      { check install }
      clearrectemp;
      if li.listview=lv4 then
        ts:=tempra.getlatestpdf(http1,ftp1,rectemppath,s.rdpath,autosetfm.c5.checked)
      else
        ts:=tempra.getlatestpdf(http1,ftp1,rectemppath,s.projpath,autosetfm.c5.checked);
      if ts<>'' then
        begin
        if fileexists(ts) then
          begin
          acceptfile(ts,true);
          tempra.loadfromreg(tempra.id);
          tempra.checkinstall(s.projpath);
          updatelvs(nil);
          res:=mryes;
          if tempra.verstatus<>vsUptoDate then
            begin
            res2:=mryes;
            if (autosetfm.c3.checked) and (not s.runsilent) then
              begin
              application.restore;
              application.bringtofront;
              if tempra.latver='' then
                ts2:='New version '
              else
                ts2:='New version '+tempra.latver+' ';
              res2:=messagedlg(ts2+'of "'+tempra.name+'" is available. Current version is '+tempra.instver+'. Install new version?',mtconfirmation,[mbyes,mbno],0);
              end;
            if res2=mryes then
              begin
              queueapp(tempra.id,true);
              if timQueue.enabled=false then
                begin
                if s.runsilent then
                  res3:=mryes
                else
                  res3:=messagedlg('The Queue is stopped. Do you want to start it to process AutoUpgrades?',mtconfirmation,[mbyes,mbno],0);
                if res3=mryes then
                  begin
                  queuestart;
                  end;
                end;
              end
            else
              begin
              { MO Turn it off or save it? }
              if not s.runsilent then
                tempra.autoupg:=false;
              { turn off autoupgrade but save it}
              tempra.savetoreg;
              updatelvs(nil);
              end;
            end;
          end
        else
          begin
          showmessagenotsilent('Downloaded but then lost latest Project Definition File.');
          result:=false;
          end;
        end
      else
        begin
        showmessagenotsilent('Could not get latest Project Definition File for "'+tempra.name+'"');
        if not s.runsilent then
          tempra.autoupg:=false;
        tempra.savetoreg;
        updatelvs(nil);
        result:=false;
        end;
      end;
    end;
  end;

begin
{ run checks on all checked items in lv2 and lv3 items }
stoptimers;
result:=true;
if (not UpdatingListViews) and
   (not ProcessingAutoUpgrades) and
   (not ProcessingScheduling) and
   (not ProcessingQueueItem) and
   (not ProcessingUpgradeFile) and
   (not QueuingApp) then
  begin
  if Scheduling then
    ProcessingScheduling:=true
  else
    ProcessingAutoUpgrades:=true;
  tempra:=trecapp.create;

  try
  cntm:=lv2.items.count-1;
  for cnt:=0 to cntm do
    begin
    if scheduling then
      begin
      ugnow(lv2.items[cnt]);
      end
    else
      begin
      if lv2.items[cnt].checked then
        ugnow(lv2.items[cnt]);
      end;
    end;

  cntm:=lv3.items.count-1;
  for cnt:=0 to cntm do
    begin
    if scheduling then
      begin
      ugnow(lv2.items[cnt]);
      end
    else
      begin
      if lv3.items[cnt].checked then
        ugnow(lv3.items[cnt]);
      end;
    end;
  finally
  tempra.free;
  end;

  ProcessingScheduling:=false;
  ProcessingAutoUpgrades:=false;
  updatelvs(nil);
  end;
starttimers;
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

function Tmainfm.lvsel(lv:tlistview;li:tlistitem): boolean;
begin
result:=false;
if li=nil then
  begin
  if lv.items.count>0 then
    begin
    lv.Selected:=lv.TopItem;
    result:=true;
    end
  else
    showmessagenotsilent('Try highlighting a Project first.');
  end
else
  begin
  result:=true;
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

procedure Tmainfm.ViewProjectFile1Click(Sender: TObject);
var
  id:string;
  tempap:tap;
  lv:tlistview;
begin
lv:=getvislv;
if lvsel(lv,lv.selected) then
  begin
  id:=getid(lv.Selected);
  if lv<>lv1 then
    begin
    if id<>'' then
      begin
      tempap:=tap.create;
      if (lv=lv4) then
        tempap.loadfromfile(s.rdpath+id);
      if (lv=lv2) or (lv=lv3) then
        tempap.loadfromfile(s.projpath+id);
      tempap.loadviewfm;
      tempap.free;
      viewfm.show;
      end;
    end;
  end;
end;

procedure Tmainfm.assignhints;
begin
{ assign hints to main form }
file1.hint:=hfile;
OpenProjectDefinitionFile1.hint:=hopenproj;
exit1.hint:=hexit;
queue1.hint:=hqueue;
start1.hint:=hqstart;
stop1.hint:=  hqstop;
up1.hint:=  hqup;
down1.hint:=  hqdown;
remove1.hint:=hqremove;

  { project menu }
project1.hint:=hproject;
run1.hint:=  hrun;
readme1.hint:=  hreadme;
readme2.hint:=  hlreadme;
website1.hint:=  hwebsite;
install1.hint:=  hinstall;
check2.hint:=  hcheck;
email1.hint:=  hemail;
upgrade1.hint:=  hupgrade;

  { installation menu }
install2.hint:=  hinstallation;
backup1.hint:=  hbackup;
revert1.hint:=  hrevert;
uninstall1.hint:=  huninstall;
remove2.hint:=  hremcomplete;
redeploy1.hint:=  hredeploy;
mirror1.hint:=  hmirror;
pulldown1.hint:=  hpulldown;
RemoveBackup1.hint:=  hrembackup;
clearstagingarea1.hint:=hclearstage;
clearworkingarea1.hint:=hclearworkarea;

  { tools menu }
tools1.hint:=  htools;
filesaver1.hint:=  hfilesaver;
showresults1.hint:=hviewresults;
viewprojectfile1.hint:=  hviewproj;
setinstalldirectory1.hint:=  hsetinstalldir;

  { options menu }
options1.hint:=  hoptions;
autosettings1.hint:=  hprefs;
proxyfirewallsettings1.hint:=  hproxy;

  { help menu }
help1.hint:=  hhelp;
UpgradeReceiverHelp1.hint:=  hhtmlhelp;
GottoWebsite1.hint:=  hdswebsite;
GotoCustomerSupport1.hint:= hcswebsite;
//LicenceUpgradeReceiverNow1.hint:=  hlicnow;
 AboutUpgradeReceiver1.hint:= habout;

{toolbar buttons }
{ queue buttons }
start.hint:=hqstart;
tbt10.hint:=hqstop;
tbt2.hint:=hqup;
tbt3.hint:=hqdown;
tbt4.hint:=hqremove;
tbt23.hint:=hviewresults;

{installed buttons }
tbt5.hint:=hrun;
tbt13.hint:=hreadme;
tbt15.hint:=hemail;
tbt14.hint:=hwebsite;
tbt6.hint:=hcheck;
tbt11.hint:=hupgrade;
tbt20.hint:=hviewresults;

{uninstalled buttons }
tbt16.hint:=hreadme;
tbt9.hint:=hinstall;
tbt12.hint:=hcheck;
tbt21.hint:=hviewresults;

{redeploy buttons }
tbt17.hint:=hmirror;
tbt19.hint:=hpulldown;
tbt18.hint:=hremovedep;
tbt22.hint:=hviewresults;

{ other hints }
lv1.hint:=hlv1;
lv2.hint:=hlv2;
lv3.hint:=hlv3;
lv4.hint:=hlv4;
m1.hint:=hhint;

{ popup menu hints }
run2.hint:=phrun;
install3.hint:=phinstall;
check1.hint:=phcheck;
upgrade2.hint:=phupgrade;
backup2.hint:=phbackup;
revert2.hint:=phrevert;
uninstall2.hint:=phuninstall;
removecompletely1.hint:=phremcomplete;
redeploy2.hint:=phredeploy;
mirror2.hint:=phmirror;
pulldown2.hint:=phpulldown;
clearstagingarea2.hint:=phclearstage;
removebackup2.hint:=phrembackup;
clearworkingarea2.hint:=phclearworkarea;





end;


function tmainfm.projrembackup(lv:tlistview):boolean;
var
	tempra:trecapp;
  ap:tap;
  res:integer;
  tempid:string;
  bres:boolean;
  goon:boolean;
begin
result:=false;
goon:=true;
{ remove project from registry and projects directory }
if lvsel(lv,lv.selected) then
	begin
  tempid:=getid(lv.selected);
  tempra:=trecapp.create;
  if tempid='' then
    begin
    showmessagenotsilent('Could not determine Project ID. Operation cancelled.');
    end
  else
    begin
    if (lv.selected.listview=lv3) or (lv.selected.listview=lv2) then
      begin
      tempra.loadfromreg(tempid);
      { first remove backup }
      if tempra.backupid='' then
        begin
        result:=false;
        showmessagenotsilent(tempra.name+' does not seem to be backed up. Operation cancelled.');
        end
      else
        begin
        goon:=false;
        tempid:=tempra.backupid;
        tempra.backupid:='';
        tempra.savetoreg;
        updatelvs(nil);
        bres:=tempra.loadfromreg(tempid);
        if bres then
          begin
          res:=messagedlg('Are you sure you want to remove the back-up?',mtconfirmation,[mbyes,mbno],0);
          if res=mryes then
            begin
            ap:=tap.create;
            ap.loadfromfile(s.projpath+tempra.id);
            ap.pulldown(s.bupath+ap.id,true,s.xmRunsilent,s.xmCloseEnd);
            ap.free;
            result:=true;
            end
          end
        else
          showmessagenotsilent('Back-up removal unsuccessful.');
        end;
      end;
    end;
  tempra.free;
  end;
if result then
  showmessagenotsilent('Back-up removal successful.')
end;

procedure Tmainfm.RemoveBackup1Click(Sender: TObject);
var
  lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
  projrembackup(lv);
end;

procedure Tmainfm.ClearStagingArea1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projclearstage(lv);
end;

function tmainfm.projclearstage(lv:tlistview): boolean;
var
  ap:tap;
  id:string;
begin
if lv<>lv4 then
  begin
  showmessagenotsilent('This function is only available for Redeployments.');
  end
else
  begin
  { load ap}
  id:=getid(lv.selected);
  if id='' then
  	showmessagenotsilent('Could not retrieve Project ID.')
  else
  	begin
    ap:=tap.create;
    ap.loadfromfile(s.rdpath+id);
    ap.clearstagingarea(recstagepath,'Clear Staging Area of Redeployment?'#13#10#13#10'This clears patches of your Redeployment.',false);
    ap.free;
    end;
  end;
end;


procedure Tmainfm.FormActivate(Sender: TObject);
begin
formActivateAction;
end;

procedure Tmainfm.ClearWorkingArea1Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projremworkarea(lv);
end;

procedure Tmainfm.ClearWorkingArea2Click(Sender: TObject);
var
	lv:tlistview;
begin
lv:=getvislv;
if lv<>nil then
	projremworkarea(lv);
end;

function tmainfm.projremworkarea(lv:tlistview): boolean;
var
	tempra:trecapp;
  id:string;
  res:integer;
  ts:string;
begin
{ check install }
result:=false;
if lvsel(lv,lv.selected) then
  begin
  id:=getid(lv.Selected);
  if id<>'' then
    begin
    { offer to get latest pdf }
    tempra:=trecapp.create;
    tempra.loadfromreg(id);
    Screen.Cursor := crHourGlass;
    try
      tempra.remworkarea;
    finally
    	Screen.Cursor := crDefault;
    end;  // try/finally
    result:=true;
    end
  end;
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

procedure Tmainfm.lv2Changing(Sender: TObject; Item: TListItem;
  Change: TItemChange; var AllowChange: Boolean);
begin
olditemchecked:=item.checked;
end;

procedure Tmainfm.lv3Changing(Sender: TObject; Item: TListItem;
  Change: TItemChange; var AllowChange: Boolean);
begin
olditemchecked:=item.checked;
end;

procedure Tmainfm.pm1ProgressEvent(Sender: TObject; Progress: Real);
begin
sb1.panels[1].text:=pm1.oldFile+': '+inttostr(trunc(progress*100)+1)+'%';
application.processmessages;
end;

procedure Tmainfm.OpenPDF;
begin
od1.initialdir:='C:\';
od1.filter:='Project Definition Files (*.upg,*.pbu,*.rdp,*.tst)|*.upg;*.pbu;*rdp;*.tst|All Files (*.*)|*.*';
if od1.Execute=true then
	begin
	acceptfile(od1.FileName,false);
  end;
updatelvs(nil);
end;

procedure Tmainfm.OpenProjectDefinitionFile1Click(Sender: TObject);
begin
OpenPDF;
end;

procedure Tmainfm.timSchedulingTimer(Sender: TObject);
begin
{ check if any scheduled items due to be put on the queue }
timScheduling.enabled:=false;
autoupgrade(true);
timScheduling.enabled:=autosetfm.cbPoll.checked;
end;

procedure Tmainfm.pollstart;
begin
timScheduling.Enabled:=true;
end;

procedure Tmainfm.pollstop;
begin
timScheduling.Enabled:=false;
end;

procedure Tmainfm.showadvancedinterface;
begin
{ show everything }
tsredep.tabVisible:=true;
{ Queue }
tbt2.visible:=true;
tbt3.visible:=true;
tbt23.visible:=true;
{ Installed }
tbt6.visible:=true;
tbt13.visible:=true;
tbt14.visible:=true;
tbt15.visible:=true;
tbt20.visible:=true;
{Uninstalled }
tbt12.visible:=true;
tbt16.visible:=true;
tbt21.visible:=true;
{ Main Menu items }
install2.Visible:=true;
Tools1.visible:=true;

end;

procedure Tmainfm.showsimpleinterface;
begin
{ show everything }
if pc1.activepage=tsredep then
  pc1.activepage:=tsinst;
tsredep.tabVisible:=false;
{ Queue }
tbt2.visible:=false;
tbt3.visible:=false;
tbt23.visible:=false;
{ Installed }
tbt6.visible:=false;
tbt13.visible:=false;
tbt14.visible:=false;
tbt15.visible:=false;
tbt20.visible:=false;
{Uninstalled }
tbt12.visible:=false;
tbt16.visible:=false;
tbt21.visible:=false;
{ Main Menu items }
install2.Visible:=false;
Tools1.visible:=false;
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
{ stop timers - may be more }
timQueue.enabled:=false;
timUpdateFile.enabled:=false;
timScheduling.enabled:=false;
timAutoUpgrade.enabled:=false;
timListFail.enabled:=false;

{ check if doing anything? }
ftpabort( ftp1);
httpabort(http1);
{ change queue settings to waiting }
cntm := lv1.Items.count-1;
for cnt := 0 to cntm do    // Iterate
  begin
	setsaveqs(lv1.items[cnt],qsWaiting);
  end;    // for
if not s.runsilent then
  showTimeLeft;
end;

procedure Tmainfm.TBNArea1DblClick(Sender: TObject);
begin
showapplication;
end;

procedure Tmainfm.formshowaction;
begin
{ update lv's }
{ MO Which way around do the next two lines go? }
readactionfile;
application.onhint:=showhint;
updatelvs(nil);
end;

procedure Tmainfm.formActivateAction;
var
  tempra:trecapp;
  tempid:string;
begin
application.onhint:=showhint;
setHintBox;
if startup then
  begin
  startup:=false;
  if paramstr(1)<>'' then
    begin
    globalacceptfile:=''; // this is set be acceptfile to the unzipped fname
    if fileexists(paramstr(1)) then
      begin
      if acceptfile(paramstr(1),true) then
        begin
        if globalacceptfile<>'' then
          begin
          tempra:=trecapp.create;
          tempid:=getidfromfile(globalacceptfile);
          tempra.loadfromreg(tempid);
          tempra.checkinstall(s.projpath);
          updatelvs(nil);
          tempra.free;
          { maybe we should queue the app? }
          queueapp(tempid,false);
          end;
        end;
      end;
    end;
  end;
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

procedure Tmainfm.timAutoUpgradeTimer(Sender: TObject);
begin
timAutoUpgrade.enabled:=false;
autoupgrade(false);
SetAutoTimer;
end;

function Tmainfm.SetAutoTimer: boolean;
begin
result:=true;
case autosetfm.cb1.itemindex of    //
  0:begin
    timAutoUpgrade.enabled:=false;
    end;
  1:begin
    timAutoUpgrade.interval:=60000;
    timAutoUpgrade.enabled:=true;
    end;
  2:begin
    timAutoUpgrade.interval:=60000*60;
    timAutoUpgrade.enabled:=true;
    end;
  3:begin
    timAutoUpgrade.interval:=60000*120;
    timAutoUpgrade.enabled:=true;
    end;
  end;    // case
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
  sb1.Panels[2].text:='';
  application.processmessages;
  end
else
  begin
  sb1.Panels[2].text:=inttostr(ictimeout);
  application.processmessages;
  end;
end;

procedure Tmainfm.RefreshDisplay1Click(Sender: TObject);
begin
updatelvs(nil);
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
{ Show Hints? }
p1.Visible:=s.showhints;
s3.visible:=s.showHints;
showhints1.Checked:=s.showhints;
end;

end.

