

# 
# match_results_data <- worldfootballR::fb_match_results(country = "ENG", gender = "M", season_end_year = 2024, tier = "1st")
# write.csv(match_results_data,"data/match_results_data.csv")


#' @export
get_match_details<-function(results_data,team_select){
  filter_team<-results_data %>% filter(Home==team_select | Away==team_select)
  filter_team<-list("match_selection"=unique(filter_team$MatchSelect),"MatchURL"=unique(filter_team[['MatchURL']]))
  filter_team=setNames(filter_team$MatchURL,filter_team$match_selection)
  return(filter_team)
}




# 
# # #Function to extract premier league table
# pl_table <- worldfootballR::fb_season_team_stats(country = "ENG", gender = "M", season_end_year = "2024", tier = "1st", stat_type = "league_table")
# 
# write.csv(final_pl_table,"data/final_pl_table.csv")
# 
# # # #Adding images
#  final_pl_table=pl_table %>% arrange(Rk)
# # 
#  team_urls <- "https://www.transfermarkt.co.in/premier-league/tabelle/wettbewerb/GB1/saison_id/2023"
# # 
#  team_imgs=read_html(team_urls) %>% html_elements("#yw1 .no-border-rechts img") %>% html_attr("src")
# # 
#  team_imgs=gsub("tiny","head",team_imgs)
# # 
# # 
# # 
#  final_pl_table$club_img<-team_imgs



# Team Hex Codes ----------------------------------------------------------

hex_codes=data.frame("Squad"=c("Arsenal",
                               "Aston Villa","Bournemouth",
                               "Brentford","Brighton & Hove Albion",
                               "Burnley","Chelsea","Crystal Palace","Everton","Fulham","Liverpool","Luton Town","Manchester City","Manchester United",
                               "Newcastle United","Nottingham Forest","Sheffield United","Tottenham Hotspur","West Ham United","Wolverhampton Wanderers"))
hex_codes['Codes']<-c("#EF0107",
                      "#94BEE5","#E62333",
                      "#D20000",
                      "#0055a9",
                      "#53162F",
                      "#034694",
                      "#1B458F","#274488","grey",
                      "#D00027","#F78F1E","#98c5e9","#DA020E","#241f20","#DD0000","#ED1A3B","#001C58","#60223B","#FBEE23")

