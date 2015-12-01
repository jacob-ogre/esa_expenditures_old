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

single_view_page <- {
    tabPanel(
        title="Main",
        fluidRow(
            column(1,
                br(), br(), br(),
                bsButton("get_started",
                         label="Getting Started",
                         style="primary"
                ),
                br(), br()
            ),
            column(10,
                br(), br(),
                h2("Endangered Species Expenditures",
                   style="text-align:center;font-weight:bold")
            ),
            column(1,
                br(), br(),
                a(href="http://www.defenders.org",
                    imageOutput("defenders", height=NULL))
            )
        ),

        fluidRow(
            column(12,
                box(title="Selection criteria",
                    status="primary",
                    solidHeader=FALSE,
                    height=NULL,
                    width=NULL,
                    collapsible=TRUE,
                    collapsed=TRUE,
                    column(2,
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
                        )
                    ),
                    column(2,
                        selectInput(
                            inputId="years",
                            label="Year",
                            choices=years,
                            selected="All",
                            width="95%"
                        ),
                        selectInput(
                            inputId="groups",
                            label="Taxonomic group",
                            choices=groups,
                            selected="All",
                            width="95%"
                        )
                    ),
                    column(2,
                        selectInput(
                          inputId="cty_st",
                          label="County, State",
                          choices=cty_st,
                          selected="All",
                          width="95%"
                        )
                    ),
                    column(6,
                        HTML("<p class='help-block'>Select your favorite state, species, county, and taxonomic group from drop-downs at left; graphs and maps will update automatically. You may select more than one category to filter on.  For example, if you're just interested in bull trout in Idaho and for expenses in 2009, then you may select each of those criteria (or any others as you see fit).")
                    )
                ),
                bsModal(id="open_select", 
                        title="Getting started",
                        trigger="get_started",
                        includeMarkdown("txt/getting_started.md")
                )
            )
        ),

        fluidRow(
            column(3),
            column(6,
                bsAlert("waiting")
            ),
            column(3)
        ),
        br(),


        fluidRow(
            column(9,
                box(title="Spending by State",
                    status="primary",
                    solidHeader=TRUE,
                    height=NULL,
                    width=NULL,
                    collapsible=TRUE,
                    collapsed=FALSE,
                    htmlOutput("consults_map"),
                    bsButton("modConsultsMap",
                             label="Larger",
                             style="primary",
                             size="small"
                    )
                )
            ),
            column(3,
                box(title="General Information",
                    status="primary",
                    solidHeader=TRUE,
                    height=NULL,
                    width=NULL,
                    collapsible=TRUE,
                    collapsed=FALSE,
                    fluidRow(
                          tipify(
                               valueBox(
                                   subtitle="Total dollars spent",
                                   value=textOutput("total_spent"),
                                   color="orange",
                                   icon=NULL,
                                   width=12
                               ),
                               title="Includes all funding sources."
                          )
                    ),
                    fluidRow(
                          tipify(
                               valueBox(
                                   subtitle="Number of species",
                                   value=textOutput("n_species"),
                                   color="blue",
                                   icon=NULL,
                                   width=12
                               ),
                               title="Number of species receiving funding."
                             )
                    ),
                    fluidRow(
                        box(width=12,
                            solidHeader = TRUE,
                            htmlOutput("percentage_chart")
                            # bsButton("modPercentChart",
                            #          label="Larger",
                            #          style="primary",
                            #          size="small"
                            # )
                        )
                    )
                )
            ),
            bsModal("largeConsultsMap",
                    title="Spending by State",
                    trigger="modConsultsMap",
                    size="large",
                    fluidRow(
                        column(12,
                            htmlOutput("consults_map_large")
                        )
                    )
            )
        ),

        fluidRow(
            column(12,
                popify(
                    box(title="Spending by Species (Top 25)",
                        status="primary",
                        solidHeader=TRUE,
                        height=NULL,
                        width=NULL,
                        collapsible=TRUE,
                        collapsed=FALSE,
                        htmlOutput("consults_species"),
                        bsButton("modConsultsSpecies",
                                 label="Larger",
                                 style="primary",
                                 size="small")
                    ),
                    title="Species",
                    content="If your favorite species isn't here, try searching in the 'Selection criteria' box."
                )
            ),
            bsModal("largeConsultsSpecies",
                    title="Spending by Species (Top 25)",
                    trigger="modConsultsSpecies",
                    size="large",
                    htmlOutput("consults_species_large")
            )
        ),

        fluidRow(
            column(6,
                box(title="Spending Changes Over Time",
                    status="primary",
                    solidHeader=TRUE,
                    height=NULL,
                    width=NULL,
                    collapsible=TRUE,
                    collapsed=FALSE,
                    htmlOutput("spending_time"),
                    # helpText(""),
                    bsButton("modSpendingTime",
                             label="Larger",
                             style="primary",
                             size="small"
                    )
                )
            ),
            column(6,
                box(title="Spending per Taxonomic Group",
                    status="primary",
                    solidHeader=TRUE,
                    height=NULL,
                    width=NULL,
                    collapsible=TRUE,
                    collapsed=FALSE,
                    htmlOutput("spend_tax_group"),
                    bsButton("modTaxSpending",
                             label="Larger",
                             style="primary",
                             size="small"
                    )
                )
            ),
            bsModal("largeSpendingTime",
                    title="Spending Changes Over Time",
                    trigger="modSpendingTime",
                    size="large",
                    htmlOutput("spending_time_large")
            ),
            bsModal("largeTaxSpending",
                    title="Spending per Taxonomic Group",
                    trigger="modTaxSpending",
                    size="large",
                    htmlOutput("spend_tax_group_large")
            )
        ),

        fluidRow(
            column(6,
                box(title="Spending by State (Top 10)",
                    status="primary",
                    solidHeader=TRUE,
                    height=NULL,
                    width=NULL,
                    collapsible=TRUE,
                    collapsed=FALSE,
                    htmlOutput("spend_state"),
                    bsButton("modSpendState",
                             label="Larger",
                             style="primary",
                             size="small")
                )
            ),
        column(6,
            box(title="Spending By County (Top 10)",
                status="primary",
                solidHeader=TRUE,
                height=NULL,
                width=NULL,
                collapsible=TRUE,
                collapsed=FALSE,
                htmlOutput("spend_county"),
                bsButton("modSpendCounty",
                         label="Larger",
                         style="primary",
                         size="small")
            )
        ),
            bsModal("largeSpendState",
                    title="Spending by State (Top 10)",
                    trigger="modSpendState",
                    size="large",
                    htmlOutput("spend_state_large")
            ),
              bsModal("largeSpendCounty",
                      title="Spending By County (Top 10)",
                      trigger="modSpendCounty",
                      size="large",
                      htmlOutput("spend_county_large")
              )
        ),

        # a placeholder
        fluidRow(
            column(12,
                imageOutput("a_line", height="5px", width="100%")
            )
        ),

        hr(),
        # fluidRow(
        #     column(2),
        #     column(3,
        #         HTML("<h4 style='font-weight:bold'>Alternate views</h4> <p style='font-size:larger'>Check out the <span style='font-weight:bold'>Alternate Map</span> page for a different geographic view, the <span style='font-weight:bold'>Comparison View</span> page for side-by-side comparisons, and the <span style='font-weight:bold'>Data</span> page to get the raw data.</p>")
        #     ),
        #     column(2),
        #     column(3,
        #         shinyURL.ui(label=HTML("<h4 style='font-weight:bold'>Share your selection!</h4>"))
        #     ),
        #     column(2)
        # ),
        hr(),

        fluidRow(
            column(3),
            column(6,
                br(),
                br()
            ),
            column(3)
        ),

        fluidRow(
            column(3),
            column(6,
                div(HTML(defenders_cc()), style=center_text)
            ),
            column(3)
        )
    )
}
