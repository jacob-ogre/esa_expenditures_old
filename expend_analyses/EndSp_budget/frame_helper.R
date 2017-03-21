# Functions to facilitate showing plotly in Shiny apps.
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


basic_frame <- function(x, height, width="100%") {
    return(tags$iframe(src=x$response$url,
                       frameBorder="0",
                       height=height,
                       width=width)
    )
}

make_layout <- function(l=100, t=100, r=100, b=100, 
                        ylab="", xlab="", title="") {
    layout <- list(margin=list(l=l, t=t, r=r, b=b),
                   yaxis=list(title=ylab),
                   xaxis=list(title=xlab),
                   title=title)
}
