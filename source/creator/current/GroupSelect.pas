unit GroupSelect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmGroupSelect = class(TForm)
    Label1: TLabel;
    butOK: TButton;
    butClear: TButton;
    lbProjects: TListBox;
    procedure butClearClick(Sender: TObject);
    {
    lbProjects: TListBox;
    Label1: TLabel;
    butOK: TButton;
    butClear: TButton;}
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGroupSelect: TfrmGroupSelect;

implementation

{$R *.DFM}

procedure TfrmGroupSelect.butClearClick(Sender: TObject);
var
  c:integer;
  cm:integer;
begin
cm:=lbProjects.Items.Count-1;
for c:=0 to cm do
  begin
  lbProjects.Selected[c]:=false;
  end;
end;

end.
