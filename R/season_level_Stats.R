

#' Title
#'
#' @param match_data Pass a data frame containing match data
#' @param final_pl_table  Pass a dataframe containing premier league table data
#'
#' @return Returns a complete dataframe with all information including team win/loss
#' 
#' @export
#'
#' @examples
#'sparklines_logic(match_data,final_pl_table)


sparklines_logic<-function(match_data,final_pl_table){
  final_pl_table$score_by_week <- I(vector("list", length = nrow(final_pl_table)))
  for(team in 1:length(final_pl_table$Squad)){
  match_data_filter<-match_data %>% group_by(Home,Away,Wk) %>% arrange(as.numeric(Wk)) %>% filter(Home==final_pl_table$Squad[team] | Away==final_pl_table$Squad[team])
  match_data_filter <- match_data_filter %>%
    mutate(
      result = case_when(
        HomeGoals > AwayGoals ~ paste0(Home, " Win"),
        HomeGoals == AwayGoals ~ "Match Draw",
        TRUE ~ paste0(Away, " Win")
      ),
      score = case_when(
        HomeGoals > AwayGoals ~ 1,
        HomeGoals == AwayGoals ~ 0,
        TRUE ~ 1
      )
    )
  match_data_filter$score<-ifelse(str_detect(match_data_filter$result,paste(final_pl_table$Squad[team],"Win",sep=" ")),3,ifelse(str_detect(match_data_filter$result, "Win"), -1, 1))

  
  final_pl_table$score_by_week[final_pl_table$Squad == final_pl_table$Squad[team]] <- I(list(c(match_data_filter$score)))
  }
  
  
    
  
  return(final_pl_table)
  
}






#' @param pl_table  Pass a dataframe containing premier league table data
#'
#' @return Returns a complete dataframe with reactable data table containing all information
#' 
#' @export
#'
#' @examples
#'season_level_stats(pl_table)
season_level_stats <- function(pl_table) {
  season_table<-reactable(
    pl_table %>% select("Team"=Squad,club_img,W,"Draw"=D,"Loss"=L,GF,GA,"Points"=Pts,"Top Goal Scorer"=Top.Team.Scorer,"Form"=score_by_week),
    pagination = FALSE,sortable = FALSE,highlight = TRUE,striped = TRUE,compact = TRUE,defaultExpanded = F,resizable = T,
    defaultColDef = colDef(name = NULL, align = "center",width = 150,resizable = T),
    theme = reactableTheme(
      headerStyle = list(
        "&:hover[aria-sort]" = list(background = "hsl(0, 0%, 96%)"),
        "&[aria-sort='ascending'], &[aria-sort='descending']" = list(background = "hsl(0, 0%, 96%)"),
        borderColor = "#555"
      )),
    # Give rows a pointer cursor to indicate that they're clickable
    rowStyle = list(cursor = "pointer"),
    columns = list(
      club_img = colDef(name = "",  sticky = "right",
                        cell = embed_img(height = 35, width = 35)),
      W = colDef(name ="Wins", 
                 cell = data_bars(pl_table, 
                                  align_bars = "left",round_edges = TRUE,
                                  bar_height = 10, 
                                  text_position = "outside-end", 
                                  background = "transparent",fill_color = "green"
                 )
      ),
      GF = colDef(name="Goals Scored",
                  cell = data_bars(pl_table, 
                                   align_bars = "left",round_edges = TRUE, 
                                   bar_height = 10, 
                                   text_position = "outside-end", 
                                   background = "transparent",fill_color = "blue" )
      ),
      GA = colDef(name="Goals Conceded",
                  cell = data_bars(pl_table, 
                                   align_bars = "right",round_edges = TRUE,
                                   bar_height = 10, 
                                   text_position = "outside-end", 
                                   background = "transparent",fill_color="red")
      ),
      Form = colDef(
        cell = function(value) {
          sparkline(value,chart_type = "bar",height=80,width=200)
        }
      )
      
    ))
  return(season_table)
}






