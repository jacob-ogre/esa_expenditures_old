# Prepare state and fed spending data for Shiny app.
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
base <- "~/OneDrive/Defenders/data/EndSp_expenditures/combined_clean/"
fed_fil <- paste(base, "FY2008-2013_fed_exp_EndSp_consistentNames.tab", sep="")
state_f <- paste(base, "FY2012-2013_state_exp_EndSp_consistentNames.tab", sep="")
fed <- read.table(fed_fil, sep="\t", header=TRUE, stringsAsFactors=FALSE)
state <- read.table(state_f, sep="\t", header=TRUE, stringsAsFactors=FALSE)

dim(fed)
dim(state)

names(fed)
names(state)

names(state) <- c("State", "Year", "Group", "Common", "Scientific", "Population",
                  "General_Expenditures", "Land_Expenditures", "Grand_Total",
                  "State_Cumulative")

#############################################################################
# Check for consistency, make changes as needed
#############################################################################
# add coral placeholders
coral <- c(NA, 2012, "Corals", NA, NA, NA, 0, 0, 0, 0)
state <- rbind(state, coral)

coral <- c(NA, 2013, "Corals", NA, NA, NA, 0, 0, 0, 0)
state <- rbind(state, coral)

# fix various outlying problems
state$Group <- ifelse(state$Group == "Multi-Species",
                      "Multi-species",
                      as.character(state$Group))

state$Common <- ifelse(state$Common == "Warbler, kirtlands",
                       "Warbler, Kirtlands",
                       as.character(state$Common))

fed$Scientific <- ifelse(fed$Scientific == "Gila seminuda(=robusta)",
                         "Gila seminuda (=robusta)",
                         fed$Scientific)

fed$Scientific <- ifelse(fed$Scientific == "Notropis topeka(=tristis)",
                         "Notropis topeka (=tristis)",
                         fed$Scientific)

fed$Scientific <- ifelse(fed$Scientific == "Cottus paulus(=pygmaeus)",
                         "Cottus paulus (=pygmaeus)",
                         fed$Scientific)

state$Scientific <- ifelse(state$Scientific == "Pritchardia aylmer- robinsonii",
                           "Pritchardia aylmer-robinsonii",
                           state$Scientific)

state$Scientific <- ifelse(state$Scientific == "Pritchardia aylmer- robinsonii",
                           "Pritchardia aylmer-robinsonii",
                           state$Scientific)

state$Scientific <- ifelse(state$Scientific == "Corynorhinus (=Plecotus) townsendii ingens  Ozark big-eared bat",
                           "Corynorhinus (=Plecotus) townsendii ingens",
                           state$Scientific)

state$Scientific <- ifelse(state$Scientific == "Pediocactus (=Echinocactus,=Utahi a) sileri",
                           "Pediocactus (=Echinocactus,=Utahia) sileri",
                           state$Scientific)

# convert to factors
fed_to_fac <- c(1, 2, 4, 5, 13)
for (i in fed_to_fac) {
    fed[,i] <- as.factor(fed[,i])
}

state_to_fac <- c(1, 2, 3, 4, 5)
for (i in state_to_fac) {
    state[,i] <- as.factor(state[,i])
}

# ensure no differences in groups
setdiff(levels(state$Group), levels(fed$Group))
setdiff(levels(fed$Group), levels(state$Group))

# get sci and common names
fed_sci <- levels(fed$Scientific)
state_sci <- levels(state$Scientific)
fed_com <- levels(fed$Common)
state_com <- levels(state$Common)
length(fed_sci)
length(fed_com)
length(state_sci)
length(state_com)

# ensure no state names are not in fed names
setdiff(levels(state$Common), levels(fed$Common))
setdiff(levels(state$Scientific), levels(fed$Scientific))

# check / convert money to numeric
fed_chk_num <- c(14, 15, 16, 17, 18)
for (i in fed_chk_num) {
    if (!is.numeric(fed[,i])) {print(names(fed)[i])}
}

state_chk_num <- c(7, 8, 9, 10)
for (i in state_chk_num) {
    if (!is.numeric(state[,i])) {
        state[,i] <- as.numeric(state[,i])
    }
}


#############################################################################
# Write the updated dataframes to file
#############################################################################
fed_out <- paste(base, "RDATAs/FY2008-2013_fed_exp_EndSp.RData", sep="")
state_o <- paste(base, "RDATAs/FY2012-2013_state_exp_EndSp.RData", sep="")
save(fed, file=fed_out)
save(state, file=state_o)

fed_out <- paste(base, "TABs/FY2008-2013_fed_exp_EndSp_final.tab", sep="")
state_o <- paste(base, "TABs/FY2012-2013_state_exp_EndSp_final.tab", sep="")
write.table(fed,
            file=fed_out,
            sep="\t",
            row.names=FALSE,
            quote=FALSE)
write.table(state,
            file=state_o,
            sep="\t",
            row.names=FALSE,
            quote=FALSE)








