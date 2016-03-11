unit apfolder;

interface

uses classes;
type
  Tapfolder = class(Tobject)
    name:string;
    parent:tapfolder;
    apfolds:tlist;
    apfiles:tlist;
    constructor create(prnt:tapfolder);
    destructor destroy;override;
    function deleteapfile(fl:string):boolean;
    function findfilenam(nam:string):integer;
    function findfileurl(nam:string):integer;
    function findfoldnam(nam:string):tapfolder;
  end;

implementation

uses apfile;


function Tapfolder.findfoldnam(nam:string):tapfolder;
var
	cnt,cntm:integer;
  found:boolean;
begin
result:=nil;
cntm:=apfolds.count;
found:=false;
cnt:=0;
while (not found) and (cnt<cntm) do
  begin
  if tapfolder(apfolds[cnt]).name=nam then
  	begin
    found:=true;
    result:=apfolds[cnt];
    end;
  inc(cnt);
  end;    // while
end;

function Tapfolder.findfilenam(nam:string):integer;
var
	cnt,cntm:integer;
  found:boolean;
begin
result:=-1;
cntm:=apfiles.count;
found:=false;
cnt:=0;
while (not found) and (cnt<cntm) do
  begin
  if tapfile(apfiles[cnt]).name=nam then
  	begin
    found:=true;
    result:=cnt;
    end;
  inc(cnt);
  end;    // while
end;

{TAPFOLDER}
constructor tapfolder.create(prnt:tapfolder);
begin
inherited create;
parent:=prnt;
apfiles:=tlist.create;
apfolds:=tlist.create;
end;

destructor tapfolder.destroy;
var
  cnt:integer;
  cntm:integer;
  n1:integer;
  posn:integer;
begin
{ if there is a parent folder, remove this folder from it's apfolds list }
if parent<>nil then
  begin
  parent.apfolds.Remove(self);
  end;
{ clear apfiles then free }
cntm:=apfiles.count-1;
for cnt:=cntm downto 0 do
  begin
  tapfile(apfiles.Items[cnt]).free;
  end;
apfiles.free;
apfolds.pack;
cntm:=apfolds.count-1;
for cnt:=cntm downto 0do
  begin
  tapfolder(apfolds.items[cnt]).free;
  end;
apfolds.free;
inherited destroy;
end;

{ find file of name fl and remove from folder}
function tapfolder.deleteapfile(fl:string):boolean;
var
	cnt,cntm:integer;
begin
result:=true;
cntm:=apfiles.count;
cnt:=0;
while cnt<cntm do
	begin
	if tapfile(apfiles[cnt]).name=fl then
  	begin
		apfiles.Delete(apfiles.indexof(apfiles[cnt]));
    cnt:=cntm;
    end;
  end;
end;

function Tapfolder.findfileurl(nam: string): integer;
var
	cnt,cntm:integer;
  found:boolean;
begin
result:=-1;
cntm:=apfiles.count;
found:=false;
cnt:=0;
while (not found) and (cnt<cntm) do
  begin
  if tapfile(apfiles[cnt]).url=nam then
  	begin
    found:=true;
    result:=cnt;
    end;
  inc(cnt);
  end;    // while
end;

end.
