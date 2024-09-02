**free
// Program to handle API requests for authentication
ctl-opt option(*srcstmt: *nodebugio)
        pgminfo(*PCML:*MODULE)
        bnddir('MAXTOOL');

dcl-pr ValidateUserAPI extpgm('LOGINJWT');
    username char(10) const;
    password char(10) const;
    token    char(256);
    errmsg   char(256);
end-pr;

dcl-s username char(10) inz('MAXUSER   '); 
dcl-s password char(10) inz('MAXPASS   '); 
dcl-s token    char(256);
dcl-s errmsg   char(256);

// เรียกใช้ ValidateUserAPI ด้วยค่าที่ถูกต้อง
ValidateUserAPI(username: password: token: errmsg);

// ตรวจสอบและพิมพ์ผลลัพธ์
if %trim(errmsg) <> '';
    // แสดงข้อความผิดพลาด
    SND-MSG *INFO errmsg %TARGET(*SELF) ;
else;
    // แสดง token ที่ได้รับ
    SND-MSG *INFO token %TARGET(*SELF) ;

endif;

*INLR = *ON; 