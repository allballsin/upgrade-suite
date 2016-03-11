unit recapp;

interface

uses {windows,share,ap,apfolder,
      apfile,registry,sysutils,settings,
      dialogs,shellapi,controls,md5,
      filectrl,forms,comctrls,classes,
      inifiles;}
      windows,forms,share,apfolder,ap,
      apfile,registry,sysutils,settings,
      dialogs,shellapi,controls,md5b,
      filectrl,inifiles,zlibarchive,pmupgrade,nmftp,nmhttp;

type
	trecapp = class(Tobject)
  	name:string;
    id:string;
    installdir:string;
    inststatus:tinststatus;
    qstatus:tqstatus;
    verstatus:tverstatus;
    instver:string;
    autoupg:boolean;
    latver:string;
    prevver:string;
    redeploy:string;
    automirror:boolean;
    backupid:string;
    ffname:string;
    { For scheduled upgrades }
    useScheduling:boolean;
    ScheduleTime:ttime;
    ScheduleDate:tdate;

    constructor create;
    destructor destroy;override;
    function savetoreg:boolean;
    function loadfromreg(ids:string):boolean;

	  { convert status numbers to english words }
  	function qs2eng(s:tqstatus):string;
	  function is2eng(s:tinststatus):string;
  	function vs2eng(s:tverstatus):string;

		function getlatestpdf(var http:tnmhttp;var ftp:tnmftp;pth:string;projpath:string;forceanon:boolean):string;
    procedure getviewlatestreadme(var http:tnmhttp;var ftp:tnmftp;forceanon:boolean);
    procedure checkinstall(projpath:string);

    function checkdeps:boolean;
    function appcheckrec(curf:tapfolder):boolean;
    function install(var http:tnmhttp;var ftp:tnmftp;forceaction:boolean;projpath:string;forceanon:boolean):boolean;
    function appinstrec(var http:tnmhttp;var ftp:tnmftp;curf:tapfolder;forceaction:boolean;useftp:boolean):boolean;
    function uninstall(projpath:string):boolean;
		function appdelrec(cf:tapfolder):boolean;
    function runproj:boolean;
		procedure regify(fname:string);
		function projregified(fname:string):boolean;

    function viewreadme:boolean;
  private

  	latestver:boolean;
		fullinstalled:boolean;
		notinstalled:boolean;

    function writeactionfile(ids:string): boolean;
    function fileaction(tempf:tapfile;fn:string):boolean;
    function getwapfn(wafnmd5:string): string;
    function getdapurl(wafnmd5:string;var dat:turltype):string;
    function getdaurl(tempfile:tapfile;var dat:turltype):string;
    function installfile(var http:tnmhttp;var ftp:tnmftp;tempf:tapfile;td,wa:string;forceaction:boolean): boolean;
    function gettddir(tempfold:tapfolder):string;
    function getwadir(tempfold:tapfolder):string;

  public
  	tempap:tap;
    function loginftp(var ftp:tnmftp;burl:string;name:string;forceanon:boolean): boolean;
    function removepdf(projpath:string):boolean;
    function unregify:boolean;
    function remworkarea:boolean;
  end;


var
  revertingnow:boolean;

implementation

uses main,fsave,view,login;

{ trecapp methods }
constructor trecapp.create;
begin
inherited create;
tempap:=tap.create;
end;

destructor trecapp.destroy;
begin
tempap.free;
inherited destroy;
end;

function trecapp.savetoreg:boolean;
var
	reg:tregistry;
  tk:string;
begin
tk:=recprojroot+'\'+id;
result:=true;
reg:=tregistry.create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(tk,true);
try
  reg.WriteString('name',name);
except
  result:=false;
end;
try
  reg.WriteString('id',id);
except
  result:=false;
end;
try
  reg.WriteString('backupid',backupid);
except
  result:=false;
end;
try
  reg.WriteString('installdir',installdir);
except
  result:=false;
end;
try
  reg.WriteInteger('inststatus',integer(inststatus));
except
  result:=false;
end;
try
  reg.WriteInteger('qstatus',integer(qstatus));
except
  result:=false;
end;
try
  reg.WriteInteger('verstatus',integer(verstatus));
except
  result:=false;
end;
try
  reg.Writestring('latver',latver);
except
  result:=false;
end;
try
  reg.Writestring('prevver',prevver);
except
  result:=false;
end;

try
  reg.WriteString('instver',instver);
except
  result:=false;
end;
try
  reg.WriteString('redeploy',redeploy);
except
  result:=false;
end;
try
  reg.WriteString('ffname',ffname);
except
  result:=false;
end;
try
  reg.Writebool('autoupg',autoupg);
except
  result:=false;
end;
try
  reg.Writebool('automirror',automirror);
except
  result:=false;
end;
try
  reg.Writebool('useScheduling',useScheduling);
except
  result:=false;
end;
try
  reg.Writestring('ScheduleDate',datetostr(ScheduleDate));
except
  result:=false;
end;
try
  reg.Writestring('ScheduleTime',timetostr(ScheduleTime));
except
  result:=false;
end;

reg.closekey;
reg.free;
end;

function trecapp.loadfromreg(ids:string):boolean;
var
	reg:tregistry;
  tk:string;
  ti:integer;
begin
result:=false;
if ids<>'' then
	begin
	result:=true;
  { check if id file exists }
  if not fileexists(s.projpath+ids) then
    begin
    try
    viewfm.m1.lines.add('  Could not find Project Definition File: '+s.projpath+ids);
    except;
    end;
    result := False;
    end
  else
    begin
    tk:=recprojroot+'\'+ids;
    reg:=tregistry.create;
    reg.rootkey:=HKEY_LOCAL_MACHINE;
    reg.openkey(tk,true);
    if reg.ValueExists('name') then
      name:=reg.readstring('name')
    else
      begin
      showmessagenotsilent('Error 124. Project information in registry is corrupt.');
      name:='Unknown';
      end;

    if reg.ValueExists('id') then
      self.id:=reg.readstring('id')
    else
      begin
      showmessagenotsilent('Error 124. Project information in registry is corrupt.');
      self.id:=ids;
      end;

    if reg.ValueExists('installdir') then
      installdir:=reg.readstring('installdir')
    else
      begin
      showmessagenotsilent('Error 108. Project information in registry is corrupt.');
      installdir:='';
      end;

    if reg.ValueExists('inststatus') then
      begin
      ti:=reg.readinteger('inststatus');
      inststatus:=tinststatus(ti);
      end
    else
      begin
      showmessagenotsilent('Error 109. Project information in registry is corrupt.');
      inststatus:=isUninstalled;
      end;

    if reg.ValueExists('qstatus') then
      begin
      ti:=reg.readinteger('qstatus');
      qstatus:=tqstatus(ti);
      end
    else
      begin
      showmessagenotsilent('Error 110. Project information in registry is corrupt.');
      qstatus:=qsNotqueued;
      end;

    if reg.ValueExists('verstatus') then
      begin
      ti:=reg.readinteger('verstatus');
      verstatus:=tverstatus(ti);
      end
    else
      begin
      showmessagenotsilent('Error 111. Project information in registry is corrupt.');
      verstatus:=vsNewveravail;
      end;

    if reg.ValueExists('instver') then
      instver:=reg.readstring('instver')
    else
      begin
      showmessagenotsilent('Error 112. Project information in registry is corrupt.');
      instver:='NA';
      end;

    if reg.ValueExists('backupid') then
      backupid:=reg.readstring('backupid')
    else
      begin
      showmessagenotsilent('Error 220. Project information in registry is corrupt.');
      backupid:='';
      end;

    if reg.ValueExists('latver') then
      latver:=reg.readstring('latver')
    else
      begin
      showmessagenotsilent('Error 120. Project information in registry is corrupt.');
      latver:='NA';
      end;

    if reg.ValueExists('prevver') then
      prevver:=reg.readstring('prevver')
    else
      begin
      showmessagenotsilent('Error 120. Project information in registry is corrupt.');
      latver:='NA';
      end;

    if reg.ValueExists('autoupg') then
      autoupg:=reg.readbool('autoupg')
    else
      begin
      showmessagenotsilent('Error 116. Project information in registry is corrupt.');
      autoupg:=true;
      end;


    if reg.ValueExists('redeploy') then
      redeploy:=reg.readstring('redeploy')
    else
      begin
      showmessagenotsilent('Error 121. Project information in registry is corrupt.');
      redeploy:='';
      end;

    if reg.ValueExists('ffname') then
      ffname:=reg.readstring('ffname')
    else
      begin
      showmessagenotsilent('Error 121. Project information in registry is corrupt.');
      ffname:='';
      end;

    if reg.ValueExists('automirror') then
      automirror:=reg.readbool('automirror')
    else
      begin
      showmessagenotsilent('Error 122. Project information in registry is corrupt.');
      automirror:=false;
      end;

    if reg.ValueExists('useScheduling') then
      useScheduling:=reg.readbool('useScheduling')
    else
      useScheduling:=false;

    if reg.ValueExists('ScheduleDate') then
      ScheduleDate:=Strtodate(reg.readstring('ScheduleDate'));

    if reg.ValueExists('ScheduleTime') then
      ScheduleTime:=StrtoTime(reg.readstring('ScheduleTime'));

    reg.closekey;
    reg.Free;
    tempap.loadfromfile(s.projpath+ids);
    end
  end;
end;

function trecapp.qs2eng(s:tqstatus):string;
begin
result:='Unknown';
case s of
qsWaiting:
  begin
  result:='Waiting';
  end;
qsInstalling:
  begin
  result:='Receiving';
  end;
qsNotqueued:
  begin
  result:='Not Queued';
  end
else
  begin
  showmessagenotsilent('Error 117. Unrecognised Queue Status.');
  end;
end;
end;

function trecapp.is2eng(s:tinststatus):string;
begin
result:='Unknown';
case s of
  isInstalled:
    begin
    result:='Installed';
    end;
  isUninstalled:
    begin
    result:='Uninstalled';
    end;
  isPartinstalled:
    begin
    result:='Part Installed';
    end;
  isPartuninstalled:
  	begin
    result:='Part Uninstalled';
    end

  else
    begin
    showmessagenotsilent('Error 118. Unrecognised Installation Status.');
    end;
  end;
end;

function trecapp.vs2eng(s:tverstatus):string;
begin
result:='Unknown';
case s of
  vsUptodate:
    begin
    result:='Latest';
    end;
  vsNewveravail:
    begin
    if latver<>'' then
	    result:=latver+' Available'
    else
    	result:='New Available';
    end
  else
    begin
    showmessagenotsilent('Error 119. Unrecognised Version Status.');
    end;
  end;
end;

function trecapp.getlatestpdf(var http:tnmhttp;var ftp:tnmftp;pth:string;projpath:string;forceanon:boolean):string;
var
  ts,ts2:string;
  dltype:turltype;
  goon:boolean;
begin
result:='';
tempap.loadfromfile(projpath+id);
{ get name of pdf }
ts:=tempap.ownloc;
ts2:=makedpath(pth)+getfilefromurl(ts);
dltype:=getdltype(ts);
goon:=true;
viewfm.m1.Lines.Add(uppercase('Getting Latest Project Definition File ['+datetimetostr(now)+']'));
if dltype=utFTP then
  begin
  if not loginftp(ftp,ts,tempap.nname,forceanon) then
    goon:=false;
  end;
if goon then
  begin
  if dloadfile(http,ftp,dltype,ts,ts2,true,false,0)=drSuccess then
    begin
    result:=ts2;
    end
  else
    begin
    if not s.runsilent then
      autoupg:=false;
    savetoreg;
    result:='';
    end;
  end;
end;

procedure trecapp.getviewlatestreadme(var http:tnmhttp;var ftp:tnmftp;forceanon:boolean);
var
  ts:string;
  dltype:turltype;
  tempaf:tapfile;
  res:integer;
  goon:boolean;
begin
tempap.loadfromfile(s.projpath+id);
{ get name of readme }
ts:=tempap.readmefile;
{ get url of readme file }
if ts='' then
	begin
  if not s.runsilent then
    showmessagenotsilent('There is no readme file for this Project.');
  end
else
	begin
  tempaf:=tempap.findfile(tempap.readmefile,tempap.rootfold);
  if tempaf=nil then
    begin
    if not s.runsilent then
      showmessagenotsilent('Error 217. The Project Administrator has not included the readme file in this Project.');
    end
  else
  	begin
    { get this info from readme apfile }
    ts:=tempaf.url;
    dltype:=getdltype(ts);
    if dltype=utUnknown then
    	begin
      { get baseurl }
      dltype:=getdltype(tempap.baseurl);
      if (dltype=utHTTP) or (dltype=utFTP) then
      	ts:=makewpath(tempap.baseurl)+ts
      else if (dltype=utLNF) then
      	ts:=makedpath(tempap.baseurl)+ts
      else
      	showmessagenotsilent('Error 218. Could not determine type of base URL.');
      end;
    goon:=true;
    if dltype=utFTP then
      begin
      if not loginftp(ftp,ts,tempap.nname,forceanon) then
        goon:=false;
      end;
    if goon then
      begin
      if dloadfile(http,ftp,dltype,ts,makedpath(s.temppath)+getfilefromurl(ts),true,false,0)<>drSuccess then
        goon:=false;
      end;
    ftpdisconnect(ftp);
    if goon then
      begin
      if shellexecute(0,'open',pchar(tempap.readmefile),nil,pchar(s.temppath),SW_SHOWNORMAL)<=32 then
        begin
        if s.runsilent then
          res:=mryes
        else
          res:=messagedlg('Could not open file in associated application. Use Notepad instead?',mtconfirmation,[mbyes,mbno],0);
        if res=mryes then
          begin
          shellexecute(0,'open','notepad.exe',pchar(makedpath(s.temppath)+tempap.readmefile),pchar(s.windir),0);
          end;
        end;
      end
    else
      begin
      showmessagenotsilent('Could not retrieve latest Readme File.');
      end;
    end;
  end;
end;

procedure trecapp.checkinstall(projpath:string);
var
	cnt,cntm:integer;
  cf:tapfolder;
//  za2:TZLBArchive;
begin
latestver:=true;
fullinstalled:=true;
notinstalled:=true;
{ check install and set inststatus and verstatus }
projpath:=makedpath(projpath);
//viewfm.m1.lines.clear;
if assigned(viewfm) then
  begin
  viewfm.m1.lines.add('');
  viewfm.m1.lines.add(uppercase('Checking installation of "'+name+'" ['+datetimetostr(now)+']'));
  end;
{ cater for zip files }
if isfilezipped(projpath+id) then
  begin
  { unzip }
  copyfile(pchar(projpath+id),pchar(projpath+id+'.zzz'),false);
//  za2:=TZLBArchive.create(application);
  mainfm.za.OpenArchive(projpath+id+'.zzz');
  mainfm.za.ExtractAll(projpath);
  mainfm.za.CloseArchive;
//  za2.free;
  deletefile(projpath+id+'.zzz');
  end;
if tempap.loadfromfile(projpath+id) then
	begin
  { Start at root folder }
  tempap.apfolds.pack;
  cntm:=tempap.apfolds.count-1;
  for cnt:=0 to cntm do
    begin
    cf:=tempap.apfolds[cnt];
    appcheckrec(cf);
    end;
  end
else
	begin
  showmessagenotsilent('Could not load Project Definition File: '+s.projpath+id);
  end;
{ do something with the final results }
if notinstalled then
	inststatus:=isUninstalled
else if fullinstalled then
	inststatus:=isInstalled
else if ( not fullinstalled) and (not notinstalled) then
	inststatus:=isPartInstalled;
if (latestver) and (fullinstalled)then
  begin
	verstatus:=vsUptodate;
  instver:=latver;
  end
else
	verstatus:=vsNewveravail;
if assigned(viewfm) then
  begin
  viewfm.m1.lines.add('  Installation Status: '+is2eng(inststatus));
  viewfm.m1.lines.adD('  Version Status:'+vs2eng(verstatus));
  viewfm.m1.lines.add('  Installed Version: '+instver);
  viewfm.m1.lines.adD('  Latest Version Available: '+latver);
  viewfm.m1.lines.adD('  Queue Status: '+qs2eng(qstatus));
  viewfm.m1.lines.add('');
  end;
savetoreg;
end;

function trecapp.appcheckrec(curf:tapfolder):boolean;
var
  cnt,cntm,c2,c2m:integer;
  tempf:tapfile;
  tp3:string; // folder strings
  tempfold:tapfolder;
  ts,ts3,ts7:string; // temporary strings
  finished:boolean;
begin
result:=true;
{ determine path of installation directory }
tp3:='';
tempfold:=curf;
finished:=false;
while not finished do
  begin
  ts:=tempap.foldtosname(tempfold.name);
  if ts='Root' then
    begin
    tp3:=makedpath(installdir)+tp3;
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
c2m:=curf.apfiles.count-1;
for c2:=0 to c2m do
  begin
  tempf:=tapfile(curf.apfiles[c2]);
  { this is where you check if each file installed and
  	matching latest MD5 number }

  { location of file in destination directory }
  ts7:='';
  ts:=makedpath(tp3)+tempf.name; // latest file install location
  ts3:='';

  if fileexists(ts) then
    begin
    notinstalled:=false;
    ts7:=filemd5digest(ts);
    if ts7=tempf.md5 then
      begin
      { latest file installed }
      if assigned(viewfm) then
        begin
        viewfm.m1.lines.add('  '+ts+' : Latest');
        end
      end
    else
      begin
      { installed file is old version }
      latestver:=false;
      if assigned(viewfm) then
        begin
        viewfm.m1.lines.add('  '+ts+' : Out of Date');
        end;
      end
    end
  else
    begin
    fullinstalled:=false;
    if assigned(viewfm) then
      begin
      viewfm.m1.lines.add('  '+ts+' : Missing');
      end
    end;
  end;
{ recurse down folder list in current folder object }
curf.apfolds.pack;
cntm:=curf.apfolds.count-1;
ts:=tempap.foldtosname(curf.name);
for cnt:=0 to cntm do
  begin
  appcheckrec(curf.apfolds[cnt]);
  end;
end;

{ forceaction forces any registering or executing action even if
 latest file is in place }
function trecapp.install(var http:tnmhttp;var ftp:tnmftp;forceaction:boolean;projpath:string;forceanon:boolean):boolean;
var
	cnt,cntm:integer;
  cf:tapfolder;
  ts:string;
  useftp:boolean;
  goon:boolean;
//  za2:TZLBArchive;
begin
rebootnow:=false;
result:=true;
//oldverstatus:=verstatus;
{ install Project }
{ may not be wanted anymore }
projpath:=makedpath(projpath);
//s.projpath:=makedpath(s.projpath);
{ check for zipped files }
if isfilezipped(projpath+id) then
  begin
  copyfile(pchar(projpath+id),pchar(projpath+id+'.zzz'),false);
//  za2:=TZLBArchive.create(application);
  mainfm.za.OpenArchive(projpath+id+'.zzz');
  mainfm.za.ExtractAll(projpath);
  mainfm.za.CloseArchive;
//  za2.free;
  deletefile(projpath+id+'.zzz');
  end;
if tempap.loadfromfile(projpath+id) then
	begin
  { use compile code to recurse through structure and download files }
  { Project IMAGE CONSTRUCTION }
  { check if last character is \ }
  { how the add '\' to end of a path should look }
  s.wkpath:=makedpath(s.wkpath);
  installdir:=makedpath(installdir);
  { create patch directory in workarea }
  ts:=s.wkpath+tempap.id+'\Patch';
  if not directoryexists(ts)  then
    forcedirectories(ts);
  { Start at root folder }
  cntm:=tempap.apfolds.count-1;
  //mainfm.zm1.load_unz_dll;
  //viewfm.m1.lines.clear;
  viewfm.m1.lines.add('');
  viewfm.m1.lines.add(uppercase('Installing "'+name+'" ['+datetimetostr(now)+']'));
  viewfm.m1.lines.add('');
  { check if you need to log in to an FTP server }
  useftp:=false;
  goon:=true;
  if getdltype(tempap.baseurl)=utFTP then
    begin
    { first log in }
    if loginftp(ftp,tempap.baseurl,tempap.nname,forceanon) then
      useftp:=true
    else
      goon:=false;
    end;
  if not goon then
    begin
    if not s.runsilent then
      showmessagenotsilent('Installation Cancelled.');
    result:=false;
    end
  else
    begin
    for cnt:=0 to cntm do
      begin
      cf:=tempap.apfolds[cnt];
      appinstrec(http,ftp,cf,forceaction,useftp);
      end;
    end;
  //mainfm.zm1.unload_unz_dll;
  { disconnect ftp if connected }
  if ftpconnected then
    ftpdisconnect(ftp);
  qstatus:=qsNotqueued;
  savetoreg;
  end
else
	begin
  showmessagenotsilent('Could not load Project Definition File.');
  end;
end;

{ assumes ftp logged in? }
function trecapp.appinstrec(var http:tnmhttp;var ftp:tnmftp;curf:tapfolder;forceaction:boolean;useftp:boolean):boolean;
var
  cnt,cntm,c2,c2m:integer;
  tempf:tapfile;
//  res:boolean;
  ts:string; // temporary strings
  { new vars }
  wa,td:string;
begin
result:=true;

{ determine path of directory in workarea }
wa:=getwadir(curf);
{ determine path of installation directory }
td:=gettddir(curf);

{ get into correct FTP folder }
//if ftp then
//  begin
//  changeto(makewpath(tempap.baseurl)+tempap.foldtolongpath(curf));
//  end;

{ get list of files from fold }
c2m:=curf.apfiles.count-1;
for c2:=0 to c2m do
  begin
  tempf:=tapfile(curf.apfiles[c2]);
  installfile(http,ftp,tempf,td,wa,forceaction);
  end;
{ recurse down folder list in current folder object }
curf.apfolds.pack;
cntm:=curf.apfolds.count-1;
ts:=tempap.foldtosname(curf.name);
for cnt:=0 to cntm do
  begin
  appinstrec(http,ftp,curf.apfolds[cnt],forceaction,useftp);
  end;
end;

function trecapp.uninstall(projpath:string):boolean;
var
	cnt,cntm:integer;
  cf:tapfolder;
begin
rebootnow:=false;
result:=true;
{ load directory structure }
{ remove local files }
{ remove shortcuts }
{ check if item ready to download }
s.projpath:=makedpath(s.projpath);
qstatus:=qsNotqueued;
inststatus:=isUninstalled;
tempap.loadfromfile(s.projpath+id);
installdir:=makedpath(installdir);
{ Start at root folder }
tempap.apfolds.pack;
cntm:=tempap.apfolds.count-1;
//viewfm.m1.lines.clear;
viewfm.m1.lines.add('');
viewfm.m1.lines.add(uppercase('Uninstalling "'+name+'" ['+datetimetostr(now)+']'));
viewfm.m1.lines.add('');
for cnt:=cntm downto 0 do
  begin
  cf:=tempap.apfolds[cnt];
  if not appdelrec(cf) then
  	result:=false
  end;
if inststatus=isUninstalled then
  begin
  if not s.runsilent then
  	showmessagenotsilent('"'+tempap.nname+'" uninstallation complete.')
  end
else
  begin
  if rebootnow then
    begin
    if not s.runsilent then
    	showmessagenotsilent('"'+tempap.nname+'" uninstallation will be completed when you reboot your computer.');
    end
  else
    begin
    if not s.runsilent then
      showmessagenotsilent('"'+tempap.nname+'" was not uninstalled completely.');
    end;
  end;
{ disconnect ftp if connected }
instver:='NA';
autoupg:=false;
savetoreg;
checkinstall(projpath);
end;

function trecapp.appdelrec(cf:tapfolder):boolean;
var
  cnt,cntm,c2,c2m:integer;
  tempf:tapfile;
  tp3:string; // folder strings
  tempfold:tapfolder;
  res:boolean;
  ts,ts7:string; // temporary strings
  finished:boolean;
begin
result:=true;
{ recurse down folder list in current folder object }
cf.apfolds.pack;
cntm:=cf.apfolds.count-1;
for cnt:=0 to cntm do
  begin
  appdelrec(cf.apfolds[cnt]);
  end;

{ determine path of installation directory }
tp3:='';
tempfold:=cf;
finished:=false;
while not finished do
  begin
  ts:=tempap.foldtosname(tempfold.name);
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
c2m:=cf.apfiles.count-1;
for c2:=0 to c2m do
  begin
  tempf:=tapfile(cf.apfiles[c2]);
  { this is where you install each file }
  { start variations based on download type for this file }
  { location of file in destination directory }
  ts7:='';
  // getnewfile:=false;
  ts:=tp3+tempf.name; // latest file install location
  if fileexists(ts) then
    begin
    { if file in Windows or System Directory, then
    	add file to File Saver }
    if 	(pos(s.windir,makedpath(extractfilepath(ts)))<>0) or
        (pos(s.sysdir,makedpath(extractfilepath(ts)))<>0) then
        begin
        fsavefm.addfsavefile(tempap.id,ts);
        end;
    res:=deletefile(pchar(ts));
    if res=true then
    	begin
      viewfm.m1.lines.add('  '+ts+' deleted.');
      end
    else
      begin
      viewfm.m1.lines.add('  '+ts+' not deleted until reboot.');
      inststatus:=isPartuninstalled;
      deleteatreboot(ts);
      rebootnow:=true;
      end;
    end;
  { delete shortcut }
  tempf.delshortcut;
  { remove directory }
  end;
try
if 	(pos(s.windir,makedpath(extractfilepath(ts)))=0) and
    (pos(s.sysdir,makedpath(extractfilepath(ts)))=0) then
   rmdir(tp3);
except
end;
end;

function trecapp.runproj:boolean;
begin
result:=true;
tempap.loadfromfile(s.projpath+id);
if shellexecute(0,'open',pchar(installdir+tempap.runfile),nil,
  pchar(installdir),SW_SHOWNORMAL)<=32 then
  begin
  showmessagenotsilent('Error 211. Could not run main Project file.');
  end;
end;

procedure trecapp.regify(fname:string);
var
  bres:boolean;
  ts:string;
  tempapp:tap;
  ids:string;
begin
{ open file and get ID then save as filename }
{ assume not zipped }
ids:=getidfromfile(fname);
if ids<>'' then
  begin
  ts:=s.projpath+ids;
  if ts<>fname then
  	begin
    bres:=copyfile(pchar(fname),pchar(ts),false);
    if bres=false then
      begin
      showmessagenotsilent('Error 104. Could not save Project Definition File in projects directory.');
      end;
    end;
  { open new file, read in valid info, and savetoreg }
  ffname:=ts;
  tempapp:=tap.create;
  if tempapp.loadfromfile(ts)=false then
  	showmessagenotsilent('Could not load Project Definition File: '+ts);
  { transfer pertinent values }
  //installdir:=tempapp.deflocdir;
  name:=tempapp.nname;
  instver:='NA';
  prevver:='NA';
  autoupg:=true;
  id:=tempapp.id;
  inststatus:=isUninstalled;
  qstatus:=qsNotQueued;
  latver:=tempapp.version;
  verstatus:=vsNewveravail;
  redeploy:='';
  automirror:=false;
  if tempapp.ScheduleUpgrade=1 then
    useScheduling:=true
  else
    useScheduling:=false;
  ScheduleDate:=tempapp.upgradedate;
  ScheduleTime:=tempapp.upgradetime;
  savetoreg;
	tempapp.free;
  end
end;

{ check if pdf has been regified }
function trecapp.projregified(fname:string):boolean;
var
  ids:string;
begin
result:=false;
if fileexists(fname) then
	begin
  ids:=getidfromfile(fname);
  if ids<>'' then
    result:=isidregified(ids);
  end;
end;

function trecapp.checkdeps:boolean;
var
	cnt,cntm:integer;
  tempapp:tap;
  parentinst:boolean;
begin
result:=true;
tempapp:=tap.create;
{ load app }
tempapp.loadfromfile(s.projpath+id);
{ check if project's dependencies are installed }
{ could be optimised using parentid.indexof(str) }
cntm:=tempapp.parentid.count-1;
for cnt:=0 to cntm do
  begin
  parentinst:=true;
  if isprojinstalled(tempapp.parentid[cnt]) = false then
	  parentinst:=false;
  if parentinst=false then
    begin
    if not s.runsilent then
      showmessagenotsilent('This Project cannot be installed without '+tempapp.parentname[cnt]);
    result:=false;
    end;
  end;
end;

function trecapp.viewreadme:boolean;
var
  ts:string;
  tempaf:tapfile;
  res:integer;
begin
result:=true;
tempap.loadfromfile(s.projpath+id);
{ get name of readme }
ts:=tempap.readmefile;
{ get url of readme file }
if ts='' then
	begin
  if not s.runsilent then
    showmessagenotsilent('There is no readme file for this Project.');
  end
else
	begin
  if s.runsilent then
    res:=mrno
  else
    res:=messagedlg('Do you want to view the Readme File?',mtconfirmation,[mbyes,mbno],0);
  if res=mryes then
    begin
    tempaf:=tempap.findfile(tempap.readmefile,tempap.rootfold);
    if tempaf=nil then
      begin
      if not s.runsilent then
        showmessagenotsilent('Error 217. The Project Administrator has not included the readme file in this Project.');
      result:=false;
      end
    else
      begin
      if not s.runsilent then
        begin
        if shellexecute(0,'open',pchar(tempap.readmefile),nil,pchar(installdir),SW_SHOWNORMAL)<=32 then
          begin
          result:=false;
          res:=messagedlg('Could not open file '+tempap.readmefile+' in associated application. Use Notepad instead?',mtconfirmation,[mbyes,mbno],0);
          if res=mryes then
            begin
            if shellexecute(0,'open','notepad.exe',pchar(makedpath(installdir)+tempap.readmefile),pchar(s.windir),SW_SHOWNORMAL)<=32 then
              result:=false
            else
              result:=true;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function trecapp.unregify:boolean;
var
	reg:tregistry;
begin
{ removes id from registry }

reg:=tregistry.Create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(recprojroot,true);
result:=reg.deletekey(id);
reg.closekey;
reg.free;

end;

function trecapp.removepdf(projpath:string):boolean;
begin
result:=deletefile(pchar(projpath+id));
end;

function trecapp.getwadir(tempfold:tapfolder):string;
var
  finished: boolean;
begin
result:='';
finished:=false;
while not finished do
  begin
  result:=tempap.foldtosname(tempfold.name)+'\'+result;
  if tempfold.parent<>nil then
    tempfold:=tempfold.parent
  else
    finished:=true;
  end;
result:=s.wkpath+tempap.fname+'\'+result;
if not directoryexists(result)  then
   forcedirectories(result);
result:=makedpath(result);
end;

function trecapp.gettddir(tempfold:tapfolder):string;
var
  finished: boolean;
  ts:string;
begin
result:='';
finished:=false;
while not finished do
  begin
  ts:=tempap.foldtosname(tempfold.name);
  if ts='Root' then
    begin
    result:=installdir+result;
    end
  else if ts='Windows' then
    begin
    result:=makedpath(s.windir)+result;
    end
  else if ts='System' then
    begin
    result:=makedpath(s.sysdir)+result;
    end
  else
    begin
    result:=tempfold.name+'\'+result;
    end;
  if tempfold.parent=nil then
    finished:=true
  else
    tempfold:=tempfold.parent;
  end; // while
if result<>'' then
  begin
  if not directoryexists(result) then
    forcedirectories(result);
  result:=makedpath(result);
  end;
end;

function trecapp.installfile(var http:tnmhttp;var ftp:tnmftp;tempf:tapfile;td,wa:string;forceaction:boolean): boolean;
var
  tdfn,wafn,dafn,dapfn,wapfn:String;
  tdfnmd5,wafnmd5:string;
  dat,dapt:turltype;
  psuc:boolean;
  fp:string;
//  za2:TZLBArchive;
  procedure wa2td;forward;
  procedure waeqmd5;forward;
  procedure dap2wa;forward;
  procedure td2wa;forward;

  procedure da2wa;
    begin
    if dloadfile(http,ftp,dat,dafn,wafn,true,true,tempap.useRestore)=drSuccess then
      begin
      viewfm.m1.lines.adD('  '+tempf.name+': Deployment Area --> Working Area');
      wa2td;
      end
    else
      begin
      { dload error }
      result:=false;
      viewfm.m1.lines.adD('  '+tempf.name+': Deployment Area -x- Working Area');
      end;
    end;

  procedure wa2td;
    begin
    { check if file saver needed }
    fp:=makedpath(extractfilepath(tdfn));
    { Check if file is a windows or system file }
    if (pos(s.windir,fp)<>0) and (fileexists(tdfn)) then
      begin
      { add file to filesaver }
      fsavefm.addfsavefile(id,tdfn);
      end;
    if copyfile(pchar(wafn),pchar(tdfn),false) then
      begin
      result:=true;
      viewfm.m1.lines.adD('  '+tempf.name+': Working Area --> Target Directory');
      { action }
      fileaction(tempf,tdfn);
      end
    else
      begin
      result:=true;
      viewfm.m1.lines.adD('  '+tempf.name+': Working Area -reboot-> Target Directory');
      copyatreboot(wafn,tdfn,true);
      rebootnow:=true;
      { write action file }
      writeactionfile(id);
      if s.runrecatstartup=false then
        runreconceatreboot;
      end;
    end;

  procedure waeqmd5;
    begin
    wafnmd5:=filemd5digest(wafn);
    if wafnmd5=tempf.md5 then
      begin
      wa2td;
      end
    else
      begin
      dap2wa;
      end;
    end;

  procedure dap2wa;
    begin
    // should be dapfn:=getdapurl(dafnmd5,dapt); ?
    dapfn:=getdapurl(wafnmd5,dapt);
    wapfn:=getwapfn(wafnmd5);
    { get patch }
    if dloadfile(http,ftp,dapt,dapfn,wapfn,false,false,tempap.useRestore)=drSuccess then
      begin
      if isfilezipped(wapfn) then
        begin
        copyfile(pchar(wapfn),pchar(wapfn+'.zzz'),false);
        { unzip }
        deletefile(wapfn);
//        za:=TZLBArchive.create(application);
        mainfm.za.OpenArchive(wapfn+'.zzz');
        mainfm.za.ExtractAll(extractfilepath(wapfn));
        mainfm.za.CloseArchive;
//        za2.free;
        viewfm.m1.lines.add('  Unzipping patch: '+wapfn);
        deletefile(pchar(wapfn+'.zzz'));
        end;
      { patch file }
      psuc:=true;
      //copyfile(pchar(wafn),pchar(wafn+'.zzz'),false);
      deletefile(wafn+'.zzz');
      mainfm.pm1.oldfile:=wafn;
      mainfm.pm1.newfile:=wafn+'.zzz';
      mainfm.pm1.PatchFile:=wapfn;
      try
        mainfm.pm1.applypatch;
      except
        psuc:=false;
      end;
      if (fileexists(wafn+'.zzz')) and (psuc)  then
        begin
        deletefile(wafn);
        copyfile(pchar(wafn+'.zzz'),pchar(wafn),false);
        viewfm.m1.lines.adD('  '+tempf.name+': Working Area + Patch --> Working Area');
        deletefile(wafn+'.zzz');
        { md5 }
        wafnmd5:=filemd5digest(wafn);
        if wafnmd5=tempf.md5 then
          begin
          wa2td;
          end
        else
          begin
          da2wa;
          end;
        end
      else
        begin
        viewfm.m1.lines.adD('  '+tempf.name+': Working Area + Patch -x- Working Area');
        copyfile(pchar(wafn+'.zzz'),pchar(wafn),false);
        deletefile(pchar(wafn+'.zzz'));
        da2wa;
        end;
      end
    else
      begin
      da2wa;
      end;
    end;

  procedure td2wa;
    begin
    if copyfile(pchar(tdfn),pchar(wafn),false) then
      begin
      viewfm.m1.lines.adD('  '+tempf.name+': Target Directory --> Working Area');
      waeqmd5;
      end
    else
      begin
      viewfm.m1.lines.adD('  '+tempf.name+': Target Directory -x- Working Area');
      da2wa;
      end;
    end;
begin
{ assign filename strings }
tdfn:=td+tempf.name;
wafn:=wa+tempf.name;
dafn:=getdaurl(tempf,dat);

{ file in td? }
if fileexists(tdfn)  then
  begin
  { check md5 }
  tdfnmd5:=filemd5digest(tdfn);
  if tdfnmd5=tempf.md5 then
    begin
    { no action }
    viewfm.m1.lines.adD('  '+tempf.name+': Target Directory = Latest File');
    result:=true;
    if forceaction then
      begin
      fileaction(tempf,tdfn);
      end;
    end
  else
    begin
    if fileexists(wafn)  then
      begin
      waeqmd5;
      end
    else
      begin
      td2wa;
      end;
    end;
  end
else
  begin
  { not in td }
  if fileexists(wafn)  then
    begin
    waeqmd5;
    end
  else
    begin
    da2wa;
    end;
  end;
end;


function trecapp.getdaurl(tempfile:tapfile;var dat:turltype):string;
var
  tp1: String;
  tempfold: tapfolder;
  dltypebase: turltype;
  dltypefile: turltype;
begin
{ get url type }
dat:=utUnknown;
dltypefile:=getdltype(tempfile.URL);
dltypebase:=getdltype(tempap.baseurl);
if (dltypefile=utUnknown) and (dltypebase=utUnknown) then
  showmessagenotsilent('Error 135. Cannot determine type of file download.');
dat:=utUnknown;
if dltypefile=utUnknown then
 	dat:=dltypebase
else
 	dat:=dltypefile;
{ get url }
if dltypefile=utUnknown then
  begin
  tempfold:=tempfile.parent;
  tp1:=tempap.foldtolongpath(tempfold);
  if (dat=utHTTP) or (dat=utFTP) then
    begin
    tp1:=makewpath(tempap.baseurl)+tp1;
    result:=makewpath(tp1)+tempfile.name
    end
  else
    begin
    tp1:=makedpath(tempap.baseurl)+tp1;
    result:=makedpath(tp1)+tempfile.name; // remote file name
    end
  end
else
  result:=tempfile.url;
end;

function trecapp.getwapfn(wafnmd5:string): string;
begin
result:='';
if wafnmd5<>'' then
  result:=makedpath(s.wkpath)+tempap.fname+'\Patch\'+wafnmd5; // patch workarea target file
end;

function trecapp.getdapurl(wafnmd5:string;var dat:turltype):string;
var
  typ:turltype;
begin
result:='';
if wafnmd5<>'' then
  begin
  typ:=getdltype(tempap.baseurl);
  if (typ=utHTTP) or (typ=utFTP) then
    result:=makewpath(tempap.baseurl)+'Patch/'+wafnmd5
  else
    result:=makedpath(tempap.baseurl)+'Patch\'+wafnmd5; // remote patch file
  end;
if result<>'' then
  begin
  { get url type }
  dat:=getdltype(result);
  end;
end;

function trecapp.fileaction(tempf:tapfile;fn:string):boolean;
begin
{ make shortcut, register, etc. }
result:=tempf.makeshortcut(fn);
if result=true then
  result:=tempf.registerfile(fn)
else
  tempf.registerfile(fn);
end;

function trecapp.writeactionfile(ids:string): boolean;
var
  actini:tinifile;
begin
result:=true;
try
  actini:=tinifile.create(s.rcpath+'action.ini');
  actini.WriteString('install',ids,'yes');
  actini.free;
  viewfm.m1.lines.add('  Created action file.');
except
result:=false;
end;
end;

function trecapp.loginftp(var ftp:tnmftp;burl:string;name:string;forceanon:boolean): boolean;
var
  host,user,pass:string;
  port:integer;
  goon:boolean;
begin
result:=false;
loginfm.caption:=name+' Retrieval';
goon:=false;
if forceanon then
  begin
  loginfm.bb1.click;
  goon:=true;
  end
else
  begin
  if loginfm.showmodal=mrok then
    goon:=true;
  end;
if goon then
  begin
  host:=getserverfromurl(burl);
  port:=strtoint(loginfm.e3.text);
  user:=loginfm.e1.text;
  pass:=loginfm.e2.text;
  result:=ftpconnect(ftp,host,port,user,pass);
  if not result then
    showmessagenotsilent('Critical Error. Could not log on to '+getserverfromurl(burl)+' as '+loginfm.e1.text);
  end;
end;


function trecapp.remworkarea:boolean;
var
  dr:string;
  res:integer;
begin
result:=true;
{ recursively delete }
dr:=s.wkpath+self.id;
if directoryexists(dr) then
  begin
  res:=messagedlg('Clear out Working Area of "'+name+'" ?'#13#10#13#10+
    '('+dr+')',mtconfirmation,[mbyes,mbno],0);
  if res=mryes then
    begin
    //viewfm.m1.Lines.Clear;
    recdirdel(dr);
    viewfm.m1.lines.add('');
    viewfm.m1.lines.add('  Deleted: Working Area of "'+name+'" ['+datetimetostr(now)+']');
    viewfm.m1.lines.add('');
    end;
  end;
end;
end.
