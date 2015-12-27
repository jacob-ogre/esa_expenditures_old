# Functions to subset an input dataset, x.
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
# Return a subset of the Sec7 db (x) based on a suite of variables.
##############################################################################
sub_df <- function(x, years, groups, species, state, src) {
    if (years != "All") {
        x <- x[x$Year == years, ]
    }
    if (groups != "All") {
        x <- x[x$Group %in% groups, ]
    }
    if (species != "All") {
        x <- x[x$sp %in% species, ]
    }
    if (state != "All") {
        x <- x[x$STATE %in% state, ]
    }
    if (src == "All") {
        x$exp_report <- x$grand_per_cnty
    } else if (src == "FWS") {
        x$exp_report <- x$fws_per_cnty
    } else if (src == "Fed., non-FWS") {
        x$exp_report <- x$other_fed_per_cnty
    } else {
        x$exp_report <- x$state_per_cnty
    }
    x$st_co_sp <- paste(x$cs, x$sp)
    x$st_co_yr <- paste(x$cs, x$Year)
    return(x)

}

