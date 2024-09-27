**free

ctl-opt dftactgrp(*no) option(*nodebugio : *srcstmt) copyright('MaxKuB');


// Declare a variable to hold the response data
dcl-s responseData varchar(5000);
dcl-s URL varchar(1024) inz('https://172.16.1.240:9100/web/services/UPDIC01');
dcl-s requestBody varchar(1024);
dcl-s headers varchar(1024); 
dcl-s username varchar(100) inz('WOSUSR');
dcl-s password varchar(100) inz('P@ssw0rd8E');
dcl-s retval varchar(1000);

// headers = '{"headers":{"basicAuth":"WOSUSR:P@ssw0rd8E","Content-Type":"application/json"}}';

headers 
= '{'
+ '"basicAuth":' + '"' + username + ',' + password+ '" ,'  
+ '"header":"content-type,application/json" , '
+ '"header": "Accept,application/json,",'
+ '}';

requestBody = '{"model": "TST123M0", "lot": "001", "unit": 4, "stage": "MAXKUB", "print_flg": "Y"}';

// exec sql 
//   set :responseData = qsys2.http_post(:URL,:requestBody,:headers);

exec sql
   values QSYS2.HTTP_POST(:URL, 
   cast(:requestBody as clob(10M)),
   cast(:headers as clob(3k)) )
   into :responseData ; 

if %subst(sqlstt:1:2) <> '00' and %subst(sqlstt:1:2) <> '01';
  retval = '**ERROR IN HTTP_POST: SQLSTT=' + sqlstt;
endif;

snd-msg *INFO sqlstt;
snd-msg *INFO retval;

// End of program
*inlr = *on;