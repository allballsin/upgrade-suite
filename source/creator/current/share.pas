unit share;

interface

uses {sysutils,forms,windows,classes,
      registry,dialogs,md5,filectrl,
  		shellapi,controls,inifiles,comctrls,
      NMFtp, zipmstr}
    windows,forms,classes,sysutils,dialogs,
    registry,inifiles,zlibarchive,
    nmhttp,nmftp,filectrl,controls,exfile,demo,shellapi;

type
	Tinststatus=(isInstalled,isUninstalled,isPartinstalled,isPartuninstalled,isUnknown);
  Tverstatus=(vsUptodate,vsNewveravail,vsUnknown);
  Tqstatus=(qsWaiting,qsInstalling,qsNotqueued,qsUnknown);
  turltype=(utHTTP,utFTP,utLNF,utUnknown);
  tdlresult=(drSuccess,drFileNotFound,drTimeout,drError,drUnknown,drNotLoggedIn);

  teventobject=class(tobject)
    procedure procCompleted(sender: TObject; evFileName,
      evIdentifier: String; evRetValue: Integer; evTimedOut: Boolean);
    procedure LaunchFailed(sender: TObject; evFileName,
      evIdentifier: String; evErrorCode: Integer; evErrorMessage: String);
    end;

const
  { Demo dates }
  DemoDate=36858; // 31-11-2000
  { Version info }
  wserverCaption='PC Blues Upgrade Suite [Server]';
  wserverVer='Version 2.0';
  wserverBuild='Build 30';

  serverCaption='PC Blues Upgrade Suite [Server]';
  serverVer='Version 2.0';
  serverBuild='Build 30';

  clientCaption='PC Blues Upgrade Suite [Client]';
  clientVer='Version 2.0';
  clientBuild='Build 30';

  transCaption='PC Blues Upgrade Suite [Transmitter]';
  transVer='Version 2.0';
  transbuild='Build 30';

  distmgrCaption='PC Blues Upgrade Suite [Distribution Manager]';
  distmgrVer='Version 2.0';
  distmgrBuild='Build 30';

  s4appsCaption='PC Blues Upgrade Suite [Server for Apps]';
  s4appsVer='Version 1.0';
  s4appsbuild='Build 1';

  c4appsCaption='PC Blues Upgrade Suite [Client for Apps]';
  c4appsVer='Version 1.0';
  c4appsBuild='Build 1';

  x4appsCaption='PC Blues Updater Transmitter';
  x4appsVer='Version 1.0';
  x4appsBuild='Build 1';

  updateFile='update.txt';
  transFile='trans.txt';
                         
  APPSVAL = 1;
  FOLDSVAL = 2;
  FILESVAL = 3;
  UGroot = 'Software\PC Blues\Upgrade Suite';
  proxykey = UGroot+'\Proxy';
  dialupkey = UGroot+'\Dialup';
  transroot = UGroot+'\Config';
  targetroot = UGroot+'\TargetIDs';
  URroot = UGroot + '\Receiver';
  recroot = URroot+'\Config';
  recprojroot = URroot+'\Projects';
  recfsaveroot = URroot+'\FileSave';
  transname = 'Server';
  ugfileext = '.upg';

  { Distribution list constants }
  DistListSection = 'DistributionList';
  DistListFile = 'distlist.ini';
var
  { ftp component }

  { dodgy }
  globalacceptfile:string;
  globalids:string;
  globalbuckdir:string;

  { receiver only }
  recstagepath:string;

  { for debugging }
  curremdir:string;

  { For dialup networking }
  connectionerror:boolean;
  
  { for ftp and http stuff }
  { http status flags }
  httpfilerec:boolean; // http file received
  httperror:boolean; // http error occurred
  httptimeout:boolean; // http timeout occurred

  { ftp status flags }
  ftpfilerec:boolean;
  ftperror:boolean;
  ftptimeout:boolean;
  ftpfileput:boolean;
  ftpauth:boolean;
  ftpconn:boolean;
  ftpcomsuc:boolean;
  { To fix FTP list failures }
  ListFailed:boolean;
  ListWorked:boolean;

	{ string functions }
  rectemppath:string;
  rebootnow:boolean;

  { External Tools }
  clientRunning:boolean;
  transRunning:boolean;
  DistMgrRUnning:boolean;

  { External tools }
  exTrans:texfile;
  exTransEO:tEventobject;
  exClient:texfile;
  exClientEO:teventobject;
  exDistMgr:texfile;
  exDistMgrEO:teventobject;


  { Internet timeout component }
  ictimeout:integer;

  function makedpath(pth:string):string;
  function makewpath(pth:string):string;
  function removesbs(dir:string):string;
  function remfortrail(pth:string):string;
  function getdltype(fl:string):turltype;
  function getserverfromurl(url:string):string;
  function getdirfromurl(url:String): string;
  function getfilefromurl(url:string):string;
  function lastdirfromurl(url:string):string;
  function firstdirfrompath(url:string):string;
  function extractfilenamenoext(fn:string):string;

  { file functions }
	procedure createupdatefile(ids:string);
	function dloadfile(var http:tnmhttp;var ftp:tnmftp;dltype:turltype;sourcefile:string;destfile:string;showerror:boolean;reboot:boolean;useRestore:integer):tdlresult;
  function recdirdel(pathname:string):boolean;

  { check if project installed }
  function isprojinstalled(id:string):boolean;
	function lastdirfromlongpath(path:string):string;
	function longpathtoshort(path:string):string;

  function eng2qs(s:string):tqstatus;
  function eng2is(s:string):tinststatus;
  function eng2vs(s:string):tverstatus;

	function isidregified(id:string):boolean;

  function copyatreboot(src,trg:string;showerror:boolean): boolean;
  function deleteatreboot(fn:string):boolean;

	function isfilezipped(fn:string):boolean;

  function runrecatreboot:boolean;
  function getregifiedids(var tsl:tstringlist):boolean;


  function dontrunrecatreboot:boolean;
  function runreconceatreboot:boolean;
  function getidfromfile(fn:string):string;
  function acceptfile(fn:string;forceaccept:boolean): boolean;
  function patchfilecheck(f1, f2:string):boolean;
  function getfilefrombase(fl:string):string;
  function bytecopy(oldfile,newfile:string):boolean;
  function dirdepth(url:string):integer;

  { FTP AND HTTP SHARED FUNCTIONS }
  procedure sFTP1Success(Trans_Type: TCmdType);
  procedure sFTP1Connect(Sender: TObject);
  procedure sFTP1ConnectionFailed(Sender: TObject);
  procedure sFTP1Disconnect(Sender: TObject);
  procedure sFTP1Error(Sender: TComponent; Errno: Word;Errmsg: String);
  procedure sFTP1Failure(var handled: Boolean; Trans_Type: TCmdType);
  procedure sFTP1HostResolved(Sender: TComponent);
  procedure sFTP1InvalidHost(var handled: Boolean);
  procedure sFTP1ListItem(Listing: String);
  procedure sFTP1PacketRecvd(Sender: TObject);
  procedure sFTP1PacketSent(Sender: TObject);
  procedure sFTP1TransactionStart(Sender: TObject);
  procedure sFTP1TransactionStop(Sender: TObject);
  procedure sFTP1UnSupportedFunction(Trans_Type: TCmdType);

  procedure sHTTP1Connect(Sender: TObject);
  procedure sHTTP1ConnectionFailed(Sender: TObject);
  procedure sHTTP1Disconnect(Sender: TObject);
  procedure sHTTP1Failure(Cmd: CmdType);
  procedure sHTTP1HostResolved(Sender: TComponent);
  procedure sHTTP1InvalidHost(var handled: Boolean);
  procedure sHTTP1PacketRecvd(Sender: TObject);
  procedure sHTTP1PacketSent(Sender: TObject);
  procedure sHTTP1Status(Sender: TComponent; Status: String);
  procedure sHTTP1Success(Cmd: CmdType);


  { ftp commands }
  function ftpconnect(var ftp:tnmftp;host:string;port:integer;userid:string;pword:string):boolean;
  function ftplist(var ftp:tnmftp):tdlresult;
  function ftpabort(var ftp:tnmftp):tdlresult;
  function ftpfileexists(var ftp:tnmftp;fname:String):boolean;
  function ftpdirexists(var ftp:tnmftp;dname:string):boolean;
  function changeto(var ftp:tnmftp;dir:string;list:boolean):boolean;
  function ftpdload(var ftp:tnmftp;rf,lf:string;useRestore:integer):tdlresult;
  function ftpdelfile(var ftp:tnmftp;fl:string):tdlresult;
  function ftpmkdir(var ftp:tnmftp;dir:string):tdlresult;
  function ftpdirdel(var ftp:tnmftp;dir:string):tdlresult;
  function ftpupload(var ftp:tnmftp;lf,rf:string):tdlresult;
  procedure ftpdisconnect(var ftp:tnmftp);
  function ftpisfolder(att:string):boolean;
  function ftpisfile(fl:String):boolean;

  function httpget(var http:tnmhttp;url:String;lf:string):tdlresult;
  procedure httpabort(var http:tnmhttp);

  function buildpath(var ftp:tnmftp;dir:string;go:boolean):boolean;
  procedure ftplistfolders(var ftp:tnmftp;var flist:tstringlist);
  procedure ftplistfiles(var ftp:tnmftp;var flist:tstringlist);

  function ftpwait:tdlresult;
  procedure ftpsetwait;
  function ftploggedin:boolean;
  function ftpconnected:boolean;
  procedure httpsetwait;
  function httpwait:tdlresult;
  procedure putview(str:string);

  procedure showmessagenotsilent(msg:string);

  { Demonstration functions }
  function CheckDemoEnd:boolean;
  procedure ShowTimeLeft;

  { External Tools }
  procedure runDistMgr(look:boolean;param:string);
  procedure runClient(look:boolean;param:string);
  procedure runTransmitter(look:boolean;param:string);

  { Distribution functions }
  procedure loadDistTargets;
  procedure saveDistTargets;

  { Dialup network functions }
  function UseDialUp:boolean;
  procedure DialUpNow;
  function DialUpConnected:boolean;
  procedure HangUp;

implementation

uses fsave, ap,apfile,apfolder,settings,recapp,view,main,fwall;



function extractfilenamenoext(fn:string):string;
var
	posn:integer;
begin
result:=extractfilename(fn);
posn:=pos('.',result);
if posn<>0  then
	delete(result,posn,length(result));
end;

{ returns last directory from url }
function lastdirfromurl(url:string):string;
var
  posn:integer;
  found:boolean;
  ts:string;
begin
result:='error';
{ start at end of string }
posn:=length(url);
{ remove trailing slash if any }
if (url[posn]='\') or (url[posn]='/') then
	begin
	delete(url,posn,1);
  end;

found:=false;
while (posn>0) and (found=false) do
  begin
  { work back to next '/' or '\'}
  ts:=pchaR(copy(url,posn,1));
  if (ts='\') or (ts='/') then
    found:=true;
  dec(posn);
  end;
if posn<>0 then
  delete(url,posn+1,length(url));

found:=false;
while (posn>0) and (found=false) do
  begin
  { work back to next '/' or '\'}
  ts:=pchar(copy(url,posn,1));
  if (ts='\') or (ts='/') then
    found:=true;
  dec(posn);
  end;

if posn<>0 then
  result:=copy(url,posn+2,length(url));
end;

function firstdirfrompath(url:string):string;
var
  posn:integer;
  found:boolean;
  ts:string;
begin
result:='error';
{ remove first,last slashes }
url:=makedpath(remfortrail(url));
posn:=1;
found:=false;
while (posn<length(url)) and (found=false) do
  begin
  inc(posn);
  ts:=pchaR(copy(url,posn,1));
  if (ts='\') or (ts='/') then
    found:=true;
  end;
if posn<>1 then
  begin
  result:=copy(url,1,posn-1);
  end;
end;

function lastdirfromlongpath(path:string):string;
var
  posn:integer;
  found:boolean;
  ts:string;
begin
result:='';
{ start at end of string }
posn:=length(path);
{ remove trailing slash if any }
if (path[posn]='\') or (path[posn]='/') then
	begin
	delete(path,posn,1);
  end;

found:=false;
while (posn>0) and (found=false) do
  begin
  { work back to next '/' or '\'}
  ts:=pchaR(copy(path,posn,1));
  if (ts='\') or (ts='/') then
    found:=true
  else
    dec(posn);
  end;
if posn<>0 then
  result:=copy(path,posn+1,length(path))
else if found=false then
	result:=path;
end;


function makedpath(pth:string):string;
begin
result:='';
if pth<>'' then
	begin
	if pth[length(pth)]<>'\' then
  	pth:=pth+'\';
	result:=pth;
  end;
end;

function makewpath(pth:string):string;
begin
result:='';
if pth<>'' then
	begin
  if pth[length(pth)]<>'/' then
    pth:=pth+'/';
  result:=pth;
  end;
{ also convert \ to / }
while pos('\',result)>0 do
  result[pos('\',result)]:='/';
end;

function removesbs(dir:string):string;
begin
delete(dir,1,1);
result:=copy(dir,1,length(dir)-1);
end;

function remfortrail(pth:string):string;
begin
result:=pth;
if pth<>'' then
	begin
//	if (pth[1]='/') or (pth[1]='\') then
	if (pth[1]='\') then
    { keep leading slash for internet protocols }
  	delete(pth,1,1);
  if (pth<>'') and (pth<>'/') then
  	begin
  	if (pth[length(pth)]='/') or (pth[length(pth)]='\') then
    	delete(pth,length(pth),1);
    end;
  result:=pth;
  end;
end;

{ create file to update }
procedure createupdatefile(ids:string);
var
	ts:string;
  tempf:textfile;
begin
ts:=makedpath(s.rcpath)+updatefile;
assignfile(tempf,ts);
rewrite(tempf);
writeln(tempf,ids);
closefile(tempf);
end;

{ establish type of network file transmission for download }
function getdltype(fl:string):turltype;
begin
result:=utUnknown;
if pos('http:',fl)<>0 then
  result:=utHTTP  // http
else if pos('ftp:',fl)<>0 then
  result:=utFTP  // ftp
else if (pos(':',fl)<>0) or (copy(fl,1,2)='\\') then
	result:=utLNF; // network drive
end;


function getserverfromurl(url:string):string;
var
  posn:integer;
begin
{ return the server from ftp://blah.blah.blah/sdf/sdf/sdf }
{ find // if any }
posn:=pos('//',url);
if posn<>0 then
	begin
  delete(url,1,posn+1);
  end;
{ find / after // if any }
posn:=pos('/',url);
while posn<>0 do
	begin
  delete(url,posn,length(url));
  posn:=pos('/',url);
  end;
result:=url;
end;

{ returns true if fileexists in current FTP directory }
function ftpfileexists(var ftp:tnmftp;fname:String):boolean;
var
  filelist:tstringlist;
begin
{if Usedialup then
  if not DialUpConnected then
    DialUpNow;}
result:=false;
filelist:=tstringlist.create;
if s.uselist then
  begin
  ftplistfiles(ftp,filelist);
  if filelist.indexof(fname)<>-1 then
      result:=true
  else
    result:=true; // assumed
  end;
filelist.free;
end;

{ returns true if directory exists in current FTP directory }
function ftpdirexists(var ftp:tnmftp;dname:string):boolean;
var
  dlist:tstringlist;
begin
{if Usedialup then
  if not DialUpConnected then
    DialUpNow;
}
result:=false;
dlist:=tstringlist.create;
ftplistfolders(ftp,dlist);
if dlist.indexof(dname)<>-1 then
    result:=true;
dlist.free;
end;


function changeto(var ftp:tNMFTP ;dir:string;list:boolean):boolean;
begin
result:=true;
curremdir:=dir;
ftpsetwait;
viewfm.m1.lines.add('  Changing to remote directory: '+dir);
ftp.ChangeDir(dir);
if ftpwait<>drsuccess then
  result:=false;
if not result then
  if not s.runsilent then showmessagenotsilent('Could not change to directory "'+dir+'". You do not have permission or directory does not exist.')
else
  begin
  if list then
    ftplist(ftp);
  end;
end;

{ download a file according to type
	- assumes there is a mainfm around with HTTP1:thttp , FTP1:tftp on it
  - assumes ftp is connected and in correct directory ? }
function dloadfile(var http:tnmhttp;var ftp:tnmftp;dltype:turltype;sourcefile:string;destfile:string;showerror:boolean;reboot:boolean;useRestore:integer):tdlresult;
var
  bres:boolean;
  desttemp:string;
  tempfn:string;
//  za2:TZLBArchive;
begin
result:=drUnknown;
{ Desttemp is a temporary holding file }
desttemp:=destfile+'.zzz';
case dltype of
utHTTP:  begin // http
    { wait for previous file's download to finish }
    deletefile(pchar(desttemp));
    result:=httpget(http,sourcefile,desttemp);
    end;
utFTP:  begin // ftp
    { if not connected then connect }
    if not ftploggedin then
      result:=drNotLoggedIn
    else
      begin
      //sourcefile:=getfilefrombase(sourcefile);
      result:=ftpdload(ftp,sourcefile,desttemp,useRestore);
      end
    end;
utLNF:  begin // local or anything else at the moment
		if not fileexists(sourcefile) then
    	begin
      result:=drFileNotFound;
      if showerror then
      	showmessagenotsilent(sourcefile+' does not exist.');
      end
    else
    	begin
      bres:=copyfile(pchar(sourcefile),pchar(desttemp),false);
      if bres then
        begin
        result:=drsuccess;
        end
      else
        begin
        result:=drError;
        if showerror then
          if not s.runsilent then showmessagenotsilent('Could not copy '+sourcefile+' --> '+desttemp+'. Could not retrieve file.');
        end;
      end;
    end
  else
    begin
    result:=drERror;
    if showerror then
      showmessagenotsilent('Error 206. Download type not known.');
    end;
  end;

{ shift file to new pos }
if result=drSuccess then
  begin
  if not fileexists(desttemp) then
  	begin
    result:=drError;
    if showerror then
    	begin
    	showmessagenotsilent(desttemp+' does not exist.');
      end;
    end;
  end;
if result=drSuccess then
	begin
  if isfilezipped(desttemp) then
    begin
    { unzip - should next line be (desttemp,destfile? ) }
    { This is in working area }
    { Rename target file }
    renamefile(destfile,destfile+'.yyy');
    { MO - 20/3/2000
      Check if file in archive exists }
    mainfm.za.OpenArchive(desttemp);
    mainfm.za.ExtractAll(extractfilepath(desttemp));
    mainfm.za.CloseArchive;
    if fileexists(destfile)  then
      begin
      result:=drsuccess
      end
    else
      begin
      result:=drerror;
      { Replace with old file }
      renamefile(destfile+'.yyy',destfile);
      end;
    end
  else
    begin
    { If not zipped, just copy to destination }
    if copyfile(pchar(desttemp),pchar(destfile),false) then
      begin
      result:=drsuccess
      end
    else
      begin
      result:=drError;
      end;
    end;
  deletefile(pchar(desttemp));
  end;
end;

{ returns fname only from url or full path }
function getfilefromurl(url:string):string;
var
  posn:integer;
  found:boolean;
  ts:string;
begin
result:='error';
found:=false;
{ start at end of string }
posn:=length(url);
{ remove trailing slash if any }
if (url[posn]='\') or (url[posn]='/') then
	begin
	delete(url,posn,1);
  end;

{ check for slashes }
if (pos('\',url)=0) and ( pos('/',url)=0) then
	begin
  result:=url;
  end
else
  begin
  while (posn>0) and (found=false) do
    begin
    { work back to first '/' or '\'}
    if (url[posn]='\') or (url[posn]='/') then
      found:=true;
    dec(posn);
    end;
  if posn<>0 then
    result:=copy(url,posn+2,length(url));
  end;
end;

function isidregified(id:string):boolean;
var
  reg:tregistry;
  tsl:tstringlist;
begin
result:=false;
{ check if registry contains project id
  and overturn result if so }
reg:=tregistry.Create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(recprojroot,true);
tsl:=tstringlist.create;
reg.GetKeyNames(tsl);
if tsl.count=0 then
  result:=false;
if tsl.IndexOf(id)<>-1 then
  result:=true;
tsl.free;
reg.closekey;
reg.free;
end;


function isprojinstalled(id:string):boolean;
var
	tempra:trecapp;
begin
result:=false;
tempra:=trecapp.create;
if tempra.loadfromreg(id) then
  begin
  tempra.checkinstall(s.projpath);
  if tempra.inststatus=isInstalled then
    result:=true
  else
    result:=false;
  end;
end;

function longpathtoshort(path:string):string;
begin
result:=lastdirfromurl(path);
end;


function eng2qs(s:string):tqstatus;
begin
result:=qsUnknown;
if s='Waiting' then
	result:=qsWaiting;
if s='Not Queued' then
	result:=qsNotqueued;
if s='Receiving' then
	result:=qsInstalling;
end;

function eng2is(s:string):tinststatus;
begin
result:=isUninstalled;
if s='Installed' then
	result:=isInstalled;
if s='Uninstalled' then
	result:=isUninstalled;
if s='Part Installed' then
	result:=isPartinstalled;
if s='Part Uninstalled' then
	result:=isPartuninstalled;
end;

function eng2vs(s:string):tverstatus;
begin
result:=vsNewveravail;
if s='Latest' then
	result:=vsUptodate;
end;

function deleteatreboot(fn:string):boolean;
var
	tpc2:pchar;
  initfile:tinifile;
  winver:integer;
begin
result:=true;
{ check windows version }
winver:=win32Platform;
tpc2:=stralloc(255);
if winver=VER_PLATFORM_WIN32_WINDOWS then
  begin
	initfile:=tinifile.creatE(makedpath(s.windir)+'wininit.ini');
  { must be short file names }
  getshortpathname(pchar(fn),tpc2,254);
  initfile.WriteString('rename','NUL',tpc2);
  initfile.free;
  end
else if winver=VER_PLATFORM_WIN32_NT then
  begin
  { may have to be short file names }
  movefileex(pchar(fn),nil,MOVEFILE_DELAY_UNTIL_REBOOT);
  end
else
  begin
  showmessagenotsilent('Error 129. Unrecognised Windows Version.');
  end;
strdispose(tpc2);
end;

function copyatreboot(src,trg:string;showerror:boolean): boolean;
var
	tpc,tpc2:pchar;
  winver:integer;
  initfile:tinifile;
begin
result:=true;
{ check windows version}
winver:=win32Platform;
tpc:=stralloc(255);
tpc2:=stralloc(255);
if winver=VER_PLATFORM_WIN32_NT then
  begin
  { may have to be short file names }
  movefileex(pchar(trg),nil,MOVEFILE_DELAY_UNTIL_REBOOT);
  movefileex(pchar(src),pchar(trg),MOVEFILE_DELAY_UNTIL_REBOOT);
  viewfm.m1.lines.add('  Copy at reboot: '+tpc2+' --> '+tpc);
  end
else if winver=VER_PLATFORM_WIN32_WINDOWS then
  begin
	initfile:=tinifile.create(makedpath(s.windir)+'wininit.ini');
  { must be short file names }
  getshortpathname(pchar(trg),tpc,254);
  getshortpathname(pchar(src),tpc2,254);
	initfile.WriteString('rename','NUL',tpc);
  initfile.writestring('rename',tpc,tpc2);
	initfile.free;
  viewfm.m1.lines.add('  Copy at reboot: '+tpc2+' --> '+tpc);
  end
else
  begin
  result:=false;
  if showerror then
    showmessagenotsilent('Error 207. Unrecognised Windows Version.');
  end;
strdispose(tpc);
strdispose(tpc2);
end;

function isfilezipped(fn:string):boolean;
var
  fl:tfilestream;
  b:array[1..10] of byte;
begin
result:=false;
if fileexists(fn) then
	begin
  try
  fl:=tfilestream.create(fn,fmOpenRead);
  fl.seek(0,sofrombeginning);
  if fl.Read(b,2)=2 then
    begin
    if (b[1]=120) and (b[2]=156){156 = default ; 218 = maximum} then
      begin
      result:=true;
      end;
    end;
  //strdispose(b);
  finally
  fl.free;
  end;
  end;
end;

function runrecatreboot:boolean;
var
  reg:tregistry;
begin
result:=true;
reg:=tregistry.create;
reg.RootKey:=HKEY_LOCAL_MACHINE;
try
  reg.openkey('Software\Microsoft\Windows\CurrentVersion\Run',true);
  reg.writestring('PC Blues Upgrade Suite Client',s.rcpath+'usclient.exe');
except
result:=false;
end;
reg.free;
end;

function runreconceatreboot:boolean;
var
  reg:tregistry;
begin
result:=true;
reg:=tregistry.create;
reg.RootKey:=HKEY_LOCAL_MACHINE;
try
  reg.openkey('Software\Microsoft\Windows\CurrentVersion\RunOnce',true);
  reg.writestring('PC Blues Upgrade Suite Client',s.rcpath+'usclient.exe');
except
result:=false;
end;
reg.free;
end;


function dontrunrecatreboot:boolean;
var
  reg:tregistry;
begin
result:=true;
reg:=tregistry.create;
reg.RootKey:=HKEY_LOCAL_MACHINE;
try
  reg.openkey('Software\Microsoft\Windows\CurrentVersion\Run',true);
  reg.DeleteValue('PC Blues Upgrade Suite Client');
except
result:=false;
end;
reg.free;
end;

function getregifiedids(var tsl:tstringlist):boolean;
var
  reg:tregistry;
begin
result:=true;
reg:=tregistry.Create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(recprojroot,true);
tsl.clear;
reg.GetKeyNames(tsl);
reg.closekey;
reg.free;
end;

//function checkanyFTPinap(ap:tap): boolean;
//var
//  cnt: integer;
//  cntm: integer;
//begin
//result:=false;
//cntm:=ap.apfolds.count-1;
//for cnt:=0 to cntm do
//  begin
//  result:=checkanyFTPinfold(ap.apfolds[cnt]);
//  end;
//end;
//
//function checkanyFTPinfold(fldr:tapfolder):boolean;
//var
//  cnt: integer;
//  cntm: integer;
//begin
//result:=false;
//cntm:=fldr.apfiles.count-1;
//cnt:=0;
//while (cnt<=cntm) and (result=false) do
//  begin
//  if getdltype(apfile(fldr.apfiles[cnt]))=utFTP then
//    result:=true;
//  inc(cnt);
//  end;    // while
//cnt:=0;
//cntm:=fldr.apfolds.count-1;
//while (cnt<=cntm) and (result=false) do
//  begin
//  result:=checkanyftpinfold(apfolder(fldr.apfolds[cnt]));
//  inc(cnt);
//  end;    // while
//end;

function getdirfromurl(url:String): string;
var
  posn:integer;
  found:boolean;
  ts:string;
  goon:boolean;
begin
result:='error';
{ assume there is an FTP or http setting }
{ remove first 2 slashes }
goon:=true;
posn:=pos('/',url);
if posn=0 then
  goon:=false;
if goon then
  begin
  delete(url,1,posn);
  posn:=pos('/',url);
  if posn=0 then
    goon:=false;
  end;
if goon then
  begin
  delete(url,1,posn);
  { get rid of server }
  posn:=pos('/',url);
  if posn=0 then
    goon:=false;
  end;
if goon then
  begin
  delete(url,1,posn);
  { get rid of last file }
  posn:=length(url);
  found:=false;
  while not found do
    begin
    delete(url,length(url),1);
    if (url[length(url)]='/') or (length(url)=0) then
      begin
      found:=true;
      if length(url)>0 then
        delete(url,length(url),1);
      end;
    end;
  result:=url;
  end;
end;

function getidfromfile(fn:string):string;
var
  tempf:textfile;
  screamfound:boolean;
  ts2:string;
begin
result:='';
if fileexists(fn) then
	begin
  { open file and get ID then save as filename }
  assignfile(tempf,fn);
  reset(tempf);
  screamfound:=false;
  while (not EOF(tempf)) and (not screamfound) do
    begin
    readln(tempf,ts2);
    if pos('!',ts2)<>0 then
      screamfound:=true;
    end;
  closefile(tempf);
  if screamfound=true then
    begin
    result:=copy(ts2,2,length(ts2));
    end;
  end;
if result='' then
  begin
  showmessagenotsilent('Could not find ID inside file '+fn);
  end;
end;

function acceptfile(fn:string;forceaccept:boolean): boolean;
var
	tempra:trecapp;
  newfn:string;
  ap:tap;
  id:string;
  za2: tzlbarchive;
  tf:tform;
begin
result:=false;
tempra:=trecapp.create;
{ have checking for shortcuts ? }
if fileexists(fn) then
  begin
  if isfilezipped(fn) then
    begin
    tf:=tform.create(screen);
    za2:=tzlbarchive.create(tf);
    za2.OpenArchive(fn);
    fn:=rectemppath+za2.Files[0].name;
    deletefile(pchar(fn));
    za2.ExtractAll(rectemppath);
    za2.CloseArchive;
    za2.free;
    tf.free;
    end;
  if fileexists(fn) then
    begin
    { move file to projpath }
    id:=getidfromfile(fn);
    if id<>'' then
      begin
      newfn:=makedpath(s.projpath)+id;
      if copyfile(pchar(fn),pchar(newfn),false)=false then
        begin
        showmessagenotsilent('Could not copy Project Definition File ('+fn+') to Projects Directory.');
        end
      else
        begin
        if not tempra.projregified(newfn) then
          begin
          tempra.regify(newfn);
          result:=true;
          globalacceptfile:=newfn;
          globalids:=id;
          end
        else
          begin
          { set version info }
          tempra.loadfromreg(id);
          ap:=tap.create;
          ap.loadfromfile(newfn);
          tempra.latver:=ap.version;
          ap.free;
          tempra.savetoreg;
          result:=true;
          globalacceptfile:=newfn;
          globalids:=id;
          end;
        if not forceaccept then
          begin
          showmessagenotsilent('"'+tempra.name+'" registered with Upgrade Suite Client.');
          end;
        end;
      end
    end
  else
    begin
    showmessagenotsilent('File '+fn+' does not exist. Zipped Project Definition File may be corrupt.');
    end;
  end
else
  begin
  showmessagenotsilent('File '+fn+' does not exist. No action taken.');
  end;
tempra.free;
end;

function patchfilecheck(f1,f2:string):boolean;
begin
result:=true;
//if (not fileexists(f1)) or (not fileexists(f2) ) then
//  result := False;
//if result=true then
//  begin
//  { calculate file size }
//  ftemp:=tfilestream.create(f1,fmOpenRead);
//  fs1:=ftemp.Size;
//  ftemp.free;
//  ftemp:=tfilestream.create(f2,fmOpenRead);
//  fs2:=ftemp.Size;
//  ftemp.free;
//  if (fs1<32) or (fs2<32) then
//    result:=false;
//  end;
end;

function buildpath(var ftp:tnmftp;dir:string;go:boolean):Boolean;
var
  ts,ts2:string;
  dpth:integer;
  c:integer;
begin
result:=true;
if dir<>'' then
  begin
  { You might not be able to change to '.' if directory list
    doesn't display it - same for '..' }
  result:=changeto(ftp,'.',true);
  //result:=true;
  if result then
    begin
    ts2:=firstdirfrompath(dir);
    if (ts2[1]='/')  then
      begin
      result:=changeto(ftp,'/',true);
      if result then
        begin
        delete(ts2,1,1);
        end;
      end;
    if ts2='' then
      ts2:='error';
    dpth:=0;
    while (ts2<>'error') and result do
      begin
      ts:=lastdirfromlongpath(ftp.currentdir);
      if (ts2<>ts) then
        begin
        if not s.uselist then
          if not ftpdirexists(ftp,ts2) then
            ftpmkdir(ftp,ts2);
        if s.uselist then
            ftpmkdir(ftp,ts2);
        result:=changeto(ftp,ts2,true)
        end
      else
        result:=true;
      if result then
        begin
        inc(dpth);
        delete(dir,1,length(ts2)+1);
        ts2:=firstdirfrompath(dir);
        end;
      end;
    if not go then
      begin
      for c:=1 to dpth do
        begin
        changeto(ftp,'..',false);
        end;
      end;
    end;
  end;
end;

function getfilefrombase(fl:string):string;
var
  posn:integer;
begin
result:='';
//posn:=0;
{ get rid of //}
if fl<>'' then
  begin
  posn:=pos('//',fl);
  delete(fl,1,posn+1);
  posn:=pos('/',fl);
  delete(fl,1,posn);
  result:=fl;
  end;


end;

{ this is because copyfile doesn't work with files opened in netscape }
function bytecopy(oldfile,newfile:string):boolean;
var
  ofile,nfile:tfilestream;
  buf:pchar;
  len:integer;
  buflen:integer;
begin
showmessagenotsilent('OldFile: '+oldfile);
showmessagenotsilent('Newfile: '+newfile);
buflen:=1024;
buf:=stralloc(buflen+1);
result:=true;
try
ofile:=tfilestream.create(oldfile,fmOpenRead);
deletefile(pchar(newfile));
nfile:=tfilestream.create(newfile,fmOpenWrite);
len:=buflen;
ofile.read(buf,len);
while len=buflen do
  begin
  nfile.Write(buf,len);
  ofile.Read(buf,len);
  end;
finally
ofile.free;
nfile.free;
end;
strdispose(buf);
end;

{ HTTP AND FTP SHARED FUNCTIONS }

procedure sFTP1Success(Trans_Type: TCmdType);
begin
ictimeout:=0;
  Case Trans_Type of
    cmdChangeDir:   begin
                    mainfm.sb1.panels[1].text := 'ChangeDir success';
                    ftpcomsuc:=true;
                    end;
    cmdMakeDir:     begin
                    mainfm.sb1.panels[1].text := 'MakeDir success';
                    ftpcomsuc:=true;
                    end;
    cmdDelete:      begin
                    mainfm.sb1.panels[1].text := 'Delete success';
                    ftpcomsuc:=true;
                    end;
    cmdRemoveDir:   begin
                    mainfm.sb1.panels[1].text := 'RemoveDir success';
                    ftpcomsuc:=true;
                    end;
    cmdList:        begin
                    mainfm.sb1.panels[1].text := 'List success';
                    ListWorked:=true;
                    ftpcomsuc:=true;
                    end;
    cmdRename:      begin
                    mainfm.sb1.panels[1].text := 'Rename success';
                    ftpcomsuc:=true;
                    end;
    cmdUpRestore:   begin
                    mainfm.sb1.panels[1].text := 'UploadRestore success';
                    ftpfileput:=true;
                    end;
    cmdDownRestore: begin
                    mainfm.sb1.panels[1].text := 'DownloadRestore success';
                    ftpfilerec:=true;
                    end;
    cmdDownload:    begin
                    mainfm.sb1.panels[1].text := 'Download success';
                    ftpfilerec:=true;
                    end;
    cmdUpload:      begin
                    mainfm.sb1.panels[1].text := 'Upload success';
                    ftpfileput:=true;
                    end;
    cmdAppend:      begin
                    mainfm.sb1.panels[1].text := 'UploadAppend success';
                    ftpfileput:=true;
                    end;
    cmdReInit:      begin
                    mainfm.sb1.panels[1].text := 'ReInit success';
                    ftpcomsuc:=true;
                    ftpauth:=false;
                    end;
    cmdAllocate:    begin
                    mainfm.sb1.panels[1].text := 'Allocate success';
                    ftpcomsuc:=true;
                    end;
    cmdNList:       begin
                    mainfm.sb1.panels[1].text := 'NList success';
                    ftpcomsuc:=true;
                    end;
    cmdDoCommand:   begin
                    mainfm.sb1.panels[1].text := 'DoCommand success';
                    ftpcomsuc:=true;
                    end
    else
      begin
      ftpcomsuc:=true;
      end;
  end;
end;

procedure sFTP1Connect(Sender: TObject);
begin
mainfm.sb1.panels[1].text:='Connected';
ftpconn:=true;
ftpauth:=true;
end;

procedure sFTP1ConnectionFailed(Sender: TObject);
begin
ictimeout:=0;
showmessagenotsilent('Connection Failed');
ftperror:=true;
end;

procedure sFTP1Disconnect(Sender: TObject);
begin
If mainfm.sb1 <> nil then
  mainfm.sb1.panels[1].text := 'Disconnected';
ftpconn:=false;
end;

procedure sFTP1Error(Sender: TComponent; Errno: Word;
  Errmsg: String);
begin
  showmessagenotsilent('Error '+IntToStr(Errno)+': '+Errmsg);
ftperror:=true;
end;

procedure sFTP1Failure(var handled: Boolean; Trans_Type: TCmdType);
begin
ictimeout:=0;
  Case Trans_Type of
    cmdChangeDir: mainfm.sb1.panels[1].text := 'ChangeDir failure';
    cmdMakeDir: mainfm.sb1.panels[1].text := 'MakeDir failure';
    cmdDelete: mainfm.sb1.panels[1].text := 'Delete failure';
    cmdRemoveDir: mainfm.sb1.panels[1].text := 'RemoveDir failure';
    cmdList:begin
            mainfm.sb1.panels[1].text := 'List failure';
            listFailed:=true;
            end;
    cmdRename: mainfm.sb1.panels[1].text := 'Rename failure';
    cmdUpRestore: mainfm.sb1.panels[1].text := 'UploadRestore failure';
    cmdDownRestore: mainfm.sb1.panels[1].text := 'DownloadRestore failure';
    cmdDownload: mainfm.sb1.panels[1].text := 'Download failure';
    cmdUpload: mainfm.sb1.panels[1].text := 'Upload failure';
    cmdAppend: mainfm.sb1.panels[1].text := 'UploadAppend failure';
    cmdReInit: mainfm.sb1.panels[1].text := 'ReInit failure';
    cmdAllocate: mainfm.sb1.panels[1].text := 'Allocate failure';
    cmdNList: mainfm.sb1.panels[1].text := 'NList failure';
    cmdDoCommand: mainfm.sb1.panels[1].text := 'DoCommand failure';
  end;
ftperror:=true;
handled:=true;
end;

procedure sFTP1HostResolved(Sender: TComponent);
begin
mainfm.sb1.panels[1].text := 'Host resolved';
end;

procedure sFTP1InvalidHost(var handled: Boolean);
begin
ictimeout:=0;
showmessagenotsilent('Invalid Host');
ftperror:=true;
handled:=true;
end;

procedure sFTP1ListItem(Listing: String);
begin
//sleep(100);
ListWorked:=true;
end;

procedure sFTP1PacketRecvd(Sender: TObject);
begin
mainfm.sb1.panels[1].text := IntToStr(mainfm.ftp1.BytesRecvd)+' of '+IntToStr(mainfm.ftp1.BytesTotal);
application.processmessages;
end;

procedure sFTP1PacketSent(Sender: TObject);
begin
mainfm.sb1.panels[1].text := IntToStr(mainfm.ftp1.BytesSent)+' of '+IntToStr(mainfm.ftp1.BytesTotal);
application.processmessages;
end;

procedure sFTP1TransactionStart(Sender: TObject);
begin
mainfm.sb1.panels[1].text := 'Beginning Data Transfer';
end;

procedure sFTP1TransactionStop(Sender: TObject);
begin
mainfm.sb1.panels[1].text := 'Data Transfer Complete';
end;

procedure sFTP1UnSupportedFunction(Trans_Type: TCmdType);
begin
ictimeout:=0;
  Case Trans_Type of
    cmdChangeDir: showmessagenotsilent('ChangeDir unsupported');
    cmdMakeDir: showmessagenotsilent('MakeDir unsupported');
    cmdDelete: showmessagenotsilent('Delete unsupported');
    cmdRemoveDir: showmessagenotsilent('RemoveDir unsupported');
    cmdList: showmessagenotsilent('List unsupported');
    cmdRename: showmessagenotsilent('Rename unsupported');
    cmdUpRestore: showmessagenotsilent('UploadRestore unsupported');
    cmdDownRestore: showmessagenotsilent('DownloadRestore unsupported');
    cmdDownload: showmessagenotsilent('Download unsupported');
    cmdUpload: showmessagenotsilent('Upload unsupported');
    cmdAppend: showmessagenotsilent('UploadAppend unsupported');
    cmdReInit: showmessagenotsilent('ReInit unsupported');
    cmdAllocate: showmessagenotsilent('Allocate unsupported');
    cmdNList: showmessagenotsilent('NList unsupported');
    cmdDoCommand: showmessagenotsilent('DoCommand unsupported');
  end;
ftperror:=true;
end;


function ftpconnect(var ftp:tnmftp;host:string;port:integer;userid:string;pword:string):boolean;
var
err:boolean;
begin
result:=true;
if ftpconnected then
  begin
  ftpdisconnect(ftp);
  end;
ftp.Host := Host;
ftp.Port := port;
ftp.Timeout := strtoint(fwallfm.ediFCto.text)*1000;
{ Check for password }
if (lowercase(userid)<>'anonymous') and (pword='') then
  inputquery('FTP Server Password Required','Enter Password:',pword);
ftp.UserID := userid;
ftp.Password := pword;
ftpsetwait;
err:=false;
ictimeout:=strtoint(fwallfm.ediFCto.text);
mainfm.timICtimeout.enabled:=true;
ftp.Connect;
if ftpwait<>drsuccess then
  result:=false;
ftp.timeout :=strtoint(fwallfm.ediffto.text)*1000;
ftplist(ftp);
(*
if (ftperror or ftptimeout or err) then
  result:=false
else
  begin
  //mainfm.timListFail.enabled:=true;
  if s.useList then
    begin
    ictimeout:=strtoint(fwallfm.ediFFto.text);
    mainfm.timICtimeout.enabled:=true;
    //ftp.makedirectory('z');
    ftpsetwait;
    ftp.List;
    if ftpwait<>drsuccess then
      result:=false
    end;
  end;
*)
end;

function ftplist(var ftp:tnmftp):tdlresult;
begin
//mainfm.timListFail.enabled:=true;
result:=drsuccess;
if s.useList then
  begin
  //ftp.makedirectory('z');
  ftpsetwait;
  ftp.list;
  result:=ftpwait;
  end;
end;

function ftpabort(var ftp:tnmftp):tdlresult;
begin
ftpsetwait;
ftperror:=true;
ftp.Abort;
result:=ftpwait;
end;


function ftpdload(var ftp:tnmftp;rf,lf:string;useRestore:integer):tdlresult;
var
  pth:string;
  fl:string;
  goon:boolean;
  pd1,pd2:integer;
  tp1,tp2:string;
  c,cm:integer;
begin
{if Usedialup then
  if not DialUpConnected then
    DialUpNow;
}
goon:=true;
pth:='/'+getdirfromurl(rf);
fl:=getfilefromurl(rf);
if ftp.currentdir<>pth then
  begin
  { find path depth }
//  pd1:=dirdepth(rf);
  pd2:=dirdepth(ftp.CurrentDir);
  while (pd2>0) and (goon=true) do
    begin
    goon:=changeto(ftp,'..',false);
    dec(pd2);
    end;
  if goon=true then
    begin
    goon:=changeto(ftp,pth,true);
    end;
  if goon=true then
    begin
    if not ftpfileexists(ftp,fl) then
      goon:=false;
    end;
  end;
if goon then
  begin
  ftpsetwait;
  ftp.Mode(MODE_IMAGE);
  ftpwait;
  ictimeout:=strtoint(fwallfm.ediFFto.text);
  mainfm.timICtimeout.enabled:=true;
  forcedirectories(extractfilepath(lf));
  if useRestore=1 then
    begin
    if fileexists(lf) then
      begin
      { RC3 Check this out better }
      ftpsetwait;
      ftp.DownloadRestore(fl,lf);
      result:=ftpwait;
      end
    else
      begin
      ftpsetwait;
      ftp.Download(fl, lf);
      result:=ftpwait;
      end
    end
  else
    begin
    ftpsetwait;
    ftp.Download(fl,lf);
    result:=ftpwait;
    end;
  end
else
  result:=drError;
end;

function ftpdelfile(var ftp:tnmftp;fl:string):tdlresult;
begin
ftpsetwait;
ftp.Delete(fl);
result:=ftpwait;
end;

function  ftpmkdir(var ftp:tnmftp;dir:string):tdlresult;
begin
ftpsetwait;
ftp.MakeDirectory(dir);
result:=ftpwait;
end;


function  ftpdirdel(var ftp:tnmftp;dir:string):tdlresult;
begin
ftpsetwait;
ftp.RemoveDir(dir);
result:=ftpwait;
end;

function  ftpupload(var ftp:tnmftp;lf,rf:string):tdlresult;
begin
ftpsetwait;
ftp.Mode(MODE_IMAGE);
result:=ftpwait;
ftpsetwait;
ictimeout:=strtoint(fwallfm.ediFFto.text);
mainfm.timICtimeout.enabled:=true;
ftp.Upload(lf,rf);
result:=ftpwait;
end;

procedure ftpdisconnect(var ftp:tnmftp);
var
  err:boolean;
begin
err:=false;
if ftploggedin then
  begin
  ftpsetwait;
  ftp.disconnect;
  if ftpwait<>drsuccess then
    begin
    showmessagenotsilent('Disconnecting from the network caused an error.');
    end;
  end;
end;

function ftpisfolder(att:string):boolean;
begin
{if Usedialup then
  if not DialUpConnected then
    DialUpNow;
}
result:=false;
if (att[1]='d') or (att[1]='l') then
  result:=true;
end;

function ftpisfile(fl:string):boolean;
begin
{if Usedialup then
  if not DialUpConnected then
    DialUpNow;
}
result:=false;
if fl[1]='-' then
  result:=true;
end;


function httpget(var http:tnmhttp;url,lf:String):tdlresult;
begin
{if Usedialup then
  if not DialUpConnected then
    DialUpNow;
}
http.timeout:=strtoint(fwallfm.ediHFto.text)*1000;
http.body:=lf;
httpsetwait;
try
ictimeout:=strtoint(fwallfm.ediHFto.text);
mainfm.timICtimeout.enabled:=true;
http.Get(url);
except
end;
result:=httpwait;
end;

procedure httpabort(var http:tnmhttp);
begin
httpsetwait;
httperror:=true;
try
http.abort;
except
end;
httpwait;
end;

procedure ftplistfiles(var ftp:tnmftp;var flist:tstringlist);
var
  cnt,cntm:integer;
begin
{if Usedialup then
  if not DialUpConnected then
    DialUpNow;
}
{assumes assigned }
flist.clear;
if s.uselist then
  begin
  flist.clear;
  cntm:=ftp.ftpdirectorylist.name.count-1;
  for cnt:=cntm downto 0 do
    begin
    if ftpisfile(ftp.FTPDirectoryList.Attribute[cnt]) then
      flist.add(ftp.ftpDirectoryList.name[cnt]);
    end;
  end;
end;

procedure ftplistfolders(var ftp:tnmftp;var flist:tstringlist);
var
  cnt,cntm:integer;
begin
{if Usedialup then
  if not DialUpConnected then
    DialUpNow;
}
{assumes assigned }
flist.clear;
if s.uselist then
  begin
  cntm:=ftp.FTPDirectoryList.name.count-1;
  flist.clear;
  for cnt:=cntm downto 0 do
    begin
    if ftpisfolder(ftp.FTPDirectoryList.attribute[cnt]) then
      flist.add(ftp.FTPDirectoryList.name[cnt]);
    end;
  end;
end;

function ftploggedin:boolean;
begin
result:=ftpauth;
end;

function ftpconnected:boolean;
begin
{ was result:=ftpconn }
result:=ftpconn;
end;

function ftpwait:tdlresult;
begin
//(drSuccess,drFileNotFound,drTimeout,drError,drUnknown,drNotLoggedIn);
result:=drunknown;
while not (ftpauth or ftperror or ftptimeout or ftpfilerec or ftpfileput or ftpcomsuc or listfailed or listworked) do
  application.processmessages;
if ftpauth or ftpfilerec or ftpfileput or ftpcomsuc or listworked then
  result:=drsuccess;
if ftptimeout then
  result:=drtimeout;
if ftperror or listfailed then
  result:=drerror;
end;

procedure ftpsetwait;
begin
ftptimeout:=false;
ftperror:=false;
ftpfilerec:=false;
ftpfileput:=false;
ftpcomsuc:=false;
listworked:=false;
listfailed:=false;
end;


function httpwait:tdlresult;
begin
//(drSuccess,drFileNotFound,drTimeout,drError,drUnknown,drNotLoggedIn);
result:=drunknown;
while not (httpfilerec or httptimeout or httperror) do
  application.processmessages;
if httpfilerec then
  result:=drsuccess;
if httptimeout then
  result:=drtimeout;
if httperror then
  result:=drerror;
end;

procedure httpsetwait;
begin
httpfilerec:=false; // http file received
httperror:=false; // http error occurred
httptimeout:=false;// http timeout occurred
end;

procedure putview(str:string);
begin
while (str[length(str)]=#13) or (str[length(str)]=#10) do
  delete(str,length(str),1);
viewfm.m1.lines.add('    > '+str);
end;

procedure sHTTP1Connect(Sender: TObject);
begin
mainfm.sb1.panels[1].text := 'Connected'
end;

procedure sHTTP1ConnectionFailed(Sender: TObject);
begin
showmessagenotsilent('Connection Failed');
ictimeout:=0;
httperror:=true;
end;

procedure sHTTP1Disconnect(Sender: TObject);
begin
If mainfm.sb1 <> nil then
//  mainfm.sb1.panels[1].text := 'Disconnected';
end;

procedure sHTTP1Failure(Cmd: CmdType);
begin
ictimeout:=0;
  Case Cmd of
    CmdGET: mainfm.sb1.panels[1].text := 'Get Failed';
    CmdOPTIONS: mainfm.sb1.panels[1].text := 'Options Failed';
    CmdHEAD: mainfm.sb1.panels[1].text := 'Head Failed';
    CmdPOST: mainfm.sb1.panels[1].text := 'Post Failed';
    CmdPUT: mainfm.sb1.panels[1].text := 'Put Failed';
    CmdPATCH: mainfm.sb1.panels[1].text := 'Patch Failed';
    CmdCOPY: mainfm.sb1.panels[1].text := 'Copy Failed';
    CmdMOVE: mainfm.sb1.panels[1].text := 'Move Failed';
//    CmdDELETE: mainfm.sb1.panels[1].text := 'Delete Failed';
    CmdLINK: mainfm.sb1.panels[1].text := 'Link Failed';
    CmdUNLINK: mainfm.sb1.panels[1].text := 'UnLink Failed';
    CmdTRACE: mainfm.sb1.panels[1].text := 'Trace Failed';
    CmdWRAPPED: mainfm.sb1.panels[1].text := 'Wrapped Failed';
  end;
httperror:=true;
end;

procedure sHTTP1HostResolved(Sender: TComponent);
begin
  mainfm.sb1.panels[1].text := 'Host Resolved';
end;

procedure sHTTP1InvalidHost(var handled: Boolean);
begin
ictimeout:=0;
httperror:=true;
end;


procedure sHTTP1PacketRecvd(Sender: TObject);
begin
  mainfm.sb1.panels[1].text := IntToStr(mainfm.http1.BytesRecvd)+' of '+IntToStr(mainfm.http1.BytesTotal)+' retrieved';
end;

procedure sHTTP1PacketSent(Sender: TObject);
begin
  mainfm.sb1.panels[1].text := IntToStr(mainfm.http1.BytesSent)+' of '+IntToStr(mainfm.http1.BytesTotal)+' sent';
end;

procedure sHTTP1Status(Sender: TComponent; Status: String);
begin
  If mainfm.sb1 <> nil then
  Begin
    mainfm.sb1.panels[1].text := status;
    If mainfm.http1.ReplyNumber = 404 then
      mainfm.sb1.panels[1].text := 'Object Not Found';
  End;
putview(status);
end;


procedure sHTTP1Success(Cmd: CmdType);
begin
ictimeout:=0;
  Case Cmd of
    CmdGET: begin
            httpfilerec:=true;
            mainfm.sb1.panels[1].text := 'Get Succeeded';
            end;
    CmdOPTIONS: mainfm.sb1.panels[1].text := 'Options Succeeded';
    CmdHEAD: mainfm.sb1.panels[1].text := 'Head Succeeded';
    CmdPOST: mainfm.sb1.panels[1].text := 'Post Succeeded';
    CmdPUT: mainfm.sb1.panels[1].text := 'Put Succeeded';
    CmdPATCH: mainfm.sb1.panels[1].text := 'Patch Succeeded';
    CmdCOPY: mainfm.sb1.panels[1].text := 'Copy Succeeded';
    CmdMOVE: mainfm.sb1.panels[1].text := 'Move Succeeded';
//    CmdDELETE: mainfm.sb1.panels[1].text := 'Delete Succeeded';
    CmdLINK: mainfm.sb1.panels[1].text := 'Link Succeeded';
    CmdUNLINK: mainfm.sb1.panels[1].text := 'UnLink Succeeded';
    CmdTRACE: mainfm.sb1.panels[1].text := 'Trace Succeeded';
    CmdWRAPPED: mainfm.sb1.panels[1].text := 'Wrapped Succeeded';
  end;
end;

function dirdepth(url:string):integer;
var
  ti:integer;
  ts:string;
begin
result:=0;
//url:=getdirfromurl(url);
while (url<>'') and (url<>'/') do
  begin
  ts:=lastdirfromlongpath(url);
  if (ts<>'') then
    begin
    inc(result);
    delete(url,pos(ts,url),length(url));
    url:=remfortrail(url);
    end
  else
    begin
    inc(result);
    url:='';
    end;
  end;
end;

procedure showmessagenotsilent(msg: string);
begin
if not s.runsilent then
  showmessage(msg);
end;

{ recursive directory delete }
function recdirdel(pathname:string):boolean;
var
  cnt,cntm:integer;
  td:string;
  res:integer;
begin
result:=true;
res:=mryes;
if (pathname='\') or (pathname='') or (pathname=extractfiledrive(pathname)) then
	res:=messagedlg('This program has been instructed to delete all files in the '+pathname+' directory. Are '+
  'you sure you want to do this?',mtconfirmation,[mbno,mbyes],0);
if res=mryes then
	begin
  pathname:=makedpath(pathname);
  if directoryexists(pathname) then
    begin
    { delete files }
    mainfm.flb1.directory:=pathname;
    mainfm.flb1.Mask:='*.*';
    mainfm.flb1.filetype:=[ftNormal,ftReadOnly,ftArchive];
    viewfm.m1.lines.add('  Directory: '+mainfm.flb1.directory);
    cntm:=mainfm.flb1.Items.count-1;
    for cnt:=cntm downto 0 do
      begin
      if deletefile(mainfm.flb1.items[cnt]) then
        viewfm.m1.lines.add('    '+mainfm.flb1.items[cnt]+': Deleted')
      else
        viewfm.m1.lines.add('    '+mainfm.flb1.items[cnt]+': Not deleted');
      end;
    { delete subdirectories }
    mainfm.flb1.FileType:=[ftDirectory];
    cntm:=mainfm.flb1.items.count-1;
    for cnt:= cntm downto 2 do
      begin
      mainfm.flb1.FileType:=[ftDirectory];
      mainfm.flb1.directory:=pathname;
      td:=pathname+removesbs(mainfm.flb1.items[cnt]);
      recdirdel(td);
      end;
    { delete self }
    try
      mainfm.flb1.Directory:='..';
      rmdir(pathname);
    except
    end;
    end;
  end;
end;

procedure ShowTimeLeft;
var
  daysleft:integer;
begin
{$ifdef demo }
frmDemo.Label1.Caption:='This demonstration software has '+inttostr(round(s.timeoutdate-date))+' days left.'#10#10+
  'Please contact PC Blues (http://www.pcblues.com) for further information, or purchasing.';
frmDemo.showmodal;
{$endif}
end;

function CheckDemoEnd:boolean;
begin
result:=true;
{$ifdef demo}
try
if now>s.timeoutdate then
  begin
  showmessage('This demonstration software expired on '+datetimetostr(s.timeoutdate)+'.'+#10#10+
  'Please contact PC Blues (http://www.pcblues.com) for further information, or purchasing.');
  halt;
  end;
except
end;
{$endif}
end;

{ External Tools }
procedure runClient(look:boolean;param:string);
begin
//shellexecute(0,'open',pchar(s.rcpath+'usclient.exe'),pchar(param),pchar(s.rcpath),SW_SHOWNORMAL);
application.Minimize;
mainfm.AppExec1.ExeName:=s.rcpath+'usclient.exe';
mainfm.AppExec1.ExeParams.clear;
mainfm.AppExec1.ExeParams.Add(param);
mainfm.AppExec1.ExePath:=s.rcpath;
mainfm.AppExec1.Wait:=true;
mainfm.AppExec1.Execute;
application.restore;
application.bringtofront;
{mainfm.ActivApp1.ExePath:=s.rcpath+'dsclient.exe '+param;
mainfm.ActivApp1.MainFormTitle:=clientCaption;
if look then
  mainfm.ActivApp1.ActivateApp
else
  mainfm.ActivApp1.ExecuteApp(true);
}

{if ClientRunning then
  begin
  showmessage('Client is already running.');
  end
else
  begin
  if exClient=nil then
    exClient:=texfile.create(application);
  exClient.ProcFileName:=s.rcpath+'dsclient.exe';
  exClient.ProcParameters:=param;
  exClient.ProcCurrentDir:=s.rcpath;
  exClient.ProcIdentifier:='client';
  exClient.WaitUntilDone:=wait;
  if exClientEO=nil then
    exClientEO:=teventobject.create;
  exClient.OnProcCompleted:=exClientEO.proccompleted;
  exClient.OnLaunchFailed:=exClientEO.launchfailed;
  ClientRunning:=true;
  exClient.Execute;
  ClientRunning:=true;
  if exClient=nil then
    exClient:=texfile.create(application);
  exClient.WaitUntilDone:=false;
  exClient.Execute;
  end;}
end;

procedure runDistMgr(look:boolean;param:string);
begin
{ Run Distribution manager }
//shellexecute(0,'open',pchar(s.dmpath+'usDstmgr.exe'),pchar(param),pchar(s.dmpath),SW_SHOWNORMAL);
application.Minimize;
mainfm.AppExec1.ExeName:=s.dmpath+'usdstmgr.exe';
mainfm.AppExec1.ExeParams.clear;
mainfm.AppExec1.ExeParams.Add(param);
mainfm.AppExec1.ExePath:=s.dmpath;
mainfm.AppExec1.Wait:=true;
mainfm.AppExec1.Execute;
application.restore;
application.bringtofront;

{
mainfm.ActivApp1.ExePath:=s.dmpath+'dsDstmgr.exe '+param;
mainfm.ActivApp1.MainFormTitle:=distmgrCaption;
if look then
  mainfm.ActivApp1.ActivateApp
else
  mainfm.ActivApp1.ExecuteApp(true);
}
{if DistMgrRunning then
  showmessage('Distribution Manager is already running')
else
  begin
  if exDistMgr=nil then
    exDistMgr:=texfile.create(application);
  exDistMgr.ProcFileName:=s.dmpath+'dsDstmgr.exe';
  exDistMgr.ProcParameters:=param;
  exDistMgr.ProcCurrentDir:=s.dmpath;
  exDistMgr.ProcIdentifier:='distmgr';
  exDistMgr.WaitUntilDone:=wait;
  if exDistMgrEO=nil then
    exDistMgrEO:=teventobject.create;
  exDistMgr.OnProcCompleted:=exDistMgrEO.proccompleted;
  exDistMgr.OnLaunchFailed:=exDistMgrEO.launchfailed;
  DistMgrRunning:=true;
  exDistMgr.Execute;
  end;}
end;

procedure runTransmitter(look:boolean;param:string);
begin
{ Run Transmitter }
//shellexecute(0,'open',pchar(s.xmpath+'ustrnsmt.exe'),pchar(param),pchar(s.xmpath),SW_SHOWNORMAL);
application.Minimize;
mainfm.AppExec1.ExeName:=s.xmpath+'ustrnsmt.exe';
mainfm.AppExec1.ExeParams.clear;
mainfm.AppExec1.ExeParams.Add(param);
mainfm.AppExec1.ExePath:=s.xmpath;
mainfm.AppExec1.Wait:=true;
mainfm.AppExec1.Execute;
application.restore;
application.bringtofront;

{
mainfm.ActivApp1.ExePath:=s.xmpath+'dstrnsmt.exe '+param;
mainfm.ActivApp1.MainFormTitle:=transCaption;
if look then
  mainfm.ActivApp1.activateapp
else
  mainfm.ActivApp1.executeapp(true);
  }

{ Run Transmitter }
{if transRunning then
  begin
  showmessage('Transmitter is already running');
  end
else
  begin
  if extrans=nil then
    exTrans:=texfile.create(application);
  extrans.ProcFileName:=s.xmpath+'dstrnsmt.exe';
  extrans.ProcParameters:=param;
  extrans.ProcCurrentDir:=s.xmpath;
  extrans.ProcIdentifier:='transmitter';
  extrans.WaitUntilDone:=wait;
  if exTransEO=nil then
    exTRansEO:=tEventObject.create;
  extrans.OnProcCompleted:=exTransEO.proccompleted;
  extrans.OnLaunchFailed:=exTRansEO.launchfailed;
  TransRunning:=true;
  extrans.Execute;
  end;}
end;

procedure tEventObject.procCompleted(sender: TObject; evFileName,
  evIdentifier: String; evRetValue: Integer; evTimedOut: Boolean);
begin
if evIdentifier='transmitter' then
  begin
  transrunning:=true;
  end;
if evIdentifier='client' then
  clientrunning:=true;
if evIdentifier='distmgr' then
  DistMgrRUnning:=true;
showmessage(evIdentifier +' has completed');
end;

procedure tEventObject.LaunchFailed(sender: TObject; evFileName,
  evIdentifier: String; evErrorCode: Integer; evErrorMessage: String);
begin
if evIdentifier='transmitter' then
  begin
  showmessage('Could not launch Transmitter'+#10+evErrorMessage);
  transrunning:=false;
  end;
if evIdentifier='client' then
  begin
  showmessage('Could not launch Client'+#10+evErrorMessage);
  Clientrunning:=false;
  end;
if evIdentifier='distmgr' then
  begin
  showmessage('Could not launch Distribution Manager'+#10+evErrorMessage);
  DistMgrrunning:=false;
  end;
end;

{ Distribution functions }
procedure loadDistTargets;
var
  ini:tinifile;
  c,cm:integer;
begin
s.DistListIDs.clear;
s.DistListNames.clear;
ini:=tinifile.create(s.dmpath+distlistfile);
if ini.SectionExists(distlistsection) then
  begin
  ini.ReadSection(distlistsection,s.DistListIDs);
  cm:=s.DistListIDs.count-1;
  for c:=0 to cm do
    begin
    s.DistListNames.add(ini.ReadString(distlistsection,s.DistListIDs[c],'No Name '+inttostr(c)));
    end;
  end;
end;

procedure saveDistTargets;
var
  ini:tinifile;
  c,cm:integer;
begin
ini:=tinifile.Create(s.dmpath+distlistfile);
if s.DistListIDs.count<>0 then
  begin
  ini.EraseSection(distlistsection);
  cm:=s.DistListIDs.count-1;
  for c:=0 to cm do
    begin
    ini.WriteString(distlistsection,s.DistLIstIDs[c],s.DistListNames[c]);
    end;
  end;
ini.free;
end;

{ Dialup network functions }
function UseDialUp:boolean;
begin
result:=false;
//result:=frmDialup.cbUseDial.checked;
end;

procedure DialUpNow;
begin
//frmDialup.DialUp1.entry:=frmDialUp.cbConnections.text;
//frmDIalup.DialUp1.SetEntryUserName(frmDIalup.ediUserName.text);
//frmDIalup.DialUp1.SetEntryPassword(frmDIalup.ediPassword.text);
//frmDialup.DialUp1.Dial;
end;

function DialUpConnected:boolean;
begin
//frmDialup.Dialup1.GetConnections;
//if frmDialup.ediactiveconnection.text<>'' then
//  result:=true
//else
//  result:=false;
end;

procedure HangUp;
begin
//frmDialup.Dialup1.HangUp;
//frmDialup.DialUp1.HangUpConn(frmDialup.OpenConnection);
//frmDialup.OpenConnection:=0;
//frmDialUp.ediActiveConnection.text:='';
end;


end.

