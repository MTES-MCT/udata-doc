options mprint symbolgen ;
/* Paramètres généraux */

%let mykey = <API KEY> ;
%let apiserver = http://<SERVER>/api/1 ;

/* Information sur le dataset concerné */
%let datasets = <DATASET> ;

/* Information sur le fichier à déposer */

%let filetoupload = <FILE> ;
%let localdirectory = <REP> ;
%let titre = "<TITLE>" ;
%let description = "<DESC>" ;
%cvs2datalake (&datasets,&filetoupload,&localdirectory,&titre,&description) ;
