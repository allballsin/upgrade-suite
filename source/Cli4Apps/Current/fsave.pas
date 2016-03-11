unit fsave;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, ComCtrls, ToolWin, StdCtrls, FileCtrl,share,registry,recapp,
  ImgList;

type
  Tfsavefm = class(TForm)
    sb1: TStatusBar;
    s1: TSplitter;
    p1: TPanel;
    m1: TMemo;
    tb2: TToolBar;
    Label5: TLabel;
    p2: TPanel;
    tb1: TToolBar;
    tbt1: TToolButton;
    tbt2: TToolButton;
    tbt3: TToolButton;
    lv2: TListView;
    s2: TSplitter;
    lv1: TListView;
    ilfs: TImageList;
    ToolButton1: TToolButton;
    procedure tbt3Click(Sender: TObject);
    procedure tbt1Click(Sender: TObject);
    procedure tbt2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lv1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
    procedure assignhints; 
    function updatelv1:boolean;
    function updatelv2(li:tlistitem):boolean;
    function readfnamefromreg(id:string;fn:string):string;
    function writefnametoreg(id:string;fn:string):boolean;
    function deletefnamefromreg(id:string;fn:string):boolean;
		procedure showhint(sender:tobject);
  public
    { Public declarations }
    function addfsavefile(id,fname:string):boolean;
    function restorefsavefile:boolean;
    function deletefsavefile:boolean;
  end;

const
 hexit='Exit|Exit File Saver.';
 hnormal='|Normal mode.';
 hadvanced='|View internal program information to track down problems with installations.';
 hrestore='Restore File|Restore deleted or overwritten file to the Windows or System directory.You may be asked to reboot the computer to complete the replacement of a file if it is currently in use.';
 hdelete='Delete File|Permanently delete a file from the File Saver.This frees up some room on your hard disk.';
 hlv1='|List of Projects on this computer that installed files into the Windows or System directories.';
 hlv2='|List of files that were replaced or deleted from the Windows or System directory when a Project was installed/upgraded/deleted.';
var
  fsavefm: Tfsavefm;

implementation

uses settings;

{$R *.DFM}
{ PRIVATE FUNCTIONS }

function tfsavefm.updatelv1:boolean;
var
	cnt,cntm:integer;
  tli:tlistitem;
  tempra:trecapp;
  ts:string;
  tsl:tstringlist;
  reg:tregistry;
  tk:string;
begin
result:=true;
tsl:=tstringlist.create;
tempra:=trecapp.create;
lv1.items.clear;
reg:=tregistry.create;
tk:=recfsaveroot;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(tk,true);
tsl.clear;
reg.GetKeyNames(tsl);
cntm:=tsl.count-1;
for cnt:=0 to cntm do
	begin
  tempra.loadfromreg(tsl[cnt]);
  tli:=lv1.Items.Add;
  tli.caption:=tempra.name;
  tli.subitems.add(tempra.id);
  end;
tempra.free;
tsl.free;
end;

function tfsavefm.updatelv2(li:tlistitem):boolean;
var
	cnt,cntm:integer;
  tli:tlistitem;
  ts,ts2,ts3:string;
  tsl:tstringlist;
  reg:tregistry;
  tk:string;
begin
result:=true;
if lv1.selected<>nil then
	begin
  tsl:=tstringlist.create;
  ts:=li.subitems[0];
  lv2.items.clear;
  reg:=tregistry.create;
  tk:=recfsaveroot+'\'+ts;
  reg.rootkey:=HKEY_LOCAL_MACHINE;
  reg.openkey(tk,true);
  tsl.clear;
  reg.GetValueNames(tsl);
	cntm:=tsl.count-1;
	for cnt:=0 to cntm do
		begin
	  ts2:=tsl[cnt];
	  tli:=lv2.items.Add;
	  tli.caption:=ts2;
    ts3:=readfnamefromreg(ts,ts2);
    if ts3<>'' then
	    tli.subitems.add(ts3)
    else
    	showmessagenotsilent('Error 134. Could not find full path name.');
  	end;
  tsl.free;
	end;
end;

function tfsavefm.readfnamefromreg(id:string;fn:string):string;
var
	reg:tregistry;
  tk:string;
begin
result:='';
tk:=recfsaveroot+'\'+id;
reg:=tregistry.create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(tk,true);
if reg.ValueExists(extractfilename(fn)) then
  result:=reg.readstring(extractfilename(fn))
else
  showmessagenotsilent('Error 133. Could not get file''s full name from the registry.');
reg.closekey;
reg.Free;
end;

function tfsavefm.writefnametoreg(id:string;fn:string):boolean;
var
	reg:tregistry;
  tk:string;
begin
result:=true;
tk:=recfsaveroot+'\'+id;
result:=true;
reg:=tregistry.create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(tk,true);
try
  reg.WriteString(extractfilename(fn),fn);
except
	result:=false;
end;
reg.closekey;
reg.free;
end;


function tfsavefm.deletefnamefromreg(id:string;fn:string):boolean;
var
	reg:tregistry;
  tk:string;
begin
result:=true;
tk:=recfsaveroot+'\'+id;
reg:=tregistry.create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.deletekey(tk);
reg.free;
end;

{ END PRIVATE FUNCTIONS }

{ PUBLIC FUNCTIONS }
function tfsavefm.addfsavefile(id,fname:string):boolean;
var
	bres:boolean;
  tpath:string;
begin
result:=true;
tpath:=makedpath(s.fsavepath)+makedpath(id);
{ copy file to fsavepath\id }
if not directoryexists(tpath) then
	forcedirectories(tpath);
bres:=copyfile(pchar(fname),pchar(tpath+extractfilename(fname)),false);
if bres=true then
	begin
  writefnametoreg(id,fname);
  updatelv1;
  end
else
	begin
	showmessagenotsilent('Error 137. Could not copy file to File Save area.')
  end;
end;

function tfsavefm.restorefsavefile:boolean;
var
	ts,ts2:string;
  bres:boolean;
  winver:integer;
  wininit:textfile;
begin
result:=true;
if lv2.selected<>nil then
	begin
  ts:=makedpath(s.fsavepath)+makedpath(lv1.selected.subitems[0])+lv2.selected.caption;
  ts2:=lv2.selected.subitems[0]; // target file
	{ restore file }
  { shift file }
  if fileexists(ts) then
    begin
    bres:=copyfile(pchar(ts),pchar(ts2),false);
    if bres=false then
      begin
      copyatreboot(ts,ts2,true);
      showmessagenotsilent('Reboot your computer to finish file restoration.');
      end
    else
      begin
      showmessagenotsilent(ts2+' has been successfully restored.');
      end;
    end
  else
    begin
    showmessagenotsilent('Could not find file '+ts+#13#10#13#10'File restoration cancelled.');
    end;
  end
else
  begin
  showmessagenotsilent('Try selecting a file to restore first.');
  end;
end;

procedure tfsavefm.showhint(sender:tobject);
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

{ END PUBLIC FUNCTIONS }
procedure Tfsavefm.tbt3Click(Sender: TObject);
begin
fsavefm.hide;
end;

procedure Tfsavefm.tbt1Click(Sender: TObject);
begin
restorefsavefile;
end;

procedure Tfsavefm.tbt2Click(Sender: TObject);
begin
deletefsavefile;
end;

function tfsavefm.deletefsavefile:boolean;
var
	bres:boolean;
  ts:string;
  id:string;
  fn:string;
begin
result:=true;
if (lv1.selected<>nil) and (lv2.selected<>nil) then
	begin
  id:=lv1.selected.subitems[0];
  fn:=lv2.selected.caption;
	ts:=makedpath(s.fsavepath)+makedpath(id)+(fn);
  { delete file permanently from fsave area}
  bres:=deletefile(pchar(ts));
  if bres=false then
    begin
    deleteatreboot(ts);
    end
  else
    begin
    showmessagenotsilent(ts+' has been deleted from the File Save area.');
    end;
	deletefnamefromreg(id,fn);
  if lv1.selected<>nil then
  	begin
	  updatelv2(lv1.selected);
    end;
  end
else
  begin
  showmessagenotsilent('Try selecting the Project, then the file before deleting.');
  end;
end;


procedure Tfsavefm.FormCreate(Sender: TObject);
begin                 
{ What if s is not created yet? }
assignhints;
end;

procedure Tfsavefm.assignhints;
begin
tbt3.hint:=hexit;
tbt1.hint:=hrestore;
tbt2.hint:=hdelete;
lv1.hint:=hlv1;
lv2.hint:=hlv2;
end;

procedure Tfsavefm.FormActivate(Sender: TObject);
begin
application.onhint:=showhint;
{ Show hints? }
p1.Visible:=s.showHints;
s1.Visible:=s.showHints;
{ load project id's }
updatelv1;
end;

procedure Tfsavefm.lv1Click(Sender: TObject);
begin
if lv1.selected<>nil then
  begin
  if updatelv2(lv1.selected)=false then
	  showmessagenotsilent('Error 132. Could not update screen.');
  end;
end;

procedure Tfsavefm.Exit1Click(Sender: TObject);
begin
fsavefm.hide;
end;

end.
