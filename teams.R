library(tidyverse)
library(stringr)

download.file(
  "https://raw.githubusercontent.com/the-blue-alliance/the-blue-alliance-data/master/teams/teams.csv",
  "data/teams.csv",
  "wget"
)

teams <- read_csv(
  "data/teams.csv",
  col_names = c(
    "team_number",
    "nickname",
    "name",
    "city",
    "state_prov",
    "country",
    "website",
    "rookie_year",
    "facebook",
    "twitter",
    "youtube",
    "github",
    "instagram",
    "periscope"
  )
) %>%
  mutate(team_number = str_replace(team_number, "frc", "")) %>%
  mutate(country = as.factor(country)) %>%
  type_convert()

teams %>%
  ggplot(aes(rookie_year, team_number)) +
  geom_point() +
  geom_smooth()

teams %>%
  ggplot(aes(rookie_year)) +
  geom_bar()

teams %>%
  filter(!is.na(country)) %>%
  mutate(country = fct_lump(country, 7)) %>%
  mutate(country = country %>% fct_infreq() %>% fct_rev()) %>%
  group_by(rookie_year, country) %>%
  count() %>%
  ggplot(aes(rookie_year, n,
             color = fct_reorder2(country, rookie_year, n))) +
  geom_line(binwidth = 1) +
  xlim(1990, 2018) +
  labs(
    title = "FRC Growth Outside USA",
    subtitle = "Growth from 400 rookies/y to 500+ driven by Canada, China, Turkey, and others",
    x = "Year",
    y = "Rookie Teams",
    color = "Country"
  )
ggsave("rookies_by_country.png", width = 8, height = 4)
