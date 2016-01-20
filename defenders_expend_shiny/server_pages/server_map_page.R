# Server-side code for the section 7 app basic single-view page
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

source("plot/my_legend.R")

###########################################################################
# Server-side code for the section 7 app basic single-view page
###########################################################################
server_map_page <- function(input, output, selected, session) {
    # cur_zoom <- 4
    cur_zoom <- reactive({
        if (!is.null(input$map_zoom)) {
            input$map_zoom
        } else {
            4
        }
    })

    circ_1 <- reactive({
        tmp <- selected()
        tmp$dups <- duplicated(tmp$st_co_sp)
        n_spp <- table(tmp[tmp$dups == FALSE, ]$GEOID)
        nspp_df <- data.frame(GEOID=names(n_spp), n_spp=as.vector(n_spp))
        tot_exp <- tapply(tmp$exp_report, tmp$GEOID, FUN=sum, na.rm=TRUE)
        texp_df <- data.frame(GEOID=names(tot_exp), tot_exp=as.vector(tot_exp))
        int_dat <- merge(nspp_df, texp_df, by="GEOID")
        res <- merge(int_dat, spa_dat, by="GEOID")
        res$scaled_nspp <- scale(res$n_spp, center=F) * 50000 * (1/cur_zoom())
        res$exp_per_sp <- res$tot_exp / res$n_spp
        res
    })

    output$map <- renderLeaflet({ 
		cur_map <- leaflet() %>%
                   setView(lng=-95, lat=38, zoom = 4) %>%
                   mapOptions(zoomToLimits = "never")
        return(cur_map)
    })

    # proxy to add/change the basemap
    observe({ 
        leafletProxy("map") %>% 
            clearTiles() %>% 
            addProviderTiles(input$map_tile) 
    })

    # proxy to add/change topoJSON, with line color dependent on basemap
    observe({ 
        cur_col <- ifelse(input$map_tile == "Stamen.TonerLite" |
                          input$map_tile == "Stamen.Toner" |
                          input$map_tile == "OpenStreetMap.Mapnik",
                          "#ffcc00",
                          "#000000")
        leafletProxy("map") %>%
            addTopoJSON(topoData, 
                        weight = 0.5, 
                        color = cur_col, 
                        fill = FALSE)
    })

    # proxy to add/change plotted circles, with size/fill dependent on selection
    observe({
        if (input$circ_rep == "sep") {
            circle_size <- circ_1()$scaled_nspp
            circle_color <- circ_1()$tot_exp
        } else {
            circle_size <- log(scale(circ_1()$exp_per_sp, center=F)) * 100000 * 1/cur_zoom()
            circle_color <- circ_1()$exp_per_sp
        }
        leafletProxy("map", data=circ_1()) %>%
            clearShapes() %>%
            addCircles(lng = ~INTPTLON,
                       lat = ~INTPTLAT,
                       radius = ~circle_size, 
                       color = ~colorBin("RdYlBu", 
                                         range(circle_color),
                                         bins=5)(circle_color),
                       fillOpacity=0.85,
                       stroke = FALSE,
                       popup = ~paste0("<b>", NAME, " Co.</b><br>", 
                                       make_dollars(circ_1()$tot_exp),
                                       "<br>", n_spp, " species<br>")
            )
    })

    output$my_legend <- renderPlot({
        cur_dat <- make_map_legend_df(selected())
        return(make_my_legend(cur_dat, input$circ_rep))
    }, height=170, width=170)
    
    # # proxy to add/change the legend, conditioned on viz selection
    # observe({
    #     if (input$circ_rep == "sep") {
    #         circle_color <- circ_1()$tot_exp
    #         title <- "<p style='text-align:center;'>Est. expenditures<br>(&times; 1,000)</p>"
    #     } else {
    #         circle_color <- circ_1()$exp_per_sp
    #         title <- "<p style='text-align:center;'>Est. per-species expend.<br>(&times; 1,000)</p>"
    #     }
    #     leafletProxy("map", data=circ_1()) %>%
    #         clearControls() %>%
    #         addLegend("bottomleft",
    #                   pal=colorBin("RdYlBu", 
    #                                range(circle_color),
    #                                bins=5),
    #                   values=circ_1()$tot_exp,
    #                   title=title,
    #                   labFormat=labelFormat(prefix="$",
    #                       transform=function(x) {return(x / 1000) }),
    #                   opacity=1)
    # })

    output$small_chart <- renderGvis({
        if (input$mini_chart == "Top 10% vs. bottom 90%") {
            make_top10_low90_plot(selected, height="100%")
        } else if (input$mini_chart == "Top species") {
            make_species_plot(selected(), height="100%", mini=TRUE)
        } else if (input$mini_chart == "Expenditures by year") {
            make_spending_time_line(selected, height="100%")
        } else if (input$mini_chart == "Expenditures by group") {
            make_tax_group_plot(selected(), height="100%", mini=TRUE)
        } else if (input$mini_chart == "Est. expend. by state") {
            make_spend_state_plot(selected, height="100%", mini=TRUE)
        } else {
            make_spend_county_plot(selected, height="100%")
        }
    })

    output$large_chart <- renderGvis({
        if (input$mini_chart == "Top 10% vs. bottom 90%") {
            make_top10_low90_plot(selected, height="500px")
        } else if (input$mini_chart == "Top species") {
            make_species_plot(selected(), height="500px")
        } else if (input$mini_chart == "Expenditures by year") {
            make_spending_time_line(selected, height="500px")
        } else if (input$mini_chart == "Expenditures by group") {
            make_tax_group_plot(selected(), height="500px")
        } else if (input$mini_chart == "Est. expend. by state") {
            make_spend_state_plot(selected, height="500px")
        } else {
            make_spend_county_plot(selected, height="500px")
        }
    })

}

