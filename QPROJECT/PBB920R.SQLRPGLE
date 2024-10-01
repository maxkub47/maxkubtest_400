**free

// **************************************************************************
// ***    PROGRAM ID   :  PBB920R
// ***    PROGRAM NAME :
// ***    REMARK       :
// ***    AUTHOR       :  L.Rattapon (MSC)    27/Sep/2024
// ***
// ***    ------------<<   MAINTENANCE   >>--------------------
// ***      DATE      PROGRAMMER         DESRIPTION
// ***
// **************************************************************************

// Declare variables
dcl-c Q         x'7d'   ;

dcl-s URL varchar(2048) inz('https://192.168.1.141:10021/web/services/PBB920RT');
dcl-s requestBody varchar(1024);   // Request body for JSON data
dcl-s headers varchar(1024);       // HTTP headers
dcl-s http_status int(5);          // Status code from the HTTP request
dcl-s username varchar(100);       // Username
dcl-s password varchar(100);       // Password
dcl-s code int(10);
dcl-s message varchar(100);
dcl-s response varchar(5000);
dcl-s sql varchar(1000);

Exec Sql
    Set Option commit=*none;

exec sql
    select A7DDTA, A7DDES
    into :username, :password
    from prd1dblib.C8201P
    where A7DEY1 = 'API_AUTH' and
          A7DEY2 = 'WOS';

headers
= '{'
+ '"basicAuth":' + '"' + %trimr(username) + ',' + %trimr(password) + '" ,'
+ '"header":"Content-Type,application/json"'
+ '}';

requestBody
= '{'
+ '"model":"TST123M0",'
+ '"lot":"001",'
+ '"unit":"35",'
+ '"stage":"MAXKUBTEST",'
+ '"print_flg":"Y" }';

sql = 'Select * FROM JSON_TABLE('
+ 'QSYS2.HTTP_POST(:URL,:requestBody,:headers),'
+ Q + '$' + Q + 'COLUMNS('
+ 'code int PATH ' + Q + '$.code' + Q
+ ', message VARCHAR(100) PATH ' + Q + '$.message' + Q + '))';

Exec Sql
  DECLARE C1 CURSOR FOR DYNSQLSTM ;

Exec Sql
  PREPARE DYNSQLSTM FROM :sql  ;

Exec Sql
  Open C1;

Exec Sql
  Fetch C1 into :code, :message ;

Exec Sql
  Close C1;

snd-msg *INFO headers;
snd-msg *INFO requestBody;
snd-msg *INFO sqlstt;
snd-msg *INFO response;


*inlr = *on;
