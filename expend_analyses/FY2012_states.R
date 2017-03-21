# Quick analyses of FY 2012 state spending on listed species.
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

require(ggplot2)

#############################################################################
# Load the data
#############################################################################
fil <- "~/Dropbox/Defenders/data/FY2012_state_ES_expenditures/FY2012_state_exp_EndSp.tab"
alld <- "~/Dropbox/Defenders/other_reports/all_FWS_ES_pdfs/expenditure_reports"
allf <- paste(alld, 
              "expenditures_Table1/extracted_tabd/2012_expenses_tab1_finalish.tab", 
              sep="/")

dat <- read.table(fil, sep="\t", header=TRUE, stringsAsFactors=FALSE)
all <- read.table(allf, sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Add a null entry for Arachnids
arach <- c(NA, "Domestic", "Arachnids", NA, NA, NA, 0, 0, 0, 0)
dat <- rbind(dat, arach)

coral <- c(NA, "Domestic", "Corals", NA, NA, NA, 0, 0, 0, 0)
dat <- rbind(dat, coral)

multi <- c(NA, "Multi-Species", NA, NA, NA, NA, 0, 0, 0, 0, 0)
all <- rbind(all, multi)

to_num <- c(7, 8, 9, 10)
for (i in to_num) {
    dat[,i] <- as.numeric(dat[,i])
}

to_num <- c(7, 8, 9, 10, 11)
for (i in to_num) {
    all[,i] <- as.numeric(all[,i])
}

dat$Year <- rep(2012, length(dat$State))
all$Year <- rep(2012, length(all$Rank))

datout <- "~/Dropbox/Defenders/data/FY2012_state_ES_expenditures/FY2012_state_exp_EndSp.RData"
allout <- "~/Dropbox/Defenders/data/FY2012_state_ES_expenditures/FY2012_all_exp_EndSp.RData"
save(dat, file=datout)
save(all, file=allout)

#############################################################################
# Some quick stats
#############################################################################
st_grand_by_sp <- tapply(dat$Grand_Total,
                         INDEX=as.factor(dat$Common_Name),
                         FUN=sum,
                         na.rm=TRUE)
st_grand_by_sp

st_grand_by_group <- tapply(dat$Grand_Total,
                            INDEX=as.factor(dat$Group),
                            FUN=sum,
                            na.rm=TRUE)
st_grand_by_group

st_nonland_by_group <- tapply(dat$General_Expenditures,
                              INDEX=as.factor(dat$Group),
                              FUN=sum,
                              na.rm=TRUE)
st_nonland_by_group

all_nonland_by_group <- tapply(all$Species_tot,
                             INDEX=as.factor(all$Group),
                             FUN=sum,
                             na.rm=TRUE)
all_nonland_by_group

st_nonland_by_group / (st_nonland_by_group + all_nonland_by_group)
st_grand_by_group / (st_grand_by_group + all_nonland_by_group)







