# A Shiny Dashboard version of the End. Sp. expenditures app.
# Copyright (C) 2015 Defenders of Wildlife, jmalcom@defenders.org

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.

source("server_pages/server_map_page.R")
source("server_pages/server_chart_page.R")
# source("server_pages/server_alt_map_page.R")

#############################################################################
# Define the server with calls for data subsetting and making figures
#############################################################################
shinyServer(function(input, output, session) {

    # The basic reactive subsetting functions...separate functions for each
    # of the pages.
    selected <- reactive({
        sub_df(full,
               input$years,
               input$groups,
               input$species,
               input$state,
               input$sources
        )
    })

    selected_2 <- reactive({
        sub_df(full,
               input$years_2,
               input$groups_2,
               input$species_2,
               input$state_2,
               input$sources_2
        )
    })

    output$defenders <- renderImage({
        width <- session$clientData$output_defenders_width
        if (width > 100) {
            width <- 100
        }
        list(src = "www/01_DOW_LOGO_COLOR_300-01.png",
             contentType = "image/png",
             alt = "Overview of section 7 consultation",
             a(href = "http://www.defenders.org"),
             width=width)
    }, deleteFile=FALSE)

    output$heuristic <- renderImage({
        # width <- session$clientData$output_heuristic_width
        # if (width > 200) {
        #     width <- 200
        # }
        list(src = "www/heuristic_2.png",
             contentType = "image/png",
             alt = "Heuristic key to bubbles",
             width=200)
    }, deleteFile=FALSE)


    # Call the files with server functions broken out by page
    server_map_page(input, output, selected, session)
    server_chart_page(input, output, selected_2, session)
    # server_alt_map_page(input, output, selected_3, session)

    ###########################################################################
    # The following function calls are used for getting the data selections
    # for download.
    # get_selected_data <- function(x) {
    #     if (x == "single") {
    #         return(selected())
    #     } else if (x == "no_1") {
    #         return(selected_1())
    #     } else if (x == "no_2") {
    #         return(selected_2())
    #     } else {
    #         return(selected_3())
    #     }
    # }
    # 
    # output$selected_data <- DT::renderDataTable(
    #     get_selected_data(input$which_data),
    #     rownames=FALSE,
    #     filter="top", 
    #     extensions="ColVis", 
    #     options = list(dom = 'C<"clear">lfrtip')
    # )
    # 
    # output$download_data <- downloadHandler(
    #     filename=function() {
    #         "selected_data.tab"
    #     },
    #     content=function(file) {
    #         if (input$which_data == "single") {
    #             data_to_get <- selected()
    #         } else if (input$which_data == "no_1") {
    #             data_to_get <- selected_1()
    #         } else if (input$which_data == "no_2") {
    #             data_to_get <- selected_2()
    #         } else {
    #             data_to_get <- selected_3()
    #         }
    #         for_write <- make_writeable(data_to_get)
    #         write.table(for_write, 
    #                     file=file, 
    #                     sep="\t",
    #                     row.names=FALSE,
    #                     quote=FALSE)
    #     }
    # )
    # 
    # output$download_metadata <- downloadHandler(
    #     filename=function() {
    #         "section_7_metadata.json"
    #     },
    #     content=function(file) {
    #         sink(file)
    #         cat(the_metadata)
    #         sink()
    #     }
    # )

})
