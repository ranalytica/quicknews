quicknews: r package for quick/multi-lingual web-based corpus creation
======================================================================

facilitates quick/easy web scraping of news sources, as a dataframe in text interchange format...

The two web-based functions presented here more or less work in tandem. Both functions depend on functionality made available in the `boilerpipeR`, `XML`, and `RCurl` packages.

``` r
library(tidyverse)
library(quicknews)#devtools::install_github("jaytimm/quicknews")
library(DT)
```

### qnews\_get\_meta()

`qnews_get_meta` simply pulls metadata based on user-specified search paramaters from the GoogleNews RSS feed. Here, we search for US-based business-related articles written in Spanish.

``` r
es_us_business_meta <- quicknews::qnews_get_meta  (language="es", country="us", type="topic", search='business')
```

Metadata include:

    ## [1] "lang"    "country" "search"  "date"    "source"  "title"   "link"

First six article titles:

``` r
es_us_business_meta%>%
  select(date:title)
```

    ##           date                  source
    ## 1  13 Mar 2018        elespectador.com
    ## 2  12 Mar 2018                cnet.com
    ## 3  13 Mar 2018      eluniversal.com.mx
    ## 4  13 Mar 2018      imparcialoaxaca.mx
    ## 5  13 Mar 2018     elfinanciero.com.mx
    ## 6  13 Mar 2018         contactonews.co
    ## 7  13 Mar 2018            expansion.mx
    ## 8  13 Mar 2018          eluniverso.com
    ## 9  13 Mar 2018            colombia.com
    ## 10 13 Mar 2018 noticieros.televisa.com
    ## 11 13 Mar 2018           estrategia.cl
    ## 12 13 Mar 2018     semanaeconomica.com
    ## 13 13 Mar 2018       diariobitcoin.com
    ## 14 13 Mar 2018          coincrispy.com
    ## 15 13 Mar 2018 noticieros.televisa.com
    ## 16 13 Mar 2018           portafolio.co
    ## 17 13 Mar 2018              gestion.pe
    ## 18 13 Mar 2018    diariojornada.com.ar
    ## 19 13 Mar 2018             lanacion.cl
    ## 20 13 Mar 2018        tecnologia.press
    ##                                                                                                   title
    ## 1             Broadcom, el nuevo episodio en la guerra de Trump contra la influencia económica de China
    ## 2                                         Una impresora 3D ayudará a construir 100 casas en El Salvador
    ## 3                                                 La Costeña prevé reinvertir 20% de sus ventas en 2018
    ## 4                                                        Empleo para ingenieros mexicanos en Nueva York
    ## 5                                               Bolsa mexicana borra ganancias en línea con Wall Street
    ## 6                                                                   NCL anuncia nueva terminal en Miami
    ## 7                          El cofundador de Google, Larry Page, prueba taxis voladores en Nueva Zelanda
    ## 8                                               Ecuador lanza licitación para áreas petroleras y de gas
    ## 9                                          Jeff Bezos gana premio de exploración, come carne de lagarto
    ## 10                                                              Bolsa de Nueva York sube en la apertura
    ## 11                                                              Dólar retrocede $1,5 y cierra en $602,5
    ## 12                                      PDAC 2018: el Perú sigue siendo la 'estrella' de América Latina
    ## 13                          Ministerio de Tecnología de China creará estándares oficiales de Blockchain
    ## 14 Directora del FMI sugiere utilizar la tecnología Blockchain para frenar el auge de las criptomonedas
    ## 15                                  Precios del petróleo caen por la producción de crudo estadounidense
    ## 16                 Las generadoras hidráulicas también pujarían en subasta para las energías renovables
    ## 17                   CCL: Exportaciones peruanas alcanzarán este año cifra récord de US$ 48000 millones
    ## 18                                         Telegram busca 2.250 millones de dólares con su criptomoneda
    ## 19                                    Banco Central de Venezuela pagó deuda millonaria a su par chileno
    ## 20                      (Video) Japón llamará a acción del G20 sobre lavado de dinero con criptomonedas

### qnews\_scrape\_web()

The second web-based function, `qnews_scrape_web`, scrapes text from the web addresses included in the output from `qnews_get_meta`. The function returns a [TIF](https://github.com/ropensci/tif#text-interchange-formats)-compliant dataframe, with each scraped text represented as a single row. Metadata from output of `qnews_get_meta` are also included.

``` r
es_us_business_corpus <- es_us_business_meta%>% 
  quicknews::qnews_scrape_web (link_var='link')
```
