**free

ctl-opt nomain 
        pgminfo(*PCML:
                *MODULE:
                *DCLCASE) ;


dcl-f TL000P keyed usage(*input);

dcl-c H_OK             200 ; 
dcl-c H_CREATED        201 ;
dcl-c H_NOCONTENT      204 ;
dcl-c H_BADREQUEST     400 ;
dcl-c H_NOTFOUND       404 ;  
dcl-c H_CONFLICT       409 ;
dcl-c H_GONE           410 ;   
dcl-c H_SERVERERROR    500 ;  

dcl-pr tstHeader  ;
  username     char(10) const ; 
  password     char(10) const ;
  http_token   char(256)  ; 
  output       char(50);
  httpStatus   int(10:0);
  httpHeaders  char(100) dim(10);
end-pr;

// ------------------------------------------------------------------------------------
// Get lib All
// ------------------------------------------------------------------------------------
dcl-proc tstHeader export ;

  dcl-pi tstHeader ;
  username     char(10) const ; 
  password     char(10) const ;
  http_token   char(256)  ; 
  output       char(50);
  httpStatus   int(10:0);
  httpHeaders  char(100) dim(10);
  end-pi;
  
if http_token = 'abcd';
  http_token = 'xyz';
endif;

  output = username + password + http_token; 
  httpStatus = H_OK;
  httpHeaders(1) = 'Cache-Control: no-cache, no-store' ;
      
end-proc;