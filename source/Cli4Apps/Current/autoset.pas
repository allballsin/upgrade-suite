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
  end;

var
  autosetfm: Tautosetfm;

implementation

uses main,share,settings;

{$R *.DFM}

procedure Tautosetfm.bb1Click(Sender: TObject);
begin
saveautosettings;
end;

procedure Tautosetfm.FormCreate(Sender: TObject);
begin
loadautosettings;
end;

function tautosetfm.saveautosettings:boolean;
begin
result:=true;
end;

function tautosetfm.loadautosettings:boolean;
var
  c,cm:integer;
begin
result:=true;
c1.checked:=false;
c3.checked:=false;
c2.checked:=true;
c4.checked:=false;
cbInterface.itemindex:=1;
c5.checked:=true;
cbSilent.checked:=true;
cbpoll.checked:=false;
cbID.Items.Clear;
saveautosettings;
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

