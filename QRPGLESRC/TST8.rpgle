**free

ctl-opt nomain 
        pgminfo(*PCML:
                *MODULE:
                *DCLCASE);


dcl-pr tst;
  char          char(10) ;
  zoned         zoned(6:2); 
  pack          packed(6:2) ;
  int           int(10) ;
  dete          date ;
  timestamp     timestamp ;

end-pr;


// ------------------------------------------------------------------------------------
// tstHeader Procedure
// ------------------------------------------------------------------------------------
dcl-proc tst export;

  dcl-pi tst;
  char          char(10) ;
  zoned         zoned(6:2) ;
  pack          packed(6:2) ;
  int           int(10) ;
  dete          date ;
  timestamp     timestamp ; 
end-pi;

char    =  'ABCXDEES';
zoned   = 33.33;
pack     = 20.11;
int      = 20;
dete     = %date();
timestamp = %timestamp();

end-proc;
