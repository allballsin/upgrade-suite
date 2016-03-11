unit demo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmDemo = class(TForm)
    butOK: TButton;
    Label1: TLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDemo: TfrmDemo;

implementation

{$R *.DFM}

procedure TfrmDemo.Timer1Timer(Sender: TObject);
begin
timer1.enabled:=false;
close;
end;

procedure TfrmDemo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
timer1.enabled:=false;
canclose:=true;
end;

procedure TfrmDemo.FormShow(Sender: TObject);
begin
timer1.enabled:=true;
end;

end.
