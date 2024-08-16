

#Libraries sourcing
source("libraries.R")



# Function to extrace match results data
match_results_data <- worldfootballR::fb_match_results(country = "ENG", gender = "M", season_end_year = 2024, tier = "1st")


#Function to extract premier league table
pl_table <- worldfootballR::fb_season_team_stats(country = "ENG", gender = "M", season_end_year = "2024", tier = "1st", stat_type = "league_table")

# #Adding images
# pp_table=prem_table %>% arrange(Rk)
# pp_table$club_img<-team_imgs
# 
# #MAtch Data 
# 
# # # function to extract match report data
# match_report_data <- worldfootballR::fb_match_report(match_url =match_results_data[['MatchURL']])
# # #match summaries
# match_summary=worldfootballR::fb_match_summary(match_url=match_results_data[['MatchURL']])


