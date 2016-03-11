{
  Current Version: 1.21

  This component was designed and programmed by Jose Sebastian Battig,
  this is freeware software, so im not responsible for its use and possible damage and
  your pc total destruction. But, if you have questions about it's working just e-mail me

  E-Mail: sbattig@bigfoot.com

  Last correction (v1.21):
  changed

  History.Delete (i);

  by

  History.Delete (0);

  in the finalization part of the unit.
  Deleted the variable i declared in the bottom of the unit.
}

unit HistoryCombo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DB, DBTables, DBGrids, ExtCtrls;

type
  TAddStringMode = (addOnExit, addOnUpdate);
  TAddStringModeSet = set of TAddStringMode;
  TDBHistoryComboBox = class(TDBComboBox)
  private
    FLastOnExit : TNotifyEvent;
    FHistoryId : string;
    FAddStringMode : TAddStringModeSet;
    FLastUpdateData : TNotifyEvent;
    FItemsList : TStringList;
    FEnabledTypeHelp : boolean;
    FEnabledGridTypeHelp : boolean;
    WaitChange : boolean;
    DataLink : TFieldDataLink;
    FDBGrid : TDBGrid;
    FDBColumn : integer;
    LastGridKeyPress : TKeyPressEvent;
    UpdateSelStart : boolean;
    function GetDataSource : TDataSource;
    procedure SetDataSource (value : TDataSource);
    function GetDataField : string;
    procedure SetDataField (const value : string);
    procedure SetHistoryId (const value : string);
    procedure SetAddStringMode (value : TAddStringModeSet);
    procedure NewOnExit (Sender : TObject);
    procedure NewUpdateData (Sender : TObject);
    class procedure AddString (SelfObject : TObject; const Cad : string);
    class procedure DeleteFromList (Obj : TObject);
    class procedure InsertInList (const Value : string; Obj : TObject);
    function GetKeepGlobalHistory : boolean;
    procedure SetKeepGlobalHistory (value : boolean);
    procedure NewGridKeyPress (Sender : TObject; var Key : char);
    procedure SetDBGrid (value : TDBGrid);
  protected
    procedure Loaded; override;
    procedure KeyPress(var Key : char); override;
    procedure Change; override;
    procedure Notification (AComponent : TComponent; AOperation : TOperation); override;
  public
    constructor Create (AOwner : TComponent); override;
    destructor Destroy; override;
    procedure AddText;
  published
    property MaxLength;
    property DataSource : TDataSource read GetDataSource write SetDataSource;
    property DataField : string read GetDataField write SetDataField;
    property HistoryId : string read FHistoryId write SetHistoryId;
    property AddStringMode : TAddStringModeSet read FAddStringMode write SetAddStringMode;
    property KeepGlobalHistory : boolean read GetKeepGlobalHistory write SetKeepGlobalHistory default true;
    property EnabledTypeHelp : boolean read FEnabledTypeHelp write FEnabledTypeHelp default true;
    property EnabledGridTypeHelp : boolean read FEnabledGridTypeHelp write FEnabledGridTypeHelp default false;
    property DBGrid : TDBGrid read FDBGrid write SetDBGrid;
    property DBColumn : integer read FDBColumn write FDBColumn;
  end;

  THistoryComboBox = class(TComboBox)
  private
    FLastOnExit : TNotifyEvent;
    FHistoryId : string;
    FItemsList : TStringList;
    FEnabledTypeHelp : boolean;
    WaitChange : boolean;
    procedure SetHistoryId (const value : string);
    procedure NewOnExit (Sender : TObject);
    function GetKeepGlobalHistory : boolean;
    procedure SetKeepGlobalHistory (value : boolean);
  protected
    procedure Loaded; override;
    procedure KeyPress(var Key : char); override;
    procedure Change; override;
  public
    constructor Create (AOwner : TComponent); override;
    destructor Destroy; override;
    procedure AddText;
  published
    property HistoryId : string read FHistoryId write SetHistoryId;
    property KeepGlobalHistory : boolean read GetKeepGlobalHistory write SetKeepGlobalHistory default true;
    property EnabledTypeHelp : boolean read FEnabledTypeHelp write FEnabledTypeHelp default true;
  end;

procedure Register;

implementation

uses
  TypInfo, Grids;

type
  TTypingHelp = class
    DBCombo : TDBHistoryComboBox;
    LastJ : integer;
    procedure OnTimer (Sender : TObject);
  end;

  TExposeGrid = class (TCustomGrid)
    function GetInPlaceEditor : TInPlaceEdit;
    property InPlaceEditor : TInPlaceEdit read GetInPlaceEditor;
  end;

var
  RegisteredCombos : TStringList;
  History : TStringList;
  KeepHistory : boolean;
  HelpTimer : TTimer;
  TypingHelp : TTypingHelp;

procedure Register;
begin
  RegisterComponents('Upgrade Suite', [TDBHistoryComboBox, THistoryComboBox]);
end;

{ TExposeGrid }

function TExposeGrid.GetInPlaceEditor;
begin
  Result := inherited InPlaceEditor;
end;

{ TTypingHelp }

procedure TTypingHelp.OnTimer;
var
  Cad : string;
  InPlaceEditor : TCustomEdit;
  i, j : integer;
  F : TField;
begin
  try
    if DBCombo <> nil
      then with DBCombo do
        begin
          InPlaceEditor := TExposeGrid (FDBGrid).InPlaceEditor;
          if (InPlaceEditor <> nil) and (FDBGrid.DataSource.State = dsEdit)
            then
            begin
              Cad := InPlaceEditor.Text;
              if not UpdateSelStart
                then
                begin
                  FItemsList.Find (Cad, i);
                  if (i < FItemsList.Count) and (Cad = copy (FItemsList [i], 1, length (Cad)))
                    then
                    begin
                      j := length (Cad);
                      F := FDBGrid.SelectedField;
                      if F <> nil
                        then
                        begin
                          F.AsString := FItemsList [i];
                          UpdateSelStart := true;
                          LastJ := j;
                        end;
                    end;
                end
                else
                begin
                  try
                    with TExposeGrid (FDBGrid).InPlaceEditor do
                      begin
                        SelStart := Lastj;
                        SelLength := length (Cad) - Lastj;
                      end;
                  finally
                    UpdateSelStart := false;
                    DBCombo := nil;
                  end;
                end;
            end;
        end;
  finally
    (Sender as TTimer).Enabled := DBCombo <> nil;
  end;
end;

{ TDBHistoryComboBox }

constructor TDBHistoryComboBox.Create;
begin
  inherited Create (AOwner);
  FAddStringMode := [addOnExit, addOnUpdate];
  FEnabledTypeHelp := true;
  DataLink := TFieldDataLink (Perform (CM_GETDATALINK, 0, 0));
end;

destructor TDBHistoryComboBox.Destroy;
begin
  if not (csDesigning in ComponentState)
    then DeleteFromList (self);
  inherited Destroy;
end;

procedure TDBHistoryComboBox.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState)
    then
    begin
      if addOnExit in FAddStringMode
        then
        begin
          FLastOnExit := OnExit;
          OnExit := NewOnExit;
        end;
      if (addOnUpdate in FAddStringMode) and (DataSource <> nil)
        then
        begin
          FLastUpdateData := DataSource.OnUpdateData;
          DataSource.OnUpdateData := NewUpdateData;
        end;
    end;
end;

procedure TDBHistoryComboBox.Notification;
begin
  inherited Notification (AComponent, AOperation);
  if (AOperation = opRemove) and (AComponent = FDBGrid)
    then
    begin
      FDBGrid := nil;
      LastGridKeyPress := nil;
    end;
end;

procedure TDBHistoryComboBox.SetDBGrid;
begin
  if Value <> FDBGrid
    then
    begin
      if (not (csDesigning in ComponentState)) and (FDBGrid <> nil)
        then FDBGrid.OnKeyPress := LastGridKeyPress;
      FDBGrid := Value;
      if (not (csDesigning in ComponentState)) and (FDBGrid <> nil)
        then
        begin
          FDBGrid.Columns [FDBColumn].PickList.AddStrings (Items);
          if FEnabledGridTypeHelp
            then
            begin
              LastGridKeyPress := FDBGrid.OnKeyPress;
              FDBGrid.OnKeyPress := NewGridKeyPress;
            end;
        end;
    end;
end;

class procedure TDBHistoryComboBox.AddString;
var
   i, j : integer;
   Combo : TObject;
   AItems : TStrings;
begin
  if Trim (Cad) <> ''
    then
    begin
      j := RegisteredCombos.IndexOfObject (SelfObject);
      if j >= 0
        then
        begin
          j := History.IndexOf (RegisteredCombos [j]);
          if j >= 0
            then if TStringList (History.Objects [j]).IndexOf (Cad) < 0
              then
              begin
                TStringList (History.Objects [j]).Add (Cad);
                for i := 0 to RegisteredCombos.Count - 1 do
                  if History [j] = RegisteredCombos [i]
                    then
                    begin
                      Combo := RegisteredCombos.Objects [i];
                      AItems := TStrings (GetOrdProp (Combo, GetPropInfo (Combo.ClassInfo, 'Items')));
                      if AItems <> nil
                        then AItems.Add (Cad);
                      if Combo is TDBHistoryComboBox
                        then with Combo as TDBHistoryComboBox do
                          begin
                            if FDBGrid <> nil
                              then FDBGrid.Columns [FDBColumn].PickList.Add (Cad);
                          end;
                    end;
              end;
        end;
    end;
end;

procedure TDBHistoryComboBox.KeyPress;
begin
  inherited KeyPress (Key);
  if FEnabledTypeHelp and (FItemsList <> nil) and (FItemsList.Count > 0) and (not (Key in [#8, #27]))
    then WaitChange := true;
end;

procedure TDBHistoryComboBox.NewGridKeyPress;
begin
  if (FEnabledGridTypeHelp) and (FItemsList <> nil) and (FItemsList.Count > 0) and (not (Key in [#8, #27]))
    then
    begin
      if (FDBGrid.SelectedField <> nil) and (FDBGrid.SelectedField = FDBGrid.Columns [FDBColumn].Field)
        then
        begin
          TypingHelp.DBCombo := self;
          HelpTimer.Enabled := true;
        end;
    end;
  if assigned (LastGridKeyPress)
    then LastGridKeyPress (Sender, Key);
end;

procedure TDBHistoryComboBox.Change;
var
  i, j : integer;
  F : TField;
begin
  inherited Change;
  if WaitChange
    then
    begin
      try
        FItemsList.Find (Text, i);
        if (i < FItemsList.Count) and (Text = copy (FItemsList [i], 1, length (Text)))
          then
          begin
            j := length (Text);
            if DataLink <> nil
              then
              begin
                F := DataLink.Field;
                if F <> nil
                  then
                  begin
                    F.AsString := FItemsList [i];
                    { The next line is because the implementation of the SelStart and the
                      SelLength properties is buggy in the class TCustomComboBox, this
                      is the correct way to use the message CB_SETEDITSEL message }
                    Perform (CB_SETEDITSEL, 0, MAKELPARAM (j, length (Text)));
                  end;
              end;
          end;
      finally
        WaitChange := false;
      end;
    end;
end;

procedure TDBHistoryComboBox.NewOnExit;
begin
  try
    AddString (self, Text);
  finally
    if assigned (FLastOnExit)
      then FLastOnExit (Sender);
  end;
end;

procedure TDBHistoryComboBox.AddText;
begin
  AddString (self, Text);
end;

procedure TDBHistoryComboBox.NewUpdateData;
begin
  try
    AddString (self, Text);
  finally
    if assigned (FLastUpdateData)
      then FLastUpdateData (Sender);
  end;
end;

class procedure TDBHistoryComboBox.DeleteFromList;
var
  j : integer;
  Cad : string;
begin
  if Obj is TDBHistoryComboBox
    then (Obj as TDBHistoryComboBox).FItemsList := nil
    else (Obj as THistoryComboBox).FItemsList := nil;
  j := RegisteredCombos.IndexOfObject (Obj);
  if j >= 0
    then
    begin
      Cad := RegisteredCombos [j];
      RegisteredCombos.Delete (j);
      j := RegisteredCombos.IndexOf (Cad);
      if (j < 0) and (not KeepHistory)
        then
        begin
          j := History.IndexOf (Cad);
          if j >= 0
            then
            begin
              with TStringList (History.Objects [j]) do
                begin
                  try
                    SaveToFile (ExtractFilePath (Application.ExeName) + Cad + '.txt');
                  except
                  end;
                  Free;
                end;
              History.Delete (j);
            end;
        end;
    end;
end;

class procedure TDBHistoryComboBox.InsertInList;
var
  St : TStringList;
  j : integer;
  AItems : TStrings;
  Strings : TStringList;
begin
  RegisteredCombos.AddObject (value, obj);
  j := History.IndexOf (value);
  AItems := TStrings (GetOrdProp (Obj, GetPropInfo (Obj.ClassInfo, 'Items')));
  if j < 0
    then
    begin
      St := TStringList.Create;
      if Obj is TDBHistoryComboBox
        then (Obj as TDBHistoryComboBox).FItemsList := St
        else (Obj as THistoryComboBox).FItemsList := St;
      with St do
        begin
          Sorted := true;
          Duplicates := dupIgnore;
          try
            LoadFromFile (ExtractFilePath (Application.ExeName) + Value + '.txt');
            AItems.AddStrings (St);
          except
          end;
        end;
      History.AddObject (Value, St);
    end
    else
    begin
      Strings := TStringList (History.Objects [j]);
      if Obj is TDBHistoryComboBox
        then (Obj as TDBHistoryComboBox).FItemsList := Strings
        else (Obj as THistoryComboBox).FItemsList := Strings;
      AItems.AddStrings (Strings);
    end;
end;

function TDBHistoryComboBox.GetDataSource;
begin
  Result := inherited DataSource;
end;

procedure TDBHistoryComboBox.SetDataSource;
begin
  if value <> DataSource
    then
    begin
      if [csDesigning, csReading, csLoading] * ComponentState = []
        then
        begin
          if (DataSource <> nil) and (addOnUpdate in FAddStringMode)
            then DataSource.OnUpdateData := FLastUpdateData;
          FLastUpdateData := nil;
          if (addOnUpdate in FAddStringMode) and (value <> nil)
            then
            begin
              FLastUpdateData := value.OnUpdateData;
              value.OnUpdateData := NewUpdateData;
            end;
        end;
      inherited DataSource := value;
    end;
end;

function TDBHistoryComboBox.GetDataField;
begin
  Result := inherited DataField;
end;

procedure TDBHistoryComboBox.SetDataField;
begin
  if (csDesigning in ComponentState) and (Value <> inherited DataField)
    then if FHistoryId = ''
      then HistoryId := Value;
  inherited DataField := Value;
end;

procedure TDBHistoryComboBox.SetHistoryId;
begin
  if (FHistoryId <> value)
    then
    begin
      if not (csDesigning in ComponentState)
        then
        begin
          DeleteFromList (self);
          InsertInList (Value, self);
        end;
      FHistoryId := value;
    end;
end;

procedure TDBHistoryComboBox.SetAddStringMode;
begin
  if Value <> FAddStringMode
    then
    begin
      if [csDesigning, csReading, csLoading] * ComponentState = []
        then
        begin
          if DataSource <> nil
            then if not (addOnUpdate in FAddStringMode)
              then
              begin
                DataSource.OnUpdateData := FLastUpdateData;
                FLastUpdateData := nil;
              end
              else
              begin
                FLastUpdateData := DataSource.OnUpdateData;
                DataSource.OnUpdateData := NewUpdateData;
              end;
          if not (addOnExit in FAddStringMode)
            then
            begin
              OnExit := FLastOnExit;
              FLastOnExit := nil;
            end
            else
            begin
              FLastOnExit := OnExit;
              OnExit := NewOnExit;
            end;
        end;
      FAddStringMode := value;
    end;
end;

function TDBHistoryComboBox.GetKeepGlobalHistory;
begin
  Result := KeepHistory;
end;

procedure TDBHistoryComboBox.SetKeepGlobalHistory;
begin
  KeepHistory := value;
end;

{ THistoryComboBox }

constructor THistoryComboBox.Create;
begin
  inherited Create (AOwner);
  FEnabledTypeHelp := true;
end;

destructor THistoryComboBox.Destroy;
begin
  if not (csDesigning in ComponentState)
    then TDBHistoryComboBox.DeleteFromList (self);
  inherited Destroy;
end;

procedure THistoryComboBox.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState)
    then
    begin
      FLastOnExit := OnExit;
      OnExit := NewOnExit;
    end;
end;

procedure THistoryComboBox.KeyPress;
begin
  inherited KeyPress (Key);
  if FEnabledTypeHelp and (FItemsList <> nil) and (FItemsList.Count > 0) and (not (Key in [#8, #27]))
    then WaitChange := true;
end;

procedure THistoryComboBox.Change;
var
  i, j : integer;
begin
  inherited Change;
  if WaitChange
    then
    begin
      try
        FItemsList.Find (Text, i);
        if (i < FItemsList.Count) and (Text = copy (FItemsList [i], 1, length (Text)))
          then
          begin
            j := length (Text);
            Text := FItemsList [i];
            { The next line is because the implementation of the SelStart and the
            SelLength properties is buggy in the class TCustomComboBox, this
            is the correct way to use the message CB_SETEDITSEL message }
            Perform (CB_SETEDITSEL, 0, MAKELPARAM (j, length (Text)));
          end;
      finally
        WaitChange := false;
      end;
    end;
end;

procedure THistoryComboBox.NewOnExit;
begin
  try
    TDBHistoryComboBox.AddString (self, Text);
  finally
    if assigned (FLastOnExit)
      then FLastOnExit (Sender);
  end;
end;

procedure THistoryComboBox.AddText;
begin
  TDBHistoryComboBox.AddString (self, Text);
end;  

procedure THistoryComboBox.SetHistoryId;
begin
  if (FHistoryId <> value)
    then
    begin
      if not (csDesigning in ComponentState)
        then
        begin
          TDBHistoryComboBox.DeleteFromList (self);
          TDBHistoryComboBox.InsertInList (Value, self);
        end;
      FHistoryId := value;
    end;
end;

function THistoryComboBox.GetKeepGlobalHistory;
begin
  Result := KeepHistory;
end;

procedure THistoryComboBox.SetKeepGlobalHistory;
begin
  KeepHistory := value;
end;

initialization
  KeepHistory := true;
  RegisteredCombos := TStringList.Create;
  with RegisteredCombos do
    begin
      Sorted := true;
      Duplicates := dupAccept;
    end;
  History := TStringList.Create;
  with History do
    begin
      Sorted := true;
      Duplicates := dupIgnore;
    end;
  HelpTimer := TTimer.Create (nil);
  HelpTimer.Interval := 1;
  HelpTimer.Enabled := false;
  TypingHelp := TTypingHelp.Create;
  HelpTimer.OnTimer := TypingHelp.OnTimer;
finalization
  while History.Count > 0 do
    begin
      with TStringList (History.Objects [0]) do
        begin
          SaveToFile (ExtractFilePath (Application.ExeName) + History [0] + '.txt');
          Free;
        end;
      History.Delete (0);
    end;
  TypingHelp.Free;
  HelpTimer.Free;
  History.Free;
  RegisteredCombos.Free;
end.
