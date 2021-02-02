
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kiaora

<!-- badges: start -->

<!-- badges: end -->

The goal of kiaora is to provide functions to get Auckland transport
information and residential auction results for NZ property, including
property information,auction price and dates, rating value and dates.

## Installation

You can install the released version of kiaora from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("kiaora")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Tina-ye112/kiaora")
```

## Usage

This function contains 3 parameters that are region,district,area.You
could

``` r
library(kiaora)
get_property_auction_price(region = "Northland",district = NULL,area = NULL)
#> # A tibble: 130 x 8
#>    property_address auction_price auction_dates bedrooms bathrooms car_parking
#>    <chr>                    <dbl> <date>           <dbl>     <dbl>       <dbl>
#>  1 31 Moir Street,…        680000 2021-01-28           2         1           1
#>  2 120 Ota Point R…        520000 2021-01-21           4         2           2
#>  3 21 Kemp Road, K…        990000 2021-01-21           3         2           2
#>  4 1 Lincoln Stree…       2600000 2020-12-17           5         3           2
#>  5 5/26 Percy Stre…        487500 2020-12-16           2         1           2
#>  6 40 Hall Road, K…       1096000 2020-12-10           3         2           2
#>  7 39 Percy Street…        570000 2020-12-09           3         1           2
#>  8 93 The Bullock …            NA 2020-12-03           3         2           3
#>  9 7 Brind Road, R…        611000 2020-11-20           2         1           3
#> 10 9B Akiha Street…        330000 2020-11-20           2         1          NA
#> # … with 120 more rows, and 2 more variables: rating_value <dbl>,
#> #   rating_dates <date>
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(nzhousingprice)
#>  property_address   auction_price       auction_dates           bedrooms     
#>  Length:15733       Min.   :1.300e+01   Min.   :2016-07-01   Min.   : 1.000  
#>  Class :character   1st Qu.:6.900e+05   1st Qu.:2018-11-15   1st Qu.: 3.000  
#>  Mode  :character   Median :9.350e+05   Median :2019-11-14   Median : 3.000  
#>                     Mean   :8.522e+08   Mean   :2019-10-04   Mean   : 3.384  
#>                     3rd Qu.:1.305e+06   3rd Qu.:2020-09-03   3rd Qu.: 4.000  
#>                     Max.   :1.202e+13   Max.   :2021-01-29   Max.   :65.000  
#>                     NA's   :1332                             NA's   :238     
#>    bathrooms        car_parking      rating_value       rating_dates       
#>  Min.   :  1.000   Min.   : 1.000   Min.   :    3000   Min.   :2015-07-01  
#>  1st Qu.:  1.000   1st Qu.: 1.000   1st Qu.:  650000   1st Qu.:2017-07-01  
#>  Median :  2.000   Median : 2.000   Median :  885000   Median :2017-07-01  
#>  Mean   :  1.746   Mean   : 1.787   Mean   :  995540   Mean   :2017-08-22  
#>  3rd Qu.:  2.000   3rd Qu.: 2.000   3rd Qu.: 1200000   3rd Qu.:2017-07-01  
#>  Max.   :150.000   Max.   :33.000   Max.   :11000000   Max.   :2020-09-01  
#>  NA's   :204       NA's   :2051     NA's   :3486       NA's   :3681
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date.

You can also embed plots, for example:

``` r
library(ggplot2)
ggplot(nzhousingprice,aes(x=rating_value,y=auction_price))+geom_point()+
  geom_smooth(method = 'lm')+xlim(0,11000000)+ylim(0,11000000)
#> `geom_smooth()` using formula 'y ~ x'
#> Warning: Removed 4619 rows containing non-finite values (stat_smooth).
#> Warning: Removed 4619 rows containing missing values (geom_point).
#> Warning: Removed 2 rows containing missing values (geom_smooth).
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub\!
