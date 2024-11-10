# Available Data 

# tbl_all_data_selected_season %>% view()
# tbl_spieltag_summary %>% view()
# tbl_spielerin_summary %>% view()
# tbl_kennzahlen %>%  t()


tab_Item_page_spieltage <-
  tabItem("page_spieltage",
          fixedRow(
            box(status = "primary",
                title = p("Spieltagsdaten", style = 'color:black;'), #font-size:12px;
                 selectInput("choices_spieltage",
                             "Wähle Spieltag", 
                             choices = tbl_all_data %>% 
                               distinct(datum) %>% 
                               arrange(desc(datum)) %>% 
                               pull() %>% 
                               as.character(),
                             selected = tbl_all_data %>% 
                               filter(datum == max(datum)) %>%
                               distinct(datum) %>% 
                               pull() %>% 
                               as.character()),
                 reactableOutput("reactable_spieltag",
                                 width = '100%')),
            box(status = "primary",
                title = p("Spieltagsfoto", style = 'color:black;'), #font-size:12px;
                uiOutput(outputId = "image_spieltag"))
          )
  )
        
        
#         ,
#         fixedRow(box(status = "teal",
#                      title = "Vergleich der Spieler:innen",
#                      width = 12,
#                      box( status = "teal",
#                           title = "1. Spieler:in",
#                           width = 6,
#                           selectInput("choice_player_1",
#                                       "Wähle Spieler:in", 
#                                       choices = tbl_all_data %>% distinct(spieler_in) %>% pull(),
#                                       selected = "Nadine"),
#                           valueBoxOutput("value_box_player_1_Score",
#                                          width = 12),
#                           valueBoxOutput("value_box_player_1_spiele_n",
#                                          width = 12),
#                           valueBoxOutput("value_box_player_1_punkte_pro_spiel",
#                                          width = 12),
#                           valueBoxOutput("value_box_player_1_soli",
#                                          width = 12)
#                      ),
#                      box(status = "teal",
#                          title = "2. Spieler:in",
#                          width = 6,
#                          selectInput("choice_player_2",
#                                      "Wähle Spieler:in", 
#                                      choices = tbl_all_data %>% distinct(spieler_in) %>% pull(),
#                                      selected = "Eric"),
#                          valueBoxOutput("value_box_player_2_Score",
#                                         width = 12),
#                          valueBoxOutput("value_box_player_2_spiele_n",
#                                         width = 12),
#                          valueBoxOutput("value_box_player_2_punkte_pro_spiel",
#                                         width = 12),
#                          valueBoxOutput("value_box_player_2_soli",
#                                         width = 12))
#         ))
# )