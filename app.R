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
               bslib,
               bsicons,
               fontawesome,
               googledrive,
               googlesheets4,
               plotly,
               reactablefmtr,
               toastui)

# Define input data ----

# URL's from Google Drive and Google Sheet 
input_data <-
  list(google_url_folder_images = "https://drive.google.com/drive/folders/1a7Rn8z1eSw-xZPczU5vioYJh0eftK5dj",
       google_id_folder_images = "1a7Rn8z1eSw-xZPczU5vioYJh0eftK5dj",
       google_url_sheet_data = "https://docs.google.com/spreadsheets/d/1rZDkXF7CPSkXcMSGHUp-KRwgnoBsgN-xqQqRO-GyGs8")

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
 
# Load data -----
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
 source("./ui/ui_page_overview.R", local = TRUE)
 source("./ui/ui_page_player.R", local = TRUE)
 source("./ui/ui_page_matches.R", local = TRUE)

# Create ui object 
ui <- page_navbar(theme = bslib_theme_default,
                  tags$head(
                    tags$link(rel = "stylesheet",
                              type = "text/css",
                              href = "styles.css"),
                    tags$link(rel = "shortcut icon",
                              type = "image/x-icon",
                              href = "favicon.ico")),
                  title = tags$div(class = "navbar-brand",
                                   tags$img(src = "logo.png",
                                            height = "48px",
                                            style = "margin-right: 10px;"),
                                   "4ever Bock Dashboard"),
                  
                  sidebar = sidebar(open = "closed",
                                    selectInput("season",
                                                label = "Select season",
                                                choices = options_season,
                                                multiple = T,
                                                selected = max(options_season))),
                  nav_panel("Overview",
                            icon =  fa("users-viewfinder"),
                            page_ui_overview),
                  nav_panel("Player",
                            icon = bs_icon("person-bounding-box"),
                            page_ui_player),
                  nav_panel("Matches",
                            icon = fa("dice"),
                            page_ui_matches),
                  nav_panel("Rules",
                            icon = fa("section"),
                            page_fluid(card(tags$iframe(
                              src = "rules.pdf",  
                              width = "100%",       
                              height = "1300px",
                              style = "border: none;",
                              allow = "fullscreen; autoplay")))),
                  nav_panel("Hall Of Fame",
                            icon = fa("place-of-worship"),
                            page_fluid(
                              navset_card_tab(full_screen = TRUE,
                                              title = "Hall of Fame",
                                              height = 800,
                                              nav_panel(title = "2023",
                                                        tags$iframe(
                                                          src = "season_2023_4ever_bock.pdf",
                                                          width = "100%",
                                                          height = "700px",
                                                          style = "border: none;",
                                                          allow = "fullscreen; autoplay")
                                              )
                              )
                            )
                  ),
                  nav_spacer(),
                  nav_item(tags$a(tags$span(fa("google-drive"),
                                            "Data"),
                                  href = input_data$google_url_sheet_data,
                                  target = "_blank")
                  ),
                  nav_item(tags$a(tags$span(fa("images"),
                                            "Pictures"),
                                  href = input_data$google_url_folder_images,
                                  target = "_blank")
                  ),
                  nav_item(tags$a(tags$span(bs_icon("github"),
                                            "Source Code"),
                                  href = "https://github.com/faust-x/4ever_bock_dashboard",
                                  target = "_blank"))
)
                  

# Load server ----
server <- function(session,input, output) {
  
  # Data
  source("./server/server_data.R", local = TRUE)
  
  # Pages
  source("./server/server_page_overview.R", local = TRUE)
  source("./server/server_page_player.R", local = TRUE)
  source("./server/server_page_matches.R", local = TRUE)
  
}

# Start App -------------------------------------------------------------------
shinyApp(ui, server)
