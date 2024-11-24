# Tags -------------------------------------------------------------------------

tags_std <-
tags$head(
  tags$link(
    href = "https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap", 
    rel = "stylesheet"
  )
)

# bslib themes ----------------------------------------------------------------

# bslib theme mementor default ----
bslib_theme_default <-
  bs_theme(
    version = 5,
    bootswatch = "minty",
    #preset = "shiny",
    base_font = font_google("Montserrat"),
    code_font = font_google("Montserrat"),
    font_scale = 0.9,
    # "navbar-light-bg" = "#2d8c84 !important",
    # "navbar-light-active-color" = "white !important",
    # "navbar-light-link-color" = "#494848 !important",
    # "navbar-light-brand-color" = "white !important",
    # "navbar-light-brand-hover-color" = "white !important",
    # "nav-link-active-color" = "red !important",
    # "nav-link-color" = "#494848 !important",
    bg = "#FFFFFF",
    fg = "#d0b169",
    primary = "#d0b169",
    secondary = "#272c30",
    success = "#6a9f58",
    info = "#85b6b2",
    warning = "#e7ca60",
    danger = "#d1615d",
    heading_font = font_google("Baloo 2"))

# bs4dash layout theme ---------------------------------------------------------
# 
# create the theme with fresh
# theme <- create_theme(
#   bs4dash_vars(
#     navbar_light_color = "#bec5cb",
#     navbar_light_active_color = "#FFF",
#     navbar_light_hover_color = "#FFF"
#   ),
#   bs4dash_yiq(
#     contrasted_threshold = 10,
#     text_dark = "#FFF",
#     text_light = "#272c30"
#   ),
#   bs4dash_layout(
#     main_bg = "#FFF"
#   ),
#   bs4dash_sidebar_light(
#     bg = "#272c30",
#     color = "#bec5cb",
#     hover_color = "#FFF",
#     submenu_bg = "#272c30",
#     submenu_color = "#FFF",
#     submenu_hover_color = "#FFF"
#   ),
#   bs4dash_status(
#     primary = "#d0b169",#primary = "#5E81AC",
#     danger = "#BF616A",
#     light = "#272c30"
#   ),
#   bs4dash_color(
#     gray_900 = "#FFF"
#   )
# )

# Plotly -----------------------------------------------------------------------

list_plotly_default <- 
  list(line_width = 3,
       marker_size = 8,
       font_family = "Montserrat",
       font_body_size = 16,
       font_title_size = 22,
       font_title_y_position = 0.98,
       font_annotation_size = 10,
       toImage_scale = 4,
       toImage_width = 1200,
       toImage_height = 800)

# Reactable --------------------------------------------------------------------

list_reactable_default <- 
  list(font_body_size = 18,
       font_header_size = 20,
       cell_padding = 5)

# GoogleFonts --------------------------------------------------------------------

list_google_font_default <- 
  list(font_family = "Montserrat")

# Colors -----------------------------------------------------------------------

# tableau 10 ----

# list
list_colors_tableau_10 <- 
  list(blue = "#5778a4",
       orange = "#e49444",
       green = "#6a9f58",
       red = "#d1615d",
       teal = "#85b6b2",
       yellow = "#e7ca60",
       purple = "#a87c9f",
       pink = "#f1a2a9",
       grey = "#b8b0ac",
       brown = "#967662")

# vector 
vec_colors_tableau_10 <- list_colors_tableau_10 %>% unlist() %>% unname()