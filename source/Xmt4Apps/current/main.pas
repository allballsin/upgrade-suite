unit main;

interface

uses

  windows,  ShellLnk,
  pmupgrade, ImgList, Controls,
  Menus, StdCtrls, FileCtrl, ComCtrls,
  Classes, ToolWin,ap,forms,
  dialogs,sysutils, Psock, NMHttp, NMFtp,  ZLIBArchive, 
  TBNArea, DialUp, ExtCtrls, appexec, MMJRasConnect;

type
  Tmainfm = class(TForm)
    mm1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    SmallImages: TImageList;
    flb1: TFileListBox;
    http1: TNMHTTP;
    ftp1: TNMFTP;
    za: TZLBArchive;
    TBNArea1: TTBNArea;
    pmTaskbar: TPopupMenu;
    ShowTransmitter1: TMenuItem;
    HideTransmitter1: TMenuItem;
    N1: TMenuItem;
    Exit2: TMenuItem;
    timListFail: TTimer;
    N2: TMenuItem;
    EmergencyExit1: TMenuItem;
    pm1: Tpatchmaker;
    timICtimeout: TTimer;
    Timer1: TTimer;
    AppExec1: TAppExec;
    ras: TMMJRasConnect;
    Label1: TLabel;
    Label2: TLabel;
    ViewLog1: TMenuItem;
    Label3: TLabel;
    procedure Exit1Click(Sender: TObject);
    procedure Formcreate(Sender: TObject);

		{ from mainfm  }


    procedure tbt3Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure tbt2Click(Sender: TObject);
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
    procedure ftp1Status(Sender: TComponent; Status: String);
    procedure ftp1Success(Trans_Type: TCmdType);
    procedure ftp1TransactionStart(Sender: TObject);
    procedure ftp1UnSupportedFunction(Trans_Type: TCmdType);
    procedure ftp1TransactionStop(Sender: TObject);
    procedure TBNArea1DblClick(Sender: TObject);

    procedure hidetask(sender:tobject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ShowTransmitter1Click(Sender: TObject);
    procedure HideTransmitter1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure timListFailTimer(Sender: TObject);
    procedure EmergencyExit1Click(Sender: TObject);
    procedure timICtimeoutTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure UpgradeTransmitterHelp1Click(Sender: TObject);
  private
    deployall: boolean;
    { Private declarations }

    { These settings are action flags for the running of the program }


		curapp:tap;
    deploylist:tstringlist;
    function specialfile(fn:string): boolean;
    procedure showdeploylist(title:string);
	  function pulldownpdf(curpath:string):boolean;
	  function transmitpdf(curpath:string):boolean;
    function pulldownnow(fname:string):boolean;
    function pulldownrec(curpath:string):boolean;
    function transmitnow(fname:string):boolean;
    function transmitrec(curpath:string):boolean;
    procedure determineaction;
    procedure executeaction;
    procedure loadParams;
    procedure deleteStatusFile;
    procedure createStatusFile;
    procedure showmessagenosilent(msg:string);
  public
    { Public declarations }
    { Paramaters }
    silentMode:boolean;
    projectFileName:string;
    stagingArea:string;
    forceAllFiles:boolean;
    pulldownFlag:boolean;
    testHack:string;
    closeOnFinish:boolean;
    noFileCopy:boolean;

  end;


var
  startup:boolean;
  mainfm: Tmainfm;

implementation

uses  ShellAPI, settings, view, fwall,share;


{$R *.DFM}

{ PRIVATE FUNCTIONS }


{ pass in full path name of application file }
function tmainfm.transmitnow(fname:string):boolean;
var
  ts:string;  // temporary strings
  res:integer;
  finalname:string;
  goon:boolean;
begin
goon:=true;
label1.caption:='Deploying Project';
application.processmessages;
viewfm.m1.lines.adD('');
viewfm.m1.lines.add(uppercase('Deploying Project '+fname+' ['+datetimetostr(now)+']'));
viewfm.m1.lines.adD('');
result:=true;
deployall:=forceAllFiles;
{if forceAllFiles<>'forceall' then
  begin
  res:=messagedlg('Deploy new files only?'#13#10#13#10'( No = Deploy All Files )',mtconfirmation,[mbyes,mbno],0);
  if res=mryes then
    deployall:=false;
  end;}
Screen.Cursor := crHourGlass;
curapp:=tap.create;
{ get directory from staging area that files will be in }
curapp.loadfromfile(fname);
curapp.loadserfromfile(fname+'.ser');
finalname:=curapp.fname;
if pos('.tst',finalname)<>0 then
  begin
  { Hack to use project being tested as stagepath }
  //finalname:=testhack;
  delete(finalname,length(finalname)-3,4);
  end;
deploylist:=tstringlist.create;
if fileexists(fname+'.dep') then
  begin
  deploylist.LoadFromFile(fname+'.dep');
  showdeploylist('Deployment List before transmission');
  end
else
  begin
  try
    deploylist.savetofile(fname+'.dep');
    deploylist.loadfromfile(fname+'.dep');
    showdeploylist('Deployment List before transmission');
  except
    showmessage('Directory does not exist:'#10#10+
    extractfilepath(fname));
    goon:=false;
  end;
  end;
if goon then
  begin
  { send it into the recursive upload routine }
  if not noFileCopy then
    begin
    case curapp.transtype of
        0:begin
        { if FTP transfer }
        { first log in }
        if ftpconnect(ftp1,curapp.server,21,curapp.username,curapp.password) then
          begin
          goon:=buildpath(ftp1,curapp.remdir,true)
          end
        else
          begin
          goon:=false;
            showmessagenosilent('Critical Error. Could not log on to '+curapp.server+' as '+curapp.username);
          end;
        end;
      end;
    end;
  end;
if goon then
  begin
  if not directoryexists(stagingArea) then
    forcedirectories(stagingarea);
  { ts is staging area directory }
  //mainfm.zm1.Load_Zip_Dll;
  //viewfm.m1.lines.clear;
  if testHack='nohack' then
    ts:=makedpath(stagingArea)+makedpath(remfortrail(finalname))
  else
    ts:=makedpath(stagingArea)+makedpath(testHack);
  transmitrec(ts);
  {Hack}
  //ts:=makedpath(stagingArea)+makedpath(remfortrail(finalname));
  //transmitrec(ts);
  //mainfm.zm1.Unload_Zip_Dll;
  ftpdisconnect(ftp1);
  showdeploylist('Deployment List after transmission');
  deploylist.savetofile(fname+'.dep');
  deploylist.free;
  end
else
  begin
  showmessagenosilent('FTP error. Transmission unsuccessful.');
  end;
Screen.Cursor := crDefault;
label1.caption:='Deployment Finished';
viewfm.m1.lines.adD('');
viewfm.m1.lines.adD('Deployment Finished ['+datetimetostr(now)+']');
viewfm.m1.lines.adD('');
application.restore;
application.bringtofront;
if goon then
  createupdatefile('');
curapp.free;
end;

{ recursively transmit Project file structure
	FROM Staging Area TO Deployment Area
  curpath=current staging area directory

  if curapp.zipfiles=1 then zip away }
function tmainfm.transmitrec(curpath:string):boolean;
var
  cnt,cntm:integer;
  shortfn:string;
  flist:tstringlist;
  dlist:tstringlist;
  source,deploypath:string; // sourcebase and current deployment path directories
  ts,ts2:string ; // temporary string
  finalname:string;
  goon:boolean;
  upone:boolean;
  updpth:integer;
  c:integer;
  posn:integer;
begin
result:=false;
{maybe below will introduce problems }
flist:=tstringlist.create;
dlist:=tstringlist.create;
if pos('dsold',curpath)=0 then
  begin
  if not directoryexists(curpath) then
    begin
    showmessagenosilent(curpath+' does not exist.'#13#10#13#10+
    'Project probably has not been Prepared. Deployment cancelled.');
    end
  else
    begin
    result:=true;
    finalname:=curapp.fname;
    if pos('.tst',finalname)<>0 then
      delete(finalname,length(finalname)-3,4);
    source:=makedpath(stagingArea)+makedpath(remfortrail(finalname));
    ts:=copy(curpath,length(source)+1,length(curpath));
    case curapp.transtype of
      0:begin // FTP upload
        deploypath:=makewpath(curapp.remdir)+makewpath(remfortrail(ts));
        upone:=true;
        if remfortrail(ts)='' then
          upone:=false
        else
          updpth:=dirdepth(ts);
        { create remote directory }
        if nofilecopy then
          result:=true
        else
          result:=buildpath(ftp1,ts,true);
        if result then
          begin
          if not nofilecopy then
            begin
            { delete all files in remote directory }
            if deployall then
              begin
              ftplistfiles(ftp1,flist);
              cntm:=flist.Count-1;
              for cnt:=0 to cntm do
                begin
                ftpdelfile(ftp1,flist[cnt]);
                end;
              end;
            end;

          { upload all files }
          flb1.mask:='*.*';
          flb1.filetype:=[ftNormal,ftReadOnly,ftArchive];
          flb1.directory:=curpath;
          cntm:=flb1.items.count-1;
          for cnt:=0 to cntm do
            begin
            if nofilecopy then
              begin
              posn:=deploylist.indexof(curpath+flb1.items[cnt]);
              if posn<>-1 then
                deploylist.delete(posn);
              end
            else
              begin
              if (deploylist.IndexOf(curpath+flb1.items[cnt])>-1) or (deployall=true) or
              (specialfile(flb1.items[cnt])) then
                begin
                { this ensures .upg files are always deployed }
                ts:=curpath+flb1.items[cnt];
                { zip file if necessary }
                if (curapp.zipfiles=1) then
                  begin
                  za.CompressionLevel:=fcDefault;
                  end
                else
                  begin
                  za.CompressionLevel:=fcNone;
                  end;
                if specialfile(flb1.items[cnt]) then
                  begin
                  za.CompressionLevel:=fcDefault;
                  end;
                ts2:=ts+'.dzp';
                deletefile(ts2);
                za.CreateArchive(ts2);
                za.AddFile(ts);
                za.CloseArchive;
                if isfilezipped(ts2) then
                  begin
                  viewfm.m1.lines.Add('  Uploading '+extractfilename(ts2)+' --> '+deploypath+flb1.items[cnt]);
                  if ftpupload(ftp1,ts2,flb1.items[cnt])=drSuccess then
                    begin
                    posn:=deploylist.indexof(ts);
                    if posn<>-1 then
                      deploylist.delete(posn);
                    end;
                  end
                else
                  begin
                  viewfm.m1.lines.Add('  Uploading '+extractfilename(ts)+' --> '+deploypath+flb1.items[cnt]);
                  if ftpupload(ftp1,ts,flb1.items[cnt])=drSuccess then
                    begin
                    posn:=deploylist.indexof(ts);
                    if posn<>-1 then
                      deploylist.delete(posn);
                    end;
                  end;
                if deletefile(ts2) then
                  viewfm.m1.lines.Add('  '+shortfn+'(z)'+' deleted')
                else
                  viewfm.m1.lines.add('  '+shortfn+' (z)'+' not deletable');
                end;
              end;
            end;
          end
        else
          begin
          showmessagenosilent('Could not create/change to directory: '+ts+#13#10#13#10'Transmission unsuccessful.');
          end;
        end;
      1:begin  // upload into local or network directories
        { from curpath --> deploypath }
        { directory creation }
        deploypath:=makedpath(curapp.remdir)+makedpath(ts);
        if deploypath[length(deploypath)]='\' then
          delete(deploypath,length(deploypath),1);
        if not nofilecopy then
          begin
          if not directoryexists(deploypath) then
            begin
            try
              forcedirectories(deploypath);
              except
              end;
            end;
          end;
        //chdir(deploypath);
        //curpath:=makedpath(curpath); curpath is like this already

        { delete all files in remote directory }
        if nofilecopy then
          begin
          if deployall then
            begin
            flb1.mask:='*.*';
            flb1.filetype:=[ftNormal,ftReadOnly,ftArchive];
            if not directoryexists(deploypath) then
              begin
              showmessagenosilent(deploypath+' does not exist. This is a fatal Deployment Error.');
              result:=false;
              end
            else
              begin
              flb1.directory:=deploypath;
              deploypath:=makedpath(deploypath);
              flist.clear;
              flist.AddStrings(flb1.items);
              cntm:=flist.count-1;
              for cnt:=cntm downto 0 do
                begin
                deletefile(makedpath(deploypath)+flist[cnt]);
                end;
              end;
            end;
          end;
        { "upload" all files }
        flb1.mask:='*.*';
        flb1.filetype:=[ftNormal,ftReadOnly,ftArchive];
        flb1.directory:=curpath;
        flist.clear;
        flist.addstrings(flb1.items);
        viewfm.m1.lines.add('');
        viewfm.m1.lines.add('  Staging Area Directory: '+curpath);
        viewfm.m1.lines.add('  Deployment Area Directory: '+deploypath);
        viewfm.m1.lines.add('');
        cntm:=flist.count-1;
        for cnt:=0 to cntm do
          begin
          ts:=curpath+flist[cnt];
          if nofilecopy then
            begin
            posn:=deploylist.indexof(ts);
            if posn<>-1 then
              deploylist.delete(posn);
            end
          else
            begin
            if (deploylist.indexof(ts)>-1) or (deployall=true) or
              (specialfile(flb1.Items[cnt])) then
              begin
              { zip file if necessary }
              if curapp.zipfiles=1 then
                begin
                za.CompressionLevel:=fcDefault;
                end
              else
                begin
                za.CompressionLevel:=fcNone;
                end;
              { this ensures .upg files are always deployed and compressed fully }
              if specialfile(flb1.Items[cnt]) then
                begin
                za.CompressionLevel:=fcDefault;
                end;
              shortfn:=extractfilename(ts);
              ts2:=ts+'.dzp';
              deletefile(ts2);
              za.CreateArchive(ts2);
              za.AddFile(ts);
              za.CloseArchive;
              if fileexists(ts2) then
                begin
                viewfm.m1.lines.Add('  '+shortfn+': Staging Area --> Staging Area(zipped)');
                end
              else
                begin
                viewfm.m1.lines.Add('  '+shortfn+': Staging Area -x- Staging Area(zipped)');
                end;
              { Check if file zipped }
              if isfilezipped(ts2) then
                begin
                if copyfile(pchar(ts2),pchar(makedpath(deploypath)+flist[cnt]),false)=true then
                  begin
                  viewfm.m1.lines.Add('  '+shortfn+'(z): Staging Area --> Deployment Area');
                  posn:=deploylist.indexof(ts);
                  if posn<>-1 then
                    deploylist.delete(posn);
                  end
                else
                  begin
                  viewfm.m1.lines.Add('  '+shortfn+'(z)'+': Staging Area -x- Deployment Area');
                  end;
                end
              else
                begin
                if copyfile(pchar(ts),pchar(makedpath(deploypath)+flist[cnt]),false)=true then
                  begin
                  viewfm.m1.lines.Add('  '+shortfn+': Staging Area --> Deployment Area');
                  posn:=deploylist.indexof(ts);
                  if posn<>-1 then
                    deploylist.delete(posn);
                  end
                else
                  begin
                  viewfm.m1.lines.Add('  '+shortfn+': Staging Area -x- Deployment Area');
                  end;
                end;
              if deletefile(ts2) then
                viewfm.m1.lines.Add('  '+shortfn+'(z)'+' deleted')
              else
                viewfm.m1.lines.add('  '+shortfn+' (z)'+' not deletable');
              end;
            end;
          end;
        end;
      else
        showmessagenosilent('Error 1. Transfer type not known.');
      end;

    if result then
      begin
      { recurse through directory structure }
      flb1.mask:='*.*';
      flb1.FileType:=[ftDirectory];
      flist.clear;
      flist.addstrings(flb1.items);
      cntm:=flist.Count-1;
      for cnt:=2 to cntm do
        begin
        if result=true then
          result:=transmitrec(makedpath(curpath)+makedpath(removesbs(flist[cnt])));
        end;
      if (curapp.transtype=0) and (upone) and (not nofileCopy) then
        begin
        for c:=1 to updpth do
          changeto(ftp1,'..',false);
        end;
      end;
    end;
  end
else
  result:=true;
flist.free;
dlist.free;
end;

function tmainfm.transmitpdf(curpath:string):boolean;
var
  cnt,cntm:integer;
  flist:tstringlist;
  source,deploypath:string; // sourcebase and current deployment path directories
  ts,ts2:string ; // temporary string
begin
result:=true;
source:=makedpath(stagingArea)+makedpath(remfortrail(curapp.fname));
flist:=tstringlist.create;
case curapp.transtype of
  0:begin // FTP upload
		deploypath:=makewpath(curapp.remdir);
    { create remote directory }
    result:=buildpath(ftp1,deploypath,true);
    if result then
      begin
      if ftpfileexists(ftp1,curapp.fname) then
        ftpdelfile(ftp1,curapp.fname);
      viewfm.m1.lines.Add('  Uploading '+ts+' --> '+deploypath+curapp.fname);
      ftpupload(ftp1,curapp.ffname,flb1.items[cnt]);
      end
    else
      begin
      showmessagenosilent('Could not create/change to directory: '+deploypath+#13#10#13#10'Transmission of Project Definition File unsuccessful.');
      end;

    end;
  1:begin  // upload into local or network directories
  	{ from curpath --> deploypath }
		deploypath:=makedpath(curapp.remdir);
    { directory creation }
    if not directoryexists(deploypath) then
    	begin
      try
      	forcedirectories(deploypath);
     	except
      end;
      end;
    deletefile(deploypath+curapp.fname);
    if copyfile(pchar(source+curapp.fname),pchar(deploypath+curapp.fname),false)=true then
      viewfm.m1.lines.Add('  '+curapp.fname+': Staging Area --> Deployment Area')
    else
      viewfm.m1.lines.Add('  '+curapp.fname+': Staging Area -x- Deployment Area');
    end;
  else
    showmessagenosilent('Error 1. Transfer type not known.');
  end;
end;

{ remove from current directory }
function tmainfm.pulldownpdf(curpath:string):boolean;
var
  cnt,cntm:integer;
  source,deploypath:string; // sourcebase and current deployment path directories
  ts,ts2:string ; // temporary string
begin
result:=true;
source:=makedpath(stagingArea)+makedpath(remfortrail(curapp.fname));
ts:=copy(curpath,length(source)+1,length(curpath));
case curapp.transtype of
  0:begin // FTP
		deploypath:=makewpath(curapp.remdir)+makewpath(ts);
    if ftpfileexists(ftp1,curapp.fname) then
      begin
      ftpdelfile(ftp1,curapp.fname);
      viewfm.m1.lines.adD('  Removing file '+deploypath+curapp.fname);
      end
    else
      begin
      viewfm.m1.lines.add('  Could not remove file '+deploypath+curapp.fname);
      end;
    end;
  1:begin  // upload into local or network directories
  	{ from curpath --> deploypath }
		deploypath:=makedpath(curapp.server)+makedpath(curapp.remdir)+makedpath(ts);
    deletefile(deploypath+curapp.fname);
    viewfm.m1.lines.adD('  Removing file: '+deploypath+curapp.fname);
    end;
  else
    showmessagenosilent('Error 1. Transfer type not known.');
  end;
end;


{ pass in full path name of Project file }
function tmainfm.pulldownnow(fname:string):boolean;
var
  res: integer;
  ts:string;  // temporary strings
  goon:boolean;
begin
goon:=true;
label1.caption:='Pulling Down Project';
result:=true;
{ get directory from staging area that files will be in }
curapp:=tap.create;
if not fileexists(fname) then
  begin
  showmessagenosilent(fname+' does not exist. Cancelling Pulling Down.');
  end
else
  begin
  curapp.loadfromfile(fname);
  if not fileexists(fname+'.ser') then
    begin
    showmessagenosilent(fname+'.ser does not exist. Cancelling Pulling Down.');
    end
  else
    begin
    curapp.loadserfromfile(fname+'.ser');
    { Check if remdir }
    if curapp.remdir='' then
      begin
      showmessagenosilent('Project has no Deployment Directory.'#13#10+'Pull Down cancelled.');
      end
    else
      begin
      { Ask for pulldown }
      if curapp.transtype=0 then
        res:=messagedlg('Remove "'+curapp.nname+'" files from:'#13#10#13#10+'ftp://'+curapp.server+'/'+curapp.remdir+'?',mtconfirmation,[mbyes,mbno],0)
      else
        res:=messagedlg('Remove "'+curapp.nname+'" files from:'#13#10#13#10+curapp.remdir+'?',mtconfirmation,[mbyes,mbno],0);
      if res<>mryes then
        begin
        showmessagenosilent('File removal cancelled.');
        end
      else
        begin
        { send it into the recursive upload routine }
        { may have a problem with curapp.appdir }
        case curapp.transtype of
          0:begin
            { if FTP transfer }
            { first log in }
            if ftpconnect(ftp1,curapp.server,21,curapp.username,curapp.password) then
              goon:=true
            else
              begin
              goon:=false;
              showmessagenosilent('Critical Error. Could not log on to '+curapp.server+' as '+curapp.username);
              end;

            end;
          end;
        if goon then
          begin
          ts:=curapp.remdir;
          if curapp.transtype=1 then
            begin
            res:=messagedlg('Are you sure you want to remove files from '+curapp.remdir+'?',mtconfirmation,[mbyes,mbno],0)
            end
          else
            begin
            res:=messagedlg('Are you sure you want to remove files from ftp://'+curapp.server+'/'+curapp.remdir+'?',mtconfirmation,[mbyes,mbno],0);
            end;
           { goto the starting directory? }
          if res=mryes then
            begin
            if curapp.transtype=0 then
              begin
              goon:=changeto(ftp1,ts,true);
              end;
            { check if this affects local transtype }
            //pulldownpdf(ts);
            if goon then
              begin
              pulldownrec(ts);
              deletefile(fname+'.dep');
              end
            else
              begin
              showmessagenosilent('Could not change directory to '+ts+'. Pull Down cancelled.');
              end
            end
          else
            begin
            showmessagenosilent('Deployment removal cancelled');
            end;
          case curapp.transtype of
            0:begin
              ftpdisconnect(ftp1);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
curapp.free;
if goon then
  createupdatefile('');
label1.caption:='Pull Down Finished';
end;

{ recursively delete file FROM Deployment Area
  curpath=current remote directory}
function tmainfm.pulldownrec(curpath:string):boolean;
var
  res: integer;
  cnt,cntm:integer;
  flist:tstringlist;
  dlist:tstringlist;
  source,deploypath:string; // sourcebase and current deployment path directories
  ts:string ; // temporary string
  upone:boolean;
  cderror:boolean;
begin
result:=true;
source:=curapp.remdir;
{ check this doesn't stuff up  +1 }
ts:=copy(curpath,length(source)+1,length(curpath));
flist:=tstringlist.create;
dlist:=tstringlist.create;
case curapp.transtype of
  0:begin // FTP removal
    ftplist(ftp1);
    ftplistfiles(ftp1,flist);
    ftplistfolders(ftp1,dlist);
    cntm:=flist.count-1;
    for cnt:=0 to cntm do
      begin
      viewfm.m1.lines.adD('  Removing file: '+deploypath+flist[cnt]);
      ftpdelfile(ftp1,flist[cnt]);
      end;

    cntm:=dlist.count-1;
    { recurse through directory structure }
    for cnt:=0 to cntm do
      begin
      result:=changeto(ftp1,dlist[cnt],true);
      if result then
        begin
        pulldownrec(makewpath(curpath)+dlist[cnt]);
        changeto(ftp1,'..',false);
        ftpdirdel(ftp1,dlist[cnt]);
        end
      end;
    end;
  1:begin  // local or network directories
    deploypath:=makedpath(curapp.server)+makedpath(curapp.remdir)+makedpath(ts);
    res:=mryes;
    if (curapp.remdir='') and (ts='') then
    	res:=messagedlg('The Project Definition File has instructed Upgrade to delete the Root Directory '+
      'of a hard disk. Do you really want to do this?',mtconfirmation,[mbno,mbyes],0);
		if res=mryes then
    	begin
      if directoryexists(deploypath) then
        begin
        { delete all files in remote directory }
        flb1.mask:='*.*';
        flb1.directory:=deploypath;
        flb1.filetype:=[ftNormal,ftReadOnly,ftArchive];
        flist.clear;
        flist.AddStrings(flb1.items);
        cntm:=flist.count-1;
        for cnt:=cntm downto 0 do
          begin
          viewfm.m1.lines.adD('  Removing file: '+deploypath+flist[cnt]);
          deletefile(deploypath+flist[cnt]);
          end;
        { recurse through directory structure }
        flb1.mask:='*.*';
        flb1.FileType:=[ftDirectory];
        flb1.directory:=deploypath;
        flist.clear;
        flist.addstrings(flb1.items);
        cntm:=flist.Count-1;
        for cnt:=2 to cntm do
          begin
          pulldownrec(makedpath(curpath)+makedpath(removesbs(flist[cnt])));
          end;
        if deploypath[length(deploypath)]='\' then
          delete(deploypath,length(deploypath),1);
        if directoryexists(deploypath) then
          begin
          try
            rmdir(deploypath);
          except
          end;
          end;
        end;
      end;
    end;
  else
    showmessagenosilent('Error 1. Transfer type not known.');
  end;
flist.free;
dlist.free;
end;

{ END PRIVATE FUNCTIONS }

{ PUBLIC FUNCTIONS }
{ END PUBLIC FUNCTIONS }

{ EVENT HANDLERS ETC}
procedure Tmainfm.Exit1Click(Sender: TObject);
begin
close;
end;

procedure Tmainfm.FormCreate(Sender: TObject);
begin
createstatusfile;
loadparams;
connectionerror:=false;
startup:=true;
caption:=x4appsCaption;
application.helpfile:=s.rcpath+'usuite.hlp';
{ This will close the program if no parameters }
determineaction;
end;


procedure Tmainfm.tbt3Click(Sender: TObject);
begin
if viewfm.Visible=false then
	viewfm.show
else
	viewfm.hide;
end;

procedure Tmainfm.Settings1Click(Sender: TObject);
begin
fwallfm.showmodal;
end;

procedure Tmainfm.tbt2Click(Sender: TObject);
begin
close;
end;

procedure tmainfm.showdeploylist(title:string);
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
  viewfm.m1.lines.add('    Empty');
  end;
viewfm.m1.lines.add('');
viewfm.m1.lines.add('  END DEPLOYMENT LIST');
viewfm.m1.lines.add('');
end;

function Tmainfm.specialfile(fn:string): boolean;
begin
result:=false;
if (pos('.upg',fn)<>0) or (pos('.rdp',fn)<>0) or (pos('.pbu',fn)<>0) or (pos('.tst',fn)<>0) then
  result:=true;
end;


procedure tmainfm.http1Connect(Sender: TObject);
begin
sHTTP1Connect(Sender);
end;

procedure tmainfm.http1ConnectionFailed(Sender: TObject);
begin
sHTTP1ConnectionFailed(Sender);
end;

procedure tmainfm.http1Disconnect(Sender: TObject);
begin
sHTTP1Disconnect(Sender);
end;

procedure tmainfm.http1Failure(Cmd: CmdType);
begin
sHTTP1Failure(Cmd);
end;

procedure tmainfm.http1HostResolved(Sender: TComponent);
begin
sHTTP1HostResolved(Sender);
end;

procedure tmainfm.http1InvalidHost(var Handled: Boolean);
begin
sHTTP1InvalidHost(handled);
end;

procedure tmainfm.http1PacketRecvd(Sender: TObject);
begin
sHTTP1PacketRecvd(Sender);
end;

procedure tmainfm.http1PacketSent(Sender: TObject);
begin
sHTTP1PacketSent(Sender);
end;

procedure tmainfm.http1Status(Sender: TComponent; Status: String);
begin
sHTTP1Status(Sender,Status);
end;

procedure tmainfm.http1Success(Cmd: CmdType);
begin
sHTTP1Success(Cmd);
end;

procedure tmainfm.ftp1Connect(Sender: TObject);
begin
sFTP1Connect(Sender);
end;


procedure tmainfm.ftp1ConnectionFailed(Sender: TObject);
begin
sFTP1ConnectionFailed(Sender);
end;

procedure tmainfm.ftp1Disconnect(Sender: TObject);
begin
sFTP1Disconnect(Sender);
end;

procedure tmainfm.ftp1Error(Sender: TComponent; Errno: Word;
  Errmsg: String);
begin
sFTP1Error(Sender,Errno,Errmsg);
end;

procedure tmainfm.ftp1Failure(var Handled: Boolean; Trans_Type: TCmdType);
begin
sFTP1Failure(handled,Trans_Type);
end;

procedure tmainfm.ftp1HostResolved(Sender: TComponent);
begin
sFTP1HostResolved(Sender);
end;

procedure tmainfm.ftp1InvalidHost(var Handled: Boolean);
begin
sFTP1InvalidHost(handled);
end;

procedure tmainfm.ftp1ListItem(Listing: String);
begin
sFTP1ListItem(Listing);
end;

procedure tmainfm.ftp1PacketRecvd(Sender: TObject);
begin
sFTP1PacketRecvd(Sender);
end;

procedure tmainfm.ftp1PacketSent(Sender: TObject);
begin
sFTP1PacketSent(Sender);
end;

procedure tmainfm.ftp1TransactionStart(Sender: TObject);
begin
sFTP1TransactionStart(Sender);
end;

procedure tmainfm.ftp1TransactionStop(Sender: TObject);
begin
sFTP1TransactionStop(Sender);
end;

procedure tmainfm.ftp1UnSupportedFunction(Trans_Type: TCmdType);
begin
sFTP1UnSupportedFunction(Trans_Type);
end;


procedure tmainfm.ftp1Success(Trans_Type: TCmdType);
begin
sFTP1Success(trans_type);
end;

procedure tmainfm.ftp1Status(Sender: TComponent; Status: String);
begin
putview(status);
end;


procedure Tmainfm.determineaction;
begin
if paramcount<7 then
  begin
  showmessage('This was not called from PC Blues software.');
  halt;
  end;
end;

procedure Tmainfm.executeaction;
{ MO - 15/3/2000
  Here we are supposed to execute the action that }
var
  cnt,cntm:integer;
  ts:string;
begin
application.bringtofront;
if startup then
  begin
  startup:=false;
  { check if another instance running }
  if paramcount>=7 then
    begin
    { load appfiles and continue normally }
    ts:=projectFileName;
    if not pullDownFlag then
			begin
      transmitnow(ts);
      if closeOnFinish then
        application.terminate;
      end
    else
    	begin
			pulldownnow(ts);
      if closeOnFinish then
        application.terminate;
      end;
    end;
  end;
end;


procedure Tmainfm.TBNArea1DblClick(Sender: TObject);
begin
application.restore;
Show;
application.bringtofront;
end;

procedure Tmainfm.hidetask(sender: tobject);
begin
// ShowWindow( Application.handle, SW_HIDE );
end;


procedure Tmainfm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
httptimeout:=true;
ftptimeout:=true;
ftpabort(ftp1);
httpabort(http1);
ftpdisconnect(ftp1);
s.free;
canclose:=true;
deleteStatusFile;
end;

procedure Tmainfm.ShowTransmitter1Click(Sender: TObject);
begin
{ probably should be in a  single function }
application.restore;
Show;
application.bringtofront;
end;

procedure Tmainfm.HideTransmitter1Click(Sender: TObject);
begin
application.minimize;
end;

procedure Tmainfm.Exit2Click(Sender: TObject);
begin
close;
end;

procedure Tmainfm.timListFailTimer(Sender: TObject);
begin
timListFail.enabled:=false;
ListFailed:=true;
end;

procedure Tmainfm.loadParams;
begin
{ Check for valid params, else halt }

if (paramcount<>8) or
   ((paramstr(1)<>'t') and (paramstr(1)<>'p')) or
   ((paramstr(4)<>'forceall') and (paramstr(4)<>'noforceall')) or
   ((paramstr(6)<>'silent') and (paramstr(6)<>'nosilent')) or
   ((paramstr(7)<>'close') and (paramstr(7)<>'noclose')) or
   ((paramstr(8)<>'copy') and (paramstr(8)<>'nocopy')) then
   begin
   showmessagE('Updater Deployer incorrectly called');
   deletestatusfile;
   halt;
   end;
{ Loads parameters }
if paramstr(1)='t' then
  pulldownFlag:=false;
if paramstr(1)='p' then
  pullDownFlag:=true;
projectFileName:=paramstr(2);
stagingArea:=paramstr(3);
if paramstr(4)='forceall' then
  forceAllFiles:=true;
if paramstr(4)='noforceall' then
  forceAllFiles:=false;
testHack:=paramstr(5);
if paramstr(6)='silent' then
  silentMode:=true;
if paramstr(6)='nosilent' then
  silentMode:=false;
if paramstr(7)='close' then
  CloseOnFinish:=true;
if paramstr(7)='noclose' then
  CloseOnFinish:=false;
if paramstr(8)='copy' then
  NoFileCopy:=false;
if paramstr(8)='nocopy' then
  NoFileCopy:=true;
end;

procedure Tmainfm.createStatusFile;
{ Creates file for program status }
var
	ts:string;
  tempf:textfile;
begin
try
ts:=makedpath(s.xmpath)+transFile;
assignfile(tempf,ts);
rewrite(tempf);
writeln(tempf,'Updater Deployer started');
closefile(tempf);
except
 { Could not create status file }
end;
end;

procedure Tmainfm.deleteStatusFile;
begin
{ Deletes file for program status }
deletefile(makedpath(s.xmpath)+transfile);
end;

procedure Tmainfm.EmergencyExit1Click(Sender: TObject);
begin
if messagedlg('Exit program and any network processes?',mtconfirmation,[mbyes,mbno],0)=mryes then
  begin
  deleteStatusFile;
  halt;
  end;
end;

procedure Tmainfm.showmessagenosilent(msg: string);
begin
if not silentMode then
  showmessage(msg); 
end;

procedure Tmainfm.timICtimeoutTimer(Sender: TObject);
begin
dec(ictimeout);
if ictimeout<=0 then
  begin
	Screen.Cursor := crDefault;
  timICtimeout.enabled:=false;
  label3.caption:='';
  application.processmessages;
  end
else
  begin
  label3.caption:=inttostr(ictimeout);
  application.processmessages;
  end;
end;

procedure Tmainfm.FormActivate(Sender: TObject);
begin
executeaction;
hidetask(sender);
end;

procedure Tmainfm.Timer1Timer(Sender: TObject);
begin
timer1.enabled:=false;
end;


procedure Tmainfm.UpgradeTransmitterHelp1Click(Sender: TObject);
begin
application.HelpContext(42);
end;

end.
