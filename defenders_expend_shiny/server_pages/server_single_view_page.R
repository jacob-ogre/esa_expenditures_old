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


###########################################################################
# Server-side code for the section 7 app basic single-view page
###########################################################################
server_map_page <- function(input, output, selected, session) {

    # shinyURL.server(session)

    output$total_spent <- renderText({
        get_number_spent(selected())
    })

    output$n_species <- renderText({
        get_number_species(selected())
    })

    output$consults_species <- renderGvis({
        make_species_plot(selected)
    })

    output$consults_species_large <- renderGvis({
        make_species_plot(selected, height="575px", chartHeight="70%")
    })

    output$consults_map <- renderLeaflet({ 
		map <- leaflet(height="500px") %>% 
                   setView(lng=-75, lat=52, zoom = 3) %>%
				   addProviderTiles("Stamen.Toner") %>%
				   addTopoJSON(topoData, 
                               weight = 1, 
                               color = "#ffcc00", 
                               fill = FALSE)
        return(map)
    })

    output$percentage_chart <- renderGvis({
        make_percent_plot(selected)
    })

    output$percent_chart_large <- renderGvis({
        make_percent_plot(selected, height="550px")
    })

    output$spending_time <- renderGvis({
        make_spending_time_line(selected)
    })

    output$spending_time_large <- renderGvis({
        make_spending_time_line(selected, height="550px")
    })

    output$spend_tax_group <- renderGvis({
        make_tax_group_plot(selected)
    })

    output$spend_tax_group_large <- renderGvis({
        make_tax_group_plot(selected, height="575px", chartHeight="75%")
    })

    output$spend_state <- renderGvis({
        make_spend_state_plot(selected)
    })

    output$spend_state_large <- renderGvis({
        make_spend_state_plot(selected, height="575px", chartHeight="70%")
    })

    output$spend_county <- renderGvis({
        make_spend_county_plot(selected)
    })
    
    output$spend_county_large <- renderGvis({
        make_spend_county_plot(selected, height="575px", chartHeight="70%")
    })
    
    output$a_line <- renderImage({
        width <- session$clientData$output_a_line_width
        list(src = "www/line-01.png",
             contentType = "image/png",
             alt = "",
             a(href = ""),
             width=width)
    }, deleteFile=FALSE)
 
}

