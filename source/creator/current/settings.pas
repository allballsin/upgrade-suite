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
  reg:tregistry;
  c,cm:integer; // loop counters
begin
result:=true;
reg:=tregistry.create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(transroot,true);
try
  reg.WriteString('ugpath',ugpath);
except
  result:=false;
end;
try
  reg.writestring('xmpath',xmpath);
except
  result:=false;
end;
try
  reg.writestring('rcpath',rcpath);
except
  result:=false;
end;
try
  reg.writestring('dmpath',dmpath);
except
  result:=false;
end;

try
  reg.writebool('uselistcommand',uselist);
except
  result:=false;
end;

try
  reg.writebool('xmsilentmode',xmRunSilent);
except
  result:=false;
end;

try
  reg.writebool('xmcloseend',xmCloseEnd);
except
  result:=false;
end;

try
  reg.writebool('xmforceall',xmForceAll);
except
  result:=false;
end;

{ Save showHints setting }
try
  reg.writebool('showhints',showHints);
except
  result:=false;
end;


reg.closekey;
reg.free;
end;

function tsettings.loadsettings:boolean;
var
  reg:tregistry;
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
reg:=tregistry.create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(transroot,true);

{ MO Paths will be set to current exe directory }
{ Server path }
ugpath:=extractfilepath(paramstr(0));
ugpath:=makedpath(ugpath);
if not directoryexists(ugpath) then
  forcedirectories(ugpath);
appath:=ugpath+'pdfs\';
if not directoryexists(appath) then
  forcedirectories(appath);
stagepath:=ugpath+'staging\';
if not directoryexists(stagepath) then
  forcedirectories(stagepath);
//testpath:=stagepath+'html\';
//if not directoryexists(testpath) then
//  forcedirectories(testpath);
temppath:=ugpath+'temp\';
if not directoryexists(temppath) then
  forcedirectories(temppath);



{ Transmitter path }
xmpath:=extractfilepath(paramstr(0));
(*if reg.ValueExists('xmpath') then
  xmpath:=reg.readstring('xmpath');
if xmpath='' then
  begin
  xmpath:=extractfilepath(paramstr(0));
  //if not inputquery('No Transmitter Path','Enter Working Path',xmpath) then
  //  halt;
  end;
*)
xmpath:=makedpath(xmpath);
if not directoryexists(xmpath) then
  forcedirectories(xmpath);

{ Client path }
rcpath:=extractfilepath(paramstr(0));
(*
if reg.ValueExists('rcpath') then
  rcpath:=reg.readstring('rcpath');
if rcpath='' then
  begin
  rcpath:=extractfilepath(paramstr(0));
  //if not inputquery('No Client Path','Enter Working Path',rcpath) then
  //  halt;
  end;
*)
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
dmpath:=extractfilepath(paramstr(0));
(*
if reg.ValueExists('dmpath') then
  dmpath:=reg.readstring('dmpath');
if dmpath='' then
  begin
  dmpath:=extractfilepath(paramstr(0));
  //if not inputquery('No Deployment Manager Path','Enter Working Path',dmpath) then
  //  halt;
  end;
*)
dmpath:=makedpath(dmpath);
if not directoryexists(dmpath) then
  forcedirectories(dmpath);

{ Show Hints }
if reg.ValueExists('showhints') then
  showHints:=reg.readbool('showhints')
else
  showhints:=false;

{ What is this? }
if reg.ValueExists('uselistcommand') then
  useList:=reg.readbool('uselistcommand')
else
  useList:=true;

{ Transmitter Settings }
if reg.ValueExists('xmsilentmode') then
  xmRunSilent:=reg.readbool('xmsilentmode')
else
  xmRunSilent:=false;

if reg.ValueExists('xmcloseend') then
  xmCloseEnd:=reg.readbool('xmcloseend')
else
  xmCloseEnd:=true;

if reg.ValueExists('xmforceall') then
  xmForceAll:=reg.readbool('xmforceall')
else
  xmForceAll:=false;

{ Save time out date if not already }
try
  timeoutdate:=reg.ReadInteger('tocom');
except
  reg.writeinteger('tocom',round(date)+40);
  timeoutdate:=round(date)+40;
end;

reg.closekey;
reg.free;
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
