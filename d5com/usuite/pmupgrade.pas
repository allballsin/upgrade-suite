{ MDO - 16.7.98 - changed [0]'s to [1] }
{ MDO - 16.7.98 - changed [0..x-1] to [1..x] except for packed character arrays. }
{ MDO - 26.7.98 - changed [1..x] back to [0..x-1]}
unit pmupgrade;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;



type

  tbytearray=array [0..maxint-1] of byte;
  pbytearray=^tbytearray;

  tintarray=array [0..(maxint div 4)-1] of integer;
  pintarray=^tintarray;

  toutrec = packed record
  cmdtype:byte;
  length:integer;
  offset:integer;
  end;

  TOnProgressEvent = procedure (Sender: TObject;Progress:real) of object;

  Tpatchmaker = class(TComponent)
  private
    { Private declarations }
    oldbuf,newbuf,outbuf:pbytearray;
    fmincompsize:integer;
    foldfile,fnewfile,fpatchfile,FOrderFile:string;
    fOnProgressEvent:TOnProgressEvent;
    FCompressPatch:boolean;
    FSpeedUp:boolean;
  protected
    { Protected declarations }
  { MDO 26.7.98 }
  function diffbuffers(oldbufsize,newbufsize:integer):integer;
  function  CRCBuffer (oldbufsize:integer): integer;
  public
    { Public declarations }
  function makepatch:boolean;
  procedure applypatch;
  procedure applyorder;
  constructor Create(AOwner: TComponent); override;
  destructor destroy;override;
  published
    { Published declarations }
  property OldFile:string read foldfile write foldfile;
  property Mincomparesize:integer read fmincompsize write fmincompsize default sizeof(toutrec)+1;
  property CompressPatch:boolean read FCompressPatch write FCompressPatch default true;
  property SpeedUp:boolean read FSpeedUp write FSpeedUp default false;
  property NewFile:string read fnewfile write fnewfile;
  property PatchFile:string read fpatchfile write fpatchfile;
  property OrderFile:string read FOrderFile write FOrderFile;
  property OnProgressEvent:TOnProgressEvent read fOnProgressEvent write fOnProgressEvent;
  end;



const CRCTbl: array [0..255] of integer =
  ( $00000000, $77073096, $ee0e612c, $990951ba,
    $076dc419, $706af48f, $e963a535, $9e6495a3,
    $0edb8832, $79dcb8a4, $e0d5e91e, $97d2d988,
    $09b64c2b, $7eb17cbd, $e7b82d07, $90bf1d91,

    $1db71064, $6ab020f2, $f3b97148, $84be41de,
    $1adad47d, $6ddde4eb, $f4d4b551, $83d385c7,
    $136c9856, $646ba8c0, $fd62f97a, $8a65c9ec,
    $14015c4f, $63066cd9, $fa0f3d63, $8d080df5,

    $3b6e20c8, $4c69105e, $d56041e4, $a2677172,
    $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b,
    $35b5a8fa, $42b2986c, $dbbbc9d6, $acbcf940,
    $32d86ce3, $45df5c75, $dcd60dcf, $abd13d59,

    $26d930ac, $51de003a, $c8d75180, $bfd06116,
    $21b4f4b5, $56b3c423, $cfba9599, $b8bda50f,
    $2802b89e, $5f058808, $c60cd9b2, $b10be924,
    $2f6f7c87, $58684c11, $c1611dab, $b6662d3d,

    $76dc4190, $01db7106, $98d220bc, $efd5102a,
    $71b18589, $06b6b51f, $9fbfe4a5, $e8b8d433,
    $7807c9a2, $0f00f934, $9609a88e, $e10e9818,
    $7f6a0dbb, $086d3d2d, $91646c97, $e6635c01,

    $6b6b51f4, $1c6c6162, $856530d8, $f262004e,
    $6c0695ed, $1b01a57b, $8208f4c1, $f50fc457,
    $65b0d9c6, $12b7e950, $8bbeb8ea, $fcb9887c,
    $62dd1ddf, $15da2d49, $8cd37cf3, $fbd44c65,

    $4db26158, $3ab551ce, $a3bc0074, $d4bb30e2,
    $4adfa541, $3dd895d7, $a4d1c46d, $d3d6f4fb,
    $4369e96a, $346ed9fc, $ad678846, $da60b8d0,
    $44042d73, $33031de5, $aa0a4c5f, $dd0d7cc9,

    $5005713c, $270241aa, $be0b1010, $c90c2086,
    $5768b525, $206f85b3, $b966d409, $ce61e49f,
    $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4,
    $59b33d17, $2eb40d81, $b7bd5c3b, $c0ba6cad,

    $edb88320, $9abfb3b6, $03b6e20c, $74b1d29a,
    $ead54739, $9dd277af, $04db2615, $73dc1683,
    $e3630b12, $94643b84, $0d6d6a3e, $7a6a5aa8,
    $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1,

    $f00f9344, $8708a3d2, $1e01f268, $6906c2fe,
    $f762575d, $806567cb, $196c3671, $6e6b06e7,
    $fed41b76, $89d32be0, $10da7a5a, $67dd4acc,
    $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5,

    $d6d6a3e8, $a1d1937e, $38d8c2c4, $4fdff252,
    $d1bb67f1, $a6bc5767, $3fb506dd, $48b2364b,
    $d80d2bda, $af0a1b4c, $36034af6, $41047a60,
    $df60efc3, $a867df55, $316e8eef, $4669be79,

    $cb61b38c, $bc66831a, $256fd2a0, $5268e236,
    $cc0c7795, $bb0b4703, $220216b9, $5505262f,
    $c5ba3bbe, $b2bd0b28, $2bb45a92, $5cb36a04,
    $c2d7ffa7, $b5d0cf31, $2cd99e8b, $5bdeae1d,

    $9b64c2b0, $ec63f226, $756aa39c, $026d930a,
    $9c0906a9, $eb0e363f, $72076785, $05005713,
    $95bf4a82, $e2b87a14, $7bb12bae, $0cb61b38,
    $92d28e9b, $e5d5be0d, $7cdcefb7, $0bdbdf21,

    $86d3d2d4, $f1d4e242, $68ddb3f8, $1fda836e,
    $81be16cd, $f6b9265b, $6fb077e1, $18b74777,
    $88085ae6, $ff0f6a70, $66063bca, $11010b5c,
    $8f659eff, $f862ae69, $616bffd3, $166ccf45,

    $a00ae278, $d70dd2ee, $4e048354, $3903b3c2,
    $a7672661, $d06016f7, $4969474d, $3e6e77db,
    $aed16a4a, $d9d65adc, $40df0b66, $37d83bf0,
    $a9bcae53, $debb9ec5, $47b2cf7f, $30b5ffe9,

    $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6,
    $bad03605, $cdd70693, $54de5729, $23d967bf,
    $b3667a2e, $c4614ab8, $5d681b02, $2a6f2b94,
    $b40bbe37, $c30c8ea1, $5a05df1b, $2d02ef8d);



procedure Register;

implementation

const
NOT_IDENTICAL:byte = 0;
IDENTICAL:    byte = 1;
CRC32:        byte = 2;
ID_RECORD:    byte = 3;

function compare(var old,new;len:integer):integer;assembler;
asm
   push esi
   push edi
   mov esi,old
   mov edi,new
   cld
   mov eax,len
   mov ecx,eax
   rep cmpsb
   inc ecx
   sub eax,ecx
   pop edi
   pop esi
end;

function gettoken(var s:string):string;
var
ind:integer;
begin
s:=trim(s);
ind:=pos(' ',s);
if ind<>0 then
   begin
   result:=copy(s,1,ind);
   delete(s,1,ind);
   end
else
   begin
   result:=s;
   s:='';
   end;
end;

function Tpatchmaker.CRCBuffer (oldbufsize:integer): integer;
var
  BytesRead, Count, i: integer;
  CRCVal: integer;
begin
  CRCVal := -1;count:=0;
  repeat
      if oldbufsize-count<32768 then
         BytesRead:=oldbufsize-count
      else
         BytesRead:=32768;
      if BytesRead > 0 then
         for i := 0 to BytesRead-1 do
            begin
            try
             CRCVal := CRCTbl[Byte(CRCVal xor integer(oldbuf[Count+i]))] xor ((CRCVal shr 8) and $00FFFFFF);
            except
            end;
            end;
      count:=count+bytesread;
  until BytesRead = 0;
Result := CRCVal;
end;


function Tpatchmaker.diffbuffers(oldbufsize,newbufsize:integer):integer;
var
hashtbl:array [0..$10000] of integer;
hashlst:pintarray;
pos,outpos,temppos,hashpos:integer;
complen,findlen:integer;
value:integer;
tempbuf:pbytearray;
outrec:toutrec;
speed:integer;

    procedure createhashtable;
    var
    oldvalue:integer;
    value:integer;
    i:integer;
    begin
    oldvalue:=-1;
    {allocmem does a fillchar }
    hashlst:=allocmem(oldbufsize*4);
//    getmem(hashlst,oldbufsize*4);
    fillchar(hashtbl,sizeof(hashtbl),0);
    for i:=0 to oldbufsize-1 do
    { not sure whether to make oldvalue a pointer }
//    for i:=1 to oldbufsize do
        begin
        value:=oldbuf[i];
        if value<>oldvalue then
           begin
           hashlst[i]:=hashtbl[value];
           hashtbl[value]:=i+1;
           oldvalue:=value;
           end;
        end;
    end;

    procedure writetempbuf;
    var
    i:integer;
    begin
    for i:=1 to speed do
        begin
        inc(temppos);
        tempbuf[temppos]:=newbuf[pos];
        inc(pos);
        if pos=newbufsize-1 then
           begin
           inc(temppos);
           tempbuf[temppos]:=newbuf[pos];
           inc(pos);
           outrec.cmdtype:=NOT_IDENTICAL;
           outrec.length:=temppos+1;
           outrec.offset:=0;
           move(outrec,outbuf[outpos],sizeof(outrec));
           inc(outpos,sizeof(outrec));
           move(tempbuf[0],outbuf[outpos],temppos+1);
           inc(outpos,temppos+1);
           temppos:=-1;
           break;
           end;
        end;
    if Fspeedup then inc(speed);
    end;

begin
createhashtable;
outpos:=0;
{write ID record to patch}
outrec.cmdtype:=ID_RECORD;
outrec.length:=1129595216;{PATC}
outrec.offset:=1380663629;{MAKR}
move(outrec,outbuf[0],sizeof(toutrec));
inc(outpos,sizeof(toutrec));
{write crc to patch}
outrec.cmdtype:=CRC32;
outrec.length:=CRCBuffer (oldbufsize);
outrec.offset:=0;
move(outrec,outbuf[outpos],sizeof(toutrec));
inc(outpos,sizeof(toutrec));
{begin}
tempbuf:=allocmem(newbufsize);
//getmem(tempbuf,newbufsize);
pos:=0;temppos:=-1;speed:=1;
while pos<newbufsize do
      begin
      if assigned(fonprogressevent) then fonprogressevent(self,pos/newbufsize);
      value:=newbuf[pos];
      hashpos:=hashtbl[value];
      if hashpos<>0 then
         begin
         findlen:=fmincompsize-1;
               while (findlen<fmincompsize) and (hashpos>0) do
                   begin
                   dec(hashpos);
                   complen:=oldbufsize-hashpos;
                   findlen:=compare(oldbuf[hashpos],newbuf[pos],complen);
                   if (findlen<fmincompsize) and (hashpos>=0) then
                      hashpos:=hashlst[hashpos]
                   else break;
                   end;
         if findlen<fmincompsize then
            writetempbuf
         else
            begin
            if temppos<>-1 then
               begin
               outrec.cmdtype:=NOT_IDENTICAL;
               outrec.length:=temppos+1;
               outrec.offset:=0;
               move(outrec,outbuf[outpos],sizeof(outrec));
               inc(outpos,sizeof(outrec));
               move(tempbuf[0],outbuf[outpos],temppos+1);
               inc(outpos,temppos+1);
               temppos:=-1;
               end;
            outrec.cmdtype:=IDENTICAL;
            outrec.length:=findlen;
            outrec.offset:=hashpos;
            move(outrec,outbuf[outpos],sizeof(outrec));
            inc(outpos,sizeof(outrec));
            inc(pos,findlen);
            speed:=1;
            end;
         end
      else
         writetempbuf;
      end;
freemem(tempbuf);
freemem(hashlst);
diffbuffers:=outpos+1;
end;


constructor Tpatchmaker.Create(AOwner: TComponent);
begin
inherited create(AOwner);
fmincompsize:=sizeof(toutrec)+1;
fcompresspatch:=true;
FSpeedUp:=false;
end;


function Tpatchmaker.makepatch:boolean;
var
oldstr,newstr,patchstr:tfilestream;
outsize:integer;
begin
result:=true;
try
oldstr:=TFileStream.Create(foldfile,fmopenread);
newstr:=TFileStream.Create(fnewfile,fmopenread);
getmem(oldbuf,oldstr.Size);
getmem(newbuf,newstr.Size);
{ this may help (100) }
getmem(outbuf,newstr.size+sizeof(toutrec)+500);
oldstr.ReadBuffer(oldbuf^,oldstr.size);
newstr.ReadBuffer(newbuf^,newstr.size);
outsize:=diffbuffers(oldstr.size,newstr.size);
patchstr:=tfilestream.create(fpatchfile,fmcreate);
patchstr.writebuffer(outbuf^,outsize);
oldstr.Free;
newstr.Free;
patchstr.free;
freemem(oldbuf);
freemem(newbuf);
freemem(outbuf);
if fcompresspatch then
   begin
{   zm1.copyfile(fpatchfile,'patch.tmp');
   deletefile(fpatchfile);
   zm1.FSpecArgs.Clear;
   zm1.FSpecArgs.add('patch.tmp');
   zm1.ZipFilename:=fpatchfile;
   zm1.Add;
   deletefile('patch.tmp');}
   end;
except
result:=false;
end;
end;

procedure Tpatchmaker.applypatch;
var
oldstr,newstr,patchstr:tfilestream;
outrec:toutrec;
begin
if fcompresspatch then
   begin
{   zm1.ZipFilename:=fpatchfile;
   zm1.Extract;
   fpatchfile:='patch.tmp';}
   end;
oldstr:=TFileStream.Create(foldfile,fmopenread);
patchstr:=TFileStream.Create(fpatchfile,fmopenread);
newstr:=Tfilestream.Create(fnewfile,fmcreate);
getmem(oldbuf,oldstr.Size);
try
oldstr.ReadBuffer(oldbuf^,oldstr.size);
patchstr.ReadBuffer(outrec,sizeof(outrec));
if  (outrec.cmdtype<>ID_RECORD) or
    (outrec.length<>1129595216) or
    (outrec.offset<>1380663629) then
    begin
    showmessage('Not valid patch file!');
    exit;
    end;
patchstr.ReadBuffer(outrec,sizeof(outrec));
if  (outrec.cmdtype<>CRC32) or
    (outrec.length<>CRCBuffer(oldstr.size)) then
    begin
    showmessage('Bad CRC!');
    exit;
    end;
while patchstr.Position<patchstr.Size-1 do
      begin
      if assigned(fonprogressevent) then fonprogressevent(self,patchstr.Position/patchstr.Size);
      patchstr.ReadBuffer(outrec,sizeof(outrec));
      case outrec.cmdtype of
      1: newstr.writebuffer(oldbuf[outrec.offset],outrec.length); {IDENTICAL}
      0: newstr.CopyFrom(patchstr,outrec.length); {NOT_IDENTICAL}
      end;
      end;
//showmessage('last:'+inttostr(outrec.cmdtype)+':'+inttostr(outrec.length)+':'+inttostr(outrec.offset));
finally
oldstr.Free;
patchstr.Free;
newstr.Free;
end;
freemem(oldbuf);
end;

procedure Tpatchmaker.applyorder;
var
infile:textfile;
instr,cmd:string;
begin
assignfile(infile,forderfile);
reset(infile);
readln(infile,instr);
while not eof(infile) do
      begin
       cmd:=uppercase(gettoken(instr));
       if cmd='PATCH' then
          begin
          foldfile:=gettoken(instr);
          fnewfile:=gettoken(instr);
          fpatchfile:=gettoken(instr);
          applypatch;
          end
       else if cmd='PACK' then
          begin
{          zm1.FSpecArgs.Clear;
          zm1.FSpecArgs.add(gettoken(instr));
          zm1.ZipFilename:=gettoken(instr);
          zm1.Add;}
          end
       else if cmd='UNPACK' then
          begin
{          zm1.FSpecArgs.Clear;
          zm1.ZipFilename:=gettoken(instr);
          zm1.extract;}
          end
       else if cmd='DELETE' then
          deletefile(gettoken(instr))
       else if cmd='MOVE' then
          renamefile(gettoken(instr),gettoken(instr))
       else if cmd='COPY' then
           begin
{           zm1.CopyFile(gettoken(instr),gettoken(instr))}
           end
       else if cmd='CREATEDIR' then
          createdir(gettoken(instr))
       else if cmd='REMOVEDIR' then
          removedir(gettoken(instr))
       else showmessage('Unknown command!');
     readln(infile,instr);
     end;
end;

destructor Tpatchmaker.destroy;
begin
{zm1.free;}
inherited destroy;
end;


procedure Register;
begin
  RegisterComponents('Upgrade Suite', [Tpatchmaker]);
end;

end.

