% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/raw_download.R
\name{raw_download}
\alias{raw_download}
\title{Download Raw data from S3}
\usage{
raw_download(election_code, county_code)
}
\arguments{
\item{election_code}{Election code}

\item{county_code}{County code. Typically 5-digit fips}
}
\value{
a data.frame if the uploaded raw data is csv, a list if the data is JSON,
and an xml2::xml_document if xml
}
\description{
For accessing files placed using \code{\link{raw_upload}}
}
