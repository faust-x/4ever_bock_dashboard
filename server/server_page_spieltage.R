
#tbl_all_data_selected_season %>% glimpse()

# tbl_spieltag_summary %>% 
#   distinct(datum) %>% 
#   arrange(desc(datum)) %>% 
#   pull() %>% 
#   as.character() %>% class()
# 
# tbl_spieltag_summary %>% 
#   filter(datum == max(datum)) %>%
#   distinct(datum) %>% 
#   pull() %>% 
#   as.character() %>% class()

output$reactable_spieltag <- renderReactable({
  tbl_all_data_selected_season() %>%
    mutate(datum= as.character(datum)) %>% 
     filter(datum == input$choices_spieltage) %>% 
    #filter(datum == "2023-02-15") %>% 
  mutate(Spiele = spielrunden_am_abend - spielrunden_ausgesetzt) %>% 
  select(Spieler_in = spieler_in,
         Punkte = punkte,
         Spiele,
         Soli = soli_gespielt_anzahl) %>% 
  arrange(desc(Punkte)) %>% 
  reactable(.,
            striped = TRUE,
            fullWidth = FALSE,
            resizable = TRUE,
            defaultPageSize = 15,
            theme = reactableTheme(
              color = "#000000"),
            columns = list(
              Punkte = colDef(cell = data_bars(.,
                                               text_position = "above",
                                               fill_color = c("#d1615d","#6a9f58"))
                                               )
            ))
})


# Spieltagsfoto

image_url <- reactive({
drive_ls(path = "4everBock-Eherenbilder",
         pattern = str_replace_all(input$choices_spieltage,"-","_"),
          type = c("jpg", "jpeg", "image/gif")) %>%
  slice_head(n = 1) %>%
  select(id) %>%
  pull() %>%
  as.character() %>%
  paste0("https://drive.google.com/uc?export=view&id=",.)
})


output$image_spieltag<-renderUI({img(src=image_url(),
                                     width = '400px',
                                     height = '500px')})



