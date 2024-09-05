**free
// Define program and module
ctl-opt dftactgrp(*no) actgrp(*new) option(*srcstmt:*nodebugio);

// Declare the QCMDEXC procedure
dcl-pr QCMDEXC extpgm('QCMDEXC');
  commandString char(32702) const options(*varsize);
  commandLength packed(15:5) const;
end-pr;

// Declare the QHFOPNSF procedure
dcl-pr QHFOPNSF extpgm('QHFOPNSF');
  fileHandle int(10);
  pathName char(1000) const;
  pathNameLength int(10) const;
  openInfo char(10) const;
  attrInfoTable char(100) const;
  attrInfoTableLength int(10) const;
  actionTaken char(1);
  errorCode char(1000) const;
end-pr;

// Declare the QHFRDSF procedure
dcl-pr QHFRDSF extpgm('QHFRDSF');
  fileHandle int(10);
  data char(1024);
  dataLength int(10) const;
  bytesRead int(10);
  errorCode char(8);
end-pr;

// Declare the QHFCLOSF procedure
dcl-pr QHFCLOSF extpgm('QHFCLOSF');
  operation char(5) const;
  fileSystemJobHandle char(16) const;
  openFileHandle char(16) const;
  errorCode char(3778) const;
end-pr;

// Main procedure
dcl-s command varchar(256) inz('QSH CMD(''/QOpenSys/usr/bin/sh -c "ls > /tmp/ls_output.txt"'')');
dcl-s cmdLength packed(15:5);
dcl-s fileName varchar(256) inz('/tmp/ls_output.txt');
dcl-s fileContent char(1024) inz('');
dcl-s fileHandle int(10);
dcl-s bytesRead int(10);
dcl-s errorCode char(8) inz(x'0000000000000000');
dcl-s actionTaken Char(1);

cmdLength = %len(%trimr(command));

// Run Qshell command using QCMDEXC API
QCMDEXC(command : cmdLength);

// Open the file for reading using QHFOPNSF API
fileHandle = -1;


QHFOPNSF(fileHandle : fileName : %len(fileName) : 'R' : '' : 0 : actionTaken : errorCode);

// Check if the file was opened successfully
if fileHandle < 0;
  dsply 'Error opening file';
  *inlr = *on;
  return;
endif;

// Read the contents of the file using QHFRDSF API
QHFRDSF(fileHandle : fileContent : %size(fileContent) : bytesRead : errorCode);

// Check if the file was read successfully
if bytesRead <= 0;
  dsply 'Error reading file';
  *inlr = *on;
  return;
endif;

// Close the file using QHFCLOSF API
QHFCLOSF('CLOSE' : '' : %char(fileHandle) : errorCode);

// Check if the file was closed successfully
if %subst(errorCode:1:1) <> x'00';
  dsply 'Error closing file';
endif;

*INLR = *on;