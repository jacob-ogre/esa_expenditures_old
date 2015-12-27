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
tooltips <- function(sp, dol, src) {
    paste0("<div style='padding:5px 5px 5px 5px;'><b>", 
           sp, '</b><br>', src, ":<br>$", prettyNum(dol, big.mark=","), "</div>")
}

make_top_25_species_df <- function(sub) {
    spp_tot <- tapply(sub$grand_per_cnty, INDEX=sub$sp, FUN=sum, na.rm=TRUE)
    spp_fws <- tapply(sub$fws_per_cnty, INDEX=sub$sp, FUN=sum, na.rm=TRUE)
    spp_otf <- tapply(sub$other_fed_per_cnty, INDEX=sub$sp, FUN=sum, na.rm=TRUE)
    spp_stf <- tapply(sub$state_per_cnty, INDEX=sub$sp, FUN=sum, na.rm=TRUE)
    s <- data.frame(species=names(spp_tot),
                    FWS=as.vector(round(spp_fws, 0)),
                    Other_fed=as.vector(round(spp_otf, 0)),
                    State=as.vector(round(spp_stf, 0)),
                    Total=as.vector(round(spp_tot, 0)))

    sorted <- s[order(s$Total, decreasing=T),]
    if (length(sorted$species) <= 25) {
        dat <- sorted[, c(1:4)]
    } else {
        dat <- sorted[1:25, c(1:4)]
    }
        fws_tooltip <- tooltips(dat$species, dat$FWS, "FWS")
        other_tooltip <- tooltips(dat$species, dat$Other_fed, "Other fed")
        state_tooltip <- tooltips(dat$species, dat$State, "State")
        res <- data.frame(species=dat$species,
                          FWS=dat$FWS,
                          fws.html.tooltip=fws_tooltip,
                          other_fed=dat$Other_fed,
                          other.html.tooltip=other_tooltip,
                          state=dat$State,
                          state.html.tooltip=state_tooltip)
        names(res) <- c("species", "FWS", "fws.html.tooltip", "other fed", 
                        "other fed.html.tooltip", "state", "state.html.tooltip")
    return(res)
}

############################################################################
# Create a small dataframe for taxonomic group spending plot
make_tax_group_df <- function(sub) {
    grp_tot <- tapply(sub$grand_per_cnty, INDEX=sub$Group, FUN=sum, na.rm=TRUE)
    grp_fws <- tapply(sub$fws_per_cnty, INDEX=sub$Group, FUN=sum, na.rm=TRUE)
    grp_otf <- tapply(sub$other_fed_per_cnty, INDEX=sub$Group, FUN=sum, na.rm=TRUE)
    grp_stf <- tapply(sub$state_per_cnty, INDEX=sub$Group, FUN=sum, na.rm=TRUE)
    s <- data.frame(Group=names(grp_tot),
                    FWS=as.vector(round(grp_fws, 0)),
                    Other_fed=as.vector(round(grp_otf, 0)),
                    State=as.vector(round(grp_stf, 0)),
                    Total=as.vector(round(grp_tot, 0)))

    s <- s[order(s$Total, decreasing=TRUE), ]
    fws_tooltip <- tooltips(s$Group, s$FWS, "FWS")
    other_tooltip <- tooltips(s$Group, s$Other_fed, "Other fed")
    state_tooltip <- tooltips(s$Group, s$State, "State")
    res <- data.frame(group=s$Group,
                      FWS=s$FWS,
                      fws.html.tooltip=fws_tooltip,
                      other_fed=s$Other_fed,
                      other.html.tooltip=other_tooltip,
                      state=s$State,
                      state.html.tooltip=state_tooltip)
    names(res) <- c("group", "FWS", "fws.html.tooltip", "other fed", 
                    "other fed.html.tooltip", "state", "state.html.tooltip")
    return(res)
}

############################################################################
# Create a small dataframe for taxonomic group spending plot
get_n_levels <- function(x) {
    length(levels(as.factor(x)))
}

make_group_bubble_df <- function(sub) {
    cty_grp <- tapply(sub$cs, INDEX=sub$Group, FUN=get_n_levels)
    exp_grp <- tapply(sub$grand_per_cnty, INDEX=sub$Group, FUN=sum, na.rm=T)
    spp_grp <- tapply(sub$sp, INDEX=sub$Group, FUN=get_n_levels)
    res_df <- data.frame(group=names(cty_grp), cty_grp=as.vector(cty_grp), 
                         exp_grp=as.vector(exp_grp), spp_grp=as.vector(spp_grp))
    res_df <- res_df[complete.cases(res_df),]
    res_df <- res_df[order(res_df$exp_grp, decreasing=TRUE), ]
    names(res_df) <- c("group", "N counties occupied", "Expenditures", 
                       "N species")
    return(res_df)
}

############################################################################
# Create a small dataframe for top 25 states bar plot
make_top_25_states_df <- function(sub) {
    sub_state <- data.frame(ST=sub$STATE, 
                            FWS=round(sub$fws_per_cnty,0), 
                            Other_fed=round(sub$other_fed_per_cnty,0), 
                            State=round(sub$state_per_cnty,0),
                            Total=round(sub$grand_per_cnty,0))
    s <- aggregate(cbind(FWS, Other_fed, State, Total)~ST, sub_state, sum)
    sorted <- s[order(s$Total, decreasing=T),]
    if (length(sorted$ST) <= 25) {
        dat <- sorted[, c(1:4)]
    } else {
        dat <- sorted[c(1:25), c(1:4)]
    }
    fws_tooltip <- tooltips(dat$ST, dat$FWS, "FWS")
    other_tooltip <- tooltips(dat$ST, dat$Other_fed, "Other fed")
    state_tooltip <- tooltips(dat$ST, dat$State, "State")
    res <- data.frame(st=dat$ST,
                      FWS=dat$FWS,
                      fws.html.tooltip=fws_tooltip,
                      other_fed=dat$Other_fed,
                      other.html.tooltip=other_tooltip,
                      state=dat$State,
                      state.html.tooltip=state_tooltip)
    names(res) <- c("st", "FWS", "fws.html.tooltip", "other fed", 
                    "other fed.html.tooltip", "state", "state.html.tooltip")
    return(res)
}

############################################################################
# Create a small dataframe for selected state and top 24 states bar plot
make_select_top_24_states_df <- function(sub, sel_st) {
    sub_state <- data.frame(ST=sub$STATE, 
                            FWS=round(sub$fws_per_cnty,0), 
                            Other_fed=round(sub$other_fed_per_cnty,0), 
                            State=round(sub$state_per_cnty,0),
                            Total=round(sub$grand_per_cnty,0))
    s <- aggregate(cbind(FWS, Other_fed, State, Total)~ST, sub_state, sum)
    sorted <- s[order(s$Total, decreasing=T),]
    sel_dat <- sorted[as.character(sorted$ST) == sel_st, ]
    if (length(sorted$ST) <= 24) {
        dat <- sorted[, c(1:4)]
    } else {
        dat <- sorted[c(1:24), c(1:4)]
    }
    dat <- rbind(sel_dat[, c(1:4)], dat)
    fws_tooltip <- tooltips(dat$ST, dat$FWS, "FWS")
    other_tooltip <- tooltips(dat$ST, dat$Other_fed, "Other fed")
    state_tooltip <- tooltips(dat$ST, dat$State, "State")
    res <- data.frame(st=dat$ST,
                      FWS=dat$FWS,
                      fws.html.tooltip=fws_tooltip,
                      other_fed=dat$Other_fed,
                      other.html.tooltip=other_tooltip,
                      state=dat$State,
                      state.html.tooltip=state_tooltip)
    names(res) <- c("st", "FWS", "fws.html.tooltip", "other fed", 
                    "other fed.html.tooltip", "state", "state.html.tooltip")
    return(res)
}

############################################################################
# Create a dataframe for per-species spending by state
tooltip_2 <- function(st, nspp, dol, src) {
    paste0("<div style='padding:5px 5px 5px 5px;'><b>", 
           st, '</b><br>', src, ":<br>$", prettyNum(dol, big.mark=","), 
           "<br># spp:", nspp, "</div>")
}

make_per_spp_state_df <- function(sub) {
    exp_st_grand <- tapply(sub()$grand_per_cnty, INDEX=sub()$STATE, FUN=sum, na.rm=TRUE)
    exp_st_fws <- tapply(sub()$fws_per_cnty, INDEX=sub()$STATE, FUN=sum, na.rm=TRUE)
    exp_st_state <- tapply(sub()$state_per_cnty, INDEX=sub()$STATE, FUN=sum, na.rm=TRUE)
    exp_st_ofed <- tapply(sub()$other_fed_per_cnty, INDEX=sub()$STATE, FUN=sum, na.rm=TRUE)
    spp_st <- tapply(sub()$sp, INDEX=sub()$STATE, FUN=get_n_levels)
    per_st_grand <-   exp_st_grand / spp_st
    per_st_fws <-   exp_st_fws / spp_st
    per_st_state <- exp_st_state / spp_st
    per_st_ofed <-  exp_st_ofed / spp_st
    s <- data.frame(ST=names(exp_st_fws), 
                    n_spp=as.vector(spp_st),
                    exp_st_grand=as.vector(exp_st_grand),
                    exp_st_fws=as.vector(exp_st_fws),
                    exp_st_ofed=as.vector(exp_st_ofed),
                    exp_st_state=as.vector(exp_st_state),
                    per_st_grand=as.vector(per_st_grand),
                    per_st_fws=as.vector(per_st_fws),
                    per_st_ofed=as.vector(per_st_ofed),
                    per_st_state=as.vector(per_st_state))
    sorted <- s[order(s$per_st_grand, decreasing=T),]
    if (length(sorted$ST) <= 25) {
        dat <- sorted
    } else {
        dat <- sorted[c(1:25),]
    }
    fws_tooltip <- tooltip_2(dat$ST, dat$n_spp, dat$per_st_fws, "FWS")
    other_tooltip <- tooltip_2(dat$ST, dat$n_spp, dat$per_st_ofed, "Other fed")
    state_tooltip <- tooltip_2(dat$ST, dat$n_spp, dat$per_st_state, "State")
    dat <- cbind(dat, fws_tooltip, other_tooltip, state_tooltip)
    names(dat) <- c("st", "n_spp", "tot", "FWS", "other fed", "state", "per-sp tot",
                    "per-sp FWS", "per-sp other fed", "per-sp state", 
                    "fws.html.tooltip", "other fed.html.tooltip", "state.html.tooltip")
    return(dat)
}

############################################################################
# Create a small dataframe for top 10 counties bar plot
make_top_10_county_df <- function(sub) {
    sub_cnty <- data.frame(County=sub$cs, 
                           FWS=round(sub$fws_per_cnty,0), 
                           Other_fed=round(sub$other_fed_per_cnty,0), 
                           State=round(sub$state_per_cnty,0),
                           Total=round(sub$grand_per_cnty,0))
    s <- aggregate(cbind(FWS, Other_fed, State, Total)~County, sub_cnty, sum)
    sorted <- s[order(s$Total, decreasing=T),]
    if (length(sorted$State) <= 25) {
        dat <- sorted[, c(1:4)]
        fws_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$County, '</b><br>FWS: ', make_dollars(dat$FWS), "</br></div>", sep="")
        other_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$County, '</b><br>other fed: ', make_dollars(dat$Other_fed), "</br></div>", sep="")
        state_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$County, '</b><br>state: ', make_dollars(dat$State), "</br></div>", sep="")
        res <- data.frame(cs=dat$County,
                          FWS=dat$FWS,
                          fws.html.tooltip=fws_tooltip,
                          other_fed=dat$Other_fed,
                          other.html.tooltip=other_tooltip,
                          state=dat$State,
                          state.html.tooltip=state_tooltip)
        names(res) <- c("county", "FWS", "fws.html.tooltip", "other fed", 
                        "other fed.html.tooltip", "state", "state.html.tooltip")
    } else {
        dat <- sorted[1:25, c(1:4)]
        fws_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$County, '</b><br>FWS: ', make_dollars(dat$FWS), "</br></div>", sep="")
        other_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$County, '</b><br>other fed: ', make_dollars(dat$Other_fed), "</br></div>", sep="")
        state_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$County, '</b><br>state: ', make_dollars(dat$State), "</br></div>", sep="")
        res <- data.frame(cs=dat$County,
                          FWS=dat$FWS,
                          fws.html.tooltip=fws_tooltip,
                          other_fed=dat$Other_fed,
                          other.html.tooltip=other_tooltip,
                          state=dat$State,
                          state.html.tooltip=state_tooltip)
        names(res) <- c("county", "FWS", "fws.html.tooltip", "other fed", 
                        "other fed.html.tooltip", "state", "state.html.tooltip")
    }
    return(res)
}

############################################################################
# Create a small dataframe for the state-resolution map
make_map_df <- function(sub) {
    sub_state <- data.frame(STABBREV=sub()$STABBREV, 
                            grand_per_cnty=round(sub()$grand_per_cnty,0))
    s <- aggregate(grand_per_cnty ~ STABBREV, sub_state, sum)
    res <- data.frame(state=s$STABBREV, total=s$grand_per_cnty)
    return(res)
}

############################################################################
# Create a small dataframe for the spending over time plot
make_spend_time_df <- function(sub) {
    spend_tab <- data.frame(Year=sub$Year, 
                            FWS=round(sub$fws_per_cnty,0), 
                            Other_fed=round(sub$other_fed_per_cnty,0), 
                            State=round(sub$state_per_cnty,0))
    s <- aggregate(cbind(FWS, Other_fed, State)~Year, spend_tab, sum)
    fws_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", s$Year, "</b><br>FWS: ", make_dollars(s$FWS), "</br></div>", sep="")
    other_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", s$Year, "</b><br>other fed: ", make_dollars(s$Other_fed), "</br></div>", sep="")
    state_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", s$Year, "</b><br>state: ", make_dollars(s$State), "</br></div>", sep="")
    res <- data.frame(year=s$Year,
                      FWS=s$FWS,
                      fws.html.tooltip=fws_tooltip,
                      other_fed=s$Other_fed,
                      other.html.tooltip=other_tooltip,
                      state=s$State,
                      state.html.tooltip=state_tooltip)
    names(res) <- c("year", "FWS", "fws.html.tooltip", 
                    "other fed", "other fed.html.tooltip", 
                    "state", "state.html.tooltip")
    return(res)
}

############################################################################
# Create small dataframe for the percentage plot
make_percent_plot_df <- function(sub) {
    sub_perc <- data.frame(species=sub$sp,
                           total=round(sub$grand_per_cnty,0))
    s <- aggregate(total~species, sub_perc, sum)
    sorted <- s[order(s$total, decreasing=T),]
    t_10_pos <- round(length(sorted$total)/10)
    top_10 <- sum(sorted[1:t_10_pos,2])
    other_90 <- sum(sorted[t_10_pos:length(sorted$total),2])
    tag_10 <- paste("<div style='padding:5px 5px 5px 5px;'><b># Species: </b>", t_10_pos, "<br>", make_dollars(top_10), "</br></div>", sep="")
    tag_90 <- paste("<div style='padding:5px 5px 5px 5px;'><b># Species: </b>", length(sorted$total)-t_10_pos, "<br>", make_dollars(other_90), "</br></div>", sep="")
    res <- data.frame(names=c("Top 10%", "Other 90%"), spent=c(top_10, other_90), spent.html.tooltip=c(tag_10, tag_90))
    return(res)
}
