# Data Preparation ----

tbl_raw_data_selected <- reactive({
  tbl_raw_data_clean %>% 
    filter(season %in% input$season)
})

tbl_matches <- reactive({
  tbl_raw_data_selected() %>% 
    group_by(date,player,match) %>% 
    summarise(points = sum(points),
              payment = sum(payment),
              games_n = max(games_n),
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
})

tbl_matches_summary <- reactive({
  tbl_matches() %>% 
    group_by(date,match) %>% 
    summarise(games_n = max(games_n),
              games_bock = max(games_bock),
              payment = sum(payment),
              games_soli = sum(games_soli),
              winner = player[position==1],
              player_n = n_distinct(player)) %>% 
    ungroup()
})


tbl_matchdays_raw_data <- reactive({
  tbl_matches() %>% 
    group_by(date,player) %>% 
    summarise(points = sum(points),
              games_played = sum(games_played),
              games_soli = sum(games_soli),
              games_bock = sum(games_bock)
    ) %>% 
    mutate(payment_matchday = if_else(points >= 0,
                                      0,
                                      points) * -10/100) %>% 
    arrange(date,
            desc(points),
            player) %>% 
    group_by(date) %>% 
    mutate(position= row_number()) %>% 
    ungroup()
})


tbl_player_summary <- reactive({
  tbl_matches() %>%  
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
    left_join(tbl_matchdays_raw_data() %>% # !!!
                group_by(player) %>% 
                summarise(victories_matchday = sum(position == 1)),
              by = join_by(player)) %>% 
    left_join(tbl_matches() %>%
                group_by(player) %>% 
                summarise(matches = n(),
                          victories_match = sum(position == 1)),
              by = join_by(player)) %>%
    mutate(across(where(is.numeric), ~ replace_na(., 0))) %>% 
    mutate(across(where(is.numeric), ~ round(., 2))) %>% 
    ungroup()
})


tbl_matchday_summary_by_player <- reactive({
  tbl_matches() %>% 
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
})



# tbl_raw_data_selected %>% glimpse()
# tbl_matchdays_raw_data %>% glimpse()
# tbl_matches_raw_data %>% glimpse()
# tbl_player_summary %>% glimpse()
# tbl_pictures_in_folder %>% glimpse()

# value box data

tbl_key_values <- reactive({
  tbl_matches_summary() %>% 
    summarise(macthes_n = n(),
              matchdays = n_distinct(date),
              games_n = sum(games_n),
              games_bock = sum(games_bock),
              games_soli = sum(games_soli),
              payment = sum(payment),
              biggest_match = max(player_n),
              first_match_date = min(date)) %>% 
    bind_cols(.,
              tbl_player_summary() %>%
                summarise(player_n = n_distinct(player),
                          most_points_player = toString(player[points== max(points)]),
                          most_points_value = max(points),
                          highest_payment_player = toString(player[payment==max(payment)]),
                          highest_payment_value = max(payment),
                          highest_points_per_game_player = toString(player[points_per_game== max(points_per_game)]),
                          highest_points_per_game_value = max(points_per_game),
                          most_soli_player = toString(player[games_soli== max(games_soli)]),
                          most_soli_value = max(games_soli),
                          most_games_played_player = toString(player[games_played== max(games_played)]),
                          most_games_played_value = max(games_played),
                          most_victories_match_player = toString(player[victories_match== max(victories_match)]),
                          most_victories_match_value = max(victories_match),
                          most_victories_matchday_player = toString(player[victories_matchday== max(victories_matchday)]),
                          most_victories_matchday_value = max(victories_matchday),
                          newest_player_name = toString(player[date_first == max(date_first)]),
                          newest_player_date = max(date_first),
                          last_match_player = toString(player[date_last == max(date_last)]),
                          last_match_date = max(date_last)))
})



# Reacttable 

# matches all
output$reacttable_overview_match_all <- renderReactable({
  
  tbl_raw_data_clean %>% 
    reactable_std()
  
})

# match selection
output$reacttable_overview_match_selection <- renderReactable({
  
  tbl_matches() %>% 
    reactable_std()
  
})

# matchday selection
output$reacttable_overview_matchday_selection <- renderReactable({
  
  tbl_matchdays_raw_data() %>% 
    reactable_std()
  
})

# match summary
output$reacttable_overview_match_summary <- renderReactable({
  
  tbl_matches_summary() %>% 
    reactable_std()
  
})

# player summary
output$reacttable_overview_player_summary <- renderReactable({
  
  tbl_player_summary() %>% 
    reactable_std()
  
})

# tbl_key_values
output$reacttable_overview_key_values <- renderReactable({
  
  tbl_key_values() %>% 
    pivot_longer(data = .,
                 cols = everything(),
                 values_transform = as.character) %>% 
    reactable_std()
  
})

# tbl_key_values
output$reacttable_pictures_all <- renderReactable({
  
  tbl_pictures_in_folder %>%  
    reactable_std()
  
})





