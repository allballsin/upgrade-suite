{
ZWECK       : Komponenten TMailslotServer und TMailslotClient
              Netzwerkkommunikation über MailSlots

DATEIEN     : ms01.dpr
              ms01u1.pas
              ms01u1.dfm

STAND       : 19.4.97 Version 1.00.00

AUTOR       : Kurt Spitzley, email (101.10490@germanynet.de or Kurt.Spitzley@rz-online.de)

COPYRIGHT   : (c) 1997 bei Kurt Spitzley, All rights reserved.
              Diese Software darf zu nichtkommerziellen Zwecken frei genutzt
              und weitergegeben werden. Kommerzielle Nutzung nur mit ausdrück-
              licher Genehmigung des Autors.
GEWÄHR-
LEISTUNG    : Sie akzeptieren diese Software wie sie ist, ohne eine Garantie
              jeglicher Art, einschließlich aber nicht ausschließlich der
              Eignung für eine beliebige Anwendung.

BESCHREIBUNG:

Sollen mehrere Programme (auch auf verschiedene Rechner verteilt) miteinander
kommunizieren, so kann dies über sogenannte 'Mailslots' erfolgen. Dieses Verfahren
erlaubt das Senden von Nachrichten an einen oder mehrere Empfänger (broadcasting).
Ein Empfänger wird spezifiziert durch
-  Name des Rechners, der Domäne oder '*' oder '.'
-  Name des Mailslots
Beispiele eines solchen Adressstrings sind:

\\MyGrp\mailslot\xyz      :  Domäne 'MyGrp'
                             alle Applikationen mit Mailslot 'xyz'
\\MyPC\mailslot\ChannelA  :  Rechner 'MyPC'
                             alle Applikationen mit Mailslot 'ChannelA'
\\MyPC\mailslot\ChannelA  :  Rechner 'MyPC'
                             alle Applikationen mit Mailslot 'ChannelA'
\\.\mailslot\MyMailSl     : lokaler Mailslot
                            alle Applikationen mit Mailslot 'MyMailSl'
\\*\mailslot\ChannelA     : alle Rechner der Primärdomäne
                            alle Applikationen mit Mailslot 'ChannelA'

Unbedingt zu beachten ist, daß die Nachricht, die an einen bestimmten Mailslot
gesendet werden soll, über jedes verfügbare Netzwerkprotokoll gesendet wird.
Dies bedeutet, daß auf einem Rechner mit bsw. den Protokollen NET-BEUI, IPX und
TCP/IP eine gesendete Nachricht gleich dreimal beim Empfänger aufläuft. Um hier
Konflikte zu vermeiden, sollte jede Nachricht mit einer ID versehen werden, so
daß mehrfache Nachrichten ausgesondert werden können.

Es gibt verschiedene TMailslot-Komponenten:
TMailslotServer - Empfängt Mails
TMailslotClient - Sendet Mails

ANWENDUNG: siehe Beispielprogramme

TMailslotServer:

PROPERTIES:
AllowDupMsgs: boolean
  Blendet mehrfache Mails (verursacht durch bsw. mehrere Netzwerkprotokolle) aus
Mailslot: string
  Name des Mailslots

METHODEN:
function MailAvailable:boolean;
  True wenn Mails vorhanden
function ReadString:string;
  Liest eine Mail aus

EVENTS:
property OnMail: TNotifyMailEvent
  Löst aus wenn Mails vorhanden

TMailslotClient:

PROPERTIES:
Mailslot: string
  Name des Mailslots
MachineOrDomain: string
  Name des Rechners oder der Domäne

METHODEN:
function WriteString(s: string):boolean;
  Sendet eine Mail

================================================================================

SCOPE       : Components TMailslotServer and TMailslotClient
              Network-Communication via MailSlots

FILES       : ms01.dpr
              ms01u1.pas
              ms01u1.dfm

LAST CHANGES: 19.4.97 Version 1.00.00

AUTHOR      : Kurt Spitzley, email 0225438-0001@t-online.de

COPYRIGHT   : (c) 1997 by Kurt Spitzley, All rights reserved.
              This software should not be SOLD by anyone. It is distributed as
              freeware and therefore may be used free of charge.

DISCLAIMER  : You accept this software AS IS without any representation or
              warranty of any kind, including but not limited to the warranty of
              merchantability or fitness for a particular purpose.

DESCRIPTION:

A means for communication of multiple applications (on multiple machines too) are
'mailslots'. By this way messages can be sent to one or more recipients(broadcasting).
A recipient is specified through:
-  name of machine, domain or '*' oder '.'
-  name of mailslot
Examples for such address-strings are:

\\MyGrp\mailslot\xyz      :  domain 'MyGrp'
                             all applications with mailslot 'xyz'
\\MyPC\mailslot\ChannelA  :  machine 'MyPC'
                             all applications with mailslot 'ChannelA'
\\MyPC\mailslot\ChannelA  :  machine 'MyPC'
                             all applications with mailslot 'ChannelA'
\\.\mailslot\MyMailSl     :  local mailslot
                             all applications with mailslot 'MyMailSl'
\\*\mailslot\ChannelA     :  all machines of primary domain
                             all applications with mailslot 'ChannelA'

You should realize, that each message to be sent to a specific mailslot will be
transmitted via each available network-protocol. For a machine with e.g. the
implemented protocols NET-BEUI, IPX and TCP/IP each message will be transmitted
three times. To avoid conflicts here, each message should be signed with an
unique ID, so that at the recipients site multiple messages can be recognized.

There are several TMailslot-Components:
TMailslotServer - Receives Mails
TMailslotClient - Sends Mails

USAGE: see examples

TMailslotServer:

PROPERTIES:
AllowDupMsgs: boolean
  Discard multiple Mails (e.g. caused by multiple network-protocols)
Mailslot: string
  Name of Mailslot

METHODS:
function MailAvailable:boolean;
  True if mail exists
function ReadString:string;
  Read a mail

EVENTS:
property OnMail: TNotifyMailEvent
  Fires on new mails

TMailslotClient:

PROPERTIES:
Mailslot: string
  Name of Mailslot
MachineOrDomain: string
  Name of machine or domain

METHODS:
function WriteString(s: string):boolean;
  Sends a mail
}

unit MailSlot;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

const
  ComponentPage = 'KSDKB';
  MAILSLOT_WAIT_FOREVER = -1;
  MsgTerminate = 'This is the Mailslot-Server-Terminating Message';

type

  TMailslotServer = class;
  TMailslotClient= class;

  TReadThread = class(TThread)
  private
    FMsServer:TMailslotServer; // Reference on thread's Owner(a Mailslot-Server)
    FMailslotName: string;
    FTerminatorClient: TMailslotClient;  // local ms-client used to terminate thread
    FMail: string;
    FShutDown: boolean;
  protected
    procedure Execute; override;
    procedure FireMailEvent;  //Synchronized proc to fire OnMail-Event
    procedure ShutDown;  // Force leaving of 'hanging' ReadFile in thread's Execute-Method
  public
    constructor Create( AOwner: TMailslotServer);
  end;

  EMailSlotError = class(Exception);

  TNotifyMailEvent = procedure (Sender: TObject; Mail: string) of object;

  TMailslotServer = class(TComponent)
  private
    FMailslotName: string;
    hMailslotServer: THandle;
    FReadThread: TReadThread; // Generates component-events
    FOnMail: TNotifyMailEvent; // Fires on new mail
    FLastMailId: byte; // Helps to recognize mail-clones
    FIsNewMail, // True if new mail isn't a cloned (duplicate) mail
    FAllowDupMsgs: boolean;  // Allow cloned mails (through e.g. multiple protocols)
    procedure SetOnMail(OnMail:TNotifyMailEvent);
    procedure SetMailslotName(MailslotName:string);
  protected
    { Protected-Deklarationen }
  public
    constructor Create(AOwner: TComponent; MailslotName:string);
    destructor Destroy; override;
    function MailAvailable:boolean;
    function ReadString:string;
  published
    property OnMail: TNotifyMailEvent read FOnMail write SetOnMail;
    property AllowDupMsgs: boolean read FAllowDupMsgs write FAllowDupMsgs default false;
    property Mailslot: string read FMailslotName write SetMailslotName;
  end;

  TMailSlotClient = class(TComponent)
  private
    FMailslotName,
    FMachineOrDomain: string;
    FMailId: byte;
    hMailslotClient: THandle;
    procedure SetMailslotName(MailslotName:string);
    procedure SetMachineOrDomain(MachineOrDomain:string);
    procedure CreateMailslotClient;
  protected
    { Protected-Deklarationen }
  public
    constructor Create(AOwner: TComponent; MachineOrDomain,MailSlotName: string);
    destructor Destroy; override;
    function WriteString(s: string):boolean;
  published
    property Mailslot: string read FMailslotName write SetMailslotName;
    property MachineOrDomain: string read FMachineOrDomain write SetMachineOrDomain;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Upgrade Suite',[TMailslotServer,TMailSlotClient]);
end;

//------------------------------------------------------------------------------

constructor TReadThread.Create(AOwner: TMailslotServer);
begin
  inherited Create(false); // Suspended=false
  FMsServer:=AOwner; // Thread needs to know his owner to access him
  FMailslotName:=FMsServer.FMailslotName;
  FreeOnterminate:=true; // Automatic destroying of Thread-Object after terminate
end;

procedure TReadThread.ShutDown;
begin
  // Create a mailslot-file-handle for sending Terminator-mail
  FTerminatorClient:=TMailSlotClient.Create(FMsServer,'.',FMailslotName);
  FTerminatorClient.WriteString(MsgTerminate);
  FTerminatorClient.Free;
  repeat until FShutDown;
end;

procedure TReadThread.Execute;
Label
  EndThread;
var
  CharsRead: dword;
begin
  with FMsServer do
    begin
      FShutDown:=false;
      while true do
        begin
          SetLength(FMail,1); // Allocate space for 1 char
          // ReadFile doesn't return until there is a mail in the queue.
          // Non-Overlapped-Mode causes the thread to 'hang' here on no data.
          // Furthermore ReadFile never will fill FMail with data. The reason is
          // that a mail contains at least 3 char's (ID-No.) and FMail's space
          // is restricted to 1 char. FMail is filled by ReadString.

          // To ensure thread-terminating before destroying the component, the
          // destructor posts a terminating-mail to the ms-server via a local
          // created ms-client. This causes leaving of 'hanging' ReadFile and
          // Endless-Loop.
          ReadFile(hMailslotServer,PChar(FMail)^,1,CharsRead,nil);
          FMail:=ReadString; // Get mail
          if pos(MsgTerminate,FMail)<>0 then // Thread-Terminating-mail ?
            goto EndThread;
          if assigned(FOnMail)then
            if FAllowDupMsgs or FIsNewMail then
              Synchronize(FireMailEvent);
        end;
EndThread:
      FShutDown:=true;
    end;
end;

procedure TReadThread.FireMailEvent;
begin
  FMsServer.FOnMail(FMsServer,FMail);
end;

//------------------------------------------------------------------------------

constructor TMailslotServer.Create(AOwner: TComponent; MailslotName:string);
begin
  inherited Create(AOwner);
  hMailslotServer:=INVALID_HANDLE_VALUE;
  SetMailslotName(MailslotName);
  FReadThread:=nil;
  FAllowDupMsgs:=false; // Ignore mail-clones (through e.g. multiple network-protocols)
  FLastMailId:=0;
end;

destructor TMailslotServer.Destroy;
begin
  if not (csDesigning in ComponentState) then
    begin
      if assigned(FReadThread) then
        FReadThread.ShutDown;
      CloseHandle(hMailslotServer);
    end;
  inherited Destroy;
end;

procedure TMailslotServer.SetOnMail(OnMail:TNotifyMailEvent);
begin
  FOnMail:=OnMail;
  if (not (csDesigning in ComponentState))and
     (FMailslotName<>'') then
    begin
      // Thread will be created only on event-driven operation
      if assigned(FOnMail) then
        begin
          if not assigned(FReadThread) then // Thread still exists ?
            try
              FLastMailId:=0;
              FReadThread := TReadThread.Create(self);
            except
              raise EMailslotError.Create( 'Unable to create Read thread' );
            end;
        end
      else
        if assigned(FReadThread) then
          begin
            FReadThread.ShutDown;
            FReadThread:=nil;
          end;
    end;
end;

procedure TMailslotServer.SetMailslotName(MailslotName:string);
begin
  FMailslotName:=MailslotName;
  if not (csDesigning in ComponentState) then
    begin
      // If property Mailslot and event OnMail have valid values, the existing
      // read-thread must be terminated and replaced by a new read-thread
      // who operates on the newly generated hMailslotServer-handle
      if assigned(FReadThread) then
        begin
          FReadThread.ShutDown;
          FReadThread:=nil;
        end;
      // If there is one, delete old server
      if hMailslotServer<>INVALID_HANDLE_VALUE then
        begin
          CloseHandle(hMailslotServer);
          hMailslotServer:=INVALID_HANDLE_VALUE;
        end;
      // A new server will only be created on a valid name
      if MailslotName<>'' then
        begin
          // Create a mailslot-server-handle for receiving mails
          hMailslotServer:=CreateMailslot(pchar('\\.\mailslot\'+MailSlotName),
                           0,
                           MAILSLOT_WAIT_FOREVER,
                           PSecurityAttributes(nil));
          if hMailslotServer=INVALID_HANDLE_VALUE then
            raise EMailSlotError.Create('Error creating mailslot-server');
          // On case that OnMail-Event has been assigned before setting the
          // mailslot-property, no read-thread could be created. Do it now.
          if assigned(FOnMail) then
            SetOnMail(FOnMail);
        end;
    end;
end;

function TMailslotServer.MailAvailable:boolean;
var
  NextSize,
  MessageCount: dword;
begin
  GetMailslotInfo(hMailslotServer,nil,NextSize,addr(MessageCount),nil);
  Result:=NextSize<>-1;
end;

function TMailslotServer.ReadString:string;
var
  NextSize,
  MessageCount,
  CharsRead: dword;
  s:string;
  ActMailId: byte;
begin
  GetMailslotInfo(hMailslotServer,nil,NextSize,addr(MessageCount),nil);
  if NextSize<>-1 then
    begin
      SetLength(s,NextSize); // Allocate space
      ReadFile(hMailslotServer,PChar(s)^,NextSize,CharsRead,nil);
      SetLength(s,CharsRead); // Adjust length
      ActMailId:=StrToInt(copy(s,1,3));
      s:=copy(s,4,length(s)-3); // Remove mailId
      // Cloned mails through multiple network-protocol's are discarded
      if (ActMailId=FLastMailId)and not(FAllowDupMsgs) then
        begin
          FIsNewMail:=false;
          s:='';
        end
      else
        FIsNewMail:=true;
      FLastMailId:=ActMailId;
    end
  else
    s:='';
  Result:=s;
end;

//------------------------------------------------------------------------------

constructor TMailSlotClient.Create(AOwner: TComponent; MachineOrDomain,MailSlotName: string);
begin
  inherited Create(AOwner);
  hMailslotClient:=INVALID_HANDLE_VALUE;

  // As a mail is sent for each installed network-protocol, an unique MailId is
  // added to each mail so that multiple mails can be discarded.
  FMailId:=0;

  FMachineOrDomain:=MachineOrDomain;
  FMailSlotName:=MailslotName;

  CreateMailslotClient;
end;

destructor TMailSlotClient.Destroy;
begin
  CloseHandle(hMailslotClient);
  inherited Destroy;
end;

procedure TMailslotClient.CreateMailslotClient;
begin
  if not (csDesigning in ComponentState) then
    begin
      // If there is one, delete old server
      if hMailslotClient<>INVALID_HANDLE_VALUE then
        begin
          CloseHandle(hMailslotClient);
          hMailslotClient:=INVALID_HANDLE_VALUE;       
        end;
      // A new client will only be created on valid machine/domain and mailslot-name
      if (FMachineOrDomain<>'')and(FMailslotName<>'') then
        begin
          // Create a mailslot-client-handle for sending mails
          hMailslotClient:=
            CreateFile(pchar('\\'+FMachineOrDomain+'\mailslot\'+FMailSlotName),
              GENERIC_WRITE,
              FILE_SHARE_READ,
              PSecurityAttributes(nil),
              OPEN_EXISTING,
              FILE_ATTRIBUTE_NORMAL,
              0);
          if hMailslotClient=INVALID_HANDLE_VALUE then
            raise EMailSlotError.Create('Error creating mailslot-client');
        end;
    end;
end;

procedure TMailslotClient.SetMailslotName(MailslotName:string);
begin
  FMailslotName:=MailslotName;
  CreateMailslotClient;
end;

procedure TMailslotClient.SetMachineOrDomain(MachineOrDomain:string);
begin
  FMachineOrDomain:=MachineOrDomain;
  CreateMailslotClient;
end;

function TMailslotClient.WriteString(s: string):boolean;
var
  TextToSend: string;
  NumBytesWritten: dword;
begin
  // Write mail to mailslot
  inc(FMailId);
  TextToSend:=format('%.3d%s',[FMailId,s]);
  Result:=WriteFile(hMailslotClient,
                    pchar(TextToSend)^,
                    length(TextToSend),
                    NumBytesWritten,
                    nil);
end;

end.
