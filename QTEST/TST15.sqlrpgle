**free

ctl-opt copyright('MaxKuB') DftActGrp(*no) bnddir('HTTPAPI') 
        option(*nodebugio : *srcstmt);
    
/copy libhttp/qrpglesrc,httpapi_h

// Declare the necessary variables
dcl-s url        varchar(500);
dcl-s postData   varchar(1000);
dcl-s response   varchar(2000);
dcl-s rc         int(10);

// API URL
url = 'https://172.16.1.240:9100/web/services/UPDIC01';

// Prepare POST data (the body of the request)
postData = '{ "model":"TST123M0", "lot":"001", "unit":19, "stage":"MAXKUB    ", "print_flag":"Y" }';

// Initialize the HTTPAPI
rc = http_init();
if rc <> 1;
  dsply 'Failed to initialize HTTPAPI';
  return;
endif;

// Set Basic Authentication (username and password)
rc = http_setauth(HTTP_AUTH_BASIC: 'WOSUSR': 'P@ssw0rd8E');
if rc <> 1;
  dsply 'Failed to set Basic Authentication';
  return;
endif;

// Set the Content-Type header to application/json
rc = http_xproc('POST': 'application/json');
if rc <> 1;
  dsply 'Failed to set Content-Type header';
  return;
endif;

// Perform the HTTP POST request
rc = http_url_post(url: %addr(postData): %len(postData): response: %size(response));
if rc <> 1;
  dsply 'HTTP POST failed';
  return;
endif;

// Output the response (for debugging)
dsply response;

// Clean up the HTTP session
http_end();

*inlr = *on

