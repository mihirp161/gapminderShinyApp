source("gapMinder_shiny.R")

shiny::shinyApp(ui= ui, server= server, options= list(height= 500, width= 500, scipen= 9999))
shiny::runGitHub("gapminder_shiny_app_R", "opendatasurgeon")