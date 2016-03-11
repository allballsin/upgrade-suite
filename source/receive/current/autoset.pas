unit autoset;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,registry,clipbrd;

type
  Tautosetfm = class(TForm)
    bb2: TBitBtn;
    bb1: TBitBtn;
    cb1: TComboBox;
    Label1: TLabel;
    c1: TCheckBox;
    c2: TCheckBox;
    c3: TCheckBox;
    c4: TCheckBox;
    c5: TCheckBox;
    cbSilent: TCheckBox;
    cbPoll: TCheckBox;
    cbInterface: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    sbPasteID: TSpeedButton;
    Bevel1: TBevel;
    cbID: TComboBox;
    procedure bb1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbPasteIDClick(Sender: TObject);
  private
    { Private declarations }
    function loadautosettings:boolean;
    function saveautosettings:boolean;
  public
    { Public declarations }
    procedure setthingsgoing;
  end;

var
  autosetfm: Tautosetfm;

implementation

uses main,share,settings;

{$R *.DFM}

procedure Tautosetfm.bb1Click(Sender: TObject);
begin
saveautosettings;
setthingsgoing;
end;

procedure Tautosetfm.FormCreate(Sender: TObject);
begin
loadautosettings;
end;

function tautosetfm.saveautosettings:boolean;
var
  reg:tregistry;
  c,cm:integer;
begin
result:=true;
reg:=tregistry.create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(recroot,true);
try
  reg.Writebool('autocheckstartup',c1.checked);
except
  result:=false;
end;
try
  reg.Writebool('promptnewinstall',c3.checked);
except
  result:=false;
end;
try
  reg.Writebool('startqueuestartup',c2.checked);
except
  result:=false;
end;
try
  reg.Writebool('runrecatstartup',c4.checked);
except
  result:=false;
end;

try
  reg.writebool('autoanonftp',c5.checked);
except
  result:=false;
end;

try
  reg.writebool('runsilent',cbSilent.checked);
except
  result:=false;
end;

try
  reg.writebool('pollschedule',cbpoll.checked);
except
  result:=false;
end;

cm:=cbID.Items.count-1;
for c:=0 to cm do
  begin
  try
    reg.writestring('ClientID'+inttostr(c),cbID.items[c]);
  except
    result:=false;
  end;
  end;

s.runrecatstartup:=c4.checked;
if s.runrecatstartup then
  begin
  runrecatreboot;
  end
else
  begin
  dontrunrecatreboot;
  end;


try
	reg.writeinteger('autocheckinterval',cb1.itemindex);
except
	result:=false
end;

try
	reg.writeinteger('showinterface',cbInterface.itemindex);
except
	result:=false
end;

reg.closekey;
reg.free;

end;

function tautosetfm.loadautosettings:boolean;
var
  reg:tregistry;
  c,cm:integer;
begin
result:=true;
reg:=tregistry.create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(recroot,true);
{ this is being determined according to location of Upgrade Suite Server }
if reg.ValueExists('autocheckstartup') then
  c1.checked:=reg.readbool('autocheckstartup')
else
	c1.checked:=true;

if reg.valueexists('promptnewinstall') then
  c3.checked:=reg.readbool('promptnewinstall')
else
	c3.checked:=false;

if reg.valueexists('startqueuestartup') then
  c2.checked:=reg.readbool('startqueuestartup')
else
	c2.checked:=true;

if reg.valueexists('runrecatstartup') then
  c4.checked:=reg.readbool('runrecatstartup')
else
  c4.checked:=true;

if reg.valueexists('autocheckinterval') then
	cb1.itemindex:=reg.readinteger('autocheckinterval')
else
	cb1.itemindex:=1;

if reg.valueexists('showinterface') then
	cbInterface.itemindex:=reg.readinteger('showinterface')
else
	cbInterface.itemindex:=0;

if reg.valueexists('autoanonftp') then
  c5.checked:=reg.readbool('autoanonftp')
else
  c5.checked:=true;

if reg.valueexists('runsilent') then
  cbSilent.checked:=reg.readbool('runsilent')
else
  cbSilent.checked:=true;

if reg.valueexists('pollschedule') then
  cbpoll.checked:=reg.readbool('pollschedule')
else
  cbpoll.checked:=true;

cbID.Items.Clear;
cm:=1000;
for c:=0 to cm do
  begin
  if reg.valueexists('ClientID'+inttostr(c)) then
    cbID.items.add(reg.readstring('ClientID'+inttostr(c)));
  end;

reg.closekey;
reg.free;
saveautosettings;
end;

procedure Tautosetfm.setthingsgoing;
begin
if cbSilent.checked then
  s.runsilent:=true;

if cbInterface.ItemIndex=0 then
  mainfm.showsimpleinterface
else
  mainfm.showadvancedinterface;

if c2.checked then
  mainfm.queuestart
else
  mainfm.queuestop;
//mainfm.t1.enabled:=c2.checked;

if cbPoll.checked then
  mainfm.pollstart
else
  mainfm.pollstop;

s.runrecatstartup:=c4.checked;
if s.runrecatstartup then
  runrecatreboot
else
  dontrunrecatreboot;



mainfm.SetAutoTimer;
// disable until able to fix problems
mainfm.timUpdateFile.enabled:=true;
end;

procedure Tautosetfm.sbPasteIDClick(Sender: TObject);
begin
if messagedlg('Paste Client ID from clipboard?',mtconfirmation,[mbyes,mbno],0)=mryes then
  begin
  if length(trim(clipboard.astext))<>38 then
    showmessage('This is not a valid Client ID.')
  else
    cbID.Items.Add(trim(clipboard.astext));
  end;
end;


end.

