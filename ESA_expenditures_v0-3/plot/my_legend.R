# Code to create a bubble and color gradient.
# Copyright (c) 2016 jmalcom@defenders.org

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

################################################################################
# A bubble-and-color gradient legend.
make_my_legend <- function(cur_dat, circ) {
    ylab <- ifelse(circ == "sep",
                   "-      # species      +",
                   "-     USD / species      +")
    legn <- ifelse(circ == "sep",
                   "Expenditures\n(million USD)",
                   "Expenditures\n($1,000s/species)")
    p <- ggplot(cur_dat, aes(factor(xaxs), spp)) +
         geom_point(aes(size=spp, colour=dol/1000000)) +
         geom_point(aes(size=spp)) +
         scale_size(range=c(2,11)) +
         scale_y_continuous(breaks=round(cur_dat$spp, 0),
                            limits=c(0, max(cur_dat$spp) + 0.1*max(cur_dat$spp))) +
         scale_colour_distiller(palette="RdYlBu", 
                                direction=1,
                                name=legn) + 
         guides(size=FALSE) +
         labs(x="", y=ylab) +
         theme_tufte(ticks=FALSE) +
         theme(axis.text.x=element_blank(),
               axis.text.y=element_blank(),
               text=element_text(size=12, family="OpenSans"),
               legend.text=element_text(size=11), 
               legend.title=element_text(size=11),
               legend.title.align=-1,
               legend.key.width=unit(14, "points"),
               legend.position="right")
    return(p)
}
