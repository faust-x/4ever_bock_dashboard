# Google Drive -----------------------------------------------------------------


# input <-
#   list(season = 2024,
#        player = "Felix",
#        player_analysis_y_axis = "points_total")
# 

# Load 
google_sheet_data <-
read_sheet(input_data$google_url_sheet_data)

# Renaming
tbl_renaming_column_names <-
  tibble(datum = "date",
         spiel = "match",
         spieler_in = "player",
         punkte = "points",
         spielrunden_am_abend = "games_n",
         bockrunden_am_abend = "games_bock",
         soli_gespielt_anzahl  = "games_soli",
         spielrunden_ausgesetzt = "games_suspended") %>% 
  pivot_longer(everything())

vec_renaming_colum_names <- 
  setNames(tbl_renaming_column_names$name,
           tbl_renaming_column_names$value)

# Clean data set
tbl_raw_data_clean <- 
google_sheet_data %>% 
  clean_names() %>% 
  rename(!!!vec_renaming_colum_names) %>% 
  mutate(across(any_of(c("date")), ymd)) %>% 
  filter(!is.na(date)) %>%
  filter(!is.na(player)) %>%
  mutate(across(where(is.numeric), ~ replace_na(., 0))) %>% 
  mutate(games_played = games_n - games_suspended) %>% 
  mutate(payment = if_else(points >= 0,
                           0,
                           points) *-10/100) %>% 
  mutate(season = year(date)) %>% 
  arrange(desc(date))

# Backup 
# write_csv(tbl_raw_data_clean,
#           "tbl_raw_data_clean.csv")
# 
# tbl_raw_data_clean_test <- 
# read_csv("tbl_raw_data_clean.csv")

tbl_pictures_in_folder <-
  drive_ls(path= as_id(input_data$google_id_folder_images),
           #shared_drive = as_id(input$id_shared_drive),
           recursive = TRUE) %>% 
  unnest_wider(drive_resource,
               names_repair = "unique") %>%
  select(name=1,
         googledrive_id=2,
         mimeType,
         createdTime,
         modifiedTime,
         parents) %>% 
  unnest_wider(parents,
               names_sep = "_") %>% 
  mutate(across(contains(c("Time")),
                ymd_hms)) %>% 
  filter(str_detect(mimeType,"image")) %>% 
  mutate(url = paste0("https://drive.google.com/uc?export=view&id=",googledrive_id))

#Backup
# write_csv(tbl_pictures_in_folder,
#           "tbl_pictures_in_folder.csv")
# 
# tbl_pictures_in_folder <-
#   read_csv("tbl_pictures_in_folder.csv")

# Options ----

options_season <-
  tbl_raw_data_clean %>% 
  distinct(season) %>% 
  arrange(desc(season)) %>% 
  pull()



# 
# 
# 
# # Detail Player Analysis 
# 
# # data 
# 
# tbl_data_of_selected_player_by_date <-
#   tbl_matches_raw_data %>% 
#   filter(player %in% input$player) %>% 
#   group_by(date) %>% 
#   summarise(points = sum(points),
#             matches = n(),
#             games_n = sum(games_n),
#             games_bock = sum(games_bock),
#             games_played = sum(games_played),
#             games_soli = sum(games_soli)) %>% 
#   arrange(date) %>% 
#   mutate(points_total = cumsum(points)) %>% 
#   ungroup() %>% 
#   mutate(points_color = if_else(points>=0,
#                                 list_colors_tableau_10$green,
#                                 list_colors_tableau_10$red))
# 
# 
# output$chart_points <- renderPlotly({ 
#   plot_ly(hoverlabel = list(align = "left"),
#     data = tbl_data_of_selected_player_by_date,
#           x = ~date) %>% 
#     add_trace(y = ~points_total,
#               type = 'scatter', 
#               mode = 'lines',
#               line = list(color = list_colors_tableau_10$teal,
#                           width = 3),
#               name = "Total") %>% 
#     add_trace(y = ~points,  
#               type = 'bar',
#               marker = list(color = ~points_color),
#               name = "Matchday") %>%
#     layout(title = list(text = paste0 ("<b> Points of ",input$player,"</b>"),
#                         font= list(size = list_plotly_default$font_title_size),
#                         y = list_plotly_default$font_title_y_position),
#            font = list(family = list_plotly_default$font_family,
#                        size = list_plotly_default$font_body_size),
#            font = list(family = list_plotly_default$font_family),
#            yaxis = list(title = "Points"),
#            xaxis = list(title = ""),
#            legend = list(orientation = 'h'))
# })
# 
# output$chart_points <- renderPlotly({ 
#   plot_ly(hoverlabel = list(align = "left"),
#           data = tbl_matchday_summary_by_player %>% 
#             filter(!player %in% input$player),
#           x = ~date,
#           y = ~position_reverse, 
#           color = ~player,
#           line = list(color = list_colors_tableau_10$grey,
#                       width = 2),
#           type = 'scatter', 
#           mode = 'lines',
#           hovertemplate = ~paste0("Player<b>: ",player,"</b><br><br>",
#                                   "-Date: ",date,"<br>",
#                                   "-Position: <b>",position,"</b><br>",
#                                   "-Points:",
#                                   "<br>  -Today: ",points,
#                                   "<br>  -Total: ",points_total,
#                                   "<extra></extra>")) %>% 
#     add_trace(data = tbl_matchday_summary_by_player %>% 
#                 filter(player %in% input$player),
#               line = list(color = list_colors_tableau_10$blue,
#                           width = 2)) %>% 
#     layout(title = list(text = "<b>Position</b>",
#                         font= list(size = list_plotly_default$font_title_size),
#                         y = list_plotly_default$font_title_y_position),
#            font = list(family = list_plotly_default$font_family,
#                        size = list_plotly_default$font_body_size),
#            font = list(family = list_plotly_default$font_family),
#            yaxis = list(title = "Position"),
#            xaxis = list(title = "",
#                         categoryorder = "total descending"),
#            legend = list(orientation = 'h'))
# })
# 
# # Matches 
# 
# output$reactable_spieltag <- renderReactable({
#   tbl_matches_raw_data %>%
#     filter(date == "2024-03-13") %>% 
#     filter(match == 0) %>% 
#     select(player,
#            position,
#            points,
#            payment,
#            games = games_played,
#            soli = games_soli) %>% 
#     reactable(.,
#               striped = TRUE,
#               fullWidth = FALSE,
#               resizable = TRUE,
#               defaultPageSize = 15,
#               theme = reactableTheme(
#                 color = "#000000"),
#               columns = list(
#                 points = colDef(cell = data_bars(.,
#                                                  text_position = "above",
#                                                  fill_color = c(list_colors_tableau_10$red,
#                                                                 list_colors_tableau_10$green))
#                 )
#               ))
# })
# 
# 
# # Picture
# output$image_spieltag<-renderUI({img(src=tbl_pictures_in_folder %>% 
#                                        filter(name=="2023_08_02.jpg") %>%
#                                        pull(url),
#                                      width = '400px',
#                                      height = '500px')})
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
