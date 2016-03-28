# Global functions to be called at app initiation.
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

#############################################################################
# Load packages and source files
#############################################################################
library(DT)
library(ggplot2)
# library(httr)
# library(lattice)
library(RCurl)
library(jsonlite)
# library(RJSONIO)
library(reldist)
library(shiny)
library(shinydashboard)
library(shinyBS)
# library(shinyURL)
# library(xtable)

library(leaflet)
library(maptools)
library(sp)

library(googleVis)
library(plyr)

source("data_mgmt/make_dataframes.R")
source("data_mgmt/subset_fx.R")
source("data_mgmt/summary_fx.R")
source("plot/bargraphs.R")
source("plot/histograms.R")
# source("support/stick.R")
# source("support/random_string.R")
source("txt/help.R")
source("txt/metadata.R")
source("txt/notes.R")
source("txt/text_styles.R")

#############################################################################
# Load the data and basic data prep
#############################################################################
load("data/FY2008-2013_fed_ESA_expenditures_by_county.RData")
full$GEOID <- as.character(full$GEOID)
full$GEOID <- ifelse(nchar(full$GEOID) == 4,
                     paste0("0", full$GEOID),
                     full$GEOID)
full$st_cnty_sp <- paste(full$cs, full$sp)

spa_dat <- read.csv("data/US_counties_attrib.csv", header=TRUE)
spa_dat$GEOID <- ifelse(nchar(spa_dat$GEOID) == 4,
                     paste0("0", spa_dat$GEOID),
                     spa_dat$GEOID)

# To facilitate adding new data, generate the vectors from the data
years <- c("All", as.numeric(levels(full$Year)))
states <- c("All", as.character(levels(full$STATE)))
groups <- c("All", as.character(levels(full$Group)))
species <- c("All", as.character(levels(as.factor(full$sp))))
cty_st <- c("All", as.character(levels(as.factor(full$cs))))

minYear <- min(as.numeric(levels(full$Year)))
maxYear <- max(as.numeric(levels(full$Year)))
full$Year <- as.numeric(as.character(full$Year))

# # Need to get the county outlines...
# topoData <- readLines("data/US_counties_1e5_topo.json") %>% paste(collapse="\n")
# topoData <- readLines("data/US_counties_5e4_topo.json") %>% paste(collapse="\n")
topoData <- readLines("data/US_counties_TIGERd_topo.json", warn=FALSE) %>% 
                paste(collapse="\n")

# tdat <- readLines("data/US_counties_TIGERd_topo.json", warn=FALSE) %>% 
#                   paste(collapse="\n") %>%
#                   fromJSON(simplifyVector=FALSE)

# tdat$style = list(
#     weight = 1,
#     color = "#ffcc00",
#     opacity = 1,
#     fillOpacity = 0.8
# )

# d2 <- tdat %>% toJSON(simplifyVector=TRUE)


# update colors for CSS
validColors_2 <- c("red", "yellow", "aqua", "blue", "light-blue", "green",
                   "navy", "teal", "olive", "lime", "orange", "orange_d", "fuchsia",
                   "purple", "maroon", "black")

validateColor_2 <- function(color) {
    if (color %in% validColors_2) {
        return(TRUE)
    }
  
    stop("Invalid color: ", color, ". Valid colors are: ",
         paste(validColors_2, collapse = ", "), ".")
}


