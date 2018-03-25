#' Scrape web articles based on metadata obtained via qnews_get_meta().
#'
#' This function scrapes news articles from web based on user specified set of web addresses.
#' @name scrape_web
#' @param link_var Variable containing web addresses.
#' @return A corpus data frame object.
#' @import data.table
#' @importFrom boilerpipeR ArticleExtractor
#' @importFrom RCurl getURL



#' @export
#' @rdname scrape_web
qnews_scrape_web <- function(y,link_var='link') {

raws <- list()
for (i in 1:nrow(y)) { #sapply() causes problems. ?
  raws[[i]] <- tryCatch(RCurl::getURL(y[i,link_var], .encoding='UTF-8', ssl.verifypeer = TRUE), error=function(e) paste("no dice"))
  }

  cleaned <- lapply(raws, function(z) {
    x <- boilerpipeR::ArticleExtractor(z)
    x <- gsub("\\\n"," ",x, perl=TRUE) #Note. Kills text structure.
    gsub("\\\"","\"",x, perl=TRUE)
      })

  names(cleaned) <- y[[link_var]]
  tif <- melt(unlist(cleaned),value.name='text') #Uses data.table
  setDT(tif, keep.rownames = TRUE)[]
  colnames(tif)[1] <- 'link'
  tif <- merge(y,tif,by.x=c(link_var),by.y=c('link'))
  tif$text <- as.character(tif$text)
  tif$text <- enc2utf8(tif$text)

  tif <- tif[nchar(tif$text)>500,]
  tif <- tif[complete.cases(tif),]
  tif$date <- as.Date(tif$date, "%d %b %Y")
  tif <- subset(tif,source != 'wsj.com')

  return(tif)
}
