# Histogram templates for Shiny apps.
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

##############################################################################
# Histogram of consultation times
make_spending_time_line <- function(all, height="365px") {
    dat <- make_spend_time_df(all())
    chart <- gvisLineChart(dat,
                 xvar="year", 
                 yvar=c("FWS", "fws.html.tooltip", "other fed", "other fed.html.tooltip", "state", "state.html.tooltip"),
                 options = list(legend="{ position: 'top' }",
                                height=height,
                                # colors="['#0A4783', '#f49831']",
                                vAxis="{title: 'Money Spent (American $)'}",
                                hAxis="{title: 'Year', format: ''}",
                                tooltip="{isHtml: 'true'}")
    )
    chart
}
