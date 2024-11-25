**free

ctl-opt nomain 
        pgminfo(*PCML:
                *MODULE:
                *DCLCASE);

dcl-c H_OK             200 ; 
dcl-c H_CREATED        201 ;
dcl-c H_NOCONTENT      204 ;
dcl-c H_BADREQUEST     400 ;
dcl-c H_NOTFOUND       404 ;  
dcl-c H_CONFLICT       409 ;
dcl-c H_GONE           410 ;   
dcl-c H_SERVERERROR    500 ;  

dcl-pr tstHeader extpgm(tst10);
  output1      char(256); 
  output2      char(256);
  httpStatus   int(10:0);
  httpHeaders  char(100) dim(10);
end-pr;

dcl-pr getenv pointer extproc('getenv');
  varname pointer value options(*string);
end-pr;

dcl-s authHeader char(512);
dcl-s authEnvPtr pointer;
dcl-s base64Token char(512); // Base64 encoded value
dcl-s decodedValue varchar(512) ccsid(819); // Decoded value in UTF-8

// ------------------------------------------------------------------------------------
// Get lib All
// ------------------------------------------------------------------------------------
dcl-proc tstHeader export;

  dcl-pi tstHeader;
    output1      char(256); 
    output2      char(256);
    httpStatus   int(10:0);
    httpHeaders  char(100) dim(10);
  end-pi;
  
  // Get the Authorization header
  authEnvPtr = getenv('HTTP_AUTHORIZATION');

  if authEnvPtr <> *null;
    authHeader = %str(authEnvPtr);

    if %scan('Basic ':authHeader) = 1;
      base64Token = %subst(authHeader:7);
    endif;

    // Execute SQL to decode the Base64 token
    exec sql 
    select systools.BASE64DECODE(:base64Token)
    into :decodedValue
    from sysibm.sysdummy1;

  endif;

  // Return the decoded values
  output1 = authHeader; 
  output2 = decodedValue;
  httpStatus = H_OK;
  httpHeaders(1) = 'Cache-Control: no-cache, no-store';

end-proc;
