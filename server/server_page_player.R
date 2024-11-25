# Required Data ----------------------------------------------------------------

# Data 
# tbl_player_summary()

# Inputs -----------------------------------------------------------------------

observeEvent(
  tbl_player_summary(),
  updateSelectInput(session,
                    inputId = "player",
                    choices = tbl_player_summary() %>% 
                      distinct(player) %>% 
                      pull(),
                    selected = tbl_player_summary() %>% 
                      head(1) %>% 
                      distinct(player) %>% 
                      pull())
  )


# Detailed player analysis -----------------------------------------------------

# Data ----

tbl_data_of_selected_player_by_date <- reactive({
  tbl_matches() %>%
  filter(player %in% input$player) %>%
  group_by(date) %>%
  summarise(points = sum(points),
            payment = sum(payment),
            matches = n(),
            games_n = sum(games_n),
            games_bock = sum(games_bock),
            games_played = sum(games_played),
            games_soli = sum(games_soli)) %>%
    bind_rows(tibble(date = as.Date(paste0(min(input$season),
                                           "-01-01")),
                     points = 0,
                     points_total = 0)) %>% 
  arrange(date) %>%
  mutate(points_total = cumsum(points)) %>%
  ungroup() %>%
  mutate(points_color = if_else(points>=0,
                                list_colors_tableau_10$green,
                                list_colors_tableau_10$red)) 
})

# Value boxes ------------------------------------------------------------------

# Value box row 01 ----

output$value_box_row_player_01 <- renderUI({
  
  # Data 
  data <-
  tbl_player_summary() %>% 
    filter(player %in% input$player)
  
  # Points
  box_01 <-
    value_box(
      fill = TRUE,
      title = toupper("Points"),
      value = data$points,
      showcase = fa_value_box("star"),
      theme = "primary")
  
  # Payment
  box_02 <-
    value_box(
      fill = TRUE,
      title = toupper("Payment"),
      value = paste0(data$payment," €"),
      showcase = fa_value_box("file-invoice-dollar"),
      theme = "primary")
  
  # Games Player
  box_03 <-
    value_box(
      fill = TRUE,
      title = toupper("Games"),
      value = data$games_played,
      showcase = fa_value_box("gamepad"),
      theme = "primary")
  
  # Soli
  box_04 <-
    value_box(
      fill = TRUE,
      title = toupper("Soli"),
      value = data$games_soli,
      showcase = fa_value_box("person-rays"),
      theme = "primary")
  
  layout_column_wrap(width = 1/4,
                     heights_equal = "row",
                     fill = FALSE,
                     box_01,
                     box_02,
                     box_03,
                     box_04
                     )
})


# Charts -----------------------------------------------------------------------

# Points ----
output$chart_player_points <- renderPlotly({
  plot_ly(hoverlabel = list(align = "left"),
    data = tbl_data_of_selected_player_by_date(),
          x = ~date) %>%
    add_trace(y = ~points_total,
              type = 'scatter',
              mode = 'lines',
              line = list(color = list_colors_tableau_10$teal,
                          width = 3),
              name = "Total") %>%
    add_trace(y = ~points,
              type = 'bar',
              marker = list(color = ~points_color),
              name = "Matchday") %>%
    layout(title = list(text = paste0 ("<b> Points of ",input$player,"</b>"),
                        font= list(size = list_plotly_default$font_title_size),
                        y = list_plotly_default$font_title_y_position),
           font = list(family = list_plotly_default$font_family,
                       size = list_plotly_default$font_body_size),
           font = list(family = list_plotly_default$font_family),
           yaxis = list(title = "Points"),
           xaxis = list(title = ""),
           legend = list(orientation = 'h'))
})

# Position ----
output$chart_player_position <- renderPlotly({
  plot_ly(hoverlabel = list(align = "left"),
          data = tbl_matchday_summary_by_player() %>%
            filter(!player %in% input$player),
          x = ~date,
          y = ~position_reverse,
          color = ~player,
          line = list(color = list_colors_tableau_10$grey,
                      width = 2),
          type = 'scatter',
          mode = 'lines',
          hovertemplate = ~paste0("Player<b>: ",player,"</b><br><br>",
                                  "-Date: ",date,"<br>",
                                  "-Position: <b>",position,"</b><br>",
                                  "-Points:",
                                  "<br>  -Today: ",points,
                                  "<br>  -Total: ",points_total,
                                  "<extra></extra>")) %>%
    add_trace(data = tbl_matchday_summary_by_player() %>%
                filter(player %in% input$player),
              line = list(color = list_colors_tableau_10$blue,
                          width = 2)) %>%
    layout(title = list(text = "<b>Position</b>",
                        font= list(size = list_plotly_default$font_title_size),
                        y = list_plotly_default$font_title_y_position),
           font = list(family = list_plotly_default$font_family,
                       size = list_plotly_default$font_body_size),
           font = list(family = list_plotly_default$font_family),
           yaxis = list(title = "Position",
                        visible = FALSE),
           xaxis = list(title = "",
                        categoryorder = "total descending"),
           legend = list(orientation = 'h'))
})