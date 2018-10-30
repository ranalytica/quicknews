

library(corpuslingr)
library(quicknews)#devtools::install_github("jaytimm/quicknews")
library(udpipe)
library(tidyverse)

#Local function:
build_update_corpus <- function(existing_urls=NULL) {
  lapply(topics, function (x) {
  quicknews::qnews_get_meta (language="en",
                             country="us",
                             type="topic",
                             search=x) %>%
    filter(!link %in% existing_urls) %>%
    quicknews::qnews_scrape_web() }) %>%
    bind_rows() %>%
    mutate(doc_id = row_number() + length(existing_urls))
}

setwd("C:\\Users\\jason\\Google Drive\\GitHub\\packages\\quicknews\\data-raw")
tif_existing <- readRDS('qnews_eg_tif.rds')
ann_existing <- readRDS('qnews_eg_corpus.rds')

#Set search params
topics <- c('nation', 'world', 'health',
            'science', 'business', 'technology',
            'entertainment')

#Initialize cleanNLP
cleanNLP::cnlp_init_udpipe(model_name="english",
                           feature_flag = FALSE,
                           parser = "none")

##Build/Update corpus.
tif_new <- build_update_corpus(existing_urls = tif_existing$link) %>%
  corpuslingr::clr_prep_corpus (hyphenate = TRUE)

ann_new <-
  cleanNLP::cnlp_annotate(tif_new$text,
                          as_strings = TRUE,
                          doc_ids = tif_new$doc_id)$token %>%
  corpuslingr::clr_set_corpus(doc_var='id',
                              token_var='word',
                              lemma_var='lemma',
                              tag_var='pos',
                              pos_var='upos',
                              sentence_var='sid') %>%
  bind_rows() %>%
  corpuslingr::clr_get_freq(agg_var = c('doc_id','token',
                                        'lemma','tag','pos'),
                            toupper=TRUE) %>%
  select(-docf) %>%
  arrange(as.numeric(doc_id))

##Existing & New.
tif_new <- rbind(tif_existing, tif_new)
ann_new <- rbind(ann_existing, ann_new)


##Output Meta and Annotated BOWS.
setwd("C:\\Users\\jason\\Google Drive\\GitHub\\packages\\quicknews\\data-raw")
saveRDS(tif_new, 'qnews_eg_tif.rds')
saveRDS(ann_new, 'qnews_eg_corpus.rds')

#devtools::use_data(cdr_slate_corpus, overwrite=TRUE)
#devtools::use_data(cdr_slate_ann, overwrite=TRUE)
