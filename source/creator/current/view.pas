unit view;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,share, ComCtrls, ToolWin, ImgList;

type
  Tviewfm = class(TForm)
    m1: TRichEdit;
    tbLog: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    SmallImages: TImageList;
    tbbWrap: TToolButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tbbWrapClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  viewfm: Tviewfm;

implementation

uses main, settings;

{$R *.DFM}

procedure Tviewfm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
action:=caHide;
end;

procedure Tviewfm.FormDestroy(Sender: TObject);
begin
try
//m1.Lines.SaveToFile(s.ugpath+extractfilename(paramstr(0))+'.RTF');
except
end;
end;

procedure Tviewfm.ToolButton1Click(Sender: TObject);
begin
m1.Lines.SaveToFile(s.ugpath+copy(extractfilename(paramstr(0)),1,8)+'.TXT');
showmessage('Saved to "'+s.ugpath+copy(extractfilename(paramstr(0)),1,8)+'.TXT"');
end;

procedure Tviewfm.ToolButton2Click(Sender: TObject);
begin
try
m1.Print('Upgrade Suite Output Report');
except
  ShowMessagenotsilent('Could not print Upgrade Suite Log');
end;

end;

procedure Tviewfm.ToolButton3Click(Sender: TObject);
begin
m1.Lines.Clear;
end;

procedure Tviewfm.ToolButton4Click(Sender: TObject);
begin
hide;
end;

procedure Tviewfm.FormCreate(Sender: TObject);
begin
m1.PlainText:=true;
end;

procedure Tviewfm.tbbWrapClick(Sender: TObject);
begin
m1.WordWrap:=tbbWrap.Down;
end;

procedure Tviewfm.FormShow(Sender: TObject);
begin
m1.WordWrap:=tbbWrap.Down;
end;

end.
