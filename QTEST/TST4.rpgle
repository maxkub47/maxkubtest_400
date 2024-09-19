**free

ctl-opt option(*srcstmt: *nodebugio) pgminfo(*PCML:*MODULE);

dcl-pr chk_usr extpgm('QSYGETPH');
    UserID              char(10)    const;
    Password            char(10)    const;
    ProfileHandle       char(12);
    ErrorCode           char(16) options(*varsize:*nopass)  ;
    LengthOfPassword    int(10) options(*nopass) const;
    CCSIDOfPassword     int(10) options(*nopass) const ;
end-pr;

/COPY QSYSINC/QRPGLESRC,QUSEC

dcl-s User_ID char(10) inz('MAX');
dcl-s Password char(10) inz('MAXK');
dcl-s Profile_handle char(12) inz('');
dcl-s Length_of_password int(10);
dcl-s CCSID_of_password int(10) inz(37);




Length_of_password = %len(Password);

chk_usr(User_ID: Password: Profile_handle: qusec: Length_of_password: CCSID_of_password);

*inlr = *on;