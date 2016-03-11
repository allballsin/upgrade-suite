unit login;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  Tloginfm = class(TForm)
    e1: TEdit;
    e2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    bb2: TBitBtn;
    bb3: TBitBtn;
    bb1: TBitBtn;
    Label3: TLabel;
    e3: TEdit;
    Bevel1: TBevel;
    procedure bb1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  loginfm: Tloginfm;

implementation

{$R *.DFM}

procedure Tloginfm.bb1Click(Sender: TObject);
begin
e1.text:='anonymous';
e2.text:='anyone@anywhere.com';
end;

end.
