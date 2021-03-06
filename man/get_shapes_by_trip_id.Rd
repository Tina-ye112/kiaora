% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/akl_transport.R
\name{get_shapes_by_trip_id}
\alias{get_shapes_by_trip_id}
\title{Get shapes by trip id}
\usage{
get_shapes_by_trip_id(trip_id = NULL)
}
\arguments{
\item{trip_id}{string identifier of the trip}
}
\value{
A tibble
}
\description{
Query shapes by trip id
}
\examples{
\dontrun{
get_shapes_by_trip_id(trip_id = "51100221657-20201221160823_v95.106")
}
# get shapes by trip_id
}
