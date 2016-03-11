unit about;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls,share,dialogs;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    Copyright: TLabel;
    OKButton: TButton;
    Version: TLabel;
    Build: TLabel;
    Image1: TImage;
    Bevel1: TBevel;
    Label1: TLabel;
    ediUname: TEdit;
    Label2: TLabel;
    ediRegCode: TEdit;
    butReg: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure butRegClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure updatetofullversion;
  public
    { Public declarations }
  end;

const
  mesg='Invalid username or password.'#13#10#13#10'Username and password must be entered '+
  'exactly as you received them in your confirmation email.';
  
var
  AboutBox: TAboutBox;

implementation

uses main, splash;

{$R *.DFM}

procedure TAboutBox.FormCreate(Sender: TObject);
begin
{ load first screen }
build.Caption:=s4appsbuild;
version.Caption:=s4appsVer;
end;

procedure TAboutBox.FormShow(Sender: TObject);
begin
{$ifndef demo}
ediUname.visible:=false;
ediregcode.visible:=false;
label1.visible:=false;
butreg.visible:=false;
label2.caption:='Registered Version';
{$else}
{$endif}
end;

procedure TAboutBox.butRegClick(Sender: TObject);
var
  c,cm:integer;
  d:integer;
begin
{ add the characters and multiply by 13? }
try
cm:=length(ediuname.Text);
d:=0;
for c:=1 to cm do
  begin
  d:=d+ord(ediuname.text[c]);
  if c<>1 then
    d:=d*2;
  end;
if (d=strtoint(ediRegCode.text)) or (length(ediuname.text)<10) then
  updatetofullversion
else
  showmessage(mesg);
except
  showmessage(mesg);
end;
end;

procedure TAboutBox.updatetofullversion;
begin
{ call updater to upgrade to full version }
showmessage('not yet implemented');
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
var
  c,cm,d:integer;
begin                            
cm:=length(ediuname.Text);
d:=0;
for c:=1 to cm do
  begin
  d:=d+ord(ediuname.text[c]);
  if c<>1 then
    d:=d*2;
  end;
ediRegCode.text:=inttostr(d);
end;

end.

