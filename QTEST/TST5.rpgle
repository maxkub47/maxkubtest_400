**free

ctl-opt DFTACTGRP(*no) option(*srcstmt: *nodebugio) pgminfo(*PCML:*MODULE);

dcl-pr QIBM_QSH_CMD extpgm('QIBM_QSH_CMD');
    cmdString char(1024) const;
    outputBuffer char(1024) options(*varsize: *nopass);
    outputSize int(10) options(*nopass);
end-pr;

dcl-ds CommandParams qualified;
    CommandLen int(10);
    Command char(256);
end-ds;

dcl-ds OutputData qualified;
    OutputLen int(10);
    Output char(256);
end-ds;

dcl-s header char(128);
    dcl-s payload char(256);
    dcl-s signature char(64);
    dcl-s jwt char(512);
    dcl-s expTime timestamp;
    dcl-s iatTime timestamp;
    dcl-s user char(10) inz('MAX');
    dcl-s key char(256) inz('ABKCESGDLSKJUODLS');
    dcl-s jwtToken char(1024);


    // Current timestamp
    iatTime = %timestamp();

    // Expiration time (24 hours from now)
    expTime = iatTime + %seconds(3600 * 24);

    // Base64 encode the header
    header = Base64Encode('{"alg":"HS256","typ":"JWT"}');

    // Create payload with username and expiration
    payload = '{"user":"' + %trim(user) + '","exp":"' + %char(expTime) + '","iat":"' + %char(iatTime) + '"}';
    payload = Base64Encode(payload);

    // Create signature using HMAC with SHA-256
    signature = HMACSHA256(header + '.' + payload: key);

    // Construct the JWT token
    jwt = %trim(header) + '.' + %trim(payload) + '.' + %trim(signature);
    
    *INLR = *on ;

    dcl-proc Base64Encode;
    dcl-pi *n char(64);
        data char(256) const;
    end-pi;

    dcl-s cmdString char(1024);
    dcl-s base64Encoded char(512);
    dcl-s qshResult char(1024);

    //cmdString = 'openssl base64 -in ' + %trim(data);

    CommandParams.CommandLen = %len(CommandParams.Command);
    CommandParams.Command = 'echo -n ' + %trim(data) + ' | openssl base64';

    callp QIBM_QSH_CMD(CommandParams);


    // Implement Base64 encoding here or use an existing utility
    return base64Encoded;
end-proc;

// Procedure to perform HMAC SHA-256 hashing
dcl-proc HMACSHA256;
    dcl-pi *n char(64);
        data char(256) const;
        key  char(256) const;
    end-pi;
    // Implement HMAC SHA-256 here or use an existing utility
    return 'HMAC_SHA256_' + %subst(data:1:32); // Placeholder
end-proc;