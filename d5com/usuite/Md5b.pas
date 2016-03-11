{ MD5.Pas - components for calculating MD5 Message-Digest values
  written 2/2/94 by

  Peter Sawatzki
  Buchenhof 3
  D58091 Hagen, Germany Fed Rep

  EMail: Peter@Sawatzki.de
  EMail: 100031.3002@compuserve.com
  WWW:   http://www.sawatzki.de

  original C Source for MD5 routine was found in Dr. Dobbs Journal Sep 91
  MD5 algorithm from RSA Data Security, Inc.
}
{$A-}
Unit Md5b;
Interface
Uses
  windows,
  filectrl,
  SysUtils,
  Classes,
  Consts,dialogs ;
Type
  { integer to cardinal }
  TDigestStr = String[32];
  TDigest = Array[0..15] Of Byte;
  TDigestInteger = Array[0..3] Of cardinal;

  TIntegerBuf = Array[0..15] Of cardinal;
  TByteBuf = Array[0..63] Of Byte;

  TCustomMD5 = class(TComponent)
  Private
    FDigest: TDigest;         {the digest to be returned}
    CDigest: TDigestInteger;  {digest accumulator}
    BitLo, BitHi: Integer;    { number of _bits_ handled mod 2^64 }
    bBuf: TByteBuf;
    bLen: Cardinal; {bytes in bBuf}
    BufferChanged: Boolean;
    Procedure ResetBuffer;
    Procedure Update (Const ChkBuf; Len: Cardinal);
    Function GetDigest: TDigest;
    Function GetDigestStr: TDigestStr;
    Function GetDigestInteger: TDigestInteger;
    Procedure SetDigestStr (Const ADigestStr: TDigestStr);
  Protected
    { Protected declarations }
  Public
    Constructor Create (AOwner: TComponent); Override;
    Property Digest: TDigest Read GetDigest Stored False;
    Property DigestInteger: TDigestInteger Read GetDigestInteger Stored False;
  Published
    { Published declarations }
    Property DigestStr: TDigestStr Read GetDigestStr Write SetDigestStr Stored False;
  End;

Function FileMD5Digest (Const FileName: TFileName): TDigestStr;

Procedure Register;

Implementation

Procedure Transform (Var Accu; Const Buf);
{$IfNDef UsePascal} Register; External; {$L MD5_386} {use fast 386 version (see MD5_386.ASM)} {$Else}
{Pascal version for reference...}
Var
  a, b, c, d: Integer;
  lBuf: TIntegerBuf Absolute Buf;
  lAccu: TDigestInteger Absolute Accu;

  Function ROL (x: Integer; n: Integer): Integer;
  Begin Result:= (x Shl n) Or (x Shr (32-n)) End;

  Function FF (a,b,c,d,x,s,ac: Integer): Integer;
  Begin Result:= ROL (a+x+ac + (b And c Or Not b And d), s) + b End;

  Function GG (a,b,c,d,x,s,ac: Integer): Integer;
  Begin Result:= ROL (a+x+ac + (b And d Or c And Not d), s) + b End;

  Function HH (a,b,c,d,x,s,ac: Integer): Integer;
  Begin Result:= ROL (a+x+ac + (b Xor c Xor d), s) + b End;

  Function II (a,b,c,d,x,s,ac: Integer): Integer;
  Begin Result:= ROL (a+x+ac + (c Xor (b Or Not d)), s) + b End;

Begin
  a:= lAccu[0];
  b:= lAccu[1];
  c:= lAccu[2];
  d:= lAccu[3];

  a:= FF(a,b,c,d, lBuf[ 0],  7, $d76aa478); { 1 }
  d:= FF(d,a,b,c, lBuf[ 1], 12, $e8c7b756); { 2 }
  c:= FF(c,d,a,b, lBuf[ 2], 17, $242070db); { 3 }
  b:= FF(b,c,d,a, lBuf[ 3], 22, $c1bdceee); { 4 }
  a:= FF(a,b,c,d, lBuf[ 4],  7, $f57c0faf); { 5 }
  d:= FF(d,a,b,c, lBuf[ 5], 12, $4787c62a); { 6 }
  c:= FF(c,d,a,b, lBuf[ 6], 17, $a8304613); { 7 }
  b:= FF(b,c,d,a, lBuf[ 7], 22, $fd469501); { 8 }
  a:= FF(a,b,c,d, lBuf[ 8],  7, $698098d8); { 9 }
  d:= FF(d,a,b,c, lBuf[ 9], 12, $8b44f7af); { 10 }
  c:= FF(c,d,a,b, lBuf[10], 17, $ffff5bb1); { 11 }
  b:= FF(b,c,d,a, lBuf[11], 22, $895cd7be); { 12 }
  a:= FF(a,b,c,d, lBuf[12],  7, $6b901122); { 13 }
  d:= FF(d,a,b,c, lBuf[13], 12, $fd987193); { 14 }
  c:= FF(c,d,a,b, lBuf[14], 17, $a679438e); { 15 }
  b:= FF(b,c,d,a, lBuf[15], 22, $49b40821); { 16 }

  a:= GG(a,b,c,d, lBuf[ 1],  5, $f61e2562); { 17 }
  d:= GG(d,a,b,c, lBuf[ 6],  9, $c040b340); { 18 }
  c:= GG(c,d,a,b, lBuf[11], 14, $265e5a51); { 19 }
  b:= GG(b,c,d,a, lBuf[ 0], 20, $e9b6c7aa); { 20 }
  a:= GG(a,b,c,d, lBuf[ 5],  5, $d62f105d); { 21 }
  d:= GG(d,a,b,c, lBuf[10],  9, $02441453); { 22 }
  c:= GG(c,d,a,b, lBuf[15], 14, $d8a1e681); { 23 }
  b:= GG(b,c,d,a, lBuf[ 4], 20, $e7d3fbc8); { 24 }
  a:= GG(a,b,c,d, lBuf[ 9],  5, $21e1cde6); { 25 }
  d:= GG(d,a,b,c, lBuf[14],  9, $c33707d6); { 26 }
  c:= GG(c,d,a,b, lBuf[ 3], 14, $f4d50d87); { 27 }
  b:= GG(b,c,d,a, lBuf[ 8], 20, $455a14ed); { 28 }
  a:= GG(a,b,c,d, lBuf[13],  5, $a9e3e905); { 29 }
  d:= GG(d,a,b,c, lBuf[ 2],  9, $fcefa3f8); { 30 }
  c:= GG(c,d,a,b, lBuf[ 7], 14, $676f02d9); { 31 }
  b:= GG(b,c,d,a, lBuf[12], 20, $8d2a4c8a); { 32 }

  a:= HH(a,b,c,d, lBuf[ 5],  4, $fffa3942); { 33 }
  d:= HH(d,a,b,c, lBuf[ 8], 11, $8771f681); { 34 }
  c:= HH(c,d,a,b, lBuf[11], 16, $6d9d6122); { 35 }
  b:= HH(b,c,d,a, lBuf[14], 23, $fde5380c); { 36 }
  a:= HH(a,b,c,d, lBuf[ 1],  4, $a4beea44); { 37 }
  d:= HH(d,a,b,c, lBuf[ 4], 11, $4bdecfa9); { 38 }
  c:= HH(c,d,a,b, lBuf[ 7], 16, $f6bb4b60); { 39 }
  b:= HH(b,c,d,a, lBuf[10], 23, $bebfbc70); { 40 }
  a:= HH(a,b,c,d, lBuf[13],  4, $289b7ec6); { 41 }
  d:= HH(d,a,b,c, lBuf[ 0], 11, $eaa127fa); { 42 }
  c:= HH(c,d,a,b, lBuf[ 3], 16, $d4ef3085); { 43 }
  b:= HH(b,c,d,a, lBuf[ 6], 23, $04881d05); { 44 }
  a:= HH(a,b,c,d, lBuf[ 9],  4, $d9d4d039); { 45 }
  d:= HH(d,a,b,c, lBuf[12], 11, $e6db99e5); { 46 }
  c:= HH(c,d,a,b, lBuf[15], 16, $1fa27cf8); { 47 }
  b:= HH(b,c,d,a, lBuf[ 2], 23, $c4ac5665); { 48 }

  a:= II(a,b,c,d, lBuf[ 0],  6, $f4292244); { 49 }
  d:= II(d,a,b,c, lBuf[ 7], 10, $432aff97); { 50 }
  c:= II(c,d,a,b, lBuf[14], 15, $ab9423a7); { 51 }
  b:= II(b,c,d,a, lBuf[ 5], 21, $fc93a039); { 52 }
  a:= II(a,b,c,d, lBuf[12],  6, $655b59c3); { 53 }
  d:= II(d,a,b,c, lBuf[ 3], 10, $8f0ccc92); { 54 }
  c:= II(c,d,a,b, lBuf[10], 15, $ffeff47d); { 55 }
  b:= II(b,c,d,a, lBuf[ 1], 21, $85845dd1); { 56 }
  a:= II(a,b,c,d, lBuf[ 8],  6, $6fa87e4f); { 57 }
  d:= II(d,a,b,c, lBuf[15], 10, $fe2ce6e0); { 58 }
  c:= II(c,d,a,b, lBuf[ 6], 15, $a3014314); { 59 }
  b:= II(b,c,d,a, lBuf[13], 21, $4e0811a1); { 60 }
  a:= II(a,b,c,d, lBuf[ 4],  6, $f7537e82); { 61 }
  d:= II(d,a,b,c, lBuf[11], 10, $bd3af235); { 62 }
  c:= II(c,d,a,b, lBuf[ 2], 15, $2ad7d2bb); { 63 }
  b:= II(b,c,d,a, lBuf[ 9], 21, $eb86d391); { 64 }

  Inc(lAccu[0], a);
  Inc(lAccu[1], b);
  Inc(lAccu[2], c);
  Inc(lAccu[3], d)
End;
{$EndIf}

Constructor TCustomMD5.Create (AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  ResetBuffer;
End;

Procedure TCustomMD5.ResetBuffer;
Begin
  BitLo:= 0;
  BitHi:= 0;
  bLen:= 0;
  {Load magic initialization constants.}
  CDigest[0]:= $67452301;
  CDigest[1]:= $efcdab89;
  CDigest[2]:= $98badcfe;
  CDigest[3]:= $10325476;
  BufferChanged:= True
End;

Procedure TCustomMD5.Update (Const ChkBuf; Len: Cardinal);
Var
  BufPtr: ^Byte;
  Left: Cardinal;
Begin
  BufferChanged:= True;
  If BitLo + Integer(Len) Shl 3 < BitLo Then
    Inc(BitHi);
  Inc(BitLo, Integer(Len) Shl 3);
  Inc(BitHi, Integer(Len) Shr 29);

  BufPtr:= @ChkBuf;
  If bLen>0 Then Begin
    Left:= 64-bLen; If Left>Len Then Left:= Len;
    Move(BufPtr^, bBuf[bLen], Left);
    Inc(bLen, Left); Inc(BufPtr, Left);
    If bLen<64 Then Exit;
    Transform(CDigest, bBuf);
    bLen:= 0;
    Dec(Len, Left)
  End;
  While Len>=64 Do Begin
    Transform(CDigest, BufPtr^);
    Inc(BufPtr, 64);
    Dec(Len, 64)
  End;
  If Len>0 Then Begin
    bLen:= Len;
    Move(BufPtr^, bBuf[0], bLen)
  End
End;

Function TCustomMD5.GetDigest: TDigest;
{-get digest without modifying bBuf, bLen and BitLo/Hi}
Var
  WorkBuf: TByteBuf;
  WorkLen: cardinal ;
Begin
  If BufferChanged Then Begin
    FDigest:= TDigest( CDigest);
    Move(bBuf, WorkBuf, bLen); {make copy of buffer}
    {pad out to block of form (0..55, BitLo, BitHi)}
    WorkBuf[bLen]:= $80;
    WorkLen:= bLen+1;
    If WorkLen>56 Then Begin
        FillChar(WorkBuf[WorkLen], 64-WorkLen, 0);
      TransForm(FDigest, WorkBuf);
      WorkLen:= 0
    End;
    FillChar(WorkBuf[WorkLen], 56-WorkLen, 0);
    TIntegerBuf(WorkBuf)[14]:= BitLo;
    TIntegerBuf(WorkBuf)[15]:= BitHi;
    Transform (FDigest, WorkBuf);
    BufferChanged:= False
  End;
  Result:= FDigest
End;

Function TCustomMD5.GetDigestStr: TDigestStr;
Const
  hc: Array[0..$F] Of Char = '0123456789ABCDEF';
Var
  aDigest: TDigest;
  i: 0..15;
Begin
  aDigest:= Digest;
  Result[0]:= #32;
  For i:= 0 To 15 Do Begin
    Result[1+i Shl 1]:= hc[aDigest[i] Shr 4];
    Result[2+i Shl 1]:= hc[aDigest[i] And $F]
  End
End;

Function TCustomMD5.GetDigestInteger: TDigestInteger;
Begin
  TDigest(Result):= Digest
End;

Procedure TCustomMD5.SetDigestStr (Const ADigestStr: TDigestStr);
Begin
  {a read-only property}
End;

Function FileMD5Digest (Const FileName: TFileName): TDigestStr;
var
  MD5: TCustomMD5;
  aBuf: array[1..8193] of byte;
  wRd: Cardinal;
  goon:boolean;
  source:tfilestream;
//  bread:integer;
  chunksize:cardinal;
  deltemp:boolean;
Begin
chunksize:=8192;
deltemp:=false;
Result:= '';
goon:=true;
MD5:= TCustomMD5.Create(Nil);
Try
  source:=tfilestream.create(filename,fmopenread);
except
  //showmessage('Could not open '+filename+' to get MD5 number.'#13#10#13#10'Will attempt to copy a temporary file and use that.');
  if copyfile(pchar(filename),pchar(filename+'.www'),falsE) then
    deltemp:=true;
  try
    source:=tfilestream.create(filename+'.www',fmopenread);
  except
    showmessage('Critical Error. Could not get MD5 from '+filename+'.'#13#10#13#10' Using XXXX for MD5 instead.');
    goon:=false;
    result:='XXXX';
  end;
end;
if goon then
  begin
  source.seek(0,sofrombeginning);
  repeat
    begin
    wrd:=source.Read(abuf,chunksize);
    if wRd>0 then
      begin
      try
      MD5.Update(aBuf, wRd);
      except
      end;
      end;
    end
  until wRd<ChunkSize; { until we run out of chunks }
  Result:= MD5.DigestStr;
  source.free;
  if deltemp then
    deletefile(pchar(filename+'.www'));
  End;
MD5.Free
End;

procedure Register;
begin
  RegisterComponents('Upgrade Suite', [TCustomMD5]);
end;


end.
{$A+}

