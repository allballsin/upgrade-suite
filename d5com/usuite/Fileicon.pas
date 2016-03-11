{ -------------------------------------------------------------------------------------}
{ A "file icon" unit for Delphi32.                                                     }
{ Copyright 1996, Patrick Brisacier and Jean-Fabien Connault.  All Rights Reserved.    }
{ This component can be freely used and distributed in commercial and private          }
{ environments, provided this notice is not modified in any way.                       }
{ -------------------------------------------------------------------------------------}
{ Feel free to contact us if you have any questions, comments or suggestions at        }
{ PBrisacier@mail.dotcom.fr (Patrick Brisacier)                                        }
{ JFConnault@mail.dotcom.fr (Jean-Fabien Connault)                                     }
{ -------------------------------------------------------------------------------------}
{ Date last modified:  08/09/96                                                        }
{ -------------------------------------------------------------------------------------}

{ -------------------------------------------------------------------------------------}
{ TFileIcon v1.01                                                                      }
{ -------------------------------------------------------------------------------------}
{ Description:                                                                         }
{   A unit that allows you to manipulate icons.                                        }
{ Needs:                                                                               }
{   Iconctls from Brad Stowers (bstowers@pobox.com)                                    }
{ -------------------------------------------------------------------------------------}
{ Revision History:                                                                    }
{ 1.00:  + Initial release                                                             }
{ 1.01:  + Added support for french and english languages                              }
{ -------------------------------------------------------------------------------------}

unit FileIcon;

interface

uses
  Classes, DsgnIntf, Forms, Controls;

type
  TFileIcon = class(TPersistent)
  private
    { Déclarations privées }
    FFileName: String;
    FIconIndex: Integer;
  protected
    { Déclarations protégées }
  public
    { Déclarations publiques }
    procedure Assign(Source: TPersistent);
  published
    { Déclarations publiées }
    property FileName: String read FFileName write FFileName;
    property IconIndex: Integer read FIconIndex write FIconIndex;
  end;

  TFileIconProperty = class(TClassProperty)
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
  public
    { Déclarations publiques }
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

implementation

uses
  FIconDlg;

{***************************************************************************}
{ TFileIcon                                                                 }
{***************************************************************************}

{***************************************************************************}
{ TFileIcon.Assign                                                          }
{***************************************************************************}
procedure TFileIcon.Assign(Source: TPersistent);
begin
  { inherited Assign(Source); }
  FFileName := (Source as TFileIcon).FileName;
  FIconIndex := (Source as TFileIcon).IconIndex;
end; { TFileIcon.Assign }


{***************************************************************************}
{ TFileIconProperty                                                         }
{***************************************************************************}

{***************************************************************************}
{ TFileIconProperty.GetAttributes                                           }
{***************************************************************************}
function TFileIconProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end; { TFileIconProperty.GetAttributes }

{***************************************************************************}
{ TFileIconProperty.Edit                                                    }
{***************************************************************************}
procedure TFileIconProperty.Edit;
var
  EditDlg: TEditFileIconDlg;
begin
  EditDlg := TEditFileIconDlg.Create(Application);
  try
    EditDlg.FileIcon := TFileIcon(GetOrdValue);
    if EditDlg.ShowModal = mrOk then begin
      SetOrdValue(Longint(EditDlg.FileIcon));
    end;
  finally
    EditDlg.Free;
  end;
end; { TFileIconProperty.Edit }


end.
 
