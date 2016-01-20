

make_my_legend <- function(cur_dat, circ) {
    ylab <- ifelse(circ == "sep",
                   "-      # species      +",
                   "-     USD / species      +")
    legn <- ifelse(circ == "sep",
                   "Expenditures\n(million USD)",
                   "Expenditures\n($1,000s/species)")
    p <- ggplot(cur_dat, aes(factor(xaxs), spp)) +
         geom_point(aes(size=spp, colour=dol/1000000)) +
         geom_point(aes(size=spp)) +
         scale_size(range=c(2,11)) +
         scale_y_continuous(breaks=round(cur_dat$spp, 0),
                            limits=c(0, max(cur_dat$spp) + 0.1*max(cur_dat$spp))) +
         scale_colour_distiller(palette="RdYlBu", 
                                direction=1,
                                name=legn) + 
         guides(size=FALSE) +
         labs(x="", y=ylab) +
         theme_tufte(ticks=FALSE) +
         theme(axis.text.x=element_blank(),
               axis.text.y=element_blank(),
               text=element_text(size=12, family="OpenSans"),
               legend.text=element_text(size=11), 
               legend.title=element_text(size=11),
               legend.title.align=-1,
               legend.key.width=unit(14, "points"),
               legend.position="right")
    return(p)
}
