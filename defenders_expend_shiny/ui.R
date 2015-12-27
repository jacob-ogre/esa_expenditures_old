# A Shiny Dashboard version of the expenditures app.
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

source("pages/results_page.R")
source("pages/chart_page.R")

#############################################################################
# Define the header and sidebar (disabled)
header <- dashboardHeader(disable=TRUE)
sidebar <- dashboardSidebar(disable=TRUE)

#############################################################################
# Define the page(s) with dashboardBody
body <- dashboardBody(
    bsModal(id="instructions",
            title="How do I use this app?",
            trigger="get_started",
            includeMarkdown("txt/getting_started.md"),
            size="large"
    ),
    bsModal(id="limits_disag",
            title="Know the limitations",
            trigger="give_limits",
            includeMarkdown("txt/disaggregation_limits.md"),
            size="small"
    ),
    bsModal(id="show_rank_change",
            title="Rank change comparing 'raw' and per-species spending",
            trigger="per_sp_rank_change",
            fluidRow(
                column(2,
                    HTML("<div style=font-size:smaller; color:gray><p>States (or 
                         territories) with strong positive rank changes tend to have 
                         lower overall expenditures, but also relatively few species. 
                         As a result, their relative ranking increases substantially 
                         once per-species spending is estimated.</p>
                         
                         <p>States with strong negative rank changes tend to have 
                         either (a) high spending and lots of species or (b) just a 
                         lot of species.</p>
                         
                         <p>Note that these rank changes say little about the
                         rank of each state, in terms of either 'raw' or per-species 
                         expenditures. However, we can be reasonably sure that 
                         states with large rank changes were probably on the ends
                         of the distribution of 'raw' or per-species lists.</p></div>")
                ),            
                column(10,
                    htmlOutput("rank_change_plot")
                )
            ),
            size="large"
    ),
    bsModal(id="datatable_help",
            title="Using the data table",
            trigger="table_help",
            HTML("<ul><li>Hover over the table and scroll right to see additional columns.</li>
                      <li>Search each column using the boxes at the top of the columns.</li>
                      <li>Sort the table by column using the arrows above each column.</li>
                      <li>Show/hide additional columns using the button at right.</li>
                 </ul>"),
            size="small"
    ),
    bsModal("mod_big_chart",
            title="",
            trigger="big_chart",
            size="large",
            htmlOutput("large_chart"),
            fluidRow(
                helpText("Check out the Charts page to get additional information.")
            )
    ),
    results_page
)

dashboardPage(header, sidebar, body, skin="blue")
# shinyUI(body)
