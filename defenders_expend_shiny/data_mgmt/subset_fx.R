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
sub_df <- function(x, years, groups, species, cty_st, state) {
    if (years != "All") {
        x <- x[x$Year %in% years, ]
    }
    if (groups != "All") {
        x <- x[x$Group %in% groups, ]
    }
    if (species != "All") {
        x <- x[x$sp %in% species, ]
    }
    if (cty_st != "All") {
        x <- x[x$cs %in% cty_st, ]
    }
    if (state != "All") {
        x <- x[x$STABBREV %in% state, ]
    }
    return(x)

}

