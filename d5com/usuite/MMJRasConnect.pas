(*This component is created with great help from Davide Moretti dave@rimini.com
  and his ras.pas, translation of ras.h
  I'm currently writing an internet counter application, and I needed a component that will
  notify me when certain events occur that are related to ras connection. So I implemented
  OnConnectionStatus event that gets fired when any of the TCStatus=
  (connecting,authenticate,connected,disconnected) events happent, for the first time.
   There is also a OnStatusChange event that lets you display all connection status
   related information.
   When the component is created it fills the AvailableConnections
   StringList, and you can choose one of them to dial in two ways:
   DialEntryByInd-->you pass AvailableEntries.Strings[index] as parametar
   DialEntryByStr-->you pass a string that represents EntryName as parametar.
   There is a Language property, which affects which members of Stats array are to
   be processed as status messages. You are free to change croatian strings with
   ones in language of your own. This is not a commercial component, so I didn't
   include other langiages.
   ConnectedEntry property stores just one Entry, but if you have abilities to have
   more then one connected entries at a time, in impelmentation of EnumerateConnectedEntries
   function there is a conEntries: Array[1..20] of TRasConn, that stores up to 20
   entries, so change the property ConnectedEntry accordingly.
   Status property stores the connection status, which is one of stats array strings
   at a time.
   Feel free to modify the code to your own likings, but please mention me and David Moretti,

   Happy Programming

   Mihaela Mihaljevic Jakic

   mihaela.mihaljevic-jakic@zg.teh.hr
   Delphi Rulez, visit me on
   http://www.geocities.com/SiliconValley/Horizon/3229/index.html
   You may page me on:
   http://wwp.mirabilis.com/9842704

   *)



unit MMJRasConnect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Ras,
   stdCtrls,extCtrls;
const
   Stats : array[1..22] of string[60] =
   ('Opening comm port',
    'Otvaranje komunikacijskog porta',
    'Comm port opened',
    'Komunikacijski port je otvoren',
    'A device is about to be connected',
    'Spajamo se na mrežu',
    'A device has connected successfully',
    'Ureðaj se uspješno spojio',
    'All devices in the device chain have successfully connected',
    'Svi ureðaji su se uspješno spojili',
    'The authentication process is starting',
    'Poèinje provjera podataka',
    'User authentication is being initiated or retried', //win95 only
    'Poèinje provjera podataka',
    'The client has successfully completed authentication',
    'Podaci su provjereni',
    'Client is logging on to the network',              //win95 only
    'Logiranje na mrežu',                                //win95 only
    'Connected succesfully',
    'Spojeni smo',
    'Disconnected or failed connection',
    'Nismo spojeni');

type
  TCStatus=(connecting,authenticate,connected,disconnected);
  TConnectionStatusEvent = procedure(Sender :TObject;  status:TCStatus) of Object;
  //This is custom event that monitors the change of FStatus string
  //so that you can display connection status information, from Stats array
  //the moment they happen, and don't have to invoke them by other events
  TStausChangeEvent = procedure(Sender :TObject; StatusChanged:Boolean) of Object;
  TLanguage =(english, croatian);
  TCStatusType = record
     stat: TCStatus;
     count : longint;
  end;
  TMMJRasConnect = class(TComponent)
  private
    { Private declarations }
    FDoTimer : Boolean;
    FAvailableEntries : TStrings;
    FAvailableNumbers : TStrings;
    FConnectedNumber : string;
    FOwnerFormHandle :hWnd;//Needed for EditEntry procedure
    FConnectedEntry:string;//Presume it will be only one,(who wants to live forever)
    FIsConnected : Boolean;
    FStatusChanged : Boolean;
    FLanguage : TLanguage;
    FTimer :TTimer;  //To check for connection
    FNumEntries :LongInt;
    FOnConnectionStatus : TConnectionStatusEvent;
    FOnStatusChange :  TStausChangeEvent;
    FStatus : string;
    FCStatus :TCStatusType;
    function  EnumerateEntries:Integer;
    function  EnumerateConnectedEntries:String;
    function  GetEntryNumber(Name: string):string;
    procedure SetLanguage(Value: TLanguage);
    procedure DialEntry(EntryName:string);
    procedure EditEntry(Name:string);
    procedure GetAvailableNumbers(FAvailableEntries:TStrings);
    procedure DeleteEntry(Name:string);
    function  GetConnectedNumber:string;
    procedure SetDoTimer(Value : Boolean);
  protected
    { Protected declarations }
    procedure ExecuteTimer(Sender :TObject);dynamic; { Timer event }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure DialEntryByInd(ind : integer);
    procedure DialEntryByStr(Name:string);
    procedure EditEntryByInd(ind : integer);
    procedure EditEntryByStr(Name:string);
    procedure DeleteEntryByInd(ind : integer);
    procedure DeleteEntryByStr(Name:string);
    procedure NewEntry;

  published
    { Published declarations }
     property AvailableEntries : TStrings
        read FAvailableEntries;
     property AvailableNumbers : TStrings
        read FAvailableNumbers;
     property ConnectedEntry : string
        read FConnectedEntry;
     property ConnectedNumber : string
        read FConnectedNumber;
     property Status : string
        read FStatus;
     property IsConnected : Boolean
        read FIsConnected;
     property OnConnectionStatus : TConnectionStatusEvent
        read  FOnConnectionStatus
        write FOnConnectionStatus;
     property OnStatusChange :  TStausChangeEvent
        read FOnStatusChange
        write FOnStatusChange;
     property Language : TLanguage
        read FLanguage
        write SetLanguage;
     property DoTimer : Boolean
        read FDoTimer
        write SetDoTimer;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TMMJRasConnect]);
end;

function TMMJRasConnect.GetConnectedNumber:string;
var
   i:integer;
begin
   result:='';
   if FConnectedEntry='' then Exit
   else if FConnectedEntry<>'' then begin
      if FAvailableNumbers.Count = 0 then Exit;
      for i:= 0 to FAvailableNumbers.Count-1 do begin
         if FAvailableEntries.Strings[i] = FConnectedEntry then
            result:=FAvailableNumbers[i];
      end;
   end;
end;


constructor TMMJRasConnect.Create(AOwner:TComponent);
var
   i:integer;
begin
   inherited Create(AOwner);

   //First check if Owner is TForm
   if not (AOwner is TForm) then
      Raise Exception.Create('Please drop the component onto a Form!');

  { then check, if this component is already on the form.}
   for i:=0 to TForm(AOwner).ComponentCount-1 do begin
      if (TForm(AOwner).Components[i].Classtype=TMMJRasConnect)
         and (TForm(AOwner).Components[i]<>Self) then begin
         { if a component exists then don't of a new one }
            Raise Exception.Create('There is TMMJRasConnect component already on this form');
         end;
   end;

   FOwnerFormHandle:=TForm(AOwner).Handle;
   FIsConnected:=False;
   FStatusChanged :=False;
   FAvailableEntries:=TStringList.Create;
   FAvailableNumbers := TStringList.Create;
   FConnectedNumber :='';;
   FConnectedEntry:='';
   FNumEntries:=0;
   FStatus:='';
   FCStatus.Stat:=Disconnected;
   FCStatus.Count:=0;
      //Getting AvailableEntries property and hrasconn handle
   FNumEntries:=EnumerateEntries;
   FLanguage:=Croatian;
   FTimer:=TTimer.Create(Self);
   FTimer.OnTimer := ExecuteTimer;
   FTimer.Enabled:=False;
   FDoTimer:=False;
   FTimer.Interval := 500;
   GetAvailableNumbers(FAvailableEntries);
end;

destructor TMMJRasConnect.Destroy;
begin
//First code
   FAvailableEntries.Free;
   FTimer.Free;
   inherited Destroy;
end;

procedure TMMJRasConnect.SetLanguage(Value: TLanguage);
begin
   if FLanguage<>Value then begin
      FLanguage:=Value;
   end;
end;

procedure TMMJRasConnect.ExecuteTimer(Sender :TObject);
var
   str:string ;
begin
   str:=EnumerateConnectedEntries;
   //Cheking for events
   with FCStatus do begin
      //The event occured for the first time
      if Count = 1 then begin
         if Stat = Connecting then begin
            if Assigned(FOnConnectionStatus) then
               FOnConnectionStatus(Self,Connecting);
         end;
         if Stat = Authenticate then begin
            if Assigned(FOnConnectionStatus) then
               FOnConnectionStatus(Self,Authenticate);
         end;
         if Stat = Connected then begin
            if Assigned(FOnConnectionStatus) then begin
               FOnConnectionStatus(Self,Connected);
            end;
         end;
         if Stat = Disconnected then begin
            if Assigned(FOnConnectionStatus) then
               FOnConnectionStatus(Self,Disconnected);
         end;
      end;
   end;
   if Assigned(FOnStatusChange) then
      FOnStatusChange(Self,FStatusChanged);
end;

function TMMJRasConnect.EnumerateEntries:Integer;
var
   res,i: Integer;
   bufsize: Longint;
   Entries:LPRasEntryName;
begin
  Entries := AllocMem(SizeOf(TRasEntryName));
  Entries^.dwSize := SizeOf(TRasEntryName);
  Bufsize := SizeOf(TRasEntryName);
  res := RasEnumEntries(nil, nil, Entries, bufsize, FnumEntries);
  if res = ERROR_BUFFER_TOO_SMALL then begin
     ReallocMem(Entries, bufSize);
     FillChar(entries^, bufsize, 0);
     Entries^.dwSize := SizeOf(TRasEntryName);
     res := RasEnumEntries(nil, nil, Entries, bufSize, FnumEntries);
  end;
  result:=res;
  //writing AvailableEntries property
   if (res=0) and (FnumEntries >0) then begin
      for i:=0 to FnumEntries-1 do begin
         FAvailableEntries.Add(Entries^.szEntryName);//To access it FAvailableEntries.Strings[index];
         Inc(Entries);
      end;
   end;
end;

function TMMJRasConnect.EnumerateConnectedEntries:String;
var
   conEntries: Array[1..20] of TRasConn;
   Stat: TRasConnStatus;
   bufSize :LongInt;
   numConEntries: Longint;
   rez,i,j,k:integer;
   strStat,str,str2,str3,str4,test:string;
begin
   test:='';
   str2:=''; str3:=''; str4:=''; j:=0;
         if FLanguage = English then
            j:=1
         else if FLanguage = Croatian then
            j:=2;
         k:=j+20;
   result:=Stats[k];
   conEntries[1].dwSize := SizeOf(TRasConn);
   bufSize := SizeOf(TRasConn) * 100;
   FillChar(Stat, Sizeof(TRasConnStatus), 0);
   Stat.dwSize := Sizeof(TRasConnStatus);
   rez:=RasEnumConnections(@conEntries[1], bufSize, numConEntries);
   if (rez = 0) and (numConEntries>0) then begin
      for i := 1 to numConEntries do begin
         if FLanguage = English then
            j:=1
         else if FLanguage = Croatian then
            j:=2;
         k:=j+20;
         with conEntries[i]do begin
            RasGetConnectStatus(hrasconn, Stat);
            case Stat.RasConnState of
               RASCS_OpenPort                  :begin
                                                   strStat:=Stats[j];
                                                   //reseting the counter
                                                   if FCStatus.Stat<>Connecting then
                                                      FCStatus.Count:=0;
                                                   FCStatus.Stat:=Connecting;
                                                   FCStatus.Count:=FCStatus.Count + 1;
                                                end;
               RASCS_PortOpened                :begin
                                                   strStat:=Stats[j+2];
                                                   //reseting the counter
                                                   if FCStatus.Stat<>Connecting then
                                                      FCStatus.Count:=0;
                                                   FCStatus.Stat:=Connecting;
                                                   FCStatus.Count:=FCStatus.Count + 1;
                                                end;
               RASCS_ConnectDevice             :begin
                                                   strStat:=Stats[j+4];
                                                   //reseting the counter
                                                   if FCStatus.Stat<>Connecting then
                                                      FCStatus.Count:=0;
                                                   FCStatus.Stat:=Connecting;
                                                   FCStatus.Count:=FCStatus.Count + 1;
                                                end;
               RASCS_DeviceConnected           :begin
                                                   strStat:=Stats[j+6];
                                                   //reseting the counter
                                                   if FCStatus.Stat<>Connecting then
                                                      FCStatus.Count:=0;
                                                   FCStatus.Stat:=Connecting;
                                                   FCStatus.Count:=FCStatus.Count + 1;
                                                end;
               RASCS_AllDevicesConnected       :begin
                                                   strStat:=Stats[j+8];
                                                   //reseting the counter
                                                   if FCStatus.Stat<>Connecting then
                                                      FCStatus.Count:=0;
                                                   FCStatus.Stat:=Connecting;
                                                   FCStatus.Count:=FCStatus.Count + 1;
                                                end;
               RASCS_Authenticate	       :begin
                                                   strStat:=Stats[j+10];
                                                   //reseting the counter
                                                   if FCStatus.Stat<>Authenticate then
                                                      FCStatus.Count:=0;
                                                   FCStatus.Stat:=Authenticate;
                                                   FCStatus.Count:=FCStatus.Count + 1;
                                                end;
               RASCS_StartAuthentication       :begin
                                                   strStat:=Stats[j+12]; //win95 only
                                                   //reseting the counter
                                                   if FCStatus.Stat<>Authenticate then
                                                      FCStatus.Count:=0;
                                                   FCStatus.Stat:=Authenticate;
                                                   FCStatus.Count:=FCStatus.Count + 1;
                                                end;
               RASCS_Authenticated             :begin
                                                   strStat:=Stats[j+14];
                                                   //reseting the counter
                                                   if FCStatus.Stat<>Authenticate then
                                                      FCStatus.Count:=0;
                                                   FCStatus.Stat:=Authenticate;
                                                   FCStatus.Count:=FCStatus.Count + 1;
                                                end;
               RASCS_LogonNetwork	       :begin
                                                   strStat:=Stats[j+16]; //win 95 only
                                                   //reseting the counter
                                                   if FCStatus.Stat<>Connecting then
                                                      FCStatus.Count:=0;
                                                   FCStatus.Stat:=Connecting;
                                                   FCStatus.Count:=FCStatus.Count + 1;
                                                end;
               RASCS_Connected	               :begin
                                                   strStat:=Stats[j+18];
                                                   //reseting the counter
                                                   if FCStatus.Stat<>Connected then
                                                      FCStatus.Count:=0;
                                                   FCStatus.Stat:=Connected;
                                                   FCStatus.Count:=FCStatus.Count + 1;
                                                   FIsConnected:=True;
                                                end;
               RASCS_Disconnected	       :begin
                                                   strStat:=Stats[j+20];
                                                   //reseting the counter
                                                   if FCStatus.Stat<>Disconnected then
                                                      FCStatus.Count:=0;
                                                   FCStatus.Stat:=Disconnected;
                                                   FCStatus.Count:=FCStatus.Count + 1;
                                                   FIsConnected:=False;
                                                end;
            end;
            str:=strStat ;
            if szDeviceName<>'' then str2:=szDeviceName;
            if szDeviceType<>'' then str3:=szDeviceType;
            if szEntryName<>'' then str4:=szEntryName;
            if str<>'' then str:=str;
         end;
      end;
   end;
   result:=str+' ' + str4+' '+str2+' ' + str3;
   test :=str3+' '+str2+' '+str;
   if FStatus <> test then FStatusChanged:=True
   else FStatusChanged :=False;
   FStatus:=Test;
   FConnectedEntry:=str4;
   FConnectedNumber:=GetConnectedNumber; // szEntryName
   if not((rez = 0) and (numConEntries>0)) then begin
      result:=Stats[k];
      test :=result;
      if FStatus <> test then FStatusChanged:=True
      else FStatusChanged :=False;
      FStatus:=Test;
      FIsConnected:=False;
      FConnectedEntry:='';
      FConnectedNumber:='';
      with FCStatus do begin
      //If disconnected then reset status and counter
         Stat:=Disconnected;
         Count:=0;
      end;
   end;
end;

procedure TMMJRasConnect.DialEntry(EntryName:string);
var
   Text: array[0..255] of char;
begin
   StrPCopy(Text, 'rundll32.exe rnaui.dll,RnaDial ' + EntryName);
   if WinExec(Text,SW_SHOWNORMAL) < 32 then begin
      Exception.Create('Dialing error');
   end;
end;
procedure TMMJRasConnect.SetDoTimer(Value:Boolean);
begin
   if FDoTimer <> Value then
      FDoTimer:=Value;
   FTimer.Enabled:=FDoTimer;
end;
procedure TMMJRasConnect.DialEntryByStr(Name:string);
var
   i:integer;
    Exst:Boolean;
begin
   if FAvailableEntries.Count = 0 then Exit;
//Cheking if given Name exists in FAvailableEntries
   Exst:=False;
   for i:=0 to FAvailableEntries.Count -1 do begin
      if FAvailableEntries.Strings[i]=Name then
         Exst:=True;
   end;
   If FIsConnected then Exst:=False;
   if Exst then DialEntry(Name);
end;

procedure TMMJRasConnect.DialEntryByInd(ind : integer);
var
   txt:string;
begin
   //cheking if there are any entries to dial
   if FAvailableEntries.Count = 0 then Exit;
   if FIsConnected then Exit;
   //Cheking if index is correct
   if ind < 0 then Exit;
   if ind > FAvailableEntries.Count-1 then Exit;
   //Now getting the entry
   txt:=FAvailableEntries.Strings[ind];
   DialEntry(txt);
end;

procedure TMMJRasConnect.EditEntry(Name:string);
var
   txt:string;
begin
   if FLanguage = Croatian then
      txt:='Ne mogu promjeniti podatke o vezi: ' + Name
   else if FLanguage = English then
      txt:='Unable to edit Phonebook Entry: ' + Name;
   if RasEditPhonebookEntry(FOwnerFormHandle, nil,PChar(Name)) <> 0 then
      Exception.Create(txt);
end;

procedure TMMJRasConnect.EditEntryByInd(ind : integer);
var
   txt:string;
begin
   //cheking if there are any entries to dial
   if FAvailableEntries.Count = 0 then Exit;
   //if FIsConnected then Exit;
   //Cheking if index is correct
   if ind < 0 then Exit;
   if ind > FAvailableEntries.Count-1 then Exit;
   //Now getting the entry
   txt:=FAvailableEntries.Strings[ind];
   EditEntry(txt);
end;

procedure TMMJRasConnect.EditEntryByStr(Name:string);
var
   i:integer;
   Exst:Boolean;
begin
   if FAvailableEntries.Count = 0 then Exit;
//Cheking if given Name exists in FAvailableEntries
   Exst:=False;
   for i:=0 to FAvailableEntries.Count -1 do begin
      if FAvailableEntries.Strings[i]=Name then
         Exst:=True;
   end;
   //If FIsConnected then Exst:=False;
   if Exst then EditEntry(Name);
end;


function TMMJRasConnect.GetEntryNumber(Name: string):string;
  var
    Entry: LPRasEntry;
    EntrySize, devinfoSize: Integer;
    txt,number1,number2: string;
    i: Integer;
begin
   result:='';
   if FLanguage = Croatian then
      txt:='Ne mogu dobiti informacije o vezi ' + Name
   else if FLanguage = English then
      txt:='RasGetEntryProperties failed: ' + Name;
   EntrySize := 0;
   DevInfoSize := 0;
   //This call fills the size buffers--> EntrySize & DevInfoSize
  if RasGetEntryProperties(nil, PChar(Name),nil, EntrySize, nil,
     DevInfoSize) <> ERROR_BUFFER_TOO_SMALL then begin
       raise Exception.Create(txt);
       Exit;
  end;
  Entry := AllocMem(EntrySize);
  try
     Entry^.dwSize := SizeOf(TRasEntry);
     //This call fills Entry buffer
     if RasGetEntryProperties(nil, PChar(Name),Entry, EntrySize, nil,
     DevInfoSize) = 0 then begin
        with Entry^ do begin
           number1 := szLocalPhoneNumber;
           number2 := szAreaCode;
        end;
     end;
  finally
     FreeMem(Entry);
  end;
  result:=number1;
end;

procedure TMMJRasConnect.GetAvailableNumbers(FAvailableEntries:TStrings);
var
   i:integer;
   EntryName,Number:string;
begin
   if FAvailableEntries.Count=0 then Exit;
   for i:=0 to FAvailableEntries.Count-1 do begin
      EntryName:=FAvailableEntries.Strings[i];
      Number:=GetEntryNumber(EntryName);
      FAvailableNumbers.Add(Number);
      //inc(FAvailableNumbers);
   end;
end;

procedure TMMJRasConnect.NewEntry;
var
   txt:string;
   ind:integer;
begin
   if FLanguage = Croatian then
      txt:='Ne mogu kreirati novu vezu! '
   else if FLanguage = English then
      txt:='RasCreatePhonebookEntry failed.';
//Creates new entry
  if RasCreatePhonebookEntry(FOwnerFormHandle, nil) = 0 then begin
     FAvailableEntries.Clear;
     FAvailableNumbers.Clear;
     ind:=EnumerateEntries;
     GetAvailableNumbers(FAvailableEntries);
  end
  else
    raise Exception.Create(txt);
end;

procedure TMMJRasConnect.DeleteEntry(Name:string);
var
   txt:string;
   ind : integer;
begin
   if FLanguage = Croatian then
      txt:=Name+': veza æe biti obrisana: Da li ste sigurni? '
   else if FLanguage = English then
      txt:=Name+': connection will be deleted,are you sure? ';

  if Application.MessageBox(PChar(txt), nil,MB_YESNO or MB_ICONWARNING) = IDYES then begin
     if RasDeleteEntry(nil, PChar(Name)) <> 0 then begin
        if FLanguage = Croatian then
           txt:='Ne mogu obrisati vezu: '+Name
        else if FLanguage = English then
           txt:='Unable to delete connection: '+Name;
        raise Exception.Create(txt);
     end
     else begin
        FAvailableEntries.Clear;
        FAvailableNumbers.Clear;
        ind:=EnumerateEntries;
        GetAvailableNumbers(FAvailableEntries);
     end;
  end;
end;

procedure TMMJRasConnect.DeleteEntryByInd(ind : integer);
var
   txt:string;
begin
   //cheking if there are any entries to dial
   if FAvailableEntries.Count = 0 then Exit;
   If (FIsConnected) and (FConnectedEntry=Name) then Exit;
   //Cheking if index is correct
   if ind < 0 then Exit;
   if ind > FAvailableEntries.Count-1 then Exit;
   //Now getting the entry
   txt:=FAvailableEntries.Strings[ind];
   DeleteEntry(txt);
end;

procedure TMMJRasConnect.DeleteEntryByStr(Name:string);
var
   i:integer;
   Exst:Boolean;
begin
   if FAvailableEntries.Count = 0 then Exit;
//Cheking if given Name exists in FAvailableEntries
   Exst:=False;
   for i:=0 to FAvailableEntries.Count -1 do begin
      if FAvailableEntries.Strings[i]=Name then
         Exst:=True;
   end;
   If (FIsConnected) and (FConnectedEntry=Name) then Exst:=False;
   if Exst then DeleteEntry(Name);
end;

end.
