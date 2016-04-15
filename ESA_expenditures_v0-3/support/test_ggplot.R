library(ggplot2)
library(ggthemes)
library(extrafont)

dat <- full


xaxs <- c(1, 1, 1, 2, 2, 2)
yaxs <- c(1, 2, 3, 1, 2, 3)
nspp <- c(1, 50, 100, 1, 50, 100)
ndol <- c(1, 50, 100, 100, 50, 1)
cols <- c("#d7191c", "#ffffbf", "#2c7bb6", "#2c7bb6", "#ffffbf", "#d7191c")
d <- data.frame(xaxs, yaxs, nspp, ndol, cols)

col2 <- c("#d7191c", "#ffffbf", "#2c7bb6")
p <- ggplot(d, aes(factor(xaxs), nspp)) +
     geom_point(aes(size=nspp, colour=ndol)) +
     scale_colour_distiller(palette="RdYlBu") +
     guides(size=FALSE) +
     labs(x="", y="# species") +
     theme_tufte(ticks=FALSE)
p


dolcnt <- tapply(dat$grand_per_cnty,
                 INDEX=dat$cs,
                 FUN=sum, na.rm=TRUE)
head(dolcnt)

sppcnt <- tapply(dat$sp,
                 INDEX=dat$cs,
                 FUN=get_n_levels)
head(sppcnt)

maxspp <- max(sppcnt)
minspp <- min(sppcnt)
medspp <- (maxspp + minspp) / 2

maxdol <- max(dolcnt)
mindol <- min(dolcnt)
meddol <- (maxdol + mindol) / 2

spp <- rep(c(maxspp, medspp, minspp), 2)
dol <- c(maxdol, meddol, mindol, mindol, meddol, maxdol)
xaxs <- c(1,1,1, 2,2,2)
d2 <- data.frame(spp, dol, xaxs)

col2 <- c("#d7191c", "#ffffbf", "#2c7bb6")
p <- ggplot(d2, aes(factor(xaxs), spp)) +
     geom_point(aes(size=spp, colour=dol/1000000)) +
     scale_y_continuous(breaks=round(spp, 0)) +
     scale_colour_distiller(palette="RdYlBu", 
                            name="Expenditures\n(million USD)") + 
     guides(size=FALSE) +
     labs(x="", y="# species") +
     theme_tufte(ticks=FALSE) +
     theme(axis.text.x=element_blank(),
           text=element_text(size=12, family="OpenSans-Light"),
           legend.text=element_text(size=8), 
           legend.title=element_text(size=8),
           legend.title.align=1,
           legend.key.width=unit(12, "points"),
           legend.justification=c(10,0)) #,
           # legend.position="bottom")
p


