**free

dcl-ds dateInfo_T template qualified;
    dayNumber zoned(1:0) inz (1);
    dayName   char(9) inz('test');
    dateString char(40) inz('Testssss');
end-ds;

dcl-ds @dateInfo likeDS(dateInfo_T) inz(*likeds);


snd-msg  @dateInfo ;

*inlr = *on ; 