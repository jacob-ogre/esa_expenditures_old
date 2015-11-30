# Functions to create dataframes, typically for plot generation.
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

############################################################################
# Create a small dataframe for front-page summary figure
# make_consult_year_summary_df <- function(x) {
#     cons_yr <- calculate_consults_per_year(x)
#     form_yr <- calculate_formal_per_year(x)
#     years <- names(cons_yr)
#     dat <- data.frame(years, as.vector(cons_yr), as.vector(form_yr))
#     names(dat) <- c("years", "all", "formal")
#     return(dat)
# }

############################################################################
# Create a small dataframe for top 25 species bar plot
make_top_25_species_df <- function(sub) {
    sub_species <- data.frame(species=sub$sp, FWS=sub$fws_per_cnty, 
                              Other_fed=sub$other_fed_per_cnty, 
                              Federal=sub$fed_per_cnty, 
                              State=sub$state_per_cnty,
                              Total=sub$grand_per_cnty)
    s <- aggregate(cbind(FWS, Other_fed, Federal, State, Total)~species, sub_species, sum)
    sorted <- s[order(s$Total, decreasing=T),]
    if (length(sorted$species) <= 25) {
       dat <- sorted[, c(1:3,5)]
    } else {
       dat <- sorted[1:25, c(1:3,5)]
    }
    return(dat)
}

############################################################################
# Create a small dataframe for taxonomic group spending plot
make_tax_group_df <- function(x) {
    sub_tax <- data.frame(Group=x$Group, 
                          FWS=x$fws_per_cnty, 
                          Other_fed=x$other_fed_per_cnty, 
                          State=x$state_per_cnty)
    s <- aggregate(cbind(FWS, Other_fed, State)~Group, sub_tax, sum)
    return(s)
}

############################################################################
# Create a small dataframe for top 10 states bar plot
make_top_10_states_df <- function(sub) {
    sub_state <- data.frame(ST=sub$STATE, 
                            FWS=sub$fws_per_cnty, 
                            Other_fed=sub$other_fed_per_cnty, 
                            State=sub$state_per_cnty,
                            Total=sub$grand_per_cnty)
    s <- aggregate(cbind(FWS, Other_fed, State, Total)~ST, sub_state, sum)
    sorted <- s[order(s$Total, decreasing=T),]
    if (length(sorted$ST) <= 25) {
        dat <- sorted[, c(1:4)]
    } else {
        dat <- sorted[1:25, c(1:4)]
    }
    return(dat)
}

############################################################################
# Create a small dataframe for top 10 counties bar plot
make_top_10_county_df <- function(sub) {
    sub_cnty <- data.frame(County=sub$cs, 
                           FWS=sub$fws_per_cnty, 
                           Other_fed=sub$other_fed_per_cnty, 
                           State=sub$state_per_cnty,
                           Total=sub$grand_per_cnty)
    s <- aggregate(cbind(FWS, Other_fed, State, Total)~County, sub_cnty, sum)
    sorted <- s[order(s$Total, decreasing=T),]
    if (length(sorted$State) <= 25) {
        dat <- sorted[, c(1:4)]
    } else {
        dat <- sorted[1:25, c(1:4)]
    }
    return(dat)
}

############################################################################
# Create a small dataframe for the state-resolution map
make_map_df <- function(sub) {
    sub_state <- data.frame(STABBREV=sub()$STABBREV, grand_per_cnty=sub()$grand_per_cnty)
    s <- aggregate(grand_per_cnty ~ STABBREV, sub_state, sum)
    res <- data.frame(state=s$STABBREV, total=s$grand_per_cnty)
    return(res)
}

############################################################################
# Create a small dataframe for the spending over time plot
make_spend_time_df <- function(sub) {
    spend_tab <- data.frame(Year=sub$Year, 
                      FWS=sub$fws_per_cnty, 
                      Other_fed=sub$other_fed_per_cnty, 
                      State=sub$state_per_cnty)
    s <- aggregate(cbind(FWS, Other_fed, State)~Year, spend_tab, sum)
    return(s)
}

############################################################################
# Create small dataframe for the percentage plot
make_percent_plot_df <- function(sub) {
    sub_perc <- data.frame(species=sub$sp,
                           total=sub$grand_per_cnty)
    s <- aggregate(total~species, sub_perc, sum)
    sorted <- s[order(s$total, decreasing=T),]
    t_10_pos <- round(length(sorted$total)/10)
    top_10 <- sum(sorted[1:t_10_pos,2])
    other_90 <- sum(sorted[t_10_pos:length(sorted$total),2])
    res <- data.frame(names=c("Top 10%", "Other 90%"), percent=c(top_10, other_90))
    return(res)
}