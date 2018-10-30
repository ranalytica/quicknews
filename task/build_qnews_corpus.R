

library(corpuslingr)
library(quicknews)
library(udpipe)
library(tidyverse)


topics <- c('nation','world', 'sports', 
            'science', 'business', 'technology')
#Probably kill the sports section.  Lots of numbers, junky, etc.


#Get news meta.

#Also, there was an additional parameter here ('link_var') that we killed for some reason.

#This can also be a local function.
meta1 <- lapply(topics, function (x) {
  quicknews::qnews_get_meta (language="en", country="us", 
                             type="topic", search=x) %>%
  quicknews::qnews_scrape_web()  
}) %>% bind_rows() 
#Need to add unique doc_ids.


setwd("C:\\Users\\jason\\Google Drive\\GitHub\\packages\\quicknews\\data-raw")
saveRDS(meta1, 'qnews_tif.rds') #meta & tif as one; most efficient.


#These texts also have to be annotated, and outputted.  

#Amounts to: 1. qnews_get_meta(), 2. Compare new meta to existing, 3. If new, qnews_Scrape_web()

existing_urls <- meta1$link #This could be a parameter -- 

meta2 <- lapply(topics, function (x) {
  quicknews::qnews_get_meta (language="en", 
                             country="us", 
                             type="topic", 
                             search=x) %>% 
    #'existing_corpus' param. -- a vector specifying URLs comprising ... 
    filter(!link %in% existing_urls) %>% #Only difference.
  
    quicknews::qnews_scrape_web()  
}) %>% bind_rows() 
#Need to add doc_ids; will start where meta1 ends.


#append meta2 to meta1, then output.

#Clean raw corpus --- clean/Annotate meta2.  

#Output as a BOW per search instance.  --- Or, append to a larger RDS file, which would make more sense.  In both instances, then, we have done away with loads of intermediary csv files.

#Annotate raw corpus
corpus <- clr_prep_corpus (corpus, hyphenate = TRUE)

cleanNLP::cnlp_init_udpipe(model_name="english",
                           feature_flag = FALSE, 
                           parser = "none")
ann_corpus <- 
  cleanNLP::cnlp_annotate(corpus$text, 
                          as_strings = TRUE, 
                          doc_ids = corpus$doc_id) 

