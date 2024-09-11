**free

ctl-opt nomain 
        pgminfo(*PCML:
                *MODULE:
                *DCLCASE) ;


dcl-f PSTRUC keyed usage(*input);

dcl-c H_OK             200 ; 
dcl-c H_CREATED        201 ;
dcl-c H_NOCONTENT      204 ;
dcl-c H_BADREQUEST     400 ;
dcl-c H_NOTFOUND       404 ;  
dcl-c H_CONFLICT       409 ;
dcl-c H_GONE           410 ;   
dcl-c H_SERVERERROR    500 ;  

dcl-ds data  likeds(PSTRUC) end-ds;

dcl-pr getDataAll  ;
  library_len  int(10:0);
  libraries     likeds(data) dim(*) options(*varsize);
  httpStatus   int(10:0);
  httpHeaders  char(100) dim(10);
end-pr;

// ------------------------------------------------------------------------------------
// Get lib All
// ------------------------------------------------------------------------------------
dcl-proc getDataAll export ;

  dcl-pi getDataAll ;
    library_len  int(10:0);
    libraries     likeds(Library) dim(1500) options(*varsize);
    httpStatus   int(10:0);
    httpHeaders  char(100) dim(10);
  end-pi;

  clear httpHeaders;
  clear libraries ; 
  library_len = 0;

  openTL000P();

  setll *loval TL000P ; 
  read(e) TL000P;

  if (%ERROR);
    httpStatus = H_SERVERERROR;
    return;
  endif;

  dow (NOT %eof);
    library_len = library_len + 1 ;
    libraries(library_len).libraryName = TL0LIB;
    libraries(library_len).libraryText = TL0DES;

    read(e) TL000P ; 
    if (%ERROR);
      httpStatus = H_SERVERERROR;
      return;
    endif;
  enddo;
    
  httpStatus = H_OK;
  httpHeaders(1) = 'Cache-Control: no-cache, no-store' ;
    
  closeTL000P();
    
end-proc;

// ------------------------------------------------------------------------------------
// Openfile
// ------------------------------------------------------------------------------------
dcl-proc openTL000P;

  dcl-pi openTL000P int(10) end-pi;

  if not %open(PSTRUC);
    open(e) PSTRUC;
    if %ERROR;
      return 0;
    endif;
  endif;

  return 1;
end-proc;

// ------------------------------------------------------------------------------------
// Close file
// ------------------------------------------------------------------------------------
dcl-proc closeTL000P;

  dcl-pi closeTL000P int(10) end-pi;

  if %open(PSTRUC);
    close(e) PSTRUC;
    if %ERROR;
      return 0;
    endif;
  endif;

  return 1;
end-proc;