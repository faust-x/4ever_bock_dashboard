################################################################################
# 4Ever-Bock-Dashboard                                                         #
# The "4Ever-Bock-Dashboard" is an interactive R-Shiny-Dashboard that displays #
# the current standings of the "4ever Bock" Doppelkopf community. Data is      #
# updated in real-time via a connected Google Sheet, allowing all members to   #
# stay up-to-date with the latest scores and statistics.                       #
#                                                                              #                                                                             #                                                                              #
# Author: Felix Aust                                                           #
# E-mail: felix.aust@posteo.de                                                 #
################################################################################

# Preparation ------------------------------------------------------------------

# Clean up workspace ----
rm(list = ls(all.names = TRUE))

# setwd is only required on local machine
# setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Load packages ----
pacman::p_load(tidyverse,
               janitor,
               shiny,
               shinyWidgets,
               bslib,
               bsicons,
               fontawesome,
               googledrive,
               googlesheets4,
               openxlsx,
               plotly,
               DT,
               reactablefmtr)


# Define input data ----

# URL's from Google Drive and Google Sheet 
input_data <-
  list(google_url_folder_images = "https://drive.google.com/drive/folders/1a7Rn8z1eSw-xZPczU5vioYJh0eftK5dj?usp=sharing",
       google_url_sheet_data = "https://docs.google.com/spreadsheets/d/1rZDkXF7CPSkXcMSGHUp-KRwgnoBsgN-xqQqRO-GyGs8/edit?usp=sharing")

# Load config files ----

# Custom values  
source(file="./global/custom_values.R", local = TRUE)

# Custom functions 
source(file="./global/custom_functions.R", local = TRUE)

# Google authentication ----

# Get json from Google Service Account 
value_name_service_account_token <- list.files(path = "./.secrets",
                                         pattern = "\\.json$")[1]

# Authentication 
drive_auth(path = paste0("./.secrets/",
                         value_name_service_account_token))
gs4_auth(token = drive_token())

# Load data ---- 
script_load_data <- parse(file = "./global/load_data.R")

for (i in seq_along(script_load_data)) {
  tryCatch(eval(script_load_data[[i]]), 
           error = function(e) message("Oops! Error in chunk: ",
                                       script_load_data[[i]],
                                       "; error message: ",
                                       as.character(e)))
}

# APP --------------------------------------------------------------------------

# Load ui ----
# source("./ui/ui_page_overview.R", local = TRUE)
# source("./ui/ui_page_spieltage.R", local = TRUE)
# source("./ui/ui_page_medallien.R", local = TRUE)

# Create ui object 
ui <- dashboardPage(#freshTheme = theme,
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


# Load server ----
server <- function(input, output) {
  
  # source("./server/server_data.R", local = TRUE)
  # source("./server/server_page_overview.R", local = TRUE)
  # source("./server/server_page_spieltage.R", local = TRUE)
  # source("./server/server_page_medallien.R", local = TRUE)
  # 
}

# Start APP ----
shinyApp(ui, server)
