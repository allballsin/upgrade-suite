unit DCADlg1;

interface
                     
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TShellCommandsDlg = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Button3: TButton;
    Button4: TButton;
    ListBox1: TListBox;
    Header1: THeader;
    Button5: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure ListBox1MeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBox1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ShellCommandList:string;
    procedure SetShellCommandList(aValue:string);
  end;

function ParseShellCommandList(value:string):tstringlist;

var
  ShellCommandsDlg: TShellCommandsDlg;

implementation
Uses DCADlg2;
{$R *.DFM}

function parseShellCommandList(value:string):tstringlist;
 var
   s,ItemText:string;
   SepPos:integer;
begin
  ItemText:='';
  result:=tStringlist.create;
  s:=value;
  while Length(s) > 0 do begin
    {Determine the position of the first ',' in the string}
    SepPos:=Pos(',',s);
    ItemText:=Copy(s,1,SepPos-1);
    result.add(ItemText);
    {remove command from string}
    s:=Copy(s,SepPos+1,Length(s)-SepPos+1);
  end;  {of while}
end;

procedure TShellCommandsDlg.SetShellCommandList(aValue:string);
var
  i:integer;
  alist:tstringlist;
begin
  alist:=parseShellCommandList(aValue);
  Listbox1.items.clear;
  for i:=0 to alist.count-1 do
    begin         
      Listbox1.items.add(alist[i])
    end;
  alist.free;
  if listbox1.items.count>0 then
    listbox1.itemindex:=0;
end;

procedure TShellCommandsDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i:integer;
begin
  if modalresult=mrOk then
    begin
      ShellCommandList:='';
      for i:=0 to listbox1.items.count-1 do
        begin
           ShellCommandList:=ShellCommandList+listbox1.items[i]+',';
        end;
    end;
   CanClose:=true;
end;

procedure TShellCommandsDlg.Button3Click(Sender: TObject);
begin
   AddShellCommandDlg:=TAddShellCommandDlg.create(application);
   try
     if AddShellCommandDlg.showmodal = mrOk then
       begin
         listbox1.items.add(AddShellCommandDlg.MenuEdit.text+'|'+
                                 AddShellCommandDlg.ParamEdit.text);
       end;
   finally
     AddShellCommandDlg.free;
 end;
 if Listbox1.items.count>0 then
   Listbox1.itemindex:=Listbox1.items.count-1;
end;

procedure TShellCommandsDlg.ListBox1MeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  Height := (Control as TListBox).Canvas.TextHeight('W');
end;

procedure TShellCommandsDlg.ListBox1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  I: Integer;
  R: TRect;
  ConfName,
  ItemStr, Str: String;
begin
  with (Control as TListBox) do
    begin
      if (odGrayed in State) or (odDisabled in State) then
        Canvas.Font.Color := clGrayText;

      ItemStr := Items[Index];
      I := 1;

      R := Rect;
      R.Right := R.Left + Header1.SectionWidth[0];
      str:=copy(ItemStr,1,pos('|',ItemStr)-1);
      Canvas.TextRect(R, R.Left + 2, R.Top, str);

      R.Left := R.Right;
      R.Right := R.Left + Header1.SectionWidth[1];
      Str := copy(ItemStr,pos('|',ItemStr)+1,Length(ItemStr));
      Canvas.TextRect(R, R.Left + 4{(R.Right - R.Left) - Canvas.TextWidth(Str)
       -2} , R.Top, Str);

    end;
end;

procedure TShellCommandsDlg.ListBox1Click(Sender: TObject);
begin
  Button4.enabled:=(ListBox1.itemindex>-1);
  Button4.enabled:=(ListBox1.itemindex>-1);
end;

procedure TShellCommandsDlg.Button4Click(Sender: TObject);
var
  i:integer;
begin
  if ListBox1.itemindex=-1 then exit;
  i:=Listbox1.itemindex;
   ListBox1.items.delete(ListBox1.itemindex);
   if (i<Listbox1.items.count) then
     Listbox1.itemindex:=i
   else
     Listbox1.itemindex:=Listbox1.items.count-1;
end;

procedure TShellCommandsDlg.Button5Click(Sender: TObject);
var           
  i:integer;
begin
  if ListBox1.itemindex=-1 then exit;
   i:=listbox1.itemindex;
   AddShellCommandDlg:=TAddShellCommandDlg.create(application);
   try
     AddShellCommandDlg.MenuEdit.text:=copy(listbox1.items[listbox1.itemindex],1,
                         pos('|',listbox1.items[listbox1.itemindex])-1);

     AddShellCommandDlg.ParamEdit.text:=copy(
             listbox1.items[listbox1.itemindex], pos('|',listbox1.items[listbox1.itemindex])+1,
                            length(listbox1.items[listbox1.itemindex])
                            );
     if AddShellCommandDlg.showmodal = mrOk then
       begin
         listbox1.items[listbox1.itemindex]:=AddShellCommandDlg.MenuEdit.text+'|'+
                                 AddShellCommandDlg.ParamEdit.text;
       end;
   finally
     AddShellCommandDlg.free;
   end;
   listbox1.itemindex:=i;
end;

procedure TShellCommandsDlg.SpeedButton1Click(Sender: TObject);
var
  i:integer;
begin
  if ListBox1.itemindex<1 then exit;
  i:=ListBox1.itemindex;
  listbox1.items.exchange(ListBox1.itemindex,ListBox1.itemindex-1);
  if i>0 then
    ListBox1.itemindex:=i-1
  else
    ListBox1.itemindex:=0;
end;

procedure TShellCommandsDlg.SpeedButton2Click(Sender: TObject);
var
  i:integer;
begin
  if ListBox1.itemindex=-1 then exit;
  i:=ListBox1.itemindex;
  if ListBox1.itemindex>(ListBox1.items.count-2) then exit;
   begin
     listbox1.items.exchange(ListBox1.itemindex,ListBox1.itemindex+1);
     ListBox1.itemindex:=ListBox1.itemindex+1;
   end;
  if i < (ListBox1.items.count-1) then
     ListBox1.itemindex:=i+1
  else
    ListBox1.itemindex:=ListBox1.items.count-1;
end;

end.
