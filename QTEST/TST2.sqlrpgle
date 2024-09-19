**free
ctl-opt dftactgrp(*no) ;

snd-msg *DIAG 'My diagnostic message' %TARGET(*EXT) ;

SND-MSG *INFO 'Message text goes here' %TARGET(*SELF) ;

snd-msg *NOTIFY 'My notification message' %TARGET(*EXT) ;

*inlr = *on ;

snd-msg *COMP 'Program has completed' %TARGET(*PGMBDY:1) ;