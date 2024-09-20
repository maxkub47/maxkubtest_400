**Free

ctl-opt nomain
        option(*srcstmt: *nodebugio)
        pgminfo(*PCML:*MODULE);

dcl-pr decodeBase64 ; 
  input			char(1024) ; 
  output    char(1024) ; 
end-pr ; 

dcl-proc decodeBase64 export ; 
  dcl-pi decodeBase64 ; 
    		input			char(1024) ; 
    	output    char(1024) ; 
  end-pi ; 

  exec sql 
  select systools.BASE64DECODE(:input)
  into :output
  from sysibm.sysdummy1;

end-proc;