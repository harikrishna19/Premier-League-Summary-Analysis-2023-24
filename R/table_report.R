





#' Title
#'
#' @param match_url Pass a match URL
#'
#' @return Returns a graph with match level events
#' 
#' @export
#'
#' @examples
#' match_report_data=match_report(match_results_data$MatchURL[87])

match_report <- function(match_url) {

report<-fb_match_report(match_url)
# Sample data
team_a_data <- report[,4:10] %>% unlist() %>% as.vector()
team_b_data <- report[,11:17] %>% unlist() %>% as.vector()

team_a_data<-gsub('&rsquor'," ' ",x = team_a_data)
team_b_data<-gsub('&rsquor'," ' ",x = team_b_data)
categories <- c("Team", "Formation", "Score","Xg","⚽","🟨","🟥")


# Create a data frame
team_comparison <- data.frame(
  `Home Team` = team_a_data,
  Statistic = categories,
  `Away Team`=team_b_data
)

# Print the data frame
render_table <- team_comparison %>% select("Home Team" = Home.Team, "Statistic", "Away Team" =
                                             Away.Team) %>% reactable(
                                               bordered = T,
                                               highlight = T,
                                               striped = T,
                                               compact = T,
                                               resizable = T,
                                               
                                               defaultColDef = colDef(name = NULL, align = "center"),
                                               ,
                                               theme = reactableTheme(
                                                 borderColor = "red",
                                                 stripedColor = "#ffa",
                                                 cellPadding = "8px 12px",
                                                 style = list(fontFamily = "-apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif"),
                                                 searchInputStyle = list(width = "100%")
                                               )
                                             )

return(render_table)

}








