% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_meta.R
\name{get_meta}
\alias{get_meta}
\alias{qnews_get_meta}
\title{Get article metadata from GoogleNews RSS feed.}
\usage{
qnews_get_meta(x, language = "en", country = "us", type = "topstories",
  search = NULL)
}
\arguments{
\item{language}{Language locale code}

\item{country}{Country two letter code}

\item{type}{Search type: topic, topstories, or term}

\item{search}{if type = term/topic, the term or topic to be searched.  Sets to NULL when type = topstories.}
}
\value{
A dataframe of meta for articles collected.
}
\description{
A simple function for acquiring current metadata for articles aggregated by GoogleNews based on user-specified search parameters, including language and country.
}
