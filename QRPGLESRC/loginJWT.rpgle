**Free

// Program to handle API requests for authentication
ctl-opt nomain
        option(*srcstmt: *nodebugio)
        pgminfo(*PCML:*MODULE);

// Constants for HTTP status codes
dcl-c H_OK             200 ;
dcl-c H_CREATED        201 ;
dcl-c H_NOCONTENT      204 ;
dcl-c H_BADREQUEST     400 ;
dcl-c H_NOTFOUND       404 ;
dcl-c H_CONFLICT       409 ;
dcl-c H_GONE           410 ;
dcl-c H_SERVERERROR    500 ;

// External prototype for QSYGETPH (Validate user profile and password)
dcl-pr chk_usr extpgm('QSYGETPH');
    UserID              char(10)    const;
    Password            char(10)    const;
    ProfileHandle       char(12);
    ErrorCode           char(16) options(*varsize:*nopass)  ;
    LengthOfPassword    int(10) options(*nopass) const;
    CCSIDOfPassword     int(10) options(*nopass) const ;
end-pr;

// External prototype for QIBM_QSH_CMD (Run QShell command)
dcl-pr QIBM_QSH_CMD extpgm('QIBM_QSH_CMD');
    CmdString char(1024) const;
end-pr;

// External prototype for API validation
dcl-pr ValidateUserAPI ;
    USERNAME char(10) const;
    PASSWORD char(10) const;
    token    char(256);
    errmsg   char(256);
end-pr;

/COPY QSYSINC/QRPGLESRC,QUSEC

// Validation procedure
dcl-proc ValidateUserAPI export ;
    dcl-pi *n;
        USERNAME char(10) const;
        PASSWORD char(10) const;
        token    char(256);
        errmsg   char(256);
    end-pi;

    dcl-s Profile_handle char(12) inz('');
    dcl-s Length_of_password int(10);
    dcl-s CCSID_of_password int(10) inz(37);

    Length_of_password = %len(password);

    // Call QSYGETPH to validate the username and password
    chk_usr('MAX': PASSWORD: Profile_handle: QUSEC: Length_of_password: CCSID_of_password);

    // Check if authentication was successful
    if QUSBAVL = 0;
        // Authentication successful, generate JWT token
        token = GenerateJWT(username: %trim(GetEnv('MY_SECRET_KEY')));
        errmsg = '';
    else;
        // Authentication failed, retrieve error message from errorCode
        RetrieveErrorMessage(QUSEI: errmsg);
        //errmsg = 'User' + USERNAME + 'Pass' + PASSWORD ;
    endif;
end-proc;

// Procedure to retrieve the error message from errorCode
dcl-proc RetrieveErrorMessage;
    dcl-pi *n;
        errorCode char(32) const;
        errmsg    char(256);
    end-pi;

    // Parse the error code to create a meaningful message
    select;
        when QUSEI = 'CPF22E2';
            errmsg = 'Password not correct.';
        when QUSEI = 'CPF2204';
            errmsg = 'User profile not found.';
        when QUSEI = 'CPF22E3';
            errmsg = 'User profile disabled.';
        when QUSEI = 'CPF22E4';
            errmsg = 'Password expired.';
        other;
            errmsg = qusei + ' ' + 'Authentication failed';
    endsl;

end-proc;

// Procedure to generate a JWT token
dcl-proc GenerateJWT;
    dcl-pi *n char(256);
        user char(50) const;
        key  char(256) const;
    end-pi;

    dcl-s header char(128);
    dcl-s payload char(256);
    dcl-s signature char(64);
    dcl-s jwt char(512);
    dcl-s expTime timestamp;
    dcl-s iatTime timestamp;

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

    // Return the JWT token
    return jwt;
end-proc;

// Procedure to perform Base64 encoding
dcl-proc Base64Encode;
    dcl-pi *n char(64);
        data char(256) const;
    end-pi;
    // Implement Base64 encoding here or use an existing utility
    return 'BASE64_ENCODED_' + %subst(data:1:32); // Placeholder
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

// Procedure to get environment variable value
dcl-proc GetEnv;
    dcl-pi *n char(256);
        varname char(50) const;
    end-pi;

    dcl-s cmdString char(256);
    dcl-s varValue char(256);
    dcl-s qshResult char(256);

    cmdString = 'echo $' + %trim(varname);
    QIBM_QSH_CMD(cmdString);

    // Trim and return the result
    varValue = %trim(qshResult);

    return varValue;
end-proc;
