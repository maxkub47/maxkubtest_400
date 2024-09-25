**free

ctl-opt nomain 
        pgminfo(*PCML:
                *MODULE:
                *DCLCASE);

// Set SQL options                                    
exec sql  
    set option commit=*none,datfmt=*iso, closqlcsr=*ENDMOD;

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
dcl-s #MDL char(8);
dcl-s #LOT char(3);
dcl-s #UNT packed(3:0);
dcl-s #STAGE char(10);
dcl-s #PRINT char(1);

dcl-proc upDate_ic001 export;
  dcl-pi *n  ;
    model      char(8) const ;
    lot        char(3) const ;
    unit       packed (3:0) const ;
    stage      char(10) const;
    print_flg  char(1) const;
    code       int(10);
    message    char(100);
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
    #MDL = model;
    #LOT = lot;
    #UNT = unit;
    #STAGE = stage;
    #PRINT = print_flg;

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
        insert into prd1dblib.ic001p
        values(
          0,                        // DOLUPD (auto-generated or current date)
          'MAXTESTAPI',              // DOLUPU (update user)
          'SR',                      // DOFCTI (factory ID)
          :model,                    // DOMODL (model)
          :lot,                      // DOLOT (lot no)
          ' ',                       // DOMDVI (model dev version)
          :unit,                     // DOUNIT (unit)
          :stage,                    // DOSTGC (stage code)
          0,                         // DOAPDT (actual prod date)
          0,                         // DOAPTM (actual prod time)
          :print_flg,                // DOAPSF (actual prod shift)
          'MA',                      // DOLNCD (line code)
          0,                         // DOPLDT (planned prod date)
          0,                         // DOPPTM (planned prod time)
          0,                         // DOPPSQ (planned prod seq)
          ' ',                       // DOPPSF (planned prod shift)
          0,                         // DODEXD (VAT data extract)
          0,                         // DOSTDT (stock date)
          0,                         // DOREDT (real date)
          0                          // DOSTCK (stock status flag)
        );



      if sqlcod = 0 ; 
        httpStatus = 200;
        code = 1;
        message = 'OK';

      else;
        httpStatus = 200;
        message = 'Error';
        code = 1;
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