**Free

ctl-opt nomain
        option(*srcstmt: *nodebugio)
        pgminfo(*PCML:*MODULE);

dcl-proc BBB export ; 
  dcl-pi *n ; 
    input			char(1024) ccsid(819); 
    output          char(1024) ; 
  end-pi ; 

  exec sql 
  select systools.BASE64ENCODE(:input)
  into :output
  from sysibm.sysdummy1;

end-proc;