**free

ctl-opt nomain
        pgminfo(*PCML:
                *MODULE:
                *DCLCASE);

// **************************************************************************
// ***    PROGRAM ID   :  PBBXXXR
// ***    PROGRAM NAME :  Get Model Lot Unit and Completed Date
// ***    REMARK       :
// ***    AUTHOR       :  K.Tanapon (MSC)    08/Oct/2024
// ***
// ***    ------------<<   MAINTENANCE   >>--------------------
// ***      DATE      PROGRAMMER         DESRIPTION
// ***
// **************************************************************************

dcl-ds response  qualified ;
  production_date char(8);
  model_code      char(8);
  lot_no          char(3);
  unit_no         char(3);
  complete_date   char(8);
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
dcl-s chkdta char(1);
dcl-s production_date char(8);
dcl-s model_code char(8);
dcl-s lot_no char(3);
dcl-s unit_no int(3);
dcl-s complete_date char(8);

dcl-proc getModelLotUnit export;
  dcl-pi *n  ;
    production_date    char(8) const ;
    message     char(10);
    result      char(10);
    data  likeds(response) dim(100);
    httpStatus   int(10:0);
  end-pi;

  Exec Sql
        Set Option commit=*none;

  base64Token = getHeaderToken();

  if base64Token <> '';
    exec sql
      select systools.BASE64DECODE(:base64Token)
      into :decodedValue
      from sysibm.sysdummy1;

    pos = %scan (txtscan : decodedValue);
    
    chkdta = 'N';

    EXEC SQL
          DECLARE c1 CURSOR FOR
            SELECT DKMODL,DKLOT,DKUNIT FROM prd1dblib.gc015p
            where DKPFAD = :production_date;
    EXEC SQL
          OPEN c1;

    EXEC SQL
          FETCH NEXT FROM c1 INTO :model_code,:lot_no,:unit_no;

    dow SQLSTATE = '00000';

      exec sql
            declare c2 cursor for
            select DOMODL, DOLOT, DOUNIT, DOAPDT
            from prd1dblib.ic001p
            where DOMODL = :model_code
            and DOLOT = :lot_no
            and DOUNIT = :unit_no
            and DOSTGC = 'COMP';
      exec sql
            open c2;

      exec sql
            fetch next from c2
            into    :response.model_code, 
                    :response.lot_no, 
                    :response.unit_no ,
                    :response.complete_date;

      dow SQLSTATE = '00000';

        chkdta = 'Y';

        exec sql
                 fetch next from c2
                 into :response.model_code, :response.lot_no ,
                      :response.unit_no, :response.complete_date;
      enddo;

      exec sql
              close c2;

      EXEC SQL
              FETCH NEXT FROM c1 INTO :model_code,:lot_no,:unit_no;
    enddo;

    EXEC SQL
          CLOSE c1;

    if chkdta = 'Y' ;
      httpStatus = 200;
      message = 'success';
      result = 'OK';
      data = response ;
    else;
      httpStatus = 200;
      message = 'success';
      result = 'NG';
    endif ;

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
