
#Draw Graph Events vs Minutes in a football game


#source("get_data.R")
source("libraries.R")
source("team_hex_codes.R")

#' Title
#'
#' @param variables 
#'
#' @return
#' @export
#'
#' @examples





draw_event_graph <- function(match_url,data_hex) {
  
  get_match_summary<-worldfootballR::fb_match_summary(match_url = match_url)
  get_match_summary<-get_match_summary %>% separate(Score_Progression, c('home_sc', 'away_sc'))
  
  get_match_summary_data <- get_match_summary %>%
    pivot_longer(cols = c(home_sc, away_sc), names_to = "Team1", values_to = "Score_Value")
  
  get_match_summary_data<-get_match_summary_data %>%
    filter((Team == unique(get_match_summary_data$Home_Team) & Team1 == "home_sc") |
             (Team == unique(get_match_summary_data$Away_Team) & Team1 == "away_sc"))
  
  get_match_summary_data$emoji1=case_when(
    get_match_summary_data$Event_Type %in% c("Goal","Penalty") ~ "\u26BD",
    get_match_summary_data$Event_Type =='Substitute'  ~ "⬆️⬇️",
    get_match_summary_data$Event_Type=="Red Card" ~ "🟥",
    get_match_summary_data$Event_Type=="Yellow Card" ~ "🟨",
  ) 
  get_match_summary_data$Event_Display=paste0(get_match_summary_data$Event_Time,"-",get_match_summary_data$emoji1,"-",get_match_summary_data$Event_Players)

  
 
  
 
  plot_graph<-get_match_summary_data %>%
    dplyr::mutate(y = case_when(Team == unique(get_match_summary_data$Away_Team) ~ -as.numeric(Score_Value), .default = as.numeric(Score_Value))) %>%
    ggplot(aes(x = Event_Time, y = y, color = Team,tooltip=Event_Display,data_id=Event_Display)) +
    geom_point_interactive(size=3) +
    geom_segment(aes(x = Event_Time, xend = Event_Time, y = 0, yend = y), linetype = 2) +
    geom_hline(yintercept = 0) +
    expand_limits(y = 0) +
    scale_y_continuous(
      labels = abs,
      breaks=function(x) seq(floor(min(x)), ceiling(max(x)), by = 1)
      #breaks = seq(0, ceiling(max(abs(as.numeric(get_match_summary_data$Score_Value)))), by = 1)
    ) +
    scale_colour_manual(values = c(data_hex[data_hex$Squad==unique(get_match_summary_data$Home_Team),][['Codes']],data_hex[data_hex$Squad==unique(get_match_summary_data$Away_Team),][['Codes']]))+
    guides(color = guide_legend(override.aes = list(shape = 16)),  # Adjust legend
           shape = guide_legend(title = "Emojis")) +
    labs(x = "Event Time", y = "Goals Scored By Team") +
    theme_stata(scheme="s2manual")
  plot_graph<- girafe(
    ggobj = plot_graph,
    options = list(
      opts_toolbar(
        position = "topright",
        tooltips = list(
          zoom_on = "activattion du pan/zoom",
          zoom_off = "désactivation du pan/zoom",
          zoom_rect = "zoom en rectangle",
          zoom_reset = "reset pan/zoom",
          saveaspng = FALSE
        )
  )))
  return(plot_graph)
  
  
  }



# 
# match_url="https://fbref.com/en/matches/53bb8f30/Chelsea-Manchester-City-November-12-2023-Premier-League"
# 
# match_url1="https://fbref.com/en/matches/3a6836b4/Burnley-Manchester-City-August-11-2023-Premier-League"
# 
# draw_event_graph(match_url = match_results_data$MatchURL[380],hex_codes)













