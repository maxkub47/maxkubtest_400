**free

ctl-opt DFTACTGRP(*no) option(*srcstmt: *nodebugio) pgminfo(*PCML:*MODULE);

/COPY QSYSINC/QRPGLESRC,QC3CCI
/COPY QSYSINC/QRPGLESRC,QUSEC

dcl-pr CrtKeyCtx extproc('Qc3CreateKeyContext');
   KeyString       char(65535) const options(*varsize);
   LenKeyString    int(10)     const;
   KeyFormat       char(1)     const;
   KeyType         int(10)     const;
   KeyForm         char(1)     const;
   KeyEncrKey      char(8)     const options(*omit);
   KeyAlgorithm    char(8)     const options(*omit);
   KeyContext      char(8);
   QUSEC           likeds(QUSEC);
end-pr;

dcl-pr GenPRN extproc('Qc3GenPRNs');
   PRN            char(1)      options(*varsize);
   LenPRN         int(10)      const;
   PRNType        char(1)      const;
   PRNParity      char(1)      const;
   QUSEC          likeds(QUSEC);
end-pr;

dcl-pr Encrypt extproc('Qc3EncryptData');
   ClearData      char(65535)  const options(*varsize);
   LenClearData   int(10)      const;
   ClearDataFmt   char(8)      const;
   AlgDesc        char(65535)  const options(*varsize);
   AlgDescFmt     char(8)      const;
   KeyDesc        char(65535)  const options(*varsize: *omit);
   KeyDescFmt     char(8)      const options(*omit);
   CryptoProvider char(1)      const;
   CryptoDevice   char(10)     const options(*omit);
   EncrData       char(1)      options(*varsize);
   LenEncrData    int(10)      const;
   RtnLenEncrData int(10);
   QUSEC          likeds(QUSEC);
end-pr;

dcl-pr DstKeyCtx extproc('Qc3DestroyKeyContext');
   KeyContext     char(8)      const;
   QUSEC          likeds(QUSEC);
end-pr;

dcl-ds CustomerDS qualified;
   Custnbr  char(10) ; 
   CustName char(10) ; 
end-ds;

dcl-ds EncrCustDS qualified;
   Custnbr  char(10) ; 
   EncrData     char(48);      // Encrypted Data (hexadecimal)
   IV           char(16);      // Initialization Vector (hexadecimal)
end-ds;

dcl-s Key char(16) dtaara('CLEARKEY');
dcl-s LenEncrRtn int(10);

QUSBPRV = 0;

// Describe the encryption algorithm to use 
QC3D0200 = 'SHA-256';            //Initialize format to x'00' 
QC3BCA =22;                  
QC3BL = 16;                   
QC3MODE = '1';                
QC3PO = '1';                  
QC3PC = *loval;               // AES // Block length of 16 // CBC // Pad to 16 byte boundary // Pad with x'00'

CustomerDS.CustName = 'MAXKUB' ;

// Create a key encrypting context in Key
CrtKeyCtx(Key: %size(Key): '0': 22: '0': *OMIT: *OMIT: QC3KCT: QUSEC);
Key = *blanks;

// Process all records from the Customer file
   // Get an initialization vector for this customer
   GenPRN(EncrCustDS.IV: %size(EncrCustDS.IV): '0': '0': QUSEC);
   QC3IV = EncrCustDS.IV;

   // Encrypt the customer data
   Encrypt(CustomerDS.CustName: %size(CustomerDS.CustName): 'DATA0100': QC3D0200: 'ALGD0200': QC3D010000: 'KEYD0100': '0': *OMIT: EncrCustDS.EncrData: %size(EncrCustDS.EncrData): LenEncrRtn: QUSEC);



// When done, clean up
DstKeyCtx(QC3D010000: QUSEC);

*inlr = *on;
return;