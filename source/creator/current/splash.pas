unit splash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  Tsplashfm = class(TForm)
    t1: TTimer;
    Image2: TImage;
    procedure FormShow(Sender: TObject);
    procedure t1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  splashfm: Tsplashfm;

implementation

uses main;

{$R *.DFM}

procedure Tsplashfm.FormShow(Sender: TObject);
begin
t1.enabled:=true;
end;

procedure Tsplashfm.t1Timer(Sender: TObject);
begin
t1.enabled:=false;
close;
end;

end.

