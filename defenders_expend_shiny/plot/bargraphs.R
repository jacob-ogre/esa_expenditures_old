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
make_species_plot <- function(dat, height="475px", chartHeight="65%", mini=FALSE) {
    cur_dat <- make_top_25_species_df(dat)
    left <- nchar(as.character(cur_dat$species[1])) * 5
    if (left > 200) {
        left <- 200
    }
    if (!mini) {
        chartArea <- paste("{left: ", left, ", top: 50, width: '90%', height: '",
                           chartHeight, "'}", sep="")
    } else {
        chartArea <- ""
    }
    chart2 <- gvisColumnChart(cur_dat,
                  xvar="species",
                  yvar=c("other fed", "other fed.html.tooltip", "FWS", 
                         "fws.html.tooltip", "state", "state.html.tooltip"),
                  options = list(height=height,
                                 colors="['#0A4783', '#f49831', '#e60000']",
                                 legend="{position: 'top'}",
                                 vAxis="{title: 'Expenditures (USD)'}",
                                 chartArea=chartArea,
                                 isStacked=T,
                                 tooltip="{isHtml: 'true'}")
             )
    chart2
}

#############################################################################
# Spending by taxonomic group barchart
make_tax_group_plot <- function(dat, height="440px", chartHeight="65%", mini=FALSE) {
    cur_dat2 <- make_tax_group_df(dat)
    if (!mini) {
        chartArea <- paste("{left: ", 200, ", top: 50, width: '90%', height: '",
                           chartHeight, "'}", sep="")
    } else {
        chartArea <- ""
    }
    chart3 <- gvisColumnChart(cur_dat2,
                  xvar="group",
                  yvar=c("other fed", "other fed.html.tooltip", "FWS", 
                         "fws.html.tooltip", "state", "state.html.tooltip"),
                  options = list(height=height,
                                 colors="['#0A4783', '#f49831', '#e60000']",
                                 legend="{position: 'top'}",
                                 vAxis="{title: 'Expenditures (USD)'}",
                                 chartArea=chartArea,
                                 isStacked=T,
                                 tooltip="{isHtml: 'true'}")
             )
    chart3
}

#############################################################################
# Spending by taxonomic group and counties occupied 
make_group_bubble_plot <- function(dat, height="440px", chartHeight="65%") {
    cur_dat9 <- make_group_bubble_df(dat)
    chartArea <- paste("{left: 200", ", top: 50, width: '90%', height: '",
                       chartHeight, "'}", sep="")
    xAxisVals <- paste0("{title: '# counties occupied', logScale: 'true', 
                        maxValue: ", 1.5*max(cur_dat9$`N counties occupied`), "}")
    chart <- gvisBubbleChart(cur_dat9,
                 idvar="group",
                 xvar="N counties occupied",
                 yvar="Expenditures",
                 colorvar="group",
                 sizevar="N species",
                 options = list(height=height,
                                legend="{position: 'none'}",
                                vAxis="{title: 'Expenditures (USD)',
                                        logScale: 'true' }",
                                hAxis=xAxisVals,
                                chartArea=chartArea,
                                bubble="{opacity: 0.6}",
                                sizeAxis="{minValue: 5, maxSize: 50}")
                 )
    chart
}

#############################################################################
# Spending by taxonomic group and counties occupied version 2
make_group_bubble_plot_2 <- function(dat, height="440px", chartHeight="65%") {
    cur_dat9 <- make_group_bubble_df(dat)
    chartArea <- paste("{left: 200", ", top: 50, width: '90%', height: '",
                       chartHeight, "'}", sep="")
    xAxisVals <- paste0("{title: '# species in group', logScale: 'true', 
                        maxValue: ", 1.5*max(cur_dat9$`N species`), "}")
    chart <- gvisBubbleChart(cur_dat9,
                 idvar="group",
                 xvar="N species",
                 yvar="Expenditures",
                 colorvar="group",
                 sizevar="N counties occupied",
                 options = list(height=height,
                                legend="{position: 'none'}",
                                vAxis="{title: 'Expenditures (USD)',
                                        logScale: 'true' }",
                                hAxis=xAxisVals,
                                chartArea=chartArea,
                                bubble="{opacity: 0.6}",
                                sizeAxis="{minValue: 5, maxSize: 50}")
                 )
    chart
}

#############################################################################
# Top State spending barchart
make_spend_state_plot <- function(dat, height="500px", chartHeight="65%", 
                                  mini=FALSE) {
    cur_dat <- make_top_25_states_df(dat())
    if (!mini) {
        chartArea <- paste("{left: ", 200, ", top: 50, width: '90%', height: '",
                           chartHeight, "'}", sep="")
    } else {
        chartArea <- ""
    }
    chart4 <- gvisColumnChart(cur_dat,
                 xvar="st",
                 yvar=c("other fed", "other fed.html.tooltip", "FWS", 
                        "fws.html.tooltip", "state", "state.html.tooltip"),
                 options = list(height=height,
                                colors="['#0A4783', '#f49831', '#e60000']",
                                legend="{position: 'top'}",
                                vAxis="{title: 'Expenditures (USD)'}",
                                isStacked=T,
                                chartArea=chartArea,
                                tooltip="{isHtml: 'true'}")
             )
    chart4
}

#############################################################################
# Top State spending barchart with the selected state in column 1
make_select_state_spend_plot <- function(dat, sel_st, height="500px", 
                                         chartHeight="65%") {
    cur_dat <- make_select_top_24_states_df(dat, sel_st)
    chartArea <- paste("{left: 200", ", top: 50, width: '90%', height: '",
                       chartHeight, "'}", sep="")
    chart4 <- gvisColumnChart(cur_dat,
                 xvar="st",
                 yvar=c("other fed", "other fed.html.tooltip", "FWS", 
                        "fws.html.tooltip", "state", "state.html.tooltip"),
                 options = list(height=height,
                                colors="['#0A4783', '#f49831', '#e60000']",
                                legend="{position: 'top'}",
                                vAxis="{title: 'Expenditures (USD)'}",
                                isStacked=T,
                                chartArea=chartArea,
                                tooltip="{isHtml: 'true'}")
             )
    chart4
}

#############################################################################
# Top state spending barchart with per-species expenditure
make_per_spp_state_plot <- function(dat, height="500px", chartHeight="65%") {
    cur_dat <- make_per_spp_state_df(dat)
    chartArea <- paste("{left: 200", ", top: 50, width: '90%', height: '",
                       chartHeight, "'}", sep="")
    chart4 <- gvisColumnChart(cur_dat,
                 xvar="st",
                 yvar=c("per-sp other fed", "other fed.html.tooltip", 
                        "per-sp FWS", "fws.html.tooltip", "per-sp state", 
                        "state.html.tooltip"),
                 options = list(height=height,
                                colors="['#0A4783', '#f49831', '#e60000']",
                                legend="{position: 'top'}",
                                vAxis="{title: 'Per-species expenditures (USD)'}",
                                isStacked=TRUE,
                                chartArea=chartArea,
                                tooltip="{isHtml: 'true'}")
             )
    chart4
}

#############################################################################
# Top state spending barchart with per-species expenditure
make_rank_delta_plot <- function(dat, height="450px", chartHeight="85%") {
    chartArea <- paste("{left: 200", ", top: 50, width: '90%', height: '",
                       chartHeight, "'}", sep="")
    chart4 <- gvisBarChart(dat,
                           yvar=c("pos_change", "neg_change"),
                           xvar="state",
                           options=list(height=height,
                                        colors="['#0A4783', '#e60000']",
                                        fontSize=10,
                                        isStacked=TRUE,
                                        chartArea=chartArea))
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
