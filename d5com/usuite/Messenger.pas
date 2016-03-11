unit Messenger;

interface

{$LONGSTRINGS ON}  // Equal {$H+}

uses
  ExtCtrls, Windows, SysUtils, Classes,Dialogs;

type
 TMainMessenger = Class;
 TSignalThread = class(TThread)
  private
    FMailSlot : TMainMessenger;
  protected
    procedure Execute; override;
  Public
    Constructor Create(MailSlot : TMainMessenger);
  end;
 TTimerThread = class(TThread)
  private
    FMailSlot : TMainMessenger;
  protected
    procedure Execute; override;
  Public
    Constructor Create(MailSlot : TMainMessenger);
  end;



  TNELineArrival = Procedure (Sender : TObject;Origin,Time,Line : string) of Object;
  TNEMemoArrival = Procedure (Sender : TObject;Origin,Time : string;MsgLines : TStrings) of Object;
  TNEUserListChange = Procedure (Sender : TObject; UserList : TStrings) of Object;
  TNEError = Procedure (Sender : TObject;ErrorMsg : string) of object;
  TNETimer = Procedure (Sender : TObject) of object;

  TMainMessenger = class(TComponent)
  private
   FWaitThread : TSignalThread;
   FTimerThread : TTimerThread;
   LocalHandle,RemoteHandle : THandle;
   ActiveFlag : Boolean;
   FComputer,FUser : string;
   Server,FBoxName,LocalPath,RemotePath : string;
   MaxMsgSize,MsgCount,NextMsgSize,MsgSize : DWORD;
   MsgType,MsgTime,MsgSender,MsgText : string;
   OutStrings,InStrings,UserList,MemoLines : TStringList;
   NewLine : String;
   FInterval : word;
   FTimerActive : boolean;
   FLineArrival : TNELineArrival;
   FMemoArrival : TNEMemoArrival;
   FUserListChange : TNEUserListChange;
   FError : TNEError;
   FTimer : TNETimer;
   Procedure SendOutStrings(Recipient : string);
   Procedure SendCommand(Recipient,Command : string);
   Procedure AddUser(Name : string);
   Procedure DeleteUser(Name : string);
  protected
   Procedure DoLineArrival(Const FMSender,FMTime,FMText : string); virtual;
   Procedure DoMemoArrival(const FMSender,FMTime : string;MLines : Tstrings); virtual;
   Procedure DoUserListChange(Const CompList : TStringList); virtual;
   Procedure DoErrorReport(const Error : string); virtual;
  public
    Constructor Create(AOwner : TComponent); Override;
    Destructor Destroy; override;
    Procedure Activate;
    Procedure DeActivate;
    Procedure SetName(const NewName : TComponentName); override;
    Procedure SetBoxName(NewName : string);
    Procedure SetInterval(time : word);
    Procedure ReadMessage;
    Procedure ProcessCommand;
    Procedure SendLine(Recipient,Text : string);
    Procedure SendMemo(Recipient : string;Lines : TStrings);
    Procedure Broadcast(text : string);
    procedure DoTimer;
    Property OnNewLine : TNELineArrival read FLineArrival write FLineArrival;
    Property OnNewMemo : TNEMemoArrival read FMemoArrival write FMemoArrival;
    Property OnUserListChange : TNEUserListChange Read FUserListChange Write FUserListChange;
    Property OnError : TNEError read FError write FError;
    Property OnTimer : TNETimer read FTimer write FTimer;
  published
  end;

 TMessenger = class(TMainMessenger)
  Published
   Property Computer : string read FComputer;
   Property User : string read FUser;
   Property BoxName : string read FBoxName write SetBoxName;
   Property Interval : word read FInterval write SetInterval;
   Property OnNewLine;
   Property OnNewMemo;
   Property OnUserListChange;
   Property OnError;
   Property OnTimer;
  end;

procedure Register;

implementation

//---------- Component Registration ------------------------------------------

procedure Register;
begin
  RegisterComponents('Upgrade Suite', [TMessenger]);
end;



//---------- Thread Procedures -----------------------------------------------

Constructor TSignalThread.Create(MailSlot : TMainMessenger);
Begin
  Inherited Create(False);
  Priority := tpNormal;
  FMailSlot := MailSlot;
end;

Procedure TSignalThread.Execute;
Begin
  While Not Terminated do
  Begin
    GetMailSlotInfo(FMailSlot.LocalHandle,NIL, FMailSlot.NextMsgSize,
                    @FMailSlot.MsgCount, NIL);
    If FMailSLot.MsgCount > 0 Then
      Synchronize(FMailSLot.ReadMessage);
    Sleep(1);
  end;
end;


Constructor TTimerThread.Create(MailSlot : TMainMessenger);
Begin
  Inherited Create(False);
  Priority := tpNormal;
  FMailSlot := MailSlot;
end;

Procedure TTimerThread.Execute;
Begin
  While Not Terminated do begin
    Synchronize(FMailSLot.DoTimer);
    Sleep(FMailslot.FInterval);
  end;
end;


Procedure TMainMessenger.DoTimer;
begin
 if assigned(FTimer) then FTimer(Self);
end;


//----------- Signaler StartUp/ShutDown -----------------------------------------

Constructor TMainMessenger.Create(AOwner : TComponent);
var
 temp : array[0..255] of char;
 len : integer;
Begin
  Inherited Create(AOwner);
  FBoxName := 'SignalBox';
  FInterval := 1000;
  FWaitThread := NIL;
  FTimerThread := NIL;
  len := 255;
  GetComputerName(temp,len);
  FComputer := StrPas(temp);
  len := 255;
  GetUserName(temp,len);
  FUser := StrPas(temp);
  OutStrings := TStringList.Create;
  InStrings := TStringList.Create;
  UserList := TStringList.Create;
  MemoLines := TStringList.Create;
end;

Destructor TMainMessenger.Destroy;
begin
 if ActiveFlag = true then DeActivate;
 UserList.Free;
 OutStrings.Free;
 InStrings.Free;
 MemoLines.Free;
 inherited Destroy;
end;

Procedure TMainMessenger.Activate;
var
 i,j : integer;
begin
 If ActiveFlag = true then begin
  DoErrorReport('You tried to Activate an active TMessenger component');
  exit;
 end;
 FWaitThread := TSignalThread.Create(Self);
 if FWaitThread = nil then begin
  DoErrorReport('Could not Start TMessenger Timer Thread');
  exit;
 end;
 FTimerThread := TTimerThread.Create(Self);
 Server := '.';
 LocalPath := '\\' + Server + '\mailslot\' + FBoxName;
 LocalHandle := CreateMailSlot(PChar(LocalPath),MaxMsgSize,0,nil);
 if LocalHandle = INVALID_HANDLE_VALUE then begin
  FWaitThread.Terminate;
  FWaitThread := nil;
  FTimerThread.Terminate;
  FTimerThread := nil;
  DoErrorReport('Could not Create Mail Slot');
  exit;
 end;
 SendCommand('*','ONLINE_NOTIFY');
 ActiveFlag := true;
end;


Procedure TMainMessenger.DeActivate;
begin
 if ActiveFlag = false then begin
  DoErrorReport('Cannot Deactivate an Inactive TMessenger Component');
  exit;
 end;
 if FWaitThread <> nil then begin
  FWaitThread.Terminate;
  FWaitThread := nil;
 end;
 if FTimerThread <> nil then begin
  FTimerThread.Terminate;
  FTimerThread := nil;
 end;
 CloseHandle(LocalHandle);
 SendCommand('*','OFFLINE_NOTIFY');
 ActiveFlag := False;
end;


//-------------- Set Property Procedures --------------------------------------

Procedure TMainMessenger.SetName(const NewName: TComponentName);
Begin
  Inherited SetName(NewName);
end;

Procedure TMainMessenger.SetBoxName(NewName : string);
begin
 if FBoxName <> NewName then begin
  FBoxName := NewName;
  if ActiveFlag = true then begin
   DeActivate;
   Activate;
  end;
 end;
end;

Procedure TMainMessenger.SetInterval(Time : word);
begin
 if FInterval <> Time then  FInterval := Time;
end;


//------------- Message Retrieval Procedures ----------------------------------

Procedure TMainMessenger.ReadMessage;
var
 i : integer;
begin
 Instrings.Clear;
 SetLength(NewLine,NextMsgSize);
 ReadFile(LocalHandle,PChar(NewLine)^,NextMsgSize,MsgSize,nil);
 Instrings.Text := NewLine;
 FWaitThread.Suspend;
 if Instrings.Count > 3 then begin
  MsgType := Instrings[0];
  MsgTime := Instrings[1];
  MsgSender := Instrings[2];
  MsgText := Instrings[3];
 end;
 if Instrings.Count > 5 then begin
  MemoLines.Clear;
  for i := 4 to Instrings.Count - 2 do begin
   MemoLines.Add(Instrings[i]);
  end;
 end;
 if MsgType = 'COMMAND_MSG' then ProcessCommand;
 if MsgType = 'LINE_MSG' then DoLineArrival(MsgSender,MsgTime,MsgText);
 if MsgType = 'MEMO_MSG' then DoMemoArrival(MsgSender,MsgTime,MemoLines);
 Instrings.Clear;
 FWaitThread.Resume;
end;

Procedure TMainMessenger.ProcessCommand;
begin
 if MsgSender = FComputer then exit;
 if MsgText = 'ONLINE_NOTIFY' then begin
  AddUser(MsgSender);
  SendCommand(MsgSender,'ONLINE_RESPONSE');
 end;
 if MsgText = 'ONLINE_RESPONSE' then AddUser(MsgSender);
 if MsgText = 'OFFLINE_NOTIFY' then DeleteUser(MsgSender);
end;

Procedure TMainMessenger.AddUser(Name : string);
var
 i : Integer;
 j : boolean;
begin
 j := false;
 if UserList.Count > 0 then begin
  for i := 0 to UserList.Count - 1 do begin
   if UserList[i] = Name then j := true;
  end;
 end;
 if j = true then exit;
 UserList.Add(Name);
 DoUserListChange(UserList);
end;

Procedure TMainMessenger.DeleteUser(Name : string);
var
 i,Num : Integer;
 j : boolean;
begin
 j := false;
 Num := 0;
 if UserList.Count > 0 then begin
  for i := 0 to UserList.Count - 1 do begin
   if UserList[i] = Name then begin
    j := true;
    Num := i;
   end;
  end;
 end;
 if j = false then exit;
 UserList.Delete(Num);
 DoUserListChange(UserList);
end;

//------------- Message Sending Procedures ------------------------------------

Procedure TMainMessenger.SendOutStrings(Recipient : string);
var
 len : DWORD;
begin
 if OutStrings.Count > 0 then begin
  RemotePath := '\\' + Recipient + '\mailslot\' + FBoxName;
  RemoteHandle := CreateFile(PChar(RemotePath),GENERIC_WRITE,FILE_SHARE_READ,
                             nil,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,-1);
  if RemoteHandle = INVALID_HANDLE_VALUE then begin
   DoErrorReport('Could not Open a Remote Mail Slot');
   exit;
  end;
  WriteFile(RemoteHandle,Pointer(Outstrings.text)^,Length(OutStrings.text),len,nil);
  OutStrings.Clear;
 end;
end;

Procedure TMainMessenger.SendLine(Recipient,Text : string);
begin
 if Recipient = '*' then exit;
 Outstrings.Add('LINE_MSG');
 Outstrings.Add(TimeToStr(Time));
 OutStrings.Add(FComputer);
 OutStrings.Add(text);
 OutStrings.Add('END_MESSAGE');
 SendOutStrings(Recipient);
end;

Procedure TMainMessenger.Broadcast(text : string);
begin
 Outstrings.Add('LINE_MSG');
 Outstrings.Add(TimeToStr(Time));
 OutStrings.Add(FComputer);
 OutStrings.Add(text);
 OutStrings.Add('END_MESSAGE');
 SendOutStrings('*');
end;

Procedure TMainMessenger.SendMemo(Recipient : string;Lines : TStrings);
var
 i : integer;
begin
 if Recipient = '*' then exit;
 Outstrings.Add('MEMO_MSG');
 Outstrings.Add(TimeToStr(Time));
 OutStrings.Add(FComputer);
 OutStrings.Add('BEGIN_MEMO');
 if Lines.Count > 0 then begin
  for i := 0 to Lines.Count -1 do begin
    OutStrings.Add(Lines[i]);
  end;
 end;
 OutStrings.Add('END_MESSAGE');
 SendOutStrings(Recipient);
end;

Procedure TMainMessenger.SendCommand(Recipient,Command : string);
begin
 Outstrings.Add('COMMAND_MSG');
 Outstrings.Add(TimeToStr(Time));
 OutStrings.Add(FComputer);
 OutStrings.Add(Command);
 OutStrings.Add('END_MESSAGE');
 SendOutStrings(Recipient);
end;

//----------- Event Handler Procedures ---------------------------------------

Procedure TMainMessenger.DoLineArrival(const FMSender,FMTime,FMText : string);
begin
 if Assigned(FLineArrival) then FLineArrival(Self,MsgSender,MsgTime,MsgText);
end;

Procedure TMainMessenger.DoMemoArrival(const FMSender,FMTime : string;MLines : Tstrings);
begin
  if Assigned(FMemoArrival) then FMemoArrival(Self,MsgSender,MsgTime,MemoLines);
end;

Procedure TMainMessenger.DoUserListChange(Const CompList : TStringList);
begin
 If Assigned(FUserListChange) Then FUserListChange(Self,CompList);
end;

Procedure TMainMessenger.DoErrorReport(const Error : string); 
begin
  If Assigned(FError) Then FError(Self,Error);
end;

end.
