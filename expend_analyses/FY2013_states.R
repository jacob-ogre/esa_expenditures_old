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
fil <- "~/OneDrive/Defenders/data/EndSp_expenditures/2013/FY2013_state_exp_EndSp_clean.tab"
dat <- read.table(fil, sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Add a null entry for Corals
coral <- c(NA, 2013, "Corals", NA, NA, NA, 0, 0, 0, 0)
dat <- rbind(dat, coral)

multi <- c(NA, 2013, "Multi-Species", NA, NA, NA, 0, 0, 0, 0)
dat <- rbind(dat, multi)

to_num <- c(7, 8, 9, 10)
for (i in to_num) {
    dat[,i] <- as.numeric(dat[,i])
}

datout <- "~/OneDrive/Defenders/data/EndSp_expenditures/2013/FY2013_state_exp_EndSp.RData"
save(dat, file=datout)

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







