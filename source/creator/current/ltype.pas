unit ltype;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, PBFolderDialog;

type
  Tltypefm = class(TForm)
    rg1: TRadioGroup;
    bb1: TBitBtn;
    bb2: TBitBtn;
    Label1: TLabel;
    e1: TEdit;
    Label2: TLabel;
    e2: TEdit;
    cbPageHeader: TCheckBox;
    procedure rg1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ltypefm: Tltypefm;

implementation


{$R *.DFM}

procedure Tltypefm.rg1Click(Sender: TObject);
begin
if rg1.itemindex=0 then
	begin
  { disable shortcut directory location }
  { enable url }
  e2.tabstop:=true;
  e2.enabled:=true;
  label1.enabled:=true;
  cbPageHeader.enabled:=true;
  end
else
	begin
	{ enable shortcut directory location }
  { disable url }
  e2.tabstop:=false;
  e2.enabled:=false;
  label1.enabled:=false;
  cbPageHeader.enabled:=false;
  end;
end;

procedure Tltypefm.FormShow(Sender: TObject);
begin
rg1Click(Sender);
end;

end.
