# Required Data ----------------------------------------------------------------

# Data 
# tbl_player_summary()
# tbl_matches()

# Inputs -----------------------------------------------------------------------

observeEvent(
  tbl_matches(),
  updateSelectInput(session,
                    inputId = "matchday",
                    choices = tbl_matches() %>%
                      distinct(date) %>%
                      pull() %>% 
                      as.character(),
                    selected = tbl_matches() %>%
                      distinct(date) %>%
                      head(1) %>% 
                      pull() %>% 
                      as.character())
  )


observeEvent(
  input$matchday,
  {
    selected_date <- 
      as.Date(input$matchday, format = "%Y-%m-%d")
    
    vec_choices <- 
      tbl_matches() %>%
      filter(date == selected_date) %>%
      distinct(match) %>%
      pull()
    
    updateSelectInput(session,
                      inputId = "match",
                      choices = vec_choices,
                      selected = vec_choices[1])
  }
)

# Detailed player analysis -----------------------------------------------------

output$reactable_match_selection <- renderReactable({
  tbl_matches() %>%
    filter(date == input$matchday) %>%
    filter(match == input$match) %>%
    select(player,
           position,
           points,
           payment,
           games = games_played,
           soli = games_soli) %>%
    reactable(.,
              compact = TRUE,
              defaultPageSize = 15,
              columns = list(
                points = colDef(cell = data_bars(.,
                                                 text_position = "above",
                                                 fill_color = c(list_colors_tableau_10$red,
                                                                list_colors_tableau_10$green))) %>% 
                  google_font("Montserrat")
              ))
})

# Pictures ---------------------------------------------------------------------

output$image_match <- renderImage({
  # Download image 
  temp_file <- tempfile(fileext = ".jpg")
  
  drive_download(as_id(input$image_google_id),
                 path = temp_file, 
                 overwrite = TRUE)
  
  # Show image 
  list(src = temp_file,
       contentType = "image/jpeg",
       width = '100%',
       height = '500px')
}, 
deleteFile = TRUE)

# Calendar ---------------------------------------------------------------------

# Data ----

tbl_calendar_data <-
  bind_rows(tbl_pictures_in_folder %>%
              mutate(date_name = str_sub(name,1,10) %>% 
                       str_replace_all(.,"_","-") %>% 
                       as.Date(.)) %>%
              mutate(date_createdTime = str_sub(createdTime,1,10) %>% 
                       as.Date(.)) %>%
              mutate(start = if_else(!is.na(date_name),
                                     date_name,
                                     date_createdTime)) %>% 
              mutate(end = start) %>% 
              mutate(category = "allday",
                     title = name,
                     backgroundColor = list_colors_tableau_10$teal,
                     color = "white",
                     borderColor = list_colors_tableau_10$teal),
            tbl_raw_data_clean %>% 
              group_by(date) %>% 
              summarise(payment = sum(payment),
                        player_n = n_distinct(player),
                        player_names = toString(unique(player))) %>%
              ungroup() %>% 
              arrange(date) %>% 
              mutate(matchday_num = row_number()) %>% 
              mutate(title = paste("Matchday",
                                   matchday_num),
                     start = date,
                     end = date,
                     category = "allday",
                     backgroundColor = list_colors_tableau_10$blue,
                     color = "white",
                     borderColor = list_colors_tableau_10$blue,
                     body = paste0("Player (",
                                   player_n,
                                   "): ",
                                   player_names,
                                   "<br> Payment:",
                                   payment,
                                   " €"))
  )

# Chart ----

output$calendar <- renderCalendar({
  calendar(tbl_calendar_data, 
           navigation = TRUE,
           defaultDate = Sys.Date()) %>%
    cal_month_options(
      startDayOfWeek  = 1, 
      narrowWeekend = FALSE) %>% 
    google_font("Montserrat")
})
