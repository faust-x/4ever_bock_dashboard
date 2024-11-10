

tabItem_page_medallien <-
tabItem("page_medallien",
        fluidRow(infoBoxOutput(outputId ="infobox_spieltage",width = 3),
                 infoBoxOutput(outputId ="infobox_spieltag_letzter", width = 3),
                 infoBoxOutput(outputId ="infobox_spiele_n", width = 3),
                 infoBoxOutput(outputId ="infobox_bockrunden", width = 3)),
        fluidRow(infoBoxOutput(outputId ="infobox_meisten_punkte", width = 3),
                 infoBoxOutput(outputId ="infobox_meisten_punkte_pro_spiel", width = 3),
                 infoBoxOutput(outputId ="infobox_meisten_soli", width = 3),
                 infoBoxOutput(outputId ="infobox_meisten_siege", width = 3)),
        fluidRow(infoBoxOutput(outputId ="infobox_spielerinnen_n", width = 3),
                 infoBoxOutput(outputId ="infobox_neuste_spielerin", width = 3),
                 infoBoxOutput(outputId ="infobox_einzahlung", width = 3)))


