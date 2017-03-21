# Some non-dynamic analyses of the fed (and state?) expenditure data.
# Copyright © 2015 Defenders of Wildlife, jmalcom@defenders.org

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

dat_base <- "~/Defenders_JWM/R/EndSp_expend_dash/data"
load(paste(dat_base, "merged_states_data.RData", sep="/")) #fed_fin
load(paste(dat_base, "merged_fed_data.RData", sep="/")) #state_fin
counties <- read.table(paste(dat_base, "ESA_spp_counties_v5.tab", sep="/"),
                       sep="\t",
                       header=TRUE,
                       stringsAsFactors=FALSE)

###############################################################################
# Get the estimated per-county/state expenditures data into tables
tot_exp_per_cnty <- tapply(fed_fin$grand_per_cnty,
                           INDEX=fed_fin$st_cnt,
                           FUN=sum)
tot_exp_per_cnty <- sort(tot_exp_per_cnty, decreasing=TRUE)
hist(tot_exp_per_cnty, breaks=80)
tot_exp_per_cnty_df <- data.frame(st_cnt=names(tot_exp_per_cnty),
                                  tot_exp=as.vector(tot_exp_per_cnty))
tot_exp_per_cnty_df$cumsum <- cumsum(tot_exp_per_cnty_df$tot_exp)

tot_exp_cnt <- merge(tot_exp_per_cnty_df, counties, by="st_cnt")
head(tot_exp_cnt)
tot_exp_cnt$dups <- duplicated(tot_exp_cnt$st_cnt)
tot_exp_cnt <- tot_exp_cnt[tot_exp_cnt$dups == FALSE, ]
tot_exp_cnt <- tot_exp_cnt[, c(1, 2, 4, 5, 6, 11:14)]

base <- "~/Google Drive/Defenders/EndSpCons_shared/mapping/ESA_by_county"
write.table(tot_exp_cnt,
            file=paste(base, "tot_expend_by_county.tab", sep="/"),
            sep="\t",
            quote=FALSE,
            row.names=FALSE)

# Now let's do the estimated expenditures per state:
tot_exp_per_state <- tapply(fed_fin$grand_per_cnty,
                            INDEX=fed_fin$state,
                            FUN=sum)
tot_exp_per_state <- sort(tot_exp_per_state, decreasing=TRUE)
hist(tot_exp_per_state, breaks=80)
tot_exp_per_state_df <- data.frame(state=names(tot_exp_per_state),
                                   tot_exp=as.vector(tot_exp_per_state))
tot_exp_per_state_df$cumsum <- cumsum(tot_exp_per_state_df$tot_exp)

tot_exp_state <- merge(tot_exp_per_state_df, counties, by="state")
tot_exp_state$dups <- duplicated(tot_exp_state$state)
tot_exp_state <- tot_exp_state[tot_exp_state$dups == FALSE, ]
tot_exp_state <- tot_exp_state[, c(1, 4, 2, 11)]
head(tot_exp_state)
tot_exp_state <- tot_exp_state[order(-tot_exp_state$tot_exp), ]

base <- "~/Google Drive/Defenders/EndSpCons_shared/mapping/ESA_by_county"
write.table(tot_exp_state,
            file=paste(base, "tot_expend_by_state.tab", sep="/"),
            sep="\t",
            quote=FALSE,
            row.names=FALSE)

# Now write an excel, .xlsx
base <- "~/Google Drive/Defenders/EndSpCons_shared/mapping/ESA_by_county"
WriteXLS(c("tot_exp_cnt", "tot_exp_state"),
         ExcelFileName=paste(base, "expend_per_state_county.xlsx", sep="/"),
         AdjWidth=TRUE)

# Some figures
base <- "~/Google Drive/Defenders/EndSpCons_shared/mapping/ESA_by_county"
pdf(file=paste(base, "figures/cumsum_total_exp_by_county.pdf", sep="/"),
    height=6,
    width=8)
half_exp <- max(tot_exp_per_cnty_df$cumsum)/2
p90_exp <- max(tot_exp_per_cnty_df$cumsum) * 0.9
half_cnt <- sum(tot_exp_per_cnty_df$cumsum <= half_exp)
p90_cnt <- sum(tot_exp_per_cnty_df$cumsum <= p90_exp)
plot(tot_exp_per_cnty_df$cumsum, 
     type="l",
     ylab="Cumulative Sum (dollars)",
     xlab="# Counties Summed")
abline(h=half_exp, lty=2, col="gray")
abline(v=half_cnt, lty=2, col="gray")
abline(h=p90_exp, lty=3, col="gray")
abline(v=p90_cnt, lty=3, col="gray")
text(x=half_cnt+90, y=1e9, labels=half_cnt)
text(x=p90_cnt+90, y=1e9, labels=p90_cnt)
dev.off()


base <- "~/Google Drive/Defenders/EndSpCons_shared/mapping/ESA_by_county"
pdf(file=paste(base, "figures/total_exp_by_state.pdf", sep="/"),
    height=6,
    width=10)
par(mar=c(8, 7, 2, 2))
barplot(tot_exp_state$tot_exp, 
        names.arg=tot_exp_state$state, 
        ylab="Total expenditures (dollars)\n\n",
        las=2)
graphics::box()
dev.off()

par(mar=c(5, 4, 4, 2))

###############################################################################
# Do the species accumulation curve
tot_exp_spp <- tapply(fed_fin$grand_per_cnty,
                      INDEX=fed_fin$scientific,
                      FUN=sum)
fws_exp_spp <- tapply(fed_fin$fws_per_cnty,
                      INDEX=fed_fin$scientific,
                      FUN=sum)
ofd_exp_spp <- tapply(fed_fin$other_fed_per_cnty,
                      INDEX=fed_fin$scientific,
                      FUN=sum)
fed_exp_spp <- tapply(fed_fin$fed_per_cnty,
                      INDEX=fed_fin$scientific,
                      FUN=sum)
state_exp_spp <- tapply(fed_fin$state_per_cnty,
                        INDEX=fed_fin$scientific,
                        FUN=sum)

# tot_exp_spp <- sort(exp_spp, decreasing=TRUE)
tot_exp_spp_df <- data.frame(scientific=names(tot_exp_spp),
                             tot_exp=as.vector(tot_exp_spp),
                             fws_exp=as.vector(fws_exp_spp),
                             other_fed_exp=as.vector(ofd_exp_spp),
                             fed_exp=as.vector(fed_exp_spp),
                             state_exp=as.vector(state_exp_spp))
exp_spp_df <- tot_exp_spp_df[order(-tot_exp_spp_df$tot_exp), ]

exp_spp_df$tot_cumsum <- cumsum(exp_spp_df$tot_exp)
exp_spp_df$fws_cumsum <- cumsum(exp_spp_df$fws_exp)
exp_spp_df$other_fed_cumsum <- cumsum(exp_spp_df$other_fed_exp)
exp_spp_df$fed_cumsum <- cumsum(exp_spp_df$fed_exp)
exp_spp_df$state_cumsum <- cumsum(exp_spp_df$state_exp)

# some Gini coefficients
library("reldist")

tot_gini <- gini(exp_spp_df$tot_exp)
fws_gini <- gini(exp_spp_df$fws_exp)
other_fed_gini <- gini(exp_spp_df$other_fed_exp)
state_gini <- gini(exp_spp_df$state_exp)
adf <- data.frame(group=c("total", "FWS", "other fed", "states"),
                  Gini=c(tot_gini, fws_gini, other_fed_gini, state_gini))
adf

par(mar=c(5, 5, 2, 2))
half_exp <- max(exp_spp_df$tot_cumsum)/2
p90_exp <- max(exp_spp_df$tot_cumsum) * 0.9
half_cnt <- sum(exp_spp_df$tot_cumsum <= half_exp)
p90_cnt <- sum(exp_spp_df$tot_cumsum <= p90_exp)
plot(exp_spp_df$tot_cumsum, 
     type="l",
     ylim=c(0, max(exp_spp_df$tot_cumsum + 1e4)),
     ylab="Cumulative Sum (dollars)",
     xlab="# Species Summed")
par(new=T)
plot(exp_spp_df$state_cumsum, 
     type="l",
     col="blue",
     ylim=c(0, max(exp_spp_df$tot_cumsum + 1e4)),
     ylab="",
     xlab="")
par(new=T)
plot(exp_spp_df$other_fed_cumsum, 
     type="l",
     col="red",
     ylim=c(0, max(exp_spp_df$tot_cumsum + 1e4)),
     ylab="",
     xlab="")
par(new=T)
plot(exp_spp_df$fws_cumsum, 
     type="l",
     col="orange",
     ylim=c(0, max(exp_spp_df$tot_cumsum + 1e4)),
     ylab="",
     xlab="")
par(new=F)

abline(h=half_exp, lty=2, col="gray")
abline(v=half_cnt, lty=2, col="gray")
abline(h=p90_exp, lty=3, col="gray")
abline(v=p90_cnt, lty=3, col="gray")
text(x=half_cnt+10, y=2e9, labels=half_cnt)
text(x=p90_cnt+25, y=2e9, labels=p90_cnt)



