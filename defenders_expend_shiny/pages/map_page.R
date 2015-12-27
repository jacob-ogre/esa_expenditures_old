# UI page for the main app landing page (single selection).
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

map_page <- {
    tabPanel(
        title="Interactive map",
		div(class="outer",
		    tags$head(
                HTML("<link href='https://fonts.googleapis.com/css?family=Open+Sans:300,400' rel='stylesheet' type='text/css'>"),
                includeCSS("www/custom_styles.css"),
                includeScript("www/gomap.js")
            ),
            tags$style(type="text/css", "body {padding-top: 70px;}"),
            leafletOutput("map", height="100%", width="100%"),

            # Add the contol panel
            absolutePanel(id = "controls", class = "panel panel-default", 
                fixed = TRUE, draggable = TRUE, top = 60, left = "auto", 
                right = 20, bottom = "auto", width = 330, height = "90%",

                fluidRow(
                    column(8,
                        HTML("<h3 style='font-weight:bold;'>Explore the data</h3>")
                    ),
                    column(4,
                        a(href="http://www.defenders.org",
                            imageOutput("defenders", height=NULL))
                    )
                ),

                # Add in the data selectors:
                box(title="Selection criteria",
                    status="primary",
                    solidHeader=TRUE,
                    height=NULL,
                    width=NULL,
                    collapsible=TRUE,
                    collapsed=TRUE,
                    selectInput(
                        inputId="state",
                        label="State",
                        choices=states,
                        selected="All",
                        multiple=FALSE,
                        width="95%"
                    ),
                    selectInput(
                        inputId="species",
                        label="Species",
                        choices=species,
                        selected="All",
                        multiple=FALSE,
                        width="95%"
                    ),
                    selectInput(
                        inputId="groups",
                        label="Taxonomic group",
                        choices=groups,
                        selected="All",
                        width="95%"
                    ),
                    selectInput(
                        inputId="years",
                        label="Year",
                        choices=years,
                        selected="All",
                        width="95%"
                    ),
                    selectInput(
                        inputId="sources",
                        label="Funding source",
                        choices=c("All", "FWS", "Fed., non-FWS", "State"),
                        selected="All",
                        width="95%"
                    )
                ),

                # Let the user select which mini-figure is shown:
                selectInput(
                    inputId="mini_chart",
                    label=HTML("<h4>Which chart?</h4>"),
                    choices=c("Top 10% vs. bottom 90%",
                              "Top species",
                              "Expenditures by group",
                              "Expenditures by year",
                              "Est. expend. by state",
                              "Top counties"),
                    selected="Top 10% vs. bottom 90%",
                    width="95%"
                ),

                # Show the small chart:
                htmlOutput("small_chart"),
                bsButton("big_chart",
                         label="Larger",
                         style="primary",
                         size="small"),

                hr(),
                tags$div(id='help_img', class='bottom-align',
                    column(6,
                        bsButton("get_started",
                                 label="Getting Started",
                                 style="success"
                        )
                    ),
                    column(6,
                        bsButton("give_limits",
                                 label="Limitations",
                                 style="warning"
                        )
                    )
                )
            )
        )
    )
}
