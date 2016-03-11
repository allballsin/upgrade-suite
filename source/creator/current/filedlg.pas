unit filedlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ApOpenDlg;

type
  Tfrmfiledlg = class(TForm)
    fdialog: TApOpenDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmfiledlg: Tfrmfiledlg;

implementation

{$R *.DFM}

end.
