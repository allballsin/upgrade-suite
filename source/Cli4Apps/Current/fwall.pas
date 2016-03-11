unit fwall;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,registry, OleCtrls, ToolWin, ComCtrls,math;

type
  Tfwallfm = class(TForm)
    p2: TPanel;
    p1: TPanel;
    p3: TPanel;
    bb2: TBitBtn;
    bb1: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    c1: TCheckBox;
    e1: TEdit;
    e2: TEdit;
    p4: TPanel;
    m1: TMemo;
    ToolBar1: TToolBar;
    Label3: TLabel;
    ToolBar2: TToolBar;
    Label6: TLabel;
    ToolBar3: TToolBar;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    e3: TEdit;
    e6: TEdit;
    c2: TCheckBox;
    cbHTTPreport: TComboBox;
    cbFTPreport: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ediHCto: TEdit;
    ediHFto: TEdit;
    ediFCto: TEdit;
    ediFFto: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure bb1Click(Sender: TObject);
    procedure showhint(sender:tobject);
    procedure e2Change(Sender: TObject);
    procedure e6Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    procedure assignhints;
    procedure SetHintbox;
    function loadpfsettings:boolean;
    function savepfsettings:boolean;
  public
    { Public declarations }
  end;

const
  huseprox='|Check here if your web browser uses a Proxy Server.';
  huseftpprox='|Check here if you use an FTP proxy server. You may need to ask your ISP or Network Administrator.';
  hproxhost='|Enter your proxy server address here.You may need help from your ISP or Network Administrator.';
  hproxport='|Port number of your proxy server.You may need help from your ISP or Network Administrator.';
  hfwhost='|FTP proxy server address.You may need help from your ISP or Network Administrator.';
  hfwport='|Port number for access to data through proxy server.You may need help from your ISP or Network Administrator.';
  hhint='|Automatic hint box.';



var
  fwallfm: Tfwallfm;

implementation

uses share,main,settings;
{$R *.DFM}


procedure Tfwallfm.FormCreate(Sender: TObject);
begin
{ load settings }
assignhints;
loadpfsettings;
end;

function tfwallfm.loadpfsettings:boolean;
var
  reg:tregistry;
begin
result:=true;
reg:=tregistry.create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(proxykey,true);
{ this is being determined according to location of Server }
if reg.ValueExists('usewebproxy') then
  c1.checked:=reg.readbool('usewebproxy')
else
	c1.checked:=false;

if reg.ValueExists('useftpproxy') then
  c2.checked:=reg.readbool('useftpproxy')
else
	c2.checked:=false;

if reg.ValueExists('webproxyhost') then
	e1.text:=reg.readstring('webproxyhost')
else
	e1.text:='';

if reg.ValueExists('ftpproxyhost') then
	e3.text:=reg.readstring('ftpproxyhost')
else
	e3.text:='';

if reg.ValueExists('webproxyport') then
	e2.text:=inttostr(reg.readinteger('webproxyport'))
else
	e2.text:='80';

if reg.ValueExists('ftpproxyport') then
	e6.text:=inttostr(reg.readinteger('ftpproxyport'))
else
	e6.text:='21';

if reg.valueexists('webreportlevel') then
  cbHTTPreport.itemindex:=reg.readinteger('webreportlevel')
else
  cbHTTPreport.itemindex:=1;

if reg.valueexists('ftpreportlevel') then
  cbftpreport.itemindex:=reg.readinteger('ftpreportlevel')
else
  cbftpreport.itemindex:=1;

if reg.valueexists('httpcontimeout') then
  ediHCto.text:=inttostr(reg.readinteger('httpcontimeout'))
else
  ediHCto.text:='120';

if reg.valueexists('httpfiltimeout') then
  ediHFto.text:=inttostr(reg.readinteger('httpfiltimeout'))
else
  ediHFto.text:='30';

if reg.valueexists('ftpcontimeout') then
  ediFCto.text:=inttostr(reg.readinteger('ftpcontimeout'))
else
  ediFCto.text:='120';

if reg.valueexists('ftpcontimeout') then
  ediFFto.text:=inttostr(reg.readinteger('ftpfiltimeout'))
else
  ediFFto.text:='30';

reg.closekey;
reg.free;
savepfsettings;
end;


function tfwallfm.savepfsettings:boolean;
var
  reg:tregistry;
  httprep,ftprep:integer;
begin
result:=true;
reg:=tregistry.create;
reg.rootkey:=HKEY_LOCAL_MACHINE;
reg.openkey(proxykey,true);
try
  reg.Writebool('usewebproxy',c1.checked);
except
  result:=false;
end;

try
  reg.Writebool('useftpproxy',c2.checked);
except
  result:=false;
end;

try
	reg.writestring('webproxyhost',e1.text);
except
	result:=false
end;
try
	if e2.text<>'' then
		reg.writeinteger('webproxyport',strtoint(e2.text));
except
	result:=false;
end;

try
	reg.writestring('ftpproxyhost',e3.text);
except
	result:=false;
end;
try
	reg.WriteInteger('ftpproxyport',strtoint(e6.text));
except
	result:=false;
end;

try
  reg.WriteInteger('webreportlevel',cbhttpreport.ItemIndex);
except
  result:=false;
end;

try
  reg.WriteInteger('ftpreportlevel',cbftpreport.ItemIndex);
except
  result:=false;
end;

try
  reg.WriteInteger('httpcontimeout',strtoint(ediHCto.text));
except
  result:=false;
end;

try
  reg.WriteInteger('httpfiltimeout',strtoint(ediHfto.text));
except
  result:=false;
end;

try
  reg.WriteInteger('ftpcontimeout',strtoint(edifcto.text));
except
  result:=false;
end;

try
  reg.WriteInteger('ftpfiltimeout',strtoint(ediffto.text));
except
  result:=false;
end;
{ Mainfm must be created }
{ set components }
try
{ Calculate report levels }
httprep:=0;
case cbhttpreport.itemindex of
  0:httprep:=0;
  1:httprep:=1;
  2:httprep:=3;
  3:httprep:=7;
  4:httprep:=15;
  5:httprep:=31;
  end;
ftprep:=0;
case cbhttpreport.itemindex of
  0:ftprep:=0;
  1:ftprep:=1;
  2:ftprep:=3;
  3:ftprep:=7;
  4:ftprep:=15;
  5:ftprep:=31;
  end;

if mainfm<>nil then
  begin
  mainfm.http1.ReportLevel:=httprep;
  if c1.checked then
    begin
    mainfm.http1.Proxy:=e1.text;
    mainfm.http1.ProxyPort:=strtoint(e2.text);
    end
  else
    begin
    mainfm.http1.Proxy:='';
    mainfm.http1.ProxyPort:=0;
    end;
  end;
except
result:=false;
end;

try
if mainfm<>nil then
  begin
  mainfm.ftp1.ReportLevel:=ftprep;
  if c2.checked then
    begin
    mainfm.ftp1.Proxy:=e3.text;
    mainfm.ftp1.ProxyPort:=strtoint(e6.text);
    end
  else
    begin
    mainfm.ftp1.Proxy:='';
    mainfm.ftp1.ProxyPort:=0;
    end;
  end;
except
result:=false;
end;

reg.closekey;
reg.free;
end;


procedure tfwallfm.showhint(sender:tobject);
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
     // m1.lines.add('');
      oldposn:=posn;
      end;
    end;
  end;
end;

procedure Tfwallfm.bb1Click(Sender: TObject);
begin
savepfsettings;
end;

procedure Tfwallfm.e2Change(Sender: TObject);
var
	ti:integer;
begin
if e2.text<>'' then
	begin
  try
	  ti:=strtoint(e2.text);
  except
    showmessagenotsilent('This value must be an integer greater than or equal to zero.');
    e2.text:='';
  end;
  end;
end;

procedure Tfwallfm.e6Change(Sender: TObject);
var
	ti:integer;
begin
if e6.text<>'' then
	begin
  try
	  ti:=strtoint(e6.text);
  except
    showmessagenotsilent('This value must be an integer greater than or equal to zero.');
    e6.text:='';
  end;
  end;
end;

procedure Tfwallfm.assignhints;
begin
c1.hint:=huseprox;
e1.hint:=hproxhost;
e2.hint:=hproxport;
c2.hint:=huseftpprox;
e3.hint:=hfwhost;
e6.hint:=hfwport;
m1.hint:=hhint;
end;

procedure Tfwallfm.FormActivate(Sender: TObject);
begin
application.OnHint:=showhint;
SetHintBox;
end;


procedure Tfwallfm.SetHintbox;
var
  oldvis:boolean;
begin
{ Show Hints? }
oldvis:=p4.visible;
p4.Visible:=s.showhints;
if oldvis<>p4.visible then
  if oldvis then
    fwallfm.width:=fwallfm.width-156
  else
    fwallfm.width:=fwallfm.width+156;
end;

end.
