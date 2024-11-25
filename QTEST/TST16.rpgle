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

dcl-ds transport_t template qualified;
	queryString  varchar(1000);
	remoteAddr  varchar(1000);
	remoteUser  varchar(1000) ;
	requestMethod  varchar(1000);
	requestURI  varchar(1000);
	requewtURL  varchar(1000);
	serverName  varchar(1000) ;
	serverPort  varchar(1000) ;
end-ds;

dcl-pr tstHeader  ;
  httpHeaders  char(100) dim(10);
  httpStatus   int(10);
  transport    likeds(transport_t) options(*varsize);
end-pr;

dcl-pr getenv pointer extproc('getenv');
  varname pointer value options(*string);
end-pr;



// ------------------------------------------------------------------------------------
// Get lib All
// ------------------------------------------------------------------------------------
dcl-proc tstHeader export;

  dcl-pi tstHeader;
  httpHeaders  char(100) dim(10);
  httpStatus   int(10);
  transport    likeds(transport_t) options(*varsize);
  end-pi;
  

dcl-s getPointer	pointer;
  getPointer = getenv('QUERY_STRING');

	if getPointer <> *null ;
		transport.queryString = %str(getPointer);
	endif;

	getPointer = getenv('REMOTE_ADDR');

	if getPointer <> *null ;
		transport.remoteAddr = %str(getPointer);
	endif;

	getPointer = getenv('REMOTE_USER');

	if getPointer <> *null ;
		transport.remoteUser = %str(getPointer);
	endif;

	getPointer = getenv('REQUEST_METHOD');

	if getPointer <> *null ;
		transport.requestMethod = %str(getPointer);
	endif;

	getPointer = getenv('REQUEST_URI');

	if getPointer <> *null ;
		transport.requestURI = %str(getPointer);
	endif;

	getPointer = getenv('REQUEST_URL');

	if getPointer <> *null ;
		transport.requewtURL = %str(getPointer);
	endif;

	getPointer = getenv('SERVER_NAME');

	if getPointer <> *null ;
		transport.serverName = %str(getPointer);
	endif;

	getPointer = getenv('SERVER_PORT');

	if getPointer <> *null ;
		transport.serverPort = %str(getPointer);
	endif;

  // Return the decoded values
  httpStatus = H_OK;
  httpHeaders(1) = 'Cache-Control: no-cache, no-store';


end-proc;
