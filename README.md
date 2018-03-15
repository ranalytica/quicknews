quicknews
=========

An R package for quickly building multi-lingual web corpora via GoogleNews. The package performs two fairly straightforward functions:
\* It extracts metadata for current articles posted on GoogleNews (via RSS) based on user-specified search parameters. \* It scrapes article content from url obtained from the RSS.

Final output is a [TIF](https://github.com/ropensci/tif#text-interchange-formats)-compliant corpus dataframe, which includes article metadata and the full text for each article (represented as a single row). Output can subsequently be annotated using `spacyr` or `cleanNLP`.

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

    ##           date                    source
    ## 1  15 Mar 2018   estrategiaynegocios.net
    ## 2  15 Mar 2018                   bbc.com
    ## 3  15 Mar 2018                     df.cl
    ## 4  15 Mar 2018       americaeconomia.com
    ## 5  14 Mar 2018                  cnet.com
    ## 6  15 Mar 2018              eltiempo.com
    ## 7  15 Mar 2018            economiahoy.mx
    ## 8  15 Mar 2018         es.dailyforex.com
    ## 9  15 Mar 2018          elespectador.com
    ## 10 15 Mar 2018            economiahoy.mx
    ## 11 15 Mar 2018             forbes.com.mx
    ## 12 15 Mar 2018      cincodias.elpais.com
    ## 13 15 Mar 2018      economiaynegocios.cl
    ## 14 15 Mar 2018          prensa-latina.cu
    ## 15 15 Mar 2018            larepublica.co
    ## 16 15 Mar 2018            coincrispy.com
    ## 17 15 Mar 2018         diariobitcoin.com
    ## 18 15 Mar 2018            todotvnews.com
    ## 19 15 Mar 2018 telemundowashingtondc.com
    ## 20 15 Mar 2018          tecnologia.press
    ##                                                                                              title
    ## 1                                     Cierre de Toys R Us: duro impacto a la industria del juguete
    ## 2  El "preocupante" hallazgo de partículas de plástico en botellas de agua de 11 marcas diferentes
    ## 3      Singapur es la ciudad más cara para vivir y Santiago de las que más suben en ranking global
    ## 4                           Precios de importaciones de EE.UU. suben más de lo esperado en febrero
    ## 5                              La fundadora de la 'startup' de salud Theranos es acusada de fraude
    ## 6                                 Analistas temen que el caso de Qualcomm impacte a Silicon Valley
    ## 7                                Se filtran las audiencias de Amazon Prime Video en Estados Unidos
    ## 8                        Votaciones del Senado de EE.UU. Para facilitar las regulaciones bancarias
    ## 9                                       Caída de producción de crudo en Venezuela causaría déficit
    ## 10     ¿Tienen los Tesla problemas de calidad? El 40% de sus piezas originales necesita reparación
    ## 11                                    El blockchain podría colaborar en el combate a la corrupción
    ## 12  Audi se recupera del 'dieselgate' y eleva su beneficio neto un 68,4%, hasta los 3.479 millones
    ## 13         Zurich negocia compra de EuroAmerica y alcanzaría el segundo lugar en rentas vitalicias
    ## 14                                                Alemania preocupada por posible guerra comercial
    ## 15            Dólar cae frente al yen por imposición de aranceles y tensiones comerciales globales
    ## 16     Nuevos criptoactivos respaldados por el petróleo buscan su comercio legal en Estados Unidos
    ## 17  Miembro del Departamento de Cítricos de Florida fue arrestado por efectuar minería clandestina
    ## 18                                           Crackle suma nuevas regiones en LatAm con Claro Video
    ## 19                                  Walmart amplía servicios de entrega de comestibles a domicilio
    ## 20                                  La plataforma de votación Blockchain de Moscú agrega servicios

### qnews\_scrape\_web()

The second function, `qnews_scrape_web`, scrapes text from the web addresses included in the output from `qnews_get_meta`. Ads and and sidebar content have (mostly) been removed using `boilerpipeR`'s ArticleExtractor().

``` r
es_us_business_corpus <- es_us_business_meta%>% 
  quicknews::qnews_scrape_web (link_var='link')
```

Example text from our new corpus data frame is presented below. As can be noted, not all of the articles retrieved from the RSS feed (n=20) were successfully scraped -- not all websites allow non-Google entities to scrape their sites.

``` r
paste0(substr(es_us_business_corpus$text,1,55),"...")
```

    ##  [1] "El \"preocupante\" hallazgo de partículas de plástico en ..."
    ##  [2] " -4,200$ 16:25:03 Los mejores programas de televisión d..."  
    ##  [3] "+0,20% +0,65 Tesla continúa inmersa en su particular ba..."  
    ##  [4] "UF: 26.966,89 IPC: 0,00% En intensas tratativas están l..."  
    ##  [5] "Por:REDACCIÓN TECNÓSFERA* 15 de marzo 2018 , 09:52 a.m...."  
    ##  [6] "Fecha de publicación: 2018-03-15 Cierre de Toys R Us: d..."  
    ##  [7] "Alemania preocupada por posible guerra comercial Aleman..."  
    ##  [8] "Crackle suma nuevas regiones en LatAm con Claro Video T..."  
    ##  [9] "Audi se recupera del 'dieselgate' y eleva su beneficio ..."  
    ## [10] "Estados Unidos Precios de importaciones de EE.UU. suben..."  
    ## [11] "Industria de la tecnología La fundadora de la 'startup'..."  
    ## [12] "15 Mar 2018 - 8:17 AM Bloomberg. Así lo indicó la Agenc..."  
    ## [13] "marzo 15, 2018 @ 6:40 am 2018-03-15T06:40:34-0600 2018-..."  
    ## [14] "Jueves, 15 de marzo de 2018 Se espera que la moneda jap..."  
    ## [15] "Inicio / Noticias / La plataforma de votación Blockchai..."

Again, output from `qnews_scrape_web` can be piped directly into corpus annotation functions made available in `cleanNLP` or `spacyr`.
