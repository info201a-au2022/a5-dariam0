library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

# data
co2_data <- read.csv("owid-co2-data.csv", header = TRUE, stringsAsFactors
                     = FALSE)

# vector of countries/continents
countries_continents <- distinct(co2_data, country)

# vector of years
co2_years <- distinct(co2_data, year)

# list of variables

# What is the average value of my variable across all the countries (in the current year)?
#   Where is my variable the highest / lowest?
#   How much has my variable change over the last N years?

server <- function(input, output) {
  
  # select 1st country/continent
  output$select_country_continents1 <- renderUI({
    selectInput(
      inputId = "country_continents1",
      label = "Select country/continent 1",
      choices = countries_continents,
      selected = "United States"
    )
  })
  
  # select 2nd country/continent
  output$select_country_continents2 <- renderUI({
    selectInput(
      inputId = "country_continents2",
      label = "Select country/continent 2",
      choices = countries_continents,
      selected = "Haiti"
    )
  })
  
  # select 3rd country/continent
  output$select_country_continents3 <- renderUI({
    selectInput(
      inputId = "country_continents3",
      label = "Select country/continent 3",
      choices = countries_continents,
      selected = "China"
    )
  })
  
  # # select y variable to graph 
  # output$y_variable <- renderUI({
  #   
  # })
  
  # select years
  output$select_year <- renderUI({
    sliderInput(
      inputId = "year",
      label = "Select Year Range",
      min = min(co2_years),
      max = max(co2_years),
      value = c(1950, 2020),
      sep = ""
    )
  #   sliderInput("slider2", label = h3("Slider Range"), min = 0, 
  #               max = 100, value = c(40, 60))
  # )
  })

}