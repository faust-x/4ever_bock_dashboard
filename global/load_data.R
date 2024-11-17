# Google Drive -----------------------------------------------------------------

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

tbl_raw_data_clean %>% view()

# Data Preparation ----

tbl_raw_data_clean %>% glimpse()

tbl_matches_raw_data <-
  tbl_raw_data_clean %>% 
  group_by(date,player,match) %>% 
  summarise(points = sum(points),
            payment = sum(payment),
            games_played = sum(games_played),
            games_soli = sum(games_soli),
            games_bock = sum(games_bock)) %>% 
  arrange(date,
          match,
          desc(points),
          player) %>% 
  group_by(date,match) %>% 
  mutate(position= row_number()) %>% 
  ungroup()

tbl_matchdays_raw_data <-
  tbl_raw_data_clean %>% 
  group_by(date,player) %>% 
  summarise(points = sum(points),
            payment = sum(payment),
            games_played = sum(games_played),
            games_soli = sum(games_soli),
            games_bock = sum(games_bock)) %>% 
  mutate(payment_matchday = if_else(points >= 0,
                                    0,
                                    points) * -10/100) %>% 
  arrange(date,
          desc(points),
          player) %>% 
  group_by(date) %>% 
  mutate(position= row_number()) %>% 
  ungroup()

tbl_matchdays_raw_data %>% view()


tbl_matches_raw_data %>% view()

tbl_player_summary <- 
tbl_raw_data_clean %>% 
  group_by(player) %>%
  summarise(points = sum(points),
            payment = sum(payment),
            games_played = sum(games_played),
            games_soli = sum(games_soli),
            games_bock = sum(games_bock),
            matchdays = n_distinct(date),
            date_first = min(date),
            date_last = max(date)) %>%
  mutate(points_per_game = points/games_played) %>% 
  mutate(diff_days_min_max = as.numeric(date_last-date_first)+1) %>% 
  left_join(tbl_matchdays_raw_data %>%
              group_by(player) %>% 
              summarise(payment_matchday = sum(payment_matchday),
                        victories_matchday = sum(position == 1)),
            by = join_by(player)) %>% 
  left_join(tbl_matches_raw_data %>%
              group_by(player) %>% 
              summarise(matches = n(),
                        victories_match = sum(position == 1)),
            by = join_by(player)) %>%
  mutate(across(where(is.numeric), ~ replace_na(., 0))) %>% 
  mutate(across(where(is.numeric), ~ round(., 2))) %>% 
  ungroup()



tbl_player_summary %>% 
  summarise(player_n = n_distinct(player))
  




tbl_player_summary %>% glimpse()


output$chart_points <- renderPlotly({ 
  plot_ly(hoverlabel = list(align = "left")) %>% 
    add_trace(data=tbl_player_summary,
              x = ~player,
              y = ~points,
              type = 'bar',
              marker = list(color = if_else(tbl_player_summary$points>= 0,
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

output$chart_points <- renderPlotly({ 
  plot_ly(hoverlabel = list(align = "left")) %>% 
    add_trace(data=tbl_player_summary,
              x = ~player,
              y = ~points_per_game,
              type = 'bar',
              marker = list(color = if_else(tbl_player_summary$points>= 0,
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

























tbl_matches_raw_data %>%
  filter(position == 1) %>% 
  group_by(player) %>% 
  tally()






tbl_match_summary_by_player <-
  tbl_raw_data_clean %>%
  group_by(date,
           match,
           player) %>%
  summarise(points = sum(points),
            games_played = sum(games_played),
            games_soli = sum(games_soli))

# Options
vec_matchdays_available <-
tbl_raw_data_clean %>% 
  distinct(date) %>% 
  arrange(desc(date)) %>% 
  pull()


input <-
  list(season = 2024,
       player = "Felix",
       player_analysis_y_axis = "points_total")




tbl_matchday_summary_by_player <-
tbl_raw_data_clean %>% 
  filter(season %in% input$season) %>% 
  group_by(date,
           player) %>% 
  summarise(points = sum(points)) %>% 
  group_by(player) %>%
  arrange(player,date) %>%
  mutate(points_total = cumsum(points)) %>% 
  ungroup() %>% 
  complete(date,
           player) %>% 
  group_by(player) %>%
  fill(points_total,
       .direction = "down") %>% 
  filter(!is.na(points_total)) %>% 
  group_by(date) %>%
  arrange(date,
          desc(points_total),
          desc(points)) %>%
  mutate(position = row_number()) %>% 
  ungroup() %>% 
  mutate(position_reverse = max(position)+ 1 -position)


plot_ly(data = tbl_matchday_summary_by_player, #%>% 
                 #filter(spieler_in %in% vec_spielerinnen_available[1:4]),
               x = ~date,
               y = ~position_reverse, 
               color = ~player,
               type = 'scatter', 
               mode = 'lines') %>% 
  layout(#plot_bgcolor='#e5ecf6',
    yaxis = list(#zerolinewidth = 2,
      rangemode="tozero"))


plot_ly(data = tbl_matchday_summary_by_player %>% 
          filter(!player %in% input$player),
        #filter(spieler_in %in% vec_spielerinnen_available[1:4]),
        x = ~date,
        y = ~position*-1,
        #y = ~position_reverse, 
        color = ~player,
        type = 'scatter', 
        mode = 'lines',
        line = list(color = list_colors_tableau_10$grey,
                    width = 2)) %>% 
  add_trace(data = tbl_matchday_summary_by_player %>% 
              filter(player %in% input$player),
            line = list(color = list_colors_tableau_10$blue,
                        width = 2)) %>% 
  layout(title = paste0("Position of ",
                        input$player)  ,
         yaxis = list(title= "Position",
                      # categoryorder = "array",
                      # categoryarray  = ~position,
                      # tickvals = ~position,
                      # minor = list(tickmode = "array",
                      #              tickvals = ~position),
                      rangemode="tozero"),
         xaxis = list(title= ""))







input <-
  list(season = 2024,
       player = "Mo",
       player_analysis_y_axis = "points_total")


tbl_data_of_selected_player_by_date <-
  tbl_raw_data_clean %>% 
  filter(season %in% input$season) %>% 
  filter(player %in% input$player) %>% 
  group_by(date) %>% 
  summarise(points = sum(points),
            matches = n(),
            games_n = sum(games_n),
            games_bock = sum(games_bock),
            games_played = sum(games_played),
            games_suspended = sum(games_suspended),
            games_soli = sum(games_soli)) %>% 
  arrange(date) %>% 
  mutate(points_total = cumsum(points)) %>% 
  ungroup() %>% 
  mutate(points_color = if_else(points>=0,
                                list_colors_tableau_10$green,
                                list_colors_tableau_10$red))




plot_ly(data = tbl_data_of_selected_player_by_date,
        x = ~date) %>% 
  add_trace(y = ~points_total,
            type = 'scatter', 
            mode = 'lines',
            line = list(color = list_colors_tableau_10$teal,
                        width = 2),
            name = "Total") %>% 
  add_trace(y = ~points,  
            type = 'bar',
            marker = list(color = ~points_color),
            name = "Matchday")%>% 
  layout(title = input$player,
         yaxis = list(title= "Points"),
         xaxis = list(title= "",
                      range= c(as.Date(paste0(min(input$season),
                                              "-01-01")),
                               Sys.Date())))








  
  








tbl_matchday_summary_by_player %>% 
max(df$Position) + 1 - df$Position


tbl_matchday_summary_by_player %>% view()

tbl_spielerin_spieltag_summary <-
  tbl_spielerin_spieltag_summary %>% 
  left_join(.,
            tbl_spielerin_spieltag_summary %>% 
              distinct(position) %>% 
              arrange(desc(position)) %>% 
              mutate(position_reverse = row_number()),
            by="position")

selected_season <- c(2021,2022)
selected_season <- c(2023)

tbl_all_data_selected_season <-
  tbl_all_data %>%
  filter(season %in% selected_season)



# Zusammenfassung Spielerin
tbl_spielerin_summary <-
  tbl_all_data_selected_season %>%
  group_by(spieler_in) %>% 
  summarise(spieltag_erster = min(datum),
            spieltage = n_distinct(datum),
            spiele = sum(spielrunden_am_abend)-sum(spielrunden_ausgesetzt),
            bockrunden = sum(bockrunden_am_abend),
            soli = sum(soli_gespielt_anzahl),
            punkte = sum(punkte),
            einzahlung = sum(einzahlung)) %>% 
  mutate(punkte_pro_spiel = round(punkte/spiele,2)) %>% 
  ungroup()

# Zusammenfassung Spieltag
tbl_spieltag_summary <-
  tbl_all_data_selected_season %>% 
  group_by(datum,spiel) %>% 
  summarise(spiele = max(spielrunden_am_abend),
            bockrunden_am_abend = max(bockrunden_am_abend),
            spieler_in = n_distinct(spieler_in),
            einzahlung = sum(einzahlung)) %>% 
  full_join(.,
            tbl_all_data_selected_season %>% 
              group_by(datum,spiel) %>% 
              filter(punkte == max(punkte)) %>% 
              summarise(siegerin_punkte = unique(punkte), 
                        siegerin_name = toString(unique(spieler_in))),
            by=c("datum","spiel")) %>% 
  full_join(.,
            tbl_all_data_selected_season %>% 
              group_by(datum,spiel) %>% 
              filter(punkte <0) %>% 
              summarise(minuspunkte_sum = sum(punkte)),
            by=c("datum","spiel")) %>% 
  full_join(.,
            tbl_all_data_selected_season %>% 
              group_by(datum,spiel) %>% 
              filter(punkte == min(punkte)) %>% 
              summarise(loserin_punkte = unique(punkte), 
                        loserin_name = toString(unique(spieler_in))),
            by=c("datum","spiel")) %>% 
  ungroup()


# add spieltagssiege to tbl_spielerin_summary
tbl_spielerin_summary<-
  tbl_spielerin_summary %>% 
  left_join(.,
            tbl_spieltag_summary %>% 
              group_by(spieler_in=siegerin_name) %>% 
              summarise(spieltagssiege = n()),
            by="spieler_in") %>%
  mutate_if(is.numeric , replace_na, replace = 0)



# tbl kennzahlen 

# spieltags zusammenfassung 
tbl_kennzahlen <-
  tbl_spieltag_summary %>% 
  ungroup() %>% 
  summarise(spieltag_n = n(),
            spieltage_letzte = max(datum),
            spiele_n = sum(spiele),
            bockrunden_n = sum(bockrunden_am_abend),
            minuspunkte_sum = sum(minuspunkte_sum),
            einzahlung_total = sum(einzahlung)
  )

# siegerinnen 
tbl_kennzahlen <-
  tbl_spieltag_summary %>% 
  group_by(siegerin_name) %>% 
  tally() %>% 
  filter(n == max(n)) %>% 
  ungroup() %>% 
  summarise(spielerin_siege_max_n = unique(n),
            spielerin_siege_max_name = toString(unique(siegerin_name))) %>% 
  bind_cols(tbl_kennzahlen,
            .)

# summary spielerinnen 
COLUMN_NAMES_FOR_SUMMARY <- c("spiele",
                              "punkte",
                              "punkte_pro_spiel",
                              "soli",
                              "bockrunden",
                              "spieltag_erster")

for (COLUMN_NAME in COLUMN_NAMES_FOR_SUMMARY) {
  temp <-
    tbl_spielerin_summary %>%
    filter(.data[[COLUMN_NAME]] == max(.data[[COLUMN_NAME]])) %>%
    summarise(a = unique(.data[[COLUMN_NAME]]),
              b = toString(spieler_in))
  
  names(temp) <- c(paste0(COLUMN_NAME,"_max_n"),
                   paste0(COLUMN_NAME,"_max_name"))
  tbl_kennzahlen <-
    bind_cols(tbl_kennzahlen,
              temp)
  
}

# add count of players 
tbl_kennzahlen <-
  tbl_kennzahlen %>% 
  bind_cols(.,
            tbl_spielerin_summary %>% 
              summarise(spielerin_n = n()))


# Options ---------------------------------------------------------------------

vec_spielerinnen_available<-
  tbl_spielerin_spieltag_summary %>% 
  distinct(spieler_in) %>% 
  pull()


