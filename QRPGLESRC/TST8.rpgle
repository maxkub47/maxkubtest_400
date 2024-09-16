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



// Procedure prototypes
dcl-pr tstHeader;
  http_token   char(1024);
  detail       char(64);
  httpStatus   int(10:0);
  httpHeaders  char(100) dim(10);
end-pr;

dcl-pr getHttpHeaders extpgm('QtmhGetEnv');
    pHeaderData char(64);
    pHeaderDataLength int(10:0);
    pReturnedDataLength int(10:0);
    pHeadername char(30) const;
    pHeaderNameLength int(10:0) const;
    perror likeds(apiError);
end-pr;

// Error structure for API errors
dcl-ds apiError;
    errorByteP int(10:0) inz(40);
    errorByteA int(10:0);
    errorMsgID char(7);
    errorReserved char(1);
    errorData char(40);
end-ds;


// Local variables
dcl-s headerData char(64) inz;
dcl-s headerDataLength int(10:0) inz(%size(headerData));
dcl-s returnedDataLength int(10:0) inz;

// Constants for headers
dcl-s UserAgentHeader char(30) ;
dcl-s UserAgentHeaderLen int(10);

// ------------------------------------------------------------------------------------
// tstHeader Procedure
// ------------------------------------------------------------------------------------
dcl-proc tstHeader export;

  dcl-pi tstHeader;
    detail_token   char(1024);
    detail       char(64);
    httpStatus   int(10:0);
    httpHeaders  char(100) dim(10);
  end-pi;
  
  // Sample logic to modify http_token  
  if detail_token = 'abcd';
    detail_token = 'xyz';
  endif;

  UserAgentHeader = 'HTTP_TOKEN';
  UserAgentHeaderLen = %size(UserAgentHeader);

  // Call the getHttpHeaders API
  getHttpHeaders(headerData
                      : headerDataLength
                      : returnedDataLength
                      : UserAgentHeader
                      : UserAgentHeaderLen
                      : apiError);

  // Set the output details
  detail = headerData;
  httpStatus = H_OK;
  httpHeaders(1) = 'Cache-Control: no-cache, no-store';

end-proc;
