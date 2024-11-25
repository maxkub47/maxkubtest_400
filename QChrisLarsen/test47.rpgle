**free

///
//  Using %concat and %concatarr and %split
///

Ctl-Opt main(main) DftActGrp(*No) Option(*Srcstmt : *NodebugIO);

dcl-proc main;
  dcl-s array	varchar(20) dim(*auto:10);

  dcl-s string1 varchar(20) inz('one');
  dcl-s string2 varchar(20) inz('two');
  dcl-s string3 varchar(20) inz('three');
  dcl-s string4 varchar(20) inz('four');
  dcl-s string5 varchar(20) inz('five');

  dcl-s a zoned(2);

  dcl-s string varchar(100);

  // concatenation of string
  string = string1 + ',' + string2 + ',' + string3;
  snd-msg 'concat by + : ' + string;

  // %concat 
  string = %concat(',' : string1:string2:string3);
  snd-msg 'concat by %concat : ' + string;

  // Concatenation of strings in a list

  array = %list(string1:string2:string3:string4:string5);
  string = *blank;
  for a = 1 to %elem(array);
    select;
      when a = 1;
        string = array(a);
      other;
        string = %trim(string) + ',' + array(a);
    endsl;
  endfor;
  snd-msg 'concat + ' + string;

  // %concatarr 
  string = %concatarr(',' : array );
  snd-msg 'concat by %concat : ' + string;

  string = 'This**IS;;an.example-of::USING:-split*AND;;concat';

  // 1.change string to upper
  // 2.change string digit 2 to lower
  // 3.remove .-*:;  
  array = %split(%lower(%upper(string):2):'.-*:;');

  snd-msg string;

  string = %concatarr(' ' :array) ; 
  snd-msg string;

end-proc;