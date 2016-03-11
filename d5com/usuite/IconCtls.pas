{$I DFS.INC}  { Standard defines for all Delphi Free Stuff components }

{------------------------------------------------------------------------------}
{ TIconComboBox and TIconListBox v1.10                                         }
{------------------------------------------------------------------------------}
{ A Caching Icon ComboBox and ListBox component for Delphi.                    }
{ Copyright 1998, Brad Stowers.  All Rights Reserved.                          }
{ This component can be freely used and distributed in commercial and private  }
{ environments, provied this notice is not modified in any way.                }
{------------------------------------------------------------------------------}
{ Feel free to contact me if you have any questions, comments or suggestions   }
{ at bstowers@pobox.com.                                                       }
{ The latest version will always be available on the web at:                   }
{   http://www.pobox.com/~bstowers/delphi/                                     }
{ See IconCtls.txt for notes, known issues, and revision history.              }
{------------------------------------------------------------------------------}
{ Date last modified:  July 7, 1998                                            }
{------------------------------------------------------------------------------}


{ C++Builder 3 requires this if you use run-time packages. }
{$IFDEF DFS_CPPB_3_UP}
  {$ObjExportAll On}
{$ENDIF}

unit IconCtls;

interface

{$IFDEF DFS_WIN32}
  {$R IconCtls.res}
{$ELSE}
  {$R IconCtls.r16}
{$ENDIF}

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DFSAbout, Menus;

const
  DFS_COMBO_VERSION = 'TIconComboBox v1.10';
  DFS_LIST_VERSION  = 'TIconListBox v1.10';

type
  TIconComboBox = class(TCustomComboBox)
  private
    { Variables for properties }
    FFileName: String;
    FAutoDisable: boolean;
    FEnableCaching: boolean;
    FNumberOfIcons: integer;
    FOnFileChange: TNotifyEvent;

    { Routines that should only be used internally by component }
    procedure LoadIcons;
    procedure FreeIcons;
    procedure UpdateEnabledState;

    procedure WMDeleteItem(var Msg: TWMDeleteItem); message WM_DELETEITEM;
  protected
    { Routines for setting property values and updating affected items }
    procedure SetFileName(Value: String);
    procedure SetAutoDisable(Value: boolean);
    procedure SetEnableCaching(Value: boolean);
    function GetVersion: TDFSVersion;
    procedure SetVersion(const Val: TDFSVersion);

    { Icon service routines }
    function  ReadIcon(const Index: integer): TIcon;
    function  GetIcon(Index: integer): TIcon;

    { Owner drawing routines }
    procedure MeasureItem(Index: Integer; var Height: Integer);              override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;

    { Returns a specific TIcon in the list.  The TIcon is owned by the
      component, so you should NEVER free it. }
    property Icon[Index: integer]: TIcon
       read GetIcon;
  published
    property Version: TDFSVersion
       read GetVersion
       write SetVersion;
    { Name of icon file to display }
    property FileName: string
       read FFileName
       write SetFileName;
    { If true, the combobox will be disabled when FileName does not exist }
    property AutoDisable: boolean
       read FAutoDisable
       write SetAutoDisable
       default TRUE;
    { If true, icons will be loaded as needed, instead of all at once }
    property EnableCaching: boolean
       read FEnableCaching
       write SetEnableCaching
       default TRUE;
    { The number of icons in the file.  -1 if FileName is not valid.  }
    property NumberOfIcons: integer
       read FNumberOfIcons
       default -1;

    { Useful if you have statics the reflect the number of icons, etc. }
    property OnFileChange: TNotifyEvent
       read FOnFileChange
       write FOnFileChange;

    { Protected properties in parent that we will make available to everyone }
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property DropDownCount default 5;
    property Enabled;
    property ItemIndex;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
{    property OnChange: TNotifyEvent read FOnChange write FOnChange;}
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  TOrientation = (lbHorizontal, lbVertical);

  TIconListBox = class(TCustomListBox)
  private
    { Private declarations }
    FFileName: String;
    FAutoDisable: boolean;
    FEnableCaching: boolean;
    FNumberOfIcons: integer;
    FItemWidth: integer;
    FXIcons: integer;
    FYIcons: integer;
    FOnChange: TNotifyEvent; { Borland forgot this one in the parent, no idea why. }
    FOnFileChange: TNotifyEvent;

    { Routines that should only be used internally by component }
    procedure LoadIcons;
    procedure FreeIcons;
    procedure UpdateEnabledState;
    procedure ResetSize;

    procedure CNDeleteItem(var Msg: TWMDeleteItem); message CN_DELETEITEM;
  protected
{    procedure CreateParams(var Params: TCreateParams);                       override;}
    { Routines for setting property values and updating affected items }
    procedure SetFileName(Value: String);
    procedure SetAutoDisable(Value: boolean);
    procedure SetEnableCaching(Value: boolean);
    procedure SetXIcons(Value: integer);
    procedure SetYIcons(Value: integer);
    function GetVersion: TDFSVersion;
    procedure SetVersion(const Val: TDFSVersion);

    { Icon service routines }
    function  ReadIcon(const Index: integer): TIcon;
    function  GetIcon(Index: integer): TIcon;

    { Owner drawing routines }
    procedure MeasureItem(Index: Integer; var Height: Integer);              override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;

    { Returns a specific TIcon in the list.  The TIcon is owned by the
      component, so you should NEVER free it. }
    property Icon[Index: integer]: TIcon
       read GetIcon;
  published
    property Version: TDFSVersion
       read GetVersion
       write SetVersion;
    { Name of icon file to display }
    property FileName: string
       read FFileName
       write SetFileName;
    { If true, the combobox will be disabled when FileName does not exist }
    property AutoDisable: boolean
       read FAutoDisable
       write SetAutoDisable
       default TRUE;
    { If true, icons will be loaded as needed, instead of all at once }
    property EnableCaching: boolean
       read FEnableCaching
       write SetEnableCaching
       default TRUE;
    { The number of icons in the file.  -1 if FileName is not valid.  }
    property NumberOfIcons: integer
       read FNumberOfIcons
       default -1;

    { Number of icons that are to be displayed in the listbox.  The width is modified  }
    { automatically when you change this property.                                     }
    property XIcons: integer
       read FXIcons
       write SetXIcons
       default 4;
    { Number of icons that are to be displayed in the listbox.  The height is modified }
    { automatically when you change this property.                                     }
    property YIcons: integer
       read FYIcons
       write SetYIcons
       default 1;
    { Useful if you have statics the reflect the number of icons, etc. }
    property OnFileChange: TNotifyEvent
       read FOnFileChange
       write FOnFileChange;

    { Protected properties in parent that we will make available to everyone }
    property Align;
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property Enabled;
    property ItemIndex;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

procedure Register;

implementation

uses
   ShellAPI, DsgnIntf;


{ TIconComboBox Component }
constructor TIconComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  { Set default values }
  FileName := '';
  AutoDisable := TRUE;
  EnableCaching := TRUE;
  FNumberOfIcons := -1;
  DropDownCount := 5;
  Style := csOwnerDrawFixed;
  ItemHeight := GetSystemMetrics(SM_CYICON) + 6;
  Height := ItemHeight;
  Font.Name := 'Arial';
  Font.Height := ItemHeight;
  Width := GetSystemMetrics(SM_CXICON) + GetSystemMetrics(SM_CXVSCROLL) + 10;
end;

procedure TIconComboBox.WMDeleteItem(var Msg: TWMDeleteItem);
var
  Icon: TIcon;
begin
  { Don't use GetIcon here! }
  Icon := TIcon(Items.Objects[Msg.DeleteItemStruct^.itemID]);
  { Free it.  If it is NIL, Free ignores it, so it is safe }
  Icon.Free;
  { Zero out the TIcon we just freed }
  Items.Objects[Msg.DeleteItemStruct^.itemID] := NIL;
end;

{ Initialize the icon handles, which are stored in the Objects property }
procedure TIconComboBox.LoadIcons;
var
  x: integer;
  Icon: TIcon;
  Buff: array[0..255] of char;
  OldCursor: TCursor;
begin
  { Clear any old icon handles }
  FreeIcons;
  { Reset the contents of the combobox }
  Clear;
  { Update the enabled state of the control }
  UpdateEnabledState;
  { If we have a valid file then setup the combobox. }
  if FileExists(FileName) then begin
    { If we are not loading on demand, set the cursor to an hourglass }
    OldCursor := Screen.Cursor;
    if not EnableCaching then
      Screen.Cursor := crHourGlass;
    { Find out how many icons are in the file }
      FNumberOfIcons := ExtractIcon(hInstance, StrPCopy(Buff, FileName),
         {$IFDEF DFS_WIN32} UINT(-1)); {$ELSE} word(-1)); {$ENDIF}
    { Loop for every icon in the file }
    for x := 0 to NumberOfIcons - 1 do begin
      { If we are not loading on demand... }
      if not EnableCaching then begin
        { Create a TIcon object... }
        Icon := TIcon.Create;
        { and assign the icon to it. }
        Icon.Handle := ExtractIcon(hInstance, Buff, x);
        { Add the icon and a dummy string to the combobox }
        Items.AddObject(Format('%d',[x]), Icon);
      end else
        { We're loading on demand, so just add a dummy string }
        Items.AddObject(Format('%d',[x]), NIL);
    end;
    { Reset the index to the first item. }
    ItemIndex := 0;
    { if not loading on demand, restore the cursor }
    if not EnableCaching then
      Screen.Cursor := OldCursor;
  end;
end;

{ Free the icon resources we created. }
procedure TIconComboBox.FreeIcons;
var
  x: integer;
  Icon: TIcon;
begin
  { Loop for every icon }
  for x := 0 to Items.Count-1 do begin
    { Get the icon object }
    Icon := TIcon(Items.Objects[x]);  { Don't use GetIcon here! }
    { Free it.  If it is NIL, Free ignores it, so it is safe }
    Icon.Free;
    { Zero out the TIcon we just freed }
    Items.Objects[x] := NIL;
  end;
  { Reset the number of Icons to reflect that we have no file. }
  FNumberOfIcons := -1;
end;

{ Disable the control if we don't have a valid filename, and option is enabled }
procedure TIconComboBox.UpdateEnabledState;
begin
  if AutoDisable then
    Enabled := FileExists(FileName)
  else
    Enabled := TRUE;
  { This could be compressed into one statement, but I don't think it }
  { is nearly as readable/understandable this way.  Looks like C.     }
{ Enabled := (AutoDisable and FileExists(FileName)) or (not AutoDisable); }
end;

{ Update the filename of the icon file. }
procedure TIconComboBox.SetFileName(Value: String);
begin
  { If new value is same as old, don't reload icons.  That's silly. }
  if FFileName = Value then exit;
  FFileName := Value;
  { Initialize icon handles from new icon file. }
  LoadIcons;
  { Call user event handler, if one exists }
  if assigned(FOnFileChange) then
    FOnFileChange(Self);
end;

{ Update the AutoDisable property }
procedure TIconComboBox.SetAutoDisable(Value: boolean);
begin
  { If it's the same, we don't need to do anything }
  if Value = FAutoDisable then exit;
  FAutoDisable := Value;
  { Update the enabled state of control based on new AutoDisable setting }
  UpdateEnabledState;
end;

{ Update the EnableCaching property }
procedure TIconComboBox.SetEnableCaching(Value: boolean);
begin
  { If it's the same, we don't need to do anything }
  if Value = FEnableCaching then exit;
  FEnableCaching := Value;
  { If load on demand is not enabled, we need to load all the icons. }
  if not FEnableCaching then
    LoadIcons;
end;

{ Used to extract icons from files and assign them to a TIcon object }
function TIconComboBox.ReadIcon(const Index: integer): TIcon;
var
  Buff: array[0..255] of char;
begin
  { Create the new icon }
  Result := TIcon.Create;
  { Assign it the icon handle }
  Result.Handle := ExtractIcon(hInstance, StrPCopy(Buff, FileName), Index);
end;

{ Returns the icon for a given combobox index }
function TIconComboBox.GetIcon(Index: integer): TIcon;
begin
  { If load on demand is enabled... }
  if EnableCaching then
    { Has the icon been loaded yet? }
    if Items.Objects[Index] = NIL then
      { No, we must get the icon and add it to Objects }
      Items.Objects[Index] := ReadIcon(Index);
  { Return the requested icon }
  Result := TIcon(Items.Objects[Index]);
end;

{ Return the size of the item we are drawing }
procedure TIconComboBox.MeasureItem(Index: Integer; var Height: Integer);
begin
  { Ask Windows how tall icons are }
  Height := GetSystemMetrics(SM_CYICON);
end;

{ Draw the item requested in the given rectangle.  Because of the parent's default }
{ behavior, we needn't worry about the State.  That's very nice.                   }
procedure TIconComboBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Icon: TIcon;
begin
  { Use the controls canvas for drawing... }
  with Canvas do begin
    try
      { Fill in the rectangle.  The proper brush has already been set up for us,   }
      { so we needn't use State to set it ourselves.                               }
      FillRect(Rect);
      { Get the icon to be drawn }
      Icon := GetIcon(Index);
      { If nothing has gone wrong, draw the icon.  Theoretically, it should never  }
      { be NIL, but why take the chance?                                           }
      if Icon <> nil then
        { Using the given rectangle, draw the icon on the control's canvas,        }
        { centering it within the rectangle.                                       }
        with Rect do Draw(Left + (Right - Left - Icon.Width) div 2,
                          Top + (Bottom - Top - Icon.Width) div 2, Icon);
    except
      { If anything went wrong, we fall down to here.  You may want to add some    }
      { sort of user notification.  No clean up is necessary since we did not      }
      { create anything.  We'll just ignore the problem and hope it goes away. :)  }
      {!};
    end;
  end;
end;

function TIconComboBox.GetVersion: TDFSVersion;
begin
  Result := DFS_COMBO_VERSION;
end;

procedure TIconComboBox.SetVersion(const Val: TDFSVersion);
begin
  { empty write method, just needed to get it to show up in Object Inspector }
end;



{ TIconListBox Component }

constructor TIconListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  { Set default values }
  Style := lbOwnerDrawFixed;
  ItemHeight := GetSystemMetrics(SM_CYICON) + 6;
  FItemWidth := GetSystemMetrics(SM_CXICON) + 6;
  Font.Name := 'Arial';
  Font.Height := ItemHeight;
  FileName := '';
  FAutoDisable := TRUE;
  FEnableCaching := TRUE;
  FNumberOfIcons := -1;
  FYIcons := 1;
  { By setting XIcons instead of FXIcons, the windows will get sized }
  XIcons := 4;
end;

(*procedure TIconListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
{  if Orientation = lbVertical then
    Params.Style := Params.Style or LBS_DISABLENOSCROLL or WS_VSCROLL and (not WS_HSCROLL)
  else
    Params.Style := Params.Style or LBS_DISABLENOSCROLL or WS_HSCROLL and (not WS_VSCROLL);}
end;*)

procedure TIconListBox.CNDeleteItem(var Msg: TWMDeleteItem);
var
  Icon: TIcon;
begin
  { Don't use GetIcon here! }
  Icon := TIcon(Items.Objects[Msg.DeleteItemStruct^.itemID]);
  { Free it.  If it is NIL, Free ignores it, so it is safe }
  Icon.Free;
  { Zero out the TIcon we just freed }
  Items.Objects[Msg.DeleteItemStruct^.itemID] := NIL;
end;


{ Initialize the icon handles, which are stored in the Objects property }
procedure TIconListBox.LoadIcons;
  function CountIcons(Inst: THandle; Filename: PChar): integer;
  var
    TmpIcon: HICON;
  begin
    Result := 0;
    TmpIcon := ExtractIcon(Inst, Filename, Result);
    while (TmpIcon <> 0) do begin
      inc(Result);
      DestroyIcon(TmpIcon);
      TmpIcon := ExtractIcon(Inst, Filename, Result);
    end;
  end;
var
  x: integer;
  Icon: TIcon;
  Buff: array[0..255] of char;
  OldCursor: TCursor;
begin
  { Clear any old icon handles }
  FreeIcons;
  { Reset the contents of the listbox }
  Clear;
  { Update the enabled state of the control }
  UpdateEnabledState;
  { If we have a valid file then setup the combobox. }
  if FileExists(FileName) then begin
    { If we are not loading on demand, set the cursor to an hourglass }
    OldCursor := Screen.Cursor;
    if not EnableCaching then
      Screen.Cursor := crHourGlass;
    { Find out how many icons are in the file }
      FNumberOfIcons := ExtractIcon(hInstance, StrPCopy(Buff, FileName),
         {$IFDEF DFS_WIN32} UINT(-1)); {$ELSE} word(-1)); {$ENDIF}
    { Loop for every icon in the file }
    for x := 0 to NumberOfIcons - 1 do begin
      { If we are not loading on demand... }
      if not EnableCaching then begin
        { Create a TIcon object... }
        Icon := TIcon.Create;
        { and assign the icon to it. }
        Icon.Handle := ExtractIcon(hInstance, Buff, x);
        { Add the icon and a dummy string to the combobox }
        Items.AddObject(Format('%d',[x]), Icon);
      end else
        { We're loading on demand, so just add a dummy string }
        Items.AddObject(Format('%d',[x]), NIL);
    end;
    { Reset the index to the first item. }
    ItemIndex := 0;
    { if not loading on demand, restore the cursor }
    if not EnableCaching then
      Screen.Cursor := OldCursor;
  end;
end;

{ Free the icon resources we created. }
procedure TIconListBox.FreeIcons;
var
  x: integer;
  Icon: TIcon;
begin
  { Loop for every icon }
  for x := 0 to Items.Count-1 do begin
    { Get the icon object }
    Icon := TIcon(Items.Objects[x]);  { Don't use GetIcon here! }
    { Free it.  If it is NIL, Free ignores it, so it is safe }
    Icon.Free;
    { Zero out the TIcon we just freed }
    Items.Objects[x] := NIL;
  end;
  { Reset the number of Icons to reflect that we have no file. }
  FNumberOfIcons := -1;
end;

{ Disable the control if we don't have a valid filename, and option is enabled }
procedure TIconListBox.UpdateEnabledState;
begin
  if AutoDisable then
    Enabled := FileExists(FileName)
  else
    Enabled := TRUE;
end;

{ Reset the size of the listbox to reflect changes in orientation and IconsDisplayed }
procedure TIconListBox.ResetSize;
begin
  if Width < FItemWidth * XIcons + 2 then
    Height := ItemHeight * YIcons + GetSystemMetrics(SM_CYHSCROLL) + 1
  else
    Height := ItemHeight * YIcons + 3;
  Width := FItemWidth * XIcons + 2;
  Columns := XIcons;
(*  if Orientation = lbVertical then begin
    { Set height to hold the desired number of icons }
    Height := ItemHeight * IconsDisplayed + 2;
    { Set width to an icon plus a scrollbar }
    Width := FItemWidth + GetSystemMetrics(SM_CXVSCROLL) + 10;
    { Make sure we don't have any columns. }
    Columns := 0;
  end else begin
    { Set height to an icon plus a scrollbar }
    Height := ItemHeight + GetSystemMetrics(SM_CYHSCROLL) + 1;
    { Set width to hold the desired number of icons }
    Width := FItemWidth * IconsDisplayed + 2;
    { Set number of columns in the listbox to the desired number of icons }
    Columns := IconsDisplayed;
  end;*)
end;

{ Update the filename of the icon file. }
procedure TIconListBox.SetFileName(Value: String);
begin
  { If new value is same as old, don't reload icons.  That's silly. }
  if FFileName = Value then exit;
  FFileName := Value;
  { Initialize icon handles from new icon file. }
  LoadIcons;
  { Call user event handler, if one exists }
  if assigned(FOnFileChange) then
    FOnFileChange(Self);
end;

{ Update the AutoDisable property }
procedure TIconListBox.SetAutoDisable(Value: boolean);
begin
  { If it's the same, we don't need to do anything }
  if Value = FAutoDisable then exit;
  FAutoDisable := Value;
  { Update the enabled state of control based on new AutoDisable setting }
  UpdateEnabledState;
end;

{ Update the EnableCaching property }
procedure TIconListBox.SetEnableCaching(Value: boolean);
begin
  { If it's the same, we don't need to do anything }
  if Value = FEnableCaching then exit;
  FEnableCaching := Value;
  { If load on demand is not enabled, we need to load all the icons. }
  if not FEnableCaching then
    LoadIcons;
end;

{ Set the number of icons to be displayed in the listbox }
procedure TIconListBox.SetXIcons(Value: integer);
begin
  { If number hasn't changed then don't do anything }
  if (Value = FXIcons) or (Value < 1) then exit;
  FXIcons:= Value;
  { Call ResetSize to update the width or height, depending on the orientation }
  ResetSize;
end;

procedure TIconListBox.SetYIcons(Value: integer);
begin
  { If number hasn't changed then don't do anything }
  if (Value = FYIcons) or (Value < 1) then exit;
  FYIcons := Value;
  { Call ResetSize to update the width or height, depending on the orientation }
  ResetSize;
end;

{ Used to extract icons from files and assign them to a TIcon object }
function TIconListBox.ReadIcon(const Index: integer): TIcon;
var
  Buff: array[0..255] of char;
begin
  { Create the new icon }
  Result := TIcon.Create;
  { Assign it the icon handle }
  Result.Handle := ExtractIcon(hInstance, StrPCopy(Buff, FileName), Index);
end;

{ Returns the icon for a given combobox index }
function TIconListBox.GetIcon(Index: integer): TIcon;
begin
  { If load on demand is enabled... }
  if EnableCaching then
    { Has the icon been loaded yet? }
    if Items.Objects[Index] = NIL then
      { No, we must get the icon and add it to Objects }
      Items.Objects[Index] := ReadIcon(Index);
  { Return the requested icon }
  Result := TIcon(Items.Objects[Index]);
end;

{ Return the size of the item we are drawing }
procedure TIconListBox.MeasureItem(Index: Integer; var Height: Integer);
begin
  { Ask Windows how tall icons are }
  Height := GetSystemMetrics(SM_CYICON);
end;

{ Draw the item requested in the given rectangle.  Because of the parent's default }
{ behavior, we needn't worry about the State.  That's very nice.                   }
procedure TIconListBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Icon: TIcon;
begin
  { Use the controls canvas for drawing... }
  with Canvas do begin
    try
      { Fill in the rectangle.  The proper brush has already been set up for us,   }
      { so we needn't use State to set it ourselves.                               }
      FillRect(Rect);
      { Get the icon to be drawn }
      Icon := GetIcon(Index);
      { If nothing has gone wrong, draw the icon.  Theoretically, it should never  }
      { be NIL, but why take the chance?                                           }
      if Icon <> nil then
        { Using the given rectangle, draw the icon on the control's canvas,        }
        { centering it within the rectangle.                                       }
        with Rect do Draw(Left + (Right - Left - Icon.Width) div 2,
                          Top + (Bottom - Top - Icon.Width) div 2, Icon);
    except
      { If anything went wrong, we fall down to here.  You may want to add some    }
      { sort of user notification.  No clean up is necessary since we did not      }
      { create anything.  We'll just ignore the problem and hope it goes away. :)  }
      {!};
    end;
  end;
end;

function TIconListBox.GetVersion: TDFSVersion;
begin
  Result := DFS_LIST_VERSION;
end;

procedure TIconListBox.SetVersion(const Val: TDFSVersion);
begin
  { empty write method, just needed to get it to show up in Object Inspector }
end;



{ Add the components to the Delphi Component Palette.  You will want to modify     }
{ this so that it appears on the page of your choice.                              }
procedure Register;
begin
  RegisterComponents('Upgrade Suite', [TIconComboBox, TIconListBox]);
  RegisterPropertyEditor(TypeInfo(TDFSVersion), TIconComboBox, 'Version',
     TDFSVersionProperty);
  RegisterPropertyEditor(TypeInfo(TDFSVersion), TIconListBox, 'Version',
     TDFSVersionProperty);
end;

end.

