unit TimeOut;

{
TTimeOut - FREEWARE component
version 1.0
Copyright G.Ferrari 1997
Stops your application if evaluating
time is finished and shows a warning message
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, MMSystem;

type
  TTimeOut = class(TComponent)
  private
  { Private declarations }
  FLastDay: String;
  FMessage: String;
  protected
  { Protected declarations }
  public
  { Public declarations }
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure Execute;
  published
  property Name;
  property Message: string read FMessage write FMessage;
  property LastDay: string read FLastDay write FLastDay;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Upgrade Suite', [TTimeOut]);
end;

constructor TTimeOut.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
FLastDay := FormatDateTime('DD/MM/YYYY', Now);
FMessage := 'Sorry, no more time to evaluate the program.';
end;

destructor TTimeOut.Destroy;
begin
inherited Destroy;
end;

procedure TTimeOut.Execute;
var Today, StopDate: string;
begin
Today := FormatDateTime('YYYYMMDD', Now);
if Length(LastDay) <>10 then LastDay := FormatDateTime('DD/MM/YYYY', Now);
StopDate:= LastDay[7]+LastDay[8]+LastDay[9]+LastDay[10]
+LastDay[4]+LastDay[5]+LastDay[1]+LastDay[2];
if Today>StopDate then begin
MessageDlg(FMessage,mtWarning,[mbok],0);
Application.Terminate;
end;
end;

end.
