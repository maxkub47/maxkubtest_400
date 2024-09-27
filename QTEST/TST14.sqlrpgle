**free

ctl-opt dftactgrp(*no) option(*nodebugio : *srcstmt) copyright('MaxKuB');


dcl-s userid varchar(10);
dcl-s password varchar(200);
dcl-s url varchar(2000);
dcl-s requestBody varchar(2000);
dcl-s response varchar(5000);
dcl-s retval varchar(1000);
dcl-s options varchar(1000);

dcl-s model char(8);
dcl-s lot char(3) ;
dcl-s unit packed(3:0) ;
dcl-s stage char(10) ;
dcl-s print_flag char(1);

model           = 'TST123M0' ; 
lot             = '001';
unit            = 19;
stage           = 'MAXKUB';
print_flag      = 'Y';


exec sql 
    values json_object(
        'model' value upper(:model),
        'lot'   value upper(:lot),
        'unit'  value (:unit),
        'stage' value (:stage),
        'print_flag'  value (:print_flag)
    )
    into :requestBody;

userid = 'WOSUSR';
password = 'P@ssw0rd8E';

exec sql
    values json_object(
        'basicAuth'    value  :userid || ',' || :password,
        'header' value 'Content-Type,application/json'
    )
    into :options;

url = 'https://172.16.1.240:9100/web/services/UPDIC01';

exec sql
    values QSYS2.HTTP_POST(:url, :requestBody, :options)
    into :response;

snd-msg *INFO sqlstt;

snd-msg *INFO response;

*inlr = *on;