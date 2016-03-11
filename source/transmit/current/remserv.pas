unit remserv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons,share;

type
  Tremservfm = class(TForm)
    rg1: TRadioGroup;
    Label19: TLabel;
    Label20: TLabel;
    e18: TEdit;
    ediServer: TEdit;
    Label22: TLabel;
    Label21: TLabel;
    e19: TEdit;
    ediDepDir: TEdit;
    bb1: TBitBtn;
    bb2: TBitBtn;
    m1: TMemo;
    Label28: TLabel;
    procedure rg1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    procedure assignhints; 
    procedure showhint(sender:tobject);
    procedure SetHintBox;
  public
    { Public declarations }
  end;

const
httype='|Select the method of transmitting the Project from the Staging Area to the Deployment Area.';
hserver1='|Not used for Local/Network deployment.';
hserver0='|The address of the FTP server that the the Project will be deployed to.'#13#10#13#10'e.g. ftp.myserver.com, or 102.102.102.102'#13#10#13#10'Do not put ftp:// in front of the server address';
hremdir0='|The directory on the remote server to deploy the Project.';
hremdir1='|The full local/network path to the directory where the Project will be Redeployed.';
husername='|Username needed (if any) to log into the destination server to transmit files.';
hpassword='|The password needed (if any) to log into the Deployment Computer.';
hhint='|Automatic hint box.';

var
  remservfm: Tremservfm;

implementation

{$R *.DFM}

uses settings;

procedure Tremservfm.rg1Click(Sender: TObject);
begin
if rg1.itemindex=0 then
  begin
  label19.enabled:=true;
  ediServer.enabled:=true;
  label20.enabled:=true;
  label21.enabled:=true;
  ediServer.hint:=hserver0;
  ediDepDir.hint:=hremdir0;
  e18.enabled:=true;
  e19.enabled:=true;
  end
else
  begin
  label19.enabled:=false;
  ediServer.enabled:=false;
  label20.enabled:=false;
  label21.enabled:=false;
  ediServer.hint:=hserver1;
  ediDepDir.hint:=hremdir1;
  e18.enabled:=false;
  e19.enabled:=false;
  end;

end;

procedure tremservfm.showhint(sender:tobject);
var
  ts:string;
  posn,oldposn:integer;
begin
m1.lines.clear;
ts:=application.hint;
//posn:=0;
m1.lines.adD(ts);
//if ts<>'' then
//  begin
//  while posn<>length(ts) do
//    begin
//    inc(posn);
//    if (ts[posn]='.') or (posn=length(ts)) then
//      begin
//      m1.lines.add(copy(ts,oldposn+1,posn-oldposn));
//      //m1.lines.adD('');
//      oldposn:=posn;
//      end;
//    end;
//  end;
end;

procedure Tremservfm.FormCreate(Sender: TObject);
begin
assignhints;
end;

procedure Tremservfm.assignhints;
begin
rg1.hint:=httype;
ediServer.hint:=hserver0;
ediDepDir.hint:=hremdir0;
e18.hint:=husername;
e19.hint:=hpassword;
m1.hint:=hhint;
end;

procedure Tremservfm.FormActivate(Sender: TObject);
begin
application.onhint:=showhint;
if rg1.itemindex=0 then
  begin
  ediDepDir.hint:=hremdir0;
  ediServer.hint:=hserver0;
  end
else
  begin
  ediServer.hint:=hserver1;
  ediDepDir.hint:=hremdir1;
  end;
rg1click(sender);
SetHintBox;
end;

procedure Tremservfm.SetHintBox;
var
  oldvis:boolean;
begin
{ Show Hints? }
oldvis:=m1.visible;
m1.Visible:=s.showhints;
label28.Visible:=s.showhints;

if oldvis<>m1.visible then
  if oldvis then
    remservfm.height:=remservfm.height-120
  else
    remservfm.height:=remservfm.height+120;
end;

end.
