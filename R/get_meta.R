#' Get article metadata from GoogleNews RSS feed.
#'
#' A simple function for acquiring current metadata for articles aggregated by GoogleNews based on user-specified search parameters, including language and country.
#' @name get_meta
#' @param language Language locale code
#' @param country Country two letter code
#' @param type Search type: topic, topstories, or term
#' @param search if type = term/topic, the term or topic to be searched.  Sets to NULL when type = topstories.
#' @return A dataframe of meta for articles collected.
#' @importFrom xml2 xml_text xml_find_all


#' @export
#' @rdname get_meta
qnews_get_meta <- function(x,
                           language='en',
                           country='us',
                           type='topstories',
                           search=NULL) {

  ned <- country
  hl2 <- ""
  base <- "https://news.google.com/news/rss/"
  q <- "search/section/q"
  section <- "headlines/section/topic/"

  if (language == 'es') {
    ned <- paste(language,country,sep="_")
    language <- 'es-419'}

  if (language == 'es-419' & country == 'us') hl2 = "&hl=US"

  hl1 <- paste0("&hl=", language)
  ned <- paste0("?ned=",ned)
  gl <- paste0("&gl=",country)

  if(type=='topstories') rss <- paste0(base,ned,hl1,gl,hl2)

  if(type=='topic') rss <- paste0(base,section,toupper(search),ned,hl1,gl,hl2)

  if(type=='term') {
    search1 <- paste("/",gsub(" ","",search),sep="")
    rss <- paste0(base,q,search1,search1,hl1,gl,ned) }

  doc <- xml2::read_xml(rss)

  title <- xml2::xml_text(xml2::xml_find_all(doc,"//item/title"))
  link <- xml2::xml_text(xml2::xml_find_all(doc,"//item/link"))
  pubDate <- xml2::xml_text(xml2::xml_find_all(doc,"//item/pubDate"))

  source <- sub('^.* - ', '', title)

  date <- gsub("^.+, ","",pubDate)
  date <- gsub(" [0-9]*:.+$","", date)

  out <- as.data.frame(cbind(date,source,title,link))

  ##These need to be scraped from the RSS, as user input may not align with actual output.
  out$lang <- language
  out$country <- country
  out$search <- ifelse(type=='topic'|type=='term',paste(type,search,sep="_"), 'topstories')

  out[,c('date','source','title','link')] <- lapply(out[,c('date','source','title','link')], as.character)

  out[, c(5:7,1:4)]
}
