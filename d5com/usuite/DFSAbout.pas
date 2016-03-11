{$I DFS.INC}  { Standard defines for all Delphi Free Stuff components }

{-----------------------------------------------------------------------------}
{ DFSAbout unit v1.00                                                         }
{-----------------------------------------------------------------------------}
{ This unit provides a property editor that I use for the version property in }
{ all of my components.                                                       }
{ Copyright 1998, Brad Stowers.  All Rights Reserved.                         }
{ This unit can be freely used and distributed in commercial and private      }
{ environments, provied this notice is not modified in any way and there is   }
{ no charge for it other than nomial handling fees.  Contact me directly for  }
{ modifications to this agreement.                                            }
{-----------------------------------------------------------------------------}
{ Feel free to contact me if you have any questions, comments or suggestions  }
{ at bstowers@pobox.com.                                                      }
{ The lateset version of my components are always available on the web at:    }
{   http://www.pobox.com/~bstowers/delphi/                                    }
{-----------------------------------------------------------------------------}
{ Date last modified:  June 2, 1998                                           }
{-----------------------------------------------------------------------------}

unit DFSAbout;

interface

uses
  DsgnIntf;

type
  TDFSVersion = {$IFNDEF DFS_DELPHI_1} type {$ENDIF} string;

  TDFSVersionProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetValue: string; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

implementation

uses
  Dialogs, SysUtils;

procedure TDFSVersionProperty.Edit;
const
  ABOUT_TEXT = '%s'#13#13 +
     'Copyright 1998, Brad Stowers, All Rights Reserved.'#13 +
     'This component is distributed as freeware.'#13#13 +
     'The latest version of this component can be found on'#13 +
     'my web site, Delphi Free Stuff, at:'#13 +
     '  http://www.pobox.com/~bstowers/delphi/'#13;
begin
  MessageDlg(Format(ABOUT_TEXT, [GetStrValue]), mtInformation, [mbOK], 0);
end;

function TDFSVersionProperty.GetValue: string;
var
  i: integer;
begin
  i := Pos(' v', GetStrValue);
  Result := Copy(GetStrValue, i + 2, Length(GetStrValue)-i);
end;

function TDFSVersionProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog, paReadOnly];
end;

end.
