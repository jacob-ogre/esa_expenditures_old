# Functions to summarize Sec7 data and subsetted data.
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


#############################################################################
# Make a summary df with basic counts
#############################################################################
make_count_summary <- function(state_sub, fed_sub, state_full, fed_full) {
    # All data
    all_n_years <- length(levels(droplevels(as.factor(fed_full$Year))))
    all_n_groups <- length(levels(droplevels(as.factor(fed_full$Group))))
    all_n_spp <- length(levels(droplevels(as.factor(fed_full$Common))))
    all_n_states <- length(levels(droplevels(as.factor(state_full$State))))
    all_dat <- c(all_n_years, all_n_groups, all_n_spp, all_n_states)

    # Selected data
    sub_n_years <- length(levels(droplevels(as.factor(fed_sub()$Year))))
    sub_n_groups <- length(levels(droplevels(as.factor(fed_sub()$Group))))
    sub_n_spp <- length(levels(droplevels(as.factor(fed_sub()$Common))))
    sub_n_states <- length(levels(droplevels(as.factor(state_sub()$State))))
    sub_dat <- c(sub_n_years, sub_n_groups, sub_n_spp, sub_n_states)

    # ratio
    ratio_n_years <- round(sub_n_years / all_n_years, 3) * 100
    ratio_n_groups <- round(sub_n_groups / all_n_groups, 3) * 100
    ratio_n_spp <- round(sub_n_spp / all_n_spp, 3) * 100
    ratio_n_states <- round(sub_n_states / all_n_states, 3) * 100
    ratio_dat <- c(ratio_n_years, ratio_n_groups, ratio_n_spp, ratio_n_states)

    variables <- c("# years", "# taxonomic groups", "# species", "# states")
                   
    stats_df <- data.frame(variables, all_dat, sub_dat, ratio_dat)
    names(stats_df) <- c("", "All data", "Select data", "Percent (select/all)")
    return(stats_df)
}

#############################################################################
# Make a summary df of spending
#############################################################################
make_spending_summary <- function(state_sub, fed_sub, state_full, fed_full) {
    # All data
    all_state_general <- sum(state_full$General_Expenditures, na.rm=T)
    all_state_land <- sum(state_full$Land_Expenditures, na.rm=T)
    all_state_total <- sum(state_full$Grand_Total, na.rm=T)
    all_FWS_total <- sum(fed_full$FWS_tot, na.rm=T)
    all_other_fed_tot <- sum(as.numeric(fed_full$other_fed), na.rm=T)
    all_Fed_total <- sum(as.numeric(fed_full$Fed_tot), na.rm=T)
    all_grand_total <- sum(all_state_general, all_Fed_total)
    all_dat <- c(all_state_general, all_state_land, all_state_total, 
                 all_FWS_total, all_other_fed_tot, all_Fed_total,
                 all_grand_total)
    all_dat <- format(all_dat, big.mark=",", scientific=FALSE)

    # Selected data
    sub_state_general <- sum(state_sub()$General_Expenditures, na.rm=T)
    sub_state_land <- sum(state_sub()$Land_Expenditures, na.rm=T)
    sub_state_total <- sum(state_sub()$Grand_Total, na.rm=T)
    sub_FWS_total <- sum(as.numeric(fed_sub()$FWS_tot), na.rm=T)
    sub_other_fed_tot <- sum(as.numeric(fed_sub()$other_fed), na.rm=T)
    sub_Fed_total <- sum(as.numeric(fed_sub()$Fed_tot), na.rm=T)
    sub_grand_total <- sum(sub_state_general, sub_Fed_total)
    sub_dat <- c(sub_state_general, sub_state_land, sub_state_total, 
                 sub_FWS_total, sub_other_fed_tot, sub_Fed_total,
                 sub_grand_total)
    sub_dat <- format(sub_dat, big.mark=",", scientific=FALSE)

    # Ratios
    ratio_state_general <- round(sub_state_general / all_state_general, 3) * 100
    ratio_state_land <- round(sub_state_land / all_state_land, 3) * 100
    ratio_state_total <- round(sub_state_total / all_state_total, 3) * 100
    ratio_FWS_total <- round(sub_state_general / all_state_general, 3) * 100
    ratio_other_fed_total <- round(sub_other_fed_tot / all_other_fed_tot, 3) * 100
    ratio_Fed_total <- round(sub_Fed_total / all_Fed_total, 3) * 100
    ratio_grand_total <- round(sub_grand_total / all_grand_total, 3) * 100
    ratio_dat <- c(ratio_state_general, ratio_state_land, ratio_state_total, 
                   ratio_FWS_total, ratio_other_fed_total, ratio_Fed_total,
                   ratio_grand_total)

    group_var <- c("State", NA, NA, "Federal", NA, NA, "Grand total")
    variables <- c("Non-land", "Land", "Total",
                   "FWS", "Other federal", "Total", "State + Fed")

    res_df <- data.frame(group_var, variables, all_dat, sub_dat, ratio_dat)
    names(res_df) <- c("", "", "All data ($)", "Selected data ($)", 
                       "Percent (select/all)") 
    return(res_df)
}

#############################################################################
# Make a summary df comparing state and fed spending totals
#############################################################################
make_state2fed_summary <- function(state_sub, fed_sub, state_full, fed_full) {
    # State data
    all_state_general <- sum(state_full$General_Expenditures, na.rm=T)
    all_state_total <- sum(state_full$Grand_Total, na.rm=T)
    sub_state_general <- sum(state_sub()$General_Expenditures, na.rm=T)
    sub_state_total <- sum(state_sub()$Grand_Total, na.rm=T)
    state_dat <- c(all_state_general, all_state_total, sub_state_general, sub_state_total)

    # Fed data
    all_Fed_total <- sum(as.numeric(fed_full$Fed_tot), na.rm=T)
    sub_Fed_total <- sum(as.numeric(fed_sub()$Fed_tot), na.rm=T)
    fed_dat <- c(all_Fed_total, all_Fed_total, sub_Fed_total, sub_Fed_total)

    # Ratios
    ratio_dat <- round(state_dat / fed_dat, 3) * 100

    state_dat <- format(state_dat, big.mark=",", scientific=FALSE)
    fed_dat <- format(fed_dat, big.mark=",", scientific=FALSE)

    group_var <- c("All", NA, "Select", NA)
    variables <- c("General", "Total", "General", "Total")

    res_df <- data.frame(group_var, variables, state_dat, fed_dat, ratio_dat)
    names(res_df) <- c("", "", "State expend. ($)", "Federal expend. ($)",
                       "Percent (state/federal)") 
    return(res_df)
}

#############################################################################
# Make a summary df of state data
#############################################################################
make_state_summary <- function(state_sub, state_full, fed_sub) {
    if (length(levels(droplevels(as.factor(state_sub()$State)))) > 1) {
        dat <- c("", "Please select a state for summary table", "")
        var <- c("", "", "")
        noData <- data.frame(var, dat)
        names(noData) <- c("", "")
        return(noData)
    } else if (length(state_sub()$State) == 0) {
        dat <- c("", 
                 "No data available for selected year, select another year", 
                 "")
        var <- c("", "", "")
        noData <- data.frame(var, dat)
        names(noData) <- c("", "")
        return(noData)
    }

    cur_state <- as.character(levels(droplevels(as.factor(state_sub()$State))))
    num_spp <- length(levels(droplevels(as.factor(state_sub()$Common))))
    tot_state_expend <- sum(state_sub()$Grand_Total, na.rm=TRUE)
    per_sp_total_exp <- tot_state_expend / num_spp
    gen_state_expend <- sum(state_sub()$General_Expenditures, na.rm=TRUE)
    lan_state_expend <- sum(state_sub()$Land_Expenditures, na.rm=TRUE)
    multisp_expend <- sum(state_sub()$Land_Expenditures[
                          state_sub()$Group=="Multi-Species"], na.rm=TRUE)

    # get species counts and calculate ranks
    count_sp <- function(x) {
        n_spp <- length(levels(droplevels(as.factor(x))))
        return(n_spp)
    }
    state_N_sp <- tapply(state_full$Common,
                         INDEX=state_full$State,
                         FUN=count_sp)
    state_sums <- tapply(state_full$Grand_Total,
                         INDEX=state_full$State,
                         FUN=sum, na.rm=TRUE)
    state_sum_per_sp <- state_sums / state_N_sp
    st_ranks <- rank(-state_sums)
    state_rank <- st_ranks[cur_state][[1]]
    st_per_sp_ranks <- rank(-state_sum_per_sp)
    state_per_sp_rank <- st_per_sp_ranks[cur_state][[1]]

    min_st_yr <- min(as.numeric(as.character(state_sub()$Year)), na.rm=TRUE)
    max_st_yr <- max(as.numeric(as.character(state_sub()$Year)), na.rm=TRUE)
    fed_year_sub <- fed_sub()[as.numeric(as.character(fed_sub()$Year)) <= max_st_yr &
                              as.numeric(as.character(fed_sub()$Year)) >= min_st_yr,]
    fed_expend_spp <- sum(fed_year_sub$Fed_tot, na.rm=TRUE)
    data_col <- c(state_rank, 
                  state_per_sp_rank,
                  NA,
                  paste("$", format(tot_state_expend, 
                                    big.mark=",", 
                                    scientific=FALSE), sep=""),
                  format(gen_state_expend, big.mark=",", scientific=FALSE),
                  format(lan_state_expend, big.mark=",", scientific=FALSE),
                  format(multisp_expend, big.mark=",", scientific=FALSE), 
                  NA,
                  format(fed_expend_spp, big.mark=",", scientific=FALSE))
    last_row <- paste("Federal expenditures on species in ", cur_state)
    variables <- c("State expenditures rank (raw)",
                   "State expenditures rank (per species)",
                   NA,
                   "State total end. sp. expenditures",
                   "State general expenditures", 
                   "State land expenditures",
                   "State multi-species expenditures", 
                   NA,
                   last_row)
    res_df <- data.frame(variables, data_col)
    names(res_df) <- c("", "")
    return(res_df)
}

