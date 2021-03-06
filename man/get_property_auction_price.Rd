% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/property_auction_price.R
\name{get_property_auction_price}
\alias{get_property_auction_price}
\title{Get property auction price}
\usage{
get_property_auction_price(region = NULL, district = NULL, area = NULL)
}
\arguments{
\item{region}{string e.g.,Auckland}

\item{district}{string e.g.,Auckland City}

\item{area}{string e.g.,One Tree Hill}
}
\value{
A tibble
}
\description{
Query auction price and other information for NZ property
}
\examples{
\dontrun{
get_property_auction_price(region = "Northland", district = , area = )
}
# get_property_auction_price function
}
