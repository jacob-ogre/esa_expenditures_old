# Bargraphs for the section 7 Shiny app.
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

#############################################################################
# Species summary barchart
make_species_plot <- function(dat, height="475px", chartHeight="65%") {
    cur_dat <- make_top_25_species_df(dat())
    # left <- nchar(as.character(cur_dat$species[1])) * 5
    # if (left > 200) {
    #     left <- 200
    # }
    # chartArea <- paste("{left: ", left, ", top: 50, width: '90%', height: '",
    #                    chartHeight, "'}", sep="")
    chart2 <- gvisColumnChart(cur_dat,
                 xvar="species",
                 yvar=c("FWS", "fws.html.tooltip", "other fed", 
                        "other fed.html.tooltip", "state", "state.html.tooltip"),
                 options = list(height=height,
                                # colors="['#0A4783']",
                                legend="{position: 'right'}",
                                vAxis="{title: 'Money Spent (American $)'}",
                                # chartArea=chartArea,
                                isStacked=T,
                                tooltip="{isHtml: 'true'}")
             )
    chart2
}

#############################################################################
# Spending by taxonomic group barchart
make_tax_group_plot <- function(dat, height="440px", chartHeight="65%") {
    cur_dat2 <- make_tax_group_df(dat())
    chart3 <- gvisColumnChart(cur_dat2,
                 xvar="group",
                 yvar=c("FWS", "fws.html.tooltip", "other fed", "other fed.html.tooltip", "state", "state.html.tooltip"),
                 # chartid=rand_str(),
                 options = list(height=height,
                                # colors="['#0A4783']",
                                legend="{position: 'top'}",
                                vAxis="{title: 'Money Spent (American $)'}",
                                isStacked=T,
                                tooltip="{isHtml: 'true'}")
             )
    chart3
}

#############################################################################
# Top State spending barchart
make_spend_state_plot <- function(dat, height="500px", chartHeight="65%") {
    cur_dat <- make_top_10_states_df(dat())
    chart4 <- gvisColumnChart(cur_dat,
                 xvar="st",
                 yvar=c("FWS", "fws.html.tooltip", "other fed", "other fed.html.tooltip", "state", "state.html.tooltip"),
                 options = list(height=height,
                                # colors="['#0A4783']",
                                legend="{position: 'top'}",
                                vAxis="{title: 'Money Spent (American $)'}",
                                isStacked=T,
                                tooltip="{isHtml: 'true'}")
             )
    chart4
}

#############################################################################
# Top County spending barchart
make_spend_county_plot <- function(dat, height="500px", chartHeight="65%") {
  cur_dat <- make_top_10_county_df(dat())
  chart5 <- gvisColumnChart(cur_dat,
                            xvar="county",
                            yvar=c("FWS", "fws.html.tooltip", "other fed", "other fed.html.tooltip", "state", "state.html.tooltip"),
                            options = list(height=height,
                                           # colors="['#0A4783']",
                                           legend="{position: 'top'}",
                                           vAxis="{title: 'Money Spent (American $)'}",
                                           isStacked=T,
                                           tooltip="{isHtml: 'true'}")
  )
  chart5
}

#############################################################################
# top 10% species spending versus bottom 90% chart
make_top10_low90_plot <- function(dat, height="100%") {
    per_dat <- make_percent_plot_df(dat())
    chart6 <- gvisColumnChart(per_dat,
        xvar="names",
        yvar=c("spent", "spent.html.tooltip"),
        options = list(legend="{position: 'none'}",
            height=height,
            colors="['#0A4783']",
            vAxis="{title: 'Expenditures (USD)', baseline: 0}",
            title="Spending on Top 10% of Species versus the Other 90%",
            isStacked=F,
            tooltip="{isHtml: 'true'}")
    )
    chart6
}
