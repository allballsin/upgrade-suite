unit settings;

interface

uses windows,classes,ap,apfolder,apfile,registry,sysutils,
			filectrl,dialogs,shellapi;

type
	tsettings=class(tobject)
    appath:string; // location of upgrade application subdirectory
    testpath:string; // location of upgrade test html pages
    stagepath:string; // location of upgrade staging directories

    ugpath:string; // location of server program
    xmpath:string; // location of transmitter
    rcpath:string; // location of client
    dmpath:string; // location of deployment manager
    wkpath:string; // location of working area for new files, patches etc.
    temppath:string; // location temp directory;
    bupath:string; // location of backup deployment
    rdpath:string;
    fsavepath:string;
    runrecatstartup:boolean;
    runsilent:boolean;
    showHints:boolean; // show hints windows in each form

    projpath:string;

    windir:string; // windows directory
    sysdir:string; // system directory

    { FTP debug }
    useList:boolean;

//    appflist:tstringlist; // list of current Project file names
//    appnlist:tstringlist; // list of current Project names (associated)
//    appilist:tstringlist;
//    aplist:tlist;

    { Distribution lists }
    DistListIDs:tstringlist;
    DistListNames:tstringlist;

    { temp folders for file/folder editing }
    oldfold,oldparent:tapfolder;

    { Transmitter settings }
    xmRunSilent:boolean;
    xmForceAll:boolean;
    xmCloseEnd:boolean;

    { Timeout Settings }
    timeoutdate:integer;
    function savesettings:boolean;
    function loadsettings:boolean;
    constructor create;
    destructor destroy;
    end;

var
	s:tsettings;

implementation

uses recapp,share;

function tsettings.savesettings:boolean ;
var
  c,cm:integer; // loop counters
begin
result:=true;
end;

function tsettings.loadsettings:boolean;
var
  tpc:pchar;
begin
ClientRunning:=false;
TransRunning:=false;
DistMgrRUnning:=false;

shortdateformat:='d/m/yyyy';
shorttimeformat:='h:mm';
{ MO - 15/3/2000
  This handles the occurrence of no registry settings existing }
tpc:=stralloc(255);
getwindowsdirectory(tpc,254);
windir:=string(tpc);
getsystemdirectory(tpc,254);
sysdir:=string(tpc);
result:=true;

{ MO Paths will be set to current exe directory }
{ Server path }
ugpath:=extractfilepath(paramstr(0));
ugpath:=makedpath(ugpath);
ugpath:=ugpath+'update\';
if not directoryexists(ugpath) then
  forcedirectories(ugpath);
appath:=ugpath+'pdfs\';
if not directoryexists(appath) then
  forcedirectories(appath);
stagepath:=ugpath+'staging\';
if not directoryexists(stagepath) then
  forcedirectories(stagepath);
temppath:=ugpath+'temp\';
if not directoryexists(temppath) then
  forcedirectories(temppath);

{ Transmitter path }
xmpath:=ugpath;
xmpath:=makedpath(xmpath);
if not directoryexists(xmpath) then
  forcedirectories(xmpath);

{ Client path }
rcpath:=ugpath;
rcpath:=makedpath(rcpath);
if not directoryexists(rcpath) then
  forcedirectories(rcpath);

{ Client Paths }
recstagepath:=rcpath+'recstage\';
if not directoryexists(recstagepath) then
	forcedirectories(recstagepath);
rectemppath:=rcpath+'temp\';
if not directoryexists(rectemppath) then
	forcedirectories(rectemppath);
{ path for project files }
projpath:=rcpath+'projects\';
if not fileexists(projpath) then
	forcedirectories(projpath);
{ working path }
wkpath:=rcpath+'workarea\';
if not directoryexists(wkpath) then
  forcedirectories(wkpath);
{ path for project files }
projpath:=rcpath+'projects\';
if not directoryexists(projpath) then
  forcedirectories(projpath);
bupath:=rcpath+'backup\';
if not directoryexists(bupath) then
  forcedirectories(bupath);
rdpath:=rcpath+'redeploy\';
if not directoryexists(rdpath) then
  forcedirectories(rdpath);
{ File Saver Path }
fsavepath:=makedpath(s.rcpath)+'fsave\';
if not directoryexists(fsavepath) then
	forcedirectories(fsavepath);


{ Deployment Manager path }
dmpath:=ugpath;
dmpath:=makedpath(dmpath);
if not directoryexists(dmpath) then
  forcedirectories(dmpath);

{ Show Hints }
showhints:=false;

{ FTP list command? }
uselist:=true;

{ Transmitter Settings }
xmRunSilent:=false;
xmCloseEnd:=true;
xmForceAll:=false;

strdispose(tpc);
savesettings;
end;


constructor tsettings.create;
begin
inherited create;
DistListIDs:=tstringlist.create;
DistListNames:=tstringlist.create;
end;

destructor tsettings.destroy;
begin
DistListIDs.free;
DistListNames.free;
inherited Destroy;
end;

end.
