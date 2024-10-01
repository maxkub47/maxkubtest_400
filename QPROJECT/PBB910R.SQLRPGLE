**free

ctl-opt nomain
        pgminfo(*PCML:
                *MODULE:
                *DCLCASE);

// **************************************************************************
// ***    PROGRAM ID   :  PBB910R
// ***    PROGRAM NAME :  Get Incharge Description
// ***    REMARK       :
// ***    AUTHOR       :  L.Rattapon (MSC)    27/Sep/2024
// ***
// ***    ------------<<   MAINTENANCE   >>--------------------
// ***      DATE      PROGRAMMER         DESRIPTION
// ***
// **************************************************************************

dcl-ds response  qualified ;
  employee_id     char(5);
  empolyee_name   char(30) ccsid(838);
  factory         char(2);
  group           char(3);
end-ds ;

dcl-pr getenv pointer extproc('getenv');
  varname pointer value options(*string);
end-pr;

dcl-s authHeader char(512);
dcl-s authEnvPtr pointer;
dcl-s decodedValue char(512) ccsid(819);
dcl-s base64Token char(512);
dcl-s txtscan char (1) ccsid(819) inz(':');
dcl-s pos int(5);
dcl-s chkaut char(1);
dcl-s username char(10);
dcl-s password char(10);

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
    username = %subst(decodedValue : 1 : pos - 1 );
    password = %trimr(%subst(decodedValue : pos + 1 : 10));

    chkaut = 'N';

    exec sql
      select 'Y'
      into :chkaut
      from prd1dblib.c8201p
      where A7DEY1 = 'API_AUTH' and
            A7DEY2 = 'WOS' and
            A7DDTA = :username and
            A7DDES = :password ;


    if chkaut = 'Y';

      exec sql
        select j1emcd, j1nmth, j1fcti, j1dept
        into :response.employee_id, :response.empolyee_name , :response.factory , :response.group
        from prd2dblib.lm009p
        where j1emcd = :emp_id
      ;

      if sqlcod = 0 ;
        httpStatus = 200;
        message = 'Success';
        result = 'OK';
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
