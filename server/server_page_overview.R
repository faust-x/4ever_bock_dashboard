# Available Data 

# tbl_all_data_selected_season %>% view()
# tbl_spieltag_summary %>% view()
# tbl_spielerin_summary() %>% view()
# tbl_kennzahlen %>%  t()

# Value Boxes ------------------------------------------------------------------
#subtitle = p(tbl_kennzahlen$spieltag_n, style = "color:white; font-size:20px"),

output$infobox_overview_spieltage <- renderInfoBox({
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


output$infobox_overview_einzahlung <- renderInfoBox({
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

output$infobox_overview_spieltag_letzter <- renderInfoBox({
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

output$infobox_overview_meisten_punkte <- renderInfoBox({
  infoBox(title= "Meisten Punkte " %>% paste0(.,
                                            "(",
                                            tbl_kennzahlen()$punkte_max_n,
                                            ")"),
          value = tbl_kennzahlen()$punkte_max_name,
          icon = icon(name ="medal",
                      lib = "font-awesome"), 
          color = "primary",
          fill = TRUE,
          elevation = 1,
          iconElevation = 3,
          gradient = TRUE
  )
})




# Charts -----------------------------------------------------------------------

# Punkte ----

output$chart_punkte <- renderPlotly({ 
plot_ly() %>% 
  add_trace(data=tbl_spielerin_summary(),
            x = ~spieler_in,
            y = ~punkte,
            name = "Punkte (gesamt)",
            type = 'bar',
            marker = list(color = if_else(tbl_spielerin_summary()$punkte>= 0,
                                          "#6a9f58",
                                          "#d1615d")),
            text=~punkte,
            textfont=list(color="white"),
            textposition = 'auto',
            hovertemplate = paste0("Spieler:in<b>: ",tbl_spielerin_summary()$spieler_in,"</b><br><br>",
                                   "-Spieltage: ",tbl_spielerin_summary()$spieltage,"<br>",
                                   "-Spiele: ",tbl_spielerin_summary()$spiele,"<br>",
                                   "-Spieltagssiege: ",tbl_spielerin_summary()$spieltagssiege,"<br>",
                                   "-Punkte: <b>",tbl_spielerin_summary()$punkte,"</b><br>",
                                   "-Punkte pro Spiel: ",tbl_spielerin_summary()$punkte_pro_spiel,"<br>",
                                   "-Soli: ",tbl_spielerin_summary()$soli,"<br>",
                                   "<extra></extra>")) %>% 
  layout(title = list(text = "<b>Punkte nach Spieler:in</b>", 
                      font= list(size = 24,
                                 family = "calibri"),
                      y = 0.98),
         font = list(family = "calibri",size = 18),
         separators = ',',
         yaxis = list(title = "Punkte",
                      ticksuffix = ""),
         xaxis = list(title = list(text = "", standoff = 3),
                      categoryorder = "total descending",
                      zeroline = FALSE),
         legend = list(orientation = 'h'))
})




# Durchschnittliche Punkte pro Spiel ----

output$chart_punkte_pro_spiel <- renderPlotly({ 
plot_ly() %>% 
  add_trace(data=tbl_spielerin_summary(),
            x = ~spieler_in,
            y = ~punkte_pro_spiel,
            name = "Punkte (gesamt)",
            type = 'bar',
            marker = list(color = if_else(tbl_spielerin_summary()$punkte_pro_spiel>= 0,
                                          "#6a9f58",
                                          "#d1615d")),
            text=~punkte_pro_spiel,
            textfont=list(color="white"),
            textposition = 'auto',
            hovertemplate = paste0("Spieler:in<b>: ",tbl_spielerin_summary()$spieler_in,"</b><br><br>",
                                   "-Spieltage: ",tbl_spielerin_summary()$spieltage,"<br>",
                                   "-Spiele: ",tbl_spielerin_summary()$spiele,"<br>",
                                   "-Spieltagssiege: ",tbl_spielerin_summary()$spieltagssiege,"<br>",
                                   "-Punkte: ",tbl_spielerin_summary()$punkte,"<br>",
                                   "-Punkte pro Spiel:<b> ",tbl_spielerin_summary()$punkte_pro_spiel,"</b><br>",
                                   "-Soli: ",tbl_spielerin_summary()$soli,"<br>",
                                   "<extra></extra>")) %>% 
  layout(title = list(text = "<b>Durchschnittliche Punkte pro Spiel nach Spieler:in</b>", 
                      font= list(size = 24,
                                 family = "calibri"),
                      y = 0.98),
         font = list(family = "calibri",size = 18),
         separators = ',',
         yaxis = list(title = "Punkte",
                      ticksuffix = ""),
         xaxis = list(title = list(text = "", standoff = 3),
                      categoryorder = "total descending",
                      zeroline = FALSE),
         legend = list(orientation = 'h'))
})



# Anzahl der Spiele ----

output$chart_anzahl_spiele <- renderPlotly({ 
plot_ly() %>% 
  add_trace(data= tbl_spielerin_summary(),
            x = ~spieler_in,
            y = ~spiele,
            name = "Anzahl der Spiele",
            type = 'bar',
            marker = list(color = "#85b6b2"),
            text=~spiele,
            textfont=list(color="white"),
            textposition = 'auto',
            hovertemplate = paste0("Spieler:in<b>: ",tbl_spielerin_summary()$spieler_in,"</b><br><br>",
                                   "-Spieltage: ",tbl_spielerin_summary()$spieltage,"<br>",
                                   "-Spiele: <b> ",tbl_spielerin_summary()$spiele,"</b><br>",
                                   "-Spieltagssiege: ",tbl_spielerin_summary()$spieltagssiege,"<br>",
                                   "-Punkte: ",tbl_spielerin_summary()$punkte,"<br>",
                                   "-Punkte pro Spiel: ",tbl_spielerin_summary()$punkte_pro_spiel,"<br>",
                                   "-Soli: ",tbl_spielerin_summary()$soli,"<br>",
                                   "<extra></extra>")) %>% 
  layout(title = list(text = "<b>Spiele nach Spieler:in</b>", 
                      font= list(size = 24,
                                 family = "calibri"),
                      y = 0.98),
         font = list(family = "calibri",size = 18),
         separators = ',',
         yaxis = list(title = "Spiele",
                      ticksuffix = ""),
         xaxis = list(title = list(text = "", standoff = 3),
                      categoryorder = "total descending",
                      zeroline = FALSE),
         legend = list(orientation = 'h'))
})


# Anzahl der Spieltagssiege ---- 

output$chart_spieltagssiege <- renderPlotly({ 
plot_ly() %>% 
  add_trace(data= tbl_spielerin_summary(),
            x = ~spieler_in,
            y = ~spieltagssiege,
            name = "Anzahl der Spieltagssiege",
            type = 'bar',
            marker = list(color = "#85b6b2"),
            text=~spieltagssiege,
            textfont=list(color="white"),
            textposition = 'auto',
            transforms = list(list(type = 'filter',
                                   target = ~spieltagssiege,
                                   operation = '>',
                                   value = 0)),
            hovertemplate = paste0("Spieler:in<b>: ",tbl_spielerin_summary()$spieler_in,"</b><br><br>",
                                   "-Spieltage: ",tbl_spielerin_summary()$spieltage,"<br>",
                                   "-Spiele: <b> ",tbl_spielerin_summary()$spiele,"</b><br>",
                                   "-Spieltagssiege: ",tbl_spielerin_summary()$spieltagssiege,"<br>",
                                   "-Punkte: ",tbl_spielerin_summary()$punkte,"<br>",
                                   "-Punkte pro Spiel: ",tbl_spielerin_summary()$punkte_pro_spiel,"<br>",
                                   "-Soli: ",tbl_spielerin_summary()$soli,"<br>",
                                   "<extra></extra>")) %>% 
  layout(title = list(text = "<b>Spieltagssiege nach Spieler:in</b>", 
                      font= list(size = 24,
                                 family = "calibri"),
                      y = 0.98),
         font = list(family = "calibri",size = 18),
         separators = ',',
         yaxis = list(title = "Anzahl der Siege",
                      ticksuffix = ""),
         xaxis = list(title = list(text = "", standoff = 3),
                      categoryorder = "total descending",
                      zeroline = FALSE),
         legend = list(orientation = 'h')) 
})


# Anzahl der Soli ----

output$chart_anzahl_soli <- renderPlotly({ 
plot_ly() %>% 
  add_trace(data= tbl_spielerin_summary(),
            x = ~spieler_in,
            y = ~soli,
            name = "Anzahl der Spieltagssiege",
            type = 'bar',
            marker = list(color = "#85b6b2"),
            text=~soli,
            textfont=list(color="white"),
            textposition = 'auto',
            transforms = list(list(type = 'filter',
                                   target = ~soli,
                                   operation = '>',
                                   value = 0)),
            hovertemplate = paste0("Spieler:in<b>: ",tbl_spielerin_summary()$spieler_in,"</b><br><br>",
                                   "-Spieltage: ",tbl_spielerin_summary()$spieltage,"<br>",
                                   "-Spiele: <b> ",tbl_spielerin_summary()$spiele,"</b><br>",
                                   "-Spieltagssiege: ",tbl_spielerin_summary()$spieltagssiege,"<br>",
                                   "-Punkte: ",tbl_spielerin_summary()$punkte,"<br>",
                                   "-Punkte pro Spiel: ",tbl_spielerin_summary()$punkte_pro_spiel,"<br>",
                                   "-Soli: ",tbl_spielerin_summary()$soli,"<br>",
                                   "<extra></extra>")) %>% 
  layout(title = list(text = "<b>Anzahl der Soli nach Spieler:in</b>", 
                      font= list(size = 24,
                                 family = "calibri"),
                      y = 0.98),
         font = list(family = "calibri",size = 18),
         separators = ',',
         yaxis = list(title = "Anzahl der Soli",
                      ticksuffix = ""),
         xaxis = list(title = list(text = "", standoff = 3),
                      categoryorder = "total descending",
                      zeroline = FALSE),
         legend = list(orientation = 'h')) 
})

# Einzahlung nach Spieler:in ----

output$chart_einhalungen <- renderPlotly({ 
plot_ly() %>% 
  add_trace(data= tbl_spielerin_summary(),
            x = ~spieler_in,
            y = ~einzahlung,
            name = "Minuspunkte/Einzahlungen (Soll))",
            type = 'bar',
            marker = list(color = "#5778a4"),
            text= ~paste0(einzahlung," &#8364;"),
            textfont=list(color="white"),
            textposition = 'auto',
            transforms = list(list(type = 'filter',
                                   target = ~soli,
                                   operation = '>',
                                   value = 0)),
            hovertemplate = paste0("Spieler:in<b>: ",tbl_spielerin_summary()$spieler_in,"</b><br><br>",
                                   "-Einzahlung: <b>",tbl_spielerin_summary()$einzahlung," &#8364; </b><br>",
                                   "-Spieltage: ",tbl_spielerin_summary()$spieltage,"<br>",
                                   "-Spiele: ",tbl_spielerin_summary()$spiele,"<br>",
                                   "-Punkte: ",tbl_spielerin_summary()$punkte,"<br>",
                                   "-Soli: ",tbl_spielerin_summary()$soli,"<br>",
                                   "<extra></extra>")) %>% 
  layout(title = list(text = "<b>Einzahlung nach Spieler:in</b>", 
                      font= list(size = 24,
                                 family = "calibri"),
                      y = 0.98),
         font = list(family = "calibri",size = 18),
         separators = ',',
         yaxis = list(title = "Einzahlung in &#8364;",
                      ticksuffix = " &#8364;"),
         xaxis = list(title = list(text = "", standoff = 3),
                      categoryorder = "total descending",
                      zeroline = FALSE
         ),
         legend = list(orientation = 'h'),
         annotations=list(text=paste0("<b>Gesamt: ",tbl_spielerin_summary()$einzahlung %>% sum()," &#8364;</b>"),
                          "showarrow"=F,
                          align = "left",
                          yref = "paper",
                          xref = "paper",
                          x= 0.9,
                          y= 0.9,
                          font = list(size = 22)))
})




