{ Composant TGoToWeb version 1.5 (28/08/97)
  Par CRESTO Sylvain
  Copyright © 1997 CRESTO Sylvain
  sylvain.cresto@hol.fr
  http://www.mygale.org/11/cresto
  La Borde / 09230 / Contrazy / France
    ----

  Composant pour Delphi 2.0 et 3.0 et C++ Builder 1.0.

  Ce composant vous permet de lancer depuis votre application le navigateur
  par défaut et de se connecter à un site Internet.
  Ce composant à été testé et fonctionne avec Netscape (2.0 et sup.) et Internet
  Explorer (2.0 et sup.)

  Nouveauté de la version 1.5: compatibilité avec C++ Builder 1.0.

  Regardez le fichier d'aide pour plus d'explications...
    ----

  Ce composant est un FREEWARE, vous pouvez l'utiliser dans tous vos
  programmes (commerciaux ou pas !) et les distribuer sans rien me devoir.
  Vous utilisez ce composant à vos risques et périls.
  Par contre vous * NE DEVEZ PAS * distribuer le code source * MODIFIÉ *
  de ce composant sans avoir eu au préalable mon accord.
                                                       Merci.


}


unit GoToWeb;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, shellapi, DsgnIntf;

type
  TAboutProperty = class(TPropertyEditor)
  private
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;
  TGoToWeb = class(TComponent)
  private
    FAbout:TAboutProperty;
    FUrl:String;
    procedure SetUrl(value:string);
  public
    constructor Create(aOwner : TComponent); override;
    function IsAnyBrowser : boolean;
    function Execute : boolean;
  published
    property About : TAboutProperty read FAbout write FAbout;
    property Url : string read FUrl write SetUrl;
  end;

procedure Register;

implementation

  const nbr_extension=4;
        extension:array[0..nbr_extension-1] of string=('.HTM','.HTML','.SHTML','.SHTM');

{$R GOTOWEB.RES}

procedure Register;
begin
  RegisterComponents('Upgrade Suite', [TGoToWeb]);
  RegisterPropertyEditor(TypeInfo(TAboutProperty), TGoToWeb, 'ABOUT', TAboutProperty);
end;

function FindBrowser:string;
  var c:byte;
      hkey1,hkey2:hkey;
      typ,taille:cardinal;
      tmp:array[0..1024] of char;
      tmpstr:string;
  procedure Arrange;
    var u:word;
  begin
    tmpstr:=strpas(tmp);
    u:=1;
    repeat
      if tmpstr[u]<>'%' then inc(u) else delete(tmpstr,u,2);
    until u>=length(tmpstr);
    RegCloseKey(hkey2);
    FindBrowser:=tmpstr;
  end;
begin
  c:=0;
  repeat
    if regopenkeyex(hkey_classes_root,pchar(extension[c]),0,key_all_access,hkey1)=0 then
    begin
      if regqueryvalueex(hkey1,nil,nil,@typ,nil,@taille)=error_success then
      begin
        regqueryvalueex(hkey1,nil,nil,nil,@tmp,@taille);
        if tmp<>'' then
        if regopenkeyex(hkey_classes_root,pchar(tmp+'\shell\open\command'),0,key_all_access,hkey2)=error_success then
        begin
          if regqueryvalueex(hkey2,nil,nil,@typ,nil,@taille)=error_success then
          begin
            regqueryvalueex(hkey2,nil,nil,nil,@tmp,@taille);
            if tmp<>'' then
            begin
              Arrange;
              Exit;
            end;
          end;
          regclosekey(hkey2);
        end;
        if regopenkeyex(hkey1,'shell\open\command',0,key_all_access,hkey2)=error_success then
        begin
          if regqueryvalueex(hkey2,nil,nil,@typ,nil,@taille)=error_success then
          begin
            regqueryvalueex(hkey2,nil,nil,nil,@tmp,@taille);
            if tmp<>'' then
            begin
              Arrange;
              Exit;
            end;
          end;
        end;
      end;
      regclosekey(hkey1);
    end;
    inc(c);
  until c=nbr_extension;
  FindBrowser:='';
end;


{ TGoToWeb }

constructor TGoToWeb.create(aOwner : Tcomponent);
begin
  inherited create(aOwner);
  FUrl:='http://www.mygale.org/11/cresto';
end;

function TGoToWeb.IsAnyBrowser : boolean;
begin
  IsAnyBrowser:=(FindBrowser<>'');
end;

procedure TGoToWeb.SetUrl(value:string);
begin
  FUrl:=value;
end;

function TGotoWeb.Execute:boolean;
  var tmp,para:string;
  c:word;
begin
  tmp:=findbrowser;
  if tmp<>'' then
  begin
    tmp:=uppercase(tmp);
    c:=length(tmp)+1;
    repeat
      dec(c);
      para:=copy(tmp,c-3,4);
    until (para='.EXE') or (para='.BAT') or (para='.COM');

    if c<length(tmp) then
    begin
      para:=trim(copy(tmp,c+1,length(tmp)-(c)));
      while (para<>'') and (para[1]='"') do delete(para,1,1);
      delete(tmp,c+1,length(tmp)-(c));
    end else para:='';
    if tmp[1]='"' then delete(tmp,1,1);
    if shellexecute(application.handle,nil,pchar(tmp),pchar(para+' '+FUrl),nil,sw_restore)<33 then execute:=false else execute:=true;
  end else Execute:=false;
end;


{ TAboutProperty }

procedure TAboutProperty.Edit;
begin
  Application.MessageBox('By CRESTO Sylvain - 1997'#13'This component (for Delphi 2.0, 3.0 and C++ Builder 1.0) is FREEWARE.'#13#13'E-mail : sylvain.cresto@hol.fr'#13'WEB : http://www.mygale.org/11/cresto','GoToWeb component version 1.5', MB_OK+ MB_ICONINFORMATION);
end;

function TAboutProperty.GetAttributes: TPropertyAttributes;
begin
  GetAttributes:=[paDialog, paReadOnly];
end;

function TAboutProperty.GetValue: string;
begin
  GetValue:='(About)';
end;

end.
