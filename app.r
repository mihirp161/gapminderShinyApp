source("gapMinder_shiny.R")
#alternate run
shiny::shinyApp(ui= ui, server= server, options= list(height= 500, width= 500, scipen= 9999))
