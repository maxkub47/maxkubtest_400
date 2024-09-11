**free

ctl-opt DFTACTGRP(*no) option(*srcstmt: *nodebugio) pgminfo(*PCML:*MODULE);

/COPY QSYSINC/QRPGLESRC,QC3CCI
/COPY QSYSINC/QRPGLESRC,QUSEC

dcl-pr HshDta extproc('Qc3CalculateHash');
   InpDta        char(4096) const options(*varsize);
   LenInpDta     int(10) const;
   FmtInpDta     char(8) const;
   AlgDsc        char(4096) const options(*varsize);
   FmtAlgDsc     char(8) const;
   CryptoPrv     char(1) const;
   CryptoDev     char(10) const;
   HshVal        char(1) options(*varsize);
   ErrCde        likeds(qusec);
end-pr;

dcl-s Data        char(25) inz('Maxkub');
dcl-s HashValue   char(32);

// Main logic

QUSBPrv = 0;                                          

                                                        

QC3HA = 2;                                            

HshDta(Data :%len(%trimr(Data)) :'DATA0100'          

         :QC3D0500 :'ALGD0500' :'0' :' '                

         :HashValue :QUSEC);                             

*inlr = *on;
return;