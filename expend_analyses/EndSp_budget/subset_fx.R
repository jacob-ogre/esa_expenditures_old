# A function to subset the Leslie Canyon array data.
# Copyright (C) 2015 Jacob Malcom, jacob.w.malcom@gmail.com

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
# Return a subset of the Leslie Canyon array data based on selections.
##############################################################################

states_subset <- function(x, yr, state, group, sp) {
    if (yr != "All") {
        x <- x[x$Year == yr, ]
    }
    if (state != "All") {
        x <- x[x$State == state, ]
    }
    if (group != "All") {
        x <- x[x$Group == group, ]
    }
    if (sp != "All") {
        x <- x[x$Common == sp, ]
    }

    return(x)
}

all_subset <- function(x, st_dat, yr, state, group, sp) {
    if (yr != "All") {
        x <- x[x$Year == yr, ]
    }
    if (state != "All") {
        cur_sp <- as.character(levels(droplevels(as.factor(st_dat()$Common))))
        x <- x[as.character(x$Common) %in% cur_sp, ]
    }
    if (group != "All") {
        x <- x[x$Group == group, ]
    }
    if (sp != "All") {
        x <- x[x$Common == sp, ]
    }
    return(x)
}
