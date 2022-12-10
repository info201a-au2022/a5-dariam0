library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

# intro page 
intro_page <- tabPanel(
  title = "Analyzing CO2 Emission Trends",
  uiOutput("intro")
)

# variables to add to lineplot
linegraph_var <- sidebarPanel(uiOutput("select_var"),
                              uiOutput("select_country_continents1"),
                              uiOutput("select_country_continents2"),
                              uiOutput("select_country_continents3"),
                              uiOutput("select_year"))

# line plot itself
linegraph <- mainPanel(plotlyOutput("linechart"))

# linegraph page
linegraph_page <- tabPanel(
  title = "Line Graph",
  sidebarLayout(
    linegraph_var,
    linegraph
  )
)


# Define UI for application that draws a histogram
ui <- navbarPage(
  theme = shinythemes::shinytheme("flatly"),
  title = "CO2 Data",
  intro_page,
  linegraph_page
)
