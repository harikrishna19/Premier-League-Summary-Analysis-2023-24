





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
render_table<-team_comparison %>% reactable(bordered = T,highlight = T,striped = T,compact=T,
                  defaultColDef = colDef(name=NULL,
                                         align = "center"),
                  ,theme = reactableTheme(
                    borderColor = "#dfe2e5",
                    stripedColor = "#f6f8fa",
                    highlightColor = "#f0f5f9",
                    cellPadding = "8px 12px",
                    style = list(
                      fontFamily = "-apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif"
                    ),
                    searchInputStyle = list(width = "100%")
                  ))

return(render_table)
    
}








# GIve USer for selection -------------------------------------------------


# 
# match_report_adv<-function(match_url){
#   
#   adv_stats<-worldfootballR::fb_advanced_match_stats(match_url,stat_type = "summary", team_or_player = "team")
#   
#   adv_stats<-reactable(as.data.frame(adv_stats) %>% t(),filterable = T,pagination = F,pageSizeOptions = 25)
#   
#   
# return(adv_stats)  
# }
# 
# match_report_adv(match_results_data$MatchURL[1])

