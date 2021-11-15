## ui.R ##
packages = c('DT', 'ggplot2', 'shinydashboard', 'tidyverse', 'dplyr', 'leaflet', 'packrat', 'rsconnect', 'shiny', 'shinycssloaders', 'shinythemes', 'plotly', 'gridExtra', "RColorBrewer", 'highcharter')

for(p in packages){
  if(!require(p, character.only = T)){
    install.packages(p)
  }
  library(p, character.only = T)
}


dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)
