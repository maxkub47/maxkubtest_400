**free

Dcl-Ds request Qualified;
  URL Varchar(64);
  Header Varchar(1024);
  Body Varchar(2048);
End-Ds;

dcl-s Response varchar(5000);

request.URL = 'https://172.16.1.240:9100/web/services/UPDIC01';

request.Header
= '{'
+ '"basicAuth": "",'
+ '"header": "Accept,application/json,",'
+ '"header": "Content-Type,application/json",'
+ '}';

exec sql 
   values json_object(
      'model'  value    'TST123M0',
      'lot'    value    '001',
      'unit'   value    '11' ,
      'stage'  value    'maxkub',
      'print_flag' value  'Y')
   into  :request.Body ;

EXEC SQL
  SET :Response = QSYS2.HTTP_POST(
  :request.URL,
  :request.Body,
  :request.Header
  );

*inlr = *on ; 