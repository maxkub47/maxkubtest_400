**free


// Declare variables
dcl-s URL varchar(2048) inz('https://172.16.1.240:9100/web/services/UPDIC01');
dcl-s requestBody varchar(1024);   // Request body for JSON data
dcl-s headers varchar(1024) ;       // HTTP headers
dcl-s response varchar(2048);      // Response from the server
dcl-s http_status int(5);          // Status code from the HTTP request
dcl-s base64_auth varchar(256) ; // Base64 encoded authentication
dcl-s username varchar(100);       // Username
dcl-s password varchar(100);       // Password
dcl-s auth_string varchar(256);    // 'username:password' before encoding

// Retrieve the username and password from your DB
exec sql
    select A7DDTA, A7DDES
    into :username, :password
    from prd1dblib.C8201P
    where A7DEY1 = 'API_AUTH' and 
          A7DEY2 = 'WOS';
headers 
= '{'
+ '"basicAuth":' + '"' + username + ',' + password+ '" ,'  
+ '"header":"content-type,application/json" , '
+ '"header": "Accept,application/json,",'
+ '}';

exec sql 
   values json_object(
      'model'  value    'TST123M0',
      'lot'    value    '001',
      'unit'   value    '11' ,
      'stage'  value    'maxkub',
      'print_flag' value  'Y')
   into  :requestBody ;

// Define the HTTP headers including Basic Authorization
// Define the HTTP headers including Basic Authorization
headers
= '{'
+ '"basicAuth": "",'
+ '"header": "Accept,application/json,",'
+ '"header": "Content-Type,application/json",'
+ '}';

// Make the HTTP POST request using QSYS2.HTTP_POST
exec sql
  Select code,message FROM JSON_TABLE(QSYS2.HTTP_POST(
    :request.URL,
    :request.Body,
    :request.Header
  ),
  '$' COLUMNS(
    code int PATH 'lax $.code',
    message VARCHAR(100) PATH 'lax $.message'
  )
  );


*inlr = *on;
