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
  output1      char(256)  ; 
  output2      char(256);
  httpStatus   int(10:0);
  httpHeaders  char(100) dim(10);
end-pr;

dcl-pr getenv pointer extproc('getenv');
  varname pointer value options(*string);
end-pr;

dcl-s authHeader char(5512);
dcl-s authEnvPtr pointer;
dcl-s auttest    char(5512);

// ------------------------------------------------------------------------------------
// Get lib All
// ------------------------------------------------------------------------------------
dcl-proc tstHeader export ;

  dcl-pi tstHeader ;
    username     char(10) const ; 
    password     char(10) const ;
    output1      char(256)  ; 
    output2      char(256);
    httpStatus   int(10:0);
    httpHeaders  char(100) dim(10);
  end-pi;
  

  authEnvPtr = getenv('HTTP_AUTHORIZATION');

  if authEnvPtr <> *null;
    authHeader = %str(authEnvPtr);
  else;
    authHeader = '';
  endif;

  exec sql 
    select systools.getenv('HTTP_AUTHORIZATION')
    into :auttest
    from sysibm.sysdummy1;

  output1 = auttest ;
  output2 = authHeader;
  httpStatus = H_OK;
  httpHeaders(1) = 'Cache-Control: no-cache, no-store' ;
      
end-proc;