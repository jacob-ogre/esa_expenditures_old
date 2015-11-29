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
library(httr)
library(lattice)
library(lubridate)
library(RCurl)
library(RJSONIO)
library(shiny)
library(shinydashboard)
library(shinyBS)
# library(shinyURL)
library(xtable)

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
source("support/stick.R")
source("support/random_string.R")
source("txt/help.R")
source("txt/metadata.R")
source("txt/notes.R")
source("txt/text_styles.R")

#############################################################################
# Load the data and basic data prep
#############################################################################
load("data/FY2008-2013_fed_ESA_expenditures_by_county.RData")

# To facilitate adding new data, generate the vectors from the data
years <- c("All", as.numeric(levels(full$Year)))
states <- c("All", as.character(levels(full$STABBREV)))
groups <- c("All", as.character(levels(full$Group)))
species <- c("All", as.character(levels(as.factor(full$sp))))
cty_st <- c("All", as.character(levels(as.factor(full$cs))))


# table to look up species-specific jeop/admod info
# sp_look_f <- "data/jeop_admod_spp_table_12Jun2015.tab"
# sp_ja_dat <- read.table(sp_look_f, sep="\t", header=T)

# data for ESFO-level map
# eso_geo_fil <- "data/fieldOfficesTAILS.shp"
# eso_geo_dat <- readShapePoly(eso_geo_fil, 
#                              proj4string = CRS("+proj=merc +lon_0=90w"))

# extent <- as.vector(bbox(eso_geo_dat))
# xmin <- extent[1]
# ymin <- extent[2]
# xmax <- extent[3]
# ymax <- extent[4]

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


