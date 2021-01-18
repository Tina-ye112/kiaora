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

#agency
agency <- function(x){
  if (x == "Bayleys")
  {
    "1"
  } else if(x == "City Sales")
  {
    "6"
  } else if(x =="Barfoot & Thompson")
  {
    "3"
  } else if(x == "Colliers International")
  {
    "4"
  } else if(x == "Eves")
  {
    "10"
  } else if(x == "Harcourts")
  {
    "2"
  } else if (x == "Impression Real Estate")
  {
    "7"
  } else if (x == "JLL")
  {
    "11"
  } else if (x == "Knight Frank")
  {
    "9"
  } else if (x == "NAI Harcourts")
  {
    "8"
  } else if (x == "Ray White City Apartments")
  {
    "5"
  }
}
