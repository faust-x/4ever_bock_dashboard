# Available Data 

# tbl_all_data_selected_season %>% view()
# tbl_spieltag_summary %>% view()
# tbl_spielerin_summary %>% view()
# tbl_kennzahlen() %>%  t()

# Value Boxes ------------------------------------------------------------------

# row 1 ----

output$infobox_spieltage <- renderInfoBox({
  infoBox(title= "Spieltage",
          value = tbl_kennzahlen()$spieltag_n,
          icon = icon(name ="calendar-alt",
                      lib = "font-awesome"), 
          color = "primary",
          fill = TRUE,
          elevation = 1,
          iconElevation = 3,
          gradient = TRUE
  )
})

output$infobox_spieltag_letzter <- renderInfoBox({
  infoBox(title= "Letzter Spieltag",
          value = tbl_kennzahlen()$spieltage_letzte %>% format(.,"%d.%m.%y"),
          icon = icon(name ="calendar-day",
                      lib = "font-awesome"), 
          color = "primary",
          fill = TRUE,
          elevation = 1,
          iconElevation = 3,
          gradient = TRUE
  )
})

output$infobox_spiele_n <- renderInfoBox({
  infoBox(title= "Spiele",
          value = tbl_kennzahlen()$spiele_n,
          icon = icon(name ="gamepad",
                      lib = "font-awesome"), 
          color = "primary",
          fill = TRUE,
          elevation = 1,
          iconElevation = 3,
          gradient = TRUE
  )
})

output$infobox_bockrunden <- renderInfoBox({
  infoBox(title= "Bockrunden",
          value = tbl_kennzahlen()$bockrunden_n,
          icon = icon(name ="horse",
                      lib = "font-awesome"), 
          color = "primary",
          fill = TRUE,
          elevation = 1,
          iconElevation = 3,
          gradient = TRUE
  )
})

# row 2 ----

output$infobox_meisten_punkte <- renderInfoBox({
  infoBox(title= "Meisten Punkte " %>% paste0(.,
                                              "(",
                                              tbl_kennzahlen()$punkte_max_n,
                                              ")"),
          value = tbl_kennzahlen()$punkte_max_name,
          icon = icon(name ="flag-checkered",
                      lib = "font-awesome"), 
          color = "primary",
          fill = TRUE,
          elevation = 1,
          iconElevation = 3,
          gradient = TRUE
  )
})

output$infobox_meisten_punkte_pro_spiel <- renderInfoBox({
  infoBox(title= "Meisten Punkte pro Spiel" %>% paste0(.,
                                              "(",
                                              tbl_kennzahlen()$punkte_pro_spiel_max_n,
                                              ")"),
          value = tbl_kennzahlen()$punkte_pro_spiel_max_name,
          icon = icon(name ="balance-scale",
                      lib = "font-awesome"), 
          color = "primary",
          fill = TRUE,
          elevation = 1,
          iconElevation = 3,
          gradient = TRUE
  )
})

output$infobox_meisten_soli <- renderInfoBox({
  infoBox(title= "Meisten Soli" %>% paste0(.,
                                                       "(",
                                                       tbl_kennzahlen()$soli_max_n,
                                                       ")"),
          value = tbl_kennzahlen()$soli_max_name,
          icon = icon(name ="street-view",
                      lib = "font-awesome"), 
          color = "primary",
          fill = TRUE,
          elevation = 1,
          iconElevation = 3,
          gradient = TRUE
  )
})

#infobox_meisten_siege

output$infobox_meisten_siege <- renderInfoBox({
  infoBox(title= "Meisten Siege" %>% paste0(.,
                                           "(",
                                           tbl_kennzahlen()$spielerin_siege_max_n,
                                           ")"),
          value = tbl_kennzahlen()$spielerin_siege_max_name,
          icon = icon(name ="crown",
                      lib = "font-awesome"), 
          color = "primary",
          fill = TRUE,
          elevation = 1,
          iconElevation = 3,
          gradient = TRUE
  )
})

# row 3 ----


output$infobox_spielerinnen_n <- renderInfoBox({
  infoBox(title= "Anzahl Spieler:innen",
          value = tbl_kennzahlen()$spielerin_n,
          icon = icon(name ="users",
                      lib = "font-awesome"), 
          color = "primary",
          fill = TRUE,
          elevation = 1,
          iconElevation = 3,
          gradient = TRUE
  )
})

output$infobox_neuste_spielerin <- renderInfoBox({
  infoBox(title= "Neuster Doppelkopf",
          value = tbl_kennzahlen()$spieltag_erster_max_name,
          subtitle = paste0("Dabei seit ",
                            format(tbl_kennzahlen()$spieltag_erster_max_n,
                                   "%d.%m.%y")),
          icon = icon(name ="user-plus",
                      lib = "font-awesome"), 
          color = "primary",
          fill = TRUE,
          elevation = 1,
          iconElevation = 3,
          gradient = TRUE
  )
})



# ---------------------------------------------------------



output$infobox_einzahlung <- renderInfoBox({
  infoBox(title= "Einzahlung (Soll)",
          value = tbl_kennzahlen()$einzahlung_total %>% paste0(.,"€"),
          icon = icon(name ="euro",
                      lib = "glyphicon"), 
          color = "primary",
          fill = TRUE,
          elevation = 1,
          iconElevation = 3,
          gradient = TRUE
  )
})