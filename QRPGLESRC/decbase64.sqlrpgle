**Free

ctl-opt nomain
        option(*srcstmt: *nodebugio)
        pgminfo(*PCML:*MODULE);

dcl-proc AAA export ; 
  dcl-pi *n ; 
    input			char(1024) ; 
    output    char(1024) ccsid(819); 
  end-pi ; 

  exec sql 
  select systools.BASE64DECODE(:input)
  into :output
  from sysibm.sysdummy1;

end-proc;