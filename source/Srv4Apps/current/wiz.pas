unit wiz;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Buttons, FileCtrl,share,md5b, Menus,
  ap,apfile,apfolder,recapp,settings,shellapi, PBFolderDialog;
type
  Twizfm = class(TForm)
    p1: TPanel;
    pc1: TPageControl;
    files: TTabSheet;
    apps: TTabSheet;
    b1: TButton;
    b2: TButton;
    b3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    e6: TEdit;
    Label10: TLabel;
    e8: TEdit;
    Label11: TLabel;
    e9: TEdit;
    sb9: TSpeedButton;
    bb1: TBitBtn;
    bb2: TBitBtn;
    lb1: TListBox;
    e1: TEdit;
    cb5: TComboBox;
    remdets: TTabSheet;
    rg1: TRadioGroup;
    Label19: TLabel;
    Label20: TLabel;
    e18: TEdit;
    ediServer: TEdit;
    Label22: TLabel;
    Label21: TLabel;
    e19: TEdit;
    ediDepDir: TEdit;
    Label13: TLabel;
    e21: TEdit;
    Label34: TLabel;
    Label36: TLabel;
    Label38: TLabel;
    pmTarg: TPopupMenu;
    Usethese1: TMenuItem;
    pnRemoveTargets: TPopupMenu;
    Removethesetargets1: TMenuItem;
    cbUsePatching: TCheckBox;
    fdialog: TPBFolderDialog;
    cbUseRestore: TCheckBox;
    ediTargFold: TEdit;
    cbExcludeFile: TCheckBox;
    Label3: TLabel;
    e22: TEdit;
    butPrint: TButton;
    procedure pc1Change(Sender: TObject);
    procedure b2Click(Sender: TObject);
    procedure sb9Click(Sender: TObject);
    procedure cb4Click(Sender: TObject);
    procedure bb1Click(Sender: TObject);
    procedure bb2Click(Sender: TObject);
    procedure rg1Click(Sender: TObject);
    procedure b1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure bb5Click(Sender: TObject);
    procedure appsShow(Sender: TObject);
    procedure e22Enter(Sender: TObject);
    procedure butPrintClick(Sender: TObject);
  private
  	cycle:integer;
    showprintonce:boolean;
    { Private declarations }
    procedure assignhints;
    procedure SetHintBox;
    function e5load(ptype:string;fldr:string): boolean;
    function lfoldsrec(ap:tap;curfold:tapfolder):boolean;
    function loadfolds(ap:tap):boolean;
    function loaddropdowns(ap:tap): boolean;
    procedure next2finish;
    procedure finish2next;
//    procedure disablenext;
    procedure enablenext;
    procedure disableback;
    procedure enableback;
    procedure checkdirslashes;

    procedure checknext;
  public
    { Public declarations }
    edproj:boolean;
    function readproj(proj:tap):boolean;
    function readfold(ap:tap;fold:tapfolder):boolean;
    function readapfile(ap:tap;fl:tapfile):boolean;

    function writeproj(var proj:tap):boolean;
    function writefold(ap:tap;var fold:tapfolder):boolean;
    function writeapfile(var fl:tapfile):boolean;

    function showproj:boolean;
    function showfold:boolean;
    function showapfile:boolean;
  end;

const
{hints}
{remdets}
httype='|Select the method of transmitting the Project from the Staging Area to the Deployment Area.';
hserver1='|Not used for local/network deployment.';
hserver0='|The address of the FTP server that the the Project will be deployed to.'#13#10#13#10'e.g. ftp.myserver.com, or 102.102.102.102'#13#10#13#10'Do not put ftp:// in front of the server address';
hbdpbutt='|Breaks the Client Deployment Path into it''s components.';
hremdir0='|The directory on the remote server to deploy the Project.';
hremdir1='|The full local/network path to the directory in which the Project will be deployed.';
husername='|Username needed (if any) to log into the destination server to transmit files.';
hpassword='|The password needed (if any) to log into the Deployment Computer.';
hcompress='|Choose whether to compress the files in a Project before deploying them.';
hugdepth='|The number of versions of files that will have have patches created for them.';
hbdp='|This path will be used as the default location for Upgrade Suite Client to find a Project''s files.';
hhint='|Automatic hint box.';

{files}
hsource='|Name of file on Source Computer.';
hsourcesb='Browse for File|Click here to select a file to include in the Project.';
htfolder='|Select the Target folder for the file to be put in.';
hdepfile='|Unless you specify a full path for this file, the Client Deployment Path will be used on Project Compilation.';
hregister='|Register your DLL''s, run self-extracting executables, etc.';
hscutname='|Name of a Windows Shortcut.';
hscutdest='|Destination folder for the shortcut to appear under in the Start/Programs menu.';
hscuts='|More than one shortcut can be created for any single file.Shortcut format: "Name;Location"';
hscutadd='|Click to add a new shortcut to the shortcut list.';
hscutdel='|Delete selected shortcut from the list.';
hprojnameadd='|Insert Project name.';

{folds}
hwindir='|Files put into the Windows Folder in the Project Definition File will be inserted automatically into the correct Windows directory on the Target Computer.';
hsysdir='|Files put into the System Folder in the Project Definition File will be inserted automatically into the correct Windows System directory on the Target Computer.';
hparent='|The folder in which the above folder will be created.';
hfoldsel='|Enter, or select a folder to add to the Project.';

{apps}
hprojid='|IMPORTANT! If you change this ID, Target Computers will treat this Project as unique, even if it has the same name as another project.';
hprojname='|The name of the project appears in the list of Projects in the Project Toolbar.';
hsourcedir='|The main directory containing  Files and Folders defined in the Project Definition File.Files can be added to the Project from anywhere on your computer''s file system, however.';
hsdirsb='|Click here to select the Source Directory.';
hdeftargdir='|The default installation directory on Target Computers.';
hdefdirsb='|Click here to select the Default Target Directory for the Project.';
hmainfile='|A file in the Root folder that will be opened/executed when a user selects Run in the Upgrade Suite Client.';
hreadmefile='|A text file in the Root folder that will be opened when a user selects Readme in the Upgrade Suite Client.';
hprint='|Highly recommended if you create a new Project or change the Project ID.';
hclearstage='|Clear Staging Area for this Project.This will delete all patches, and force Target Computers to download new versions of files in full.Don''t forget to Reprepare the Project before Deploying it again.';
hversion='|Project version number will display in Upgrade Suite Client and allow users to know which version they can upgrade to.';
hprojfname='|This is the filename that the Project will be saved to. It cannot be changed once a Project is created.';
hprovweb='|Website for users of this Project.They will be able to jump to this website from inside Upgrade Suite Client.';
hprovemail='|Email address for users of this Project to contact.They will be able to email this address from inside Upgrade Suite Client.';

{deps}
hallproj='|All Projects created with Upgrade Suite Server that are on this computer.';
hdepproj='|Projects that need to be installed on users'' computers before this one can be.';



var
  wizfm: Twizfm;

implementation

{$R *.DFM}
uses main, splash;



{ load child folders }
function Twizfm.e5load(ptype:string;fldr:string): boolean;
begin
result:=true;
end;

{ load drop down lists }
function Twizfm.loaddropdowns(ap:tap): boolean;
var
	cnt,cntm:integer;
  c,cm:integer;
  fnd:boolean;
  templi:tlistitem;
begin
globalbuckdir:=makedpath(ap.bucketdir);
result:=true;
cb5.clear;

{ load wizfm folder dropdowns }
loadfolds(ap);
e5load('s','');

{ load dependency screen }






{ registration types }
cb5.items.add('Register DLL');
cb5.items.add('Execute');
end;

{ Private Functions }
procedure twizfm.next2finish;
begin
b2.caption:='&Finish';
b2.ModalResult:=mrOK;
end;

procedure twizfm.finish2next;
begin
b2.caption:='&Next >>';
b2.modalresult:=mrNone;
end;

procedure twizfm.enablenext;
begin
b2.Enabled:=true;
end;

procedure twizfm.disableback;
begin
b1.enabled:=false;
end;

procedure twizfm.enableback;
begin
b1.enabled:=true;
end;

{ loads file info into wizfm }
function twizfm.readapfile(ap:tap;fl:tapfile):boolean;
var
  ts:string;
  cnt,cntm:integer;
  tempfold:tapfolder;
begin
result:=true;
loaddropdowns(ap);
{ clear fields }
e1.text:='';
{ got the file, now load the values }
e1.text:=fl.name;
tempfold:=mainfm.tv1tofold(mainfm.tv1.selected);
ts:=ap.foldtolongpath(tempfold);
//cb1.itemindex:=cb1.Items.IndexOf(ts);
ediTargFold.text:=ts;
cb5.text:='';
cbUsePatching.checked:=fl.usepatching;
cbExcludeFile.checked:=fl.exclude;
cntm:=fl.reg.count-1;
lb1.clear;
for cnt:=0 to cntm do
  begin
  lb1.items.add(fl.reg.strings[cnt]);
  end;
cntm:=fl.scutloc.count-1;
end;


{ loads project info into wizfm }
function twizfm.writeproj(var proj:tap):boolean;
var
  fn:string;
  res:integer;
  tp:string;
  cnt,cntm:integer;
begin
result:=true;
if e8.text='' then
  begin
  showmessage('You must specify a Project Description File name.');
  end
else
  begin
  if (not directoryexists(e9.text)) and (e9.text<>'') then
    begin
    res:=messagedlg('Source Directory does not exist. Create?',mtconfirmation,[mbyes,mbno],0);
    if res=mryes then
      forcedirectories(e9.text);
    end;

  fn:=trim(e8.text);
  { get temp path (tp) at the same time }
  { check if name has extension }
  if pos(ugfileext,fn)=0 then
    begin
    tp:=fn;
    fn:=fn+ugfileext;
    end
  else
    begin
    tp:=copy(fn,1,length(fn)-4);
    end;
  { set curapp values then savetofile }
  proj.fname:=fn;
  //proj.ffname:=s.appath+fn;
  proj.nname:=e6.text;
  proj.deflocdir:='';
  proj.bucketdir:=e9.text;
  proj.baseurl:=e21.text;
  proj.id:=e22.text;
  //proj.version:=e23.text;
  //proj.vendwebsite:=e26.text;
  //proj.vendemail:=e27.text;
  //proj.runfile:=cb6.text;
  //proj.readmefile:=cb7.text;


  if proj.apfolds.indexof(proj.rootfold)=-1 then
    proj.apfolds.add(proj.rootfold);


  { set proj server values }
  proj.server:=ediserver.text;
  proj.username:=e18.text;
  proj.password:=e19.text;
  proj.remdir:=ediDepDir.text;
  { Hardcode to three }
  proj.ugdepth:=3;
  if cbUseRestore.checked then
    proj.useRestore:=1
  else
    proj.useRestore:=0;

  { Enforce file compression }
  proj.zipfiles:=1;
  proj.transtype:=rg1.ItemIndex;

  { Enforce no scheduling }
  proj.scheduleupgrade:=0;
  //proj.upgradedate:=dtpdate.Date;
  //proj.upgradetime:=dtptime.Time;
  end;
end;

{ write wizfm info back into fold }
function twizfm.writefold(ap:tap;var fold:tapfolder):boolean;
begin
end;

{ write file info back into fl }
function twizfm.writeapfile(var fl:tapfile):boolean;
var
  res: integer;
  cnt:integer;
  t2,t3:string;
  tempfold:tapfolder;
  dupe:boolean;
  oldname:string;
begin
result:=false;
if e1.text='' then
  begin
  showmessage('File name cannot be blank. File not added to Project.');
  end
else
  begin
  oldname:=fl.name;
  { check if file with same name already exists }
  dupe:=false;
  tempfold:=fl.parent;
  if tempfold<>nil then
    begin
    if tempfold.findfilenam(fl.name)<>-1 then
      begin
      dupe:=true;
      end;
    end;
  res:=mryes;
  if dupe and (oldname<>e1.text)then
    begin
    res:=messagedlg('Same file already exists in this folder. Continue?',mtconfirmation,[mbyes,mbno],0);
    end;
  if res=mryes then
    begin
    fl.name:=e1.text;
    //fl.URL:=e2.text;
    fl.md5:='';
    fl.usepatching:=cbUsePatching.checked;
    fl.exclude:=cbExcludeFile.checked;
    fl.reg.clear;
    for cnt:=0 to lb1.items.count-1 do
      fl.reg.add(lb1.Items[cnt]);
    result:=true;
    end;
  end;
end;


{ Event handlers }
procedure Twizfm.pc1Change(Sender: TObject);
begin
{ Set focus to active page }
pc1.activepage.SetFocus;
setHintBox;
if pc1.activepage=apps then
  begin
  if e8.text='' then
    b2.enabled:=false
  else
    b2.enabled:=true;
  disableback;
  finish2next;
  end;
if pc1.activepage=files then
  begin
  disableback;
  next2finish;
  end;
if pc1.activepage=remdets then
	begin
  enableback;
  finish2next;
  end;
end;

{ Next button click }
procedure Twizfm.b2Click(Sender: TObject);
var
	res:integer;
  goon:boolean;
begin
if b2.caption='&Finish' then
  begin
  if pc1.activepage=files then
    begin
    end;
  { add error trapping here? }
  end
else
  begin
  if b2.caption='&Next >>' then
    begin
    if pc1.activepage=remdets then
    	begin
      goon:=true;
      if edidepdir.text='' then
        begin
        showmessage('Project must have a Deployment Directory');
        goon:=false;
        end;
      if e21.text='' then
        begin
        showmessage('Project must have a Client Deployment Path');
        goon:=false;
        end;
      if goon then
        begin
        checkdirslashes;
        enableback;
        end;
      end
    else
      begin
      if pc1.activepage=apps then
        begin
        { Check if Project has Source Directory and Default Target Directory }
        goon:=true;
        if e9.text='' then
          begin
          showmessage('Project must have a Source Directory');
          goon:=false;
          end;
        if goon then
          begin
          checkdirslashes;
          if edproj=false then
            begin
            if showprintonce then
              begin
              showprintonce:=true;
              end;
            end;
          pc1.activepage:=remdets;
          finish2next;
          enableback;
          enablenext;
          end;
        end;
      end;
    end
  else
    begin
    showmessage('Error 20. Unrecognised caption on Next button');
    end;
  end;
end;


procedure Twizfm.sb9Click(Sender: TObject);
begin
fdialog.labelcaptions.Clear;
fdialog.labelcaptions.add('Default=Select root directory for this Project.');
fdialog.folder:=e9.text;
if fdialog.Execute then
  e9.text:=fdialog.folder;
end;

procedure Twizfm.cb4Click(Sender: TObject);
begin
end;

{ add new register instruction to file }
procedure Twizfm.bb1Click(Sender: TObject);
begin
lb1.items.Add(cb5.texT);
end;

{ delete register instruction from file }
procedure Twizfm.bb2Click(Sender: TObject);
begin
if lb1.itemindex<>-1 then
  lb1.Items.Delete(lb1.itemindex);
end;

{ Add new shortcut destination to file }
procedure Twizfm.rg1Click(Sender: TObject);
begin
if rg1.itemindex=0 then
  begin
  label19.enabled:=true;
  ediServer.enabled:=true;
  e18.enabled:=true;
  e19.enabled:=true;
  label20.enabled:=true;
  label21.enabled:=true;
  ediServer.hint:=hserver0;
  ediDepDir.hint:=hremdir0;
  //cbUseRestore.enabled:=true;
  //sb3.enabled:=false;
  end
else
  begin
  label19.enabled:=false;
  ediServer.enabled:=false;
  label20.enabled:=false;
  label21.enabled:=false;
  e18.enabled:=false;
  e19.enabled:=false;
  ediServer.hint:=hserver1;
  ediDepDir.hint:=hremdir1;
  //cbUseRestore.enabled:=false;
  //sb3.enabled:=true;
  end;
end;



procedure Twizfm.b1Click(Sender: TObject);
begin
if b1.caption='<< &Back' then
  begin
  if pc1.activepage=remdets then
    begin
    pc1.activepage:=apps;
    finish2next;
    disableback;
    end
  { add error trapping here? }
  end
else
  begin
  showmessage('Error 57. Unrecognised caption on Back button.');
  end;
end;

procedure Twizfm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
	begin
  { click cancel }
  ModalResult:=mrCancel;
  hide;
  end;
end;

function twizfm.showproj:boolean;
begin
//result:=false;
pc1.activepage:=apps;
caption:='Project Wizard';
pc1.activepage:=apps;
if showmodal=mrok then
	result:=true
else
	result:=false;
end;

function twizfm.showfold:boolean;
begin
end;

function twizfm.showapfile:boolean;
begin
pc1.activepage:=files;
caption:='File Wizard';
pc1.activepage:=wizfm.files;
if showmodal=mrok then
	result:=true
else
	result:=false;
end;

{ load project values into the wizfm.}
function twizfm.readproj(proj:tap):boolean;
var
  cnt,cntm:integer;
  templi:tlistitem;
begin
result:=true;
loaddropdowns(proj);
e8.text:=proj.fname;
//e7.text:=proj.deflocdir;
e9.text:=proj.bucketdir;
e6.text:=proj.nname;
e21.text:=proj.baseurl;
e22.text:=proj.id;
//e23.text:=proj.version;
//e26.text:=proj.vendwebsite;
//e27.text:=proj.vendemail;
{ set proj server values }
ediServer.text:=proj.server;
e18.text:=proj.username;
e19.text:=proj.password;
ediDepDir.text:=proj.remdir;
//e25.text:=inttostr(proj.ugdepth);
rg1.itemindex:=proj.transtype;
if proj.useRestore=1 then
  cbUseRestore.checked:=true
else
  cbuseRestore.checked:=false;
end;

{ load folder values into wizfm. }
function twizfm.readfold(ap:tap;fold:tapfolder):boolean;
var
	ts:string;
begin
end;


function twizfm.loadfolds(ap:tap):boolean;
begin
end;

{ recursive display of folders }
function twizfm.lfoldsrec(ap:tap;curfold:tapfolder):boolean;
begin
end;

procedure Twizfm.FormCreate(Sender: TObject);
begin
cycle:=1;
assignhints;
showprintonce:=false;
end;

procedure Twizfm.bb5Click(Sender: TObject);
var
	ap:tap;
begin
ap:=mainfm.loadselectedproj;
ap.clearstagingarea(s.stagepath,'This will remove existing patches for your Project.',false);
ap.free;
end;

procedure twizfm.assignhints;
begin
{remdets}
rg1.hint:=httype;
ediServer.hint:=hserver0;
ediDepDir.hint:=hremdir0;
e18.hint:=husername;
e19.hint:=hpassword;
//c1.hint:=hcompress;
//e25.hint:=hugdepth;
e21.hint:=hbdp;
//m1.hint:=hhint;
//m3.hint:=hhint;
//m4.hint:=hhint;
//m5.hint:=hhint;
//m6.hint:=hhint;

{files}
e1.hint:=hsource;
//sb1.hint:=hsourcesb;
//cb1.hint:=htfolder;
ediTargFold.hint:=htfolder;
//e2.hint:=hdepfile;
cb5.hint:=hregister;
lb1.hint:=hregister;
//e10.hint:=hscutname;
//e4.hint:=hscutdest;
//lb2.hint:=hscuts;
//speedbutton1.hint:=hprojnameadd;
//bb3.hint:=hscutadd;
//bb4.hint:=hscutdel;

{folds}
//cb3.hint:=hwindir;
//cb4.hint:=hsysdir;
//cb2.hint:=hparent;
//e5.hint:=hfoldsel;

{apps}
e22.hint:=hprojid;
e6.hint:=hprojname;
e9.hint:=hsourcedir;
sb9.hint:=hsdirsb;
//e7.hint:=hdeftargdir;
//sb7.hint:=hdefdirsb;
//cb6.hint:=hmainfile;
//cb7.hint:=hreadmefile;
//bb6.hint:=hprint;
//bb5.hint:=hclearstage;
//e23.hint:=hversion;
e8.hint:=hprojfname;
//e26.hint:=hprovweb;
//e27.hint:=hprovemail;

{deps}
//lv1.hint:=hallproj;
//lv2.hint:=hdepproj;
end;


procedure Twizfm.checkdirslashes;
begin
{ Check for trailing slash in Client deployment path}
if e21.text<>'' then
  begin
  if (pos('/',e21.text)>0) and (e21.text[length(e21.text)]<>'/') then
    e21.text:=e21.text+'/'
  else
    if (pos('\',e21.text)>0) and (e21.text[length(e21.text)]<>'\') then
      e21.text:=e21.text+'\';
  end;

{ Check for trailing slash in Source Directory }
if e9.text<>'' then
  begin
  if (pos('\',e9.text)>0) and (e9.text[length(e9.text)]<>'\') then
    e9.text:=e9.text+'\';
  end;


{ Check for trailing slash in remote directory }
if ediDepDir.text<>'' then
  begin
  if (rg1.itemindex=0) and (ediDepDir.text[length(ediDepDir.text)]<>'/') then
    ediDepDir.text:=ediDepDir.text+'/'
  else
    if (rg1.itemindex=1) and (ediDepDir.text[length(ediDepDir.text)]<>'\') then
      ediDepDir.text:=ediDepDir.text+'\';
  end;
end;

procedure Twizfm.SetHintBox;
begin
end;

procedure Twizfm.checknext;
begin
if 	(e8.text='') or
		(e6.text='') or
    (e9.text='')  then
	b2.enabled:=false
else
	b2.enabled:=true;
end;

procedure Twizfm.appsShow(Sender: TObject);
begin
checknext;
end;

procedure Twizfm.e22Enter(Sender: TObject);
var
	res:integer;
begin
res:=messagedlg('Are you SURE you want to change this value?',mtwarning,[mbyes,mbno],0);
if res=mryes then
  e22.SetFocus
else
  p1.SetFocus;
end;

procedure Twizfm.butPrintClick(Sender: TObject);
begin
print;
end;

end.
