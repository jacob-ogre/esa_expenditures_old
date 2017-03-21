# Linegraphs used in the End. Sp. expenditures portal.
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
# Fed spending through time
make_fed_spending_fig <- function(dat) {
    if (length(dat()$Year) == 0) {
        return(make_no_data_plot3())
    }

    ann_tot <- tapply(dat()$Fed_tot, INDEX=dat()$Year, FUN=sum, na.rm=TRUE)
    ann_FWS <- tapply(dat()$FWS_tot, INDEX=dat()$Year, FUN=sum, na.rm=TRUE) 
    ann_fed <- tapply(dat()$other_fed, INDEX=dat()$Year, FUN=sum, na.rm=TRUE) 
    ann_stt <- tapply(dat()$State_tot, INDEX=dat()$Year, FUN=sum, na.rm=TRUE) 

    count_spp <- function(x) {length(levels(droplevels(as.factor(x))))}
    ann_spp <- tapply(dat()$Scientific, INDEX=dat()$Year, FUN=count_spp)

    inflation <- c(1.099396191, 1.103496503, 1.085281981, 1.052467763,
                   1.030923345, 1.015879828)
    infl_rate <- rep(inflation, 4)

    data <- c(ann_tot / 1000000, 
              ann_FWS / 1000000, 
              ann_fed / 1000000, 
              ann_stt / 1000000)
    catg <- c(rep("Total", length(ann_tot)),
              rep("FWS", length(ann_FWS)),
              rep("Other fed.", length(ann_fed)),
              rep("States", length(ann_stt)))
    years <- names(data)
    n_spp <- rep(ann_spp, 4)
    exp_per_spp <- data / n_spp
    infl_adj <- data * infl_rate
    cur_dat <- data.frame(years, data, catg, n_spp, exp_per_spp, infl_rate,
                          infl_adj)

    afig <- ggplot(cur_dat, aes(x=years, y=infl_adj, group=catg)) +
            geom_line(aes(colour=catg)) +
            geom_point(aes(colour=catg), size=4) +
            scale_colour_manual(values=cbbPalette) +
            labs(colour="Category")

    py <- plotly(username="jacob-ogre", key="ykd3h99z9v")
    res <- py$ggplotly(afig, 
                       kwargs=list(filename="Fed spending infl. adj.", 
                                   fileopt="overwrite", 
                                   layout=make_layout(ylab="Spending ($, millions)",
                                                      title="Total spending",
                                                      t=50, l=50),
                                   auto_open=FALSE))
    basic_frame(res, 500, width="100%")
}

make_fed_spend_per_spp_fig <- function(dat) {
    if (length(dat()$Year) == 0) {
        return(make_no_data_plot3())
    }

    ann_tot <- tapply(dat()$Fed_tot, INDEX=dat()$Year, FUN=sum, na.rm=TRUE)
    ann_FWS <- tapply(dat()$FWS_tot, INDEX=dat()$Year, FUN=sum, na.rm=TRUE) 
    ann_fed <- tapply(dat()$other_fed, INDEX=dat()$Year, FUN=sum, na.rm=TRUE) 
    ann_stt <- tapply(dat()$State_tot, INDEX=dat()$Year, FUN=sum, na.rm=TRUE) 

    count_spp <- function(x) {length(levels(droplevels(as.factor(x))))}
    ann_spp <- tapply(dat()$Scientific, INDEX=dat()$Year, FUN=count_spp)

    inflation <- c(1.099396191, 1.103496503, 1.085281981, 1.052467763,
                   1.030923345, 1.015879828)
    infl_rate <- rep(inflation, 4)

    data <- c(ann_tot / 1000000, 
              ann_FWS / 1000000, 
              ann_fed / 1000000, 
              ann_stt / 1000000)
    catg <- c(rep("Total", length(ann_tot)),
              rep("FWS", length(ann_FWS)),
              rep("Other fed.", length(ann_fed)),
              rep("States", length(ann_stt)))
    years <- names(data)
    n_spp <- rep(ann_spp, 4)
    exp_per_spp <- data / n_spp
    infl_adj <- data * infl_rate
    cur_dat <- data.frame(years, data, catg, n_spp, exp_per_spp, infl_rate,
                          infl_adj)
    bfig <- ggplot(cur_dat, aes(x=years, y=infl_adj / n_spp, group=catg)) +
            geom_line(aes(colour=catg)) +
            geom_point(aes(colour=catg), size=4) +
            scale_colour_manual(values=cbbPalette) +
            labs(colour="Category", 
                 x="Year", 
                 y="",
                 title="Per-species spending")

    py <- plotly(username="jacob-ogre", key="ykd3h99z9v")
    res <- py$ggplotly(bfig, 
                       kwargs=list(filename="Fed spending per spp., infl. adj.", 
                                   fileopt="overwrite", 
                                   layout=make_layout(ylab="Spending ($, millions)",
                                                      title="Per-species spending",
                                                      t=50, l=50),
                                   auto_open=FALSE))
    basic_frame(res, 500, width="100%")
}

#############################################################################
# FWS spending through time
make_fws_spending_fig <- function(dat) {
    if (length(dat()$Year) == 0) {
        return(make_no_data_plot3())
    }

    ann_FWS <- tapply(dat()$FWS_tot, INDEX=dat()$Year, FUN=sum, na.rm=TRUE) 

    count_spp <- function(x) {length(levels(droplevels(as.factor(x))))}
    ann_spp <- tapply(dat()$Scientific, INDEX=dat()$Year, FUN=count_spp)

    inflation <- c(1.099396191, 1.103496503, 1.085281981, 1.052467763,
                   1.030923345, 1.015879828)
    infl_rate <- rep(inflation, 1)

    data <- c(ann_FWS / 1000000)
    catg <- c(rep("FWS", length(ann_FWS)))
    years <- names(data)
    n_spp <- ann_spp
    exp_per_spp <- data / n_spp
    infl_adj <- data * infl_rate
    cur_dat <- data.frame(years, data, catg, n_spp, exp_per_spp, infl_rate,
                          infl_adj)

    afig <- ggplot(cur_dat, aes(x=years, y=infl_adj, group=1)) +
            geom_line(colour="steelblue3", size=1) +
            geom_point(colour="steelblue3", size=4) +
            labs(colour="Category", 
                 x="Year", 
                 y="Spending ($, millions)
                   ",
                 title="FWS spending")

    py <- plotly(username="jacob-ogre", key="ykd3h99z9v")
    res <- py$ggplotly(afig, 
                       kwargs=list(filename="FWS spending, infl. adj.", 
                                   fileopt="overwrite", 
                                   layout=make_layout(ylab="Spending ($, millions)",
                                                      title="FWS total spending",
                                                      t=50, l=50),
                                   auto_open=FALSE))
    basic_frame(res, 500, width="100%")
}


make_fws_spend_per_spp_fig <- function(dat) {
    if (length(dat()$Year) == 0) {
        return(make_no_data_plot3())
    }

    ann_FWS <- tapply(dat()$FWS_tot, INDEX=dat()$Year, FUN=sum, na.rm=TRUE) 

    count_spp <- function(x) {length(levels(droplevels(as.factor(x))))}
    ann_spp <- tapply(dat()$Scientific, INDEX=dat()$Year, FUN=count_spp)

    inflation <- c(1.099396191, 1.103496503, 1.085281981, 1.052467763,
                   1.030923345, 1.015879828)
    infl_rate <- rep(inflation, 1)

    data <- c(ann_FWS / 1000000)
    catg <- c(rep("FWS", length(ann_FWS)))
    years <- names(data)
    n_spp <- ann_spp
    exp_per_spp <- data / n_spp
    infl_adj <- data * infl_rate
    cur_dat <- data.frame(years, data, catg, n_spp, exp_per_spp, infl_rate,
                          infl_adj)
    bfig <- ggplot(cur_dat, aes(x=years, y=infl_adj / n_spp, group=1)) +
            geom_line(colour="steelblue3", size=1) +
            geom_point(colour="steelblue3", size=4) +
            scale_colour_manual(values=cbbPalette) +
            labs(colour="Category", 
                 x="Year", 
                 y="",
                 title="Per-species FWS spending")

    py <- plotly(username="jacob-ogre", key="ykd3h99z9v")
    res <- py$ggplotly(bfig, 
                       kwargs=list(filename="FWS spending per spp., infl. adj.", 
                                   fileopt="overwrite", 
                                   layout=make_layout(ylab="Spending ($, millions)",
                                                      title="FWS Per-species spending",
                                                      t=50, l=50),
                                   auto_open=FALSE))
    basic_frame(res, 500, width="100%")
}

