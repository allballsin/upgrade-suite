{ -------------------------------------------------------------------------------------}
{ An "Windows 95's shortcuts" component for Delphi32.                                  }
{ Copyright 1996, Patrick Brisacier and Jean-Fabien Connault.  All Rights Reserved.    }
{ This component can be freely used and distributed in commercial and private          }
{ environments, provided this notice is not modified in any way.                       }
{ -------------------------------------------------------------------------------------}
{ Feel free to contact us if you have any questions, comments or suggestions at        }
{ cycocrew@aol.com                                                                     }
{ -------------------------------------------------------------------------------------}
{ Thanks to Radek Voltr (voltr.radek/4600/epr@epr1.ccmail.x400.cez.cz) for basis.      }
{ -------------------------------------------------------------------------------------}
{ Date last modified:  08/16/96                                                        }
{ -------------------------------------------------------------------------------------}

{ -------------------------------------------------------------------------------------}
{ TPBShellLink v1.03                                                                   }
{ -------------------------------------------------------------------------------------}
{ Description:                                                                         }
{   A component that allows you to manipulate Windows 95's shortcuts.                  }
{ Properties:                                                                          }
{   property Arguments: String;                                                        }
{   property Description: String;                                                      }
{   property FileIcon: TFileIcon;                                                      }
{   property FileName:String;                                                          }
{   property HotKey: TShortCut;                                                        }
{   property ShellFolder: TShellFolder;                                                }
{   property Target:String;                                                            }
{   property WindowState: TWindowState;                                                }
{   property WorkingDir: String;                                                       }
{ Procedures and functions:                                                            }
{   procedure Read;                                                                    }
{   procedure Write;                                                                   }
{ Needs:                                                                               }
{   FileIcon unit from Patrick Brisacier                                               }
{                                                                                      }
{ See example contained in example.zip file for more details.                          }
{ -------------------------------------------------------------------------------------}
{ Revision History:                                                                    }
{ 1.00:  + Initial release                                                             }
{ 1.01:  + Added ShellFolder property and removed Options property                     }
{ 1.02:  + Added support for french and english languages                              }
{ 1.03:  + Removed RegFiles package uses                                               }
{ -------------------------------------------------------------------------------------}

unit ShellLnk;

interface

uses
  windows,Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, CommCtrl, DsgnIntf, FileIcon, Registry,comobj,activex,shlobj ,filectrl;

const
  SLR_NO_UI               = $0001;
  SLR_ANY_MATCH           = $0002;
  SLR_UPDATE              = $0004;

  SLGP_SHORTPATH          = $0001;
  SLGP_UNCPRIORITY        = $0002;

  //CLSID_ShellLink: TCLSID = (D1:$00021401; D2:$0; D3:$0; D4:($C0,$0,$0,$0,$0,$0,$0,$46));
  //IID_IShellLink: TCLSID  = (D1:$000214EE; D2:$0; D3:$0; D4:($C0,$0,$0,$0,$0,$0,$0,$46));

  IID_IPersistFile: TGUID = (
    D1:$0000010B;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

  { French Messages }
  MSG_COCREATEINSTANCE_FAILED = 'CoCreateInstance failed.';
  MSG_PERSISTFILE_QUERYINTERFACE_FAILED = 'PersistFile QueryInterface failed.';
  MSG_ERROR_WRITE = 'Error writing link.';
  MSG_ERROR_READ = 'Error reading link.';
  MSG_LINK_NOT_FOUND = 'Link not found.';

  { English Messages }
  {MSG_COCREATEINSTANCE_FAILED = '"CoCreateInstance" failed.';
  MSG_PERSISTFILE_QUERYINTERFACE_FAILED = '"PersistFile QueryInterface" failed.';
  MSG_ERROR_WRITE = 'Write error.';
  MSG_ERROR_READ = 'Read error.';
  MSG_LINK_NOT_FOUND = 'Link not found.';}

type
//  PShellLink = ^IShellLink;
  IShellLink = class(tinterfacedobject,IUnknown)
  public
    function GetPath(pszFile: PChar; cchMaxPath: Integer; var pfd: TWin32FindData;
                fFlags: DWord): HResult; virtual; stdcall; abstract;
    function GetIDList(ppidl: pointer): HResult; virtual; stdcall; abstract;
    function SetIDList(const pidl: pointer): HResult; virtual; stdcall; abstract;
    function GetDescription(pszName: PChar; cchMaxName: Integer): HResult;
                virtual; stdcall; abstract;
    function SetDescription(const pszName: PChar): HResult; virtual; stdcall;
                abstract;
    function GetWorkingDirectory(pszDir: PChar ;cchMaxPath:Integer): HResult;
                virtual; stdcall; abstract;
    function SetWorkingDirectory(const pszDir: PChar): HResult; virtual; stdcall;
                abstract;
    function GetArguments(pszDir: PChar; cchMaxPath: Integer): HResult; virtual;
                stdcall; abstract;
    function SetArguments(const pszArgs: PChar): HResult; virtual; stdcall;
                abstract;
    function GetHotkey(pwHotkey: PWord): HResult; virtual; stdcall; abstract;
    function SetHotkey(wHotkey: Word): HResult; virtual; stdcall; abstract;
    function GetShowCmd(piShowCmd: PInteger): HResult; virtual; stdcall; abstract;
    function SetShowCmd(iShowCmd: Integer): HResult; virtual; stdcall; abstract;
    function GetIconLocation(pszIconPath: PChar; cchIconPath: Integer;
                piIcon: PInteger): HResult; virtual; stdcall; abstract;
    function SetIconLocation(const pszIconPath: PChar; iIcon: Integer): HResult;
                virtual; stdcall; abstract;
    function SetRelativePath(const pszPathRel: PChar; dwReserved: Dword): HResult;
                virtual; stdcall; abstract;
    function Resolve(wnd: hWnd; fFlags: Dword): HResult; virtual; stdcall;
                abstract;
    function SetPath(const pszFile: PChar): HResult; virtual; stdcall; abstract;
  end;

  EPBShellLink = class(Exception);

  TShellFolder = (sfNone, sfDesktop, sfFavorites, sfFonts, sfPersonal, sfPrograms,
                  sfRecent, sfSendTo, sfStartMenu, sfStartup, sfTemplates);

  TPBShellLink = class(TComponent)
  private
    { Déclarations privées }
    FFileName: String;
//    FOldPath: String;
    FTarget: String;
    FWorkingDir: String;
    FDescription: String;
    FArguments: String;
    FWindowState: Integer;
    FHotKey: Word;
    FFileIcon: TFileIcon;
    FShellFolder: TShellFolder;
    procedure SetFileName(AFileName: String);
    function GetWindowState: TWindowState;
    procedure SetWindowState(AWindowState: TWindowState);
    function GetHotKey: TShortCut;
    procedure SetHotKey(AHotKey: TShortCut);
    procedure SetFileIcon(AFileIcon: TFileIcon);
    procedure SetShellFolder(AShellFolder: TShellFolder);
    procedure CreateLink(AFileName: String);
    procedure WriteLink(AFileName: String);
    procedure ReadLink(AFileName: String);
  protected
    { Déclarations protégées }
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Read;
    procedure Write;
  published
    { Déclarations publiées }
    property Arguments: String read FArguments write FArguments;
    property Description: String read FDescription write FDescription;
    property FileIcon: TFileIcon read FFileIcon write SetFileIcon;
    property HotKey: TShortCut read GetHotKey write SetHotKey;
    property FileName:String read FFileName write SetFileName;
    property Target:String read FTarget write FTarget;
    property WindowState: TWindowState read GetWindowState write SetWindowState;
    property WorkingDir: String read FWorkingDir write FWorkingDir;
    property ShellFolder: TShellFolder read FShellFolder write SetShellFolder default sfNone;
  end;

procedure Register;

const
  ShellFolderKeys: array[TShellFolder] of string =
      ('', 'Desktop', 'Favorites', 'Fonts', 'Personal', 'Programs',
      'Recent', 'SendTo', 'Start Menu', 'Startup', 'Templates');


implementation

uses
  FIconDlg;

procedure Register;
begin
  RegisterComponents('Upgrade Suite', [TPBShellLink]);
  RegisterPropertyEditor(TypeInfo(TFileIcon), nil, '', TFileIconProperty);
end;


{***************************************************************************}
{ TPBShellLink                                                              }
{***************************************************************************}

{***************************************************************************}
{ TPBShellLink.Create                                                       }
{***************************************************************************}
constructor TPBShellLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFileIcon := TFileIcon.Create;
  FShellFolder := sfNone;
end; { TPBShellLink.Create }

{***************************************************************************}
{ TPBShellLink.Destroy                                                      }
{***************************************************************************}
destructor TPBShellLink.Destroy;
begin
  FFileIcon.Free;
  inherited Destroy;
end; { TPBShellLink.Destroy }

{***************************************************************************}
{ TPBShellLink.SetFileName                                                  }
{***************************************************************************}
procedure TPBShellLink.SetFileName(AFileName: String);
var
  Registry: TRegistry;
begin
  if AFileName <> FFileName then begin
    if FShellFolder <> sfNone then begin
      Registry := TRegistry.Create;
      try
        Registry.RootKey := HKey_Current_User;
        Registry.OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False);
//        AFileName := Registry.ReadString(ShellFolderKeys[FShellFolder]) + '\' + ExtractFileName(AFileName);
        AFileName := Registry.ReadString(ShellFolderKeys[FShellFolder]) + '\' + AFileName;
      finally
        Registry.Free;
      end;
    end;
    if UpperCase(ExtractFileExt(AFileName)) <> '.LNK' then
      AFileName := AFileName + '.lnk';
    if UpperCase(ExtractFileName(AFileName)) = '.LNK' then
      AFileName := '';
    FFileName := AFileName;
  end;
end; { TPBShellLink.SetFileName }

{***************************************************************************}
{ TPBShellLink.GetWindowState                                               }
{***************************************************************************}
function TPBShellLink.GetWindowState: TWindowState;
begin
result:=wsNormal;
  case FWindowState of
  SW_SHOWNORMAL:
    Result := wsNormal;
  SW_SHOWMINNOACTIVE:
    Result := wsMinimized;
  SW_SHOWMAXIMIZED:
    Result := wsMaximized;
  end;
end; { TPBShellLink.GetWindowState }

{***************************************************************************}
{ TPBShellLink.SetWindowState                                               }
{***************************************************************************}
procedure TPBShellLink.SetWindowState(AWindowState: TWindowState);
const
  SW: array[TWindowState] of Integer =
          (SW_SHOWNORMAL, SW_SHOWMINNOACTIVE, SW_SHOWMAXIMIZED);
begin
  FWindowState := SW[AWindowState];
end; { TPBShellLink.SetWindowState }

{***************************************************************************}
{ TPBShellLink.GetHotKey                                                    }
{***************************************************************************}
function TPBShellLink.GetHotKey: TShortCut;
const
  Sh: array[Boolean] of TShiftState = ([], [ssShift]);
  Ct: array[Boolean] of TShiftState = ([], [ssCtrl]);
  Al: array[Boolean] of TShiftState = ([], [ssAlt]);
var
  Shift: TShiftState;
begin
  Shift :=  Sh[(Hi(FHotKey) and HOTKEYF_SHIFT = HOTKEYF_SHIFT)]
          + Ct[(Hi(FHotKey) and HOTKEYF_CONTROL = HOTKEYF_CONTROL)]
          + Al[(Hi(FHotKey) and HOTKEYF_ALT = HOTKEYF_ALT)] ;
  Result := ShortCut(Lo(FHotKey), Shift);
end; { TPBShellLink.GetHotKey }

{***************************************************************************}
{ TPBShellLink.SetHotKey                                                    }
{***************************************************************************}
procedure TPBShellLink.SetHotKey(AHotKey: TShortCut);
var
  Key: Word;
  Shift: TShiftState;
begin
  ShortCutToKey(AHotKey, Key, Shift);
  Key := Swap(Key);
  if ssShift in Shift then Key := Key + HOTKEYF_SHIFT;
  if ssCtrl in Shift then Key := Key + HOTKEYF_CONTROL;
  if ssAlt in Shift then Key := Key + HOTKEYF_ALT;
  Key := Swap(Key);
  FHotKey := Key;
end; { TPBShellLink.SetHotKey }

{***************************************************************************}
{ TPBShellLink.SetFileIcon                                                  }
{***************************************************************************}
procedure TPBShellLink.SetFileIcon(AFileIcon: TFileIcon);
begin
  FFileIcon.Assign(AFileIcon);
end; { TPBShellLink.SetFileIcon }

{***************************************************************************}
{ TPBShellLink.SetShellFolder                                               }
{***************************************************************************}
procedure TPBShellLink.SetShellFolder(AShellFolder: TShellFolder);
var
  Registry: TRegistry;
begin
  if FShellFolder <> AShellFolder then begin
    FShellFolder := AShellFolder;
    if FShellFolder <> sfNone then begin
      Registry := TRegistry.Create;
      try
        Registry.RootKey := HKey_Current_User;
        Registry.OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False);
//        FFileName := Registry.ReadString(ShellFolderKeys[FShellFolder]) + '\' + ExtractFileName(FFileName);
        FFileName := Registry.ReadString(ShellFolderKeys[FShellFolder]) + '\' + FFileName;
      finally
        Registry.Free;
      end;
    end;
  end;
end; { TPBShellLink.SetShellFolder }

{***************************************************************************}
{ TPBShellLink.CreateLink                                                   }
{***************************************************************************}
procedure TPBShellLink.CreateLink(AFileName: String);
begin
  WriteLink(AFileName);
end; { TPBShellLink.CreateLink }

{***************************************************************************}
{ TPBShellLink.WriteLink                                                    }
{***************************************************************************}
procedure TPBShellLink.WriteLink(AFileName: String);
var
  HResx: hresult;
  psl: IShellLinkW;
  ppf: IPersistFile;
  PCLinkName: PChar;
  WCLinkName: array[0..Max_Path] of WideChar;
  Buf: array[0..255] of Char;
//  Data: TWin32FindData;
begin
  HResx := coInitialize(nil);
  HResx := CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
                            IID_IShellLinkA, psl);
  if not Succeeded(HResx) then raise EPBShellLink.Create(MSG_COCREATEINSTANCE_FAILED);
  HResx := psl.QueryInterface(IID_IPersistfile, ppf);
  if not Succeeded(HResx) then raise EPBShellLink.Create(MSG_PERSISTFILE_QUERYINTERFACE_FAILED);
  { Description }
  StrPCopy(Buf, FDescription);
  HResx := psl.SetDescription(@Buf);
  { Target }
  StrPCopy(Buf, FTarget);
  HResx := psl.SetPath(@Buf);
  { WorkingDir }
  StrPCopy(Buf, FWorkingDir);
  HResx := psl.SetWorkingDirectory(@Buf);
  { Arguments }
  StrPCopy(Buf, FArguments);
  HResx := psl.SetArguments(@Buf);
  { WindowState }
  HResx := psl.SetShowCmd(FWindowState);
  { HotKey }
  HResx := psl.SetHotKey(FHotKey);
  { IconLocation }
  StrPCopy(Buf, FFileIcon.FileName);
  HResx := psl.SetIconLocation(@Buf, FFileIcon.IconIndex);

  PCLinkName := StrAlloc(Length(AFileName)+1);
  StrPCopy(PCLinkName, AFileName);
  MultiByteToWideChar(CP_ACP, 0, PCLinkName, -1, WCLinkName, Max_Path);
  HResx := ppf.Save(WCLinkName, True);
  if not Succeeded(HResx) then raise EPBShellLink.Create(MSG_ERROR_WRITE);
  coUninitialize;
//  ppf._Release;
//  psl._Release;
{  don't know why }
  StrDispose(PCLinkName);
end; { TPBShellLink.WriteLink }

{***************************************************************************}
{ TPBShellLink.ReadLink                                                     }
{***************************************************************************}
procedure TPBShellLink.ReadLink(AFileName: String);
var
  HResx: HResult;
  psl: IShellLink;
  ppf: IPersistFile;
  PCLinkName: PChar;
  WCLinkName: array[0..Max_Path] of WideChar;
  Buf: array[0..255] of Char;
  IBuf: Integer;
  WBuf: Word;
  Data: TWin32FindData;
begin
  HResx := coInitialize(nil);
  HResx := CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
                            IID_IShellLinkA, psl);
  if not Succeeded(HResx) then raise EPBShellLink.Create(MSG_COCREATEINSTANCE_FAILED);
  HResx := psl.QueryInterface(IID_IPersistFile, ppf);
  if not Succeeded(HResx) then raise EPBShellLink.Create(MSG_PERSISTFILE_QUERYINTERFACE_FAILED);
  PCLinkName := StrAlloc(Length(AFileName)+10);
  StrPCopy(PCLinkName, AFileName);
  MultiByteToWideChar(CP_ACP, 0, PCLinkName, -1, WCLinkName, Max_Path);
  HResx := ppf.Load(WCLinkName, STGM_READ);
  if not Succeeded(HResx) then raise EPBShellLink.Create(MSG_ERROR_READ);
  { Description }
  HResx := psl.GetDescription(@Buf, Max_Path);
  FDescription := StrPas(Buf);
  { Target }
  HResx := psl.GetPath(@Buf, Max_Path, Data, SLGP_UNCPRIORITY);
  FTarget := StrPas(Buf);
  { WorkingDir }
  HResx := psl.GetWorkingDirectory(@Buf, Max_Path);
  FWorkingDir := StrPas(Buf);
  { Arguments }
  HResx := psl.GetArguments(@Buf, Max_Path);
  FArguments := StrPas(Buf);
  { WindowState }
  HResx := psl.GetShowCmd(@IBuf);
  FWindowState := IBuf;
  { HotKey }
  HResx := psl.GetHotKey(@WBuf);
  FHotKey := WBuf;
  { IconLocation }
  HResx := psl.GetIconLocation(@Buf, Max_Path, @IBuf);
  FFileIcon.FileName := StrPas(Buf);
  FFileIcon.IconIndex := IBuf;

  coUninitialize;
//  ppf._Release;
//  psl._Release;
  StrDispose(PCLinkName);
end; { TPBShellLink.ReadLink }

{***************************************************************************}
{ TPBShellLink.Read                                                         }
{***************************************************************************}
procedure TPBShellLink.Read;
begin
  if not FileExists(FFileName) then raise EPBShellLink.Create(MSG_LINK_NOT_FOUND);
  ReadLink(FFileName);
end; { TPBShellLink.Read }

{***************************************************************************}
{ TPBShellLink.Write                                                        }
{***************************************************************************}
procedure TPBShellLink.Write;
begin
  if not directoryexists(extractfilepath(ffilename)) then
    forcedirectories(extractfilepath(ffilename));
  if FileExists(FFileName) then
    WriteLink(FFileName)
  else
    CreateLink(FFileName);
end; { TPBShellLink.Write }


end.
