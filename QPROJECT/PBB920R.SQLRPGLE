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
dcl-s URL varchar(2048) inz('https://192.168.1.141:10021/web/services/PBB920RT');
dcl-s requestBody varchar(1024);   // Request body for JSON data
dcl-s headers varchar(1024);       // HTTP headers
dcl-s http_status int(5);          // Status code from the HTTP request
dcl-s username varchar(100);       // Username
dcl-s password varchar(100);       // Password
dcl-s code int(10);
dcl-s message varchar(100);
dcl-s response_CLOB sqltype(CLOB: 500000);



// Define parameter list (PLIST) to receive parameters
dcl-pr PBB920R extpgm('PBB920R');
  p_model char(8);         // Model parameter
  p_lot char(3);           // Lot parameter
  p_unit char(3);          // Unit parameter
  p_stage char(10);         // Stage parameter
  p_printFlg char(1);        // Print flag parameter
  p_rtn_code char(1);
  p_rtn_message char(100);
end-pr;

// Parameter list
dcl-pi *n;
  p_model char(8);         // Model parameter
  p_lot char(3);           // Lot parameter
  p_unit char(3);          // Unit parameter
  p_stage char(10);         // Stage parameter
  p_printFlg char(1);        // Print flag parameter
  p_rtn_code char(1);
  p_rtn_message char(100);
end-pi;

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

requestBody = '{'
    + '"model":"' + %trim(p_model) + '",'
    + '"lot":"' + %trim(p_lot) + '",'
    + '"unit":"' + %trim(p_unit) + '",'
    + '"stage":"' + %trim(p_stage) + '",'
    + '"print_flg":"' + %trim(p_printFlg) + '"'
    + '}';

exec sql
  set :response_CLOB = QSYS2.HTTP_POST(
:URL,
:requestBody,
:headers);

exec sql
  Select code,message
  into :code, :message
  FROM JSON_TABLE(
  :response_CLOB,
  '$' COLUMNS(
  code int PATH 'lax $.code',
  message VARCHAR(100) PATH 'lax $.message')
);

p_rtn_code = %CHAR(code);
p_rtn_message = (message);


*inlr = *on;
