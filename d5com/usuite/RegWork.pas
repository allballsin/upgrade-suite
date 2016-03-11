(*
Copyright (c) 1996 Stryder Software Development
 All rights reserved by Dale Clarke

 This unit is freeware and can be used in any way you wish. I use this
 code in all projects that require accessing the widows registry. You
 use this code at your own risk. I will not be responsible for any
 damages or los of revenue from the use of this unit.

To Use this Unit:
    If recieved from my web site then remove or comment the first line
    and save to your Delphi/Lib directory. Add RegWork to the Uses Statment
    in the calling unit.

 This unit wraps tRegistry and Win 32 API's to create a easy registry
 managment unit. You must already have the Registry.pas unit in your
 Delphi/Lib directory to use this unit. Registry.pas can be obtained
 on the internet by doing a search for TRegistry as the key word.


 *)
unit RegWork;
interface

Uses  SysUtils,Windows,Classes;
{
  Notes


    Mainkey must be one of the following root registry keys

       eg.
              HKEY_LOCAL_MACHINE
              HKEY_CURRENT_USER   ect.

   aKey and aItem are the registry nodes you wish to reference
         eg.    akey := '/SOFTWARE/MySoftware/Window Position';
      This string must begin with a slash and end with no slash.

   aValue and aDefault is the value of the key you wish to change.

   aList is a tStringlist that you must create before calling the
         method and you must free after calling the method. aList
         will return containing the names of all subkeys of aKey.

      eg.

      procedure MyWindow.LoadSize;
        var
          MyList:tStringlist;
          i:integer;
       const
          MyKey:string='/SOFTWARE/Your Software/MyWindow Size';
          RootKey:cardinal=HKEY_CURRENT_USER;
       begin
          MuList:=tstringList.create;
          if GetRegSubTree(RootKey,MyList,MyKey) then
            begin
              for i:=0 to pred(MyList.count) do
                begin
                   if MyList[i] = 'Left' then
                      SaveIntToRegistry(RootKey,MyKey+'/'+MyList[i],Left);
                   if MyList[i] = 'Right' then
                      SaveIntToRegistry(RootKey,MyKey+'/'+MyList[i],Right);
                   if MyList[i] = 'Top' then
                      SaveIntToRegistry(RootKey,MyKey+'/'+MyList[i],Top);
                   if MyList[i] = 'Height' then
                      SaveIntToRegistry(RootKey,MyKey+'/'+MyList[i],Height);
                end;
            end;
          MyList.Free;
       end;


      procedure MyWindow.SaveSize;
        var
          MyList:tStringlist;
          i:integer;
       const
          MyKey:string='/SOFTWARE/Your Software/MyWindow Size';
          RootKey:cardinal=HKEY_CURRENT_USER;
       begin
          MuList:=tstringList.create;
          GetRegSubTree(RootKey,MyList,MyKey);
          if MyList.count > 0 then
            begin
              for i:=0 to pred(MyList.count) do
                begin
                   if MyList[i] = 'Left' then
                      Left:=LoadIntToRegistry(RootKey,MyKey+'/'+MyList[i],Left);
                   if MyList[i] = 'Right' then
                      Right:=LoadIntToRegistry(RootKey,MyKey+'/'+MyList[i],Right);
                   if MyList[i] = 'Top' then
                      Top:=LoadToRegistry(RootKey,MyKey+'/'+MyList[i],Top);
                   if MyList[i] = 'Height' then
                      Height:=LoadIntToRegistry(RootKey,MyKey+'/'+MyList[i],Height);
                end;
            end;
          MyList.Free;
       end;

 You do not have to enumerate the keys but I thought the above two examples
 would help if you wish to for some reason.

   The above examples could alse be safely done with

      procedure MyWindow.LoadSize;
        var
          MyKey:String;
          RootKey:cardinal;
       Begin
          MyKey:='/SOFTWARE/Your Software/MyWindow Size';
          RootKey:=HKEY_CURRENT_USER;
          SaveIntToRegistry(RootKey,MyKey+'/Left',Left);
          SaveIntToRegistry(RootKey,MyKey+'/Right',Right);
          SaveIntToRegistry(RootKey,MyKey+'/Top',Top);
          SaveIntToRegistry(RootKey,MyKey+'/Height',Height);
       end;


      procedure MyWindow.SaveSize;
        var
          MyKey:String;
          RootKey:cardinal;
       Begin
          MyKey:='/SOFTWARE/Your Software/MyWindow Size';
          RootKey:=HKEY_CURRENT_USER;
          Left:=LoadIntToRegistry(RootKey,MyKey+'/Left',Left);
          Right:=LoadIntToRegistry(RootKey,MyKey+'/Right',Right);
          Top:=LoadToRegistry(RootKey,MyKey+'/Top',Top);
          Height:=LoadIntToRegistry(RootKey,MyKey+'/Height',Height);
       end;



 The Save and Change methods will create the key and set its values if they do
 not exists.

 The Load methods will return the value of aValue if the key does not exists.

 The GetRegSubTree will return false if aKey does not exists.

 If you have any questions about using the registry in Delphi you can contact
 me through EMail at the following:

                 stryder@.multiboard.com
                         or
                 stryder@bbs.multiboard.com

     or my Web page at   http://www.multiboard.com/~stryder

 }

function SaveIntToRegistry(MainKey:cardinal;RegistryKey,aItem:string;aValue:integer):boolean;
function LoadIntFromRegistry(MainKey:cardinal;RegistryKey,aItem:string;aValue:integer):integer;
function SaveStrToRegistry(MainKey:cardinal;RegistryKey,aItem:string;aValue:string):boolean;
function LoadStrFromRegistry(MainKey:cardinal;RegistryKey,aItem:string;aValue:string):string;
function SaveBoolToRegistry(MainKey:cardinal;RegistryKey,aItem:string;aValue:boolean):boolean;
function LoadBoolFromRegistry(MainKey:cardinal;RegistryKey,aItem:string;aValue:boolean):boolean;
{Deletes a key with and subkeys on win95}
function DeleteRegKey(MainKey:cardinal;aKey:string):boolean;
{Deletes a key with and subkeys on win95/NT}
function NTDeleteRegKey(MainKey:cardinal;const aKey:string):boolean;
{Sets a stringlist with all subkeys}
function  GetRegSubTree( MainKey : cardinal; var aList : TStringList; aKey :
string ) : Boolean;


{The following methods return or set the default key values}
procedure ChangeRegistryInt( mainKey:cardinal; aKey : String; aValue : cardinal );
procedure ChangeRegistryStr( mainKey:cardinal; aKey : String; aValue : String );
procedure ChangeRegistryBool( mainKey:cardinal; aKey : String; aValue : boolean );

function GetRegistryStr( mainKey:cardinal; aKey : String; Default : String ):string;
function  GetRegistryInt( mainKey:cardinal;aKey : String; Default : Integer ) : Integer;
function GetRegistryBool( MainKey:cardinal;aKey : String; Default :boolean ):boolean;

function RegistryKeyExists(Mainkey:cardinal;aKey:string): boolean;


implementation
Uses Registry;
//  Writen by Dale (stryder) Clarke
// This function sets the default value of the key to a string.
procedure ChangeRegistryStr( mainKey:cardinal; aKey : String; aValue : String );
Var
   szKey, szValue   : PChar;
begin
  szKey := StrAlloc( Length( aKey ) + 1 );
  szValue := StrAlloc( Length( aValue ) + 1 );
  StrPCopy( szKey, aKey );
  StrPCopy( szValue, aValue );
  RegSetValue( MainKey, szKey, REG_SZ, szValue, StrLen( szValue ));
  StrDispose( szKey );
  StrDispose( szValue );
end;

//  Writen by Dale (stryder) Clarke
// This function sets the default value of the key to a boolean.
procedure ChangeRegistryBool( mainKey:cardinal; aKey : String; aValue : boolean );
Var
   szKey, szValue   : PChar;
   BoolStr:string;
begin
  if avalue=TRUE then
     BoolStr:='TRUE'
   else
     BoolStr:='FALSE';
  szKey := StrAlloc( Length( aKey ) + 1 );
  szValue := StrAlloc( Length( BoolStr ) + 1 );
  StrPCopy( szKey, aKey );
  StrPCopy( szValue, BoolStr );
  RegSetValue( MainKey, szKey, REG_SZ, szValue, StrLen( szValue ));
  StrDispose( szKey );
  StrDispose( szValue );
end;

//  Writen by Dale (stryder) Clarke
// This function sets the default value of the key to a integer.
procedure ChangeRegistryInt( mainKey:cardinal; aKey : String; aValue : cardinal );
Var
   szKey, szValue   : PChar;
   IntegerStr:string;
begin
  IntegerStr:=intToStr(avalue);
  szKey := StrAlloc( Length( aKey ) + 1 );
  szValue := StrAlloc( Length( IntegerStr ) + 1 );
  StrPCopy( szKey, aKey );
  StrPCopy( szValue, IntegerStr );
  RegSetValue( MainKey, szKey, REG_SZ, szValue, StrLen( szValue ));
  StrDispose( szKey );
  StrDispose( szValue );
end;

//  Writen by Dale (stryder) Clarke
// This function returns a string value for the given key if the key does not exist
// the key will be created with the default value.
function GetRegistryStr( MainKey:cardinal;aKey : String; Default :String ):string;
Var
   szKey, szValue   : PChar;
   nRet      : integer;
   nsize:integer;
begin
  szKey := StrAlloc( Length( aKey ) + 1 );
  szValue := StrAlloc( 1000 );
  StrPCopy( szKey, aKey );
  StrPCopy( szValue, '' );
  nSize := 1000;
  nRet := RegQueryValue( MainKey, szKey, szValue, nSize );
  if (nRet = ERROR_SUCCESS) then
     result := StrPas( szValue )
    else
     result := Default;
  StrDispose( szKey );
  StrDispose( szValue );
end;

//  Writen by Dale (stryder) Clarke
// This function returns a boolean value for the given key if the key does not exist
// the key will be created with the default value.
function GetRegistryBool( MainKey:cardinal;aKey : String; Default :boolean ):boolean;
Var
   BoolStr:string;
   szKey, szValue   : PChar;
   nRet, nSize      : integer;
begin
  if default=TRUE then
     BoolStr:='TRUE'
   else
     BoolStr:='FALSE';
  szKey := StrAlloc( Length( aKey ) + 1 );
  szValue := StrAlloc( 1000 );
  StrPCopy( szKey, aKey );
  StrPCopy( szValue, BoolStr );
  nSize := 1000;
  nRet := RegQueryValue( MainKey, szKey, szValue, nSize );
  if (nRet = ERROR_SUCCESS) then
     begin
       boolStr := StrPas( szValue );
       if BoolStr='TRUE' then
         result:=true
       else
         result:=false;
     end
    else
     result := Default;
  StrDispose( szKey );
  StrDispose( szValue );
end;

//  Writen by Dale (stryder) Clarke
// This function returns a integer value for the given key if the key does not exist
// the key will be created with the default value.
function GetRegistryInt( MainKey:cardinal;aKey : String; Default : Integer ) : Integer;
Var
   szKey, szValue   : PChar;
   aString          : String;
   nRet, nSize      : integer;
begin
  szKey := StrAlloc( Length( aKey ) + 1 );
  szValue := StrAlloc( 32 );
  StrPCopy( szKey, aKey );
  nSize := 32;
  nRet := RegQueryValue( MainKey, szKey, szValue, nSize );
  aString := StrPas( szValue );
  StrDispose( szKey );
  StrDispose( szValue );
  if (nRet = ERROR_SUCCESS) then
     GetRegistryInt := StrToInt( aString )
    else
     GetRegistryInt := Default;
end;

//  Writen by Dale (stryder) Clarke
// This function returns a stringlist of names of a valid
// registration key. You can yous this to recursivly look for
// more subkeys. Remember to always pass a initialized stringlist
// and to free it yourself.
function GetRegSubTree( MainKey : cardinal; var aList : TStringList; aKey :
string ) : Boolean;
var
  hRoot          : HKEY;
  lItem          : cardinal;
  hError         : cardinal;
  szKey,pData          : PChar;
  aString        : String;

begin
   GetRegSubTree:=false;
   if aList=Nil then exit;
 {create pointers for the API}
  szKey := StrAlloc( Length( aKey ) + 1 );
  StrPCopy( szKey, aKey );
  lItem := 0;
  pData := StrAlloc( 1024 );

  hError := RegOpenKey( MainKey, szKey, hRoot );
  if hError = ERROR_SUCCESS then
  begin
     while (hError = ERROR_SUCCESS) do
     begin
        hError := RegEnumKey( hRoot, lItem, pData, 1024 );
        if (hError = ERROR_SUCCESS) then
        begin
           GetRegSubTree:=true;
           aList.Add( StrPas( pData ));
           Inc(lItem);
        end;
     end;
     RegCloseKey( hRoot );
  end;
  StrDispose( szKey );
  StrDispose( pData );
end;


//  Writen by Dale (stryder) Clarke
//  On Win 95 this removes all subkeys but on NT the key is
//  only removed if it has NO subkeys.  So always call NTDeleteRegKey
//  so if this fails it will recursively remove the keys.
function DeleteRegKey(MainKey:cardinal;aKey:string):boolean;
var
  szKey          : PChar;
begin
 {RegDeletKey API wants a pointer}
  szKey := StrAlloc( Length( aKey ) + 1 );
  StrPCopy( szKey, aKey );
// Let windows remove the subkey's safely by bypassing VCL
// This call is exported in the winreg unit to a call to the ADVAPI.DLL
// I have never encounter a exception here but better safe than sorry.
// Mickey may change the API (as if they've done that before)
try
  result:=(RegDeleteKey(MainKey,szKey) = ERROR_SUCCESS);
 finally
  StrDispose( szKey );  {make sure pointer is free when exit}
 end;
end;

//  Writen by Dale (stryder) Clarke
//  This function is extreemly dangerous. The key specified and all subkeys WILL be removed.
//  Especially DO NOT pass the string SOFTWARE or anyother important registry root folder.
//  On NT RegDeleteKey will not remove a key if it has subkeys.
//  This function will remove all sukeys on NT
function NTDeleteRegKey(MainKey:cardinal;const aKey:string):boolean;
var
  aList:TstringList;
  s:string;
  i:integer;
begin
  alist:=TStringlist.create;
try
   s:=aKey;
   if GetRegSubTree(MainKey,aList,aKey) then   {check for subkeys}
     begin
       for i:= 0 to alist.count-1 do
          begin
            NTDeleteRegKey(MainKey,s+'\'+alist[i]);  {recurse to look for more subkeys}
            result:= DeleteRegKey(MainKey,s); {no subkeys so delete}
          end;  
     end
   else
     if RegistryKeyExists(MainKey,s) then
       result:= DeleteRegKey(MainKey,s); {no subkeys so delete}
finally
  aList.Free;
  result := not RegistryKeyExists(MainKey,s); // return is allways correct
end;

end;

//  Writen by Dale (stryder) Clarke
// This function saves a string to a registry key.
function SaveIntToRegistry(MainKey:cardinal;RegistryKey,aItem:string;aValue:integer):boolean;
var
  RegVar: TRegistry;
begin
    result:=false;
    RegVar := TRegistry.Create;
    RegVar.RootKey := MainKey;
    try
      if RegVar.OpenKey( RegistryKey, True ) then
      begin
        RegVar.WriteInteger( aItem, aValue );
        result:=true;
      end;
    finally
      RegVar.Free;
    end;
end;

//  Writen by Dale (stryder) Clarke
// This function returns a integer from a registry key.
function LoadIntFromRegistry(MainKey:cardinal;RegistryKey,aItem:string;aValue:integer):integer;
var
  RegVar: TRegistry;

begin
    result:=avalue;
    RegVar := TRegistry.Create;
    RegVar.RootKey := MainKey;
    try
      if RegVar.OpenKey( RegistryKey, True ) then begin
        if RegVar.ValueExists( aItem ) then
         begin
          result := RegVar.ReadInteger( aItem );
          end;
      end;
    finally
      RegVar.Free;
    end;
end;

//  Writen by Dale (stryder) Clarke
// This function saves a string to a registry key.
function SaveStrToRegistry(MainKey:cardinal;RegistryKey,aItem:string;aValue:string):boolean;
var
  RegVar: TRegistry;
begin
    result:=false;
    RegVar := TRegistry.Create;
    RegVar.RootKey := MainKey;
    try
      if RegVar.OpenKey( RegistryKey, True ) then begin
        RegVar.Writestring( aItem, aValue );
        result:=true;
      end;
    finally
      RegVar.Free;
    end;
end;

//  Writen by Dale (stryder) Clarke
// This function returs a string from a registry key.
function LoadStrFromRegistry(MainKey:cardinal;RegistryKey,aItem:string;aValue:string):string;
var
  RegVar: TRegistry;
begin
    result:=avalue;
    RegVar := TRegistry.Create;
    RegVar.RootKey := MainKey;
    try
      if RegVar.OpenKey( RegistryKey, True ) then begin
        if RegVar.ValueExists( aItem ) then
          begin
          result := RegVar.ReadString( aItem );
         end;
      end;
    finally
      RegVar.Free;
    end;
end;

//  Writen by Dale (stryder) Clarke
// This function saves a boolean to a registry key.
function SaveBoolToRegistry(MainKey:cardinal;RegistryKey,aItem:string;aValue:boolean):boolean;
var
  RegVar: TRegistry;
begin
    result:=false;
    RegVar := TRegistry.Create;
    RegVar.RootKey := MainKey;
    try
      if RegVar.OpenKey( RegistryKey, True ) then begin
        RegVar.WriteBool( aItem, aValue );
        result:=true;
      end;
    finally
      RegVar.Free;
    end;
end;

//  Writen by Dale (stryder) Clarke
// This function returns a boolean from a registry key.
function LoadBoolFromRegistry(MainKey:cardinal;RegistryKey,aItem:string;aValue:boolean):boolean;
var
  RegVar: TRegistry;

begin
    Result:=avalue;
    RegVar := TRegistry.Create;
    RegVar.RootKey := MainKey;
    try
      if RegVar.OpenKey( RegistryKey, True ) then begin
        if RegVar.ValueExists( aItem ) then
         begin
          result := RegVar.ReadBool( aItem );
         end;
      end;

    finally
      RegVar.Free;
    end;
end;

{************************************************************
The following method was written by Almer.S. Tigelaar .
I have included it because I don't see any other way to
check a key with out creating it.
**************************************************************}
function RegistryKeyExists(Mainkey:cardinal; aKey:string): boolean;
var
  AReg : TRegistry;
begin
  result:=false;
  AReg := TRegistry.Create;
 try
   AReg.RootKey:=Mainkey;
     result:= AReg.OpenKey(aKey,false);
 finally
  AReg.free;
 end;
end;

end.


