unit about;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls,share;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    Copyright: TLabel;
    OKButton: TButton;
    Version: TLabel;
    Build: TLabel;
    Image1: TImage;
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
{ load first screen }
productname.caption:=distmgrCaption;
build.Caption:=distmgrbuild;
version.Caption:=distmgrVer;
{$ifdef demo}
demolab.visible:=true;
{$else}
demolab.visible:=false;
{$endif}
end;

end.
 
