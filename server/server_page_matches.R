# Required Data ----------------------------------------------------------------

# Data 
# tbl_player_summary()

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

# observeEvent(
#   input$matchday,
#   updateSelectInput(session,
#                     inputId = "match",
#                     choices = tbl_matches() %>%
#                       filter(date == input$matchday) %>%
#                       distinct(match) %>%
#                       pull(),
#                     selected = tbl_matches() %>%
#                       filter(date == input$matchday) %>%
#                       distinct(match) %>%
#                       head(1) %>%
#                       pull())
# )

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

# tbl_pictures_in_folder %>% 
#   filter(name == input$picture) %>% 
#   pull(url),

#
# 
# URL <- "https://spiele-palast.de/app/uploads/sites/6/2021/09/DE_doko_in-game_v3-1110x694.jpg"
# URL <- "https://drive.usercontent.google.com/download?id=129n_iFW0v5vunDcqEudv7l0KNtveiZ5B"
# URL <- "https://drive.google.com/uc?id=1-5gsjZHvTMWw9ilhhYw3a5Kgf3CrSJEi"
# URL <- "https://drive.usercontent.google.com/download?id=1-5gsjZHvTMWw9ilhhYw3a5Kgf3CrSJEi"
# 
# output$image_match<-renderUI({
#   img(src = URL,
#       width = '100%',
#       height = '500px')
# })



output$image_match <- renderImage({
  # Lade das Bild temporär herunter
  temp_file <- tempfile(fileext = ".jpg")
  
  drive_download(as_id(input$image_google_id),
                 path = temp_file, 
                 overwrite = TRUE)
  
  # Rückgabe für renderImage
  list(src = temp_file,
       contentType = "image/jpeg",
       width = '100%',
       height = '500px')
}, 
deleteFile = TRUE)