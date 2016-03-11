unit editDT;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,comobj,activex;

type
  TfrmEditDT = class(TForm)
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
  frmEditDT: TfrmEditDT;

implementation

{$R *.DFM}

procedure TfrmEditDT.FormShow(Sender: TObject);
var
	tempguid:tguid;
begin
ediName.SetFocus;
end;


end.
