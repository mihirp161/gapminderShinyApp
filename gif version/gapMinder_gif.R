options(scipen=999)
library(ggplot2)
library(dplyr)
library(gapminder)
library(gganimate)
library(scales)
library(gifski) 
library(RColorBrewer)
library(cowplot)

#Simple animate version
gap_draft <- gapminder::gapminder %>%
                dplyr::arrange(desc(pop)) %>%
                ggplot2::ggplot() +
                ggplot2::geom_point(aes(x= gdpPercap, y= lifeExp, size= pop, color= continent), alpha=0.5) +
                ggplot2::scale_color_brewer(palette = "Set2", name= "Continents")+
                ggplot2::scale_size(range = c(.1, 24), name= "Population Density", labels = scales::comma) +
                ggplot2::labs(x= "GDP per Capita",
                              y= "Life Expectancy",
                              title = "Life Expectancy vs. GDP per Continent from 1952 to 2007",
                              caption = "*Bubbles are various countries in that continent.") +
                ggplot2::theme_bw()+
                ggplot2::theme(plot.caption = element_text(face= "italic"), 
                                plot.title.position = "plot", 
                                plot.title = element_text(hjust=0.5),
                                plot.caption.position =  "plot") +
                ggplot2::scale_x_continuous(labels = scales::comma)+
                gganimate::transition_time(year)

gganimate::animate(gap_draft, nframes = 150, renderer = gifski_renderer("gapMinderGIF.gif"),height= 700, width= 1000)

