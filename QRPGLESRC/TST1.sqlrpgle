**Free

ctl-opt option(*nodebugio:*srcstmt) dftactgrp(*no) Copyright('MaxKuB') ;

/// Test LPRINTF and DSPLY

dcl-s a char(50);

a = 'Test' ; 

dsply 'testdsply';

exec sql 
    CALL SYSTOOLS.LPRINTF('testprint') ;

*INLR = *on ;
