# DTtable ----------------------------------------------------------------------

# DTtable buttons ----

# DTtable standard
datatable_std <- function(TABLE,
                          fillContainer =TRUE,
                          filename="data") {
  
  DT_button_download_current_page <-list(extend = "excel",
                                         text = "Download Current Page",
                                         filename = "page",
                                         exportOptions = list(modifier = list(page = "current")))
  
  
  DT_button_download_full_results <- list(extend = "excel",
                                          text = "Download Full Results",
                                          filename = "data",
                                          exportOptions = list(modifier = list(page = "all")))
  
  TABLE %>% 
    datatable(.,
              filter = 'top',
              extensions = 'Buttons',
              escape = FALSE,
              rownames= FALSE,
              fillContainer = fillContainer,
              options = list(dom = 'Bfrtipl',
                             buttons = list('copy',
                                            list(extend = "excel",
                                                 text = "Download Current Page",
                                                 filename = filename,
                                                 exportOptions = list(modifier = list(page = "current"))),
                                            list(extend = "excel",
                                                 text = "Download Full Results",
                                                 filename = filename,
                                                 exportOptions = list(modifier = list(page = "all")))),
                             pageLength = 10,
                             lengthMenu = list(c(5, 10, 25, -1),
                                               c('5', '10', '25', 'All')),
                             lengthMenu = TRUE,
                             searchHighlight = TRUE))
  
}

# Fontawesome ------------------------------------------------------------------

fa_value_box <- function(ICON = "calendar-check") {

fa(name = ICON,
   height = "4em",
   width = "4em")
}

# Reacttable (+fmtr) -----------------------------------------------------------

reactable_std <- function(TABLE = cars) {
  reactable(data = TABLE,
            defaultPageSize = 25,
            filterable = TRUE,
            searchable = TRUE,
            compact = TRUE) %>% 
    google_font("Montserrat")
}

# Plotly -----------------------------------------------------------------------

# Function for custom layout for charts in value boxes of bslib
function_plotly_layout_value_box <- function(PLOTLY_CHART,
                                             yaxis_visible = TRUE
) {
  PLOTLY_CHART %>% 
    layout(title = list(text = ""),
           separators = '.',
           xaxis = list(title = list(text = ""),
                        visible = FALSE, 
                        showgrid = FALSE,
                        zeroline = FALSE),
           yaxis = list(title = "",
                        visible = yaxis_visible,
                        showgrid = FALSE,
                        zeroline = TRUE),
           margin = list(t = 0, r = 0, l = 0, b = 0),
           font = list(color = "white"),
           paper_bgcolor = "transparent",
           plot_bgcolor = "transparent") %>% 
    config(displayModeBar = F) %>%
    htmlwidgets::onRender(
      "function(el) {
      var ro = new ResizeObserver(function() {
         var visible = el.offsetHeight > 200;
         Plotly.relayout(el, {'xaxis.visible': visible});
      });
      ro.observe(el);
    }"
    )
}


# Creates a screenshot in high resolution 
plotly_screenshot_std <-
  function(plotly_chart,
           name_of_chart = "chart"){
    plotly_chart %>% 
      plotly::config(
        toImageButtonOptions = list(
          format = "png",
          scale = 4,
          filename = paste0(str_replace_all(Sys.Date(),
                                            "-",
                                            "_"),
                            "_",
                            name_of_chart),
          width = 1200,
          height = 800
        ))
  }