unit about;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls,share;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    OKButton: TButton;
    Image1: TImage;
    Build: TLabel;
    demolab: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

uses main, splash;

{$R *.DFM}

procedure TAboutBox.FormCreate(Sender: TObject);
begin
build.Caption:=transbuild;
version.Caption:=transVer;
productname.caption:=transCaption;
{$ifdef demo}
demolab.visible:=true;
{$else}
demolab.visible:=false;
{$endif}
end;

end.

