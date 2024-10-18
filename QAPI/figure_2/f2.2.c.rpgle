**free

ctl-opt DFTACTGRP(*no) option(*srcstmt: *nodebugio) pgminfo(*PCML:*MODULE);

/COPY QSYSINC/QRPGLESRC,QSPRJOBQ
/COPY QSYSINC/QRPGLESRC,QUSEC

dcl-pr Fig2_2_C extpgm('FIG2_2_C');
  JobQParm      char(10) const;
  jobQLibParm   char(10) const ;
end-pr;

dcl-pi Fig2_2_C ;
  JobQParm      char(10) const;
  JobQLibParm   char(10) const ;
end-pi;

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

if (%parms > 0); 
  JobQName = JobQParm ;
endif ;

if (%parms > 1); 
  JobQName = JobQLibParm ;
endif ;

QUSBPRV = 0 ; 
RtvJobQ(QSPQ010000: %size(QSPQ010000): 'JOBQ0100': JOBQ: QUSEC);
snd-msg *info ('JobQ ' + %trim(QSPJQLN) + '/' + %trim(qspjqn)+ ' has ' + %char(QSPNBRJ));

*INLR = *on ;
return ; 