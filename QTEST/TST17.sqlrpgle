**free
dcl-s Company char(20) ;
Dcl-s Company_branch like(Company) ;

dcl-c COURSENAME const('API AS400');

dcl-ds Address Qualified ;
  street char(30) ;
  *n char(25);
  zipCode char(9);
  zip zoned(5) overlay(zipCode);
  zipplus zoned(4) overlay(zipCode:5);
end-ds ;

snd-msg COURSENAME ;

Address.street = 'Home';
Address.zipCode = '123456789' ;

snd-msg Address.zipCode ;
dsply Address.zip ;
dsply Address.zipplus ;

*inLR = *ON ;