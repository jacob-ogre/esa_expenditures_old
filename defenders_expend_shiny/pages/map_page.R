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
                HTML("<link href='https://fonts.googleapis.com/css?family=Open+Sans:300,400' rel='stylesheet' type='text/css'>
                     <link rel='stylesheet' href='http://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css'/>"),
                includeCSS("www/custom_styles.css"),
                includeScript("www/gomap.js"),
                includeScript("www/leaflet.zoomhome.js")
            ),
            tags$style(type="text/css", "body {padding-top: 80px;}"),
            leafletOutput("map", height="100%", width="100%"),

            # Although this panel comes in further down the page than the data
            # selection panel, we call this one first so that it is "overtopped"
            # by an expanded data selection panel (until the selection panel is
            # shrunk again)
            absolutePanel(id = "controls", class = "panel panel-default", 
                fixed = TRUE, draggable = TRUE, top = 190, left = "auto", 
                right = 20, bottom = "auto", width = 250, height = "auto",

                # Let the user select which basemap is used:
                box(title="Map options",
                    status="warning",
                    solidHeader=FALSE,
                    height=NULL,
                    width=NULL,
                    collapsible=TRUE,
                    collapsed=TRUE,
                    selectInput(
                        inputId="map_tile",
                        label=HTML("<h4>Select basemap</h4>"),
                        choices=c("Stamen toner light" = "Stamen.TonerLite",
                                  "Stamen toner dark" = "Stamen.Toner",
                                  "Stamen watercolor" = "Stamen.Watercolor",
                                  "OpenStreetMap Mapnik" = "OpenStreetMap.Mapnik",
                                  "Open Topo" = "OpenTopoMap"),
                        width="95%"
                    ),
                    radioButtons(
                        inputId="circ_rep",
                        label=HTML("<h4>Circle representation</h4>"),
                        choices=c("Size = # species, Color = Expend." = "sep",
                                  "Size, Color = Expend. per species" = "combo"),
                        width="95%"
                    )
                )
            ),

            # Although this panel comes in further down the page than the data
            # selection panel, we call this one first so that it is "overtopped"
            # by an expanded data selection panel (until the selection panel is
            # shrunk again)
            absolutePanel(id = "controls", class = "panel panel-default", 
                fixed = TRUE, draggable = TRUE, top = 125, left = "auto", 
                right = 20, bottom = "auto", width = 250, height = "auto",

                # Let the user select which mini-figure is shown:
                box(title="Simple charts",
                    status="warning",
                    solidHeader=FALSE,
                    height=NULL,
                    width=NULL,
                    collapsible=TRUE,
                    collapsed=TRUE,
                    selectInput(
                        inputId="mini_chart",
                        label=HTML("<h4>Which chart?</h4>"),
                        selectize=FALSE,
                        choices=c("Top 10% vs. bottom 90%",
                                  "Top species",
                                  "Expenditures by group",
                                  "Expenditures by year",
                                  "Est. expend. by state",
                                  "Top counties"),
                        selected="Top 10% vs. bottom 90%",
                        width="95%"
                    ),

                    # Show the small chart and give button for modal:
                    htmlOutput("small_chart"),
                    bsButton("big_chart",
                             label="Larger",
                             style="primary",
                             size="small")
                )
            ),

            # # Add the heuristic key...
            # # # Not sure why this isn't showing up as intended...for later...
            # absolutePanel(id = "help-button-box", class = "panel panel-default", 
            #     fixed = TRUE, draggable = TRUE, top = "auto", left = "auto", 
            #     right = 20, bottom = "100px", width = 330, height = "auto",
            #     div(style="right:0;",
            #         imageOutput("heuristic", height=NULL))
            # ),

            # Add the help buttons in the bottom-right
            absolutePanel(id = "help-button-box", class = "panel panel-default", 
                fixed = TRUE, draggable = TRUE, top = "auto", left = "auto", 
                right = 20, bottom = "2%", width = 330, height = "70px",

                tags$div(id='help_img', class='bottom-align',
                    column(3),
                    column(5,
                        bsButton("get_started",
                                 label="Getting Started",
                                 style="success"
                        )
                    ),
                    column(4,
                        bsButton("give_limits",
                                 label="Limitations",
                                 style="warning"
                        )
                    )
                )
            ),

            # # Add the Defenders logo
            absolutePanel(id = "help-button-box", class = "panel panel-default", 
                fixed = TRUE, draggable = FALSE, top = 120, left = 10, 
                right = "auto", bottom = "auto", width = 200, height = "auto",
                a(href="http://www.defenders.org",
                    imageOutput("defenders", height=NULL))
            ),

            absolutePanel(id = "controls", class = "panel panel-default", 
                fixed = TRUE, draggable = TRUE, top = 60, left = "auto", 
                right = 20, bottom = "auto", width = 250, height = "auto",

                # Add in the data selectors:
                box(title="Filter data",
                    status="warning",
                    solidHeader=FALSE,
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
                        multiple=TRUE,
                        width="95%"
                    ),
                    selectInput(
                        inputId="sources",
                        label="Funding source",
                        choices=c("All", "FWS", "Fed., non-FWS", "State"),
                        selected="All",
                        width="95%"
                    )
                )
            )
        )
    )
}
