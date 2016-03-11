unit xmSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmxmSettings = class(TForm)
    cbSilent: TCheckBox;
    cbClose: TCheckBox;
    cbSave: TButton;
    cbCancel: TButton;
    cbForceAll: TCheckBox;
    Bevel1: TBevel;
    procedure FormShow(Sender: TObject);
    procedure cbSaveClick(Sender: TObject);
    procedure cbCancelClick(Sender: TObject);
  private
    { Private declarations }
    procedure loadxmsettings;
    procedure savexmsettings;
  public
    { Public declarations }
  end;

var
  frmxmSettings: TfrmxmSettings;

implementation

{$R *.DFM}
uses settings;

procedure TfrmxmSettings.FormShow(Sender: TObject);
begin
{ Load settings }
loadxmsettings;
end;

procedure TfrmxmSettings.cbSaveClick(Sender: TObject);
begin
savexmsettings;
s.savesettings;
close;
end;

procedure TfrmxmSettings.loadxmsettings;
begin
cbsilent.checked:=s.xmRunSilent;
cbClose.checked:=s.xmCloseEnd;
cbForceAll.checked:=s.xmForceAll;
end;

procedure TfrmxmSettings.savexmsettings;
begin
s.xmRunSilent:=cbsilent.checked;
s.xmCloseEnd:=cbClose.checked;
s.xmForceAll:=cbForceAll.checked;
end;

procedure TfrmxmSettings.cbCancelClick(Sender: TObject);
begin
close;
end;

end.
