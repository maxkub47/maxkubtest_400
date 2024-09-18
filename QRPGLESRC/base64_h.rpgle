     /*-                                                                            +
      * Copyright (c) 2005 Scott C. Klement                                         +
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

      /if defined(BASE64_H_DEFINED)
      /eof
      /endif
      /define BASE64_H_DEFINED

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
     D base64_encode   PR            10U 0
     D   Input                         *   value
     D   InputLen                    10U 0 value
     D   Output                        *   value
     D   OutputSize                  10U 0 value


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  base64_decode: Decode base64 encoded data back to binary
      *
      *       Input = (input) pointer to base64 data to decodet
      *    InputLen = (input) length of base64 data
      *      Output = (output) pointer to memory to receive output
      *     OutSize = (input) size of area to store output in
      *
      *  Returns length of decoded data, or space needed to decode
      *      data. If this value is greater than OutSize, then
      *      output may have been truncated.
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D base64_decode   PR            10U 0
     D   Input                         *   value
     D   InputLen                    10U 0 value
     D   Output                        *   value
     D   OutputSize                  10U 0 value


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  base64_inAlphabet(): Check if a given character is in the
      *                       base64 alphabet
      *
      *        Char = (input) character to check
      *
      * Returns *ON if it's in the alphabet, *OFF otherwise
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D base64_inAlphabet...
     D                 PR             1N   extproc(*CL:'BASE64_INALPHABET')
     D   Char                         1a   value
