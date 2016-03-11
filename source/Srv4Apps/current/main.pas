unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, StdCtrls, ExtCtrls, ToolWin, registry, filectrl, Buttons,
   GoToWeb, share, Md5b, shellapi,
  clipbrd, activex, comobj, OleCtrls, ap, apfile, apfolder, recapp, settings,
  pmupgrade, ImgList, NMHttp, Psock, NMFtp, ShellLnk, ZLIBArchive, ExFile,
  TimeOut, PBFolderDialog, appexec, MMJRasConnect, IceLock;

type
  Tmainfm = class(TForm)
    mm1: TMainMenu;
    Exit1: TMenuItem;
    flb1: TFileListBox;
    tb3: TToolBar;
    tbt7: TToolButton;
    il1: TImageList;
    gw1: TGoToWeb;
    tbt17: TToolButton;
    ilock1: tIceLock;
    Help1: TMenuItem;
    AboutServer1: TMenuItem;
    ServerHelp1: TMenuItem;
    View1: TMenuItem;
    Deploysoftwebsite1: TMenuItem;
    Project1: TMenuItem;
    New1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    ClearStagingArea1: TMenuItem;
    Tools1: TMenuItem;
    Compile1: TMenuItem;
    Transmit1: TMenuItem;
    PullDown1: TMenuItem;
    N3: TMenuItem;
    GotoCustomerSupportWebsite1: TMenuItem;
    tbt19: TToolButton;
    ProxyServerSettings1: TMenuItem;
    tbt11: TToolButton;
    ViewResults1: TMenuItem;
    ftp1: TNMFTP;
    http1: TNMHTTP;
    Dia1: TMenuItem;
    timListFail: TTimer;
    pm1: Tpatchmaker;
    timICtimeout: TTimer;
    za: TZLBArchive;
    N7: TMenuItem;
    N8: TMenuItem;
    fdlg: TPBFolderDialog;
    AppExec1: TAppExec;
    ras: TMMJRasConnect;
    ToolButton2: TToolButton;
    N5: TMenuItem;
    pcMain: TPageControl;
    tsProjects: TTabSheet;
    tsFilesFolders: TTabSheet;
    lbProjects: TListBox;
    lv1: TListView;
    s1: TSplitter;
    tv1: TTreeView;
    N6: TMenuItem;
    ScanForFiles1: TMenuItem;
    TransmitterSettings1: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
    procedure FormActivate(Sender: TObject);
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
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Client1Click(Sender: TObject);
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
    procedure ShowHints1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbProjectsClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
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

    { Server for APplications }
    procedure CreateBuildUpdate;
    procedure EditBuildUpdate;
    procedure BuildUpdate;
    procedure DeployUpdate;

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
var
  mainfm: Tmainfm;

implementation

uses wiz, view, splash, about, ltype, fwall, remserv,
  xmSettings;

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
if lbprojects.itemindex<>-1 then
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
if lbprojects.itemindex<>-1 then
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
label1.caption:='Scanning for Files';
result:=false;
application.processmessages;
if (lbprojects.itemindex<>-1) or (newproj) then
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
          if lbprojects.itemindex<>-1 then
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
label1.caption:='';
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
      posn:=tempfold.findfileURL(lv1.selected.Caption);
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
if lbProjects.itemindex=-1 then
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
if lbprojects.itemindex<>-1 then
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
if lbprojects.itemindex<>-1 then
	begin
  result:=tap.create;
  ts:=s.appath+pnametofname(lbProjects.Items[lbprojects.itemindex] );
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
lbProjects.Clear;
lbProjects.Items.AddStrings(appnlist);
lbProjects.Refresh;
end;

function tmainfm.gototab(pnam:string):boolean;
var
	posn:integer;
begin
result:=true;
posn:=lbProjects.items.indexof(pnam);
if posn<>-1 then
	lbProjects.ItemIndex:=posn;
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
    litem.caption:=tempfile.URL;

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

    if tempfile.usepatching then
      litem.subitems.add('Yes') // use patching
    else
      litem.subitems.add('No');
    if tempfile.exclude then
      litem.subitems.add('Yes') // exclude file
    else
      litem.subitems.add('No');

    { shortcut info }
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
if lbprojects.itemindex<>-1 then
	begin
	tv1.items.clear;
	lv1.items.clear;
  end;
end;

procedure Tmainfm.tbt2Click(Sender: TObject);
begin
projectdelete;
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
BuildUpdate;
end;




{ recursively create Project file structure }

procedure Tmainfm.LaunchReceiver1Click(Sender: TObject);
begin
{ need to ask for parameters? }
runClient(true,'');
end;

procedure Tmainfm.pm1ProgressEvent(Sender: TObject; Progress: Real);
begin
label2.caption:=extractfilename(pm1.oldFile)+': '+inttostr(trunc(progress*100)+1)+' %';
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
mainfm.caption:=s4appsCaption;

loaddisttargets;
application.helpfile:=s.ugpath+'svr4apps.hlp';
appnlist:=tstringlist.create;
appilist:=tstringlist.create;
appflist:=tstringlist.create;

loadapplists;
loadcheckbox;
if lbProjects.items.count>0 then
	begin
  lbProjects.ItemIndex:=0;
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
setHintBox;
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
if lbprojects.itemindex<>-1 then
	projectedit;
end;

procedure Tmainfm.Delete1Click(Sender: TObject);
begin
projectdelete;
end;

procedure Tmainfm.ClearStagingArea1Click(Sender: TObject);
begin
{ should offer to delete remote files too }
if lbprojects.itemindex<>-1 then
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
  if lbprojects.itemindex<>-1 then
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
        folderimport;
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
  if lbProjects.items.count>0 then
    begin
    lbProjects.itemindex:=0;
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
if lbprojects.itemindex<>-1 then
  begin
	curapp.createlink;
  end;
end;

procedure Tmainfm.ViewFile1Click(Sender: TObject);
begin
if lbprojects.itemindex<>-1 then
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
DeployUpdate;
end;

procedure Tmainfm.PullDown1Click(Sender: TObject);
begin
if lbprojects.itemindex<>-1 then
  begin
  curapp.pulldown(s.stagepath,true,s.xmRunSilent,s.xmCloseEnd);
  end;
end;

{ add folder }
procedure Tmainfm.tbt1Click(Sender: TObject);
begin
createnewproject;
end;


procedure Tmainfm.tbt19Click(Sender: TObject);
begin
EditBuildUpdate;
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


procedure Tmainfm.ViewResults1Click(Sender: TObject);
begin
if viewfm.Visible=false then
	viewfm.show
else
	viewfm.hide;
end;

procedure Tmainfm.RestoreProjectDefinitionFile1Click(Sender: TObject);
begin
if lbprojects.itemindex<>-1 then
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
  if lbprojects.itemindex<>-1 then
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
if lbprojects.itemindex<>-1 then
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

procedure Tmainfm.compileaction;
var
  nosel:boolean;
  c,cm:integer;
  d,dm:integer;
  noprobs:boolean;
  ts:string;
begin
if lbprojects.itemindex<>-1 then
  begin
  if messagedlg('Are you sure you want to prepare '+curapp.nname+' ?',mtconfirmation,[mbyes,mbno],0)=mryes then
    begin
    if curapp.compile(s.stagepath,true,'Preparing Project',true,false) then
      showmessagE('Project Preparation Successful.')
    else
      ShowMessage('Project Preparation Failed.');
    end;
  label2.caption:='';
  end;
end;

procedure Tmainfm.deployaction(deploytonull:boolean);
var
  c,cm:integer;
  nosel:boolean;
  ts:string;
begin
if lbprojects.itemindex<>-1 then
  begin
  if messagedlg('Are you sure you want to deploy '+curapp.nname+' ?',mtconfirmation,[mbyes,mbno],0)=mryes then
    curapp.deploy(s.stagepath,false,s.xmForceAll,true,'Deploying Project',true,false,'',s.xmRunSilent,s.xmCloseEnd,deploytonull);
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
s.free;
curapp.free;
unloaddlls;
end;

procedure Tmainfm.Client1Click(Sender: TObject);
begin
runClient(true,'');
end;

procedure Tmainfm.TransLaunchFailed(sender: TObject; evFileName,
  evIdentifier: String; evErrorCode: Integer; evErrorMessage: String);
begin
showmessage('Could not launch Updater Deployer');
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
  if lbprojects.itemindex<>-1 then
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
if lbprojects.itemindex<>-1 then
	begin
  curapp.loaddeplist;
  viewfm.show;
  end;
end;

procedure Tmainfm.EditDeploymentList1Click(Sender: TObject);
begin
{ Load in notepad }
if lbprojects.itemindex<>-1 then
  begin
  if shellexecute(0,'open','notepad.exe',pchar(curapp.ffname+'.dep'),pchar(extractfilepath(curapp.ffname)),SW_SHOWNORMAL)<=32 then
    showmessagE('Could not open Deployment List file');
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
//p4.Visible:=s.showhints;
//s2.visible:=s.showHints;
//showhints1.Checked:=s.showhints;
end;

procedure Tmainfm.FormShow(Sender: TObject);
begin
pcMain.activepage:=tsProjects;
end;

procedure Tmainfm.CreateNewProject;
var
  projname:string;
begin
{ Should scan directory }
projectnew(projname);
loadapplists;
loadcheckbox;
if lbProjects.Items.Count>0 then
	begin
  if projname<>'' then
    begin
    if lbProjects.Items.IndexOf(projname)<>-1 then
      lbProjects.itemindex:=lbProjects.Items.IndexOf(projname)
    else
      lbProjects.itemindex:=0;
    end
  else
    lbProjects.itemindex:=0;
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

procedure Tmainfm.lbProjectsClick(Sender: TObject);
begin
projectchange;
end;

procedure Tmainfm.ToolButton2Click(Sender: TObject);
begin
CreateBuildUpdate;
end;

procedure Tmainfm.ToolButton3Click(Sender: TObject);
begin
projectdelete;
end;

procedure Tmainfm.CreateBuildUpdate;
begin
{ Also offer to compile, and deploy to null }
createnewproject;
end;

procedure Tmainfm.EditBuildUpdate;
begin
{ offer to compile and deploy }
projectedit;
end;

procedure Tmainfm.BuildUpdate;
begin
compileaction;
end;

procedure Tmainfm.DeployUpdate;
begin
deployaction(false);
end;

end.
