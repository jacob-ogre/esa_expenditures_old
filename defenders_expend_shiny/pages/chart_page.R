# Tab for exploring ESA expenditures charts, with text annotations
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

###############################################################################
# Tab for exploring ESA expenditures charts, with text annotations
chart_page <- {
    tabPanel(
        title="Charts",
        div(class="graph-outer",
		    tags$head(
                HTML("<link href='https://fonts.googleapis.com/css?family=Open+Sans:300,400' rel='stylesheet' type='text/css'>"),
                includeCSS("www/custom_styles.css")
            ),
            tags$style(type="text/css", "body {padding-top:30px;}"),
            column(2,
                absolutePanel(id="controls-graph", class="panel panel-default", 
                    fixed=TRUE, draggable=FALSE, top=110, left=40, 
                    right="auto", bottom="auto", width=230, height=NULL,
                    selectInput(
                        inputId="state_2",
                        label="State",
                        choices=states,
                        selected="All",
                        multiple=FALSE,
                        width="95%"
                    ),
                    selectInput(
                        inputId="species_2",
                        label="Species",
                        choices=species,
                        selected="All",
                        multiple=FALSE,
                        width="95%"
                    ),
                    selectInput(
                        inputId="groups_2",
                        label="Taxonomic group",
                        choices=groups,
                        selected="All",
                        width="95%"
                    ),
                    selectInput(
                        inputId="years_2",
                        label="Year",
                        choices=years,
                        selected="All",
                        width="95%"
                    ),
                    selectInput(
                        inputId="sources_2",
                        label="Funding source",
                        choices=c("All", "FWS", "Fed., non-FWS", "State"),
                        selected="All",
                        width="95%"
                    )
                )
            ),

            column(10,
                fluidRow(
                    column(3,
                        htmlOutput("spp_chart_text")
                    ),
                    column(9,
                        htmlOutput("big_spp_chart")
                    )
                ),
                hr(),
                fluidRow(
                    column(3,
                        htmlOutput("spp_chart_text_2")
                    ),
                    column(9,
                        htmlOutput("big_spp_chart_2")
                    )
                ),
                br()
            ),

            fluidRow(
                column(3),
                column(6,
                    div(HTML(defenders_cc()), style=center_text)
                ),
                column(3)
            ),
            br(), br()
        )
    )
}
