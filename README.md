quicknews
=========

An R package for quickly building multi-lingual web corpora via GoogleNews. The package performs two fairly straightforward functions:

-   It extracts metadata for current articles posted on GoogleNews (via RSS) based on user-specified search parameters.
-   It extracts/scrapes article content from url included in metadata.

The latter returns a data frame, which includes the metadata (for all successfully scraped texts), along with the full text for each article (represented as a single row), ie, a [TIF](https://github.com/ropensci/tif#text-interchange-formats)-compliant corpus dataframe.

The output can subsequently be annotated using `spacyr` or `cleanNLP`.

Package functionality is dependent on the `boilerpipeR`, `xml2`, and `RCurl` packages.

``` r
library(tidyverse)
library(quicknews)#devtools::install_github("jaytimm/quicknews")
```

### qnews\_get\_meta()

`qnews_get_meta` retrieves metadata based on user-specified search paramaters from the GoogleNews RSS feed. Below we search for US-based, business-related articles written in Spanish. Each call to the RSS returns 20 items.

``` r
es_us_business_meta <- quicknews::qnews_get_meta  (language="es", country="us", type="topic", search='business')
```

Additional country/language searches (that I know work) include US-English (en/us), Mexico-Spanish (es/mx), France-French (fr/fr), and Germany-German (de/de). Also, note that "es" here actually means "es-419", or Spanish spoken in Latin America.

Additional topics used in GoogleNews include Nation, World, Health, Science, Sports, Technology, and some others. When the `type` parameter is set to "term", the `search` parameter can be set to anything. When the `type` parameter is set to "topstories", the `search` parameter is ignored.

In theory, larger corpora could be constructed by applying `qnews_get_meta` across multiple topics (and over time).

Metadata include:

    ## [1] "lang"    "country" "search"  "date"    "source"  "title"   "link"

Article publication dates, sources, and titles:

``` r
es_us_business_meta%>%
  select(date:title)
```

    ##           date                  source
    ## 1  13 Mar 2018         telemundo52.com
    ## 2  14 Mar 2018      mundohispanico.com
    ## 3  14 Mar 2018            eltiempo.com
    ## 4  14 Mar 2018     eleconomista.com.mx
    ## 5  14 Mar 2018       elnuevoherald.com
    ## 6  14 Mar 2018     eleconomista.com.mx
    ## 7  14 Mar 2018       hoylosangeles.com
    ## 8  14 Mar 2018       elnuevoherald.com
    ## 9  14 Mar 2018          economiahoy.mx
    ## 10 14 Mar 2018     aeronoticias.com.pe
    ## 11 13 Mar 2018     laprensagrafica.com
    ## 12 14 Mar 2018         centrotampa.com
    ## 13 14 Mar 2018 noticieros.televisa.com
    ## 14 14 Mar 2018            latribuna.hn
    ## 15 14 Mar 2018     elfinanciero.com.mx
    ## 16 14 Mar 2018         lanacion.com.ar
    ## 17 14 Mar 2018     elfinanciero.com.mx
    ## 18 14 Mar 2018           elcomercio.pe
    ## 19 14 Mar 2018     elobservador.com.uy
    ## 20 14 Mar 2018            expansion.mx
    ##                                                                                                           title
    ## 1                                        United admite que perrito murió por encerrarlo con el equipaje de mano
    ## 2                                                Walmart ampliará su negocio de entrega de comida a 800 tiendas
    ## 3                                                             Lío en Colombia hace descolgar la acción de Cémex
    ## 4               Dow Jones pierde más de 250 puntos a media sesión por nueva preocupación a una guerra comercial
    ## 5                                            Casi 200 personas arrestadas en operativo encubierto en la Florida
    ## 6                                            Mexicanos reservan boletos de avión casi dos meses antes de viajar
    ## 7                                           El volante de 1,3 millones de vehículos de Ford se puede desprender
    ## 8                                                  Wall Street abre con alza mientras las tecnológicas repuntan
    ## 9                                         Ley Fintech abrirá las puertas del crédito a personas no bancarizadas
    ## 10                                                     El Boeing 737 obtiene nuevamente Récord Mundial Guinness
    ## 11 ¿Cómo fabricar una casa con impresora 3D en El Salvador?: 5 datos para entender esta tecnología de impresión
    ## 12                                     Un empleado público fue arrestado por producir moneda virtual en Florida
    ## 13                                           OPEP estima más suministro de petróleo por rivales pese a recortes
    ## 14                                                           Los viajeros dejan más de $714 millones en divisas
    ## 15                                                      El dólar se vende en 18.90 pesos en ventanilla bancaria
    ## 16                            Solo nueve empresas argentinas están entre las 100 que más crecieron de la región
    ## 17                                         Cofece pide eliminar monopolio de turbosina en aeropuertos mexicanos
    ## 18                                                  China fija multa récord a empresa por manipulación bursátil
    ## 19                                          Oddone: lineamientos salariales no aseguran resultados en el empleo
    ## 20                                                          Este es el plan de La Costeña por su 95 aniversario

### qnews\_scrape\_web()

The second function, `qnews_scrape_web`, scrapes text from the web addresses included in the output from `qnews_get_meta`.

``` r
es_us_business_corpus <- es_us_business_meta%>% 
  quicknews::qnews_scrape_web (link_var='link')
```

Example text from our new corpus data frame is presented below. As can be noted, not all of the articles retrieved from the RSS feed (n=20) were successfully scraped. Not all websites allow non-Google entities to scrape their sites.

``` r
paste0(substr(es_us_business_corpus$text,1,55),"...")
```

    ##  [1] "OPEP estima más suministro de petróleo por rivales pese..."
    ##  [2] "Un empleado público fue arrestado por producir moneda v..."
    ##  [3] "Micromecenazgo (Foto:Archivo) Uno de los logros de la l..."
    ##  [4] "Miami.com Los operadores bursátiles Fred DeMarco y Anth..."
    ##  [5] "Ordenar Una Copia de Este Artículo 14 de marzo de 2018 ..."
    ##  [6] "Por:Economía y Negocios 14 de marzo 2018 , 12:11 p.m. L..."
    ##  [7] "El volante de 1,3 millones de vehículos de Ford se pued..."
    ##  [8] "Los viajeros dejan más de $714 millones en divisas 14 M..."
    ##  [9] "Mundo China fija multa récord a empresa por manipulació..."
    ## [10] "MiMundo Dinero Posted 42 mins ago Apuntando al mundo di..."
    ## [11] "{[ epigrafe ]} {[ copyright ]} La baja de la inversión ..."
    ## [12] "Solo nueve empresas argentinas están entre las 100 que ..."
    ## [13] "Whatsapp realiza un cambio en su función de borrar mens..."

Again, output from `qnews_scrape_web` can be piped directly into corpus annotation functions made available in `cleanNLP` or `spacyr`.
