selected_season <- c(2021,2022)
selected_season <- c(2023)

tbl_all_data_selected_season <-
tbl_all_data %>%
  filter(season %in% selected_season)



# Zusammenfassung Spielerin
tbl_spielerin_summary <-
tbl_all_data_selected_season %>%
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

# Zusammenfassung Spieltag
tbl_spieltag_summary <-
tbl_all_data_selected_season %>% 
  group_by(datum,spiel) %>% 
  summarise(spiele = max(spielrunden_am_abend),
            bockrunden_am_abend = max(bockrunden_am_abend),
            spieler_in = n_distinct(spieler_in),
            einzahlung = sum(einzahlung)) %>% 
  full_join(.,
            tbl_all_data_selected_season %>% 
              group_by(datum,spiel) %>% 
              filter(punkte == max(punkte)) %>% 
              summarise(siegerin_punkte = unique(punkte), 
                        siegerin_name = toString(unique(spieler_in))),
            by=c("datum","spiel")) %>% 
  full_join(.,
            tbl_all_data_selected_season %>% 
              group_by(datum,spiel) %>% 
              filter(punkte <0) %>% 
              summarise(minuspunkte_sum = sum(punkte)),
            by=c("datum","spiel")) %>% 
  full_join(.,
            tbl_all_data_selected_season %>% 
              group_by(datum,spiel) %>% 
              filter(punkte == min(punkte)) %>% 
              summarise(loserin_punkte = unique(punkte), 
                        loserin_name = toString(unique(spieler_in))),
            by=c("datum","spiel")) %>% 
  ungroup()


# add spieltagssiege to tbl_spielerin_summary
tbl_spielerin_summary<-
tbl_spielerin_summary %>% 
  left_join(.,
            tbl_spieltag_summary %>% 
              group_by(spieler_in=siegerin_name) %>% 
              summarise(spieltagssiege = n()),
            by="spieler_in") %>%
  mutate_if(is.numeric , replace_na, replace = 0)
  


# tbl kennzahlen 

# spieltags zusammenfassung 
tbl_kennzahlen <-
tbl_spieltag_summary %>% 
  ungroup() %>% 
  summarise(spieltag_n = n(),
            spieltage_letzte = max(datum),
            spiele_n = sum(spiele),
            bockrunden_n = sum(bockrunden_am_abend),
            minuspunkte_sum = sum(minuspunkte_sum),
            einzahlung_total = sum(einzahlung)
  )

# siegerinnen 
tbl_kennzahlen <-
tbl_spieltag_summary %>% 
  group_by(siegerin_name) %>% 
  tally() %>% 
  filter(n == max(n)) %>% 
  ungroup() %>% 
  summarise(spielerin_siege_max_n = unique(n),
            spielerin_siege_max_name = toString(unique(siegerin_name))) %>% 
  bind_cols(tbl_kennzahlen,
            .)

# summary spielerinnen 
COLUMN_NAMES_FOR_SUMMARY <- c("spiele",
                              "punkte",
                              "punkte_pro_spiel",
                              "soli",
                              "bockrunden",
                              "spieltag_erster")

for (COLUMN_NAME in COLUMN_NAMES_FOR_SUMMARY) {
  temp <-
    tbl_spielerin_summary %>%
    filter(.data[[COLUMN_NAME]] == max(.data[[COLUMN_NAME]])) %>%
    summarise(a = unique(.data[[COLUMN_NAME]]),
              b = toString(spieler_in))
  
  names(temp) <- c(paste0(COLUMN_NAME,"_max_n"),
                   paste0(COLUMN_NAME,"_max_name"))
  tbl_kennzahlen <-
    bind_cols(tbl_kennzahlen,
              temp)
  
}

# add count of players 
tbl_kennzahlen <-
tbl_kennzahlen %>% 
  bind_cols(.,
            tbl_spielerin_summary %>% 
              summarise(spielerin_n = n()))
