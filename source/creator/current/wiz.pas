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
    folds: TTabSheet;
    apps: TTabSheet;
    b1: TButton;
    b2: TButton;
    b3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    cb2: TComboBox;
    Label8: TLabel;
    e6: TEdit;
    Label9: TLabel;
    e7: TEdit;
    Label10: TLabel;
    e8: TEdit;
    Label11: TLabel;
    e9: TEdit;
    sb9: TSpeedButton;
    sb7: TSpeedButton;
    cb3: TCheckBox;
    cb4: TCheckBox;
    bb1: TBitBtn;
    bb2: TBitBtn;
    e4: TEdit;
    bb3: TBitBtn;
    bb4: TBitBtn;
    Label12: TLabel;
    e10: TEdit;
    lb1: TListBox;
    lb2: TListBox;
    m1: TMemo;
    Label24: TLabel;
    Label26: TLabel;
    m3: TMemo;
    Label27: TLabel;
    m4: TMemo;
    e1: TEdit;
    e2: TEdit;
    Label14: TLabel;
    e22: TEdit;
    bb6: TBitBtn;
    bb5: TBitBtn;
    deps: TTabSheet;
    Label15: TLabel;
    lv1: TListView;
    m5: TMemo;
    Label16: TLabel;
    lv2: TListView;
    Label17: TLabel;
    Label18: TLabel;
    e23: TEdit;
    cb5: TComboBox;
    Label23: TLabel;
    e24: TEdit;
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
    Label25: TLabel;
    e25: TEdit;
    Label28: TLabel;
    m6: TMemo;
    sb1: TSpeedButton;
    Label29: TLabel;
    cb6: TComboBox;
    Label30: TLabel;
    cb7: TComboBox;
    Label31: TLabel;
    e26: TEdit;
    Label32: TLabel;
    e27: TEdit;
    c1: TCheckBox;
    e5: TComboBox;
    sb2: TSpeedButton;
    Label33: TLabel;
    Label13: TLabel;
    e21: TEdit;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    SpeedButton1: TSpeedButton;
    Label37: TLabel;
    Label38: TLabel;
    Bevel1: TBevel;
    b4: TButton;
    tsExtra: TTabSheet;
    Label39: TLabel;
    m7: TMemo;
    Label40: TLabel;
    cbScheduling: TCheckBox;
    dtpDate: TDateTimePicker;
    dtpTime: TDateTimePicker;
    Label41: TLabel;
    Label42: TLabel;
    tsTargets: TTabSheet;
    Label43: TLabel;
    Label44: TLabel;
    m8: TMemo;
    lvAllTargets: TListView;
    Label45: TLabel;
    Label46: TLabel;
    lvTargets: TListView;
    pmTarg: TPopupMenu;
    Usethese1: TMenuItem;
    pnRemoveTargets: TPopupMenu;
    Removethesetargets1: TMenuItem;
    cbUsePatching: TCheckBox;
    Bevel2: TBevel;
    fdialog: TPBFolderDialog;
    cbUseRestore: TCheckBox;
    ediTargFold: TEdit;
    cbExcludeFile: TCheckBox;
    procedure pc1Change(Sender: TObject);
    procedure b2Click(Sender: TObject);
    procedure sb7Click(Sender: TObject);
    procedure sb9Click(Sender: TObject);
    procedure cb3Click(Sender: TObject);
    procedure cb4Click(Sender: TObject);
    procedure bb1Click(Sender: TObject);
    procedure bb2Click(Sender: TObject);
    procedure bb3Click(Sender: TObject);
    procedure rg1Click(Sender: TObject);
		procedure showhint1(sender:tobject);
		procedure showhint3(sender:tobject);
		procedure showhint4(sender:tobject);
		procedure showhint5(sender:tobject);
		procedure showhint6(sender:tobject);
		procedure showhint7(sender:tobject);
		procedure showhint8(sender:tobject);
    procedure bb4Click(Sender: TObject);
    procedure e8Change(Sender: TObject);
    procedure e22Enter(Sender: TObject);
    procedure bb6Click(Sender: TObject);
    procedure b1Click(Sender: TObject);
    procedure lv1DblClick(Sender: TObject);
    procedure lv2DblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure e25Change(Sender: TObject);
    procedure sb1Click(Sender: TObject);
    procedure cb2Change(Sender: TObject);
    procedure sb2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bb5Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure b4Click(Sender: TObject);
    procedure lvAllTargetsDblClick(Sender: TObject);
    procedure lvTargetsDblClick(Sender: TObject);
    procedure appsShow(Sender: TObject);
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
uses main, splash, filedlg;



{ load child folders }
function Twizfm.e5load(ptype:string;fldr:string): boolean;
var
  found: boolean;
	ap:tap;
  tempfold:tapfolder;
  cnt,cntm,c2,c2m:integer;
  tpath:string;
  tsl:tstringlist;
  ts,ts2:string;
  flb4:tfilelistbox;
  goon:boolean;
begin
result:=true;
e5.clear;
tsl:=tstringlist.create;
ap:=mainfm.loadselectedproj;
tempfold:=nil;
if ap<>nil then
	begin
  if ptype='l' then
  	begin
		tempfold:=ap.longpathtofold(fldr);
    tpath:=fldr;
    end
  else if ptype='s' then
    begin
    if mainfm.tv1.selected<>nil then
    	begin
	  	tempfold:=mainfm.tv1tofold(mainfm.tv1.selected);
      tpath:=mainfm.tv1tolongpath(mainfm.tv1.Selected);
      end
    else
    	begin
      if mainfm.tv1.topitem<>nil then
      	begin
	    	tempfold:=mainfm.tv1tofold(mainfm.tv1.topitem);
        tpath:=mainfm.tv1tolongpath(mainfm.tv1.topitem);
        end;
      end;
    end;
  if tempfold<>nil then
    begin
		{ load e5 with all folders physically under folder
    except for child folders }
    ts2:=ap.realsourcedir(tpath);
    goon:=true;
    try
    if (not directoryexists(ts2)) and (ts2<>'') then
      forcedirectories(ts2);
    except
      showmessage('Could not create directory '+ts2);
      goon:=false;
    end;
    if goon then
      begin
      flb4:=tfilelistbox.create(application);
      flb4.parent:=application.MainForm;
      flb4.directory:=ts2;
      flb4.filetype:=[ftdirectory];
      flb4.mask:='*.*';
      tsl.clear;

      c2m := flb4.Items.count-1;
      for c2 := 2 to c2m do    // Iterate
        begin
        tsl.add(removesbs(flb4.items[c2]));
        end;    // for
      c2m:=tsl.count-1 ;
      cntm:=tempfold.apfolds.count;
      for c2 := 0 to c2m do    // Iterate
        begin
        found:=false;
        cnt:=0;
        while (cnt<cntm) and (found=false) do    // Iterate
          begin
          ts:=tapfolder(tempfold.apfolds[cnt]).name;
          if ts=tsl[c2] then
            found:=true;
          inc(cnt);
          end;    // while
        if not found then
          e5.Items.Add(tsl[c2]);
        end;    // for
      flb4.free;
      end;
    end;
  end;
tsl.free;
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
cb6.clear;
cb7.Clear;
e5.clear;

{ load wizfm folder dropdowns }
loadfolds(ap);
e5load('s','');

{ load dependency screen }

{ Parents }
cntm:=ap.parentname.count-1;
lv2.items.Clear;
for cnt:=0 to cntm do
  begin
  templi:=lv2.Items.add;
  templi.caption:=ap.parentname[cnt];
  templi.SubItems.Add(ap.parentid[cnt]);
  end;

{ populate wizfm.lv1 }
lv1.Items.Clear;
cntm:=mainfm.appilist.count-1;
cm:=lv2.items.count-1;
for cnt:=0 to cntm do
	begin
  fnd:=false;
  for c:=0 to cm do
    begin
    if lv2.Items[c].subitems[0]=mainfm.appilist[cnt] then
      fnd:=true;
    end;
  if not fnd then
    begin
    templi:=lv1.Items.Add;
    templi.Caption:=mainfm.appnlist[cnt];
    templi.SubItems.Add(mainfm.appilist[cnt]);
    end;
  end;

{ Targets }
cntm:=ap.TargetDistID.count-1;
lvTargets.items.Clear;
for cnt:=0 to cntm do
  begin
  templi:=lvTargets.Items.add;
  templi.caption:=ap.TargetDistNAme[cnt];
  templi.SubItems.Add(ap.TargetDistID[cnt]);
  end;

{ populate wizfm.lvAllTargets }
lvAllTargets.Items.Clear;
cntm:=s.DistListIDs.count-1;
cm:=lvTargets.items.count-1;
for cnt:=0 to cntm do
	begin
  fnd:=false;
  for c:=0 to cm do
    begin
    if lvTargets.items[c].SubItems[0]=s.DistListIDs[cnt] then
      fnd:=true;
    end;
  if not fnd then
    begin
    templi:=lvAllTargets.Items.Add;
    templi.Caption:=s.DistListNames[cnt];
    templi.SubItems.Add(s.DistListIDs[cnt]);
    end;
  end;

{ root files }
cntm:=ap.rootfold.apfiles.count-1;
for cnt:=0 to cntm do
  begin
  { what if rootfold is crap ? }
  cb6.Items.add(tapfile(ap.rootfold.apfiles[cnt]).url);
  cb7.Items.add(tapfile(ap.rootfold.apfiles[cnt]).url);
  end;
cb6.text:=ap.runfile;
cb7.text:=ap.readmefile;

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
e2.text:='';
e24.text:='';
e10.text:='';
{ got the file, now load the values }
e1.text:=fl.name;
e2.text:=fl.url;
e24.text:=fl.md5;
tempfold:=mainfm.tv1tofold(mainfm.tv1.selected);
ts:=ap.foldtolongpath(tempfold);
//cb1.itemindex:=cb1.Items.IndexOf(ts);
ediTargFold.text:=ts;
cb5.text:='';
cbUsePatching.checked:=true;
cbExcludeFile.checked:=false;
cntm:=fl.reg.count-1;
lb1.clear;
for cnt:=0 to cntm do
  begin
  lb1.items.add(fl.reg.strings[cnt]);
  end;
cntm:=fl.scutloc.count-1;
lb2.clear;
for cnt:=0 to cntm do
  begin
  ts:=fl.scutname.strings[cnt]+';'+fl.scutloc.strings[cnt];
  lb2.items.add(ts);
  end;
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
  proj.deflocdir:=e7.text;
  proj.bucketdir:=e9.text;
  proj.baseurl:=e21.text;
  proj.id:=e22.text;
  proj.version:=e23.text;
  proj.vendwebsite:=e26.text;
  proj.vendemail:=e27.text;
  proj.runfile:=cb6.text;
  proj.readmefile:=cb7.text;

  { parent project names,id's}
  proj.parentname.clear;
  proj.parentid.clear;
  cntm:=lv2.items.count-1;
  for cnt:=0 to cntm do
    begin
    proj.parentname.add(lv2.items[cnt].caption);
    proj.parentid.add(lv2.items[cnt].subItems[0]);
    end;

  { project target names, id's }
  proj.TargetDistID.clear;
  proj.targetDistName.clear;
  cntm:=lvTargets.items.count-1;
  for cnt:=0 to cntm do
    begin
    proj.TargetDistNAme.add(lvTargets.items[cnt].caption);
    proj.TargetDistID.add(lvTargets.items[cnt].subItems[0]);
    end;

  if proj.apfolds.indexof(proj.rootfold)=-1 then
    proj.apfolds.add(proj.rootfold);


  { set proj server values }
  proj.server:=ediserver.text;
  proj.username:=e18.text;
  proj.password:=e19.text;
  proj.remdir:=ediDepDir.text;
  proj.ugdepth:=strtoint(e25.text);
  if cbUseRestore.checked then
    proj.useRestore:=1
  else
    proj.useRestore:=0;
    
  if c1.checked then
    proj.zipfiles:=1
  else
    proj.zipfiles:=0;
  proj.transtype:=rg1.ItemIndex;

  {  Scheduling values }
  if cbScheduling.checked then
    proj.scheduleupgrade:=1
  else
    proj.scheduleupgrade:=0;
  proj.upgradedate:=dtpdate.Date;
  proj.upgradetime:=dtptime.Time;
  end;
end;

{ write wizfm info back into fold }
function twizfm.writefold(ap:tap;var fold:tapfolder):boolean;
var
  tempfold,tfold2:tapfolder;
  tfind:integer;
begin
result:=true;
if mainfm.cbProject.text<>'' then
	begin
  if (ap.snametofold(e5.text)<>e5.text) then
    begin
    { don't get parent }
    if e5.text='Windows' then
      begin
      ap.apfolds.add(Ap.winfold);
      end
    else if e5.text='System' then
      begin
      ap.apfolds.add(ap.sysfold);
      end
    else
      begin
      showmessage('Error 6. Special directory name not accounted.');
      end;
    end
  else
    begin
    { find parent folder in curapp }
    tempfold:=ap.longpathtofold(cb2.text);
    if tempfold=nil then
      begin
      showmessage('Error 19. Parent Folder does not exist in Project Definition.')
      end
    else
      begin
      tfold2:=tapfolder.create(tempfold);
      tfind:=tempfold.apfolds.Add(tfold2);
      { add folder to curapp structure }
      tapfolder(tempfold.apfolds.items[tfind]).name:=e5.text;
      end;
    end;
  end;
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
    fl.URL:=e2.text;
    fl.md5:='';
    fl.usepatching:=cbUsePatching.checked;
    fl.exclude:=cbExcludeFile.checked;
    fl.reg.clear;
    for cnt:=0 to lb1.items.count-1 do
      fl.reg.add(lb1.Items[cnt]);
    fl.scutname.clear;
    fl.scutloc.clear;
    for cnt:=0 to lb2.items.count-1 do
      begin
      t2:=lb2.items[cnt];
      t3:=copy(t2,1,pos(';',t2)-1);
      delete(t2,1,pos(';',t2));
      fl.scutloc.add(t2);
      fl.scutname.add(t3);
      end;
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
  application.onhint:=showhint1;

  if e8.text='' then
    b2.enabled:=false
  else
    b2.enabled:=true;
  disableback;
  finish2next;
  end;
if pc1.activepage=folds then
  begin
  application.onhint:=showhint4;
  disableback;
  next2finish;
  end;
if pc1.activepage=files then
  begin
  application.onhint:=showhint3;
  disableback;
  next2finish;
  end;
if pc1.activepage=deps then
	begin
  application.onhint:=showhint5;
  enableback;
  next2finish;
  end;
if pc1.activepage=remdets then
	begin
  application.onhint:=showhint6;
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
  if pc1.activepage=folds then
  	begin
    if mainfm.lv1.Selected<>nil then
    	begin
      end;
    end;
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
        pc1.activepage:=tsExtra;
        application.onhint:=showhint7;
        enableback;
        end;
      end
    else
      begin
      if pc1.activepage=tsExtra then
        begin
        pc1.activepage:=deps;
        application.onhint:=showhint5;
        enableback;
        end
      else
        begin
        if pc1.activepage=deps then
          begin
          pc1.activepage:=tsTargets;
          application.onhint:=showhint8;
          next2finish;
          enableback;
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
            if e7.text='' then
              begin
              showmessage('Project must have a Default Target Directory');
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
                  res:=messagedlg('It is a good idea to print out this page and to keep the '+
                  'Project ID in your records. Do you want to do this now?',mtconfirmation,[mbyes,mbno],0);
                  if res=mrYes then
                    begin
                    bb6.click;
                    end;
                  end;
                end;
              pc1.activepage:=remdets;
              application.onhint:=showhint6;
              finish2next;
              enableback;
              enablenext;
              end;
            end;
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


procedure Twizfm.sb7Click(Sender: TObject);
begin
fdialog.labelcaptions.Clear;
fdialog.labelcaptions.add('Default=Select default destination directory for Project.');
fdialog.folder:=e7.text;
if fdialog.Execute then
  e7.text:=fdialog.folder;
end;

procedure Twizfm.sb9Click(Sender: TObject);
begin
fdialog.labelcaptions.Clear;
fdialog.labelcaptions.add('Default=Select root directory for this Project.');
fdialog.folder:=e9.text;
if fdialog.Execute then
  e9.text:=fdialog.folder;
end;

procedure Twizfm.cb3Click(Sender: TObject);
begin
if cb3.checked=true then
  begin
  cb4.checked:=false;
  label6.enabled:=false;
  e5.Text:='Windows';
  label7.enabled:=false;
  cb2.enabled:=false;
  end
else
  begin
  label6.enabled:=true;
  e5.Text:='';
  label7.enabled:=true;
  cb2.enabled:=true;
  end;
end;

procedure Twizfm.cb4Click(Sender: TObject);
begin
if cb4.checked=true then
  begin
  cb3.checked:=false;
  label6.enabled:=false;
  e5.Text:='System';
  label7.enabled:=false;
  cb2.enabled:=false;
  end
else
  begin
  label6.enabled:=true;
  e5.Text:='';
  label7.enabled:=true;
  cb2.enabled:=true;
  end;

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
procedure Twizfm.bb3Click(Sender: TObject);
var
  ts:string;
begin
if (e10.text<>'') then
	begin
  ts:=e10.text+';'+e4.text;
  lb2.items.Add(ts);
  end
else
	begin
  showmessage('Make sure your shortcut has a name.');
  end;
end;

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

procedure twizfm.showhint1(sender:tobject);
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
      //m1.lines.adD('');
      oldposn:=posn;
      end;
    end;
  end;
end;

procedure twizfm.showhint3(sender:tobject);
var
  ts:string;
  posn,oldposn:integer;
begin
m3.lines.clear;
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
      m3.lines.add(copy(ts,oldposn+1,posn-oldposn));
      //m3.lines.add('');
      oldposn:=posn;
      end;
    end;
  end;
end;

procedure twizfm.showhint4(sender:tobject);
var
  ts:string;
  posn,oldposn:integer;
begin
m4.lines.clear;
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
      m4.lines.add(copy(ts,oldposn+1,posn-oldposn));
      //m4.lines.add('');
      oldposn:=posn;
      end;
    end;
  end;
end;

procedure twizfm.showhint5(sender:tobject);
var
  ts:string;
  posn,oldposn:integer;
begin
m5.lines.clear;
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
      m5.lines.add(copy(ts,oldposn+1,posn-oldposn));
      //m5.lines.add('');
      oldposn:=posn;
      end;
    end;
  end;
end;

procedure twizfm.showhint6(sender:tobject);
var
  ts:string;
//  posn,oldposn:integer;
begin
m6.lines.clear;
ts:=application.hint;
//posn:=0;
//oldposn:=0;
m6.lines.add(ts);

//if ts<>'' then
//  begin
//  while posn<>length(ts) do
//    begin
//    inc(posn);
//    if (ts[posn]='.') or (posn=length(ts)) then
//      begin
//      m6.lines.add(copy(ts,oldposn+1,posn-oldposn));
//      //m5.lines.add('');
//      oldposn:=posn;
//      end;
//    end;
//  end;
end;


procedure Twizfm.bb4Click(Sender: TObject);
begin
{ delete shortcut }
if lb2.itemindex<>-1 then
	lb2.Items.Delete(lb2.itemindex)
else
  showmessage('Highlight Shortcut to delete first.');
end;

procedure Twizfm.e8Change(Sender: TObject);
begin
//checknext;
end;



procedure Twizfm.e22Enter(Sender: TObject);
var
	res:integer;
begin
res:=messagedlg('Are you SURE you want to change this value?'#10#10+
'IMPORTANT! If you change this ID, Target Computers will treat this Project as unique, even if it has the same name as another project.',mtwarning,[mbyes,mbno],0);
if res=mryes then
  e22.SetFocus
else
  p1.SetFocus;
end;

procedure Twizfm.bb6Click(Sender: TObject);
begin
{ offer to print out page? }
if messagedlg('Print project settings?',mtconfirmation,[mbyes,mbno],0)=mryes then
  Print;
end;

procedure Twizfm.b1Click(Sender: TObject);
begin
if b1.caption='<< &Back' then
  begin
  if pc1.activepage=remdets then
    begin
    pc1.activepage:=apps;
    application.onhint:=wizfm.showhint1;
    finish2next;
    disableback;
    end
	else if pc1.activepage=tsExtra then
  	begin
    pc1.activepage:=remdets;
    application.onhint:=wizfm.showhint6;
    finish2next;
    enableback;
    end
	else if pc1.activepage=deps then
  	begin
    pc1.activepage:=tsExtra;
    application.onhint:=wizfm.showhint7;
    finish2next;
    enableback;
    end
  else if pc1.activepage=tsTargets then
    begin
    pc1.activepage:=deps;
    application.onhint:=wizfm.showhint5;
    finish2next;
    enableback;
    end;
  { add error trapping here? }
  end
else
  begin
  showmessage('Error 57. Unrecognised caption on Back button.');
  end;
end;

procedure Twizfm.lv1DblClick(Sender: TObject);
var
  tli:tlistitem;
  cnt,cntm:integer;
  itemfound:boolean;
  curapp:tap;
begin
{ RC3 why is this needed? }
curapp:=mainfm.loadselectedproj;
{ move id to other column if not there already }
if lv1.selected<>nil then
	begin
  cntm:=lv2.Items.count-1;
  itemfound:=false;
  for cnt:=0 to cntm do
  	begin
    { double check }
		if 	(lv2.items[cnt].caption=lv1.selected.caption) and
        (lv2.items[cnt].subitems[0]=lv1.selected.subitems[0]) then
			begin
      itemfound:=true;
      end;
    end;
  if itemfound=false then
    begin
    if (lv1.selected.caption=curapp.nname) or (lv1.selected.subitems[0]=curapp.id) then
    	showmessage('You can''t make a Project it''s own parent.')
    else
      begin
      tli:=lv2.items.add;
      tli.caption:=lv1.selected.caption;
      tli.subitems.add(lv1.selected.subitems[0]);
      lv1.selected.Delete;
      end;
    end
  else
  	begin
		showmessage('Project is already a parent.');
    end;
  end;
end;

procedure Twizfm.lv2DblClick(Sender: TObject);
var
  tli:tlistitem;
begin
if lv2.Selected<>nil then
	begin
  tli:=lv1.items.Add;
  tli.caption:=lv2.selected.caption;
  tli.subitems.add(lv2.selected.subitems[0]);
	lv2.selected.Delete;
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

procedure Twizfm.e25Change(Sender: TObject);
var
	ti:integer;
begin
if e25.text<>'' then
	begin
  try
	  ti:=strtoint(e25.text);
  except
    showmessage('This value must be an integer greater than or equal to zero.');
    e25.text:='';
  end;
  end;
end;

procedure Twizfm.sb1Click(Sender: TObject);
var
	res:integer;
  ts:string;
  curapp:tap;
begin
curapp:=mainfm.loadselectedproj;
//ts:=curapp.realsourcedir(cb1.text);
ts:=ediTargFold.Text;
{ set directory to current directory }
if (directoryexists(ts)) and (ts<>'') then
	begin
  frmfiledlg.fdialog.InitialDir:=ts;
  end;
if frmfiledlg.fdialog.Execute then
	begin
  e1.text:=frmfiledlg.fdialog.FileName;
  res:=mryes;
//  res:=messagedlg('Do you want the Deployment Filename to be the same name as the Source File?',mtconfirmation,[mbyes,mbno],0);
	if res=mryes then
		e2.text:=extractfilename(e1.text);
  end
end;


function twizfm.showproj:boolean;
begin
//result:=false;
pc1.activepage:=apps;
caption:='Project Wizard';
pc1.activepage:=apps;
application.onhint:=showhint1;
if showmodal=mrok then
	result:=true
else
	result:=false;
end;

function twizfm.showfold:boolean;
begin
pc1.activepage:=folds;
caption:='Folder Wizard';
pc1.activepage:=folds;
application.onhint:=showhint4;
if showmodal=mrok then
	result:=true
else
	result:=false;
end;

function twizfm.showapfile:boolean;
begin
pc1.activepage:=files;
caption:='File Wizard';
pc1.activepage:=wizfm.files;
application.onhint:=showhint3;
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
e7.text:=proj.deflocdir;
e9.text:=proj.bucketdir;
e6.text:=proj.nname;
e21.text:=proj.baseurl;
e22.text:=proj.id;
e23.text:=proj.version;
e26.text:=proj.vendwebsite;
e27.text:=proj.vendemail;
cb6.text:=proj.runfile;
cb7.text:=proj.readmefile;
cb6.clear;
cb7.clear;
cntm:=proj.rootfold.apfiles.count-1;
for cnt:=0 to cntm do
  begin
  { what if rootfold is crap ? }
  cb6.Items.add(tapfile(proj.rootfold.apfiles[cnt]).url);
  cb7.Items.add(tapfile(proj.rootfold.apfiles[cnt]).url);
  end;
cb6.text:=proj.runfile;
cb7.text:=proj.readmefile;
{ set proj server values }
ediServer.text:=proj.server;
e18.text:=proj.username;
e19.text:=proj.password;
ediDepDir.text:=proj.remdir;
e25.text:=inttostr(proj.ugdepth);

if proj.zipfiles=1 then
  c1.checked:=true
else
  c1.checked:=false;
rg1.itemindex:=proj.transtype;
if proj.useRestore=1 then
  cbUseRestore.checked:=true
else
  cbuseRestore.checked:=false;
{ Set scheduling values }
if proj.scheduleupgrade=1 then
  cbScheduling.checked:=true
else
  cbScheduling.checked:=false;
dtpTime.Time:=proj.upgradetime;
if proj.upgradedate=0 then
  dtpDate.Date:=date
else
  dtpDate.Date:=proj.upgradedate;
end;

{ load folder values into wizfm. }
function twizfm.readfold(ap:tap;fold:tapfolder):boolean;
var
	ts:string;
begin
e5.text:='';
cb2.Clear;
{ load drop downs with project's folders }
loaddropdowns(ap);
if mainfm.tv1.selected<>nil then
  begin
  ts:=mainfm.tv1.selected.Text;
  cb2.ItemIndex:=cb2.Items.IndexOf(ts);
  end
else
	begin
  cb2.itemindex:=cb2.Items.IndexOf('Root');
  end;
result:=true;
end;


function twizfm.loadfolds(ap:tap):boolean;
var
  cnt,cntm:integer;
  sn:string;
begin
try
	{ this needs to be loaded with longpath names }
	result:=true;
//  cb1.clear;
  cb2.clear;
	{ clear folder list? if too slow, do check for item, then update }
	ap.apfolds.pack;
	cntm:=ap.apfolds.count-1;
	for cnt:=0 to cntm do
		begin
			sn:=ap.foldtosname(ap.foldtolongpath(ap.apfolds[cnt]));
      cb2.items.Add(sn);
//      cb1.items.add(sn);
			lfoldsrec(ap,ap.apfolds[cnt]);
			end;
finally
end;  // try/finally
end;

{ recursive display of folders }
function twizfm.lfoldsrec(ap:tap;curfold:tapfolder):boolean;
var
  cnt,cntm:integer;
  tempf:tapfolder;
  sn:string;
begin
result:=true;
cntm:=curfold.apfolds.count-1;
for cnt:=0 to cntm do
	begin
	{ add child }
  tempf:=curfold.apfolds[cnt];
  { this loads wizfm dropdown folder lists }
  sn:=ap.foldtosname(ap.foldtolongpath(tempf));
  cb2.items.Add(sn);
//  cb1.items.add(sn);
  if tempf.apfolds.count>0 then
  	lfoldsrec(ap,tempf);
  end;
end;

procedure Twizfm.cb2Change(Sender: TObject);
begin
e5load('l',cb2.text);
end;

procedure Twizfm.sb2Click(Sender: TObject);
begin
case cycle of    //
  1: 	begin
      e2.text:=lowercase(e2.text);
  		end;
  2:  begin
  		e2.text:=uppercase(e2.text);
  		end;
  end;    // case
inc(cycle);
if cycle=3 then
	cycle:=1;
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

procedure Twizfm.SpeedButton1Click(Sender: TObject);
var
  ap:tap;
begin
ap:=mainfm.loadselectedproj;
e10.text:=ap.nname;
ap.free;
end;

procedure Twizfm.FormHide(Sender: TObject);
begin
application.onhint:=mainfm.showhint;
end;

procedure twizfm.assignhints;
begin
{remdets}
rg1.hint:=httype;
ediServer.hint:=hserver0;
ediDepDir.hint:=hremdir0;
e18.hint:=husername;
e19.hint:=hpassword;
c1.hint:=hcompress;
e25.hint:=hugdepth;
e21.hint:=hbdp;
m1.hint:=hhint;
m3.hint:=hhint;
m4.hint:=hhint;
m5.hint:=hhint;
m6.hint:=hhint;

{files}
e1.hint:=hsource;
sb1.hint:=hsourcesb;
//cb1.hint:=htfolder;
ediTargFold.hint:=htfolder;
e2.hint:=hdepfile;
cb5.hint:=hregister;
lb1.hint:=hregister;
e10.hint:=hscutname;
e4.hint:=hscutdest;
lb2.hint:=hscuts;
speedbutton1.hint:=hprojnameadd;
bb3.hint:=hscutadd;
bb4.hint:=hscutdel;

{folds}
cb3.hint:=hwindir;
cb4.hint:=hsysdir;
cb2.hint:=hparent;
e5.hint:=hfoldsel;

{apps}
e22.hint:=hprojid;
e6.hint:=hprojname;
e9.hint:=hsourcedir;
sb9.hint:=hsdirsb;
e7.hint:=hdeftargdir;
sb7.hint:=hdefdirsb;
cb6.hint:=hmainfile;
cb7.hint:=hreadmefile;
bb6.hint:=hprint;
bb5.hint:=hclearstage;
e23.hint:=hversion;
e8.hint:=hprojfname;
e26.hint:=hprovweb;
e27.hint:=hprovemail;

{deps}
lv1.hint:=hallproj;
lv2.hint:=hdepproj;
end;

procedure Twizfm.b4Click(Sender: TObject);
begin
if cb7.text<>'' then
  begin
  if shellexecute(0,'open','notepad.exe',pchar(globalbuckdir+cb7.text),pchar(s.windir),SW_SHOWNORMAL)<=32 then
    showmessagE('Could not open '+cb7.text);
  end;
end;

procedure Twizfm.showhint7(sender: tobject);
var
  ts:string;
begin
m7.lines.clear;
ts:=application.hint;
m7.lines.add(ts);
end;

procedure Twizfm.showhint8(sender: tobject);
var
  ts:string;
begin
m8.lines.clear;
ts:=application.hint;
m8.lines.add(ts);
end;

procedure Twizfm.lvAllTargetsDblClick(Sender: TObject);
var
  tli:tlistitem;
  cnt,cntm:integer;
  itemfound:boolean;
  curapp:tap;
begin
{ RC3 why is this needed? }
curapp:=mainfm.loadselectedproj;
{ move id to other column if not there already }
if lvAllTargets.selcount<>0 then
	begin
  cntm:=lvAllTargets.Items.count-1;
  for cnt:=0 to cntm do
  	begin
    if lvAllTargets.items[cnt].Selected then
      begin
      tli:=lvTargets.Items.Add;
      tli.caption:=lvAllTargets.items[cnt].caption;
      tli.subitems.add(lvAllTargets.items[cnt].subitems[0]);
      end
    end;
  { Delete existing list items }
  for cnt:=cntm downto 0 do
    begin
    if lvAlltargets.items[cnt].selected then
      lvAlltargets.Items[cnt].Delete;
    end;
  end;
end;

procedure Twizfm.lvTargetsDblClick(Sender: TObject);
var
  c,cm:integer; // loop counters
  tli:tlistitem;
begin
if lvTargets.SelCount>0 then
  begin
  cm:=lvTargets.Items.count-1;
  for c:=cm downto 0 do
    begin
    if lvTargets.items[c].selected then
      begin
      tli:=lvAllTargets.items.Add;
      tli.caption:=lvTargets.items[c].caption;
      tli.subitems.add(lvTargets.items[c].subitems[0]);
    	lvTargets.Items.Delete(c);
      end;
    end;
  end;
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

{ Check for trailing slash in Default Target Directory }
if e7.text<>'' then
  begin
  if (pos('\',e7.text)>0) and (e7.text[length(e7.text)]<>'\') then
    e7.text:=e7.text+'\';
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
{ Show Hints? }
m1.Visible:=s.showhints;
m3.Visible:=s.showhints;
m4.Visible:=s.showhints;
m5.Visible:=s.showhints;
m6.Visible:=s.showhints;
m7.Visible:=s.showhints;
m8.Visible:=s.showhints;

label28.Visible:=s.showhints;
label40.Visible:=s.showhints;
label44.Visible:=s.showhints;
label26.Visible:=s.showhints;
label27.Visible:=s.showhints;
label24.Visible:=s.showhints;
label16.Visible:=s.showhints;
end;

procedure Twizfm.checknext;
begin
if 	(e8.text='') or
		(e6.text='') or
    (e9.text='') or
    (e7.text='')  then
	b2.enabled:=false
else
	b2.enabled:=true;
end;

procedure Twizfm.appsShow(Sender: TObject);
begin
checknext;
end;

end.
