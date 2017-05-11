# Utilisation des API uData par R

## Création d'un dataset

Pré-requis
```R
library('httr')
library('jsonlite')
```

On récupère le résultat de la requête post dans la variable r (j'ai désactivé le proxy car on est sur une requête intranet):

```R
r <- with_config(use_proxy(url=''),POST("http://<url-racine-udata>/api/1/datasets/",
  accept_json(),
  add_headers("Content-Type" = "application/json", "X-API-KEY" = "<api-key>"),
  body = toJSON(list(
    "title" = "Dataset from R",
    "description" = "Description d'un dataset créé à partir de R"
  ))
))
```
