#function that checks, & install the packages
install_packs <- function(x){
  for( i in x ){
    #  require returns TRUE invisibly if it was able to load package
    if( ! require( i , character.only = TRUE ) ){
      #  If package was not able to be loaded then re-install
      install.packages( i , dependencies = TRUE )
      #  Load package after installing
      require( i , character.only = TRUE )
    }
  }
}
#  Then try/install packages...
install_packs(c("ggplot2" , "shiny" , "shinyWidgets", "shinythemes", "gapminder") )

# library(shiny)
# library(shinyWidgets)
# library(shinythemes)
# library(gapminder)
# library(ggplot2)

#ui module
ui <- fluidPage(
  
  theme = shinytheme("flatly"), 
  
  titlePanel(div(HTML("<em>Life Expectancy vs. GDP per Continent & Year</em>"))),
  
  sidebarLayout(
    position= c("left", "right"), fluid= TRUE,
    
    sidebarPanel(

      pickerInput(
        inputId = "var_country", 
        label = "Select a country:", 
        choices = sample(levels(gapminder$country), 142), 
        options = list(
          `actions-box`= TRUE, 
          size= 10,
          `selected-text-format`= "count > 3"
        ), 
        multiple= FALSE
      ),
      
      prettyCheckbox(
        inputId = "var_continent", label= strong("Color Each Continent?"), icon= icon("check"), value= TRUE,
        status = "default", shape = "curve", animation = "pulse"
      ),
      
      sliderInput("var_year", "Year:",
                  min= min(gapminder$year),
                  max= max(gapminder$year),
                  value= min(gapminder$year), 
                  step= 5,
                  sep= "",
                  animate= animationOptions(interval= 1500, loop= TRUE)
      )
    ),
    
    mainPanel(plotOutput("gapPlot"))
  )
  
)
#server module
server <- function(input, output) {
  
  output$gapPlot <- renderPlot({
    
    current_year <- gapminder[gapminder$year == input$var_year, ]
    current_country <- which(current_year$country == input$var_country)
    pop_range <- range(gapminder$pop)
    
    gp <-  ggplot2::ggplot(data= current_year, aes(x= gdpPercap, y= lifeExp, size = pop)) +
            ggplot2::geom_point(alpha= 0.25) + ylim(20, 90) + 
            ggplot2::geom_text(data= current_year, aes(x= gdpPercap[current_country], y= lifeExp[current_country]), 
                      label= input$var_country, size= 6, color= "salmon4", family= "AvantGarde") +
            ggplot2::scale_x_log10(limits = range(gapminder$gdpPercap)) + 
            ggplot2::scale_size(guide = "none", range = c(1,20) * range(current_year$pop) / pop_range) + 
            ggplot2::theme_bw() + 
            ggplot2::labs(x="GDP per Capita ($)", y="Life Expectancy (yrs.)",
                          caption = "*Bubble's size depends on the country's population.") +
            ggplot2::theme(plot.caption = element_text(face= "italic"), 
                           plot.caption.position =  "plot")
    
    if (!input$var_continent) { 
      print(gp) 
    }
    if (input$var_continent) {
      gp + ggplot2::geom_point(aes(color= continent), alpha= 0.5) +
        ggplot2::scale_color_brewer(palette= "Set2", name= "Continent")
    }
    
  })
  
}
#Build the shiny module
shinyApp(ui= ui, server= server, options= list(height= 500, width= 500, scipen= 9999))