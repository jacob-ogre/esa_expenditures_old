# Functions to create two-variable scatterplots for Sec7 db.
# Copyright (C) 2015 Defenders of Wildlife

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

cbbPalette <- c("#000000", 
                "#E69F00",
                "#56B4E9",
                "#009E73",
                "#F0E442",
                "#0072B2",
                "#D55E00",
                "#CC79A7",
                "#FFFFFF")

#############################################################################
# Helper functions to get data subsets
#############################################################################
count_per_level <- function(x, y) {
    z <- tapply(x,
                INDEX=y,
                FUN=function(g) {length(levels(droplevels(g)))}
                )
    return(z)
}

#############################################################################
# Plotting functions
#############################################################################
selection_SVL_mass <- function(tmp) {
    afig <- ggplot(tmp(), aes(x=SVL, y=Mass)) + 
            geom_point(colour="gold3", alpha=0.4, size=5) + 
            labs(x="Snout-vent Length (mm)", 
                 y="Mass (g)")
    print(afig)
}


