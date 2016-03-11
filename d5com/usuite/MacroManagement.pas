unit MacroManagement;
  /////////////////////////////////////////////////////////
  //                                                     //
  //              TMacroMagic-Component                  //
  //                                                     //
  // (C) Niels Vanspauwen, 19-03-1998                    //
  //     E-mail: Niels.Vanspauwen@Student.Kuleuven.Ac.Be //
  //                                                     //
  /////////////////////////////////////////////////////////
  {A unit that covers the internal macrohandling}

interface

uses
  SysUtils;

type
  ENoSuchMacro = class(Exception);
  TMacroNotification = procedure of object;
  TDebugRecord = record
    Rec: integer; //Recorded time (delta)
    Sched: integer; //Scheduled playtime
    Effective: integer; //Effective playtime
    Start: integer; //Starttime
    Delay: integer; //Delaytime
    Entry: integer; //Nr of EventMsg
  end;


procedure StartRecording(MacroName: string;
                         EndRecordProc: TMacroNotification;
                         CancelRecordProc: TMacroNotification);
procedure StopRecording;
procedure Playback(MacroName: string;
                   EndPlaybackProc: TMacroNotification;
                   CancelPlaybackProc: TMacroNotification);
procedure Pause;
procedure Resume;
procedure FreeBuffer;

implementation

uses Windows, Messages, Dialogs;

const
  MAXEVENTS = 100000; //Maximum number of mouse- and keyboardevents
                     //that can be recorded.

type
  TMsgBuffer = array[0..MAXEVENTS] of TEventMsg;
  PMsgBuffer = ^TMsgBuffer;

  TDebugArray = array[0..MAXEVENTS] of TDebugRecord;
  PDebugBuffer = ^TDebugArray;

var
  Recording: boolean;
  Playing: boolean;
  Paused: boolean; //Flag that indicates if a *request* to pause was issued
  Delay: boolean;
  StartTime: integer;
  Buffer: PMsgBuffer;
  Count: integer;
  Entry: integer;
  HookHandle: HHook; //Hook for recording or playback
  MsgHook: HHook; //Hook for messagescanner
  Log: file of TEventMsg;
  EPBProc: TMacroNotification;
  CPBProc: TMacroNotification;
  ERProc: TMacroNotification;
  CRProc: TMacroNotification;
  AllocatedSize: integer;
  StopPausing: boolean;
  DummyEvent: TEventMsg;
  (*
  DebugBuffer: PDebugBuffer;
  DebugEntry: integer;
  DebugFile: file of TDebugRecord;
  *)
  OldBuffer: PMsgBuffer;
  OldEntry: integer;


function Recorder(code: integer; wParam: longint;
                  lParam: longint): LResult; stdcall;
  {This is a callback function that serves as a system-wide hook,
   enabling me to record all mouse- and keyboardevents.
   This method should be passed in the SetWindowsHookEx, using the
   WH_JournalRecord parameter.}
var
  EventMsg: TEventMsg;
begin
Result:=0;
case Code of
  HC_Action:  if Recording then begin
                //Retrieve EventMsg:
                EventMsg:=PEventMsg(lParam)^;
                //Convert time to delta-time:
                EventMsg.time:=EventMsg.time-StartTime;
                //Store EventMsg:
                Buffer^[Entry]:=EventMsg;
                //Shift entry-pointer:
                if Entry<MAXEVENTS then
                  inc(Entry)
                else begin //Maximum recording capacity reached
                  SysUtils.Beep;
                  StopRecording;
                  MessageDlg('You have reached the maximum recording capacity !'+#13+
                             'Recording has stopped.', mtWarning, [mbOK], 0);
                  if Assigned(ERProc) then
                    ERProc;
                end; {if maximum recording capacity reached}
              end;
  HC_SysModalOn:  if Recording then begin
                    //Something is wrong: stop recording
                    Recording:=false;
                    //Notify other hooks of the problem:
                    Result:=CallNextHookEx(HookHandle, code,
                                           wParam, lParam);
                  end;
  HC_SysModalOff: {Problem is solved: resume recording}
                  Recording:=true;
else Result:=CallNextHookEx(HookHandle, code, wParam, lParam);
end; {case statement}
end; {function Recorder}


function Player(code: integer; wParam: longint; lParam: longint): LResult;stdcall;
  {A callback function to play a previously recorded journal}
var
  EventMsg: TEventMsg;
begin
Result:=0;
case Code of
  HC_GetNext:     if Playing then begin
                    if StopPausing then begin
                      Paused:=false;
                      StopPausing:=false;
                      if Entry < (Count-1) then
                      //Calculate correct new StartTime:
                      StartTime:=GetTickCount;
                      inc(Entry);
                      Delay:=True;
                    end; {if StopPausing}
                    PEventMsg(lParam)^:=Buffer^[Entry]; //Read log-entry
                    //Adjust playback time:
                    PEventMsg(lParam)^.time:=PEventMsg(lParam)^.time+StartTime;
                    (*LOG THE EVENT IN THE DEBUGBUFFER
                    DebugBuffer^[Entry].Effective:=GetTickCount;
                    DebugBuffer^[Entry].Rec:=EventMsg.time-StartTime;
                    DebugBuffer^[Entry].Sched:=EventMsg.time;
                    DebugBuffer^[Entry].Start:=StartTime;
                    DebugBuffer^[Entry].Entry:=Entry;
                    *)
                    if Delay then begin //Calculate delay-time:
                      Result:=PEventMsg(lParam)^.time-GetTickCount;
                      Delay:=false;
                      if Result<0 then Result:=0;
                      (*LOG THE DELAY IN THE DEBUGBUFFER
                      DebugBuffer^[Entry].Delay:=Result;*)
                    end;
                  end; {case HC_GetNext}
  HC_Skip:        if Playing then begin
                    if GetAsyncKeyState(VK_Cancel)>0 then begin
                      Playing:=false;
                      //Pull the playback-hook:
                      UnHookWindowsHookEx(HookHandle);
                      //Stop monitoring messages:
                      UnhookWindowsHookEx(MsgHook);
                      //Free buffer:
                      if buffer<>nil then begin
                        FreeMem(Buffer, AllocatedSize);
                        Buffer:=nil;
                      end; {free buffer}
                      //Call callback-procedure:
                      if Assigned(CPBProc) then
                        CPBProc;
                    end;
                    if StopPausing then begin
                      Paused:=false;
                      StopPausing:=false;
                      if Entry < (Count-1) then
                      //Calculate correct new StartTime:
                      StartTime:=GetTickCount-Buffer^[Entry+1].time;
                    end; {if StopPausing}
                    if Paused then begin
                      DummyEvent.time:=DummyEvent.time+20;
                      Buffer^[Entry]:=DummyEvent;
                      Delay:=true;
                      exit;
                        {This is were the exit-statement should be. Windows calls the
                         HC_Skip if it's done processing the previous
                         message. Then and only then will we start feeding Windows
                         with the dummy message.}
                    end; {if Paused}
                    inc(Entry); //Select next entry
                    Delay:=True; //Next message should be delayed
                    if Entry > (Count-1) then begin//Playback finished
                      Playing:=false;
                      //Release hookprocedure for playing:
                      UnhookWindowsHookEx(HookHandle);
                      //Release hookprocedure for message scanning:
                      UnhookWindowsHookEx(MsgHook);
                      if Buffer<>nil then begin
                        FreeMem(Buffer, AllocatedSize);
                        Buffer:=nil;
                      end; {if Buffer<>nil}
                      //Call callback-procedure:
                      if Assigned(EPBProc) then
                        EPBProc;
                      (*WRITE THE DEBUGLOG TO FILE
                      AssignFile(DebugFile, 'c:\debug.tts');
                      Rewrite(DebugFile); //Open file
                      BlockWrite(DebugFile, DebugBuffer^, Entry); //Write data
                      CloseFile(DebugFile); //Close file
                      //Free Buffer:
                      if DebugBuffer <> nil then
                        begin
                        FreeMem(DebugBuffer, SizeOf(TDebugArray));
                        DebugBuffer:=nil;
                        end;
                      ::::::::::::::::::::::::::::::*)
                    end; {if Playback finished}
                  end; {case HC_Skip}
  HC_SysModalOn:  begin
                    //Something serious has happend: stop playback
                    Playing:=false;
                    //Notify other hooks of the problem:
                    Result:=CallNextHookEx(HookHandle, code, wParam, lParam);
                  end; {case HC_SysModalOn}
  HC_SysModalOff: begin
                    {Something went wrong: playback-hook has been removed by system,
                     notify other hooks that they've been hosed by system:}
                    Result:=CallNextHookEx(HookHandle, code, wParam, lParam);
                    if Buffer<>nil then begin
                      FreeMem(Buffer, AllocatedSize);
                      Buffer:=nil;
                    end; {if Buffer<>nil}
                    //Call callback-procedure:
                    if Assigned(CPBProc) then
                      CPBProc;
                  end; {case HC_SysModalOff}
else Result:=CallNextHookEx(HookHandle, code, wParam, lParam);
end; {case statement}
end; {procedure Player}


function MessageScanner(code: integer; wParam:longint; lParam: longint):LResult;stdcall;
  {A hookfunction that scans for WM_CancelJournal-message or usercancel.}
var
  TheMessage: TMsg;
begin
Result:=0;
case Code of
  HC_Action:  begin
                TheMessage:=PMsg(lParam)^;
                case TheMessage.message of
                  WM_CancelJournal: begin
                                      SysUtils.beep;
                                      if Recording then begin
                                        StopRecording;
                                        if Assigned(CRProc) then
                                          CRProc;
                                      end {if Recording}
                                      else begin {we must be playing}
                                        Playing:=false;
                                        //Release hookprocedure for playing:
                                        UnhookWindowsHookEx(HookHandle);
                                        //Release hookprocedure for message scanning:
                                        UnhookWindowsHookEx(MsgHook);
                                        if Buffer<>nil then begin
                                          FreeMem(Buffer, AllocatedSize);
                                          Buffer:=nil;
                                        end; {if Buffer<>nil}
                                        //Call callback-procedure:
                                        if Assigned(CPBProc) then
                                          CPBProc;
                                      end; {stop playing}
                                    end; {case WM_CancelJournal}
                  WM_KeyDown:       begin
                                      if (TheMessage.wParam=VK_CANCEL) and
                                          Recording then begin
                                            StopRecording;
                                            if Assigned(ERProc) then
                                              ERProc;
                                      end {if Recording}
                                    end; {case WM_KeyDown}
                else CallNextHookEx(MsgHook, code, wParam, lParam);
                end; {case statement}
              end; {case HC_Action}
else CallNextHookEx(MsgHook, code, wParam, lParam)
end; {case statement}
end; {function MessageScanner}


procedure StartRecording(MacroName: string;
                         EndRecordProc: TMacroNotification;
                         CancelRecordProc: TMacroNotification);
begin
//Assign filename to log:
AssignFile(log, ChangeFileExt(MacroName, '.mcr'));
//Allocate memory for the buffer:
GetMem(Buffer, SizeOf(TMsgBuffer));
AllocatedSize:=SizeOf(TMsgBuffer);
//Set entry-pointer:
Entry:=0;
ERProc:=EndRecordProc;
CRProc:=CancelRecordProc;
Recording:=true;
//Get the starttime of the recording:
StartTime:=GetTickCount;
//Set the hookprocedure for recording:
HookHandle:=SetWindowsHookEx(WH_JOURNALRECORD,
                             TFNHookProc(Recorder),
                             0,
                             dword(0));
//Set a GetMsgProc-hook to scan for WM_CancelJournal-messages:
MsgHook:=SetWindowsHookEx(WH_GETMESSAGE, TFNHookProc(MessageScanner),
                          0, GetCurrentThreadId);
end; {procedure StartRecording}


procedure StopRecording;
begin
if not Recording then exit;
//Stop recording:
Recording:=false;
//Release hookprocedure for recording:
UnhookWindowsHookEx(HookHandle);
//Release hookprocedure for message scanning:
UnhookWindowsHookEx(MsgHook);
//Write Buffer to log file:
Rewrite(log); //Open file
BlockWrite(log, Buffer^, Entry); //Write data
CloseFile(Log); //Close file
//Free Buffer:
if Buffer <> nil then
  begin
  FreeMem(Buffer, AllocatedSize);
  Buffer:=nil;
  end;
end; {procedure StopRecording}


procedure Playback(MacroName: string;
                   EndPlaybackProc: TMacroNotification;
                   CancelPlaybackProc: TMacroNotification);
begin
Paused:=False;
StopPausing:=False;
//Check if MacroName is valid:
if not FileExists(ChangeFileExt(MacroName, '.mcr')) then
  raise ENoSuchMacro.Create('File not found: '+ChangeFileExt(MacroName, '.mcr'));
//Assign logfile:
AssignFile(log, ChangeFileExt(MacroName, '.mcr'));
//Open the log file:
Reset(Log);
//Read log into memory:
GetMem(Buffer, FileSize(log)*SizeOf(TEventMsg));
AllocatedSize:=FileSize(log)*SizeOf(TEventMsg);
Count:=FileSize(log);  //Calculate nb of entries
BlockRead(log, Buffer^, Count); //Read all entries
CloseFile(log); //Close log-file
Entry:=0; //Select first entry
//First message should be processed immediatly:
Delay:=false;
//Set EPBProc:
EPBProc:=EndPlaybackProc;
//Set CPBProc:
CPBProc:=CancelPlaybackProc;
//Allow playback:
Playing:=true;
GetAsyncKeyState(VK_CANCEL);

(*ALLCATE DEBUGBUFFER:
GetMem(DebugBuffer, SizeOf(TDebugArray));
*)

//Get startime of playback:
StartTime:=GetTickCount;
//Set the hookprocedure for playback:
HookHandle:=SetWindowsHookEx(WH_JOURNALPLAYBACK,
                             TFNHookProc(Player),
                             0,
                             dword(0));
//Set a GetMsgProc-hook to scan for WM_CancelJournal-messages:
MsgHook:=SetWindowsHookEx(WH_GETMESSAGE, TFNHookProc(MessageScanner),
                          0, GetCurrentThreadId);
end; {procedure Playback}


procedure Pause;
  {This method should only be called during playback or recording.
   Otherwise, this method does nothing.
   WARNING: this method is only intended to _PAUSE_ playback or recording.
   A call to this method should ALWAYS be followed by a call to
   Resume to ensure proper freeing of memory and releasing of all
   Hooks !!}
begin
if Playing then begin
  Paused:=true;
  DummyEvent.Time:=Buffer^[Entry].time+20;
end {if Playing}
else if Recording then begin
  Paused:=true;
  //Temporarily remove the recording hook:
  UnhookWindowsHookEx(HookHandle);
  //Allocate a dummy-buffer:
  OldBuffer:=Buffer;
  OldEntry:=Entry;
  GetMem(Buffer, SizeOf(TEventMsg));
  Entry:=0;
  DummyEvent.Time:=20;
  Buffer^[Entry]:=DummyEvent;
  Delay:=false;
  Playing:=true;
  GetAsyncKeyState(VK_CANCEL);
  StartTime:=GetTickCount;
  //Temporarily set the blocking hook:
  HookHandle:=SetWindowsHookEx(WH_JOURNALPLAYBACK, TFNHookProc(Player),
                               0, 0);
end; {if Recording}
end; {procedure Pause}


procedure Resume;
  {WARNING: this method should only be called subsequent to a call
   to Pause!! Otherwise, this method does nothing.}
begin
if not Paused then exit;
if Recording then begin
  //Pull the blocking hook:
  UnhookWindowsHookEx(HookHandle);
  FreeMem(Buffer, SizeOf(TEventMsg));
  Entry:=OldEntry;
  Buffer:=OldBuffer;
  OldBuffer:=nil;
  StartTime:=GetTickCount;
  //Set the recordinghook again:
  HookHandle:=SetWindowsHookEx(WH_JOURNALRECORD, TFNHookProc(Recorder),
                               0, 0);
  Paused:=false;
  Playing:=false;
end
else {we must be playing}
  StopPausing:=true //*REQUEST* to stop pausing
end; {procedure Resume}

procedure FreeBuffer;
begin
if Buffer<>nil then begin
  FreeMem(Buffer);
  Buffer:=nil;
end;
if OldBuffer<>nil then begin
  FreeMem(OldBuffer);
  OldBuffer:=nil;
end;
end; {procedure FreeBuffer}


initialization
DummyEvent.Message:=WM_Null;

end.
