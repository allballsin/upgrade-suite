unit apfile;

interface
uses windows,forms,dialogs,classes,shellapi,apfolder,sysutils,filectrl,share,shelllnk,controls;

type
  Tapfile = class(TObject)
    name:string;
    URL:string;
    md5:string;
    reg:tstringlist;
    scutname:tstringlist;
    scutloc:tstringlist;
    parent:tapfolder;
    usepatching:boolean;
    exclude:boolean;
    constructor create(prnt:tapfolder);
    destructor destroy;override;
	  function registerfile(fullname:string):boolean;
	  function makeshortcut(targfile:string):boolean;
  	function delshortcut:boolean;
    function scutslist:tstringlist;
    function regslist:tstringlist;
    function clearvals:boolean;
  end;


implementation

uses settings,main;

function Tapfile.clearvals:boolean;
begin
result:=true;
try
name:='';
URL:='';
md5:='';
reg.clear;
scutname.clear;
scutloc.clear;
parent:=nil;
except
result:=false;
end;
end;

constructor tapfile.create(prnt:tapfolder);
begin
inherited create;
parent:=prnt;
reg:=tstringlist.create;
scutname:=tstringlist.create;
scutloc:=tstringlist.create;
usepatching:=true;
exclude:=false;
end;

destructor tapfile.destroy;
begin
scutloc.free;
scutname.free;
reg.free;
inherited destroy;
end;

function tapfile.registerfile(fullname:string):boolean;
var
	cnt,cntm:integer;
  res:integer;
begin
result:=true;
cntm:=reg.count-1;
for cnt:=0 to cntm do
	begin
  { this code is dependent on options available in SErver }
  if reg[cnt]='Register DLL' then
  	begin
		if shellexecute(0,'open','regsvr32.exe',pchar('"'+fullname+'"'),pchar(s.sysdir),SW_SHOWNORMAL)<=32 then
    	showmessagenotsilent('Error 136. Could not register file with Windows.');
    end;
  if reg[cnt]='Execute' then
  	begin
    //mainfm.ActivApp1.MainFormTitle:='';
    //mainfm.ActivApp1.ExePath:=fullname;
    //mainfm.ActivApp1.ExecuteApp(true);

    //if shellexecute(0,'open',pchar(fullname),nil,pchar(extractfilepath(fullname)),SW_SHOWNORMAL)<=32 then
    //	showmessagenotsilent('Error 250. Could not execute file: '+#13#10#13#10+fullname);

    application.Minimize;
    mainfm.AppExec1.ExeName:=fullname;
    mainfm.AppExec1.ExeParams.clear;
    mainfm.AppExec1.ExePath:=extractfilepath(fullname);
    mainfm.AppExec1.Wait:=true;
    mainfm.AppExec1.Execute;
    application.restore;

    end;
	end;
end;

function tapfile.makeshortcut(targfile:string):boolean;
var
  cnt,cntm:integer;
  scut3:TPBShellLink;
begin
result:=true;
cntm:=scutname.count-1;
{ create shortcuts etc. if necessary }
if scutname.count>=0 then
  begin
  for cnt:=0 to cntm do
    begin
    { this can be used to add the folder before the Project shortcut too! }
    scut3:=TPBShellLink.create(application);
    scut3.FileName:=remfortrail(scutloc[cnt])+'\'+scutname[cnt];
    scut3.shellfolder:=sfprograms;
    scut3.target      := targfile;
    scut3.workingdir   := extractfilepath(targfile);
    scut3.description     := scutname.Strings[cnt];
    //mainfm.scut1.fileicon        := '';
    try
    scut3.Write;
    except
    showmessagenotsilent('Could not create shortcut '+scutloc[cnt]+'\'+scutname[cnt]);
    end;
    scut3.free;
    end;
  end;
end;

function tapfile.delshortcut:boolean;
var
  cnt,cntm:integer;
begin
result:=true;
cntm:=scutname.count-1;
{ del shortcuts etc. if necessary }
if scutname.count>=0 then
  begin
  for cnt:=0 to cntm do
    begin
    { this needs to be changed as different ways to create shortcuts gets introduced }
    deletefile(pchar(makedpath(s.windir)+'Programs\'+makedpath(scutloc.Strings[cnt])+scutname.strings[cnt]+'.lnk'));
    if scutloc[cnt]<>'' then
      begin
      try
      rmdir(makedpath(s.windir)+'Programs\'+makedpath(scutloc[cnt]));
      except
      end;
      end;
    end;
  end;
end;

function tapfile.scutslist:tstringlist;
var
	cnt,cntm:integer;
  ts:string;
begin
result:=tstringlist.create;
cntm:=scutloc.count-1;
for cnt:=0 to cntm do
  begin
  ts:=scutloc.strings[cnt]+';'+scutname.strings[cnt];
  result.add(ts);
  end;
end;


function tapfile.regslist:tstringlist;
var
	cnt,cntm:integer;
begin
result:=tstringlist.create;
cntm:=reg.count-1;
for cnt:=0 to cntm do
  begin
  result.add(reg[cnt]);
  end;
end;

end.
