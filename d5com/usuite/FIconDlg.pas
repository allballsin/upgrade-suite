unit Ficondlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IconCtls, FileIcon;

type
  TEditFileIconDlg = class(TForm)
    IconListBox: TIconListBox;
    IconFileName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    OKbtn: TButton;
    CancelBtn: TButton;
    BrowseBtn: TButton;
    OpenDialog1: TOpenDialog;
    procedure BrowseBtnClick(Sender: TObject);
    procedure IconFileNameChange(Sender: TObject);
    procedure OKbtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IconListBoxDblClick(Sender: TObject);
  private
    { Déclarations privées }
    FFileIcon: TFileIcon;
    procedure SetFileIcon(AFileIcon: TFileIcon);
  public
    { Déclarations publiques }
    property FileIcon: TFileIcon read FFileIcon write SetFileIcon;
  end;

var
  EditFileIconDlg: TEditFileIconDlg;

const
  { French Messages }
  MSG_FILE_EXISTS_ERROR = 'Impossible de trouver le fichier';
  MSG_THE_FILE = 'Le fichier';
  MSG_FILE_CONTAINS_ICONS_ERROR = 'ne contient pas d''icône.';
  MSG_DIALOG_TITLE = 'Changement d''icône';
  MSG_DIALOG_FILENAME = '&Nom du fichier :';
  MSG_DIALOG_ACTUAL_ICON = '&Icône actuelle :';
  MSG_DIALOG_CANCEL_BUTTON = 'Annuler';
  MSG_DIALOG_BROWSE_BUTTON = '&Parcourir...';

  { English Messages }
  {MSG_FILE_EXISTS_ERROR = 'Unable to find the file';
  MSG_THE_FILE = 'The file';
  MSG_FILE_CONTAINS_ICONS_ERROR = 'doesn''t contain any icon.';
  MSG_DIALOG_TITLE = 'Changing icon';
  MSG_DIALOG_FILENAME = '&Filename :';
  MSG_DIALOG_ACTUAL_ICON = '&Current icon :';
  MSG_DIALOG_CANCEL_BUTTON = 'Cancel';
  MSG_DIALOG_BROWSE_BUTTON = '&Browse...';}

implementation

{$R *.DFM}

{***************************************************************************}
{ TEditFileIconDlg.SetFileIcon                                              }
{***************************************************************************}

procedure TEditFileIconDlg.SetFileIcon(AFileIcon: TFileIcon);
begin
  FFileIcon.Assign(AFileIcon);
end;

{***************************************************************************}
{ TEditFileIconDlg.BrowseBtnClick                                           }
{***************************************************************************}

procedure TEditFileIconDlg.BrowseBtnClick(Sender: TObject);
begin
if IconFileName.text <> '' then
   openDialog1.InitialDir := extractFilePath(IconFileName.text)
else
   openDialog1.InitialDir := 'c:\';

if openDialog1.execute then
 begin
  IconListBox.itemIndex := 0;
  IconFileName.text := openDialog1.FileName
 end;

end;

{***************************************************************************}
{ TEditFileIconDlg.IconFileNameChange                                       }
{***************************************************************************}

procedure TEditFileIconDlg.IconFileNameChange(Sender: TObject);
begin
 IconListBox.FileName := IconFileName.text;
end;

{***************************************************************************}
{ TEditFileIconDlg.OKbtnClick                                               }
{***************************************************************************}

procedure TEditFileIconDlg.OKbtnClick(Sender: TObject);
begin
 modalResult := mrNone;
 if not fileExists(IconListBox.FileName) then
    MessageDlg(MSG_FILE_EXISTS_ERROR + ' "' + IconFileName.text + '".', mtWarning,[mbOk], 0)
 else
  if (IconListBox.itemIndex = -1) then
     MessageDlg(MSG_THE_FILE + ' "' + IconFileName.text + '" ' + MSG_FILE_CONTAINS_ICONS_ERROR, mtWarning,[mbOk], 0)
  else
   begin
    modalResult := mrOK;
    FFileIcon.FileName := IconFileName.Text;
    FFileIcon.IconIndex := IconListBox.itemIndex;
   end;
end;

{***************************************************************************}
{ TEditFileIconDlg.FormShow                                                 }
{***************************************************************************}

procedure TEditFileIconDlg.FormShow(Sender: TObject);
begin
  IconFileName.Text := FFileIcon.FileName;
  IconListBox.itemIndex := FFileIcon.IconIndex;

  ShowMessage('SHOW!');
  EditFileIconDlg.caption := MSG_DIALOG_TITLE;
  Label1.caption := MSG_DIALOG_FILENAME;
  Label2.caption := MSG_DIALOG_ACTUAL_ICON;
  CancelBtn.caption := MSG_DIALOG_CANCEL_BUTTON;
  BrowseBtn.caption := MSG_DIALOG_BROWSE_BUTTON;

end;

{***************************************************************************}
{ TEditFileIconDlg.FormCreate                                               }
{***************************************************************************}

procedure TEditFileIconDlg.FormCreate(Sender: TObject);
begin
  FFileIcon := TFileIcon.Create;
end;

{***************************************************************************}
{ TEditFileIconDlg.FormDestroy                                              }
{***************************************************************************}

procedure TEditFileIconDlg.FormDestroy(Sender: TObject);
begin
  FFileIcon.Free;
end;

{***************************************************************************}
{ TEditFileIconDlg.IconListBoxDblClick                                      }
{***************************************************************************}

procedure TEditFileIconDlg.IconListBoxDblClick(Sender: TObject);
begin
  OkBtn.click;
end;

end.
