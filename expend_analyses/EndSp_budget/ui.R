# User interface for exploring state and federal endangered species spending.
# Copyright (C) 2015 Jacob Malcom, jacob.w.malcom@gmail.com

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


# PLOTLY_DIR <- file.path(path.expand("."), ".plotly")
# CREDENTIALS_FILE <- file.path(PLOTLY_DIR, ".credentials")
# CONFIG_FILE <- file.path(PLOTLY_DIR, ".config")

# print(PLOTLY_DIR)
# print(CREDENTIALS_FILE)
# print(CONFIG_FILE)

library(shiny)
require(ggplot2)
# library(plotly, verbose=TRUE)
require(RCurl)
require(RJSONIO)
require(lattice)
require(xtable)
require(httr)
source("plotly/R/build_function.R")
source("plotly/R/colour_conversion.R")
source("plotly/R/corresp_one_one.R")
source("plotly/R/ggplotly.R")
source("plotly/R/marker_conversion.R")
source("plotly/R/plotly-package.r")
source("plotly/R/plotly.R")
source("plotly/R/signup.R")
source("plotly/R/tools.R")
source("plotly/R/trace_generation.R")
source("pause_text.R")
# source("plotlyGraphWidget.R")

# print(PLOTLY_DIR)
# print(CREDENTIALS_FILE)
# print(CONFIG_FILE)

set_credentials_file("jacob-ogre", "ykd3h99z9v")

#############################################################################
# Set the session-wide default font size for ggplot2
#############################################################################
theme_set(theme_grey(base_size = 18))

#############################################################################
# Load the data and basic data prep
#############################################################################
load("FY2008-2013_fed_exp_EndSp.RData")
load("FY2012-2013_state_exp_EndSp.RData")
all <- fed
dat <- state

spp_names <- c("All", as.character(levels(all$Common)))
group_names <- c("All", as.character(levels(all$Group)))
fed_years <- c("All", as.character(levels(as.factor(all$Year))))
states_ls <- c("All", as.character(levels(as.factor(dat$State))))

#############################################################################
# Define UI for dataset viewer application
#############################################################################
shinyUI(fluidPage(title="End. Sp. expenditures",

    titlePanel(h1("Endangered Species Expenditures Portal")),

    # Two sidebars to more easily view data selection criteria
    fluidRow(
        column(2,
           wellPanel(
                helpText(h4("Selection Criteria")),

                selectInput("year", label=h5("Year*"), 
                            choices = fed_years,
                            selected="All"),

                selectInput("state", label=h5("State**"), 
                            choices = states_ls,
                            selected="All"),

                selectInput("group", label=h5("Taxonomic Group"),
                            choices=group_names,
                            selected="All"),

                selectInput("species", label=h5("Species***"), 
                            choices = spp_names,
                            selected="All"),

                tags$hr(),
                helpText("*State-level data is not available for all years."),

                helpText("**Only states that submitted data to FWS are available
                         in the dropdown."),

                helpText("***Many species in dropdown had no reported state
                         expenditures, but may have been part of multi-species
                         state actions.")
                )),

        column(10,
            tabsetPanel(
                tabPanel("Overview",
                    tags$div(style="width: 75%; 
                             margin-left: auto; 
                             margin-right: auto",
                        tags$br(),
                        tags$p("The U.S. Fish and Wildlife Service (FWS)
                               reports expenditures on endangered species 
                               to Congress annually. In addition, states
                               provide FWS with data on their spending on
                               federally listed species. This app is a 
                               simple tool to allow users to peruse the
                               expenditure data.", 
                               style="font-style:italic"),
                        tags$br(),
                        tags$h4("Usage"),
                        tags$p("To get a look into the number and characteristics
                               of a particular subset of expenditures at the
                               state and/or federal levels, select filter criteria
                               from among the drop-down menus in 
                               the gray boxes to the left. All 
                               graphs and tables in the tabs (arranged along the
                               top of the page) will automatically update
                               for the data in the selection."),
                        tags$br(),
                        tags$h4(span(style="font-weight:bold; 
                                            color:#FF0000", 
                                     "CAUTION")),
                        tags$p("All state spending is pooled by species in the
                               data collected by FWS and provided
                               in the annual reports to Congress. Individual
                               reports provided by the states do not include
                               federal dollars spent on listed species. 
                               That is, the two data sources aren't fully compatible.
                               In order to compare state and federal spending
                               on a per-state basis, the app gets the list of
                               species with funding in a selected state, then
                               selects those species from the congressional
                               report table. As a result, the federal spending
                               values for a given state may also include spending 
                               on species that occur in other states. This
                               caution only applies when a state is selected
                               from the filtering dropdown menu.",
                               style="font-style:italic"),
                        tags$br(),
                        tags$h4("Notes"),
                        tags$p("Most labels are self-explanatory, but bear in
                               mind the following hints:"),
                        tags$ul(
                            tags$li("'All' or 'All data' indicates the 
                                    background of all, unfiltered data."),
                            tags$li("'Select' or 'Selected' indicates the 
                                    results are based on just the data meeting
                                    your selection criteria."),
                            tags$li("Some figures feature an overlay of 
                                    Selected data on All data for visualizing
                                    similarities or differences between the 
                                    datasets. The intensity of the color is 
                                    key: dark blue is Selected data and light
                                    blue is All data. Each page with an overlay
                                    has a small color key in the upper right
                                    corner."),
                            tags$li("Some figures aren't amenable to overlays;
                                    in these cases, the Select and All data
                                    plots are presented on top of one-another
                                    for comparison.")
                        ),
                        tags$p("Need more explanation? Check out the Help
                               tab! (Under development...)")
                    )
                ),

                tabPanel("State",
                    tags$h3(textOutput("cur_state")),
                    column(6, 
                        tags$h4("Summary"),
                        dataTableOutput("state_summary")
                    ),
                    column(6,
                        htmlOutput("state_summary_fig")
                    ),

                    column(12,
                        tags$blockquote(
                            span(style="color:#D00000", 
                                 "CAUTION: Make comparisons between state and
                                 federal spending with care because of the 
                                 limitations of the input data.
                                 See Overview tab for more information.")),
                        tags$hr(),
                        tags$h4("Top species expenditures"),
                        htmlOutput("top_state_spp"),
                        tags$hr(),
                        tags$h4("Taxonomic group expenditures"),
                        htmlOutput("top_state_group"),
                        tags$hr(),
                        tags$h4("State data"),
                        dataTableOutput("current_state_data")
                    )
                ),

                tabPanel("Federal",
                    tags$h4("Inflation-adjusted spending"),
                    column(6,
                        htmlOutput("fed_spend_time")
                    ),
                    column(6,
                        htmlOutput("fed_spend_per_spp_time")
                    ),
                    column(12,
                           tags$hr()
                    ),
                    tags$h4("Inflation-adjusted FWS spending"),
                    column(6,
                        htmlOutput("fws_spend_time")
                    ),
                    column(6,
                        htmlOutput("fws_spend_per_spp_time")
                    ),
                    tags$hr()
                ),

                tabPanel("Tables", 
                    tags$h4("Basic statistics"),
                    dataTableOutput("count_summary"),
                    tags$hr(),
                    tags$h4("Spending overview"),
                    dataTableOutput("spending_summary"),
                    tags$blockquote(
                        span(style="color:#D00000", 
                             "CAUTION: Make comparisons between state and
                             federal spending in this table with care 
                             when a state is selected from the dropdowns
                             because of the limitations of the input data.
                             See Overview tab for more information.")),
                    tags$blockquote(
                        tags$span(style="font-style:italic",
                            "NOTES: Federal expenditures do not include
                            land expenditures. State expenditures are 
                            broken down by general and land expenditures.
                            If a state is selected then the federal spending
                            is the total for all species that occur in the
                            state, even if the species occurs in many states.
                            "
                        )
                    ),
                    tags$hr(),
                    tags$h4("State:Federal spending"),
                    dataTableOutput("state2fed_summary"),
                    tags$blockquote(
                        span(style="color:#D00000", 
                             "CAUTION: Make comparisons between state and
                             federal spending in this table with care 
                             when a state is selected from the dropdowns
                             because of the limitations of the input data.
                             See Overview tab for more information.")),
                    tags$blockquote(
                        tags$span(style="font-style:italic",
                            "NOTE: Federal expenditures do not include
                            land expenditures; 'Total' state expenditures
                            include both general and land expenditures."
                        )
                    ),
                    tags$hr()
                ),

                tabPanel("Plots", 
                    tags$h4("State spending overview"),
                    htmlOutput("top10_states"),
                    tags$hr(),
                    tags$h4("State spending by taxonomic group"),
                    htmlOutput("state_taxon"),
                    tags$hr(),
                    tags$h4("More plots to follow...")
                )
           )
        )
    )
))
