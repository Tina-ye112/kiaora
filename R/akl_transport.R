library("httr")
get_akl_agency <- function(api_key=NULL){
  if (is.null(api_key)){
    stop()
  }
  base_url <- "https://api.at.govt.nz/"
  path <- "v2/gtfs/agency"
  my_raw_result <- GET(base_url, path = path,
                       add_headers("Ocp-Apim-Subscription-Key" = api_key))
  cnt <- content(my_raw_result, as = "text")
  res <- jsonlite::fromJSON(cnt)$response
  class(res)
  tibble::as_tibble(res)
}
  

get_akl_agency(api_key = "")