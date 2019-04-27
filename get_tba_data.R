library(jsonlite)

tba_auth_key <- fromJSON(read_file("tba_auth_key.json"))

getTBAData <- function(url) {
  req <- httr::GET(url, httr::add_headers("X-TBA-Auth-Key" = tba_auth_key$tba_auth_key))
  json <- httr::content(req, as = "text")
  data <- fromJSON(json)
  if(is.data.frame(data) && length(data) > 0) {
    data <- data %>% flatten(recursive = TRUE)
  }
  return(data)
}

getEvents <- function(year) {
  url <- paste(c("https://www.thebluealliance.com/api/v3/events/",
                 year),
               collapse = "")
  return(getTBAData(url))
}

getEventMatches <- function(year, event_code) {
  url <- paste(c("https://www.thebluealliance.com/api/v3/event/",
                 year,
                 event_code,
                 "/matches"),
               collapse = "")
  return(getTBAData(url))
}

getEventTeamsKeys <- function(year, event_code) {
  url <- paste(c("https://www.thebluealliance.com/api/v3/event/",
                 year,
                 event_code,
                 "/teams/keys"),
               collapse = "")
  return(getTBAData(url))
}

getTeamsPage <- function(page) {
  url <- paste(c("https://www.thebluealliance.com/api/v3/teams/",
                 page),
               collapse = "")
  print(url)
  return(getTBAData(url))
}

getTeams <- function() {
  page = 0
  teams = tibble()
  while(TRUE) {
    new_teams <- getTeamsPage(page)
    if(length(new_teams) == 0) {
      break
    }
    teams <- bind_rows(teams, new_teams)
    page <- page + 1
  }
  return(teams)
}
