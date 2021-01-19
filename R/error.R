#check if there is api_key function
stop_if_no_key <- function(api_key = ""){
  if (nchar(api_key) == 0) {
    abort(c(
      "`AKL_TRANS_API` is required to run this funcion.",
      i = "Please apply an API key at https://dev-portal.at.govt.nz",
      i = "Please use `usethis::edit_r_environ()` to add your API key to the `.Renviron`."))
  }
}

#replace space with %20
replace_space_with_20 <- function(x) {
  gsub(" ", "%20", x)
}

