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
    sub_species <- data.frame(species=sub$sp, 
                              FWS=round(sub$fws_per_cnty,0), 
                              Other_fed=round(sub$other_fed_per_cnty,0), 
                              State=round(sub$state_per_cnty,0),
                              Total=round(sub$grand_per_cnty,0))
    s <- aggregate(cbind(FWS, Other_fed, State, Total)~species, sub_species, sum)
    sorted <- s[order(s$Total, decreasing=T),]
    if (length(sorted$species) <= 25) {
       dat <- sorted[, c(1:4)]
       fws_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$species, '</b><br>FWS: ', make_dollars(dat$FWS), "</br></div>", sep="")
       other_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$species, '</b><br>other fed: ', make_dollars(dat$Other_fed), "</br></div>", sep="")
       state_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$species, '</b><br>state: ', make_dollars(dat$State), "</br></div>", sep="")
       res <- data.frame(species=dat$species,
                         FWS=dat$FWS,
                         fws.html.tooltip=fws_tooltip,
                         other_fed=dat$Other_fed,
                         other.html.tooltip=other_tooltip,
                         state=dat$State,
                         state.html.tooltip=state_tooltip)
       names(res) <- c("species", "FWS", "fws.html.tooltip", "other fed", 
                       "other fed.html.tooltip", "state", "state.html.tooltip")
    } else {
       dat <- sorted[1:25, c(1:4)]
       fws_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$species, '</b><br>FWS: ', make_dollars(dat$FWS), "</br></div>", sep="")
       other_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$species, '</b><br>other fed: ', make_dollars(dat$Other_fed), "</br></div>", sep="")
       state_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$species, '</b><br>state: ', make_dollars(dat$State), "</br></div>", sep="")
       res <- data.frame(species=dat$species,
                         FWS=dat$FWS,
                         fws.html.tooltip=fws_tooltip,
                         other_fed=dat$Other_fed,
                         other.html.tooltip=other_tooltip,
                         state=dat$State,
                         state.html.tooltip=state_tooltip)
       names(res) <- c("species", "FWS", "fws.html.tooltip", "other fed", 
                       "other fed.html.tooltip", "state", "state.html.tooltip")
    }
    return(res)
}

############################################################################
# Create a small dataframe for taxonomic group spending plot
make_tax_group_df <- function(x) {
    sub_tax <- data.frame(Group=x$Group, 
                          FWS=round(x$fws_per_cnty,0), 
                          Other_fed=round(x$other_fed_per_cnty,0), 
                          State=round(x$state_per_cnty,0))
    s <- aggregate(cbind(FWS, Other_fed, State)~Group, sub_tax, sum)
    fws_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", s$Group, '</b><br>FWS: ', make_dollars(s$FWS), "</br></div>", sep="")
    other_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", s$Group, '</b><br>other fed: ', make_dollars(s$Other_fed), "</br></div>", sep="")
    state_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", s$Group, '</b><br>state: ', make_dollars(s$State), "</br></div>", sep="")
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
# Create a small dataframe for top 10 states bar plot
make_top_10_states_df <- function(sub) {
    sub_state <- data.frame(ST=sub$STATE, 
                            FWS=round(sub$fws_per_cnty,0), 
                            Other_fed=round(sub$other_fed_per_cnty,0), 
                            State=round(sub$state_per_cnty,0),
                            Total=round(sub$grand_per_cnty,0))
    s <- aggregate(cbind(FWS, Other_fed, State, Total)~ST, sub_state, sum)
    sorted <- s[order(s$Total, decreasing=T),]
    if (length(sorted$ST) <= 25) {
        dat <- sorted[, c(1:4)]
        fws_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$ST, '</b><br>FWS: ', make_dollars(dat$FWS), "</br></div>", sep="")
        other_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$ST, '</b><br>other fed: ', make_dollars(dat$Other_fed), "</br></div>", sep="")
        state_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$ST, '</b><br>state: ', make_dollars(dat$State), "</br></div>", sep="")
        res <- data.frame(st=dat$ST,
                          FWS=dat$FWS,
                          fws.html.tooltip=fws_tooltip,
                          other_fed=dat$Other_fed,
                          other.html.tooltip=other_tooltip,
                          state=dat$State,
                          state.html.tooltip=state_tooltip)
        names(res) <- c("st", "FWS", "fws.html.tooltip", "other fed", 
                        "other fed.html.tooltip", "state", "state.html.tooltip")
    } else {
        dat <- sorted[1:25, c(1:4)]
        fws_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$ST, '</b><br>FWS: ', make_dollars(dat$FWS), "</br></div>", sep="")
        other_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$ST, '</b><br>other fed: ', make_dollars(dat$Other_fed), "</br></div>", sep="")
        state_tooltip <- paste("<div style='padding:5px 5px 5px 5px;'><b>", dat$ST, '</b><br>state: ', make_dollars(dat$State), "</br></div>", sep="")
        res <- data.frame(st=dat$ST,
                          FWS=dat$FWS,
                          fws.html.tooltip=fws_tooltip,
                          other_fed=dat$Other_fed,
                          other.html.tooltip=other_tooltip,
                          state=dat$State,
                          state.html.tooltip=state_tooltip)
        names(res) <- c("st", "FWS", "fws.html.tooltip", "other fed", 
                        "other fed.html.tooltip", "state", "state.html.tooltip")
    }
    return(res)
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
