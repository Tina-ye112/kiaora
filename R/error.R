#check if there is api_key function
stop_if_no_key <- function(api_key = NULL){
  if (is.null(api_key)){
    stop("The `api_key` to query the web must be provided.")
  }
}

#replace space with %20
get_akl_by_string <- function(api_key = NULL, path = NULL) {
  stop_if_no_key(api_key)
  base_url <- "https://api.at.govt.nz/"
  connection <- GET(base_url,
                    path = gsub(" ","%20",path),
                    add_headers("Ocp-Apim-Subscription-Key" = api_key)
  )
  stop_for_status(connection,"get the data")
  cnt <- content(connection, as = "text")
  res <- jsonlite::fromJSON(cnt)$response
  tibble::as_tibble(res)
}
