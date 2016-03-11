unit newdet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  Tnewdetfm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    e1: TEdit;
    e2: TEdit;
    e3: TEdit;
    bb1: TBitBtn;
    bb2: TBitBtn;
    c1: TCheckBox;
    Label3: TLabel;
    Label5: TLabel;
    e4: TEdit;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure e3Change(Sender: TObject);
  private
    { Private declarations }
    procedure assignhints;
  public
    { Public declarations }
  end;

const
hcompress='|Choose whether to compress the files in a Project before deploying them.';
hugdepth='|The number of versions of files that will have have patches created for them.';
hprovweb='|Website for users of this Project.They will be able to jump to this website from inside Upgrade Suite Client.';
hprovemail='|Email address for users of this Project to contact.They will be able to email this address from inside Upgrade Suite Client.';
hbdp='|This path will be used as the default location for Upgrade Suite Client to find a Project''s files.';

var
  newdetfm: Tnewdetfm;

implementation

{$R *.DFM}

procedure Tnewdetfm.FormCreate(Sender: TObject);
begin
assignhints;
end;

procedure Tnewdetfm.assignhints;
begin
e1.hint:=hprovweb;
e2.hint:=hprovemail;
e3.hint:=hugdepth;
c1.hint:=hcompress;
e4.hint:=hbdp;
end;

procedure Tnewdetfm.e3Change(Sender: TObject);
var
  dummy:integer;
begin
try
dummy:=strtoint(e3.text);
except
e3.text:='0';
end;

end;

end.
