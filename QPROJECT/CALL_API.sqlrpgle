**free
// Declare variables
dcl-s URL varchar(2048) ccsid(1208) inz('https://172.16.1.240:9100/web/services/UPDIC01');
dcl-s requestBody varchar(1024);   // Request body for JSON data
dcl-s headers varchar(1024) ccsid(1208);       // HTTP headers
dcl-s response varchar(2048);      // Response from the server
dcl-s http_status int(5);          // Status code from the HTTP request
dcl-s base64_auth varchar(256) ccsid(819); // Base64 encoded authentication
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

// Combine username and password into 'username:password'
auth_string = %trimr(username) + ':' + %trimr(password);

// Encode the 'username:password' in Base64
exec sql
    set :base64_auth = BASE64_ENCODE(:auth_string);

// Create the JSON request body
requestBody = '{"model": "TST123M0", "lot": "001", "unit": 1, "stage": "MAXKUB", "print_flg": "Y"}';

// Define the HTTP headers including Basic Authorization
// Define the HTTP headers including Basic Authorization
headers = '<httpHeader> ' +
          '<header name="authorization" value="Basic ' + %trim(base64_auth) + '" /> ' +
          '<header name="content-type" value="application/json" /> ' +
          '<header name="content-length" value="' + %char(%len(%trimr(requestBody))) + '" /> ' +
          '</httpHeader>';

// Make the HTTP POST request using QSYS2.HTTP_POST
exec sql
    set :response = SYSTOOLS.HTTPPOSTCLOB(:URL,:headers,:requestBody);


// Handle the response and status code
if http_status = 200;
  snd-msg *INFO 'Request successful. Response: ' + %trim(response);
else;
  snd-msg *INFO 'Request failed with status: ' + %char(http_status) + 
  '. Response: ' + %trim(response);
endif;

*inlr = *on;
