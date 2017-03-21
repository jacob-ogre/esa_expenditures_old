# Bargraphs used in the Section 7 database interface.
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

require(grid)

#############################################################################
# Make a figure with top 20 states (by total) & selection mean
make_state_spend <- function(state_sub, state_all) {
    if (dim(state_sub())[1] == 0) {
        return(make_no_data_plot())
    }
    select_mean <- mean(state_sub()$Grand_Total, na.rm=TRUE)
    st_tot <- tapply(state_all$Grand_Total, 
                     INDEX=state_all$State,
                     FUN=sum, na.rm=TRUE)
    st_tot <- st_tot / 1000000
    subTab <- data.frame(sort(st_tot, decreasing=TRUE))
    names(subTab) <- "st_tot"
    subTab$State <- rownames(subTab)
    subFig <- ggplot(data=subTab, aes(x=reorder(factor(State), -st_tot), y=st_tot)) +
              geom_bar(stat="identity", fill="steelblue3") + 
              labs(x="",
                   y="Spending ($, millions)
                     ",
                   title="") +
              theme(axis.text.x=element_text(angle=25, vjust=1, hjust=1))

    py <- plotly(username="jacob-ogre", key="ykd3h99z9v")
    res <- py$ggplotly(subFig, 
                       kwargs=list(filename="Spending by state", 
                                   fileopt="overwrite", 
                                   layout=make_layout(ylab="Spending ($, millions)",
                                                      t=50, l=50),
                                   auto_open=FALSE))
    basic_frame(res, 600)
}

#############################################################################
# Make a bargraph of spending by taxonomic group, sorted
make_group_spend <- function(state_sub, state_all) {
    if (dim(state_sub())[1] == 0) {
        return(make_no_data_plot())
    }
    select_mean <- mean(state_sub()$Grand_Total, na.rm=TRUE)
    grp_tot <- tapply(state_all$Grand_Total, 
                     INDEX=state_all$Group,
                     FUN=sum, na.rm=TRUE)
    grp_tot <- grp_tot / 1000000
    subTab <- data.frame(sort(grp_tot, decreasing=TRUE))
    names(subTab) <- "grp_tot"
    subTab$State <- rownames(subTab)
    subFig <- ggplot(data=subTab, aes(x=reorder(factor(State), -grp_tot), y=grp_tot)) +
              geom_bar(stat="identity", fill="steelblue3") + 
              labs(x="",
                   y="Spending ($, millions)
                     ",
                   title="") +
              theme(axis.text.x=element_text(angle=25, vjust=1, hjust=1))

    py <- plotly(username="jacob-ogre", key="ykd3h99z9v")
    res <- py$ggplotly(subFig, 
                       kwargs=list(filename="Spending by taxonomic group", 
                                   fileopt="overwrite", 
                                   layout=make_layout(ylab="Spending ($, millions)",
                                                      t=50, l=50),
                                   auto_open=FALSE))
    basic_frame(res, 600)
}

#############################################################################
# Make a very basic plot of the summary table
make_state_summary_fig <- function(state_sub, fed_sub) {
    if (length(levels(droplevels(as.factor(state_sub()$State)))) > 1) {
        return(tags$p(""))
    } else if (length(state_sub()$State) == 0) {
        return(tags$p(""))
    }

    min_st_yr <- min(as.numeric(as.character(state_sub()$Year)), na.rm=TRUE)
    max_st_yr <- max(as.numeric(as.character(state_sub()$Year)), na.rm=TRUE)
    fed_comp <- fed_sub()[as.numeric(as.character(fed_sub()$Year)) <= max_st_yr &
                          as.numeric(as.character(fed_sub()$Year)) >= min_st_yr,]

    tot_state_expend <- sum(state_sub()$Grand_Total, na.rm=TRUE)
    gen_state_expend <- sum(state_sub()$General_Expenditures, na.rm=TRUE)
    lan_state_expend <- sum(state_sub()$Land_Expenditures, na.rm=TRUE)
    fed_expend_spp <- sum(fed_comp$Fed_tot, na.rm=TRUE)
    tmp_dat <- c(fed_expend_spp, 
                 tot_state_expend, 
                 gen_state_expend,
                 lan_state_expend)
    tmp_dat <- tmp_dat / 1000000
    vars <- c("Fed. exp. for state spp.",
              "Total state expenditures",
              "General state exp.",
              "Land state exp.")
    tmp_df <- data.frame(vars, tmp_dat)

    allFig <- ggplot(data=tmp_df, aes(x=factor(vars), y=tmp_dat)) +
              geom_bar(stat="identity", fill="steelblue3") + 
              labs(x="",
                   y="Spending ($, millions)")

    py <- plotly(username="jacob-ogre", key="ykd3h99z9v")
    res <- py$ggplotly(allFig, 
                       kwargs=list(filename="State summary", 
                                   fileopt="overwrite", 
                                   layout=make_layout(ylab="Spending ($, millions)",
                                                      t=10),
                                   auto_open=FALSE))

    basic_frame(res, 400)
}

#############################################################################
# Make a plot of top species for selected state
make_top_state_spp <- function(state_sub) {
    if (length(levels(droplevels(as.factor(state_sub()$State)))) > 1) {
        return(tags$p(""))
    } else if (length(state_sub()$State) == 0) {
        return(tags$p(""))
    }

    sp_tot <- tapply(state_sub()$Grand_Total,
                     INDEX=state_sub()$Common,
                     FUN=sum, na.rm=TRUE)
    n_spp <- length(sp_tot)
    sp_tot <- sp_tot / 1000000
    subTab <- data.frame(row.names(sp_tot), sp_tot)
    names(subTab) <- c("Species", "Expend")
    subTab <- subTab[order(-subTab$Expend), ]
    subTab <- subTab[1:min(c(n_spp, 30)), ]
    subTab <- subTab[!is.na(subTab$Species), ]

    allFig <- ggplot(subTab, aes(x=reorder(factor(Species), -Expend), y=Expend)) +
              geom_bar(stat="identity", fill="steelblue3") +
              labs(x="",
                   y="Spending ($, millions)
                     ",
                   title="") 

    py <- plotly(username="jacob-ogre", key="ykd3h99z9v")
    res <- py$ggplotly(allFig, 
                       kwargs=list(filename="Top species for state", 
                                   fileopt="overwrite", 
                                   layout=make_layout(ylab="Spending ($, millions)",
                                                      t=10),
                                   auto_open=FALSE))
    basic_frame(res, 500)
}

#############################################################################
# Make a plot of top groups for selected state
make_state_group_fig <- function(state_sub) {
    if (length(levels(droplevels(as.factor(state_sub()$State)))) > 1) {
        return(tags$p(""))
    } else if (length(state_sub()$State) == 0) {
        return(tags$p(""))
    }
    sp_tot <- tapply(state_sub()$Grand_Total,
                     INDEX=state_sub()$Group,
                     FUN=sum, na.rm=TRUE)
    sp_tot <- sp_tot / 1000000
    subTab <- data.frame(row.names(sp_tot), sp_tot)
    names(subTab) <- c("Group", "Expend")
    row.names(subTab) <- c(1:length(subTab$Expend))
    subTab <- subTab[order(-subTab$Expend), ]
    # observe({ print(subTab) })
    subTab <- subTab[!is.na(subTab$Group), ]

    allFig <- ggplot(subTab, aes(x=reorder(factor(Group), -Expend), y=Expend)) +
              geom_bar(stat="identity", fill="steelblue3") +
              labs(x="",
                   y="Spending ($, millions)
                     ",
                   title="") +
              theme(axis.text.x=element_text(angle=35, vjust=1, hjust=1))
    py <- plotly(username="jacob-ogre", key="ykd3h99z9v")
    res <- py$ggplotly(allFig, 
                       kwargs=list(filename="Group state expenditures", 
                                   fileopt="overwrite", 
                                   layout=make_layout(ylab="Spending ($, millions)",
                                                      t=10),
                                   auto_open=FALSE))
    basic_frame(res, 500)
}


