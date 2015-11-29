# Semi-final re-import and saving of data file (post-salmonid fix).
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

full <- read.table(gzfile("e:/esa_expenditures/defenders_expend_shiny/data/FY2008-2013_fed_ESA_expenditures_by_county.tab.gz"), 
                   header = T, 
                   sep = "\t", 
                   stringsAsFactors = F)
                   
full$Year <- as.factor(full$Year)
full$Group <- as.factor(full$Group)
full$scientific <- as.factor(full$scientific)
full$Common <- as.factor(full$Common)
full$NAME <- as.factor(full$NAME)
full$STABBREV <- as.factor(full$STABBREV)
full$STATE <- as.factor(full$STATE)
full$n_combos <- as.numeric(full$n_combos)
full$grand_per_cnty <- as.numeric(full$grand_per_cnty)
full$fws_per_cnty <- as.numeric(full$fws_per_cnty)
full$other_fed_per_cnty <- as.numeric(full$other_fed_per_cnty)
full$fed_per_cnty <- as.numeric(full$fed_per_cnty)
full$state_per_cnty <- as.numeric(full$state_per_cnty)

full$cs <- paste(as.character(full$NAME), as.character(full$STABBREV), sep = ", ")
full$sp <- paste(as.character(full$Common), " (", as.character(full$scientific), ")", sep = "")

save(full, file="e:/esa_expenditures/defenders_expend_shiny/data/FY2008-2013_fed_ESA_expenditures_by_county.RData")
