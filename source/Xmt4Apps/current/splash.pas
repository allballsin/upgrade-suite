unit splash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  Tsplashfm = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  splashfm: Tsplashfm;

implementation

{$R *.DFM}

procedure Tsplashfm.FormShow(Sender: TObject);
begin
splashfm.hide;
end;

end.
