unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,settings,share,
  ZLIBArchive, pmupgrade,FileCTRL, StdCtrls, ComCtrls, ShellLnk,
  NMFtp, Psock, NMHttp, Menus, ActnList, ImgList, ToolWin,clipbrd,
  ExtCtrls, appexec, MMJRasConnect;

type
  Tmainfm = class(TForm)
    sb1: TStatusBar;
    http1: TNMHTTP;
    ftp1: TNMFTP;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Distribution1: TMenuItem;
    AddNewTarget1: TMenuItem;
    DeleteTarget1: TMenuItem;
    CopyTargetIDtoClipboard1: TMenuItem;
    ActionList1: TActionList;
    addnewtargetid: TAction;
    deletetargetid: TAction;
    copytoclipboard: TAction;
    il1: TImageList;
    tbmain: TToolBar;
    exit: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    lvTargets: TListView;
    ToolButton7: TToolButton;
    editTarget: TAction;
    flb1: TFileListBox;
    timListFail: TTimer;
    pm1: Tpatchmaker;
    timICtimeout: TTimer;
    za: TZLBArchive;
    N1: TMenuItem;
    ShowHints1: TMenuItem;
    N2: TMenuItem;
    DistributionManagerHelp1: TMenuItem;
    p4: TPanel;
    m1: TMemo;
    ToolBar1: TToolBar;
    Label5: TLabel;
    s2: TSplitter;
    AppExec1: TAppExec;
    N3: TMenuItem;
    Copy1: TMenuItem;
    ras: TMMJRasConnect;
    procedure FormCreate(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure exitExecute(Sender: TObject);
    procedure addnewtargetidExecute(Sender: TObject);
    procedure deletetargetidExecute(Sender: TObject);
    procedure copytoclipboardExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure editTargetExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure timListFailTimer(Sender: TObject);
    procedure ShowHints1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure DistributionManagerHelp1Click(Sender: TObject);
  private
    { Private declarations }
    procedure assignhints;
    procedure setHintBox;
    procedure displayTargetList;
  public
    { Public declarations }
		procedure showhint(sender:tobject);
  end;
const
hTargets='|List of target computers for selective distribution.You can send the Target ID''s to users to register their Client software for upgrades';
hDel='Delete Target|Delete target computer from list';
hCopy='Copy to Clipboard|Copies Target ID to clipboard so you can email it to a client';
hExit='Exit|Exits from Distribution Manager';
hEdit='Edit Target|Allows you to edit the name of the target computer';
hAdd='Add Target|Adds a new Target ID to your list';
hm1='Automatic Hint Box';
hhelp='';
hdistmanhelp='|Opens help file for Distribution Manager';
hshowhints='|Toggles the display of the Automatic Hint Box';
habout='|Displays copyright and version information';

var
  mainfm: Tmainfm;

implementation

uses view, splash, about, newDT, editDT;

{$R *.DFM}

procedure Tmainfm.FormCreate(Sender: TObject);
begin
LoadDistTargets;
if splashfm=nil then
  splashfm:=tsplashfm.create(application);
splashfm.showmodal;
splashfm.release;
caption:=distmgrCaption;
assignhints;
application.helpfile:=s.rcpath+'usuite.hlp';
end;

procedure Tmainfm.About1Click(Sender: TObject);
begin
aboutbox.showmodal;
end;

procedure Tmainfm.exitExecute(Sender: TObject);
begin
close;
end;

procedure Tmainfm.addnewtargetidExecute(Sender: TObject);
begin
{ Add new target }
if frmNewDT.showmodal=mrOK then
  begin
  if frmNewDT.ediName.text='' then
    begin
    showmessage('You need to enter a name for the Target.');
    end
  else
    begin
    S.DistListIDs.add(frmNewDT.ediID.text);
    S.DistListNames.add(frmNewDT.ediName.text);
    displayTargetList;
    end;
  end;
end;

procedure Tmainfm.deletetargetidExecute(Sender: TObject);
var
  oldID,oldName:string;
  li:tlistitem;
  posn:integer;
begin
{ Delete Target }
li:=lvTargets.selected;
if li<>nil then
  begin
  oldID:=li.subitems[0];
  oldName:=li.caption;
  posn:=s.DistListIDs.IndexOf(oldID);
  if posn>-1 then
    begin
    s.DistListIDs.Delete(posn);
    s.DistListNAmes.Delete(posn);
    displayTargetList;
    end;
  end
else
  begin
  showmessage('No target selected');
  end;
end;

procedure Tmainfm.copytoclipboardExecute(Sender: TObject);
begin
{ Copy ID to clipboard }
if lvTargets.selected<>nil then
  begin
  clipboard.SetTextBuf(pchar(lvtargets.selected.subitems[0]));
  showmessage('Target ID copied to clipboard.');
  end
else
  begin
  showmessage('No Target selected');
  end;
end;

procedure Tmainfm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
canclose:=true;
ShowTimeLeft;
saveDistTargets;
end;

procedure Tmainfm.editTargetExecute(Sender: TObject);
var
  oldID,oldName:string;
  li:tlistitem;
  posn:integer;
begin
{ Edit target }
li:=lvTargets.selected;
if li<>nil then
  begin
  oldID:=li.subitems[0];
  oldName:=li.caption;
  frmEditDT.ediID.text:=oldid;
  frmEditDT.ediName.text:=oldname;
  if frmEditDT.showmodal=mrOK Then
    begin
    posn:=s.DistListIDs.IndexOf(oldID);
    if posn>-1 then
      begin
      s.DistListIDs[posn]:=frmEditDT.ediID.text;
      s.DIstListNames[posn]:=frmEditDT.ediName.text;
      displayTargetList;
      end;
    end;
  end
else
  begin
  showmessage('No target selected');
  end;
end;

procedure Tmainfm.displayTargetList;
var
  li:tlistitem;
  c,cm:integer; // loop counters
begin
{ Display target list in lvTargets }
lockwindowupdate(lvTargets.Handle);
lvTargets.items.Clear;
cm:=S.DistListIDs.count-1;
for c:=0 to cm do
  begin
  li:=lvTargets.Items.Add;
  li.caption:=S.DistListNames[c];
  li.subitems.Add(S.DistListIDs[c]);
  end;
lockwindowupdate(0);
end;

procedure Tmainfm.FormShow(Sender: TObject);
begin
displayTargetList;
end;

procedure Tmainfm.timListFailTimer(Sender: TObject);
begin
timListFail.enabled:=false;
ListFailed:=true;

end;

procedure Tmainfm.assignhints;
begin
{ assign hints to main form }
lvTargets.hint:=hTargets;
m1.hint:=hm1;

{ Action Items }
addnewtargetid.hint:=hAdd;
deletetargetid.hint:=hDel;
copytoclipboard.hint:=hCopy;
exit.hint:=hExit;
editTarget.hint:=hEdit;

{ help menu }
help1.hint:=  hhelp;
DistributionManagerHelp1.hint:=hdistmanhelp;
ShowHints1.Hint:=hshowhints;
About1.Hint:=habout;
end;

procedure Tmainfm.setHintBox;
begin
// is this OK?
s.savesettings;
{ Show Hints? }
p4.Visible:=s.showhints;
s2.visible:=s.showHints;
showhints1.Checked:=s.showhints;
end;

procedure Tmainfm.ShowHints1Click(Sender: TObject);
begin
s.showhints:=not s.showhints;
SetHintBox;

end;

procedure Tmainfm.FormActivate(Sender: TObject);
begin
application.onhint:=showhint;
SetHintBox;
end;

procedure Tmainfm.showhint(sender: tobject);
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

procedure Tmainfm.Copy1Click(Sender: TObject);
begin
editTargetExecute(sender);
end;

procedure Tmainfm.DistributionManagerHelp1Click(Sender: TObject);
begin
application.HelpContext(43);
end;

end.
