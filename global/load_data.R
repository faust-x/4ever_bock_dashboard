# Google Drive -----------------------------------------------------------------

# Match data ----

# Load
google_sheet_data <-
read_sheet(input_data$google_url_sheet_data)

# Renaming
tbl_renaming_column_names <-
  tibble(datum = "date",
         spiel = "match",
         spieler_in = "player",
         punkte = "points",
         spielrunden_am_abend = "games_n",
         bockrunden_am_abend = "games_bock",
         soli_gespielt_anzahl  = "games_soli",
         spielrunden_ausgesetzt = "games_suspended") %>% 
  pivot_longer(everything())

vec_renaming_colum_names <- 
  setNames(tbl_renaming_column_names$name,
           tbl_renaming_column_names$value)

# Clean data set
tbl_raw_data_clean <- 
google_sheet_data %>% 
  clean_names() %>% 
  rename(!!!vec_renaming_colum_names) %>% 
  mutate(across(any_of(c("date")), ymd)) %>% 
  filter(!is.na(date)) %>%
  filter(!is.na(player)) %>%
  mutate(across(where(is.numeric), ~ replace_na(., 0))) %>% 
  mutate(games_played = games_n - games_suspended) %>% 
  mutate(payment = if_else(points >= 0,
                           0,
                           points) *-10/100) %>% 
  mutate(season = year(date)) %>% 
  arrange(desc(date))

# Images ----

tbl_pictures_in_folder <-
  drive_ls(path= as_id(input_data$google_id_folder_images),
           recursive = TRUE) %>% 
  unnest_wider(drive_resource,
               names_repair = "unique") %>%
  select(name=1,
         googledrive_id=2,
         mimeType,
         createdTime,
         modifiedTime,
         parents) %>% 
  unnest_wider(parents,
               names_sep = "_") %>% 
  mutate(across(contains(c("Time")),
                ymd_hms)) %>% 
  filter(str_detect(mimeType,"image")) %>% 
  mutate(url = paste0("https://drive.usercontent.google.com/download?id=",googledrive_id))

# Global options ---------------------------------------------------------------

options_season <-
  tbl_raw_data_clean %>% 
  distinct(season) %>% 
  arrange(desc(season)) %>% 
  pull()
