
/* Programme */

%macro statut(file) ;
%global api_code api_message ;
data _null_ ;
 infile &file termstr=CRLF length=c scanover truncover ;
 input @'HTTP/1.1' code 4. message $255. ;
 call symputx('api_code',code);
 call symput('api_message',trim(message));
run;
%mend ;

%macro cvs2datalake (datasets,filetoupload,localdirectory,titre,description) ;

filename toupload "&localdirectory.&filetoupload" ;
filename in 'C:\TEMP\in';
filename input 'C:\TEMP\input';
filename inputh 'C:\TEMP\inh';
filename output 'C:\TEMP\output';
filename outputh 'C:\TEMP\outputh';

/*Set up the form parameters*/

%let boundary=%sysfunc(uuidgen());
data _null_;
 file inputh ;
 put "X-API-KEY:&mykey" ;
run ;
data _null_;
infile toupload end=eof ;
end=eof;
file in ;

if _n_ = 1 then do;
    put "--&boundary.";
    put 'Content-Disposition: form-data; name="file"; filename="' "&filetoupload" '"';
    put 'Content-Type: text/csv';
    put  ;
end;
input;
put _infile_;
if eof then do;
    put ;
    put "--&boundary.--";
end;
run;

proc http method="POST" url="&apiserver/datasets/&datasets/upload/"
    in=in
    out=output
    HEADERIN=inputh
    headerout=outputh
    ct="multipart/form-data; boundary=&boundary.";
run;

%statut(outputh) ;
%put "Request API load :" ;
%put &api_code &api_message ;

%if (&api_code eq 201) %then %do ;

data _null_ ;
  infile output ;
  file input ;
  input ;
  mystr = _infile_ ;
  mystr =  tranwrd(mystr, '"description": null','"description": "' || &description || '"') ;
  mystr =  tranwrd(mystr, '"title": "' || "&filetoupload" || '"','"title": "' || &titre || '"') ;
  put mystr ;
run ;

data _null_ ;
 infile input termstr=CRLF length=c scanover truncover ;
 input @'"id": "' rid $36. ;
 call symput('api_rid',trim(rid));
run;

proc http in=input
     url="&apiserver./datasets/&datasets/resources/&api_rid/"
     out=output method="PUT" HEADERIN=inputh headerout=outputh ct="application/json";
run ;
%statut(outputh) ;
%put "Request API rename ressource :" ;
%put &api_code &api_message ;
%end ;

%mend ;


