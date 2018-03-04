

tryDownloadEvent <- function(event) {
  tryCatch(
    download.file(
      paste(c("https://raw.githubusercontent.com/the-blue-alliance/the-blue-alliance-data/master/events/2017/",
              event,
              "/",
              event,
              "_matches.csv"),
            collapse = ""),
      paste(c("data/",
              event,
              "_matches.csv"),
            collapse = ""),
      "curl"))
}

tba_auth_key <- fromJSON(read_file("tba_auth_key.json"))

getTBAData <- function(url) {
  req <- httr::GET(url, httr::add_headers("X-TBA-Auth-Key" = tba_auth_key$tba_auth_key))
  json <- httr::content(req, as = "text")
  data <- fromJSON(json) 
  if(length(data) > 0) {
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
