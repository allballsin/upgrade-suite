unit splash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;
type
  Tsplashfm = class(TForm)
    t1: TTimer;
    Image1: TImage;
    procedure t1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  splashfm: Tsplashfm;

implementation

uses main,settings;

{$R *.DFM}

procedure Tsplashfm.t1Timer(Sender: TObject);
begin
t1.enabled:=false;
close;
end;

procedure Tsplashfm.FormShow(Sender: TObject);
begin
// ShowWindow( Application.handle, SW_HIDE );
end;

end.
