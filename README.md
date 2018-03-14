quicknews
=========

r package for quickly building multi-lingual web corpora via GoogleNews
-----------------------------------------------------------------------

This package performs two fairly straightforward functions:

-   It extracts metadata for current articles posted on GoogleNews (via RSS) based on user-specified search parameters.
-   It extracts/scrapes article content from url included in metadata.

The latter returns a data frame, which includes the metadata (for all successfully scraped texts), along with the full text for each article (represented as a single row), ie, a [TIF](https://github.com/ropensci/tif#text-interchange-formats)-compliant corpus dataframe.

This data structure subsequently enables convenient corpus annotation via `spacyr` or `cleanNLP`.

Package functionality is dependent on the `boilerpipeR`, `xml2`, and `RCurl` packages.

``` r
library(tidyverse)
library(quicknews)#devtools::install_github("jaytimm/quicknews")
```

### qnews\_get\_meta()

`qnews_get_meta` retrieves metadata based on user-specified search paramaters from the GoogleNews RSS feed. Below we search for US-based, business-related articles written in Spanish.

``` r
es_us_business_meta <- quicknews::qnews_get_meta  (language="es", country="us", type="topic", search='business')
```

Additional country/language searches (that I know work) include US-English (en/us), Mexico-Spanish (es/mx), France-French (fr/fr), and Germany-German (de/de). Also, note that "es" here actually means "es-419", or Spanish spoken in Latin America.

Additional topics used in GoogleNews include Nation, World, Health, Science, Sports, Technology, and some others. When the `type` parameter is set to "term", the `search` parameter can be set to anything. When the `type` parameter is set to "topstories", the `search` parameter is ignored.

Metadata include:

    ## [1] "lang"    "country" "search"  "date"    "source"  "title"   "link"

Article publication dates, sources, and titles:

``` r
es_us_business_meta%>%
  select(date:title)
```

    ##           date              source
    ## 1  14 Mar 2018        expansion.mx
    ## 2  14 Mar 2018 eleconomista.com.mx
    ## 3  14 Mar 2018   elnuevoherald.com
    ## 4  14 Mar 2018   hoylosangeles.com
    ## 5  14 Mar 2018   elnuevoherald.com
    ## 6  14 Mar 2018        expansion.mx
    ## 7  14 Mar 2018 aeronoticias.com.pe
    ## 8  13 Mar 2018 laprensagrafica.com
    ## 9  14 Mar 2018        latribuna.hn
    ## 10 14 Mar 2018      economiahoy.mx
    ## 11 14 Mar 2018     lanacion.com.ar
    ## 12 14 Mar 2018       elcomercio.pe
    ## 13 14 Mar 2018 elobservador.com.uy
    ## 14 14 Mar 2018        expansion.mx
    ## 15 14 Mar 2018         netmedia.mx
    ## 16 14 Mar 2018         tvlatina.tv
    ## 17 14 Mar 2018   diariobitcoin.com
    ## 18 14 Mar 2018     lanacion.com.ar
    ## 19 14 Mar 2018   diariobitcoin.com
    ## 20 13 Mar 2018          gestion.pe
    ##                                                                                                           title
    ## 1                                                                    La caída de Cemex pega a la Bolsa mexicana
    ## 2               Dow Jones pierde más de 250 puntos a media sesión por nueva preocupación a una guerra comercial
    ## 3                                            Casi 200 personas arrestadas en operativo encubierto en la Florida
    ## 4                                           El volante de 1,3 millones de vehículos de Ford se puede desprender
    ## 5                                                  Wall Street abre con alza mientras las tecnológicas repuntan
    ## 6                                                                         El dólar sube a 18.90 pesos en bancos
    ## 7                                                      El Boeing 737 obtiene nuevamente Récord Mundial Guinness
    ## 8  ¿Cómo fabricar una casa con impresora 3D en El Salvador?: 5 datos para entender esta tecnología de impresión
    ## 9                                                            Los viajeros dejan más de $714 millones en divisas
    ## 10                                        Ley Fintech abrirá las puertas del crédito a personas no bancarizadas
    ## 11                            Solo nueve empresas argentinas están entre las 100 que más crecieron de la región
    ## 12                                                  China fija multa récord a empresa por manipulación bursátil
    ## 13                                          Oddone: lineamientos salariales no aseguran resultados en el empleo
    ## 14                                                          Este es el plan de La Costeña por su 95 aniversario
    ## 15                                    Venta de divisas digitales se enfrenta a un camino difícil y más regulado
    ## 16                                          Jesús de la Vega asume como director general de ventas de TV Azteca
    ## 17                           Coinbase recibe licencia para operaciones con dinero electrónico en el Reino Unido
    ## 18                                       Francia demandará a Google ya Apple por prácticas comerciales abusivas
    ## 19                                      Playboy TV aceptará pagos con monedas digitales por contenido exclusivo
    ## 20                       LatinFocus: Analistas mantienen proyección de crecimiento del Perú para el 2018 y 2019

### qnews\_scrape\_web()

The second function, `qnews_scrape_web`, scrapes text from the web addresses included in the output from `qnews_get_meta`.

``` r
es_us_business_corpus <- es_us_business_meta%>% 
  quicknews::qnews_scrape_web (link_var='link')
```

So, not all of the articles retrieved from the RSS feed were successfully scraped. Not all websites allow non-Google entities to scrape their sites.

``` r
nrow(es_us_business_corpus)
```

    ## [1] 15

Example text from the corpus data frame:

``` r
substr(es_us_business_corpus$text[1],1,500)
```

    ## [1] "Home / Lo más destacado / Jesús de la Vega asume como director general de ventas de TV Azteca Jesús de la Vega asume como director general de ventas de TV Azteca Elizabeth Bowen-Tombari Hace 2 horas Lo más destacado ANUNCIO Benjamín Salinas, CEO de TV Azteca, informó sobre la designación de Jesús de la Vega como nuevo director general de ventas de la compañía. La compañía destaca sus niveles de venta que se incrementaron en 11 por ciento durante 2017, gracias a la nueva oferta televisiva y el eq"

Again, output from `qnews_scrape_web` can be piped directly into corpus annotation functions made available in `cleanNLP` or `spacyr`.
