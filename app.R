################################################################################
# 4 ever bock dashboard                                                        #
#                                                                              #                                                                             #                                                                              #
# Author: Felix Aust                                                           #
# E-mail: felix.aust@posteo.de                                                 #
################################################################################

#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Load packages ----------------------------------------------------------------
pacman::p_load(shiny,
               bs4Dash,
               shinyWidgets,
               tidyselect,
               tidyverse,
               googledrive,
               googlesheets4,
               lubridate,
               janitor,
               plotly,
               showtext,
               DT,
               reactable,
               reactablefmtr,
               fresh)

# Google Authentication --------------------------------------------------------

## Setup 
# 1. Access Google Cloud Console
# 2. Create a Project (optional)
# 3. Navigate to "IAM & Admin" settings
# 4. Create Service Account
# 5. Create JSON Key
# 6. Save the JSON Key in folder ".secrets"
# 7. Grant Accces to Google Files 

# Get json from Google Service Account 
name_service_account_token <- list.files(path = "./.secrets",
                                         pattern = "\\.json$")[1]

## Authentication 
drive_auth(path = paste0("./.secrets/",
                         name_service_account_token))
gs4_auth(token = drive_token())


# Load Data -------------------------------------------------------------------- 

## define urls 
image_folder_url <- "https://drive.google.com/drive/folders/1a7Rn8z1eSw-xZPczU5vioYJh0eftK5dj?usp=sharing"
sheet_url <- "https://docs.google.com/spreadsheets/d/1rZDkXF7CPSkXcMSGHUp-KRwgnoBsgN-xqQqRO-GyGs8/edit?usp=sharing"

## load data 
tbl_all_data <-
  read_sheet(sheet_url) %>%
  clean_names() %>%
  filter(!is.na(spieler_in)) %>%
  mutate(datum = ymd(datum)) %>% 
  mutate(spiel = if_else(is.na(spiel),
                         0,
                         spiel)) %>% 
  filter(!is.na(spielrunden_am_abend)) %>% 
  mutate(einzahlung = if_else(punkte>=0,
                              0,
                              punkte*-0.1)) %>%
  mutate(season = year(datum))

# path_to_font <-
#   paste0(getwd(),
#          "/www/fonts")
# 
# font_add(family = "Montserrat",
#          regular = paste0(path_to_font,
#                           "/Montserrat/static/Montserrat-Regular.ttf"),
#          italic = paste0(path_to_font,
#                          "/Montserrat/static/Montserrat-Italic.ttf"))
# 
# font_add(family = "Montserrat",
#          regular = "Montserrat-Regular.ttf",
#          italic = "Montserrat-Italic.ttf")

# Bs4Dash-Theme ----------------------------------------------------------------
source("./global/bs4dash_theme_4ever_bock.R", local = TRUE)

# UI

## Page Overview
source("./ui/ui_page_overview.R", local = TRUE)
source("./ui/ui_page_spieltage.R", local = TRUE)
source("./ui/ui_page_medallien.R", local = TRUE)


# APP --------------------------------------------------------------------------

## UI ------------------------------------------------------------------

ui <- dashboardPage(freshTheme = theme,
                    dark = NULL,
                    header = dashboardHeader(title = dashboardBrand(title = "4ever Bock",
                                                                    href = "https://github.com/faust-x",
                                                                    image = "logo_lucky_strike_48_48.jpg")),
  sidebar = dashboardSidebar(sidebarMenu(id = "tabs",
                                         selectInput(inputId = "input_season",
                                                     label = "Select season",
                                                     choices = tbl_all_data$season %>% unique(),
                                                     selected = tbl_all_data$season %>% max(),
                                                     multiple = TRUE),
                                         menuItem("Übersicht",
                                                  tabName = "page_overview",
                                                  icon = icon("chart-pie", 
                                                              lib = "font-awesome")),
                                         menuItem("Spieltage",
                                                  tabName = "page_spieltage",
                                                  icon = icon("calendar-day", 
                                                              lib = "font-awesome")),
                                         menuItem("Medaillen",
                                                  tabName = "page_medallien",
                                                  icon = icon("medal", 
                                                              lib = "font-awesome")),
                                         menuItem("Regeln",
                                                  tabName = "page_regeln",
                                                  icon = icon("gavel", 
                                                              lib = "font-awesome")))
                             ),
  dashboardBody(tabItems(tabItem_page_overview,
                         tab_Item_page_spieltage,
                         tabItem_page_medallien,
                         tabItem("page_regeln",
                                 tags$iframe(style="height:600px; width:100%",
                                             src="Regeln.pdf"))
                                 )))


# server 
server <- function(input, output) {
  
  source("./server/server_data.R", local = TRUE)
  source("./server/server_page_overview.R", local = TRUE)
  source("./server/server_page_spieltage.R", local = TRUE)
  source("./server/server_page_medallien.R", local = TRUE)
  

}

# start app
shinyApp(ui, server)
