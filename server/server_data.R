# selected_season <- c(2021,2022)
# selected_season <- c(2023)
# 
# tbl_all_data_selected_season <-
# tbl_all_data %>%
#   filter(season %in% selected_season)


tbl_spielerin_spieltag_summary <-
  tbl_all_data %>%
  filter(datum >="2023-01-01") %>% 
  group_by(datum,spieler_in) %>% 
  summarise(punkte = sum(punkte,
                         na.rm = TRUE)) %>% 
  group_by(spieler_in) %>%
  arrange(spieler_in,datum) %>%
  mutate(punkte_total = cumsum(punkte)) %>% 
  ungroup() %>% 
  complete(spieler_in,datum) %>% 
  group_by(spieler_in) %>%
  fill(punkte_total,
       .direction = "down") %>% 
  filter(!is.na(punkte_total)) %>% 
  group_by(datum) %>%
  arrange(datum,
          desc(punkte_total),
          desc(punkte)) %>%
  mutate(position = row_number()) %>% 
  ungroup()

tbl_spielerin_spieltag_summary <-
  tbl_spielerin_spieltag_summary %>% 
  left_join(.,
            tbl_spielerin_spieltag_summary %>% 
              distinct(position) %>% 
              arrange(desc(position)) %>% 
              mutate(position_reverse = row_number()),
            by="position")


vec_spielerinnen_available<-
  tbl_spielerin_spieltag_summary %>% 
  distinct(spieler_in) %>% 
  pull()





fig <- plot_ly(data = tbl_spielerin_spieltag_summary %>% 
                 filter(spieler_in %in% vec_spielerinnen_available[1:4]),
               x = ~datum,
               y = ~position_reverse, 
               color = ~spieler_in,
               type = 'scatter', 
               mode = 'lines') %>% 
  layout(#plot_bgcolor='#e5ecf6',
    yaxis = list(#zerolinewidth = 2,
      rangemode="tozero"))


fig



tbl_all_data_selected_season <- reactive({
  tbl_all_data %>%
  filter(season %in% input$input_season)
})


# Zusammenfassung Spielerin
tbl_spielerin_summary_temp <- reactive({
tbl_all_data_selected_season() %>%
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
})

# Zusammenfassung Spieltag
tbl_spieltag_summary <- reactive({
tbl_all_data_selected_season() %>% 
  group_by(datum,spiel) %>% 
  summarise(spiele = max(spielrunden_am_abend),
            bockrunden_am_abend = max(bockrunden_am_abend),
            spieler_in = n_distinct(spieler_in),
            einzahlung = sum(einzahlung)) %>% 
  full_join(.,
            tbl_all_data_selected_season() %>% 
              group_by(datum,spiel) %>% 
              filter(punkte == max(punkte)) %>% 
              summarise(siegerin_punkte = unique(punkte), 
                        siegerin_name = toString(unique(spieler_in))),
            by=c("datum","spiel")) %>% 
  full_join(.,
            tbl_all_data_selected_season() %>% 
              group_by(datum,spiel) %>% 
              filter(punkte <0) %>% 
              summarise(minuspunkte_sum = sum(punkte)),
            by=c("datum","spiel")) %>% 
  full_join(.,
            tbl_all_data_selected_season() %>% 
              group_by(datum,spiel) %>% 
              filter(punkte == min(punkte)) %>% 
              summarise(loserin_punkte = unique(punkte), 
                        loserin_name = toString(unique(spieler_in))),
            by=c("datum","spiel")) %>% 
  ungroup() })


# add spieltagssiege to tbl_spielerin_summary
tbl_spielerin_summary <- reactive({
tbl_spielerin_summary_temp() %>% 
  left_join(.,
            tbl_spieltag_summary() %>% 
              group_by(spieler_in=siegerin_name) %>% 
              summarise(spieltagssiege = n()),
            by="spieler_in") %>%
  mutate_if(is.numeric , replace_na, replace = 0)
})
  


# tbl kennzahlen 

tbl_kennzahlen <- reactive({
bind_cols(
  tbl_spieltag_summary() %>% 
    ungroup() %>% 
    summarise(spieltag_n = n(),
              spieltage_letzte = max(datum),
              spiele_n = sum(spiele),
              bockrunden_n = sum(bockrunden_am_abend),
              minuspunkte_sum = sum(minuspunkte_sum),
              einzahlung_total = sum(einzahlung)),
  
  tbl_spieltag_summary() %>% 
    group_by(siegerin_name) %>% 
    tally() %>% 
    filter(n == max(n)) %>% 
    ungroup() %>% 
    summarise(spielerin_siege_max_n = unique(n),
              spielerin_siege_max_name = toString(unique(siegerin_name))),
  
  tbl_spielerin_summary() %>% 
    summarise(spielerin_n = n()),
  
  
  tbl_spielerin_summary() %>%
    filter(spiele == max(spiele)) %>%
    summarise(spiele_max_n = unique(spiele),
              spiele_max_name = toString(spieler_in)),
  
  tbl_spielerin_summary() %>%
    filter(punkte == max(punkte)) %>%
    summarise(punkte_max_n = unique(punkte),
              punkte_max_name = toString(spieler_in)),
  
  tbl_spielerin_summary() %>%
    filter(punkte_pro_spiel == max(punkte_pro_spiel)) %>%
    summarise(punkte_pro_spiel_max_n = unique(punkte_pro_spiel),
              punkte_pro_spiel_max_name = toString(spieler_in)),
  
  tbl_spielerin_summary() %>%
    filter(soli == max(soli)) %>%
    summarise(soli_max_n = unique(soli),
              soli_max_name = toString(spieler_in)),
  
  tbl_spielerin_summary() %>%
    filter(bockrunden == max(bockrunden)) %>%
    summarise(bockrunden_max_n = unique(bockrunden),
              bockrunden_max_name = toString(spieler_in)),
  
  tbl_spielerin_summary() %>%
    filter(spieltag_erster == max(spieltag_erster)) %>%
    summarise(spieltag_erster_max_n = unique(spieltag_erster),
              spieltag_erster_max_name = toString(spieler_in))
  
) 
})
