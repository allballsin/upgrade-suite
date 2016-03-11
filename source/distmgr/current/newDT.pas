unit newDT;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,comobj,activex;

type
  TfrmNewDT = class(TForm)
    Label1: TLabel;
    ediName: TEdit;
    butOK: TButton;
    butCancel: TButton;
    Label2: TLabel;
    ediID: TEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNewDT: TfrmNewDT;

implementation

{$R *.DFM}

procedure TfrmNewDT.FormShow(Sender: TObject);
var
	tempguid:tguid;
begin
{ Create new GUID }
ediName.SetFocus;
if cocreateguid(tempguid)<>S_OK then
  begin
  showmessage('Could not generate ID for Target');
  end
else
  ediID.text:=guidtostring(tempguid);
end;


end.
