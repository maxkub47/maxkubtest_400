**free

///
//  Using OPTIONS(*CONVERT)
///

Ctl-Opt main(main) DftActGrp(*No) Option(*Srcstmt : *NodebugIO);

dcl-proc main;

  dcl-s UTF8field	char(20) ccsid(*utf8) inz('Hello');

  snd-msg converttoChar(%date());

  snd-msg converttoChar(%timestamp());

  snd-msg converttoChar(3.141557546); 

  snd-msg converttoChar(UTF8field);

end-proc;

dcl-proc converttoChar;
  dcl-pi *n varchar(100);
    field varchar(100) const options(*convert);
  end-pi;
  return field;
end-proc;

