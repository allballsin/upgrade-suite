unit ap;

interface
uses windows,apfile,apfolder,classes,sysutils,activex,dialogs,comobj,controls,
		shellapi,filectrl,md5b,clipbrd,comctrls,forms,zlibarchive,pmupgrade,shlobj;

type
{Decides what foldertypes to accept and whether to show path.}
	TBrowseInfoFlags=(OnlyComputers, OnlyPrinters, OnlyDomains, OnlyAncestors,
		OnlyFileSystem, ShowPath);
{Decides what foldertypes to accept and whether to show path.}
	TBrowseInfoFlagSet=set of TBrowseInfoFlags;

  Tap = class(tobject)
    winfold,sysfold,rootfold:tapfolder;
    id:string;
    nname:string;
    fname:string; // name of file without path
    deflocdir:string;
    baseurl:string;
    ownloc:string;
    apfolds:tlist;
    parentname:tstringlist;
    parentid:tstringlist;
    version:string;
    ugdepth:integer;
		readmefile:string;
		vendwebsite:string;
		vendemail:string;
		runfile:string;
    zipfiles:integer;
    ffname:string; // full name of project file

    { This is only used by Server }
    server:string;
    username:string;
    password:string;
    remdir:string;
    transtype:integer; // upload type
    { 0 - FTP server }
    { 1 - Local/ Network Directory }
    bucketdir:string; // location of files
    ftpport:integer; // ftpport for upload

    { Scheduling properties }
    scheduleupgrade:integer;
    upgradedate:tdate;
    upgradetime:ttime;

    { Selective distribution properties }
    TargetDistID:tstringlist;
    TargetDistName:tstringlist;

    { FTP file restore option }
     useRestore:integer;

    constructor create;
    destructor destroy;override;
    function findfold(fnam:string):tapfolder;
    function loadfromfile(fnam:string):boolean;
    function loadserfromfile(fnam:string):boolean;
    function savetofile:boolean;
    function addfold(var fold:tapfolder):boolean;
  private
    tfile:textfile;
    deploylist:tstringlist;
    stagefilelist:tstringlist;
    ppath:string;
    function id2srec(ap:tap;cfold:tapfolder;var cfnew:tapfolder;installdir:string):boolean;
    function installdirtosource(ap:tap;instdir:string): boolean;
    function ffoldrec(curf:tapfolder;fnam:string):tapfolder;
    function stofrec(curf:tapfolder):boolean;
    function compilerec(stagepath:string;curf:tapfolder;dlist:boolean):boolean;
    function popdlrec(stagepath:string;curf:tapfolder):boolean;
    function assignid:string;
    function clearvals:boolean;
    function clearfolds:boolean;
    function createfolds:boolean;
    function createroot:boolean;
    function createwindir:boolean;
    function createsysdir:boolean;

    function getdesktoppath:string;
  public
    function cleardeploylist:boolean;
    function populatedeploylist(stagepath:string):boolean;
    procedure showdeploylist(title:string);
    procedure removestagefilelist;
	  function longpathtofold(path:string):tapfolder;
	  function foldtolongpath(fold:tapfolder):string;
    function foldtosname(fnam:string):string;
    function savetodeployfile(stagepath:string): boolean;
    function snametofold(fnam:string):string;
    function findfile(fnam:string;folder:tapfolder):tapfile;
    function realsourcedir(fldr:string):string;
    function projectdelete(stagepath:string):boolean;
    function deletefold(fold:tapfolder):boolean;

    function maketest(ap:tap):boolean;
    function makebackup(ap:tap):boolean;
    function makeredeploy(ap:tap):boolean;
    function createprojnew:boolean;
    function createprojcopy:boolean;
    function clearstagingarea(stagepath:string;msg:string;quiet:boolean):boolean;
    function createlink:boolean;
    function loadviewfm:boolean;
    function loaddeplist:boolean;
		function compile(stagepath:string;dlist:boolean;status:string;creflag:boolean;nohints:boolean):boolean;
    function deploy(stagepath:string;wt:boolean;forceall:boolean;valcontquiet:boolean;
    status:string;creflag:Boolean;test:boolean;appname:string;silentmode:boolean;
    closeonfinish:boolean;deploytonull:boolean):boolean;
    function mirror(stagepath:string;newver:string):boolean;
    function receive(stagepath:string):boolean;
    function redeploy(stagepath:string;wt:boolean):boolean;
    function pulldown(stagepath:string;wt:boolean;silentmode:boolean;closeonfinish:boolean):boolean;
    function validate(valcontquiet:boolean;creflag:boolean):boolean;
  end;

const
	NUMBER_OF_BROWSE_INFO_FLAGS=6;

implementation

uses share,remserv,settings,ltype,view,recapp,shelllnk,main;



{ delete files from deployment area }
function Tap.pulldown(stagepath:string;wt:boolean;silentmode:boolean;closeonfinish:boolean):boolean;
var
  parm:string;
begin
result:=false;
{ check directories }
if not fileexists(ffname) then
  begin
  if not s.runsilent then
    showmessagenotsilent(ffname+' does not exists. Project cannot be pulled down.');
  end
else
  begin
  Screen.Cursor := crHourGlass;
  try
    mainfm.label1.caption:='Pulling Down Project';
    result:=true;
    { Transmit the Project to the web }
    { Call the transmitter program }
    parm:='p "'+ffname+'" "'+stagepath+'" ';
    parm:=parm+' forceall ';
    parm:=parm+' nohack ';
    if silentmode then
      parm:=parm+' silent '
    else
      parm:=parm+' nosilent ';
    if closeonfinish then
      parm:=parm+' close '
    else
      parm:=parm+' noclose ';
    parm:=parm+' copy ';
    runTransmitter(false,parm)
  finally
  	Screen.Cursor := crDefault;
  end;  // try/finally
  end;
end;

function Tap.createfolds:boolean;
var
  r1,r2,r3:boolean;
begin
result:=false;
r1:=createroot;
r2:=createwindir;
r3:=createsysdir;
apfolds:=tlist.create;
parentname:=tstringlist.create;
parentid:=tstringlist.create;
TargetDistID:=tstringlist.create;
TargetDistName:=tstringlist.create;
result:=r1 and r2 and r3;
end;

function Tap.createroot:boolean;
begin
result:=true;
try
rootfold:=tapfolder.creatE(nil);
rootfold.name:=deflocdir;
except
result:=false;
end;
end;

function Tap.createwindir:boolean;
var
	tpc:pchar;
begin
result:=true;
try
tpc:=stralloc(255);
winfold:=tapfolder.create(nil);
getwindowsdirectory(tpc,254);
winfold.name:=tpc;
strdispose(tpc);
except
result:=false;
end;
end;

function Tap.createsysdir:boolean;
var
	tpc:pchar;
begin
result:=true;
try
tpc:=stralloc(255);
sysfold:=tapfolder.create(nil);
getsystemdirectory(tpc,254);
sysfold.name:=tpc;
strdispose(tpc);
except
result:=false;
end;
end;

function Tap.clearfolds:boolean;
begin
result:=true;
try
  sysfold.free;
except
result:=false;
end;
try
  winfold.free;
except
result:=false;
end;
try
  rootfold.free;
except
result:=false;
end;
try
	apfolds.free;
except
result:=false;
end;
try
  parentname.free;
except
result:=false;
end;
try
parentid.free;
except
result:=false
end;
try
  TargetDistID.free;
except
result:=false;
end;
try
  TargetDistName.free;
except
result:=false;
end;
end;

function Tap.clearvals:boolean;
begin
result:=true;
try
{ set values to 0 }
nname:='';
version:='';
fname:='';
deflocdir:='';
baseurl:='';
transtype:=1;
server:='';
username:='';
password:='';
remdir:='';
ugdepth:=3;
zipfiles:=1;
vendwebsite:='';
vendemail:='';
runfile:='';
readmefile:='';
bucketdir:='';
scheduleupgrade:=0;
upgradedate:=0;
upgradetime:=0;
useRestore:=0;
except
result:=false;
end;
end;

{ creates a new guid }
function Tap.assignid:string;
var
	tempguid:tguid;
begin
result:='';
if cocreateguid(tempguid)<>S_OK then
  begin
    showmessagenotsilent('Error 46. Could not generate ID for Project');
  end
else
  result:=guidtostring(tempguid);
end;

{ clear variables and assign new ID }
function Tap.createprojnew;
var
  r1,r2,r3:boolean;
begin
id:=assignid;
r1:=clearvals;
r2:=clearfolds;
r3:=createfolds;
result:=r1 and r2 and r3;
end;

{ creates copy of project }
function Tap.createprojcopy;
begin
result:=true;
try
id:=assignid;
except
result:=false;
end;
version:='';
fname:='';
end;

function Tap.loadviewfm:boolean;
var
  sl:tstringlist;
begin
result:=true;
try
sl:=tstringlist.create;
//viewfm.m1.Clear;
viewfm.m1.lines.add('');
viewfm.m1.lines.add('--- PROJECT DEFINITION FILE: '+ffname);
viewfm.m1.lines.add('');
if fileexists(ffname) then
  begin
  sl.LoadFromFile(ffname);
	viewfm.m1.Lines.AddStrings(sl);
  end;
viewfm.m1.lines.add('');
viewfm.m1.lines.add('--- END PROJECT DEFINITION FILE');
viewfm.m1.lines.add('');
sl.free;
except
result:=false;
end;
end;

{TAP}
constructor tap.create;
begin
inherited create;
clearvals;
clearfolds;
createfolds;
end;

destructor tap.destroy;
begin
try
  sysfold.free;
except
end;
try
  winfold.free;
except
end;
try
rootfold.free;
except
end;
parentname.free;
parentid.free;
apfolds.free;
TargetDistID.free;
TargetDistName.free;
inherited destroy;
end;

{ recurse through folders and return pointer to desired folder or nil}
function tap.findfold(fnam:string):tapfolder;
var
  cnt,cntm:integer;
  tres:tapfolder;
begin
result:=nil;
{ check if the folder is a Windows or System one first }
if fnam<>snametofold(fnam) then
	begin
  if fnam='System' then
  	begin
    if apfolds.IndexOf(sysfold)<>-1 then
	  	result:=sysfold;
    end;
  if fnam='Windows' then
  	begin
    if apfolds.IndexOf(winfold)<>-1 then
	  	result:=winfold;
    end;
  if fnam='Root' then
  	begin
    result:=rootfold;
    end;
  end
else
	begin
  fnam:=snametofold(fnam);
  apfolds.pack;
  cnt:=0;
  cntm:=apfolds.count-1;
  while (result=nil) and (cnt<=cntm) do
    begin
    if lowercase(tapfolder(apfolds.items[cnt]).name)=lowercase(fnam) then
      result:=tapfolder(apfolds.items[cnt])
    else
      begin
      { just search down root for now. }
      tres:= ffoldrec(apfolds[0],fnam);
      if tres<>nil then
        result:=tres;
      end;
    inc(cnt);
    end;
  end;
end;

function tap.ffoldrec(curf:tapfolder;fnam:string):tapfolder;
var
  cntm,cnt:integer;
begin
result:=nil;
if curf.name=fnam then
  result:=curf
else
  begin
  curf.apfolds.pack;
  cntm:=curf.apfolds.count-1;
  cnt:=0;
  while (result=nil) and (cnt<=cntm) do
    begin
    result:=ffoldrec(tapfolder(curf.apfolds.items[cnt]),fnam);
    inc(cnt);
    end;
  end;
end;

function tap.loadfromfile(fnam:string):boolean;
var
  tf:textfile;
  ts,ts2,ts3:string;
  tc:char;
  tsl:integer;
  tcf:tapfolder;
  pos1:integer;
  curfolder:tapfolder;
  curfile:tapfile;
begin
{ clear apfolds }
clearfolds;
clearvals;
createfolds;

result:=true;
curfile:=tapfile.create(nil);
curfolder:=tapfolder.creatE(nil);
ts:=fnam;
{ do this affect anything else? }
//if (pos('.upg',ts)=0) and (pos('.pbu',ts)=0)  then
//  begin
//  ts:=ts+'.upg';
//  end;
ffname:=ts;
fname:=extractfilename(ts);
if not fileexists(ts) then
	begin
  result:=false;
  end
else
	begin
  { file parsing routine }
  assignfile(tf,ts);
  reset(tf);
  while not EOF(tf) do
    begin
    readln(tf,ts);
    tc:=ts[1];
    tsl:=length(ts);
    ts:=copy(ts,2,tsl);
    { Used characters :
    DEHINPRSTUVXWYZ ?><!%@|/\#:*
    }
    case ord(tc) of
      72: begin
          { H - Distribution target Name }
          TargetDistName.Add(trim(ts));
          end;
      73: begin
          { I - Distribution target ID }
          TargetDistID.Add(trim(ts));
          end;

      63: begin
          { ? }
          nname:=ts;
          end;
      86: begin
          { V - version }
          version:=ts;
          end;
      62: begin
          { > }
          deflocdir:=ts;
          rootfold.name:=ts;
          end;
      60: begin
          { < - baseurl }
          baseurl:=ts;
          end;
      33: begin
          {! - id for Project to differentiate it
              from another Project since the client
              uses it's own PDF file naming convention }
          id:=ts;
          end;
      68:	begin
          {D - upgrade depth is independent for
            each project }
          ugdepth:=strtoint(ts);
          end;
      78: begin
          { N - Use FTP restore command }
          useRestore:=strtoint(ts);
          end;
      37: begin
          {% - location of this file on the Network, Internet for checking for upgrades. }
          ownloc:=ts;
          end;
      64: begin
          {@ - parent project id;name }
          pos1:=pos(';',ts);
          ts2:=copy(ts,1,pos1-1);
          delete(ts,1,pos1);
          ts3:=ts;
          if (ts2='') or (ts3='') then
            begin
            showmessagenotsilent('Error 48. There is an error with Parent Project information.');
            end
          else
            begin
            parentid.add(ts2);
            parentname.add(ts3);
            end;
          end;
      124:begin
          { | - folder name ? }
          if ts='Windows' then
            begin
            curfolder:=winfold;
            apfolds.Add(curfolder);
            end
          else if ts='System' then
            begin
            curfolder:=sysfold;
            apfolds.Add(curfolder);
            end
          else if ts='Root' then
            begin
            curfolder:=rootfold;
            apfolds.Add(curfolder);
            end
          else
            begin
            pos1:=pos(';',ts);
            ts2:=copy(ts,1,pos1-1);
            delete(ts,1,pos1);
            ts3:=ts;
            if (ts2='') or (ts3='') then
              begin
              showmessagenotsilent('Error 4. Folder information corrupt.');
              end
            else
              begin
              ts3:=foldtosname(ts3);
              if ts3='Windows' then
                begin
                tcf:=winfold;
                end
              else if ts3='System' then
                begin
                tcf:=sysfold;
                end
              else if ts3='Root' then
                begin
                tcf:=rootfold;
                end
              else
                tcf:=longpathtofold(ts3);
              if tcf=nil then
                showmessagenotsilent('Error 5. Parent Folder cannot be found.')
              else
                begin
                curfolder:=tapfolder.create(tcf);
                curfolder.name:=ts2;
                tcf.apfolds.Add(curfolder);
                end;
              end;
            end;
          end;
      47: begin
          curfile:=tapfile.create(curfolder);
          curfolder.apfiles.add(curfile);
          { / - file's url }
          curfile.url:=ts;
          end;
      92: begin
          { \ - file}
          if ts='' then
	          curfile.name:=getfilefromurl(curfile.url)
          else
          	curfile.name:=ts;
          end;
      35: begin
          {# - MD5 number for the latest version of a file }
          curfile.md5:=ts;
          end;
      80: begin
          { P - flag to patch file }
          if ts='1' then
            curfile.usepatching:=true
          else
            curfile.usepatching:=false;
          end;
      58: begin
          { : }
          curfile.reg.add(ts);
          end;
      42: begin
          { * - file shortcut information }
          pos1:=pos(';',ts);
          ts2:=copy(ts,1,pos1-1);
          delete(ts,1,pos1);
          ts3:=ts;
   //       if (ts2='') or (ts3='') then // allow no folder name for shortcut
   				if (ts2='') then
            begin
            showmessagenotsilent('Error 7. There is an error with a file''s shortcut information.');
            end
          else
            begin
            curfile.scutname.add(ts2);
            curfile.scutloc.add(ts3);
            end;
          end;
      69:	begin
          { E - vendor's email address }
          vendemail:=ts;
          end;
      82: begin
          { R - readmefile }
          readmefile:=ts;
          end;
      83: begin
          { S - Use Scheduling }
          scheduleupgrade:=strtoint(ts);
          end;
      84: begin
          { T - Schedule date }
          try
            upgradedate:=strtodate(ts);
          except
            upgradedate:=0;
          end;
          end;
      85: begin
          { U - Schedule time }
          try
            upgradetime:=strtotime(ts);
          except
            upgradetime:=0;
          end;
          end;
      88: begin
          { X - run executable }
          runfile:=ts;
          end;
      87: begin
          { W - vendor's website }
          vendwebsite:=ts;
          end;
      90: begin
          { Z - compress whole files }
          zipfiles:=strtoint(ts);
          end;
      else
        showmessagenotsilent('Error 8. Error reading Project file for details. Contact Project Administrator of this Project Definition File.');
      end;
    end;
  closefile(tf);
  end;
end;

function tap.loadserfromfile(fnam:string):boolean;
var
  tf:textfile;
  ts:string;
begin
result:=true;
if not fileexists(fnam) then
   begin
   result:=false;
   viewfm.m1.lines.add('Critical Error: Server Settings File '+fnam+' not found');
   end
else
   begin
  assignfile(tf,fnam);
  reset(tf);
  readln(tf,ts);
  transtype:=strtoint(ts);
  readln(tf,ts);
  server:=ts;
  readln(tf,ts);
  username:=ts;
  readln(tf,ts);
  password:=ts;
  readln(tf,ts);
  remdir:=ts;
  readln(tf,ts);
  bucketdir:=ts;
  { this is for protection }
  {try
  readln(tf,ts);
  ftpport:=strtoint(ts);
  except
  ftpport:=21;
  end;}
  closefile(tf);
  end;
end;



function tap.savetofile:boolean;
var
  cnt,cntm:integer;
  cf:tapfolder;
  ts:string;
  serfile:textfile;
begin
result:=true;
{ ffname='' when first app is being created }
ts:=ffname;
{ force backup for now - maybe offer revert }
copyfile(pchar(ts),pchar(ts+'.bak'),false);
assignfile(tfile,ts);
rewrite(tfile);
writeln(tfile,'?'+nname);
writeln(tfile,'V'+version);
writeln(tfile,'!'+id);
writeln(tfile,'D'+inttostr(ugdepth));
writeln(tfile,'>'+deflocdir);
writeln(tfile,'<'+baseurl);
writeln(tfile,'R'+readmefile);
writeln(tfile,'S'+inttostr(scheduleupgrade));
writeln(tfile,'N'+inttostr(userestore));
if upgradedate<>0 then
  writeln(tfile,'T'+datetostr(upgradedate));
if upgradetime<>0 then
  writeln(tfile,'U'+timetostr(upgradetime));
writeln(tfile,'W'+vendwebsite);
writeln(tfile,'E'+vendemail);
{ Write in a list of clients }
cntm:=TargetDistID.count-1;
for cnt:=0 to cntm do
  begin
  writeln(tfile,'H'+TargetDistName[cnt]);
  writeln(tfile,'I'+TargetDistID[cnt]);
  end;
writeln(tfile,'X'+runfile);
writeln(tfile,'Z'+inttostr(zipfiles));
{ prepare ownloc }
{ bit funny about this }
ownloc:=fname;
if (pos('http://',baseurl)<>0) or (pos('ftp://',baseurl)<>0) then
  begin
  ownloc:=makewpath(baseurl)+ownloc;
  end
else
  begin
  ownloc:=makedpath(baseurl)+ownloc;
  end;
writeln(tfile,'%'+ownloc);
{ parents }
cntm:=parentname.count-1;
for cnt:=0 to cntm do
  begin
  writeln(tfile,'@'+parentid[cnt]+';'+parentname[cnt]);
  end;
{ Start at root folder }
apfolds.pack;
cntm:=apfolds.count-1;
for cnt:=0 to cntm do
  begin
  cf:=apfolds[cnt];
  stofrec(cf);
  end;
closefile(tfile);

{ write server file }
ts:=ts+'.ser';
assignfile(serfile,ts);
rewrite(serfile);
writeln(serfile,inttostr(transtype));
writeln(serfile,server);
writeln(serfile,username);
writeln(serfile,password);
writeln(serfile,remdir);
writeln(serfile,bucketdir);
writeln(serfile,inttostr(ftpport));
closefile(serfile);
end;

{ recursively write Project file }
function tap.stofrec(curf:tapfolder):boolean;
var
  cnt,cntm,c2,c2m,c3,c3m:integer;
  ts:string;
  tempf:tapfile;
begin
result:=true;
ts:='|'+foldtosname(curf.name);
if curf.parent<>nil then
  ts:=ts+';'+foldtolongpath(curf.parent);
writeln(tfile,ts);
{ get list of files from fold }
c2m:=curf.apfiles.count-1;
for c2:=0 to c2m do
  begin
  tempf:=tapfile(curf.apfiles[c2]);
  { save file information to Project file }
  writeln(tfile,'/'+tempf.URL);
  writeln(tfile,'\'+tempf.name);
  if tempf.usepatching then
    writeln(tfile,'P1')
  else
    writeln(tfile,'P0');
  { get new md5 now!!! }
  if fileexists(tempf.name) then
    begin
    tempf.md5:=filemd5digest(tempf.name);
    end
  else
    begin
    showmessagenotsilent('"'+tempf.name+'" does not exist. Project Definition File will contain a file reference that cannot currently be Deployed.');
    end;
  writeln(tfile,'#'+tempf.md5);
  c3m:=tempf.reg.Count-1;
  for c3:=0 to c3m do
    begin
    writeln(tfile,':'+tempf.reg.strings[c3]);
    end;
  c3m:=tempf.scutname.count-1;
  for c3:=0 to c3m do
    begin
    writeln(tfile,'*'+tempf.scutname.strings[c3]+';'+tempf.scutloc.strings[c3]);
    end;
  end;
cntm:=curf.apfolds.count-1;
for cnt:=0 to cntm do
  begin
  stofrec(curf.apfolds[cnt]);
  end;
end;


function tap.maketest(ap:tap):boolean;
begin
mainfm.label1.caption:='Making Test';
result:=false;
{ set values to 0 }
loadfromfile(ap.ffname);
loadserfromfile(ap.ffname+'.ser');
nname:=ap.nname+' - Local Test';
deflocdir:=ap.deflocdir+'test';
{ new id }
//id:=assignid+'.tst';
id:=ap.id+'.tst';
fname:=id;
ffname:=extractfilepath(ap.ffname)+fname;
ownloc:=ffname;
{ Test}
transtype:=1;
baseurl:='';
server:='';
username:='';
password:='';
remdir:='';
{ make sure this does not include drive info }
ugdepth:=ap.ugdepth;
scheduleupgrade:=0;
upgradedate:=0;
upgradetime:=0;
userestore:=ap.userestore;
result:=true;
mainfm.label1.caption:='';
end;

{ make a backup of ap }
function tap.makebackup(ap:tap):boolean;
var
	ts:string;
  tempra:trecapp;
begin
mainfm.label1.caption:='Making Backup';
result:=true;
nname:=ap.nname+' - Backup';
tempra:=trecapp.create;
tempra.loadfromreg(ap.id);
version:=tempra.instver;
{ set values to 0 }
deflocdir:=tempra.installdir;
installdirtosource(ap,deflocdir);
tempra.free;
parentid.clear;
parentid.addstringS(ap.parentid);
parentname.clear;
parentname.addstrings(ap.parentname);
{ new id }
//id:=assignid+'.pbu';
id:=ap.id+'.pbu';
fname:=id;
ffname:=extractfilepath(ap.ffname)+id;
{ ts will be backup directory }
ts:=makedpath(s.bupath)+id;
transtype:=1;
{ New regime - don't put drive in server setting,
               leave it in remdir }
//server:=extractfiledrive(ts);
//remdir:=copy(ts,4,length(ts));
server:='';
remdir:=ts;

username:='';
password:='';
baseurl:=makedpath(ts);
ownloc:=baseurl+id;
ugdepth:=0;
zipfiles:=ap.zipfiles;
vendwebsite:=ap.vendwebsite;
vendemail:=ap.vendemail;
runfile:=ap.runfile;
readmefile:=ap.readmefile;
bucketdir:=makedpath(s.wkpath)+id;
scheduleupgrade:=ap.scheduleupgrade;
upgradetime:=ap.upgradetime;
upgradedate:=ap.upgradedate;
mainfm.label1.caption:='';
end;

function tap.makeredeploy(ap:tap):boolean;
var
  tempra:trecapp;
begin
mainfm.label1.caption:='Making Redeployment';
result:=true;
{ set values to 0 }
nname:=ap.nname+' - Redeployment';
tempra:=trecapp.create;
tempra.loadfromreg(ap.id);
version:=tempra.instver;
deflocdir:=tempra.installdir;
installdirtosource(ap,deflocdir);
tempra.free;
parentid.clear;
parentid.addstringS(ap.parentid);
parentname.clear;
parentname.addstrings(ap.parentname);
{ new id }
//id:=assignid+'.rdp';
id:=ap.id+'.rdp';
fname:=id;
ffname:=makedpath(s.rdpath)+fname;
runfile:=ap.runfile;
readmefile:=ap.readmefile;
{ should be workarea directory }
bucketdir:=makedpath(s.wkpath)+id;
mainfm.label1.caption:='';
end;

function tap.foldtosname(fnam:string):string;
begin
result:=fnam;
if fnam=rootfold.name then
  result:='Root'
else if fnam=sysfold.name then
  result:='System'
else if fnam=winfold.name then
  result:='Windows';
end;

function tap.snametofold(fnam:string):string;
begin
result:=fnam;
if fnam='Root' then
  result:=rootfold.name
else if fnam='System' then
  result:=sysfold.name
else if fnam='Windows' then
  result:=winfold.name;
end;


{ finds a file within a folder's file list or returns nil }
function tap.findfile(fnam:string;folder:tapfolder):tapfile;
var
  cnt,cntm:integer;
begin
result:=nil;
if assigned(folder)=false then
  begin
  showmessagenotsilent('Error 44. Folder passed in is not an object.');
  end
else
  begin
  cntm:=folder.apfiles.count-1;
  for cnt:=0 to cntm do
    begin
    if lowercase(extractfilename(tapfile(folder.apfiles[cnt]).name))=lowercase(fnam) then
      begin
      result:=folder.apfiles[cnt];
      end;
    end;
  end;
end;

{ receives long dir }
function tap.realsourcedir(fldr:string):string;
var
	taf:tapfolder;
  ts:string;
begin
result:='';
taf:=longpathtofold(fldr);
ts:='';
if taf<>nil then
	begin
  while taf<>nil do
    begin
    if foldtosname(taf.name)='Root' then
      begin
      end
    else if foldtosname(taf.name)='System' then
      begin
      ts:='System\'+ts;
      end
    else if foldtosname(taf.name)='Windows' then
      begin
      ts:='Windows\'+ts;
      end
    else
      begin
      ts:=taf.name+'\'+ts;
      end;
    taf:=taf.parent;
    end;
  ts:=makedpath(bucketdir)+ts;
  result:=ts;
  end
else
	begin
	result:='';
  end;
end;

function tap.deploy(stagepath:string;wt:boolean;forceall:boolean;valcontquiet:boolean;
  status:string;creflag:boolean;test:boolean;appname:string;silentmode:boolean;
  closeonfinish:boolean;deploytonull:boolean):boolean;
var
  extraPar:string;
  parm:string;
begin
mainfm.label1.caption:=status;
application.processmessages;
result:=false;
if validate(valcontquiet,creflag) then
  begin
  if not fileexists(ffname) then
    begin
    showmessagenotsilent(ffname+' does not exist. Deployment cancelled.');
    end
  else
    begin
    result:=true;
    Screen.Cursor := crHourGlass;
    try
      { Transmit the Project to the web }
      { Call the transmitter program }
      parm:='t "'+ffname+'" "'+stagepath+'" ';
      if forceall then
        parm:=parm+' forceall '
      else
        parm:=parm+' noforceall ';
      { Hack for testing }
      if test then
        parm:=parm+' "'+appname+'" '
      else
        parm:=parm+' nohack ';
      if silentmode then
        parm:=parm+' silent '
      else
        parm:=parm+' nosilent ';
      if closeonfinish then
        parm:=parm+' close '
      else
        parm:=parm+' noclose ';
      if deploytonull then
        parm:=parm+' nocopy '
      else
        parm:=parm+' copy ';
      runTransmitter(false,parm);
      mainfm.label1.caption:='';
    finally
      Screen.Cursor := crDefault;
    end;  // try/finally
  end;
  end;
end;

{ delete files }
function tap.projectdelete(stagepath:string):boolean;
var
  res:integer;
  fn:string;
begin
result:=false;
{ delete the project file }
res:= messagedlg('Are you sure you want to delete "'+nname+'" ? This command cannot be undone.',mtconfirmation,[mbyes,mbno],0);
if res=mrYes then
  begin
  fn:=ffname;
  if not fileexists(fn) then
    showmessagenotsilent('Error 11. Project Definition File could not be found.')
  else
    begin
    { delete file and bak files }
    clearstagingarea(stagepath,'Click Yes to remove above directory (recursively), or no if this will delete important files.',true);
    if deletefile(fn)=true then
      begin
      deletefile(fn+'.bak');
      deletefile(fn+'.bak.ser');
      deletefile(fn+'.dep');
      deletefile(fn+'.tst');
      deletefile(fn+'.tst.ser');
      deletefile(fn+'.pbu');
      deletefile(fn+'.pbu.ser');
      deletefile(fn+'.rdp');
      deletefile(fn+'.rdp.ser');
      showmessagenotsilent('Project "'+nname+'" Deleted.');
      result:=true;
      end
    else
      showmessagenotsilent('Error 12. Project Definition File could not be deleted.');
    end;
  end;
end;

function tap.mirror(stagepath:string;newver:string):boolean;
begin
mainfm.label1.caption:='Refreshing Redeployment';
result:=true;
{ get latest md5's }
version:=newver;
compile(stagepath,true,'Preparing ReDeployment(R)',false,true);
deploy(stagepath,true,true,true,'Refreshing',false,false,'',s.xmRunSilent,s.xmCloseEnd,false);
mainfm.label1.caption:='';
end;

function tap.redeploy(stagepath:string;wt:boolean):boolean;
begin
mainfm.label1.caption:='ReDeploying Project';
result:=true;
compile(stagepath,true,'Preparing ReDeployment',false,true);
deploy(stagepath,wt,true,true,'ReDeploying',false,false,'',s.xmRunSilent,s.xmCloseEnd,false);
mainfm.label1.caption:='';
end;

function tap.receive(stagepath:string):boolean;
var
  finalname:string;
begin
result:=true;
mainfm.label1.caption:='Receiving Project';
{ hopefully it only gets called by client }
finalname:=fname;
runClient(false,'"'+stagepath+makedpath(finalname)+fname+'"');
mainfm.label1.caption:='';
end;


function tap.compile(stagepath:string;dlist:boolean;status:string;creflag:boolean;nohints:boolean):boolean;
var
  cnt,cntm:integer;
  cf:tapfolder;
  tresult:boolean;
begin
result:=false;
mainfm.label1.caption:=status;
if validate(nohints,creflag) then
  begin
 { This will set the ownloc and MD5's of latest files }
  savetofile;
  loadfromfile(ffname);
  loadserfromfile(ffname+'.ser');
  result:=true;
  Screen.Cursor := crHourGlass;
  if pos('.tst',fname)<>0 then
    delete(fname,length(fname)-3,4);
  ppath:=makedpath(stagepath)+makedpath(fname)+'Patch\';
  if not directoryexists(ppath) then
    forcedirectories(ppath);
  //viewfm.m1.Lines.Clear;
  viewfm.m1.lines.add('');
  viewfm.m1.lines.adD(uppercase(status)+' ['+datetimetostr(now)+']');
  viewfm.m1.lines.add('');

  { clear patch directory - why? }
{  mainfm.flb1.Directory:=ppath;
  mainfm.flb1.mask:='*.*';
  mainfm.flb1.filetype:=[ftNormal,ftReadonly,ftArchive];
  cntm:=mainfm.flb1.items.count-1;
  for cnt:=0 to cntm do
    begin
    viewfm.m1.lines.add('    Deleting patch directory: '+mainfm.flb1.directory);
    deletefile(makedpath(mainfm.flb1.directory)+mainfm.flb1.items[cnt]);
    end;}
  deploylist:=tstringlist.create;
  stagefilelist:=tstringlist.create;
  if dlist then
    begin
    if fileexists(ffname+'.dep') then
      begin
      deploylist.LoadFromFile(ffname+'.dep');
      showdeploylist('Deployment List before Preparation');
      end
    else
      begin
      deploylist.savetofile(ffname+'.dep');
      deploylist.loadfromfile(ffname+'.dep');
      showdeploylist('Deployment List before Preparation');
      end;
    end;

  try
  { is this necessary ? }

  apfolds.pack;
  cntm:=apfolds.count-1;
  { clear viewfm }

  for cnt:=0 to cntm do
    begin
    cf:=apfolds[cnt];
    tresult:=compilerec(stagepath,cf,dlist);
    if tresult=false then
      begin
      result:=false;
      end;
    end;
  savetofile; // save latest md5's
  savetodeployfile(stagepath);
  if dlist then
    begin
    removestagefilelist;
    showdeploylist('Deployment List after Preparation');
    deploylist.savetofile(ffname+'.dep');
    end;
  viewfm.m1.lines.add('');
  viewfm.m1.lines.add(uppercase('Preparation Finished ['+datetimetostr(now)+']'));
  viewfm.m1.lines.add('');
  finally
    Screen.Cursor := crDefault;
  end;
  stagefilelist.free;
  deploylist.free;
  end;
mainfm.label1.caption:='';
end;

function tap.clearstagingarea(stagepath:string;msg:string;quiet:boolean):boolean;
var
	res:integer;
begin
result:=true;
mainfm.label1.caption:='Clearing Local Update Files';
{ need to calculate tp }
if quiet then
  res:=mryes
else
  res:=messagedlg('Clear out Local Update Files for "'+nname+'" ?'#13#10#13#10+
	'('+stagepath+fname+')'#13#10#13#10+msg,mtconfirmation,[mbyes,mbno],0);
if res=mryes then
  begin
  if fname='' then
    res:=messagedlg('Filename field of Project is nil. Continue?'#13#10#13#10+
    '(Clue: Click No! Edit your Project and make sure the Project has a file name.)',mtwarning,[mbyes,mbno],0);
  if res=mryes then
    begin
    //viewfm.m1.Lines.Clear;
    viewfm.m1.lines.add('');
    viewfm.m1.lines.add(uppercase('Deleting Staging Area of "'+nname+'" ['+datetimetostr(now)+']'));
    recdirdel(stagepath+makedpath(fname)+'Patch');
    recdirdel(stagepath+fname);
    deletefile(ffname+'.dep');
    viewfm.m1.lines.add('  Deleted: Staging Area of "'+nname+'" ['+datetimetostr(now)+']');
    if (not quiet) and (not s.runsilent) then
      showmessagenotsilent('"'+nname+'"''s Staging Area cleared.');
    end;
  end;
mainfm.label1.caption:='';
end;

function tap.addfold(var fold:tapfolder):boolean;
begin
result:=true;
end;

function tap.deletefold(fold:tapfolder):boolean;
var
	posn:integer;
  doit:integer;
  fname:string;
begin
result:=false;
{ delete folder from Project  }
if fold.name=rootfold.name then
  begin
	showmessagenotsilent('You cannot delete the Root Folder of a project.');
  end
else
  begin
  doit:=mryes;
  if (fold.name=winfold.name) or (fold.name=sysfold.name) then
    doit:=messagedlg('Are you sure you want to delete this folder?',mtconfirmation,[mbyes,mbno],0);
  if doit=mryes then
    begin
    { remove folder from parent's apfold list }
    fname:=foldtosname(fold.name);
    if fold.parent<>nil then
      begin
      posn:=fold.parent.apfolds.IndexOf(fold);
      fold.parent.apfolds.Delete(posn);
      end
    else
      begin
      if fname='Windows' then
        apfolds.remove(winfold)
      else if fname='System' then
        apfolds.remove(sysfold);
      end;

    fold.free;

    if fname='Windows' then
      begin
      createwindir;
      end
    else if fname='System' then
      begin
      createsysdir;
      end;
    result:=true;
    end;
  end;
end;

function tap.compilerec(stagepath:string;curf:tapfolder;dlist:boolean):boolean;
var
  cnt,cntm:integer;
  tempf:tapfile;
  { new variables }
  sdfn,safn:string;
  sapath:string;
  sdfnmd5,safnmd5:string;
  ugm,ugd,ugc:integer;
  posn:integer;
  shortfn:string;
//  za2:TZLBArchive;
  function calcugm(path:string):integer;
  var
    ts:string;
  begin
  result:=0;
  ts:='dsold\';
  while directoryexists(makedpath(path)+ts) do
    begin
    ts:=ts+'dsold\';
    inc(result);
    end;
  end;

  function dsold(no:integer):string;
  var
    cnt:integer;
  begin
  cnt:=0;
  result:='';
  while cnt<no do
    begin
    result:=result+'dsold\';
    inc(cnt)
    end;    // while
  end;

  procedure propagate;
  var
    tp:string;
    tsamd5:string;
    ts:string;
    tsold:string;
    psuc:boolean;
    pfile:string;
  begin
  { propagate version files algorithm }
  ugd:=ugdepth;
  ugm:=calcugm(sapath);
  if (ugd>0) and (tempf.usepatching) then
    begin
    ugc:=ugm+1;
    if ugc>ugd then
      ugc:=ugd;
    while  ugc>0 do
      begin
      tp:=makedpath(sapath)+dsold(ugc);
      ts:=tp+extractfilename(safn);
      { Adds old file }
      tsold:=makedpath(sapath)+dsold(ugc-1)+extractfilename(safn);
      if not fileexists(tsold) then
        begin
        //showmessagenotsilent('Staging Area File '+tsold +' does not exist. Preparation will not complete.');
        //result:=false;
        dec(ugc);
        end
      else
        begin
        if not directoryexistS(tp) then
          forcedirectories(tp);
        if copyfile(pchar(tsold),pchar(ts),false)=false then
          begin
          viewfm.m1.lines.add('  Propagate: '+tsold+' -x- '+ts);
          showmessagenotsilent('Staging Area File '+tsold +' does not exist. Preparation will not complete.');
          result:=false;
          end
        else
          begin
          viewfm.m1.lines.add('  Propagate: '+extractfilename(tsold)+' --> '+extractfilename(ts));
          tsamd5:=filemd5digest(tsold);
          if tsamd5=sdfnmd5 then
            begin
            deletefile(ppath+tsamd5);
            end
          else
            begin
            psuc:=true;
            if patchfilecheck(ts,sdfn) then
              begin
              mainfm.pm1.oldfile:=ts;
              mainfm.pm1.newfile:=sdfn;
              mainfm.pm1.PatchFile:=makedpath(ppath)+tsamd5;
              try
              psuc:=mainfm.pm1.makepatch;
              { if you can't patch it, copy a new file there instead
                so it won't patch in future }
              except
                psuc:=false;
              end;
              { add to deploylist }
              if dlist and psuc then
                begin
                stagefilelist.Add(makedpath(ppath)+tsamd5);
                posn:=deploylist.indexof(makedpath(ppath)+tsamd5);
                if posn=-1 then
                  deploylist.add(makedpath(ppath)+tsamd5);
                end;

              if psuc then
                begin
                { zip patch }
                pfile:=makedpath(ppath)+tsamd5;
//                za2:=TZLBArchive.create(Application);
                mainfm.za.CompressionLevel:=fcDefault;
                mainfm.za.CreateArchive(pfile+'.zzz');
                mainfm.za.AddFile(pfile);
                mainfm.za.CloseArchive;
//                za2.free;
                //mainfm.zm1.addcomplevel:=9;
                //mainfm.zm1.ZipFilename:=pfile+'.zzz';
                //mainfm.zm1.FSpecArgs.clear;
                //mainfm.zm1.FSpecArgs.add(pfile);
                //mainfm.zm1.Add;
                if deletefile(pchar(pfile)) then
                  viewfm.m1.lines.add('    Deleted file '+extractfilename(pfile))
                else
                  viewfm.m1.lines.add('    Could not delete '+pfile);
                if copyfile(pchar(pfile+'.zzz'),pchar(pfile),false) then
                  begin
                  viewfm.m1.lines.add('    Copying '+extractfilename(tsamd5)+'.zzz --> '+extractfilename(tsamd5));
                  viewfm.m1.lines.adD('    Patch: '+extractfilename(tsamd5)+' patches '+extractfilename(ts)+' --> '+extractfilename(sdfn));
                  end
                else
                  begin
                  viewfm.m1.lines.add('    Copying '+tsamd5+'.zzz -x- '+tsamd5);
                  psuc:=false;
                  end;
                deletefile(pchar(pfile+'.zzz'));
                end;
              if not psuc then
                begin
                if copyfile(pchar(sdfn),pchar(ts),false) then
                  viewfm.m1.lines.add('    Patch: '+extractfilename(tsamd5)+' failed, so copied '+extractfilename(sdfn)+' --> '+extractfilename(ts))
                else
                  viewfm.m1.lines.add('    Patch: '+tsamd5+' failed, so copied '+sdfn+' -x- '+ts);
                end;
              end
            end;
          end;
        dec(ugc);
        end;
      end;
    end;
  { copy latest }
  shortfn:=extractfilename(tempf.name);
  if copyfile(pchar(sdfn),pchar(safn),false) then
    begin
    { add to deploylist }
    if dlist then
      begin
      stagefilelist.Add(safn);
      posn:=deploylist.indexof(safn);
      if posn=-1 then
        deploylist.add(safn);
      end;
    viewfm.m1.lines.adD('    '+shortfn+':  Source Directory --> Staging Area');
    end
  else
    viewfm.m1.lines.adD('    '+shortfn+':  Source Directory -x- Staging Area');

  end;

begin
result:=true;
sapath:=makedpath(stagepath)+makedpath(fname)+makedpath(foldtolongpath(curf));
if not directoryexists(sapath) then
  forcedirectories(sapath);
{ prepare individual files }
viewfm.m1.lines.adD('  Staging Area Directory: '+sapath);
cntm:=curf.apfiles.count-1;
for cnt:=0 to cntm do
  begin
  tempf:=tapfile(curf.apfiles[cnt]);
  shortfn:=extractfilename(tempf.name);
  sdfn:=tempf.name;
  safn:=sapath+getfilefromurl(sdfn);
  if fileexists(sdfn)  then
    begin
    { Add file to stagefilelist }
    stagefilelist.add(safn);
    if fileexists(safn)  then
      begin
      safnmd5:=filemd5digest(safn);
      sdfnmd5:=filemd5digest(sdfn);
      if safnmd5=sdfnmd5 then
        begin
        { no action needed }
        viewfm.m1.lines.adD('    '+shortfn+': Staging Area = Source Directory');
        end
      else
        propagate;
      end
    else
      begin
      if copyfile(pchar(sdfn),pchar(safn),false) then
        begin
        { add to deploylist }
        if dlist then
          begin
          stagefilelist.Add(safn);
          posn:=deploylist.indexof(safn);
          if posn=-1 then
            deploylist.add(safn);
          end;
        viewfm.m1.lines.adD('    '+shortfn+': Source Directory --> Staging Area.');
        end
      else
        viewfm.m1.lines.adD('    '+shortfn+': Source Directory -x- Staging Area.');
      end;
    end
  else
    begin
    showmessagenotsilent('File "'+sdfn+'" specified in Project Definition File does not exist.');
    result:=false;
    end;
  end;
curf.apfolds.pack;
cntm:=curf.apfolds.count-1;
for cnt:=0 to cntm do
  begin
  compilerec(stagepath,curf.apfolds[cnt],dlist);
  end;
end;

function Tap.createlink:boolean;
var
  htmlstr:string;
  dltype:turltype;
  scut2:TPBShellLink;
  dtpath:string;
  f:textfile;
begin
result:=true;
dltype:=getdltype(baseurl);
htmlstr:='';
if (dltype=utHTTP) or (dltype=utFTP) then
	begin
	ltypefm.e1.text:=makewpath(baseurl)+fname;
  end;
if (dltype=utLNF) then
	begin
	ltypefm.e1.text:=makedpath(baseurl)+fname;
  end;
if ltypefm.showmodal=mrOK then
  begin
  if ltypefm.rg1.itemindex=0 then
    begin
    { create test html file }
    if ltypefm.cbpageheader.checked then
      begin
      htmlstr:=htmlstr+'<HTML><HEAD><TITLE>Test</TITLE></HEAD><BODY>'#13#10+'Click on the link below to execute/install/update '+nname+'<BR><BR>'+#13#10;
      htmlstr:=htmlstr+''+#13#10;
      end;
    htmlstr:=htmlstr+'<A HREF="'+ltypefm.e1.text+'">'+nname+'</A><BR><BR>'+#13#10;
    { MO - 9/3/2000
      This needs to be updated with pcblues graphics }
    htmlstr:=htmlstr+'<A HREF="'+ltypefm.e2.text+'">'+#13#10;
    //<IMG SRC="http://www.pcblues.com/graphics/usnow.gif"></A><BR>';
    if ltypefm.cbPageHeader.checked then
      htmlstr:=htmlstr+'</BODY></HTML>';
    clipboard.settextbuf(pchar(htmlstr));
    showmessagenotsilent('HTML code has been copied to the clipboard. Paste into your web page and edit as you see fit.');
    end
  else if ltypefm.rg1.itemindex=1 then
    begin
    if dltype=utLNF then
      begin
      { create shortcut }
      scut2:=TPBShellLink.create(application);
      scut2.FileName:=nname;
      scut2.ShellFolder:=sfDesktop;
      scut2.target      := ltypefm.e1.text;
      scut2.workingdir          := extractfilepath(ltypefm.e1.text);
      scut2.description     := nname;
      //mainfm.scut1.fileicon        := '';
      scut2.Write;
      scut2.Free;
      end
    else
      begin
      dtpath:=getdesktoppath;
      assignfile(f,makedpath(dtpath)+nname+'.URL');
      rewrite(f);
      writeln(f,'[InternetShortcut]');
      writeln(f,'URL='+ltypefm.e1.text);
      closefile(f);
      end;
    showmessagenotsilent('New shortcut is on your desktop.')
    end;
  end;
end;

function Tap.foldtolongpath(fold:tapfolder):string;
begin
result:='';
if fold<>nil then
	begin
	result:=foldtosname(fold.name);
	fold:=fold.parent;
  while fold<>nil do
    begin
    result:=foldtosname(fold.name)+'\'+result;
    fold:=fold.parent;
    end;
  end;
end;

function Tap.longpathtofold(path:string):tapfolder;
var
	tempfold:tapfolder;
  ts,ts2:string;
  ttn:ttreenode;
  tsl:tstringlist;
  ln,cnt,cntm:integer;
  newfold:tapfolder;
begin
result:=nil;
tempfold:=nil;
ts:=path;
if ts<>'' then
	begin
  tsl:=tstringlist.create;
  ts:=path;
  while ts<>'' do
    begin
    ts2:=lastdirfromlongpath(ts);
    tsl.add(ts2);
    ln:=length(ts2);
    if ts=ts2 then
    	begin
      delete(ts,1,length(ts));
      end
    else
    	begin
      delete(ts,length(ts)-ln,length(ts));
      end;
    end;
  cntm:=tsl.count-1;
  if cntm>=0 then
    begin
    { root/win/sys }
    if tsl[cntm]='Root' then
      tempfold:=rootfold
    else if tsl[cntm]='Windows' then
      tempfold:=winfold
    else if tsl[cntm]='System' then
      tempfold:=sysfold;
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

function Tap.savetodeployfile(stagepath:string): boolean;
{ save project file to staging area
  without location of source directory files
  because they are not needed. }
var
  cnt,cntm:integer;
  cf:tapfolder;
  ts,ts2:string;
  ln:string;
  oldfile,newfile:textfile;
  finalname:string;
begin
result:=true;
stagepath:=makedpath(stagepath);
{ ffname='' when first app is being created }
ts:=ffname;
{ ts2 is the target file , in the staging area }
finalname:=fname;
{ .tst removed to get directory or test project staging area }
if (pos('.tst',finalname)<>0)  then
  delete(finalname,length(finalname)-3,4);
{ fix rdp to deploy to normal filename? }
if not directoryexistS(stagepath+finalname) then
  begin
  forcedirectories(stagepath+finalname);
  end;
ts2:=stagepath+makedpath(finalname)+fname;
if not fileexists(ts) then
  begin
  showmessagenotsilent('Could not find file '+ts+' . Making of '+ts2+' cancelled.');
  result:=false;
  end
else
  begin
  assignfile(oldfile,ts);
  assignfile(newfile,ts2);
  reset(oldfile);
  rewrite(newfile);
  while not eof(oldfile) do
    begin
    readln(oldfile,ln);
    { copy every line except for fname }
    if ln[1]='\' then
      begin
      writeln(newfile,'\');
      end
    else
      begin
      writeln(newfile,ln);
      end;
    end;    // while
  viewfm.m1.lines.adD('  '+extractfilename(ts)+': Source Directory -deployable-> Staging Area.');
  closefile(oldfile);
  closefile(newfile);
  end;
end;

{ create new rootfold from ap }
function Tap.installdirtosource(ap:tap;instdir:string): boolean;
var
	cnt,cntm:integer;
  cfold:tapfolder;
  cfnew:tapfolder;
  tresult:boolean;
begin
result:=true;

clearfolds;
createfolds;
instdir:=makedpath(instdir);
s.projpath:=makedpath(s.projpath);
//viewfm.m1.lines.clear;
viewfm.m1.lines.add('');
viewfm.m1.lines.add('  Creating "'+nname+'"');
viewfm.m1.lines.add('');
{ Start at root folder }
ap.apfolds.pack;
cntm:=ap.apfolds.count-1;
for cnt:=0 to cntm do
  begin
  cfold:=ap.apfolds[cnt];
  cfnew:=tapfolder.create(nil);
  if ap.rootfold=cfold then
    begin
    cfnew.name:=instdir;
    end
  else
    begin
    cfnew.name:=cfold.name;
    end;
  apfolds.add(cfnew);
  tresult:=id2srec(ap,cfold,cfnew,instdir);
  if tresult=false then
    result:=false;
  end;
end;



function tap.id2srec(ap:tap;cfold:tapfolder;var cfnew:tapfolder;installdir:string):boolean;
var
  cnt,cntm,c2,c2m:integer;
  tempf:tapfile;
  newf:tapfile;
  tp3:string; // folder strings
  tempfold:tapfolder;
  ts,ts3,ts7:string; // temporary strings
  finished:boolean;
  fldr:tapfolder;
  tresult:boolean;
begin
result:=true;
{ determine path of installation directory }
tp3:='';
tempfold:=cfold;
finished:=false;
while not finished do
  begin
  ts:=ap.foldtosname(tempfold.name);
  if ts='Root' then
    begin
    tp3:=installdir+tp3;
    end
  else if ts='Windows' then
    begin
    tp3:=makedpath(s.windir)+tp3;
    end
  else if ts='System' then
    begin
    tp3:=makedpath(s.sysdir)+tp3;
    end
  else
    begin
    tp3:=tempfold.name+'\'+tp3;
    end;
  if tempfold.parent=nil then
    finished:=true
  else
    tempfold:=tempfold.parent;
  end; // while

{ get list of files from fold }
c2m:=cfold.apfiles.count-1;
for c2:=0 to c2m do
  begin
  tempf:=tapfile(cfold.apfiles[c2]);
  ts:=tp3+getfilefromurl(tempf.name); // latest file install location
   if not fileexists(ts) then
    begin
    showmessagenotsilent(ts+' does not exist. Project File generation will not be successful.');
    result:=false;
    end
  else
    begin
    newf:=tapfile.create(cfnew);
    newf.name:=ts;
    newf.url:=getfilefromurl(ts);
    newf.md5:=tempf.md5;
    newf.scutname.addstrings(tempf.scutname);
    newf.scutloc.addstrings(tempf.scutloc);
    newf.parent:=tempf.parent;
    newf.reg.addstrings(tempf.reg);
    viewfm.m1.lines.add('  '+ts+' added');
    cfnew.apfiles.add(newf);
    end;
  end;
{ recurse down folder list in current folder object }
cfold.apfolds.pack;
cntm:=cfold.apfolds.count-1;
for cnt:=0 to cntm do
  begin
  fldr:=tapfolder.create(cfnew);
  cfnew.name:=cfold.name;
  tresult:=id2srec(ap,cfold.apfolds[cnt],cfnew,installdir);
  if tresult=false then
    result:=false;
  end;
end;

function Tap.validate(valcontquiet:boolean;creflag:boolean):boolean;
var
  mess,m2,m3:string;
  cont:boolean;
begin
cont:=true;
mess:='';
m2:='';
m3:='';
result:=true;

if remdir='' then
  begin
  mess:=mess+#13#10;
  mess:=mess+'*IMPORTANT* You have to have a Deployment Directory specified ( even if it is /), or you could have important files deleted from the root directories of your remote drives and servers when you Deploy your Project.';
  mess:=mess+#13#10;
  result:=false;
  end;

if id='' then
  begin
  mess:=mess+#13#10;
  mess:=mess+'Project must have a Project ID.';
  result := False;
  end;

if nname='' then
  begin
  mess:=mess+#13#10;
  mess:=mess+'Project must have an Name.';
  result := False;
  end;

if deflocdir='' then
  begin
  mess:=mess+#13#10;
  mess:=mess+'Project must have a Default Target Directory.';
  result:=false;
  end;

if fname='' then
  begin
  mess:=mess+#13#10;
  mess:=mess+'Project must have a Filename.';
  result := False;
  end;

if bucketdir='' then
  begin
  mess:=mess+#13#10;
  mess:=mess+'Project must have a Source Directory.';
  result:=false;
  end;

if baseurl='' then
  begin
  mess:=mess+#13#10;
  mess:=mess+'Project must have a Client Deployment Path.';
  result := False;
  end;

if (server='') and (transtype=0) then
  begin
  mess:=mess+#13#10;
  mess:=mess+'You must specify an FTP Server to Deploy this Project.';
  result:=false;
  end;


if mess<>'' then
  begin
  m2:='The following must be addressed in the Project Definition to successfully Prepare, Deploy, or Redeploy a Project:'#13#10;
  m2:=m2+mess+#13#10;
  result:=false;
  cont:=false;
  end;

mess:='';
if version='' then
  begin
  mess:=mess+#13#10;
  mess:=mess+'You may want to include a Version number.';
  end;

if readmefile='' then
  begin
  mess:=mess+#13#10;
  mess:=mess+'You may want to include a Readme File.';
  end;

if vendwebsite='' then
  begin
  mess:=mess+#13#10;
  mess:=mess+'You may want to include your Website address.';
  end;

if vendemail='' then
  begin
  mess:=mess+#13#10;
  mess:=mess+'You may want to include your Email address.';
  end;

if runfile='' then
  begin
  mess:=mess+#13#10;
  mess:=mess+'You may want to specify the Main File that will open/execute when the user clicks Run in the Client.';
  end;

if mess<>'' then
  begin
  m2:=m2+#13#10+'You may wish to edit any of the following in your Project Definition to make full use of Upgrade Suite Client''s features.'+#13#10;
  m2:=m2+mess;
  end;

if m2<>'' then
  begin
  if cont then
    begin
    if not valcontquiet then
      begin
      if creflag then
        m2:=m2+#13#10#13#10+'Click Edit on the Project Toolbar to change any of the above ( if you wish ) after this operation is completed.'
      else
        m2:=m2+#13#10#13#10+'If you cannot change these details ( and you want to) by repeating the operation, contact the Project Administrator.';
      showmessagenotsilent(m2);
      end
    end
  else
    begin
    if not valcontquiet then
      begin
      if creflag then
        m2:=m2+#13#10#13#10+'Click Edit on the Project Toolbar to change any of the above.'
      else
        m2:=m2+#13#10#13#10+'If you cannot change these details by repeating the operation, contact the Project Administrator.';
      showmessagenotsilent(m2);
      end;
    end
  end;
end;

procedure tap.showdeploylist(title:string);
var
  c,cm:integer;
begin
cm:=deploylist.Count-1;
viewfm.m1.lines.add('');
viewfm.m1.lines.add('  '+uppercase(title));
viewfm.m1.lines.add('');
if cm>=0 then
  begin
  for c:=0 to cm do
    begin
    viewfm.m1.lines.add('    ['+inttostr(c)+']: '+deploylist[c]);
    end
  end
else
  begin
  viewfm.m1.lines.add('  Empty');
  end;
viewfm.m1.lines.add('');
viewfm.m1.lines.add('  END DEPLOYMENT LIST');
viewfm.m1.lines.add('');
end;

function tap.cleardeploylist:boolean;
begin
result:=deletefile(ffname+'.dep');
end;

procedure Tap.removestagefilelist;
var
  c,d:integer;
  posn:integer;
begin
{ remove files in deploylist that are not in the staging area }
d:=deploylist.count-1;
for c:=d downto 0 do
  begin
  posn:=stagefilelist.indexof(deploylist[c]);
  if posn=-1 then
    begin
    deploylist.delete(c);
    end;
  end;
stagefilelist.clear;
end;

{ populates deployment list from staging area based on preparation }
function Tap.populatedeploylist(stagepath:string): boolean;
var
  cnt,cntm:integer;
  cf:tapfolder;
  tresult:boolean;
  ts:string;
  posn:integer;
begin
result:=true;
deploylist:=tstringlist.create;
stagefilelist:=tstringlist.create;
deploylist.savetofile(ffname+'.dep');
deploylist.loadfromfile(ffname+'.dep');
{ Patch directory }
mainfm.flb1.Directory:=makedpath(stagepath)+makedpath(fname)+makedpath('Patch');
mainfm.flb1.mask:='*.*';
mainfm.flb1.filetype:=[ftNormal,ftReadonly,ftArchive];
cntm:=mainfm.flb1.items.count-1;
for cnt:=0 to cntm do
  begin
  ts:=makedpath(mainfm.flb1.Directory)+mainfm.flb1.Items[cnt];
  posn:=deploylist.indexof(ts);
  if posn=-1 then
    deploylist.add(ts);
  end;
try
{ is this necessary ? }
apfolds.pack;
cntm:=apfolds.count-1;
for cnt:=0 to cntm do
  begin
  cf:=apfolds[cnt];
  tresult:=popdlrec(stagepath,cf);
  if tresult=false then
    begin
    result:=false;
    end;
  end;
showdeploylist('Deployment List after population');
deploylist.savetofile(ffname+'.dep');
deploylist.free;
stagefilelist.free;
viewfm.m1.lines.add('');
finally
  Screen.Cursor := crDefault;
end;
end;


function Tap.popdlrec(stagepath: string; curf: tapfolder): boolean;
{ Like compilerec }
var
  sapath:string;
  cnt,cntm:integer;
  tempf:tapfile;
  shortfn:string;
  safn,sdfn:string;
  posn:integer;
begin
result:=true;
sapath:=makedpath(stagepath)+makedpath(fname)+makedpath(foldtolongpath(curf));
{ prepare individual files }
cntm:=curf.apfiles.count-1;
for cnt:=0 to cntm do
  begin
  tempf:=tapfile(curf.apfiles[cnt]);
  shortfn:=extractfilename(tempf.name);
  sdfn:=tempf.name;
  safn:=sapath+getfilefromurl(sdfn);
  if fileexists(safn)  then
  { add to deploylist }
    begin
    posn:=deploylist.indexof(safn);
    if posn=-1 then
      deploylist.add(safn);
    end;
  end;
curf.apfolds.pack;
cntm:=curf.apfolds.count-1;
for cnt:=0 to cntm do
  begin
  popdlrec(stagepath,curf.apfolds[cnt]);
  end;
end;


function Tap.loaddeplist: boolean;
var
  sl:tstringlist;
  cm,c:integer;
begin
result:=true;
try
sl:=tstringlist.create;
//viewfm.m1.Clear;
viewfm.m1.lines.add('');
viewfm.m1.lines.add('  PROJECT DEPLOYMENT LIST: '+ffname+'.dep');
viewfm.m1.lines.add('');
if fileexists(ffname+'.dep') then
  begin
  sl.LoadFromFile(ffname+'.dep');
  cm:=sl.count-1;
  for c:=0 to cm do
    begin
    viewfm.m1.lines.add('    ['+inttostr(c)+']: '+sl[c]);
    end;
  end;
viewfm.m1.lines.add('');
viewfm.m1.lines.add('  END PROJECT DEPLOYMENT LIST');
viewfm.m1.lines.add('');
sl.free;
except
result:=false;
end;
end;

function Tap.getdesktoppath: string;
var
  ilist:pitemidlist;
  path:pchar;
begin
result:='error';
try
  ShGetSpecialFolderLocation( application.handle,
  CSIDL_DESKTOP , PItemIDLIst(iList ));
  getmem(path,200);
  shgetpathfromidlist(ilist,path);
  result:=strpas(path);
  freemem(path);
  cotaskmemfree(iList);
except
  result:='error';
end;
end;

end.
