# DTtable ----------------------------------------------------------------------

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