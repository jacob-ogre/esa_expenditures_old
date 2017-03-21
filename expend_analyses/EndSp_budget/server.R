# Server-side code for Endangered Species spending.
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

require(ggplot2)
require(ggthemes)
require(lubridate)
# library(plotly, verbose=TRUE)
require(shiny)
source("multiplot.R")
source("subset_fx.R")
source("summary_fx.R")
source("bargraphs.R")
source("frame_helper.R")
source("linegraphs.R")
source("null_graph.R")
# source("plotlyGraphWidget.R")
source("scatterplots.R")

#############################################################################
# Load the data and basic data prep
#############################################################################
load("FY2008-2013_fed_exp_EndSp.RData")
load("FY2012-2013_state_exp_EndSp.RData")
all <- fed
dat <- state

#############################################################################
# Define the server with calls for data subsetting and making figures
#############################################################################
shinyServer(function(input, output) {
    st_sub <- reactive({
        states_subset(dat,
                      input$year,
                      input$state,
                      input$group,
                      input$species
        )
    })
    
    us_sub <- reactive({
        all_subset(all,
                   st_sub,
                   input$year,
                   input$state,
                   input$group,
                   input$species
        )
    })

    output$current_state_data <- renderDataTable(
        st_sub()
    )

    get_state <- function(state) {
        min_st_yr <- min(as.numeric(as.character(state()$Year)), na.rm=TRUE)
        max_st_yr <- max(as.numeric(as.character(state()$Year)), na.rm=TRUE)
        if (input$state == "All") {
            return("Please select a state from dropdown")
        } else if (is.infinite(min_st_yr)) {
            return("Please select a different year")
        } else {
            cur_yrs <- ifelse(min_st_yr == max_st_yr,
                              min_st_yr,
                              paste(min_st_yr, "-", max_st_yr, "cumulative"))
            return(paste(input$state, ", ", cur_yrs, sep=""))
        }
    }

    output$cur_state <- renderText(
        get_state(st_sub)
    )

    ###########################################################################
    # Make the summary tables
    output$count_summary <- renderDataTable(
        make_count_summary(st_sub, us_sub, dat, all),
        options = list(paging=FALSE, searching=FALSE, info=FALSE, ordering=FALSE)
    )

    output$spending_summary <- renderDataTable(
        make_spending_summary(st_sub, us_sub, dat, all),
        options = list(paging=FALSE, searching=FALSE, info=FALSE, ordering=FALSE)
    )

    output$state2fed_summary <- renderDataTable(
        make_state2fed_summary(st_sub, us_sub, dat, all),
        options = list(paging=FALSE,
                       searching=FALSE,
                       info=FALSE,
                       language.thousands=",",
                       ordering=FALSE)
    )

    output$state_summary <- renderDataTable(
        make_state_summary(st_sub, dat, us_sub),
        options = list(paging=FALSE, 
                       searching=FALSE, 
                       info=FALSE, 
                       ordering=FALSE)
    )

    ###########################################################################
    # Some figures
    output$top10_states <- renderUI({
        make_state_spend(st_sub, dat)
    })

    output$state_taxon <- renderUI({
        make_group_spend(st_sub, dat)
    })

    output$state_summary_fig <- renderUI({
        make_state_summary_fig(st_sub, us_sub)
    })

    output$top_state_spp <- renderUI({
        make_top_state_spp(st_sub)
    })

    output$top_state_group <- renderUI({
        make_state_group_fig(st_sub)
    })

    output$fed_spend_time <- renderUI({
        make_fed_spending_fig(us_sub)
    })

    output$fed_spend_per_spp_time <- renderUI({
        make_fed_spend_per_spp_fig(us_sub)
    })

    output$fws_spend_time <- renderUI({
        make_fws_spending_fig(us_sub)
    })

    output$fws_spend_per_spp_time <- renderUI({
        make_fws_spend_per_spp_fig(us_sub)
    })

    # output$fws_spend_appro <- renderPlot({
    #     make_fws_spend_appro_fig(us_sub)
    # })

})
