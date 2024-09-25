**free

ctl-opt option(*srcstmt: *nodebugio) bnddir('MAXTOOL');

dcl-pr decode extproc('AAA');
    input1			char(1024) ; 
    output1         char(1024) CCSID(819); 
end-pr;

dcl-pr encode extproc('BBB');
    input2			char(1024) CCSID(819) ; 
    output2         char(1024) ; 
end-pr;

dcl-s input1 char(1024) ;
dcl-s output1 char(1024) CCSID(819);
dcl-s input2 char(1024)CCSID(819);
dcl-s output2 char(1024);

input2 = 'BASIC max:maxkub';

encode(input2:output2);

snd-msg *INFO %trimR(output2);

decode(output2:output1);

snd-msg *INFO output1;

*inlr = *on;