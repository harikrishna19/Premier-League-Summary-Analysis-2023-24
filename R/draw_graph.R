
#Draw Graph Events vs Minutes in a football game



#' Title
#'
#' @param match_url Pass a match URL
#' @param data_hex  Pass a dataframe containing team names along with the hex codes
#'
#' @return Returns a graph with match level events
#' 
#' @export
#'
#' @examples
#' draw_event_graph(match_url = pass_match_url,pass_hex_code_data)


draw_event_graph <- function(match_url,data_hex) {
  get_match_summary<-worldfootballR::fb_match_summary(match_url = match_url)
  print(get_match_summary$Score_Progression)
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
  get_match_summary_data$Event_Display=paste0(get_match_summary_data$Event_Time," ' ","-",get_match_summary_data$emoji1,"-",get_match_summary_data$Event_Players)

  
 

  plot_graph<-get_match_summary_data %>%
    dplyr::mutate(y = case_when(Team == unique(get_match_summary_data$Away_Team) ~ -as.numeric(Score_Value), .default = as.numeric(Score_Value))) %>%
    ggplot(aes(x = Event_Time, y = y, color = Team,text=Event_Display)) +
    geom_point(size=3) +
    geom_segment(aes(x = Event_Time, xend = Event_Time, y = 0, yend = y), linetype = 2) +
    geom_hline(yintercept = 0) +
    geom_vline(xintercept = 45,linetype = "dotted", color = "red")+
    annotate("text", x = 45, y = 0.5, label = "Half Time", 
             vjust = -0.5, hjust = 0.5,angle=90,  color = "black") +
    expand_limits(y = 0) +
    scale_y_continuous(
      labels = abs,
      breaks=function(x) seq(floor(min(x)), ceiling(max(x)), by = 1)
    ) +
    scale_colour_manual(values = c(data_hex[data_hex$Squad==unique(get_match_summary_data$Home_Team),][['Codes']],data_hex[data_hex$Squad==unique(get_match_summary_data$Away_Team),][['Codes']]))+
    guides(color = guide_legend(override.aes = list(shape = 16)),  # Adjust legend
           shape = guide_legend(title = "Emojis")) +
    labs(
      title = "Event occured in the game vs Time",
      x = "Event Time",
      y = "Goals scored by team",
    ) +
    theme_solarized()+
    theme(
      plot.title = element_text(color = "black", size = 14, face = "bold",hjust = 0.5),       # Title
      axis.title.x = element_text(color = "red", size = 12,face = "bold"),                     # X-Axis Label
      axis.title.y = element_text(color = "red", size = 12,face = "bold"),                     # Y-Axis Label
    )

  plot_graph<-ggplotly(plot_graph,tooltip = "Event_Display")
  
  return(plot_graph)
  }





