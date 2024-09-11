**Free

ctl-opt DFTACTGRP(*no) option(*srcstmt: *nodebugio) pgminfo(*PCML:*MODULE);

// API error data structure:
dcl-ds ERRC0100 Qualified;
   BytPrv int(10) inz(%size(ERRC0100));
   BytAvl int(10);
   MsgId  char(7);
   filler char(1);
   MsgDta char(1024);
end-ds;

// Global constants:
dcl-c PRN_REAL '0';
dcl-c PRN_TEST '1';

dcl-c PAR_NOT '0';
dcl-c PAR_ODD '1';
dcl-c PAR_EVEN '2';

dcl-c CSP_ANY '0';
dcl-c CSP_SFW '1';
dcl-c CSP_HDW '2';

dcl-c DES 20;
dcl-c TDES 21;
dcl-c AES 22;
dcl-c RC2 23;

dcl-c ECB '0';
dcl-c CBC '1';
dcl-c OFB '2';
dcl-c OFB_1B '3';
dcl-c OFB_8B '4';
dcl-c OFB_64B '5';

dcl-c PAD_NO '0';
dcl-c PAD_CHR '1';
dcl-c PAD_CNT '2';

dcl-c KEY_DES 20;
dcl-c KEY_TDES 21;
dcl-c KEY_AES 22;
dcl-c KEY_RC2 23;
dcl-c KEY_RC4_C 30;
dcl-c KEY_RSA_PUB 50;
dcl-c KEY_RSA_PRI 51;

dcl-c FMT_BIN '0';
dcl-c FMT_BER '1';

dcl-c TYP_DES 20;
dcl-c TYP_TDES 21;
dcl-c TYP_AES 22;
dcl-c TYP_RC2 23;
dcl-c TYP_RC4_C 30;
dcl-c TYP_RSA_PUB 50;
dcl-c TYP_RSA_PRI 51;

dcl-c TYP_MD5 1;
dcl-c TYP_SHA_1 2;
dcl-c TYP_SHA_256 3;
dcl-c TYP_SHA_384 4;
dcl-c TYP_SHA_512 5;

dcl-c KEY_CLR '0';
dcl-c KEY_ENC '1';

dcl-c KEY_CTX_NONE ' ';
dcl-c ALG_CTX_NONE ' ';
dcl-c CRP_DEV_NONE ' ';

dcl-c FOF_CON '0';
dcl-c FOF_FIN '1';

dcl-c NULL '';
dcl-c DFT_BLK_LEN 16;
dcl-c DFT_PAD_CHR x'00';

// Encrypt data API:
dcl-pr EncryptData extproc('Qc3EncryptData');
   ClrDta char(65535) const options(*varsize);
   ClrDtaLen int(10) const;
   ClrDtaFmt char(8) const;
   AlgDsc char(1024) const options(*varsize);
   AlgDscFmt char(8) const;
   KeyDsc char(1024) const options(*varsize);
   KeyDscFmt char(8) const;
   CrpSrvPrv char(1) const;
   CrpDevNam char(10) const;
   EncDta char(65535) options(*varsize);
   EncDtaLen int(10) const;
   EncRtnLen int(10);
   Error char(32767) options(*varsize);
end-pr;

// Decrypt data API:
dcl-pr DecryptData extproc('Qc3DecryptData');
   EncDta char(65535) const options(*varsize);
   EncDtaLen int(10) const;
   AlgDsc char(1024) const options(*varsize);
   AlgDscFmt char(8) const;
   KeyDsc char(1024) const options(*varsize);
   KeyDscFmt char(8) const;
   CrpSrvPrv char(1) const;
   CrpDevNam char(10) const;
   ClrDta char(65535) options(*varsize);
   ClrDtaLen int(10) const;
   ClrRtnLen int(10);
   Error char(32767) options(*varsize);
end-pr;

// Translate Data API
dcl-pr TranslateData extproc('Qc3TranslateData');
   TrnDtaInp     pointer   const options(*varsize);
   TrnDtaInpLen  int(10)    const;
   DecAlgCtxTkn  char(8)    const;
   DecKeyCtxTkn  char(8)    const;
   EncAlgCtxTkn  char(8)    const;
   EncKeyCtxTkn  char(8)    const;
   CrpSrvPrv     char(1)    const;
   CrpDevNam     char(10)   const;
   TrnDtaOut     pointer          options(*varsize);
   TrnDtaOutLen  int(10)    const;
   TrnDtaRtnLen  int(10);
   Error         pointer          options(*varsize);
end-pr;

// Calculate Hash API
dcl-pr CalculateHash extproc('Qc3CalculateHash');
   ClcDtaInp     pointer   const options(*varsize);
   ClcDtaInpLen  int(10)    const;
   ClcDtaFmt     char(8)    const;
   AlgDsc        char(256)  const options(*varsize);
   AlgDscFmt     char(8)    const;
   CrpSrvPrv     char(1)    const;
   CrpDevNam     char(10)   const;
   ClcDtaOut     char(256);
   Error         pointer          options(*varsize);
end-pr;

// Generate Pseudorandom Numbers API
dcl-pr GenRndNbr extproc('Qc3GenPRNs');
   PrnDta        char(1024) options(*varsize);
   PrnDtaLen     int(10)    const;
   PrnTyp        char(1)    const;
   PrnPar        char(1)    const;
   Error         pointer          options(*varsize);
end-pr;

// Generate symmetric key API
dcl-pr GenSymKey extproc('Qc3GenSymmetricKey');
   KeyTyp         int(10)   const;
   KeySiz         int(10)   const;
   KeyFmt         char(1)   const;
   KeyFrm         char(1)   const;
   KekKeyCtxTkn   char(8)   const;
   KekAlgCtxTkn   char(8)   const;
   CrpSrvPrv      char(1)   const;
   CrpDevNam      char(10)  const;
   KeyStr         char(256) options(*varsize);
   KeyStrLen      int(10)   const;
   KeyLenRtn      int(10);
   Error          pointer   options(*varsize);
end-pr;

// Create algorithm context API
dcl-pr CrtAlgCtx extproc('Qc3CreateAlgorithmContext');
   AlgDsc         char(1024) const options(*varsize);
   AlgDscFmt      char(8)    const;
   AlgCtxTkn      char(8);
   Error          pointer   options(*varsize);
end-pr;

// Create key context API
dcl-pr CrtKeyCtx extproc('Qc3CreateKeyContext');
   KeyStr         char(256) const options(*varsize);
   KeyStrLen      int(10)   const;
   KeyFmt         char(1)   const;
   KeyTyp         int(10)   const;
   KeyFrm         char(1)   const;
   KekKeyCtxTkn   char(8)   const;
   KekAlgCtxTkn   char(8)   const;
   KeyCtxTkn      char(8);
   Error          pointer   options(*varsize);
end-pr;

// Destroy algorithm context API
dcl-pr DstAlgCtx extproc('Qc3DestroyAlgorithmContext');
   AlgCtxTkn      char(8)   const;
   Error          pointer   options(*varsize);
end-pr;

// Destroy key context API
dcl-pr DstKeyCtx extproc('Qc3DestroyKeyContext');
   KeyCtxTkn      char(8)   const;
   Error          pointer   options(*varsize);
end-pr;

// Retrieve key record attributes
dcl-pr RtvKeyRcdA extproc('Qc3RetrieveKeyRecordAtr');
   KeyStore_q     char(20)  const;
   RcdLbl         char(32)  const;
   KeyTyp         int(10);
   KeySiz         int(10);
   MstKeyID       int(10);
   KeyVfyVal      char(20);
   DisAlwFnc      int(10);
   Error          pointer   options(*varsize);
end-pr;

// Convert character to hex
dcl-pr cvtch extproc('cvtch');
   RcvChr         pointer   value;
   SrcHex         pointer   value;
   SrcLen         int(10)   value;
end-pr;

// Convert hex to character
dcl-pr cvthc extproc('cvthc');
   RcvHex         pointer   value;
   SrcChr         pointer   value;
   RcvLen         int(10)   value;
end-pr;

// Get cipher key
dcl-pr GetCphKey char(48) varying;
   PxKeyStore_q   char(20)  const;
   PxKeyLbl       char(32)  varying const;
end-pr;

// Generate initialization vector
dcl-pr GenInzVct char(128) varying;
   PxIzvLen       int(10)   const;
end-pr;

// Generate AES cipher key
dcl-pr GenAesKey char(48) varying;
   PxKeyLen       int(10)   const;
   PxKekKeyCtxTk  char(8)   const options(*nopass);
   PxKekAlgCtxTk  char(8)   const options(*nopass);
end-pr;

// Get algorithm context
dcl-pr GetAlgCtx char(8);
   PxBlkCphAlg    int(10)   const;
   PxBlkLen       int(10)   const;
   PxMode         char(1)   const;
   PxPadOpt       char(1)   const;
   PxPadChr       char(1)   const;
   PxInzVct       char(32)  const options(*nopass);
end-pr;

// Get key context
dcl-pr GetKeyCtx char(8);
   PxKeyStr       char(64)  varying const;
   PxKeyTyp       int(10)   const;
   PxKeyFmt       char(1)   const;
   PxKekKeyCtxTk  char(8)   const options(*nopass);
   PxKekAlgCtxTk  char(8)   const options(*nopass);
end-pr;

// Remove algorithm context
dcl-pr RmvAlgCtx int(10);
   PxAlgCtx       char(8);
end-pr;

// Remove key context
dcl-pr RmvKeyCtx int(10);
   PxKeyCtx       char(8);
end-pr;

// Encrypt data string
dcl-pr EncDtaStr char(1024) varying;
   PxDtaStr       char(1024) varying const;
   PxAlgCtxTkn    char(8);
   PxKeyCtxTkn    char(8);
end-pr;

// Decrypt cipher string
dcl-pr DecCphStr char(1024) varying;
   PxCphStr       char(1024) varying const;
   PxAlgCtxTkn    char(8);
   PxKeyCtxTkn    char(8);
end-pr;

// Calculate hash value
dcl-pr ClcHashVal char(256) varying;
   PxCalcStr      char(65535) varying const;
   PxHashAlg      int(10)   const;
end-pr;

// Get key management algorithm context
dcl-pr GetMgtAlg char(8);
end-pr;

// Translate data string
dcl-pr TrnDtaStr char(1024) varying;
   PxTrnDtaStr    char(1024) varying const;
   PxDecAlgCtxTk  char(8);
   PxDecKeyCtxTk  char(8);
   PxEncAlgCtxTk  char(8);
   PxEncKeyCtxTk  char(8);
end-pr;

// Verify key store record
dcl-pr VfyKeyRcd int(10);
   PxKeyStore_q   char(20)  const;
   PxRcdLbl       char(32)  const;
end-pr;

// Convert hex nibbles to character
dcl-pr CvtHexChr char(512) varying;
   PxHexStr       char(1024) varying const;
end-pr;

// Convert character to hex nibbles
dcl-pr CvtChrHex char(1024) varying;
   PxHexStr       char(512)  varying const;
end-pr;

// Generate initialization vector procedure (local)
dcl-proc GenInzVct export;
   dcl-pi *n char(128) varying;
      PxIzvLen int(10) const;
   end-pi;

   dcl-s InzVct char(128);
   // Procedure logic here

end-proc;

// Fully Free Format Version

// Local declarations
dcl-s AlgCtxTkn char(8);

// Get Algorithm Context
dcl-proc GetAlgCtx export;
  dcl-pi *n char(8);
    PxBlkCphAlg int(10) const;
    PxBlkLen int(10) const;
    PxMode int(10) const;
    PxPadOpt int(10) const;
    PxPadChr char(1) const;
    PxInzVct char(16) const options(*nopass);
  end-pi;

  dcl-ds ALGD0200 qualified;
    BlkCphAlg int(10);
    BlkLen int(10);
    Mode int(10);
    PadOpt int(10);
    PadChr char(1);
    Rsv char(1);
    MacLen int(10);
    EfcKeySiz int(10);
    InzVct_IV char(16);
  end-ds;

  if %parms >= 6;
    ALGD0200.InzVct_IV = PxInzVct;
  else;
    ALGD0200.InzVct_IV = *allx'00';
  endif;

  CrtAlgCtx(ALGD0200: 'ALGD0200': AlgCtxTkn: ERRC0100);

  if ERRC0100.bytAvl > 0;
    return *blanks;
  else;
    return AlgCtxTkn;
  endif;

end-proc;

// Get key context
dcl-proc GetKeyCtx export;
  dcl-pi *n char(8);
    PxKeyStr varchar(64) const;
    PxKeyTyp int(10) const;
    PxKeyFmt char(1) const;
    PxKekKeyCtxTk char(8) const options(*nopass);
    PxKekAlgCtxTk char(8) const options(*nopass);
  end-pi;

  dcl-s KeyCtxTkn char(8);

  if %parms >= 5;
    CrtKeyCtx(PxKeyStr: %len(PxKeyStr): PxKeyFmt: PxKeyTyp: KEY_ENC: 
              PxKekKeyCtxTk: PxKekAlgCtxTk: KeyCtxTkn: ERRC0100);
  else;
    CrtKeyCtx(PxKeyStr: %len(PxKeyStr): PxKeyFmt: PxKeyTyp: KEY_CLR: 
              KEY_CTX_NONE: ALG_CTX_NONE: KeyCtxTkn: ERRC0100);
  endif;

  if ERRC0100.bytAvl > 0;
    return *blanks;
  else;
    return KeyCtxTkn;
  endif;

end-proc;

// Remove algorithm context
dcl-proc RmvAlgCtx export;
  dcl-pi *n int(10);
    PxAlgCtxTkn char(8);
  end-pi;

  DstAlgCtx(PxAlgCtxTkn: ERRC0100);

  if ERRC0100.bytAvl > 0;
    return -1;
  else;
    return 0;
  endif;

end-proc;

// Remove key context
dcl-proc RmvKeyCtx export;
  dcl-pi *n int(10);
    PxKeyCtxTkn char(8);
  end-pi;

  DstKeyCtx(PxKeyCtxTkn: ERRC0100);

  if ERRC0100.bytAvl > 0;
    return -1;
  else;
    return 0;
  endif;

end-proc;

// Encrypt data string
dcl-proc EncDtaStr export;
  dcl-pi *n varchar(1024);
    PxDtaStr varchar(1024) const;
    PxAlgCtxTkn char(8);
    PxKeyCtxTkn char(8);
  end-pi;

  dcl-ds ALGD0100 qualified;
    AlgCtxTkn char(8);
    FinOprFlg char(1);
  end-ds;

  dcl-s EncDtaStr varchar(1024);
  dcl-s EncRtnLen int(10);

  ALGD0100.AlgCtxTkn = PxAlgCtxTkn;
  ALGD0100.FinOprFlg = FOF_FIN;

  EncryptData(PxDtaStr: %len(PxDtaStr): 'DATA0100': ALGD0100: 'ALGD0100': 
              PxKeyCtxTkn: 'KEYD0100': CSP_SFW: *blanks: EncDtaStr: 
              %size(EncDtaStr): EncRtnLen: ERRC0100);

  if ERRC0100.bytAvl > 0;
    return *null;
  else;
    return %subst(EncDtaStr: 1: EncRtnLen);
  endif;

end-proc;

// Decrypt cipher string
dcl-proc DecCphStr export;
  dcl-pi *n varchar(1024);
    PxCphStr varchar(1024) const;
    PxAlgCtxTkn char(8);
    PxKeyCtxTkn char(8);
  end-pi;

  dcl-ds ALGD0100 qualified;
    AlgCtxTkn char(8);
    FinOprFlg char(1);
  end-ds;

  dcl-s RtnDtaStr varchar(1024);
  dcl-s RtnDtaLen int(10);

  ALGD0100.AlgCtxTkn = PxAlgCtxTkn;
  ALGD0100.FinOprFlg = FOF_FIN;

  DecryptData(PxCphStr: %len(PxCphStr): ALGD0100: 'ALGD0100': PxKeyCtxTkn: 
              'KEYD0100': CSP_SFW: *blanks: RtnDtaStr: %size(RtnDtaStr): 
              RtnDtaLen: ERRC0100);

  if ERRC0100.bytAvl > 0;
    return *null;
  else;
    return %subst(RtnDtaStr: 1: RtnDtaLen);
  endif;

end-proc;

// Other procedures remain with a similar conversion pattern

// Calculate hash value
dcl-proc ClcHashVal export;
  dcl-pi *n varchar(256);
    PxCalcStr varchar(65535) const;
    PxHashAlg int(10) const;
  end-pi;

  dcl-ds ALGD0100 qualified;
    AlgCtxTkn char(8);
    FinOprFlg char(1);
  end-ds;

  dcl-ds ALGD0500 qualified;
    HashAlg int(10);
  end-ds;

  dcl-s RtnDtaStr varchar(1024);

  ALGD0500.HashAlg = PxHashAlg;

  CalculateHash(PxCalcStr: %len(PxCalcStr): 'DATA0100': ALGD0500: 'ALGD0500': 
                CSP_SFW: *blanks: RtnDtaStr: ERRC0100);

  select;
    when ERRC0100.bytAvl > 0;
      return *null;
    when ALGD0500.HashAlg = TYP_MD5;
      return %subst(RtnDtaStr: 1: 16);
    when ALGD0500.HashAlg = TYP_SHA_1;
      return %subst(RtnDtaStr: 1: 20);
    when ALGD0500.HashAlg = TYP_SHA_256;
      return %subst(RtnDtaStr: 1: 32);
    when ALGD0500.HashAlg = TYP_SHA_384;
      return %subst(RtnDtaStr: 1: 48);
    when ALGD0500.HashAlg = TYP_SHA_512;
      return %subst(RtnDtaStr: 1: 64);
    other;
      return *null;
  endsl;

end-proc;

// Get key management algorithm context
dcl-proc GetMgtAlg export;
  dcl-pi *n char(8);
  end-pi;

  dcl-s AlgCtxTkn char(8);

  AlgCtxTkn = GetAlgCtx(AES: DFT_BLK_LEN: ECB: PAD_CHR: DFT_PAD_CHR);

  return AlgCtxTkn;

end-proc;

// Translate data string
dcl-proc TrnDtaStr export;
  dcl-pi *n varchar(1024);
    PxTrnDtaStr varchar(1024) const;
    PxDecAlgCtxTk char(8);
    PxDecKeyCtxTk char(8);
    PxEncAlgCtxTk char(8);
    PxEncKeyCtxTk char(8);
  end-pi;

  dcl-s TrnRtnDtaStr varchar(1024);
  dcl-s TrnRtnDtaLen int(10);

  TranslateData(PxTrnDtaStr: %len(PxTrnDtaStr): PxDecAlgCtxTk: PxDecKeyCtxTk: 
                PxEncAlgCtxTk: PxEncKeyCtxTk: CSP_SFW: *blanks: TrnRtnDtaStr: 
                %size(TrnRtnDtaStr): TrnRtnDtaLen: ERRC0100);

  if ERRC0100.bytAvl > 0;
    return *null;
  else;
    return %subst(TrnRtnDtaStr: 1: TrnRtnDtaLen);
  endif;

end-proc;

// Verify key store record
dcl-proc VfyKeyRcd export;
  dcl-pi *n int(10);
    PxKeyStore_q char(20) const;
    PxRcdLbl char(32) const;
  end-pi;

  dcl-s KeyTyp int(10);
  dcl-s KeySiz int(10);
  dcl-s MstKeyID int(10);
  dcl-s KeyVfyVal char(20);
  dcl-s DisAlwFnc int(10);

  RtvKeyRcdA(PxKeyStore_q: PxRcdLbl: KeyTyp: KeySiz: MstKeyID: KeyVfyVal: 
             DisAlwFnc: ERRC0100);

  if ERRC0100.bytAvl > 0;
    return -1;
  else;
    return 0;
  endif;

end-proc;

// Convert hex nibbles to character
dcl-proc CvtHexChr export;
  dcl-pi *n varchar(512);
    PxHexStr varchar(1024) const;
  end-pi;

  dcl-s ChrStr varchar(512);
  dcl-s HexStr varchar(1024);

  HexStr = PxHexStr;

  cvtch(%addr(ChrStr): %addr(HexStr): %len(PxHexStr));

  return %subst(ChrStr: 1: %int(%len(PxHexStr) / 2));

end-proc;

// Convert character to hex nibbles
dcl-proc CvtChrHex export;
  dcl-pi *n varchar(1024);
    PxChrStr varchar(512) const;
  end-pi;

  dcl-s HexStr varchar(1024);
  dcl-s ChrStr varchar(512);

  ChrStr = PxChrStr;

  cvthc(%addr(HexStr): %addr(ChrStr): %len(PxChrStr) * 2);

  return %subst(HexStr: 1: %int(%len(PxChrStr) * 2));

end-proc;