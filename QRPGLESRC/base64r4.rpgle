     /*-                                                                            +
      * Copyright (c) 2005-2007 Scott C. Klement                                    +
      * All rights reserved.                                                        +
      *                                                                             +
      * Redistribution and use in source and binary forms, with or without          +
      * modification, are permitted provided that the following conditions          +
      * are met:                                                                    +
      * 1. Redistributions of source code must retain the above copyright           +
      *    notice, this list of conditions and the following disclaimer.            +
      * 2. Redistributions in binary form must reproduce the above copyright        +
      *    notice, this list of conditions and the following disclaimer in the      +
      *    documentation and/or other materials provided with the distribution.     +
      *                                                                             +
      * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND      +
      * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE       +
      * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  +
      * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE     +
      * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL  +
      * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS     +
      * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)       +
      * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT  +
      * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY   +
      * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF      +
      * SUCH DAMAGE.                                                                +
      *                                                                             +
      */                                                                            +

     H NOMAIN
     H COPYRIGHT('Copyright (c) 2005-2007 Scott C. Klement.  All rights +
     H reserved.  A member called "LICENSE" was included with this +
     H distribution, and contains important license information.')
     H BNDDIR('QC2LE')

      *
      *  BASE64R4 -- Service Program to Encode/Decode data using the
      *              base64 algorithm.
      *                               Scott Klement, January 14, 2005
      *
      *  To Compile:
      *        CRTRPGMOD BASE64R4 SRCFILE(xxx/QRPGLESRC) DBGVIEW(*LIST)
      *        CRTSRVPGM SRVPGM(BASE64R4) SRCFILE(xxx/QSRVSRC)
      *        CRTBNDDIR BNDDIR(BASE64)
      *        ADDBNDDIRE BNDDIR(BASE64) OBJ((BASE64R4 *SRVPGM))
      *

      /copy BASE64_H

     D invalidChar     PR
     D   CharPos                     10i 0 value
     D   Char                         3u 0 value

     D b64_alphabet    ds
     D   alphabet                    64A   inz('-
     D                                     ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                     abcdefghijklmnopqrstuvwxyz-
     D                                     0123456789+/')
     D   base64f                      1A   dim(64)
     D                                     overlay(alphabet)

     D b64_reverse     ds
     D   revalphabet                256A   inz(x'-
     D                                     FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF-
     D                                     FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF-
     D                                     FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF-
     D                                     FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF-
     D                                     FFFFFFFFFFFFFFFFFFFFFFFFFFFF3eFF-
     D                                     FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF-
     D                                     FF3fFFFFFFFFFFFFFFFFFFFFFFFFFFFF-
     D                                     FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF-
     D                                     FF1a1b1c1d1e1f202122FFFFFFFFFFFF-
     D                                     FF232425262728292a2bFFFFFFFFFFFF-
     D                                     FFFF2c2d2e2f30313233FFFFFFFFFFFF-
     D                                     FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF-
     D                                     FF000102030405060708FFFFFFFFFFFF-
     D                                     FF090a0b0c0d0e0f1011FFFFFFFFFFFF-
     D                                     FFFF1213141516171819FFFFFFFFFFFF-
     D                                     3435363738393a3b3c3dFFFFFFFFFFFF-
     D                                     ')
     D   base64r                      3U 0 dim(255)
     D                                     overlay(revalphabet:2)

      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  base64_encode:  Encode binary data using Base64 encoding
      *
      *       Input = (input) pointer to data to convert
      *    InputLen = (input) length of data to convert
      *      Output = (output) pointer to memory to receive output
      *     OutSize = (input) size of area to store output in
      *
      *  Returns length of encoded data, or space needed to encode
      *      data. If this value is greater than OutSize, then
      *      output may have been truncated.
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P base64_encode   B                   export
     D base64_encode   PI            10U 0
     D   Input                         *   value
     D   InputLen                    10U 0 value
     D   Output                        *   value
     D   OutputSize                  10U 0 value

     D                 DS
     D   Numb                  1      2U 0 inz(0)
     D   Byte                  2      2A

     D data            DS                  based(Input)
     D   B1                           1A
     D   B2                           1A
     D   B3                           1A

     D OutData         S              4A   based(Output)
     D Temp            S              4A
     D Pos             S             10I 0
     D OutLen          S             10I 0
     D Save            s              1A

      /free

          Pos = 1;

          dow (Pos <= InputLen);

             // -------------------------------------------------
             // First output byte comes from bits 1-6 of input
             // -------------------------------------------------

             Byte = %bitand(B1: x'FC');
             Numb /= 4;
             %subst(Temp:1) = base64f(Numb+1);

             // -------------------------------------------------
             // Second output byte comes from bits 7-8 of byte 1
             //                           and bits 1-4 of byte 2
             // -------------------------------------------------
             Byte = %bitand(B1: x'03');
             Numb *= 16;

             if (Pos+1 <= InputLen);
                Save = Byte;
                Byte = %bitand(B2: x'F0');
                Numb /= 16;
                Byte = %bitor(Save: Byte);
             endif;

             %subst(Temp: 2) = base64f(Numb+1);

             // -------------------------------------------------
             // Third output byte comes from bits 5-8 of byte 2
             //                          and bits 1-2 of byte 3
             // (or is set to '=' if there was only one byte)
             // -------------------------------------------------

             if (Pos+1 > InputLen);
                 %subst(Temp: 3) = '=';
             else;
                 Byte = %bitand(B2: x'0F');
                 Numb *= 4;

                 if (Pos+2 <= InputLen);
                     Save = Byte;
                     Byte = %bitand(B3: x'C0');
                     Numb /= 64;
                     Byte = %bitor(Save: Byte);
                 endif;

                 %subst(Temp:3) = base64f(Numb+1);
             endif;

             // -------------------------------------------------
             // Fourth output byte comes from bits 3-8 of byte 3
             // (or is set to '=' if there was only one/two bytes)
             // -------------------------------------------------

             if (Pos+2 > InputLen);
                 %subst(Temp:4:1) = '=';
             else;
                 Byte = %bitand(B3: x'3F');
                 %subst(Temp:4) = base64f(Numb+1);
             endif;

             // -------------------------------------------------
             //   Advance to next chunk of data.
             // -------------------------------------------------

             Input += %size(data);
             Pos += %size(data);
             OutLen += %size(Temp);

             if (OutLen <= OutputSize);
                OutData = Temp;
                Output += %size(Temp);
             endif;

          enddo;

          return OutLen;

      /end-free
     P                 E


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  base64_decode: Decode base64 encoded data back to binary
      *
      *       Input = (input) pointer to base64 data to decode
      *    InputLen = (input) length of base64 data
      *      Output = (output) pointer to memory to receive output
      *     OutSize = (input) size of area to store output in
      *
      *  Returns length of decoded data, or space needed to decode
      *      data. If this value is greater than OutSize, then
      *      output may have been truncated.
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P base64_decode   B                   export
     D base64_decode   PI            10U 0
     D   Input                         *   value
     D   InputLen                    10U 0 value
     D   Output                        *   value
     D   OutputSize                  10U 0 value

     D                 DS
     D   Numb                  1      2U 0 inz(0)
     D   Byte                  2      2A

     D data            DS                  based(Input)
     D   B1                           3U 0
     D   B2                           3U 0
     D   B3                           3U 0
     D   B4                           3U 0

     D OutData         S              3A   based(Output)
     D temp            S              3A   varying
     D Pos             S             10I 0
     D OutLen          S             10I 0

      /free

          Pos = 1;

          dow (Pos <= InputLen);

             if (base64r(B1)=x'FF');
                 invalidChar(Pos:B1);
             endif;
             if (base64r(B2)=x'FF');
                 invalidChar(Pos+1:B2);
             endif;
             if (base64r(B3)=x'FF' and B3<>126);
                 invalidChar(Pos+2:B3);
             endif;
             if (base64r(B4)=x'FF' and B4<>126);
                 invalidChar(Pos+3:B4);
             endif;

             // -------------------------------------------------
             // First output byte comes from bits 3-8 of byte 1
             //                          and bits 3-4 of byte 2
             // -------------------------------------------------

             Numb = base64r(B1) * 4
                  + base64r(B2) / 16;
             Temp = Byte;

             // -------------------------------------------------
             // Second output byte comes from bits 5-8 of byte 2
             //                           and bits 3-6 of byte 3
             // -------------------------------------------------
             if %subst(data: 3: 1) <> '=';
                  numb = %bitand(base64r(B2):x'0f') * 16
                       + base64r(B3) / 4;
                  Temp += Byte;
             endif;

             // -------------------------------------------------
             // Third output byte comes from bits 7-8 of byte 3
             //                          and bits 3-8 of byte 4
             // (or is set to '=' if there was only one byte)
             // -------------------------------------------------
             if %subst(data: 4: 1) <> '=';
                  numb = %bitand(base64r(B3):x'03') * 64
                       + base64r(B4);
                  Temp += Byte;
             endif;

             // -------------------------------------------------
             //   Advance to next chunk of data.
             // -------------------------------------------------

             Input += %size(data);
             Pos += %size(data);
             OutLen += %len(Temp);

             if (OutLen <= OutputSize);
                OutData = Temp;
                Output += %len(Temp);
             endif;

          enddo;

          return OutLen;

      /end-free
     P                 E


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  base64_inAlphabet(): Check if a given character is in the
      *                       base64 alphabet
      *
      *        Char = (input) character to check
      *
      * Returns *ON if it's in the alphabet, *OFF otherwise
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P base64_inAlphabet...
     P                 B                   export
     D base64_inAlphabet...
     D                 PI             1N
     D   Char                         1a   value
     D Numb            s              3U 0 based(p_Numb)
      /free
         p_Numb = %addr(char);
         if base64r(Numb) = x'FF';
            return *OFF;
         else;
            return *ON;
         endif;
      /end-free
     P                 E


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * invalidChar(): Report an invalid input character
      *                in a fashion dramatic enough that people
      *                won't blame me when they provide invalid
      *                input characters!
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P invalidChar     B
     D invalidChar     PI
     D   CharPos                     10i 0 value
     D   Char                         3u 0 value

     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   Const
     D   QualMsgF                    20A   Const
     D   MsgData                  32767a   Const options(*varsize)
     D   MsgDtaLen                   10I 0 Const
     D   MsgType                     10A   Const
     D   CallStkEnt                  10A   Const
     D   CallStkCnt                  10I 0 Const
     D   MessageKey                   4A
     D   ErrorCode                 8192A   options(*varsize)

     D ErrorCode       DS                  qualified
     D  BytesProv              1      4I 0 inz(0)
     D  BytesAvail             5      8I 0 inz(0)

     D cvthc           PR                  ExtProc('cvthc')
     D   target                       2A   options(*varsize)
     D   src_bits                     3u 0 const
     D   tgt_length                  10I 0 value

     D Hex             s              2a
     D MsgKey          S              4A
     D MsgDta          s            100a   varying

      /free

         cvthc(hex:char:%size(hex));

         MsgDta = 'Unable to decode character at position '
                + %char(CharPos) + '. (Char=x''' + hex + ''')';

         QMHSNDPM( 'CPF9897'
                 : 'QCPFMSG   *LIBL'
                 : MsgDta
                 : %len(MsgDta)
                 : '*ESCAPE'
                 : '*PGMBDY'
                 : 2
                 : MsgKey
                 : ErrorCode         );

      /end-free
     P                 E
