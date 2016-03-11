unit MacroMagic;
  /////////////////////////////////////////////////////////
  //                                                     //
  //              TMacroMagic-Component                  //
  //                                                     //
  // (C) Niels Vanspauwen, 19-03-1998                    //
  //     E-mail: Niels.Vanspauwen@Student.Kuleuven.Ac.Be //
  //                                                     //
  /////////////////////////////////////////////////////////
  {This component can be dropped on a form to support macro-recording
   and playback.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MacroManagement, InfoForm_f;

type
  ENoSuchMacro = class(Exception);

  TMacroState = (msRecording, msPlaying, msPausedPlayback,
                 msPausedRecording, msIdle, msUnassigned);

  TMacroMagic = class(TComponent)
  private
    FMacroName: string;
    FLoop: boolean;
    FState: TMacroState;
    FOnPlayEvent: TMacroNotification;
    FOnPlayEndedEvent: TMacroNotification;
    FOnPlayCancelledEvent: TMacroNotification;
    FOnRecordEvent: TMacroNotification;
    FOnRecordEndedEvent: TMacroNotification;
    FOnRecordCancelledEvent: TMacroNotification;
    InfoBoxCreated: boolean;
    InfoBox: TInfoForm;
    procedure SetMacroName(Value: string);
    procedure Looper;
  protected
    procedure TriggerOnPlay;dynamic;
    procedure TriggerOnPlayEnded;dynamic;
    procedure TriggerOnPlayCancelled;dynamic;
    procedure TriggerOnRecord;dynamic;
    procedure TriggerOnRecordEnded;dynamic;
    procedure TriggerOnRecordCancelled;dynamic;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure Play;
    procedure Pause;
    procedure Resume;
    procedure StartRecording;
    procedure StopRecording;
    property State: TMacroState
      read FState default msUnassigned;
  published
    property MacroName: string
      read FMacroName write SetMacroName;
    property LoopPlayback: boolean
      read FLoop write FLoop default False;
    property OnPlay: TMacroNotification
      read FOnPlayEvent write FOnPlayEvent;
    property OnPlayEnded: TMacroNotification
      read FOnPlayEndedEvent write FOnPlayEndedEvent;
    property OnPlayCancelled: TMacroNotification
      read FOnPlayCancelledEvent write FOnPlayCancelledEvent;
    property OnRecord: TMacroNotification
      read FOnRecordEvent write FOnRecordEvent;
    property OnRecordEnded: TMacroNotification
      read FOnRecordEndedEvent write FOnRecordEndedEvent;
    property OnRecordCancelled: TMacroNotification
      read FOnRecordCancelledEvent write FOnRecordCancelledEvent;
  end; {TMacroMagic component declaration}

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Upgrade Suite', [TMacroMagic]);
end;


constructor TMacroMagic.Create(AOwner: TComponent);
begin
inherited Create(AOwner); //Always call inherited constructor first!
FLoop:=false;
FState:=msUnassigned;
InfoBoxCreated:=false;
end; {constructor Create}


destructor TMacroMagic.Destroy;
begin
MacroManagement.FreeBuffer;
inherited Destroy; //Always call last !
end; {destructor Destroy}


procedure TMacroMagic.Looper;
begin
TriggerOnPlayEnded;
Play;
end; {procedure Looper}


procedure TMacroMagic.Play;
begin
if FState<>msIdle then exit; //Playback only allowed when Idle
if not FLoop then begin
  Playback(FMacroName, TriggerOnPlayEnded, TriggerOnPlayCancelled); //Start playback
  TriggerOnPlay;
end
else begin
  Playback(FMacroName, Looper, TriggerOnPlayCancelled); //Loop playback
  TriggerOnPlay;
end;
end; {procedure Play}


procedure TMacroMagic.Pause;
  {This method should only be called during playback. Otherwise, this
   method does nothing.}
begin
if (FState=msPlaying) then begin
  FState:=msPausedPlayback;
  MacroManagement.Pause;
end
else if FState=msRecording then begin
  FState:=msPausedRecording;
  MacroManagement.Pause;
end;
end; {procedure Pause}


procedure TMacroMagic.Resume;
  {This method should only be called when the playback has been paused.
   Otherwise, this method does nothing.}
begin
if FState=msPausedPlayback then begin
  FState:=msPlaying;
  MacroManagement.Resume;
end
else if FState=msPausedRecording then begin
  FState:=msRecording;
  MacroManagement.Resume;
end;
end; {procedure Resume}


procedure TMacroMagic.StartRecording;
begin
if FState<>msIdle then exit; //Recording only allowed when Idle
MacroManagement.StartRecording(FMacroName, TriggerOnRecordEnded, TriggerOnRecordCancelled); //Start recording
TriggerOnRecord;
end; {procedure StartRecording}


procedure TMacroMagic.StopRecording;
begin
if FState<>msRecording then exit; //Stop only available when recording
MacroManagement.StopRecording;
TriggerOnRecordEnded;
end; {procedure StopRecording}


procedure TMacroMagic.SetMacroName(Value: string);
begin
if (FState<>msIdle) and (FState<>msUnassigned) then exit;
if (Value<>'') and (Value<>FMacroName) then begin
  FMacroName:=Value;
  FState:=msIdle;
end;
end; {procedure SetMacroName}


procedure TMacroMagic.TriggerOnPlay;
begin
FState:=msPlaying;
if Assigned(FOnPlayEvent) then FOnPlayEvent;
end; {procedure TriggerOnPlay}


procedure TMacroMagic.TriggerOnPlayEnded;
begin
FState:=msIdle;
if Assigned(FOnPlayEndedEvent) then FOnPlayEndedEvent;
end; {procedure TriggerOnPlayEnded}


procedure TMacroMagic.TriggerOnPlayCancelled;
begin
FState:=msIdle;
if Assigned(FOnPlayCancelledEvent) then FOnPlayCancelledEvent;
end; {procedure TriggerOnPlayCancelled}


procedure TMacroMagic.TriggerOnRecord;
begin
FState:=msRecording;
if Assigned(FOnRecordEvent) then FOnRecordEvent;
end; {procedure TriggerOnRecord}


procedure TMacroMagic.TriggerOnRecordEnded;
begin
FState:=msIdle;
if Assigned(FOnRecordEndedEvent) then FOnRecordEndedEvent;
end; {procedure TriggerOnRecordEnded}


procedure TMacroMagic.TriggerOnRecordCancelled;
begin
FState:=msIdle;
if Assigned(FOnRecordCancelledEvent) then FOnRecordCancelledEvent;
end; {procedure TriggerOnRecordCancelled}

end.
