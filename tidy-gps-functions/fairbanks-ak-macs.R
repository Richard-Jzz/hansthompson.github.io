get_tidy_gps <- function() {
  library(httr);library(dplyr);library(purrr)
  
  url <- "http://macs.fnsb.us:8080/portal/feed/v3/FNSB/vehicles/?templates%5B%5D=title&templates%5B%5D=body&title=%7B%40masterRoutelongName%7D&body=Bus+%7B%40internalVehicleId%7D+traveling+at+%7B%40speed%7Dmph&timeHorizon=30&_=1494520936422"
  
  bus_list <- content(GET(url))
  
  tidy_gps <- bus_list$data %>% map_df(~list(latitude  = .x$latitude %||% NA, 
                                route  = .x$masterRouteId %||% NA,
                                trip  = .x$trip %||% NA,
                                direction  = .x$direction %||% NA,
                                latitude  = .x$latitude %||% NA,  
                                longitude = .x$longitude %||% NA))
  
  tidy_gps <- tidy_gps %>% filter(!is.na(route)) %>% arrange(route, -latitude)
  
  tidy_gps$direction[tidy_gps$direction == "Westbound"] <- 0
  tidy_gps$direction[tidy_gps$direction == "Outbound"] <- 0
  tidy_gps$direction[tidy_gps$direction == "Loop"] <- 0
  tidy_gps$direction[tidy_gps$direction == "Inbound"] <- 1
  tidy_gps$direction[tidy_gps$direction == "Eastbound"] <- 1
  tidy_gps %>% mutate(direction_id = as.character(direction)) %>%
    select(latitude, longitude, route, direction) %>%
    mutate(datetime = Sys.time())
}
