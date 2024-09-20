**free

ctl-opt option(*srcstmt: *nodebugio) 
				pgminfo(*PCML:*MODULE)  
				dftactgrp(*no) actgrp(*new) srvpgm('aut');

dcl-pr validateUser extproc('ValidateUser');
	username 			char(10) ;
  password 			char(10) ;
  result				char(10) ;
  errmsg  	 		char(256);
end-pr;

	dcl-s username 			char(10) ;
  dcl-s password 			char(10) ;
  dcl-s result				char(10) ;
  dcl-s errmsg  	 		char(256);

validateUser(username:password:result:errmsg);

*inlr = *on;