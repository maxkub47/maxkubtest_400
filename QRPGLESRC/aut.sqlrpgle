**free

ctl-opt nomain
        option(*srcstmt: *nodebugio)
        pgminfo(*PCML:*MODULE);

/COPY QSYSINC/QRPGLESRC,QUSEC

dcl-pr chk_usr extpgm('QSYGETPH');
  UserID              char(10)    const;
  Password            char(10)    const;
  ProfileHandle       char(12);
  ErrorCode           char(16) options(*varsize:*nopass)  ;
  LengthOfPassword    int(10) options(*nopass) const;
  CCSIDOfPassword     int(10) options(*nopass) const ;
end-pr;

dcl-pr ValidateUser ;
  USERNAME char(10) const;
  PASSWORD char(10) const;
  result	char(10);
  errmsg   char(256);
end-pr;

dcl-proc ValidateUser export ;
  dcl-pi *n;
    USERNAME char(10) const;
    PASSWORD char(10) const;
    result	char(10);
    errmsg   char(256);
  end-pi;

  dcl-s Profile_handle char(12) inz('');
  dcl-s Length_of_password int(10);
  dcl-s CCSID_of_password int(10) inz(37);

  Length_of_password = %len(PASSWORD);

  // Call QSYGETPH to validate the username and password
  chk_usr(USERNAME: PASSWORD: Profile_handle: QUSEC: Length_of_password: CCSID_of_password);

  // Check if authentication was successful
  if QUSBAVL = 0;
    result = 'Success';
    errmsg = '';
  else;
    // Authentication failed, retrieve error message from errorCode
    result = 'Failed';
    RetrieveErrorMessage(QUSEI: errmsg);
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