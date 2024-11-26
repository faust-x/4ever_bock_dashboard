# bslib themes ----------------------------------------------------------------

# bslib theme default ----
bslib_theme_default <-
  bs_theme(
    version = 5,
    bootswatch = "minty",
    base_font = font_google("Montserrat"),
    code_font = font_google("Montserrat"),
    font_scale = 0.6,
    bg = "#FFFFFF",
    fg = "#272c30",
    primary = "#a30041",
    secondary = "#ead3c1",
    success = "#6a9f58",
    info = "#85b6b2",
    warning = "#e7ca60",
    danger = "#d1615d",
    heading_font = font_google("Baloo 2"))

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

# GoogleFonts ------------------------------------------------------------------

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