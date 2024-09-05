**free

ctl-opt DFTACTGRP(*no) option(*srcstmt: *nodebugio) pgminfo(*PCML:*MODULE);

/COPY QSYSINC/QRPGLESRC,QSPRJOBQ
/COPY QSYSINC/QRPGLESRC,QUSEC

dcl-pr RtvJobQ extpgm('QSPRJOBQ') ; 
	Receiver			char(1)		options(*varsize);
	LengthRcv			int(10)		const;
	Format				char(8)		const;
	JOBQ				char(20)	const;
	QUSEC				likeds(QUSEC);
end-pr;

dcl-ds JOBQ ;
	JobQName			char(10)	inz('QBATCH');
	JobQLib				char(10)	inz('*LIBL');
end-ds ; 

QUSBPRV = 0 ; 
RtvJobQ(QSPQ010000: %size(QSPQ010000): 'JOBQ0100': JOBQ: QUSEC);

*INLR = *on ;
return ; 