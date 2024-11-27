# UI ---------------------------------------------------------------------------
page_ui_player <- 
  page_fluid(uiOutput("value_box_row_player_01"),
             navset_card_tab(full_screen = TRUE,
                             title = "Charts",
                             sidebar = sidebar(selectInput("player",
                                                           label = p("Select player",
                                                                     style = 'color: black;'),
                                                           choices = options_season,
                                                           multiple = F,
                                                           selected = max(options_season))),
                             height = 600,
                             nav_panel(title = "Points",
                                       plotlyOutput("chart_player_points")),
                             nav_panel(title = "Position",
                                       plotlyOutput("chart_player_position"))
                             )
             ) 