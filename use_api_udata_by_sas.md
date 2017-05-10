# Utilisation des API uData par SAS

## Création d'un dataset


```sas
filename input temp ;
filename inputh temp ;
filename output temp ;
filename outputh temp ;

data _null_;
file input ;
infile datalines4;
input;
put _infile_;
datalines4;
{
 "description": "<la description du dataset>",
 "title": "<le titre du dataset>",
}
;;;;
run ;

data _null_;
file inputh ;
infile datalines4;
input;
put _infile_;
datalines4;
X-API-KEY:<api-key>
;;;;
run ;

proc http in=input url="http://<url-racine-udata>/api/1/datasets/" out=output method="POST" HEADERIN=inputh headerout=outputh ct="application/json";
run ;
```
