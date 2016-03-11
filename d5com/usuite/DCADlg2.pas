unit DCADlg2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TAddShellCommandDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    MenuEdit: TEdit;
    ParamEdit: TEdit;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure MenuEditChange(Sender: TObject);
    procedure ParamEditChange(Sender: TObject);
    procedure ParamEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddShellCommandDlg: TAddShellCommandDlg;

implementation

{$R *.DFM}

procedure TAddShellCommandDlg.MenuEditChange(Sender: TObject);
begin
   Button1.enabled:=((MenuEdit.text<>'') and (ParamEdit.text<>''));
end;

procedure TAddShellCommandDlg.ParamEditChange(Sender: TObject);
begin
   Button1.enabled:=((MenuEdit.text<>'') and (ParamEdit.text<>''));
end;

procedure TAddShellCommandDlg.ParamEditKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (key = 13) and (ParamEdit.text<>'') then
     Button1.click;
end;

procedure TAddShellCommandDlg.FormCreate(Sender: TObject);
begin
   button1.enabled:=false;
end;

end.
