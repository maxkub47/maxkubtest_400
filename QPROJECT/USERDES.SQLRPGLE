**free

ctl-opt nomain 
        pgminfo(*PCML:
                *MODULE:
                *DCLCASE);


dcl-ds response  qualified ;
  employee_id     char(5);
  empolyee_name		char(30) ccsid(838);
  factory					char(2);
  group						char(3);
end-ds ; 

dcl-pr getenv pointer extproc('getenv');
  varname pointer value options(*string);
end-pr;

dcl-pr chk_usr extpgm('QSYGETPH');
  UserID              char(10)    const;
  password            char(10)    const;
  ProfileHandle       char(12);
  ErrorCode           char(16) options(*varsize:*nopass)  ;
  LengthOfPassword    int(10) options(*nopass) const;
  CCSIDOfPassword     int(10) options(*nopass) const ;
end-pr;

/COPY QSYSINC/QRPGLESRC,QUSEC

dcl-s authHeader char(512);
dcl-s authEnvPtr pointer;
dcl-s decodedValue char(512) ccsid(819);
dcl-s base64Token char(512);
dcl-s txtscan char (1) ccsid(819) inz(':');
dcl-s pos int(5);
dcl-s chkaut char(1);
dcl-s username char(10);
dcl-s password char(10);
dcl-s Profile_handle char(12) inz('');
dcl-s Length_of_password int(10);
dcl-s CCSID_of_password int(10) inz(37);
dcl-s result char(1);

dcl-proc getUserDes export;
  dcl-pi *n  ;
    emp_id      char(5) const ;
    message     char(10);
    result      char(10);
    data  likeds(response);
    error   char(100);
    httpStatus   int(10:0);
  end-pi;

  base64Token = getHeaderToken();

  if base64Token <> '';
    exec sql 
    select systools.BASE64DECODE(:base64Token)
    into :decodedValue
    from sysibm.sysdummy1;

    pos = %scan (txtscan : decodedValue);
    username = %upper(%subst(decodedValue : 1 : pos - 1 ));
    password = %upper(%trimr(%subst(decodedValue : pos + 1 : 10)));
    Length_of_password = %len(password);

    chk_usr(username: password: Profile_handle: QUSEC: Length_of_password: CCSID_of_password);

    if QUSBAVL = 0;

      exec sql 
        select j1emcd, j1nmth, j1fcti, j1dept 
        into :response.employee_id, :response.empolyee_name , :response.factory , :response.group
        from prd2dblib.lm009p
        where j1emcd = :emp_id
      ;

      if sqlcod = 0 ; 
        httpStatus = 200;
        message = 'Success';
        result = 'ok';
        data = response ; 
      else;
        httpStatus = 200;
        message = 'Success';
        result = 'Error';
        error = 'Not Found ' + %trimr(emp_id) + ' in Employee Name Master File (YM009P)' ; 
      endif ; 
    
    else;
      // Unauthorized
      httpStatus = 401; 

    endif;
  else;
    // Unauthorized
    httpStatus = 401; 
  endif;

end-proc;

dcl-proc getHeaderToken;
  dcl-pi getHeaderToken char(512) end-pi ;

  dcl-s headerToken char(512);
 
  authEnvPtr = getenv('HTTP_AUTHORIZATION');

  if authEnvPtr <> *null;
    authHeader = %str(authEnvPtr);
    if %scan('Basic ':authHeader) = 1;
      headerToken = %subst(authHeader:7);
    endif;
  endif;
  return headerToken ;

end-proc;