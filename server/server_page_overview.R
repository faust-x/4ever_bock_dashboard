# Available Data 


# Charts -----------------------------------------------------------------------

#Points
output$chart_overview_points <- renderPlotly({
  
  plot_ly(hoverlabel = list(align = "left")) %>%
    add_trace(data= tbl_player_summary(),
              x = ~player,
              y = ~points,
              type = 'bar',
              marker = list(color = if_else(tbl_player_summary()$points>= 0,
                                            list_colors_tableau_10$green,
                                            list_colors_tableau_10$red)),
              text=~points,
              textfont = list(color = "#FFFFFF"),
              hovertemplate = ~paste0("Player<b>: ",player,"</b><br><br>",
                                     "-Matchdays: ",matchdays,"<br>",
                                     "  -Victories: ",victories_matchday,"<br>",
                                     "-Matches: ",matches,"<br>",
                                     "  -Victories: ",victories_match,"<br>",
                                     "-Games: ",games_played,"<br>",
                                     "-Points: <b>",points,"</b><br>",
                                     "-Points per game: ",points_per_game,"<br>",
                                     "-Payment: ",payment," €<br>",
                                     "-Soli: ",games_soli,"<br>",
                                     "<extra></extra>")
              ) %>%
    layout(title = list(text = "<b>Points</b>",
                        font= list(size = list_plotly_default$font_title_size),
                        y = list_plotly_default$font_title_y_position),
           font = list(family = list_plotly_default$font_family,
                       size = list_plotly_default$font_body_size),
           font = list(family = list_plotly_default$font_family),
           yaxis = list(title = "Points"),
           xaxis = list(title = "",
                        categoryorder = "total descending"),
           legend = list(orientation = 'h'))
})

#Points per Game
output$chart_overview_points_per_game <- renderPlotly({
  plot_ly(hoverlabel = list(align = "left")) %>%
    add_trace(data=tbl_player_summary(),
              x = ~player,
              y = ~points_per_game,
              type = 'bar',
              marker = list(color = if_else(tbl_player_summary()$points_per_game>= 0,
                                            list_colors_tableau_10$green,
                                            list_colors_tableau_10$red)),
              text=~points_per_game,
              textfont = list(color = "#FFFFFF"),
              hovertemplate = ~paste0("Player<b>: ",player,"</b><br><br>",
                                      "-Matchdays: ",matchdays,"<br>",
                                      "  -Victories: ",victories_matchday,"<br>",
                                      "-Matches: ",matches,"<br>",
                                      "  -Victories: ",victories_match,"<br>",
                                      "-Games: ",games_played,"<br>",
                                      "-Points: <b>",points,"</b><br>",
                                      "-Points per game: ",points_per_game,"<br>",
                                      "-Payment: ",payment," €<br>",
                                      "-Soli: ",games_soli,"<br>",
                                      "<extra></extra>")
    ) %>%
    layout(title = list(text = "<b>Points per game</b>",
                        font= list(size = list_plotly_default$font_title_size),
                        y = list_plotly_default$font_title_y_position),
           font = list(family = list_plotly_default$font_family,
                       size = list_plotly_default$font_body_size),
           font = list(family = list_plotly_default$font_family),
           yaxis = list(title = "Points per game"),
           xaxis = list(title = "",
                        categoryorder = "total descending"),
           legend = list(orientation = 'h'))
})

# Payment
output$chart_overview_payment <- renderPlotly({
  plot_ly(hoverlabel = list(align = "left")) %>%
    add_trace(data=tbl_player_summary() %>%
                filter(payment > 0),
              x = ~player,
              y = ~payment,
              type = 'bar',
              marker = list(color = list_colors_tableau_10$teal),
              text=~payment,
              textfont = list(color = "#FFFFFF"),
              hovertemplate = ~paste0("Player<b>: ",player,"</b><br><br>",
                                      "-Matchdays: ",matchdays,"<br>",
                                      "  -Victories: ",victories_matchday,"<br>",
                                      "-Matches: ",matches,"<br>",
                                      "  -Victories: ",victories_match,"<br>",
                                      "-Games: ",games_played,"<br>",
                                      "-Points: <b>",points,"</b><br>",
                                      "-Points per game: ",points_per_game,"<br>",
                                      "-Payment: ",payment," €<br>",
                                      "-Soli: ",games_soli,"<br>",
                                      "<extra></extra>")
    ) %>%
    layout(title = list(text = "<b>Payment</b>",
                        font= list(size = list_plotly_default$font_title_size),
                        y = list_plotly_default$font_title_y_position),
           font = list(family = list_plotly_default$font_family,
                       size = list_plotly_default$font_body_size),
           font = list(family = list_plotly_default$font_family),
           yaxis = list(title = "Payment"),
           xaxis = list(title = "",
                        categoryorder = "total descending"),
           legend = list(orientation = 'h'))
})

#Soli
output$chart_overview_soli <- renderPlotly({
  plot_ly(hoverlabel = list(align = "left")) %>%
    add_trace(data=tbl_player_summary() %>%
                filter(games_soli> 0),
              x = ~player,
              y = ~games_soli,
              type = 'bar',
              marker = list(color = list_colors_tableau_10$teal),
              text=~games_soli,
              textfont = list(color = "#FFFFFF"),
              hovertemplate = ~paste0("Player<b>: ",player,"</b><br><br>",
                                      "-Matchdays: ",matchdays,"<br>",
                                      "  -Victories: ",victories_matchday,"<br>",
                                      "-Matches: ",matches,"<br>",
                                      "  -Victories: ",victories_match,"<br>",
                                      "-Games: ",games_played,"<br>",
                                      "-Points: <b>",points,"</b><br>",
                                      "-Points per game: ",points_per_game,"<br>",
                                      "-Payment: ",payment," €<br>",
                                      "-Soli: ",games_soli,"<br>",
                                      "<extra></extra>")
    ) %>%
    layout(title = list(text = "<b>Soli</b>",
                        font= list(size = list_plotly_default$font_title_size),
                        y = list_plotly_default$font_title_y_position),
           font = list(family = list_plotly_default$font_family,
                       size = list_plotly_default$font_body_size),
           font = list(family = list_plotly_default$font_family),
           yaxis = list(title = "Soli"),
           xaxis = list(title = "",
                        categoryorder = "total descending"),
           legend = list(orientation = 'h'))
})

#Games played
output$chart_overview_games_played <- renderPlotly({
  plot_ly(hoverlabel = list(align = "left")) %>%
    add_trace(data=tbl_player_summary(),
              x = ~player,
              y = ~games_played,
              type = 'bar',
              marker = list(color = list_colors_tableau_10$teal),
              text=~games_played,
              textfont = list(color = "#FFFFFF"),
              hovertemplate = ~paste0("Player<b>: ",player,"</b><br><br>",
                                      "-Matchdays: ",matchdays,"<br>",
                                      "  -Victories: ",victories_matchday,"<br>",
                                      "-Matches: ",matches,"<br>",
                                      "  -Victories: ",victories_match,"<br>",
                                      "-Games: ",games_played,"<br>",
                                      "-Points: <b>",points,"</b><br>",
                                      "-Points per game: ",points_per_game,"<br>",
                                      "-Payment: ",payment," €<br>",
                                      "-Soli: ",games_soli,"<br>",
                                      "<extra></extra>")
    ) %>%
    layout(title = list(text = "<b>Games played</b>",
                        font= list(size = list_plotly_default$font_title_size),
                        y = list_plotly_default$font_title_y_position),
           font = list(family = list_plotly_default$font_family,
                       size = list_plotly_default$font_body_size),
           font = list(family = list_plotly_default$font_family),
           yaxis = list(title = "Games"),
           xaxis = list(title = "",
                        categoryorder = "total descending"),
           legend = list(orientation = 'h'))
})

#Victories Matches
output$chart_overview_victories_match <- renderPlotly({
  plot_ly(hoverlabel = list(align = "left")) %>%
    add_trace(data=tbl_player_summary() %>%
                filter(victories_match>0),
              x = ~player,
              y = ~victories_match,
              type = 'bar',
              marker = list(color = list_colors_tableau_10$teal),
              text=~victories_match,
              textfont = list(color = "#FFFFFF"),
              hovertemplate = ~paste0("Player<b>: ",player,"</b><br><br>",
                                      "-Matchdays: ",matchdays,"<br>",
                                      "  -Victories: ",victories_matchday,"<br>",
                                      "-Matches: ",matches,"<br>",
                                      "  -Victories: ",victories_match,"<br>",
                                      "-Games: ",games_played,"<br>",
                                      "-Points: <b>",points,"</b><br>",
                                      "-Points per game: ",points_per_game,"<br>",
                                      "-Payment: ",payment," €<br>",
                                      "-Soli: ",games_soli,"<br>",
                                      "<extra></extra>")
    ) %>%
    layout(title = list(text = "<b>Victories: Match</b>",
                        font= list(size = list_plotly_default$font_title_size),
                        y = list_plotly_default$font_title_y_position),
           font = list(family = list_plotly_default$font_family,
                       size = list_plotly_default$font_body_size),
           font = list(family = list_plotly_default$font_family),
           yaxis = list(title = "Victories"),
           xaxis = list(title = "",
                        categoryorder = "total descending"),
           legend = list(orientation = 'h'))
})

#Victories Matchdays
output$chart_overview_victories_matchday <- renderPlotly({
  plot_ly(hoverlabel = list(align = "left")) %>%
    add_trace(data=tbl_player_summary() %>%
                filter(victories_matchday>0),
              x = ~player,
              y = ~victories_matchday,
              type = 'bar',
              marker = list(color = list_colors_tableau_10$teal),
              text=~victories_matchday,
              textfont = list(color = "#FFFFFF"),
              hovertemplate = ~paste0("Player<b>: ",player,"</b><br><br>",
                                      "-Matchdays: ",matchdays,"<br>",
                                      "  -Victories: ",victories_matchday,"<br>",
                                      "-Matches: ",matches,"<br>",
                                      "  -Victories: ",victories_match,"<br>",
                                      "-Games: ",games_played,"<br>",
                                      "-Points: <b>",points,"</b><br>",
                                      "-Points per game: ",points_per_game,"<br>",
                                      "-Payment: ",payment," €<br>",
                                      "-Soli: ",games_soli,"<br>",
                                      "<extra></extra>")
    ) %>%
    layout(title = list(text = "<b>Victories: Matchday</b>",
                        font= list(size = list_plotly_default$font_title_size),
                        y = list_plotly_default$font_title_y_position),
           font = list(family = list_plotly_default$font_family,
                       size = list_plotly_default$font_body_size),
           font = list(family = list_plotly_default$font_family),
           yaxis = list(title = "Victories"),
           xaxis = list(title = "",
                        categoryorder = "total descending"),
           legend = list(orientation = 'h'))
})

output$chart_overview_position <- renderPlotly({
  plot_ly(hoverlabel = list(align = "left")) %>%
    add_trace(data = tbl_matchday_summary_by_player(),
              x = ~date,
              y = ~position_reverse,
              color = ~player,
              type = 'scatter',
              mode = 'lines',
              hovertemplate = ~paste0("Player<b>: ",player,"</b><br><br>",
                                      "-Date: ",date,"<br>",
                                      "-Position: <b>",position,"</b><br>",
                                      "-Points:",
                                      "<br>  -Today: ",points,
                                      "<br>  -Total: ",points_total,
                                      "<extra></extra>")
    ) %>%
    layout(title = list(text = "<b>Position</b>",
                        font= list(size = list_plotly_default$font_title_size),
                        y = list_plotly_default$font_title_y_position),
           font = list(family = list_plotly_default$font_family,
                       size = list_plotly_default$font_body_size),
           font = list(family = list_plotly_default$font_family),
           yaxis = list(title = "Position"),
           xaxis = list(title = "",
                        categoryorder = "total descending"),
           legend = list(orientation = 'h'))
})
# 
# 
# # Value box row 
# 
# 
# 
# # Value boxes ------------------------------------------------------------------
# 
# tbl_key_values$matchdays
# 
# # Value box row Overview
# output$value_box_row_01 <- renderUI({
#   
#   # Matchdays
#   box_01 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Matchdays"),
#       value = tbl_key_values$matchdays,
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   # Payment
#   box_02 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Payment"),
#       value = paste0(tbl_key_values$payment," €"),
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   # Last matchday
#   box_03 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Last matchday"),
#       value = format(tbl_key_values$last_match_date,"%d.%m.%y"),
#       p(paste0("Player: ",tbl_key_values$last_match_player)),
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   # Most Points 
#   box_04 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Most Points"),
#       value = tbl_key_values$most_points_player,
#       p(paste0("Points: ",tbl_key_values$most_points_value)),
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   layout_column_wrap(width = 1/4,
#                      heights_equal = "row",
#                      fill = FALSE,
#                      box_01,
#                      box_02,
#                      box_03,
#                      box_04)
# })
# 
# 
# # Value box row 02 ------------------
# # matches
# # games
# # bockrunden
# # most_games_played
# 
# tbl_key_values %>% glimpse()
# 
# 
# output$value_box_row_02 <- renderUI({
#   
#   # Matches
#   box_01 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Matches"),
#       value = tbl_key_values$macthes_n,
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   # Games
#   box_02 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Games"),
#       value = tbl_key_values$games_n,
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   # Bockrunden
#   box_03 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Bock Games"),
#       value = tbl_key_values$games_bock,
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   # Most Games Played
#   box_04 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Most games played"),
#       value = tbl_key_values$most_games_played_player,
#       p(paste0("Games: ",tbl_key_values$most_games_played_value)),
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   layout_column_wrap(width = 1/4,
#                      heights_equal = "row",
#                      fill = FALSE,
#                      box_01,
#                      box_02,
#                      box_03,
#                      box_04)
# })
# 
# 
# 
# # Value box row 03 ------------------
# # victories_match
# # victories_matchday
# # most_soli
# # poitns per game 
# 
# tbl_key_values %>% glimpse()
# 
# 
# output$value_box_row_03 <- renderUI({
#   
#   # Victories Matches
#   box_01 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Most Victories: Matches"),
#       value = tbl_key_values$most_victories_match_player,
#       p(paste0("Victories: ",tbl_key_values$most_victories_match_value)),
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   # Victories Matches
#   box_02 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Most Victories: Matchdays"),
#       value = tbl_key_values$most_victories_matchday_player,
#       p(paste0("Victories: ",tbl_key_values$most_victories_matchday_value)),
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   # Points per Game 
#   box_03 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Points per game"),
#       value = tbl_key_values$highest_points_per_game_player,
#       p(paste0("Points: ",tbl_key_values$highest_points_per_game_value)),
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   # Soli
#   box_04 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Most Soli"),
#       value = tbl_key_values$most_soli_player,
#       p(paste0("Soli: ",tbl_key_values$most_soli_value)),
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   layout_column_wrap(width = 1/4,
#                      heights_equal = "row",
#                      fill = FALSE,
#                      box_01,
#                      box_02,
#                      box_03,
#                      box_04)
# })
# 
# # Value box row 04 ------------------
# 
# # players 
# # newest player 
# # biggest_match
# 
# tbl_key_values %>% glimpse()
# 
# 
# output$value_box_row_03 <- renderUI({
#   
#   # players
#   box_01 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Players"),
#       value = tbl_key_values$player_n,
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   # newest player
#   box_02 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("newest player"),
#       value = tbl_key_values$newest_player_name,
#       p(paste0("First Matchday: ",tbl_key_values$newest_player_date)),
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   # biggest match  
#   box_03 <-
#     value_box(
#       fill = TRUE,
#       title = toupper("Biggest Match"),
#       value = tbl_key_values$biggest_match,
#       p(paste0("Number of Players")),
#       showcase = bs_icon("lightning-charge-fill"),
#       theme = "primary")
#   
#   layout_column_wrap(width = 1/4,
#                      heights_equal = "row",
#                      fill = FALSE,
#                      box_01,
#                      box_02,
#                      box_03)
# })