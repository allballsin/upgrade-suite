{
---------------------
TATShell
---------------------

This component was created by Almer.S. Tigelaar and Dale (Stryder) Clarke
This component was made to ease the creation of associations and set
system shell extensions for associated files that your program uses.
It also offers functions to read Icons and Types:

This freeware release is provided free, "as-is".
Both A.S. Tigelaar and Dale (stryder) Clarke, will not be responsible for
any damage to your, or your clients computer. However this component
is free you may freely copy it and use it. And you may use and copy the
code. However you may not sell this component. If you copy this
component to a CD and sell the CD the one who receives the CD only has
to pay for the CD and not for the component.
Use this component entirely at your own risk.
}

unit ATShell;

interface

uses
  Windows, Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Registry,Shellapi,
  DsgnIntf,ExptIntf;
{$IFDEF VER300}
{$R ATSHELL.DCR} // Component icon needed for Delphi3
{$ENDIF}

Const Version:string ='1.03';  // updated by dale and sent to Almer Jan 3/98

 type
  // Set declared for the parampos field
  TParamPos =(ppBefore,ppAfter);

  // ATShell's class declaration
  TATShell = class(TComponent)
  private
   { Private declarations }
  FKey : String;    //Registry key
  FExt : String;    //Extension
  FIcon : String;   //Path to DefaultIcon
  FType : String;   //FileType Description
  FNew : Boolean;   //Show in the new menu
  FPath : String;   //Path to Application
  FShellCommands:string; {property for shell menu names and parameters}
  FParamPos:TParamPos;
  FQuick : Boolean;   //Display file in System Quicviewer
    procedure SetExtension(Value:string);
    Function ReadReg(Ext : String) : String;
    procedure MakeAssociation(Ext: String; PgmToLinkTo: String;
                              DefaultIcon:String; KeyName : String;
                              TypeName : String; ShowInNew : Boolean);
    procedure SetValInReg(RKey:HKey; KeyPath: String;
                          ValName: String; NewVal: String);
    procedure SetCommandInReg(PgmToLinkTo,aName,aParam:string);
    function DoesKeyExist(aKey:string): boolean;
    function DeleteAssociation: boolean;
    function ClearAssociation:boolean;
    function GetShellcommands:string;
    function FieldsAreValid:boolean;
  protected
    { Protected declarations }
  public
   { Public declarations }
   constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure CreateAssociation; //Creates an association
    function RemoveAssociation(RemoveKeyName:boolean;UpdateSystem:boolean): boolean;
    function ReadIcon: TIcon;
    function ReadType: String;
    function AssociationExists : String;
    function GetAssociation:boolean;
    function EnumAllAssoc:tStrings;
    function EnumAssoc(aAppFilename:string):tStrings;
    function SaveToFile(const aFilename:string):boolean ;virtual;
    function LoadFromFile(const aFilename:string):boolean ;virtual;
    function BackupAssociation(Key : string):boolean; virtual;
    function RestoreAssociation(Key : String):boolean; virtual;
  published
     { Published declarations }
   property IconPath: string read FIcon write FIcon;
    property ShowInNew: Boolean read FNew write FNew;
    property TypeName : String read FType write FType;
    Property PathToApp: String read FPath write FPath;
    Property Extension:String read FExt write SetExtension;
    Property KeyName: String read FKey write FKey;
    property QuickView: Boolean read FQuick write FQuick;
    Property ShellCommands:string read fShellCommands write fShellCommands;
    Property ParamPos:TParamPos read FParamPos write FParamPos;
  end;

procedure Register;

implementation

 Uses ShlObj,DCADlg1,RegWork,CommCtrl;

function RemoveParams(value:string):string;
var
  i:integer;
begin
        i:=pos('.EXE',uppercase(value));
        if ((i<(length(value)-4)) and (i>0)) then
          result:=copy(value,1,i+3)
        else
          result:=value;
end;


{***************************************************************************}
{ TATShell                                                                  }
{***************************************************************************}
//Contructor and Destructor
constructor TATShell.Create(AOwner:TComponent);
begin
   inherited Create(aOwner);
     ShowInNew:=False;
     QuickView:=false;
     ShellCommands:='';
     ParamPos:=ppBefore;
end;

destructor TATShell.Destroy;
begin
   inherited Destroy;
end;
{2cents - This function should realy be name GetAssociationAppPath}
function TATShell.AssociationExists: String;
var
  AReg : TRegistry;
  AssocKey : String;
begin
  Result:=''; {initialize result to empty string if exception occurrs}
  AReg := TRegistry.Create;
  AReg.RootKey:=HKEY_CLASSES_ROOT;
   //Lowercase to avoid trouble
  FExt:=LowerCase(FExt);
//Check if the key (.???) exists
  If Pos('.', FExt)=0 then FExt:='.'+FExt;
  if not AReg.KeyExists(FExt) then
   begin
    Result:='';
    AReg.Free;
   end
 else
   begin
    AReg.OpenKey(FExt, False);
    AssocKey:=AReg.ReadString('');
    AReg.CloseKey;
    if not AReg.OpenKey(AssocKey, FALSE) then
      begin
        AReg.Free;
        Result:='';
        exit;
     end;
    if not AReg.OpenKey('Shell\Open\Command', False) then
      begin
        Result:=AReg.ReadString('');
        Areg.Free;
        Exit;
      end;
    result:=RemoveParams (AReg.ReadString(''));
    AReg.Free;
  end;
end;

procedure TATShell.SetExtension(Value:string);
begin
  // always set to value incase registry change
   FExt:=Value;
   GetAssociation
end;

function TATShell.FieldsAreValid:boolean;
begin
  result:=(FKey<>'');    //Registry key
  if not result then exit;
  result:=(FExt<>'');    //Extension
  if not result then exit;
  result:=(FExt<>'.');    //Extension
  if not result then exit;
  result:=(FIcon<>'');   //Path to DefaultIcon
  if not result then exit;
  result:=(FType<>'');   //FileType Description
  if not result then exit;
  result:=fileexists(FPath);   //Path to Application
end;

function TATShell.DoesKeyExist(aKey:string): boolean;
var
  AReg : TRegistry;
begin
  result:=false;
  AReg := TRegistry.Create;
 try
  AReg.RootKey:=HKEY_CLASSES_ROOT;
  result:= AReg.OpenKey(aKey,false);
 finally
  AReg.free;
 end;
end;

function TATShell.GetShellcommands:string;
var
  aList:tStringList;
  i,e:integer;
  s:string;

  function GetParams(value:string):string;
  var
    i:integer;
  begin
        if pos(PathToApp,value)<> 0 then
          delete(value,1,length(PathToApp));
        i:=pos('%1',uppercase(value));
        if (i<>0) then
          delete(value,i,i+1);
        result:=trimleft(value);
  end;

begin
   result:='';
   aList:=tstringlist.create;
  try
   if GetRegSubTree(HKEY_CLASSES_ROOT,alist,FKey+'\Shell') then
     begin
       for i:=0 to alist.count-1 do
         begin
           if uppercase(alist[i])<>'OPEN' then
            begin
              s:=GetRegistryStr(HKEY_CLASSES_ROOT,FKey+'\Shell\'+alist[i]+'\command','');
              result:=result+alist[i]+'|'+GetParams(s)+',';
            end;
         end;
     end;
   finally
      alist.free;
   end;{of try}
end;

function TATShell.GetAssociation:boolean;
var
  AssocStr,TempStr:string;
  i:longword;
begin
  result:=false;
 { if FExt='' then exit;}
  FExt:=LowerCase(FExt);
//Check if the key (.???) exists
  If Pos('.', FExt)=0 then FExt:='.'+FExt;
  if not DoesKeyExist(FExt) then
    begin
        FKey:='';
        FIcon :='';
        FPath := '';
        FType :='';
        FQuick:=false;
        FNew:= false;
        FShellCommands:='';
    end
  else
    begin
        FKey:=GetRegistryStr(HKEY_CLASSES_ROOT,FExt,'');
        FIcon :=GetRegistryStr(HKEY_CLASSES_ROOT,FKey+'\DefaultIcon','');
        FPath := RemoveParams(GetRegistryStr(HKEY_CLASSES_ROOT,FKey+'\Shell\Open\Command',''));
        FType :=GetRegistryStr(HKEY_CLASSES_ROOT,FKey,'');
        FQuick:=(DoesKeyExist(FKey+'\QuickView'));
        FNew:= DoesKeyExist(FExt+'\ShellNew');
        FShellCommands:=GetShellCommands;
        result:=true;
    end;
end;

//Create Assoc
procedure TATShell.CreateAssociation;
begin
if not FieldsAreValid then exit;
If Pos('.', FExt)=0 then FExt:='.'+FExt;
MakeAssociation(FExt,FPath, FIcon, FKey, FType, FNew);
SHChangeNotify(SHCNE_ASSOCCHANGED,SHCNF_FLUSH,pchar(''),pchar(''));  {update system of assocciation change}
end;

//Clears or Removes an Association with or without updating desktop
function TATShell.RemoveAssociation(RemoveKeyName:boolean;UpdateSystem:boolean): boolean;
begin
  if RemoveKeyName then
    result:=DeleteAssociation
  else
    result:=ClearAssociation;
  if UpdateSystem then
     SHChangeNotify(SHCNE_ASSOCCHANGED,SHCNF_FLUSH,pchar(''),pchar(''));  {update system of assocciation change}
end;


function  TATShell.ClearAssociation:boolean;
begin
  result:=false;
  if Extension='' then exit;    {only perform if valid}
  If Pos('.', FExt)=0 then FExt:='.'+FExt;
  if DoesKeyExist(fKey) then
  SetValInReg(HKEY_CLASSES_ROOT,
             Fext,           { extension we want to define }
             '',                { specify the default data item }
             ''); { clear reference to association  }
  result:=true;           
end;

function TATShell.DeleteAssociation: boolean;
var
  s:string;
begin
  result:=false;  {initialize result}
  if Extension='' then exit;    {only perform if not empty}
  If Pos('.', FExt)=0 then FExt:='.'+FExt;  {make sure its a extension}
  FExt:=LowerCase(FExt);
  if not DoesKeyExist(Extension) then exit; {only perform if registered file extension}
  s:=GetRegistryStr(HKEY_CLASSES_ROOT,FExt,'');
  result:=NTDeleteRegKey(HKEY_CLASSES_ROOT,FExt); {remove keys and subkeys for extension}
  if not result then exit; {error occurred get out}
  if s<>'' then  {only perform if extension had a association}
    begin
      result := NTDeleteRegKey(HKEY_CLASSES_ROOT,FKey); {remove keys and subkeys for association}
    end;
end;

//Extra function : Reads the type;
function TATShell.ReadType : String;
begin
If Pos('.', FExt)=0 then FExt:='.'+FExt;
Result:=ReadReg(FExt);
end;

// ReadIcon written by dale replaces Almers. sorry
function TATShell.ReadIcon: TIcon;
var
  Buff: array[0..255] of char;
  windir,inStr:string;

  function GetIcoIdx(instr:string):integer;
   var
     e:integer;
    begin
      result:=0;
      e:=pos(',',instr);
      if e<>0 then
        begin
         try
           result:=strtoint(trim(copy(instr,e+1,length(instr))));
         except
           result:=0;
         end;
        end;
    end;
 function GetIco(s:string):string;
   var
     e:integer;
    begin
      result:=s;
      e:=pos(',',s);
      if e<>0 then
         result:=copy(s,1,e-1);
    end;
begin
  { Create the new icon }
  Result := TIcon.Create;
  GetAssociation;
  instr:=IconPath;
  {get windows dir}
  GetWindowsDirectory(buff, 255);
  {convert to string}
  windir:=strpas(buff);
  if not fileexists(getico(instr)) then
   begin
    {no file to get icon from so use apps icon}
    Result.Handle := ExtractIcon(Application.Mainform.Handle, strpCopy(buff,PathtoApp), 0);
   if (Result.Handle<2) then
    Result.Handle := ExtractIcon(Application.Mainform.Handle, strpCopy(buff,Windir+'\system\shell32.dll'), 0);
   end
  else
    { Assign it the icon handle }
     Result.Handle := ExtractIcon(Application.Mainform.Handle, StrPCopy(Buff, GetIco(instr)), GetIcoIdx(instr));
end;

//**********FUCTIONS IT USES TO CREATE THINGS******************

//Returns file type
function TATShell.ReadReg(Ext : string) : string;
var
    Index:integer;
    strin:string;
    aReg : TRegistry;
begin
//Initialise registry (aReg)
Areg:=Tregistry.Create;
Areg.Rootkey:=HKEY_CLASSES_ROOT;
if not Areg.OpenKey(Ext, False) then
begin
Result:=Copy(Uppercase(ext), pos('.',ext)+1,Length(ext))+' File';
exit;
end;
strin:=Areg.ReadString('');
areg.CloseKey;
if areg.OpenKey(strin,False) then
 Result:=areg.ReadString('')
else
 Result:=Copy(Uppercase(ext), pos('.',ext)+1,Length(ext))+' File';
Areg.Free;
end;

//Set a value in the registry;
procedure TATShell.SetValInReg(RKey:HKey; KeyPath: String;
                             ValName: String; NewVal: String);
begin
   with TRegistry.Create do
   try
      RootKey := RKey;
      OpenKey(KeyPath, True);
      WriteString(ValName,NewVal);
   finally
      Free;
   end;
end;

procedure TATShell.SetCommandInReg(PgmToLinkTo,aName,aParam:string);
var
  s:string;
begin
   if aParam<>'' then
      begin
        if ParamPos=ppBefore then
          s:=PgmToLinkTo + ' '+aParam+' %1'
        else
          s:=PgmToLinkTo +' %1 '+aParam;
        SetValInReg(HKEY_CLASSES_ROOT,
            KeyName+'\shell\'+aName+'\command', { create a shell command key }
            '',                   { specify the default data item }
            s); { command line to shell command }
       end
   else
        SetValInReg(HKEY_CLASSES_ROOT,
            KeyName+'\shell\'+aName+'\command', { create a shell command key }
            '',                   { specify the default data item }
            PgmToLinkTo + ' %1') { command line to shell command }
end;

//Makes association
procedure TATShell.MakeAssociation(Ext: String; PgmToLinkTo: String;
                                          DefaultIcon:String; KeyName : String;
                                          TypeName : String; ShowInNew : Boolean);
var
  PgmCmdLine: String;
  i:integer;
  alist:tstringlist;
begin
   { ALL extensions must be in lowercase to avoid trouble! }
   Ext:=LowerCase(Ext);
   if FileExists(PgmToLinkTo) then
   begin
      SetValInReg(HKEY_CLASSES_ROOT,
             ext,           { extension we want to define }
             '',                { specify the default data item }
             KeyName); { This is the value of the default data item -
                                 this referances our new type to be defined  }
      If ShowInNew then
         begin
           SetValInReg(HKEY_CLASSES_ROOT,
                                    ext+'\ShellNew',    // you forgot to add the shellnew Almer
                                    'Nullfile',
                                    '');
           SetValInReg(HKEY_CLASSES_ROOT,
                                    KeyName+'\ShellNew',    // you forgot to set the key shellnew Also
                                    '',
                                    'Nullfile');
         end;
      SetValInReg(HKEY_CLASSES_ROOT,
            KeyName,   { this is the type we want to define }
            '',                 { specify the default data item }
            TypeName);   { This is the value of the default data item -
                              this is the English description of the file type }
        SetValInReg(HKEY_CLASSES_ROOT,
            KeyName+'\shell\open\command', { create a file...open key }
            '',                   { specify the default data item }
            PgmToLinkTo + ' %1'); { command line to open file with }
        SetValInReg(HKEY_CLASSES_ROOT,
            KeyName+'\DefaultIcon','',DefaultIcon);
       if QuickView then
         begin
          SetValInReg(HKEY_CLASSES_ROOT,
            KeyName+'\QuickView', { create a file...QuickView key }
            '',                   { specify the default data item }
            '*'); { must be "*" }
         end;
        if ShellCommands<>'' then
         begin
            alist:=parseShellCommandList(ShellCommands);
           try
            for i:=0 to alist.count-1 do
             begin
                SetCommandInReg(PgmToLinkTo,copy(alist[i],1,pos('|',alist[i])-1),
                  copy(alist[i], pos('|',alist[i])+1,length(alist[i])));
             end;
           finally
             alist.free;
           end;{of try}
         end;
   end  {of MakeAssociation}
   else
      ShowMessage('Error: Program not found: ' + PgmToLinkTo);
end;

// written by Dale (stryder) Clarke
// This function will enumerate all associated extensions looking for
// matches to the parameter "aAppFilename" and return all extensions
// in a list of strings NOTE You must free the returned strings
function TATShell.EnumAssoc(aAppFilename:string):tStrings;
var
  alist:tstringlist;
  i:integer;
  c:tCursor;
begin
      c:=screen.cursor;
      result:=tstringlist.create;
      alist:=tstringlist.create;
   try
      screen.cursor:=crhourglass;
         if GetRegSubTree(HKEY_CLASSES_ROOT ,alist,'') then
           begin
              for i:=0 to alist.count-1 do
                begin
                  extension:=alist[i];
{                  if GetAssociation then
                    begin
                      if PathToApp<>'' then;
                      begin  }
                        if uppercase(AssociationExists) = uppercase(aAppFilename) then
                            result.add(alist[i]);
                  {    end;
                    end;}
                end;
           end;
    finally
      alist.free;
      screen.cursor:=c;
    end;
end;

// written by Dale (stryder) Clarke
// This function will enumerate all associated extensions and return all extensions
// in a list of strings NOTE You must free the returned strings
function TATShell.EnumAllAssoc:tStrings;
var
  alist:tstringlist;
  i:integer;
  c:tCursor;
begin
      c:=screen.cursor;
      result:=tstringlist.create;
      alist:=tstringlist.create;
   try
      screen.cursor:=crhourglass;
         if GetRegSubTree(HKEY_CLASSES_ROOT ,alist,'') then
           begin
              for i:=0 to alist.count-1 do
                begin
                  extension:=alist[i];
                  if GetAssociation then
                    begin
                      if PathToApp <> '' then
                        if ReadType <> '' then
                            result.add(alist[i]);
                    end;
                end;
           end;
    finally
      alist.free;
      screen.cursor:=c;
    end;
end;

// this type is used to save and load the component
Type
  ATShellRec =record
    rKey : String[255];    //Registry key
    rExt : String[255];    //Extension
    rIcon : String[255];   //Path to DefaultIcon
    rType : String[255];   //FileType Description
    rNew : Boolean;   //Show in the new menu
    rPath : String[255];   //Path to Application
    rShellCommands:string[255]; {property for shell menu names and parameters}
    rParamPos:TParamPos;
    rQuick : Boolean;   //Display file in System Quicviewer
  end;
// written by Dale (stryder) Clarke
// This procedure saves all component fields to a file
function TATShell.SaveToFile(const aFilename:string):boolean;
var
  f:file;
  r:ATShellRec;
begin
   result:=false;
   with r do
     begin
       rKey :=fkey;    //Registry key
       rExt :=fExt;    //Extension
       rIcon :=fIcon;   //Path to DefaultIcon
       rType := fType;   //FileType Description
       rNew := fNew;   //Show in the new menu
       rPath :=fPath;   //Path to Application
       rShellCommands:=fShellCommands; {property for shell menu names and parameters}
       rParamPos:=fParamPos;
       rQuick := fQuick;   //Display file in System Quicviewer
     end;
   AssignFile(f, aFilename);
   {$I-}
   Rewrite(f,1);
   if IOResult <> 0 then
     begin
        MessageDlg('Could not open '+aFilename,mtError,[mbOk],0);
        exit;
     end;
   BlockWrite(f, r, sizeof(r));
   CloseFile(f);
  {$I+}
  result:=true;
end;

// written by Dale (stryder) Clarke
// This procedure loads all component fields from a file
function TATShell.LoadFromFile(const aFilename:string):boolean;
var
  f:file;
  r:ATShellRec;
begin
   Result:=false;
   AssignFile(f, aFilename);
   {$I-}
   Reset(f,1);
   if IOResult <> 0 then
     begin
        MessageDlg('Could not open '+aFilename,mtError,[mbOk],0);
        exit;
     end;
   Blockread(f, r, sizeof(r));
   CloseFile(f);
  {$I+}
   with r do
     begin
       fKey :=rkey;    //Registry key
       fExt :=rExt;    //Extension
       fIcon :=rIcon;   //Path to DefaultIcon
       fType := rType;   //FileType Description
       fNew := rNew;   //Show in the new menu
       fPath :=rPath;   //Path to Application
       fShellCommands:=rShellCommands; {property for shell menu names and parameters}
       fParamPos:=rParamPos;
       fQuick := rQuick;   //Display file in System Quicviewer
     end;
   result:=GetAssociation;
end;

//Backup an association to a registry key.
function TATShell.BackupAssociation(Key : String) : Boolean;
begin
 FExt:=LowerCase(FExt);
 If Pos('.', FExt)=0 then FExt:='.'+FExt;
 Result:=False;
 if Pos('\', Key)<>Length(Key) then KeY:=Key+'\'; //Add \ because something has to be added to the key string (not KeyExt but Key\Ext)
 if not GetAssociation then exit;
 MakeAssociation(Key+FExt,FPath, FIcon, FKey, FType, FNew);
 Result:=GetAssociation;
end;

//Restore an association from a registry key
function TATShell.RestoreAssociation(Key : String) : Boolean;
var
 bckStr : String;
begin
 FExt:=LowerCase(FExt);
 If Pos('.', FExt)=0 then FExt:='.'+FExt;
 if Pos('\', Key)<>Length(Key) then KeY:=Key+'\';    //This might be Length(Key)-1
 Result:=False;
 bckStr:=FExt; //Backup Extension
 FExt:=Key+FExt; //Add the correct keyname
 if not DoesKeyExist(FExt) then exit;
 if not GetAssociation then exit; //If the association doesn't exist then return false
 FExt:=BckStr; //Restore FExt
 CreateAssociation; //Create the association as normal
 Result:=GetAssociation; //Return good result
end;

(*

  Delphi Editors for ATShell component

  This unit contains the property and component editors for the ATShell component.
  These editors are written by Dale (stryder) Clarke. Changes to these editors
  incorrectly can lead to serious association damage in your registry. As TATShell
  is Freeware so are these editors "as is". You use these editors at your own risk.
  If you wish to modify them or extend apon them. Please atleast have a good
  understanding of ATShells source code above, be fermilliar with using the ToolServices
  object, and read the comments in both the DsgnIntf and ExptIntf units.
  I learned by a little trial and a lot of error so be warned.

  All editors are static objects. In other words the the editors do not create
  a interface object so do not require a extra DLL to use the component or
  ship with the program.
*)

{***************************************************************************}
{ TAssocExtProperty   Editor for extension property field declarations      }
{***************************************************************************}

 Type
   // This property editor displays a drop down list of common extension
   // to allow easy selecting of the most common extensions.
   TAssocExtProperty = class (TStringProperty)
     public
      function GetAttributes: tPropertyAttributes; override;
      procedure GetValues(Proc: TGetStrproc);override;
    end;

{***************************************************************************}
{ TAssocExtProperty.Getattributes                                           }
{***************************************************************************}
 function TAssocExtProperty.Getattributes: TPropertyAttributes;
 begin
   Result:=[paValuelist, paSortList];
 end;

{***************************************************************************}
{ TAssocExtProperty.GetValues                                               }
{***************************************************************************}
 procedure TAssocExtProperty.GetValues(Proc :TGetStrProc);
 var
   aList:tstringlist;
   i:integer;
 begin
   alist:=TStringlist((GetComponent(0) as TATShell).EnumAllAssoc);
   try
     for i:=0 to alist.count-1 do
       Proc(alist[i]);
  { Proc('.txt');
   Proc('.dfm');
   Proc('.pas');
   Proc('.bmp');
   Proc('.gif');
   Proc('.jpg');
   Proc('.jpeg');
   Proc('.exe');
   Proc('.htm');
   Proc('.html');
   Proc('.rtf');
   Proc('.doc');
   Proc('.inf');
   Proc('.zip');  }
   finally
    alist.free;
   end;
 end;

 {***************************************************************************}
{ TShellCommandsProperty  Editor for ShellCommands property field declarations                                                  }
{***************************************************************************}

   // This  property editor displays the ShellCommands Dialog box
   // for easy adding and removing of fields in the Shell Commands field
   // This field is similar to the commondialog filter field and uses the same
   // format of sepporating the fields in a string using "|" and ";"
Type
   TShellCommandsProperty = class(TStringProperty)
     public
      function GetAttributes: TPropertyAttributes; override;
      procedure Edit; override;
   end;

{***************************************************************************}
{ TShellCommandsProperty.GetAttributes                                      }
{***************************************************************************}
function TShellCommandsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog]+[paReadOnly];
end;

{***************************************************************************}
{ TShellCommandsProperty.Edit                                               }
{***************************************************************************}
procedure TShellCommandsProperty.Edit;
var
  EditDlg: TShellCommandsDlg;
begin
  EditDlg := TShellCommandsDlg.Create(Application);
  try
    EditDlg.SetShellCommandList(GetStrValue);
    if EditDlg.ShowModal = mrOk then begin
     begin
       SetStrValue(EditDlg.ShellCommandList);
       Designer.Modified;
     end;
    end;
  finally
    EditDlg.Free;
  end;
end;

{***************************************************************************}
{ TCEATShell  specialized component editor for ATShell                      }
{***************************************************************************}

  // As ATShell is a specialty component it defines it's own component editor
  // This component editor is extended to add verb commands to delphi's
  // right click popup menu when ATShell is right clicked.
  // This allows testing of some of ATShells methods in design mode.
  // The menuitems added display the components aboutbox and allow
  // creating or removing associations in design mode
  // If you change the methods do not break the error checking.
  type
   TCEATShell = class (TComponentEditor)
     procedure SetAssociationToProject;virtual;   // Set properties to reflect project
     procedure CreateAssociation; virtual;        //Creates an association in design mode
     procedure DeleteAssociation; virtual;       // Removes association from system
     procedure DisconnectAssociation; virtual;   // Only unassociates extension
     function GetVerbCount: integer; override;
     function GetVerb(Index: integer):string; override;
     procedure ExecuteVerb(Index: integer); override;
   end;

{***************************************************************************}
{ TCEATShell.GetVerbCount   returns number of design mode popup menuitems   }
{***************************************************************************}
function TCEATShell.GetVerbCount:integer;
begin
  Result:= inherited GetVerbCount + 5;
end;

{***************************************************************************}
{ TCEATShell.GetVerb     adds menuitems to design mode popup menu           }
{***************************************************************************}
function TCEATShell.GetVerb(Index:integer):string;
begin
  if index < inherited GetVerbCount then
     Result:= inherited GetVerb(index)
  else
   begin
    if index = inherited GetVerbCount then
     Result:= '&About ATShell ...';
    if index = inherited GetVerbCount+1 then
     Result:= '&Set Association to Project';
    if index = inherited GetVerbCount+2 then
     Result:= '&Create Association';
    if index = inherited GetVerbCount+3 then
     Result:= '&Delete Association';
    if index = inherited GetVerbCount+4 then
     Result:= '&Disconnect Association';
   end;
end;

{***********************************************************************************}
{ TCEATShell.ExecuteVerb  determines which method to execute for selected menuitem  }
{***********************************************************************************}
procedure TCEATShell.ExecuteVerb(Index:Integer);
begin
  case index of
    0:
    MessageDlg('ATShell version '+Version+#13#10#13#10+'Coauthored by '+#13#10+
      '      Almer.S. Tigelaar - '+'http://www.cpages.dynip.com/almer'+#13#10+
      '      Dale (Stryder) Clarke - '+'http://www.multiboard.com/~stryder'+#13#10#13#10+
      'This component is copyrighted FREEWARE.'+#13#10+
      'You are using this component entirely at your own risk.',
      mtInformation, [mbOk],0);
    1:SetAssociationToProject;
    2:CreateAssociation;
    3:DeleteAssociation;
    4:DisconnectAssociation;
   end; {of case index}
end;

{***********************************************************************************}
{ TCEATShell.SetAssociationToProject  method                                        }
{***********************************************************************************}
procedure TCEATShell.SetAssociationToProject;
var
  s:string;
  i:integer;
begin
  if assigned(ToolServices) then
   begin
    s:=ToolServices.GetProjectName;
    s:=ChangeFileExt(s,'.exe');
    (component as TATShell).PathToApp:=s;
    (component as TATShell).IconPath:=s;
    s:=sysutils.extractfilename(s);  // get projects filename
    i:=(length(s)-pos('.',s))+1;   // find period
    s:=system.copy(s,1,length(s)-i);   // remove extension
    (component as TATShell).KeyName:=s;     // set TypeName to new name
    (component as TATShell).TypeName:=s+' File';    // set TypeName to new name
    Designer.Modified;
    // trick to have object inspecter to become active
    postmessage(FindWindow('TAppBuilder',nil),wm_KeyDown, VK_F11, 0);
   end
  else
    messageDlg('Could not access the Tool Services API''s to execute this verb',
        mtinformation,[mbOk],0);
end;

{*************************************************************************************}
{ TCEATShell.CreateAssociation  method                                                }
{ If the association exists then prompts to update or displays why it can't be created}
{*************************************************************************************}
procedure TCEATShell.CreateAssociation; //Creates an association in design mode
var
  ErrorMsg,s:string;
begin
  if (component as TATShell).FieldsAreValid then
   begin
    if ((component as TATShell).AssociationExists = '') then
       (component as TATShell).CreateAssociation
    else
     begin
        if messageDlg('Are you sure you wish to UPDATE the "'+(component as TATShell).ReadType+
            '" association.' ,mtconfirmation,[mbOk,mbCancel],0)= idCancel then
              exit; // exeit and don't update component
        (component as TATShell).CreateAssociation
    end;
   end
  else
   begin
      ErrorMsg:='';
      if ((component as TATShell).FExt='') or ((component as TATShell).FExt='.') then
        ErrorMsg:=ErrorMsg+'Extension can not be empty.'+#13#10;
      if (component as TATShell).FKey='' then
        ErrorMsg:=ErrorMsg+'Key Name can not be empty.'+#13#10;
       if (component as TATShell).FIcon='' then
        ErrorMsg:=ErrorMsg+'Icon Path can not be empty.'+#13#10;
       if (component as TATShell).FType='' then
        ErrorMsg:=ErrorMsg+'File Type can not be empty.'+#13#10;
       if not fileexists((component as TATShell).FPath) then
        begin
         ErrorMsg:=ErrorMsg+'Path to Application does not exist.'+#13#10;
         if assigned(ToolServices) then
           begin
             s:=ToolServices.GetProjectName;
             if uppercase((component as TATShell).PathToApp) = uppercase(ChangeFileExt(s,'.exe')) then
              begin
               // The project has not been compiled yet :-)
               if messageDlg('Project has not been compiled yet.'+#13#10#13#10+
                 'Do you wish to compile the project and create valid PathToApp executable.' ,
                     mtconfirmation,[mbYes,mbNo],0)= idYes then
                           // trick to have object inspecter to become active
                     postmessage(FindWindow('TAppBuilder',nil),wm_KeyDown, VK_F9, 0);
             end
             else
                messageDlg('Not all required properties to create this association are valid.'+#13#10#13#10+
                   ErrorMsg ,mterror,[mbOk],0);
          end
          else
             messageDlg('Not all required properties to create this association are valid.'+#13#10#13#10+
                ErrorMsg ,mterror,[mbOk],0);
         end
       else
         messageDlg('Not all required properties to create this association are valid.'+#13#10#13#10+
            ErrorMsg ,mterror,[mbOk],0);
    exit; // exit with out changing fields
   end;
   // Make sure component displays the same information as registry
  (component as TATShell).GetAssociation;
  Designer.Modified;
end;

{*************************************************************************************}
{ TCEATShell.DeleteAssociation  method                                                }
{ Displays executions result to programmer                                            }
{*************************************************************************************}
procedure TCEATShell.DeleteAssociation; // Removes association from system
var
  s1,s2,s3:string;
begin
    s3:=(component as TATShell).AssociationExists;
    if s3 <> '' then
     begin
        s1:=(component as TATShell).Extension;
        s2:=(component as TATShell).ReadType;
        if messageDlg('Are you sure you wish to DELETE the "'+s2+
            '" association.' +#13#10#13#10+'Other associations besides "'+s1+
               '" may require the "'+s2+'" registry entry to function properly.',
                             mtconfirmation,[mbOk,mbCancel],0)= idOk then
           begin
              if (component as TATShell).RemoveAssociation(true,true) then
               begin
                 messageDlg('Registry entries for files with extension "'+s1+
                      '" and "'+s3+'" have been DELETED.' ,mtconfirmation,[mbOk],0);
                 (component as TATShell).Extension:='';  // clear components properties
                 (component as TATShell).Extension:=s1;  //set properties to current extension
                 Designer.Modified;
               end
              else
                messageDlg('The association between files with extension "'+s1+
               '" and "'+s3+'" could not be deleted.' ,mterror,[mbOk],0)
           end;
     end
   else
     messageDlg('Can not delete a association that does not exist yet.' ,mterror,[mbOk],0);
end;

{*************************************************************************************}
{ TCEATShell.DisconnectAssociation  method                                            }
{ Displays executions result to programmer                                            }
{*************************************************************************************}
procedure TCEATShell.DisconnectAssociation; // Only unassociates extension
var
  s1,s2,s3:string;
begin
    s3:=(component as TATShell).AssociationExists;
    if s3 <> '' then
     begin
        s1:=(component as TATShell).Extension;
        s2:=(component as TATShell).ReadType;
       if messageDlg('Are you sure you wish to DISCONNECT the "'+s2+
                          '" association.',mtconfirmation,[mbOk,mbCancel],0)= idOk then
           begin
              if (component as TATShell).RemoveAssociation(false,true) then
                begin
                   messageDlg('Files with extension "'+s1+
                     '" are nolonger associated with "'+s3+'".' ,mtconfirmation,[mbOk],0);
                 (component as TATShell).Extension:='';  // clear components properties
                 (component as TATShell).Extension:=s1;  //set properties to current extension
                 Designer.Modified;
                end
              else
                messageDlg('The association between files with extension "'+s1+
               '" and "'+s3+'" could not be disconnected.' ,mterror,[mbOk],0)
           end;
     end
   else
     messageDlg('Can not disconnect a association that does not exist yet.' ,mterror,[mbOk],0);
end;

{*************************************************************************************}
{ Register ATShell, ATShell Property Editors, and ATShell Component Editor in VCL     }
{*************************************************************************************}
procedure Register;
begin
  RegisterComponents('Upgrade Suite', [TATShell]);
   RegisterPropertyEditor(TypeInfo(string), TATShell, 'ShellCommands',
  	TShellCommandsProperty);
   RegisterPropertyEditor(TypeInfo(string), TATShell, 'Extension',
  	TAssocExtProperty);
   RegisterComponentEditor(TATShell,TCEATShell);
end;

end.
