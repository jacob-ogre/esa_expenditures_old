# Generate a blank graph that says no data is available
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
# You ain't got no data! plot
#############################################################################
make_no_data_plot <- function() {
    dat <- data.frame(x=rep(10, 10), 
                      y=rep(10, 10))
    noData <- ggplot(data=dat, aes(x, y)) +
              geom_point(stat="identity", alpha=0) +
              labs(x="", y="") +
              theme(axis.text.x=element_blank(),
                    axis.text.y=element_blank(),
                    axis.ticks=element_blank(),
                    axis.title.x=element_blank(),
                    axis.title.y=element_blank(),
                    legend.position="none") +
              annotate("text", 
                       x=10, 
                       y=10, 
                       size=10,
                       colour="#D00000",
                       label="No data meets selection criteria")
    return(noData)
}

make_no_data_plot2 <- function() {
    dat <- data.frame(x=rep(10, 10), 
                      y=rep(10, 10))
    noData <- ggplot(data=dat, aes(x, y)) +
              geom_point(stat="identity", alpha=0) +
              labs(x="", y="") +
              theme(axis.text.x=element_blank(),
                    axis.text.y=element_blank(),
                    axis.ticks=element_blank(),
                    axis.title.x=element_blank(),
                    axis.title.y=element_blank(),
                    legend.position="none") +
              annotate("text", 
                       x=10, 
                       y=10, 
                       size=8,
                       colour="#D00000",
                       label="Please select a state\n for summary figure")
    return(noData)
}

make_no_data_plot3 <- function() {
    dat <- data.frame(x=rep(10, 10), 
                      y=rep(10, 10))
    noData <- ggplot(data=dat, aes(x, y)) +
              geom_point(stat="identity", alpha=0) +
              labs(x="", y="") +
              theme(axis.text.x=element_blank(),
                    axis.text.y=element_blank(),
                    axis.ticks=element_blank(),
                    axis.title.x=element_blank(),
                    axis.title.y=element_blank(),
                    legend.position="none") +
              annotate("text", 
                       x=10, 
                       y=10, 
                       size=8,
                       colour="#D00000",
                       label="Please select another year\n for summary figure")
    return(noData)
}

