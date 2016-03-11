unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, StdCtrls, ExtCtrls, ToolWin, registry, filectrl, Buttons,
   GoToWeb, share, IceLock, Md5b, shellapi,
  clipbrd, activex, comobj, OleCtrls, ap, apfile, apfolder, recapp, settings,
  pmupgrade, ImgList, NMHttp, Psock, NMFtp, ShellLnk, ZLIBArchive, ExFile,
  TimeOut, PBFolderDialog, appexec, MMJRasConnect;

type
  Tmainfm = class(TForm)
    p1: TPanel;
    tv1: TTreeView;
    mm1: TMainMenu;
    Exit1: TMenuItem;
    p3: TPanel;
    lv1: TListView;
    tb1: TToolBar;
    tb2: TToolBar;
    tbt1: TToolButton;
    tbt2: TToolButton;
    tbt3: TToolButton;
    tbt4: TToolButton;
    Label1: TLabel;
    Label2: TLabel;
    flb1: TFileListBox;
    tb3: TToolBar;
    tbt5: TToolButton;
    tbt7: TToolButton;
    tbt9: TToolButton;
    il1: TImageList;
    s1: TSplitter;
    tbt14: TToolButton;
    tbt16: TToolButton;
    gw1: TGoToWeb;
    tbt17: TToolButton;
    ilock1: tIceLock;
    Help1: TMenuItem;
    AboutServer1: TMenuItem;
    ServerHelp1: TMenuItem;
    p4: TPanel;
    m1: TMemo;
    ToolBar1: TToolBar;
    Label5: TLabel;
    s2: TSplitter;
    View1: TMenuItem;
    N1: TMenuItem;
    Deploysoftwebsite1: TMenuItem;
    Project1: TMenuItem;
    New1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    ClearStagingArea1: TMenuItem;
    Tools1: TMenuItem;
    ViewFile1: TMenuItem;
    Compile1: TMenuItem;
    Test1: TMenuItem;
    Transmit1: TMenuItem;
    CreateHTML1: TMenuItem;
    PullDown1: TMenuItem;
    N5: TMenuItem;
    N3: TMenuItem;
    GotoCustomerSupportWebsite1: TMenuItem;
    tbt19: TToolButton;
    ProxyServerSettings1: TMenuItem;
    tbt18: TToolButton;
    tbt10: TToolButton;
    tbt12: TToolButton;
    sb1: TStatusBar;
    tbt11: TToolButton;
    tbt13: TToolButton;
    N4: TMenuItem;
    ViewResults1: TMenuItem;
    RestoreProjectDefinitionFile1: TMenuItem;
    ClearDeploymentList1: TMenuItem;
    ftp1: TNMFTP;
    http1: TNMHTTP;
    N6: TMenuItem;
    Client1: TMenuItem;
    DistManage1: TMenuItem;
    tbFileUp: TToolButton;
    tbFileDown: TToolButton;
    Dia1: TMenuItem;
    timListFail: TTimer;
    TransmitterSettings1: TMenuItem;
    pm1: Tpatchmaker;
    timICtimeout: TTimer;
    DeploytoNull1: TMenuItem;
    PopulateDeploymentList1: TMenuItem;
    za: TZLBArchive;
    ViewDeploymentList1: TMenuItem;
    EditDeploymentList1: TMenuItem;
    Deployment1: TMenuItem;
    N7: TMenuItem;
    Label4: TLabel;
    cbProject: TComboBox;
    tbSelectGroup: TToolButton;
    ToolButton1: TToolButton;
    N8: TMenuItem;
    ShowHints1: TMenuItem;
    fdlg: TPBFolderDialog;
    AppExec1: TAppExec;
    ras: TMMJRasConnect;
    procedure NewApplication1Click(Sender: TObject);
    procedure tbt3Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure tbt6Click(Sender: TObject);
    procedure tbt2Click(Sender: TObject);
    procedure tbt4Click(Sender: TObject);
    procedure tbt14Click(Sender: TObject);
    procedure tv1Click(Sender: TObject);
    procedure tbt17Click(Sender: TObject);
    procedure LaunchReceiver1Click(Sender: TObject);
    procedure pm1ProgressEvent(Sender: TObject; Progress: Real);
    procedure FormCreate(Sender: TObject);
    procedure Hints1Click(Sender: TObject);
    procedure tbt18Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
		procedure showhint(sender:tobject);
    procedure tv1Change(Sender: TObject; Node: TTreeNode);
    procedure tv1Enter(Sender: TObject);
    procedure lv1Enter(Sender: TObject);
    procedure lv1KeyPress(Sender: TObject; var Key: Char);
    procedure Deploysoftwebsite1Click(Sender: TObject);
    procedure lv1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure ClearStagingArea1Click(Sender: TObject);
    procedure Deploy(Sender: TObject);
    procedure Compile1Click(Sender: TObject);
    procedure CreateHTML1Click(Sender: TObject);
    procedure Goto1Click(Sender: TObject);
    procedure Registerthisproduct1Click(Sender: TObject);
    procedure tv1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lv1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit2Click(Sender: TObject);
    procedure AboutServer1Click(Sender: TObject);
    procedure ServerHelp1Click(Sender: TObject);
    procedure LicenceInformation1Click(Sender: TObject);
    procedure TroubleshootingHelp1Click(Sender: TObject);
    procedure ProxyServerSettings1Click(Sender: TObject);
    procedure tbt9Click(Sender: TObject);
    procedure ViewFile1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure tbt5Click(Sender: TObject);
    procedure tbt16Click(Sender: TObject);
    procedure Test1Click(Sender: TObject);
    procedure tbt7Click(Sender: TObject);
    procedure PullDown1Click(Sender: TObject);
    procedure tbt1Click(Sender: TObject);
    procedure tbt19Click(Sender: TObject);
    procedure tbt10Click(Sender: TObject);
    procedure tbt13Click(Sender: TObject);
    procedure ViewResults1Click(Sender: TObject);
    procedure RestoreProjectDefinitionFile1Click(Sender: TObject);
    procedure ClearDeploymentList1Click(Sender: TObject);
    procedure ClearPatchDirectory1Click(Sender: TObject);
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
    procedure cbProjectChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Client1Click(Sender: TObject);
    procedure DistManage1Click(Sender: TObject);
    procedure TransLaunchFailed(sender: TObject; evFileName,
      evIdentifier: String; evErrorCode: Integer; evErrorMessage: String);
    procedure TransProcCompleted(sender: TObject; evFileName,
      evIdentifier: String; evRetValue: Integer; evTimedOut: Boolean);
    procedure ClientLaunchFailed(sender: TObject; evFileName,
      evIdentifier: String; evErrorCode: Integer; evErrorMessage: String);
    procedure ClientProcCompleted(sender: TObject; evFileName,
      evIdentifier: String; evRetValue: Integer; evTimedOut: Boolean);
    procedure DistmgrLaunchFailed(sender: TObject; evFileName,
      evIdentifier: String; evErrorCode: Integer; evErrorMessage: String);
    procedure DistmgrProcCompleted(sender: TObject; evFileName,
      evIdentifier: String; evRetValue: Integer; evTimedOut: Boolean);
    procedure ClearRegistrySettings1Click(Sender: TObject);
    procedure tbFileUpClick(Sender: TObject);
    procedure tbFileDownClick(Sender: TObject);
    procedure timListFailTimer(Sender: TObject);
    procedure TransmitterSettings1Click(Sender: TObject);
    procedure DeploytoNull1Click(Sender: TObject);
    procedure PopulateDeploymentList1Click(Sender: TObject);
    procedure ViewDeploymentList1Click(Sender: TObject);
    procedure EditDeploymentList1Click(Sender: TObject);
    procedure tbSelectGroupClick(Sender: TObject);
    procedure ShowHints1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private


    hltreenode: ttreenode;
    locktv1: boolean;
    newproj: boolean;
    { Private declarations }

//    httperror:boolean;
//    httpfilerec:boolean;
//    httptimeout:boolean;
//
//    ftperror:boolean;
//    ftptimeout:boolean;
//    ftpfilerec:boolean;

		curapp:tap;


    procedure loaddlls;
    procedure unloaddlls;
    procedure assignhints;
    function projectdelete: boolean;
    function savereload: boolean;
    function importfilerec(curpath:string;curfold:tapfolder;recres:integer):boolean;

		{ new version functions }
    function loadapplists:boolean;
    function loadcheckbox:boolean;
    function gototab(pnam:string):boolean;
    function pnametofname(pnam:string):string;
    function displayfolds(ap:tap;selfold:tapfolder):boolean;
    function dfoldsrec(curitem:ttreenode;curfold:tapfolder;selfold:tapfolder):boolean;
    function displayfiles(fold:tapfolder):boolean;
    function lv1tofile(nam:string):tapfile;

    function projectnew(var projname:string):boolean;
    function projectedit:boolean;
    function projecttest:boolean;
    function projectchange:boolean;
    function projectrestore:boolean;

    function folderadd:boolean;
    function folderdelete:boolean;
    function folderimport:boolean;

    function apfileadd:boolean;
    function apfileedit:boolean;
    function apfiledelete:boolean;
		function writemd5(ap:tap;var fl:tapfile):boolean;
    function updatedisplay:boolean;

    procedure compileaction;
    procedure deployaction(deploytonull:boolean);

    { Hints }
    procedure setHintBox;

    { Firewall settings }
    function setwebcontrols:boolean;

    { Shared interface functions }
    procedure CreateNewProject;
    
  public
    appflist,appnlist,appilist:tstringlist; // project file names, real names, and id's
  	{ new version functions }
    function tv1tofold(tn:ttreenode):tapfolder;
    function loadselectedproj:tap;
    function tv1tolongpath(tn:ttreenode):string;
    { Public declarations }
  end;
const
  { bug avoider }
  ftpserver=0;
  { HINTS }
  hnone='|';
  hproject='|Create, edit, delete Project Definition Files. Important file deletion commands.';
  htools='|Actions to make your Project available to it''s target users.';
  hpatch='|Clears the Patch directory in the Project''s Staging Area.';
  hoptions='|Change Internet settings.';
  hhelp='|Glossary, Help, licensing information and links to the PC Blues website.';
  hcussup='|Open your default web browser and go the PC Blues Customer Support website.';
  hwebsite='|Open your default web browser and go to the PC Blues website.';
  hlicinf='|Display Product Licensing Information.';
  habout='|Information about Upgrade Suite Server. Copyright, version, etc.';
  hlicnow='|Choose from a variety of convenient ways to license this product.';
  hhtmlhelp='|Open help in your default web browser.';

  hnew='New Project|Create a new Project Definition File.Do this to get started.';
  hcompile='Prepare Project|Generates an image of the Project in the Staging Area that can be Deployed.Creates patches for previous versions of your Project''s files.';
  htest='Test Project|Deploy a version of your Project on your LAN or intranet for testing.';
  hdeploy='Deploy Project|Deploys the Project to the Internet, intranet, LAN, etc.';
  hlink='Publish Project Link|Generate HTML code or a Windows Shortcut for users to install/upgrade your Project.';
  hedit='Edit Project|Edit Project Details such as whether files are compressed, which file is the readme, etc.';
  hresult='Show Log|Most file copy/delete functions generate output which you can check for testing purposes.';
  hexit='Exit|Exit Upgrade Suite Server.';

  hcleardeploy='|Clears the list of files that have been sent to the Deployment Area. This will force the Deployment of all files in the Project.';

  hfoldadd='Add Folder|Add a new folder to the Project.';
  hfolddel='Delete Folder|Remove the selected folder and it''s children and their files from the Project.This doesn''t delete any files in your Source Directory.';
  himport='Import Files/Folders|Import a directory structure into your Project.This is a big time saver.';

  hfileadd='Add File|Add a new file the selected Folder.';
  hfileed='Edit File|Edit details about the current selected File.';
  hfiledel='Delete File|Delete the currently selected file from the Project.This does not delete the actual file.';
  hfileup='Move File Up|Move selected file up one place in the order of installation/uprading.';
  hfiledown='Move File Down|Move selected file down one place in the order of installation/uprading.';

  hfoldlist='|Folders in the current Project.';
  hfilelist='|The files in the currently selected Folder.';
  hhintbox='|Automatic hint box';
  hhints='|Display or hide the Hints section.';
  hcurproj='|The current Project''s tab will stand out.';
  hviewfile='|Displays Project Definition File.File format description can be found in the Help.';
  hclearsa='|Removes all files and patches from the Staging Area.Compiling puts files into the Staging Area.';
  hpulldown='|Delete all files in Deployment Area if possible.Deploying puts files into the Deployment Area.';
  hprojdelete='|Delete the current Project.This is unreversible.If you might need to make updates for this Project, keep a copy of the Project ID.';
  hproxy='|Change the Internet settings for Project Deployment.';
  hrestore='|Restore previously saved Project Definition File. Useful if your current version becomes corrupted.';
  hgroup='Select Projects|Select a list of projects for group actions.';
var
  mainfm: Tmainfm;

implementation

uses wiz, view, splash, about, ltype, fwall, remserv,
  GroupSelect, xmSettings;

{$R *.DFM}

{ deals with  special folder names }




function Tmainfm.projectchange:boolean;
begin
result:=true;
curapp.free;
tv1.selected:=nil;
curapp:=loadselectedproj;
updatedisplay;
end;

function Tmainfm.tv1tolongpath(tn:ttreenode):string;
begin
if tn<>nil then
	begin
  result:=tn.text;
  tn:=tn.parent;
  while tn<>nil do
    begin
    result:=tn.text+'\'+result;
    tn:=tn.parent;
    end;
  end;
end;


function Tmainfm.projectdelete: boolean;
begin
result:=false;
if cbProject.text<>'' then
	begin
  curapp:=loadselectedproj;
  if curapp<>nil then
    begin
    curapp.pulldown(s.stagepath,true,s.xmRunSilent,S.xmCloseEnd);
    result:=curapp.projectdelete(s.stagepath);
    { reload everything }
    curapp.Free;
    curapp:=tap.create;
    loadapplists;
    loadcheckbox;
    updatedisplay;
    locktv1:=false;
    end;
  end;
end;

function Tmainfm.savereload: boolean;
begin
result:=true;
curapp.savetofile;
loadapplists;
loadcheckbox;
gototab(curapp.nname);
updatedisplay;
end;

function Tmainfm.updatedisplay:boolean;
var
	tempfold:tapfolder;
begin
Screen.Cursor := crHourGlass;
try
	result:=true;
	if tv1.selected<>nil then
			begin
			tempfold:=tv1tofold(tv1.selected);
			end
	else
			begin
			tempfold:=nil;
			end;
  lockwindowupdate(lv1.handle);
  lv1.Items.Clear;
  lockwindowupdate(0);
	displayfolds(curapp,tempfold);
	displayfiles(tempfold);
  if tv1.Items.count>0 then
    if tv1.Selected=nil then
      tv1.selected:=tv1.TopItem;
finally
	Screen.Cursor := crDefault;
end;  // try/finally
end;

function Tmainfm.writemd5(ap:tap;var fl:tapfile):boolean;
var
  ts:string;
begin
result:=true;
{ fl.name has real file name now }
ts:=fl.name;
if (ts='') or (not fileexists(ts)) then
  showmessagE('Error 55. File "'+ts+'" does not exist in Source Directory.')
else
  fl.md5:=filemd5digest(ts);
end;

function Tmainfm.lv1tofile(nam:string):tapfile;
var
	tempfold:tapfolder;
  posn:integer;
begin
result:=nil;
if tv1.selected<>nil then
	begin
	tempfold:=tv1tofold(tv1.selected);
  if tempfold<>nil then
    begin
    posn:=tempfold.findfilenam(nam);
    if posn<>-1 then
    	result:=tempfold.apfiles[posn];
    end
	end;
end;

function Tmainfm.folderadd:boolean;
var
	tempfold:tapfolder;
begin
result:=false;
if cbProject.text<>'' then
	begin
  tempfold:=tapfolder.create(curapp.rootfold);
  wizfm.readfold(curapp,tempfold);
  if wizfm.showfold then
    begin
    wizfm.writefold(curapp,tempfold);
    curapp.addfold(tempfold);
    result:=true;
    end;
  end;
if result then
	savereload;
end;

function Tmainfm.folderdelete:boolean;
var
	tempfold:tapfolder;
begin
locktv1:=true;
try
	result:=false;
	if tv1.selected<>nil then
    begin
    tempfold:=tv1tofold(tv1.Selected);
    if tempfold<>nil then
      begin
      result:=curapp.deletefold(tempfold);
      end;
    end;
finally
	locktv1:=false;
end;  // try/finally
if result then
  savereload;
end;

function Tmainfm.folderimport:boolean;
var
  ts,ts2,ts3,ts4:string;
  res:integer;
  tempf,tf2:tapfolder;
  temppath:string;
  goon:boolean;
begin
sb1.Panels[0].text:='Importing Folders';
result:=false;
application.processmessages;
if (cbProject.text<>'') or (newproj) then
	begin
  Screen.Cursor := crHourGlass;
  try
    locktv1:=true;
    try
      result:=true;
      goon:=true;
      { Import File structure from Source Directory }
      if newproj then
        begin
        fdlg.LabelCaptions.clear;
        fdlg.LabelCaptions.add('Default=Select Directory to Import.');
        if fdlg.Execute then
          begin
          curapp.bucketdir:=makedpath(fdlg.Folder);
          end
        else
          begin
          goon:=false;
          end;
        end
      else
        begin
          if cbProject.text<>'' then
            begin
            fdlg.LabelCaptions.clear;
            fdlg.LabelCaptions.add('Default=Select Directory to Import.');
            if not directoryexists(curapp.bucketdir) then
              forcedirectories(curapp.bucketdir);
            fdlg.folder:=curapp.bucketdir;
            if fdlg.Execute then
              begin
              curapp.bucketdir:=makedpath(curapp.bucketdir);
              { recurse down directory, adding files }
              if pos(uppercase(curapp.bucketdir),uppercase(makedpath(fdlg.folder)))=0 then
                begin
                showmessage('Can''t choose a directory above the Root directory of your Project.');
                goon:=false;
                end
              end
            else
              begin
              goon:=false;
              end;
            end
          end;
        if goon then
          begin
          res:=messagedlg('Recurse subdirectories?',mtConfirmation,[mbyes,mbno],0);
          ts:=makedpath(fdlg.Folder);
          ts2:=makedpath(curapp.bucketdir);
          //viewfm.m1.lines.Clear;
          viewfm.m1.lines.add('');
          viewfm.m1.lines.add(Uppercase('Importing files from '+ts+' to '+ts2));
          viewfm.m1.lines.add('');
          { determine relation between ts and curapp.bucketdir }
          tempf:=curapp.rootfold;
          temppath:=ts;
          { Check if windows or system }
          if (pos(lowercase('system'),lowercase(ts))>0) then
            begin
            curApp.apfolds.add(curApp.sysfold);
            tempf:=curApp.sysfold;
            end
          else if (pos(lowercase('windows'),lowercase(ts))>0) then
            begin
            curapp.apfolds.add(curApp.winfold);
            tempf:=curApp.winfold;
            end
          else
            begin
            { create folder objects for new path }
            if ts<>ts2 then
              begin
              ts2:=copy(ts,length(ts2)+1,length(ts)); // extra path
              ts3:=ts2;
              ts4:=ts2;
              while (ts4<>'\') and (ts4<>'') do
                begin
                { get first folder name }
                ts3:=copy(ts4,1,pos('\',ts4)-1);
                { remove from extra path }
                delete(ts4,1,length(ts3)+1);
                { find in rootapp }
                tf2:=tempf.findfoldnam(ts3);
                if tf2=nil then
                  begin
                  tf2:=tapfolder.create(nil);
                  tf2.name:=ts3;
                  tf2.parent:=tempf;
                  tempf.apfolds.Add(tf2);
                  end;
                tempf:=tf2;
                end;
              end;
            end;
         { call recursive file adding function }
	        result:=importfilerec(temppath,tempf,res);
          savereload;
          end;
    finally
      locktv1:=false;
    end;  // try/finally
  finally
    Screen.Cursor := crDefault;
  end;  // try/finally
  end;
sb1.Panels[0].text:='';
end;

function Tmainfm.apfileadd:boolean;
var
	tempfile:tapfile;
  tempfold:tapfolder;
begin
result:=false;
if tv1.selected<>nil then
  begin
  tempfold:=tv1tofold(tv1.selected);
  if tempfold<>nil then
    begin
    tempfile:=tapfile.create(tempfold);
    wizfm.readapfile(curapp,tempfile);
    if wizfm.showapfile then
    	begin
	    if wizfm.writeapfile(tempfile) then
      	begin
        writemd5(curapp,tempfile);
        tempfile.parent.apfiles.add(tempfile);
        result:=true;
        end;
      end;
    end
  end
else
  begin
  showmessage('Select a Folder before adding a new File.');
  end;
if result then
	begin
  curapp.savetofile;
  displayfiles(tv1tofold(tv1.selected));
  end;
end;

function Tmainfm.apfileedit:boolean;
var
	tempfile:tapfile;
  tempfold:tapfolder;
  posn:integer;
begin
result:=false;
if tv1.selected<>nil then
  begin
  tempfold:=tv1tofold(tv1.Selected);
  if tempfold<>nil then
    begin
    if lv1.selected<>nil then
			begin
      posn:=tempfold.findfilenam(lv1.selected.Caption);
      if posn<>-1 then
				begin
	      tempfile:=tempfold.apfiles[posn];
	      wizfm.readapfile(curapp,tempfile);
        if wizfm.showapfile then
          begin
          if wizfm.writeapfile(tempfile) then
          	begin
            writemd5(curapp,tempfile);
            result:=true;
            end;
          end;
        end
		  end
    else
      begin
      showmessage('Select a File before you click Edit.');
      end;
    end
  end
else
  begin
  showmessage('Select a Folder, then a File before Editing.');
  end;
if result then
	begin
  curapp.savetofile;
  displayfiles(tv1tofold(tv1.selected));
  end;
end;

function Tmainfm.apfiledelete:boolean;
var
	tempfile:tapfile;
  posn:integer;
  tempfold:tapfolder;
begin
result:=false;
if tv1.selected<>nil then
	begin
  tempfold:=tv1tofold(tv1.selected);
  if tempfold<>nil then
  	begin
    if lv1.selected<>nil then
      begin
      posn:=tempfold.findfilenam(lv1.selected.caption);
      if posn<>-1 then
        begin
	      tempfile:=tempfold.apfiles[posn];
        tempfold.apfiles.Delete(posn);
        tempfile.free;
        result:=true;
        end;
      end
    else
      begin
      showmessage('Select a File before you click Delete.');
      end;
	  end
  end
else
  begin
  showmessage('Select a Folder, then a File before Deleting.');
  end;
if result then
  begin
  curapp.savetofile;
  displayfiles(tv1tofold(tv1.selected));
  end;
end;


function Tmainfm.projecttest:boolean;
var
  newap:tap;
  goon:boolean;
  dlt:turltype;
  finalname:string;
begin
result:=false;
goon:=true;
if cbProject.text='' then
  goon:=false;
if goon then
  begin
  { start new app }
  //curapp:=loadselectedproj;
  newap:=tap.create;
  if newap.maketest(curapp) then
    begin
    { get remote details }
    { load values into remservfm }
    remservfm.ediServer.text:='';
    remservfm.e18.text:=newap.username;
    remservfm.e19.text:=newap.password;
    remservfm.ediDepDir.text:='c:\testDeploymentArea\';
    remservfm.rg1.itemindex:=newap.transtype;
    if remservfm.showmodal=mrok then
      begin
      newap.server:=remservfm.ediServer.text;
      newap.username:=remservfm.e18.text;
      newap.password:=remservfm.e19.text;
      newap.remdir:=remservfm.ediDepDir.text;
      newap.transtype:=remservfm.rg1.itemindex;
      dlt:=getdltype(newap.server);
      { Maybe makexpath around remdir fixes something }
      if (dlt=utFTP) or (dlt=utHTTP) then
        newap.baseurl:=makewpath(newap.server)+makewpath(newap.remdir)
      else
        newap.baseurl:=makedpath(newap.server)+makedpath(newap.remdir);
      newap.ownloc:=newap.baseurl+newap.fname;
      newap.savetofile;
      //newap.savetodeployfile(s.stagepath);
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
  end;
if goon then
  begin
  { Needs to be prepared or staging area changed }
  if newap.compile(s.stagepath,true,'Preparing test project',true,true) then
    begin
    showmessage('Test Project Preparation succeeded');
    end
  else
    begin
    showmessage('Test Project Preparation failed. Exiting Test.');
    goon:=false;
    end;
  if goon then
    begin
    { deploy it }
    { MO - forceall or go with deployment list ? }
    if newap.deploy(s.stagepath,true,true,true,'Deploying Test Project',true,false,'',s.xmRunSilent,s.xmCloseEnd,false) then
      begin
      { load it }
      if messagedlg('Do you want to run Upgrade Suite Client?',mtconfirmation,[mbyes,mbno],0)=mryes then
        newap.receive(s.stagepath);
      { Pull down test project }
      newap.pulldown(s.stagepath,false,true,true);
      { Delete test project }
      newap.projectdelete(s.stagepath);
      end;
    end
  else
    begin
    goon:=false;
    end;
  end;
if goon=false then
  begin
  result:=false;
  ShowMessage('Project Testing Cancelled');
  end;
newap.free;
mainfm.Activate;
end;

function Tmainfm.projectedit:boolean;
begin
result:=true;
wizfm.edproj:=true;
if cbProject.text<>'' then
	begin
  wizfm.readproj(curapp);
  if wizfm.showproj then
  	begin
	  wizfm.writeproj(curapp);
    savereload;
    end;
  end;
end;

function tmainfm.loadselectedproj:tap;
var
  ts:string;
begin
result:=nil;
if cbProject.text<>'' then
	begin
  result:=tap.create;
  ts:=s.appath+pnametofname(cbProject.text);
  result.loadfromfile(ts);
  result.loadserfromfile(ts+'.ser');
  end;
end;

function tmainfm.pnametofname(pnam:string):string;
begin
result:=appflist.strings[appnlist.indexof(pnam)];
end;

{ load Project file names and populate Project tab bar }
function tmainfm.loadapplists:boolean;
var
  cnt:integer;
  tf:textfile;
  ts,ts2,ts3:string;
  namefound:boolean;
  idfound:boolean;
begin
result:=true;
{ create file list }
appnlist.clear;
appflist.clear;
appilist.clear;
flb1.Directory:=s.appath;
flb1.filetype:=[ftNormal,ftReadonly,ftArchive];
flb1.Mask:='*.upg';
flb1.update;
for cnt:=0 to flb1.Items.count-1 do
  begin
  { open file }
  namefound:=false;
  idfound:=false;
  assignfile(tf,flb1.Items[cnt]);
  reset(tf);
  while ((not idfound) or (not namefound)) and (not EOF(tf)) do
    begin
    readln(tf,ts);
    if pos('?',ts)<>0 then
      begin
      namefound:=true;
      ts3:=copy(ts,2,length(ts));
      end;
    if pos('!',ts)<>0 then
    	begin
      idfound:=true;
      ts2:=copy(ts,2,length(ts));
      end;
    end;
  if (namefound=false) or (idfound=false) then
    begin
    closefile(tf);
    if messagedlg('Error 10. Project Definition File is corrupt. Delete?',mtconfirmation,[mbyes,mbno],0)=mryes then
      begin
      deletefile(s.appath+flb1.items[cnt]);
      end
    else
    	begin
      { limp along with a corrupt project file }
      appflist.add(flb1.items[cnt]);
      if namefound=false then
      	appnlist.add('Unknown Name.')
      else
      	appnlist.add(ts3);
      if idfound=false then
      	appilist.add('Critical Error. Unknown ID.')
      else
      	appilist.add(ts2);
      end;
    end
  else
    begin
    appflist.add(flb1.items[cnt]);
    appnlist.add(ts3);
    appilist.add(ts2);
    closefile(tf);
    end;
  end;
end;

function tmainfm.loadcheckbox:boolean;
begin
result:=true;
{ populate Project Checkbox }
cbProject.Clear;
cbProject.Items.AddStrings(appnlist);
cbProject.Refresh;
{ populate group select list }
if frmGroupSelect=nil then
  frmGroupSelect:=tfrmGroupSelect.create(application);
frmGroupSelect.lbProjects.clear;
frmGroupSelect.lbProjects.Items.AddStrings(appnlist);
frmGroupSelect.lbProjects.Refresh;
end;

function tmainfm.gototab(pnam:string):boolean;
var
	posn:integer;
begin
result:=true;
posn:=cbProject.items.indexof(pnam);
if posn<>-1 then
	cbProject.ItemIndex:=posn;
end;


{ load app details and populate drop down lists, list boxes etc.
  apfile is the Project file name }

function tmainfm.displayfolds(ap:tap;selfold:tapfolder):boolean;
var
  cnt,cntm:integer;
  sn:string;
  newitem:ttreenode;
begin
locktv1:=true;
lockwindowupdate(tv1.handle);
try
	result:=true;
  hltreenode:=nil;
	{ clear folder list? if too slow, do check for item, then update }
	tv1.items.clear;
	ap.apfolds.pack;
	cntm:=ap.apfolds.count-1;
	for cnt:=0 to cntm do
		begin
    sn:=ap.foldtosname(tapfolder(ap.apfolds[cnt]).name);
    newitem:=tv1.Items.Add(ttreenode.create(tv1.items),sn);
    { highlight correct node }
    if tapfolder(ap.apfolds[cnt])=selfold then
      hltreenode:=newitem;
    dfoldsrec(newitem,ap.apfolds[cnt],selfold);
    end;
finally
locktv1:=false;
end;  // try/finally
lockwindowupdate(0);
tv1.fullexpand;
if hltreenode<>nil then
	tv1.selected:=hltreenode
end;

{ recursive display of folders }
function tmainfm.dfoldsrec(curitem:ttreenode;curfold:tapfolder;selfold:tapfolder):boolean;
var
  cnt,cntm:integer;
  tempf:tapfolder;
  newitem:ttreenode;
begin
result:=true;
cntm:=curfold.apfolds.count-1;
for cnt:=0 to cntm do
	begin
	{ add child }
  tempf:=curfold.apfolds[cnt];
	newitem:=tv1.Items.addchild(curitem,tempf.name);
  if tapfolder(curfold.apfolds[cnt])=selfold then
    hltreenode:=newitem;
  if tempf.apfolds.count>0 then
  	dfoldsrec(newitem,tempf,selfold);
  end;
end;

function tmainfm.displayfiles(fold:tapfolder):boolean;
var
  cnt,cntm,c2,c2m:integer;
  ts:string;
  litem:tlistitem;
  tempfile:tapfile;
  tsl:tstringlist;
begin
result:=true;
{ clear file list?  if too slow, do check for items and updates }
lockwindowupdate(lv1.handle);
lv1.items.clear;
if fold<>nil then
	begin
  cntm:=fold.apfiles.count-1;
  for cnt:=0 to cntm do
    begin
    litem:=lv1.Items.add;
    tempfile:=fold.apfiles.items[cnt];
    litem.caption:=tempfile.name;
    litem.subitems.add(tempfile.URL);
    { reg info }
    tsl:=tempfile.regslist;
    c2m:=tsl.Count-1;
    ts:='';
    for c2:=0 to c2m do
      begin
      ts:=ts+tsl[c2];
      if c2<c2m then
        ts:=ts+' , ';
      end;
    tsl.free;
    litem.subitems.add(ts);

    { shortcut info }
    tsl:=tempfile.scutslist;
    c2m:=tsl.count-1;
    ts:='';
    for c2:=0 to c2m do
      begin
      ts:=ts+tsl[c2];
      if c2<c2m then
        ts:=ts+' , ';
      end;
    tsl.free;
    litem.subitems.add(ts);
    end;
  end;
lockwindowupdate(0);
end;





{ END PRIVATE FUNCTIONS }


{ this procedure gets called after all forms are created. }


{ END PUBLIC FUNCTIONS }



{ EVENT HANDLERS }
procedure Tmainfm.NewApplication1Click(Sender: TObject);
var
	tempap:tap;
begin
tempap:=tap.create;
wizfm.readproj(tempap);
if wizfm.showproj then
	wizfm.writeproj(tempap);
tempap.free;
end;


procedure Tmainfm.tbt3Click(Sender: TObject);
begin
if apfileadd then
	updatedisplay;
end;

{ load new Project details }
procedure Tmainfm.Exit1Click(Sender: TObject);
begin
//application.terminate;
close;
end;

procedure Tmainfm.tbt6Click(Sender: TObject);
begin
if cbProject.text<>'' then
	begin
	tv1.items.clear;
	lv1.items.clear;
  end;
end;

procedure Tmainfm.tbt2Click(Sender: TObject);
begin
if folderdelete then
  updatedisplay;
end;

procedure Tmainfm.tbt4Click(Sender: TObject);
begin
if apfiledelete then
  updatedisplay;
end;

procedure Tmainfm.tbt14Click(Sender: TObject);
begin
if apfileedit then
  updatedisplay;
end;

procedure Tmainfm.tv1Click(Sender: TObject);
var
	tempfold:tapfolder;
begin
if tv1.selected<>nil then
	begin
  tempfold:=tv1tofold(tv1.selected);
  if tempfold<>nil then
	  displayfiles(tempfold);
  end;
end;

procedure Tmainfm.tbt17Click(Sender: TObject);
begin
compileaction;
end;




{ recursively create Project file structure }

procedure Tmainfm.LaunchReceiver1Click(Sender: TObject);
begin
{ need to ask for parameters? }
runClient(true,'');
end;

procedure Tmainfm.pm1ProgressEvent(Sender: TObject; Progress: Real);
begin
sb1.panels[1].Text:=extractfilename(pm1.oldFile)+': '+inttostr(trunc(progress*100)+1)+' %';
application.processmessages;
end;

procedure Tmainfm.FormCreate(Sender: TObject);
var
  exeNameOK:boolean;
begin
transrunning:=false;
clientrunning:=false;
DistMgrRunning:=false;

connectionerror:=false;

{ This is where the splash and everything should really be }
if splashfm=nil then
  splashfm:=tsplashfm.create(application);
splashfm.showmodal;
splashfm.release;

{ MO - 9/3/2000
  This file is shared at the moment between the web server and the server
  so the main caption should display the difference }
{$ifdef nonweb}
mainfm.caption:=serverCaption;
{$else}
mainfm.caption:=wserverCaption;
{$endif}

loaddisttargets;
application.helpfile:=s.ugpath+'usuite.hlp';
appnlist:=tstringlist.create;
appilist:=tstringlist.create;
appflist:=tstringlist.create;

loadapplists;
loadcheckbox;
if cbProject.items.count>0 then
	begin
  cbProject.ItemIndex:=0;
	curapp:=loadselectedproj;
  updatedisplay;
  end
else
	begin
  curapp:=tap.create;
  end;
{ set private variables }
locktv1:=false;
newproj:=false;
assignhints;
loaddlls;
end;

{ generate HTML and paste to clipboard for link to upgrade object }

procedure Tmainfm.Hints1Click(Sender: TObject);
begin
//if hints1.checked then
//  begin
//  hints1.checked:=false;
//  p4.visible:=false;
//  end
//else
//  begin
//  hints1.checked:=true;
//  p4.visible:=true;
//  end;
end;

procedure Tmainfm.tbt18Click(Sender: TObject);
begin
folderimport;
end;

function tmainfm.importfilerec(curpath:string;curfold:tapfolder;recres:integer):boolean;
var
  ts,ts2:string;
  cnt,cntm:integer;
  tempfile:tapfile;
  tempfold:tapfolder;
begin
result:=true;
flb1.mask:='*.*';
flb1.filetype:=[ftNormal,ftReadOnly,ftArchive];
flb1.directory:=curpath;
cntm:=flb1.Items.count-1;
for cnt:=0 to cntm do
  begin
  if curapp.findfile(flb1.items[cnt],curfold)=nil then
    begin
    { add files to curfold's file list }
    tempfile:=tapfile.creatE(curfold);
    tempfile.name:=curpath+flb1.Items[cnt];
    { bit funny about this bit, but it seems OK }
    tempfile.url:=flb1.items[cnt];
    ts:=makedpath(curpath)+flb1.items[cnt];
    if not fileexists(ts) then
    	begin
    	showmessagE('Error 54. File does not exists.');
      result:=false;
      end
    else
      tempfile.md5:=filemd5digest(ts);
    curfold.apfiles.add(tempfile);
    viewfm.m1.lines.Add('  Adding '+tempfile.parent.name+'\'+tempfile.name);
    end;
  end;
if recres=mrYes then
  begin
  flb1.filetype:=[ftDirectory];
  cntm:=flb1.items.count-1;
  for cnt:=2 to cntm do
    begin
    flb1.filetype:=[ftDirectory];
    flb1.directory:=curpath;
		flb1.Mask:='*.*';
    ts2:=removesbs(flb1.items[cnt]);
    tempfold:=curfold.findfoldnam(ts2);
    if tempfold=nil then
    	begin
(* Old way didn't work
      if ts2<>curapp.snametofold(ts2) then
      	begin
        if ts2='System' then
        	begin
					curapp.apfolds.add(curapp.sysfold);
          tempfold:=curapp.sysfold;
          end;
        if ts2='Windows' then
        	begin
					curapp.apfolds.add(curapp.winfold);
          tempfold:=curapp.winfold;
          end;
        end
      else
*)
      { Check if windows or system }
      if (pos(lowercase('system'),lowercase(ts2))>0) then
        begin
        curApp.apfolds.add(curApp.sysfold);
        tempfold:=curApp.sysfold;
        end
      else if (pos(lowercase('windows'),lowercase(ts2))>0) then
        begin
        curapp.apfolds.add(curApp.winfold);
        tempfold:=curApp.winfold;
        end
      else
      	begin
        tempfold:=tapfolder.create(nil);
        tempfold.parent:=curfold;
        tempfold.name:=ts2;
        curfold.apfolds.add(tempfold);
        end;
      end;
    result:=importfilerec(curpath+ts2+'\',tempfold,recres);
    end;
  end;
end;

procedure Tmainfm.FormActivate(Sender: TObject);
begin
application.onhint:=showhint;
setHintBox;
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
     // m1.lines.add('');
      oldposn:=posn;
      end;
    end;
  end;
end;

procedure Tmainfm.tv1Change(Sender: TObject; Node: TTreeNode);
var
	tempfold:tapfolder;
begin
if not locktv1 then
	begin
  tempfold:=tv1tofold(node);
  if tempfold<>nil then
    displayfiles(tempfold);
  end;
end;

procedure Tmainfm.tv1Enter(Sender: TObject);
begin
if (tv1.selected=nil) and (tv1.topitem<>nil) then
	begin
  tv1.selected:=tv1.TopItem;
  end;
end;

procedure Tmainfm.lv1Enter(Sender: TObject);
begin
if (lv1.selected=nil) and (lv1.topitem<>nil) then
	lv1.selected:=lv1.topitem;
end;

procedure Tmainfm.lv1KeyPress(Sender: TObject; var Key: Char);
begin
if (key=#32) or (key=#13) then
	begin
  { edit file if selected and space or enter pressed }
  tbt14click(sender);
  end;

end;

procedure Tmainfm.Deploysoftwebsite1Click(Sender: TObject);
begin
{ open web page help }
gw1.url:='http://www.pcblues.com/index.html';
if gw1.execute=false then
	showmessage('Error 252. Could not open the PC Blues website in your '+
  'default web browser. Open your favourite browser and go to http://www.pcblues.com/index.html');
end;

procedure Tmainfm.lv1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_DELETE then
  begin
  tbt4click(sender);
  end;
end;

procedure Tmainfm.Edit1Click(Sender: TObject);
begin
if cbProject.text<>'' then
	projectedit;
end;

procedure Tmainfm.Delete1Click(Sender: TObject);
begin
projectdelete;
end;

procedure Tmainfm.ClearStagingArea1Click(Sender: TObject);
begin
if cbProject.text<>'' then
  begin
	curapp.clearstagingarea(s.stagepath,'This will clear all patches made for this Project.',false);
  end;
end;


procedure Tmainfm.Deploy(Sender: TObject);
begin
deployaction(false);
end;

procedure Tmainfm.Compile1Click(Sender: TObject);
begin
compileaction;
end;

procedure Tmainfm.CreateHTML1Click(Sender: TObject);
begin
curapp.createlink;
end;

procedure Tmainfm.Goto1Click(Sender: TObject);
begin
{ Go to Customer Support Page on PC Blues website }
gw1.url:='http://www.pcblues.com/support/index.html';
if gw1.execute=false then
	showmessage('Error 251. Could not open the PC Blues Customer Support Website in your '+
  'default web browser. Open your favourite browser and go to http://www.pcblues.com/support/index.html');
end;

procedure Tmainfm.Registerthisproduct1Click(Sender: TObject);
begin
{ MO - 4/3/2000
  Registration disable in this version }
(*
ilock1.loadkeyfile;
if ilock1.IsRegistered=true then
  begin
  showmessage('This product is already registered.');
  end
else
  begin
  nagfm.t1.interval:=50;
  nagfm.showmodal;
  end
*)
end;

procedure Tmainfm.tv1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_DELETE then
	begin
  if folderdelete then
    updatedisplay;
  end;
end;

procedure Tmainfm.lv1DblClick(Sender: TObject);
begin
tbt14Click(sender);
end;

procedure Tmainfm.FormClose(Sender: TObject; var Action: TCloseAction);
var
	res:integer;
begin
{ MO - 4/3/2000
  Registration is disabled for now }
{ Registration stuff }
(*
res:=ilock1.loadkeyfile;
if res=ieOkay then
  if ilock1.isregistered=false then
    begin
    setwindowpos(nagfm.handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE+SWP_NOSIZE);
    nagfm.t1.interval:=5500;
    nagfm.showmodal;
    end;
if res=ieNotSameHD then
  begin
  showmessage('Program has been moved to another Hard Disk.'+#13#10#13#10+
   'Contact PC Blues by email at support@PC Blues.com for a new Registration Key. Make sure you include the name the product is registered to, the Registration Key, the Serial No., and the name of the product in the email.');
  { 5000 }
  setwindowpos(nagfm.handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE+SWP_NOSIZE);
  nagfm.t1.interval:=5500;
  nagfm.showmodal;
  end;
if res=ieInvalidKEy then
  begin
  { 5000 }
  setwindowpos(nagfm.handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE+SWP_NOSIZE);
  nagfm.t1.interval:=5500;
  nagfm.showmodal;
  end;
if res=iefileerror then
  begin
  setwindowpos(nagfm.handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE+SWP_NOSIZE);
  nagfm.t1.interval:=5500;
  nagfm.showmodal;
  end;
*)
action:=cafree;
end;

procedure Tmainfm.Edit2Click(Sender: TObject);
begin
projectedit;
end;

procedure Tmainfm.AboutServer1Click(Sender: TObject);
begin
aboutbox.showmodal;
end;

procedure Tmainfm.ServerHelp1Click(Sender: TObject);
begin
application.helpcontext(30);
{if shellexecute(0,'open','index.html',nil,pchar(s.ugpath+'docs/index.html'),SW_SHOWNORMAL)<=32 then
	showmessagE('Error 254. Could not open HTML help in your default browser.');}
end;

procedure Tmainfm.LicenceInformation1Click(Sender: TObject);
begin
if shellexecute(0,'open','clicence.html',nil,pchar(s.ugpath+'docs'),SW_SHOWNORMAL)<=32 then
	showmessagE('Error 255. Could not open Licence Information HTML page in your default browser.');
end;

procedure Tmainfm.TroubleshootingHelp1Click(Sender: TObject);
begin
if shellexecute(0,'open','ctshoot.html',nil,pchar(s.ugpath+'docs'),SW_SHOWNORMAL)<=32 then
	showmessagE('Error 256. Could not open Troubleshooting HTML page in your default browser.');
end;

procedure Tmainfm.ProxyServerSettings1Click(Sender: TObject);
begin
{ set hfirewall settings }
setwebcontrols;
fwallfm.showmodal;
application.OnHint:=showhint;
end;


function tmainfm.tv1tofold(tn:ttreenode):tapfolder;
var
	tempfold:tapfolder;
  tsl:tstringlist;
  cnt,cntm:integer;
  newfold:tapfolder;
begin
result:=nil;
tempfold:=nil;
if tn<>nil then
	begin
  tsl:=tstringlist.create;
  while tn<>nil do
    begin
    tsl.add(tn.text);
    tn:=tn.parent;
    end;

  cntm:=tsl.count-1;
  if cntm>=0 then
    begin
    { root/win/sys }
    if tsl[cntm]='Root' then
      tempfold:=curapp.rootfold
    else if tsl[cntm]='Windows' then
      tempfold:=curapp.winfold
    else if tsl[cntm]='System' then
      tempfold:=curapp.sysfold;
    dec(cntm);
    newfold:=tempfold;
    for cnt:=cntm downto 0 do    // Iterate
      begin
      if newfold<>nil then
        begin
        newfold:=tempfold.findfoldnam(tsl[cnt]);
        tempfold:=newfold;
        end;
      end;    // for
    if tempfold<>nil then
      result:=tempfold;
    end;
  tsl.free;
  end;
end;



function tmainfm.projectnew(var projname:string):boolean;
var
  res: integer;
  bres: boolean;
  ts:string;
begin
projname:='';
result:=true;
newproj:=true;
wizfm.edproj:=false;
if assigned(curapp) then
	begin
  { ask whether to use same project }
  if cbProject.text<>'' then
    begin
    res:=messagedlg('Clear current Project Definition Information ( new Project ID will be generated anyway)?',mtconfirmation,[mbyes,mbno,mbcancel],0);
    end
  else
    begin
    res:=mryes;
    end;
  if res=mrno then
    begin
		curapp.createprojcopy;
    end;
  if res=mryes then
  	begin
	  curapp.createprojnew;
    end;
  if res<>mrcancel then
    begin
    ts:='';
    while (ts='') do
      begin
      ts:='My Project';
      bres:=inputquery('Choose Project Name','What do you wish to name this Project?',ts);
      end;    // while
    if bres=false then
      begin
      ShowMessage('New Project cancelled');
      end
    else
      begin
      curapp.nname:=ts;
      ts:='';
      bres:=true;
      while (ts='') and (bres=true) do
        begin
        ts:='pdf1.upg';
        bres:=inputquery('Choose Filename','Enter Project Definition File filename:',ts);
        if pos('.upg',ts)= 0 then
          begin
          ts:=ts+'.upg';
          end;
        curapp.ffname:=s.appath+ts;
        curapp.fname:=ts;
        if (fileexists(curapp.ffname)) and (bres=true) then
          begin
          res:=messagedlg('Project File with same name exists. Overwrite?',mtconfirmation,[mbyes,mbno],0);
          if res<>mryes then
            begin
            ts:='';
            end
          end;
        end;    // while
      { Save file }
      if bres=false then
        begin
        ShowMessage('New Project cancelled');
        end
      else
        begin
        savereload;
        wizfm.readproj(curapp);
        wizfm.writeproj(curapp);
        { offer to import }
        res:=messagedlg('Do you want to import a directory structure?',mtconfirmation,[mbyes,mbno],0);
        if res=mryes then
          begin
          folderimport;
          end;
        wizfm.readproj(curapp);
        if wizfm.showproj then
          begin
          wizfm.writeproj(curapp);
          savereload;
          end;
        projname:=curapp.nname;
        end;
      end;
    end;
  end
else
  begin
  result:=false;
  end;
newproj:=false;
end;

function tmainfm.projectrestore:boolean;
var
  bres: boolean;
begin
result:=true;
if not fileexists(curapp.ffname+'.bak') then
  begin
  ShowMessage('No backup file for this Project exists.');
  result:=false;
  end
else
  begin
  bres:=copyfile(pchar(curapp.ffname+'.bak'),pchar(curapp.ffname),false);
  if bres=true then
    begin
    //ShowMessage('Project restored successfully.');
    end
  else
    begin
    showmessage('Project editing could not be undone.');
    result:=false;
    end;
  end;
if result then
  begin
  loadapplists;
  loadcheckbox;
  if cbProject.items.count>0 then
    begin
    cbProject.itemindex:=0;
    curapp:=loadselectedproj;
    updatedisplay;
    end
  else
    begin
    curapp:=tap.create;
    end;
  { set private variables }
  locktv1:=false;
  end;
end;

procedure Tmainfm.tbt9Click(Sender: TObject);
begin
if cbProject.text<>'' then
  begin
	curapp.createlink;
  end;
end;

procedure Tmainfm.ViewFile1Click(Sender: TObject);
begin
if cbProject.text<>'' then
	begin
  curapp.loadviewfm;
  viewfm.show;
  end;
end;

{ Create new Project }
procedure Tmainfm.New1Click(Sender: TObject);
begin
CreateNewProject;
end;

procedure Tmainfm.tbt5Click(Sender: TObject);
begin
CreateNewProject;
end;

procedure Tmainfm.tbt16Click(Sender: TObject);
begin
projecttest;
end;

procedure Tmainfm.Test1Click(Sender: TObject);
begin
projecttest;
end;

procedure Tmainfm.tbt7Click(Sender: TObject);
begin
deployaction(false);
end;

procedure Tmainfm.PullDown1Click(Sender: TObject);
begin
if cbProject.text<>'' then
  begin
  curapp.pulldown(s.stagepath,true,s.xmRunSilent,s.xmCloseEnd);
  end;
end;

{ add folder }
procedure Tmainfm.tbt1Click(Sender: TObject);
begin
if folderadd then
	updatedisplay;
end;


procedure Tmainfm.tbt19Click(Sender: TObject);
begin
projectedit;
end;

procedure Tmainfm.tbt10Click(Sender: TObject);
begin
if viewfm.Visible=false then
	viewfm.show
else
	viewfm.hide;
end;

procedure Tmainfm.tbt13Click(Sender: TObject);
begin
//application.terminate;
close;
end;

procedure Tmainfm.assignhints;
begin

{project menu}
project1.hint:=hproject;
new1.hint:=hnew;
edit1.hint:=hedit;
viewfile1.hint:=hviewfile;
clearstagingarea1.hint:=hclearsa;
pulldown1.hint:=hpulldown;
delete1.hint:=hprojdelete;
exit1.hint:=hexit;
RestoreProjectDefinitionFile1.hint:=hrestore;

ClearDeploymentList1.hint:=hcleardeploy;

{tools menu }
tools1.hint:=htools;
compile1.hint:=hcompile;
test1.hint:=htest;
transmit1.hint:=hdeploy;
createhtml1.hint:=hlink;
viewresults1.hint:=hresult;

{options menu }
view1.hint:=hoptions;
//hints1.hint:=hhints;
proxyserversettings1.hint:=hproxy;

{ help menu }
help1.hint:=hhelp;
ServerHelp1.hint:=hhtmlhelp;
GotoCustomerSupportWebsite1.hint:=hcussup;
Deploysoftwebsite1.hint:=hwebsite;
//LicenceInformation1.hint:=hlicinf;
//Registerthisproduct1.hint:=hlicnow;
AboutServer1.hint:=habout;

{buttons, visual components }
tbt5.hint:=hnew;
tbt17.hint:=hcompile;
tbt16.hint:=htest;
tbt7.hint:=hdeploy;
tbt9.hint:=hlink;
tbt19.hint:=hedit;
tbt10.hint:=hresult;
tbt13.hint:=hexit;

tbt1.hint:=hfoldadd;
tbt2.hint:=hfolddel;
tbt18.hint:=himport;
tbt3.hint:=hfileadd;
tbt14.hint:=hfileed;
tbt4.hint:=hfiledel;
tbfileup.hint:=hfileup;
tbfiledown.hint:=hfiledown;

tbSelectGroup.hint:=hgroup;

m1.hint:=hhintbox;
tv1.hint:=hfoldlist;
lv1.hint:=hfilelist;
end;

procedure Tmainfm.ViewResults1Click(Sender: TObject);
begin
if viewfm.Visible=false then
	viewfm.show
else
	viewfm.hide;
end;

procedure Tmainfm.RestoreProjectDefinitionFile1Click(Sender: TObject);
begin
if cbProject.text<>'' then
  begin
	projectrestore;
  end;
end;

procedure Tmainfm.ClearDeploymentList1Click(Sender: TObject);
begin
{ clear deployment list }
if messagedlg('Are you sure you want to clear the Deployment List?',
mtconfirmation,[mbyes,mbno],0)=mryes then
  begin
  if cbProject.text<>'' then
    begin
    if curapp.cleardeploylist then
      ShowMessage('Deployment List deleted.')
    else
      ShowMessage('Could not delete Deployment List.');
    end;
  end;
end;

procedure Tmainfm.ClearPatchDirectory1Click(Sender: TObject);
begin
{ clear patch directory }
if cbProject.text<>'' then
  begin
  { MO - 16/3/2000
    What is meant to go here? }
  end;
end;

procedure Tmainfm.unloaddlls;
begin
//zm1.Unload_Unz_Dll;
//zm1.Unload_Zip_Dll;
end;

procedure Tmainfm.loaddlls;
begin
//zm1.Load_Unz_Dll;
//zm1.Load_Zip_Dll;
end;


procedure Tmainfm.ftp1Success(Trans_Type: TCmdType);
begin
FTP1Success(trans_type);
end;

procedure Tmainfm.ftp1Connect(Sender: TObject);
begin
FTP1Connect(Sender);
end;

procedure Tmainfm.ftp1ConnectionFailed(Sender: TObject);
begin
FTP1ConnectionFailed(Sender);
end;

procedure Tmainfm.ftp1Disconnect(Sender: TObject);
begin
FTP1Disconnect(Sender);
end;

procedure Tmainfm.ftp1Error(Sender: TComponent; Errno: Word;
  Errmsg: String);
begin
FTP1Error(Sender,Errno,Errmsg);
end;

procedure Tmainfm.ftp1Failure(var Handled: Boolean; Trans_Type: TCmdType);
begin
FTP1Failure(handled,Trans_Type);
end;

procedure Tmainfm.ftp1HostResolved(Sender: TComponent);
begin
FTP1HostResolved(Sender);
end;

procedure Tmainfm.ftp1InvalidHost(var Handled: Boolean);
begin
FTP1InvalidHost(handled);
end;

procedure Tmainfm.ftp1ListItem(Listing: String);
begin
FTP1ListItem(Listing);
end;

procedure Tmainfm.ftp1PacketRecvd(Sender: TObject);
begin
FTP1PacketRecvd(Sender);
end;

procedure Tmainfm.ftp1PacketSent(Sender: TObject);
begin
FTP1PacketSent(Sender);
end;

procedure Tmainfm.ftp1TransactionStart(Sender: TObject);
begin
FTP1TransactionStart(Sender);
end;

procedure Tmainfm.ftp1TransactionStop(Sender: TObject);
begin
FTP1TransactionStop(Sender);
end;

procedure Tmainfm.ftp1UnSupportedFunction(Trans_Type: TCmdType);
begin
FTP1UnSupportedFunction(Trans_Type);
end;

procedure Tmainfm.http1Connect(Sender: TObject);
begin
HTTP1Connect(Sender);
end;

procedure Tmainfm.http1ConnectionFailed(Sender: TObject);
begin
HTTP1ConnectionFailed(Sender);
end;

procedure Tmainfm.http1Disconnect(Sender: TObject);
begin
HTTP1Disconnect(Sender);
end;

procedure Tmainfm.http1Failure(Cmd: CmdType);
begin
HTTP1Failure(Cmd);
end;

procedure Tmainfm.http1HostResolved(Sender: TComponent);
begin
HTTP1HostResolved(Sender);
end;

procedure Tmainfm.http1InvalidHost(var Handled: Boolean);
begin
HTTP1InvalidHost(handled);
end;

procedure Tmainfm.http1PacketRecvd(Sender: TObject);
begin
HTTP1PacketRecvd(Sender);
end;

procedure Tmainfm.http1PacketSent(Sender: TObject);
begin
HTTP1PacketSent(Sender);
end;

procedure Tmainfm.http1Status(Sender: TComponent; Status: String);
begin
HTTP1Status(Sender,Status);
end;

procedure Tmainfm.http1Success(Cmd: CmdType);
begin
HTTP1Success(Cmd);
end;

procedure Tmainfm.ftp1Status(Sender: TComponent; Status: String);
begin
putview(status);
end;

procedure Tmainfm.cbProjectChange(Sender: TObject);
begin
projectchange;
end;

procedure Tmainfm.compileaction;
var
  nosel:boolean;
  c,cm:integer;
  d,dm:integer;
  noprobs:boolean;
  ts:string;
begin
if tbSelectGroup.down then
  begin
  nosel:=true;
  cm:=frmGroupSelect.lbProjects.items.count-1;
  for c:=0 to cm do
    begin
    if frmGroupSelect.lbProjects.selected[c] then
      begin
      nosel:=false;
      ts:=ts+#10+frmGroupSelect.lbProjects.items[c];
      end;
    end;
  if nosel then
    begin
    showmessage('No projects have been selected for group action');
    end
  else
    begin
    ts:='Are you sure you want to prepare these projects?'+ts;
    if messagedlg(ts,mtconfirmation,[mbyes,mbno],0)=mryes then
      begin
      noprobs:=true;
      for c:=0 to cm do
        begin
        if frmGroupSelect.lbProjects.selected[c] then
          begin
          { Need to load curapp }
          cbProject.ItemIndex:=cbProject.Items.IndexOf(frmGroupSelect.lbProjects.items[c]);
          cbProjectchange(application);
          if not curapp.compile(s.stagepath,true,'Preparing Project',true,false) then
            noprobs:=false;
          end;
        end;
      { Probably need to say when one doesn't work }
      if noprobs then
        showmessagE('Project Preparation Successful.')
      else
        ShowMessage('Project Preparation Failed.');
      end;
    end;
  end
else
  begin
  if cbProject.text<>'' then
    begin
    if messagedlg('Are you sure you want to prepare '+curapp.nname+' ?',mtconfirmation,[mbyes,mbno],0)=mryes then
      begin
      if curapp.compile(s.stagepath,true,'Preparing Project',true,false) then
        showmessagE('Project Preparation Successful.')
      else
        ShowMessage('Project Preparation Failed.');
      end;
    sb1.panels[1].text:='';
    end;
  end;
end;

procedure Tmainfm.deployaction(deploytonull:boolean);
var
  c,cm:integer;
  nosel:boolean;
  ts:string;
begin
if tbSelectGroup.down then
  begin
  nosel:=true;
  cm:=frmGroupSelect.lbProjects.items.count-1;
  for c:=0 to cm do
    begin
    if frmGroupSelect.lbProjects.selected[c] then
      begin
      nosel:=false;
      ts:=ts+#10+frmGroupSelect.lbProjects.items[c];
      end;
    end;
  if nosel then
    begin
    showmessage('No projects have been selected for group action');
    end
  else
    begin
    ts:='Are you sure you want to deploy these projects?'+ts;
    if messagedlg(ts,mtconfirmation,[mbyes,mbno],0)=mryes then
      begin
      for c:=0 to cm do
        begin
        if frmGroupSelect.lbProjects.selected[c] then
          begin
          { Need to load curapp }
          cbProject.ItemIndex:=cbProject.Items.IndexOf(frmGroupSelect.lbProjects.items[c]);
          cbProjectchange(application);
          curapp.deploy(s.stagepath,false,s.xmForceAll,true,'Deploying Project',true,false,'',S.xmRunSilent,s.xmCloseEnd,deploytonull);
          end;
        end;
      end;
    end;
  end
else
  begin
  if cbProject.text<>'' then
    begin
    if messagedlg('Are you sure you want to deploy '+curapp.nname+' ?',mtconfirmation,[mbyes,mbno],0)=mryes then
  	  curapp.deploy(s.stagepath,false,s.xmForceAll,true,'Deploying Project',true,false,'',s.xmRunSilent,s.xmCloseEnd,deploytonull);
    end;
  end;
end;

procedure Tmainfm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
canclose:=true;
if DialUpConnected then
  HangUp;
if s.savesettings=false then
  showmessage('Error 15. Could not save settings to registry');
appflist.free;
appilist.free;
appnlist.free;
showtimeleft;
s.free;
curapp.free;
unloaddlls;
end;

procedure Tmainfm.Client1Click(Sender: TObject);
begin
runClient(true,'');
end;

procedure Tmainfm.DistManage1Click(Sender: TObject);
begin
{ Run distribution manager }
runDistMgr(true,'');
end;


procedure Tmainfm.TransLaunchFailed(sender: TObject; evFileName,
  evIdentifier: String; evErrorCode: Integer; evErrorMessage: String);
begin
showmessage('Could not launch transmitter');
TransRunning:=false;
end;

procedure Tmainfm.TransProcCompleted(sender: TObject; evFileName,
  evIdentifier: String; evRetValue: Integer; evTimedOut: Boolean);
begin
TransRunning:=false;
end;

procedure Tmainfm.ClientLaunchFailed(sender: TObject; evFileName,
  evIdentifier: String; evErrorCode: Integer; evErrorMessage: String);
begin
showmessage('Client could not be run.');
ClientRunning:=false;
end;

procedure Tmainfm.ClientProcCompleted(sender: TObject; evFileName,
  evIdentifier: String; evRetValue: Integer; evTimedOut: Boolean);
begin
ClientRUnning:=false;
end;

procedure Tmainfm.DistmgrLaunchFailed(sender: TObject; evFileName,
  evIdentifier: String; evErrorCode: Integer; evErrorMessage: String);
begin
showmessage('Could not run Distribution Manager');
DistMgrRunning:=false;
end;

procedure Tmainfm.DistmgrProcCompleted(sender: TObject; evFileName,
  evIdentifier: String; evRetValue: Integer; evTimedOut: Boolean);
begin
DistMgrRunning := false;
end;


function Tmainfm.setwebcontrols:boolean;
begin
result:=true;
{ sets the internet components firewall/proxy settings to fwallfm values }
try
if  fwallfm.c1.checked then
  begin
  http1.Proxy:=fwallfm.e1.text;
  http1.proxyport:=strtoint(fwallfm.e2.text);
  end
else
  begin
  http1.Proxy:='';
  http1.proxyport:=80;
  end;
except
  showmessagenotsilent('Critical Error. Could not set HTTP server values.');
  result:=false;
end;
try
if fwallfm.c2.checked then
  begin
  ftp1.proxy:=fwallfm.e3.text;
  ftp1.proxyport:=strtoint(fwallfm.e6.text);
  end
else
  begin
  ftp1.proxy:='';
  ftp1.proxyport:=21;
  end;
except
	showmessagenotsilent('Critical Error. Could not set values of FTP control.');
  result:=false;
end;
end;

procedure Tmainfm.ClearRegistrySettings1Click(Sender: TObject);
var
  reg:tregistry;
begin
{ Clear registry settings }
if messagedlg('Are you sure you want to delete the registry settings?',
  mtconfirmation,[mbyes,mbno],0)=mryes then
  begin
  reg:=tregistry.creatE;
  reg.rootkey:=HKEY_LOCAL_MACHINE;
  try
  reg.deletekey(transroot);
  except
  end;
  reg.closekey;
  reg.free;
  showmessage('You must restart the Upgrade Suite Server');
  end;
end;

procedure Tmainfm.tbFileUpClick(Sender: TObject);
var
  tempfold:tapfolder;
  posn:integer;
begin
if tv1.selected<>nil then
  begin
  tempfold:=tv1tofold(tv1.Selected);
  if tempfold<>nil then
    begin
    if lv1.selected<>nil then
			begin
      posn:=tempfold.findfilenam(lv1.selected.Caption);
      if (posn<>-1) and (posn<>0) then
				begin
        tempfold.apfiles.Exchange(posn,posn-1);
        curapp.savetofile;
        updatedisplay;
        end;
      end;
    end;
  end;
end;

procedure Tmainfm.tbFileDownClick(Sender: TObject);
var
  tempfold:tapfolder;
  posn:integer;
begin
if tv1.selected<>nil then
  begin
  tempfold:=tv1tofold(tv1.Selected);
  if tempfold<>nil then
    begin
    if lv1.selected<>nil then
			begin
      posn:=tempfold.findfilenam(lv1.selected.Caption);
      if (posn<>-1) and (posn<>tempfold.apfiles.count-1) then
				begin
        tempfold.apfiles.Exchange(posn,posn+1);
        curapp.savetofile;
        updatedisplay;
        end;
      end;
    end;
  end;
end;

procedure Tmainfm.timListFailTimer(Sender: TObject);
begin
timListFail.enabled:=false;
ListFailed:=true;

end;

procedure Tmainfm.TransmitterSettings1Click(Sender: TObject);
begin
frmxmSettings.showmodal;
end;

procedure Tmainfm.DeploytoNull1Click(Sender: TObject);
begin
deployaction(true);
end;


procedure Tmainfm.PopulateDeploymentList1Click(Sender: TObject);
begin
{ populate deployment list }
if messagedlg('Are you sure you want to populate the Deployment List?',
mtconfirmation,[mbyes,mbno],0)=mryes then
  begin
  if cbProject.text<>'' then
    begin
    if curapp.populatedeploylist(s.stagepath) then
      ShowMessage('Deployment List populated.')
    else
      ShowMessage('Could not populate Deployment List.');
    end;
  end;

end;

procedure Tmainfm.ViewDeploymentList1Click(Sender: TObject);
begin
if cbProject.text<>'' then
	begin
  curapp.loaddeplist;
  viewfm.show;
  end;
end;

procedure Tmainfm.EditDeploymentList1Click(Sender: TObject);
begin
{ Load in notepad }
if cbProject.text<>'' then
  begin
  if shellexecute(0,'open','notepad.exe',pchar(curapp.ffname+'.dep'),pchar(extractfilepath(curapp.ffname)),SW_SHOWNORMAL)<=32 then
    showmessagE('Could not open Deployment List file');
  end;
end;

procedure Tmainfm.tbSelectGroupClick(Sender: TObject);
begin
if tbSelectGroup.Down then
  begin
  if frmGroupSelect=nil then
    frmGroupSelect:=tfrmGroupSelect.create(application);
  frmGroupSelect.showmodal;
  end;
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
p4.Visible:=s.showhints;
s2.visible:=s.showHints;
showhints1.Checked:=s.showhints;
end;

procedure Tmainfm.FormShow(Sender: TObject);
begin
application.onhint:=showhint;
setHintBox;
end;

procedure Tmainfm.CreateNewProject;
var
  projname:string;
begin
projectnew(projname);
loadapplists;
loadcheckbox;
if cbProject.items.count>0 then
	begin
  if projname<>'' then
    begin
    if cbProject.Items.IndexOf(projname)<>-1 then
      cbProject.itemindex:=cbProject.Items.IndexOf(projname)
    else
      cbProject.itemindex:=0;
    end
  else
    cbProject.itemindex:=0;
	curapp:=loadselectedproj;
  updatedisplay;
  end
else
	begin
  curapp:=tap.create;
  end;
{ set private variables }
locktv1:=false;
newproj:=false;
end;

end.
