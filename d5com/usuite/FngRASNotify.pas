{
  FNGRASNOTIFY.PAS
  FnugryRASNotify Component
  Copyright (C) 1997 Gleb Yourchenko
  Version 1.0.0.3


  E-Mail: eip__@hotmail.com
  Please specify 'FnugryRASNotify' in the subject string
}


unit FngRASNotify;

interface
uses
  Windows, SysUtils, RAS, Classes, ExtCtrls, Dialogs;

const

  RAS_MAX_CONN   = 8192;

type

  PRASConnList = ^TRASConnList;
  TRASConnList = array[0..RAS_MAX_CONN-1] of TRASCONN;

  PRASHandleArray = ^TRASHandleArray;
  TRASHandleArray = array[0..RAS_MAX_CONN-1] of THandle;


  ERASNotifyError = class(Exception);

  TRASConnectedEvent = procedure(Sender :TObject;
    hConn :THandle; const EntryName,
    DeviceType, DeviceName :String) of object;

  TRASDisconnectedEvent = procedure(Sender :TObject;
    hConn :THandle ) of object;


  TFnugryRASNotify = class(TComponent)
  private
    FEnabled        :Boolean;
    FPollInterval   :Integer;
    FPollTimer      :TTimer;
    FConnList       :PRASConnList;
    FConnCount      :Integer;
    FOnConnected    :TRASConnectedEvent;
    FOnDisconnected :TRASDisconnectedEvent;
    FOnEnable       :TNotifyEvent;
    FOnDisable      :TNotifyEvent;
    procedure HandlePollTimerEvent(Sender :TObject);
    procedure SetEnabled(Value :Boolean);
    procedure SetPollInterval(Value :Integer);
    function GetCOnnCount :Integer;
    function GetConnHandle(Index :Integer):THandle;
    function GetConnName(Index :Integer):String;
    function GetDeviceType(Index :Integer):String;
    function GetDeviceName(Index :Integer):String;
    function GetConnList(out lpList :PRASConnList):Integer;
    function GetOnline :Boolean;
  protected
    procedure ValidateEntryIndex(Value :Integer);
    procedure Loaded; override;
    procedure Connected(hConn :THandle;
      const EntryName, DeviceType, DeviceName :String); virtual;
    procedure Disconnected(hConn :THandle); virtual;
    procedure DoEnable; virtual;
    procedure DoDisable; virtual;
    procedure ResetList;
    procedure ClearList;
    procedure UpdateList;
  public
    constructor Create(AOwner :TComponent); override;
    destructor Destroy; override;
    property ConnCount :Integer
      read GetConnCount;
    property ConnHandle[Index :Integer] :THandle
      read GetConnHandle;
    property ConnName[Index :Integer] :String
      read GetConnName;
    property DeviceType[Index :Integer] :String
      read GetDeviceType;
    property DeviceName[Index :Integer] :String
      read GetDeviceName;
    property Online :Boolean
      read GetOnline;
  published
    property Enabled :Boolean
      read FEnabled write SetEnabled;
    property PollInterval :Integer
      read FPollInterval write SetPollInterval;
    property OnConnected :TRASConnectedEvent
      read FOnConnected write FOnConnected;
    property OnDisconnected :TRASDisconnectedEvent
      read FOnDisconnected write FOnDisconnected;
    property OnEnable :TNotifyEvent
      read FOnEnable write FOnEnable;
    property OnDisable :TNotifyEvent
      read FOnDisable write FOnDisable;
  end;

procedure Register;


implementation


procedure Register;
begin
  RegisterComponents('Upgrade Suite', [TFnugryRASNotify]);
end;


{  TFnugryRASNotify }

const

  POLL_INTERVAL_MIN    = 200;
  POLL_INTERVAL_MAX    = 60000;
  POLL_INTERVAL_DEF    = 2000;


  SErrInvalidInterval  = 'Invalid poll interval';
  SErrOOM              = 'Not enough memory to complete operation';
  SErrRAS              = 'Could not enumerate connections.'#13#10'Error Code %d';
  SErrIndex            = 'Invalid index';


procedure TFnugryRASNotify.Connected(hConn :THandle;
  const EntryName, DeviceType, DeviceName :String);
begin
  if assigned(FOnConnected) then FOnConnected(Self,
    hConn, EntryName, DeviceType, DeviceName);
end;


procedure TFnugryRASNotify.Disconnected(hConn :THandle);
begin
  if assigned(FOnDisconnected) then FOnDisconnected(Self, hConn);
end;

procedure TFnugryRASNotify.DoEnable;
begin
  if assigned(FOnEnable) then FOnEnable(Self);
end;

procedure TFnugryRASNotify.DoDisable;
begin
  if assigned(FOnDisable) then FOnDisable(Self);
end;

procedure TFnugryRASNotify.SetEnabled(Value :Boolean);
begin
  if FEnabled <> Value then
    begin
      if FPollTimer <> Nil then
        begin
          if Value then ResetList else ClearList;
          FPollTimer.Enabled := Value;
        end;
      FEnabled := Value;
      if Value then DoEnable else DoDisable;
    end;
end;

procedure TFnugryRASNotify.SetPollInterval(Value :Integer);
begin
  if Value <> FPollInterval then
    if (Value >= POLL_INTERVAL_MIN) and (Value <= POLL_INTERVAL_MAX)
      then
        begin
          if FPollTimer <> Nil then FPollTimer.Interval := Value;
          FPollInterval := Value;
        end
      else
        if csDesigning in ComponentState
          then MessageDlg(SErrInvalidInterval, mtError, [mbOk], 0);
end;



function TFnugryRASNotify.GetConnCount :Integer;
begin
  result := 0;
  if FConnList <> Nil then result := FConnCount;
end;


function TFnugryRASNotify.GetConnHandle(Index :Integer):THandle;
begin
  result := INVALID_HANDLE_VALUE;
  ValidateEntryIndex(Index);
  if FConnList <> Nil then result := FConnList^[Index].hrasconn;
end;


function TFnugryRASNotify.GetConnName(Index :Integer):String;
begin
  result := '';
  ValidateEntryIndex(Index);
  if FConnList <> Nil then result := FConnList^[Index].szEntryName;
end;


function TFnugryRASNotify.GetDeviceType(Index :Integer):String;
begin
  result := '';
  ValidateEntryIndex(Index);
  if FConnList <> Nil then result := FConnList^[Index].szdeviceType;
end;


function TFnugryRASNotify.GetDeviceName(Index :Integer):String;
begin
  result := '';
  ValidateEntryIndex(Index);
  if FConnList <> Nil then result := FConnList^[Index].szDeviceName;
end;


constructor TFnugryRASNotify.Create(AOwner :TComponent);
begin
  inherited Create(Aowner);
  FPollInterval := POLL_INTERVAL_DEF;
  FEnabled := true;
end;


destructor TFnugryRASNotify.Destroy;
begin
  if FPollTimer <> Nil then FPollTimer.Enabled := false;
  if FConnList <> Nil then
    begin
      FreeMem(FConnList);
      FConnList := Nil;
    end;
  inherited Destroy;
end;

procedure TFnugryRASNotify.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
    begin
      if FEnabled then FConnCount := GetConnList(FConnList);
      FPollTimer := TTimer.Create(Self);
      FPollTimer.OnTimer := HandlePollTimerEvent;
      FPollTimer.Interval := FPollInterval;
      FPollTimer.Enabled := FEnabled;
    end;
end;


{ Retrieves list of active connections.
 Returns number of entries in the list.}

function TFnugryRASNotify.GetConnList(
  out lpList :PRASConnList):Integer;
var
  cbList :Integer;
  Err    :Integer;
  ConnStatus :TRASCONNSTATUS;
  I :Integer;
begin
  Result := 0;
  cbList := 16 * SizeOf(TRASCONN);
  GetMem(lpList, cbList);
  try
    lpList^[0].dwSize := sizeof(TRASCONN);
    Err := RASEnumConnections(LPRASCONN(lpList), cbList, Result);
    case Err of
      //
      // success - do nothing
      //
      0 :;
      //
      // out of memory - throw exception
      //
      ERROR_NOT_ENOUGH_MEMORY : raise EOutOfMemory.Create(SErrOOM);
      //
      // buffer to small - reallocate
      // buffer and try once more
      //
      ERROR_BUFFER_TOO_SMALL :
        begin
          FreeMem(lpList);
          GetMem(lpList, cbList);
          lpList^[0].dwSize := sizeof(TRASCONN);
          Err := RASEnumConnections(LPRASCONN(lpList), cbList, Result);
          case Err of
            0 :;
            ERROR_BUFFER_TOO_SMALL,
            ERROR_NOT_ENOUGH_MEMORY :
              raise EOutOfMemory.Create(SErrOOM);
            else
              raise ERASNotifyError.CreateFmt(SErrRAS, [Err]);
          end;
        end;
      else
        raise ERASNotifyError.CreateFmt(SErrRAS, [Err]);
    end;
  except
    if lpList <> Nil then
      begin
        FreeMem(lpList);
        lpList := Nil;
      end;
    raise;
  end;
  { retrieve connections status }
  for I := 0 to Result-1 do
    begin
      ConnStatus.dwSize := sizeof(ConnStatus);
      if RasGetConnectStatus(lpList^[I].hrasconn, ConnStatus) = 0
        then lpList^[I].dwSize := ConnStatus.rasconnstate
        else raise ERASNotifyError.CreateFmt(SErrRAS, [Err]);
    end;
end;


procedure TFnugryRASNotify.ClearList;
begin
  if FConnList <> Nil then
    begin
      FreeMem(FConnList);
      FConnList := Nil;
      FConnCount := 0;
    end;
end;


procedure TFnugryRASNotify.ResetList;
begin
  ClearList;
  FConnCount := GetConnList(FConnList);
end;


procedure TFnugryRASNotify.HandlePollTimerEvent(Sender :TObject);
begin
  UpdateList;
end;


procedure TFnugryRASNotify.ValidateEntryIndex(Value :Integer);
begin
  if (Value < 0) or (Value >= ConnCount) then
    raise ERASNotifyError.Create(SErrIndex);
end;

procedure TFnugryRASNotify.UpdateList;
var
  S :TRASCONNSTATUS;
  N, I, J, C, E :Integer;
  L :PRASCONNLIST;
  F :Boolean;
begin
  { check connections status }
  for I := 0 to ConnCount do
    begin
      S.dwsize := sizeof(S);
      N := 0;
      E := RasGetConnectStatus(FConnList^[I].hrasconn, s);
      case E of
        0 :
          begin
            if (FConnList^[I].dwSize = RASCS_CONNECTED)
            and (s.rasconnstate <> RASCS_CONNECTED) then N := -1;
            if (FConnList^[I].dwSize <> RASCS_CONNECTED)
            and (s.rasconnstate = RASCS_CONNECTED) then N := 1;
          end;
        ERROR_INVALID_HANDLE,
        ERROR_INVALID_PORT_HANDLE :
          begin
            if FConnList^[I].dwSize = RASCS_CONNECTED then N := -1;
            FConnList^[I].dwSize := -1;
            FConnList^[I].hrasconn := -1;
          end;
        else raise ERASNotifyError.CreateFmt(SErrRAS, [E]);
      end;
      if N <> 0 then
       with FConnList^[I] do
        if N > 0
          then Connected(hrasconn, szEntryName, szDeviceType, szDeviceName)
          else Disconnected(hrasconn);
    end;

    C := GetConnList(L);
    try
      for I := 0 to C-1 do
        begin
          //
          // Check for a new entry
          //
          F := false;
          for J := 0 to ConnCount-1 do
            if L^[I].hrasconn = FConnList^[J].hrasconn then
              begin
                F := true;
                break;
              end;
          //
          // Notify if entry is new and connected
          //
          if (not F) and (L^[I].dwSize = RASCS_CONNECTED) then
            with L^[I] do Connected(hrasconn, szEntryName, szDeviceType, szDeviceName);
        end;

      //
      // Swap connection lists
      //
      asm
        mov  ebx, self
        mov  eax, L
        xchg eax, [ebx].TFnugryRASNotify.FConnList
        mov  L, eax
        mov  eax, C
        mov  [ebx].TFnugryRASNotify.FConnCount, eax
      end;
    finally
      if L <> Nil then FreeMem(L);
    end;
end;

function TFnugryRASNotify.GetOnline :Boolean;
var I :Integer;
begin
  result := false;
  for I := 0 to ConnCount-1 do
   if FConnList^[I].dwSize = RASCS_CONNECTED then
     begin
       result := true;
       break;
     end;
end;



end.
