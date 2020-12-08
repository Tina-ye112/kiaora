#check if there is api_key function
stop_if_no_key <- function(api_key = NULL){
  if (is.null(api_key)){
    stop("The `api_key` to query the web must be provided.")
  }
}

