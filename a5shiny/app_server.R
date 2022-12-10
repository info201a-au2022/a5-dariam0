library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(scales)

# data
co2_data <- read.csv("owid-co2-data.csv", header = TRUE, stringsAsFactors
                     = FALSE)

# vector of countries/continents
countries_continents <- distinct(co2_data, country)

# vector of years
co2_years <- distinct(co2_data, year)

test1 <- co2_data %>% 
  filter(country %in% c("United States", "China", "Haiti")) %>% 
  filter(year %in% c(2010:2020))

# list of variables
var_list <- list("GDP" = "gdp",
                 "Population" = "population",
                 "CO2" = "co2",
                 "CO2 Per Capita" = "co2_per_capita",
                 "CO2 Per GDP" = "co2_per_gdp",
                 "Consumption CO2" = "consumption_co2",
                 "Consumption CO2 Per Capita" = "consumption_co2_per_capita",
                 "Consumption CO2 Per GDP" = "consumption_co2_per_gdp",
                 "Share Global CO2" = "share_global_co2")

# remove non countries
noncountries <- c("Africa", "Africa (GCP)", "Antarctica", "Asia",
                  "Asia (excl. China and India)", "Central America (GCP)",
                  "Europe", "Europe (GCP)", "Europe (excl. EU-27)",
                  "Europe (excl. EU-28)", "European Union (27)",
                  "European Union (27) (GCP)", "European Union (28)",
                  "French Equatorial Africa (GCP)", "French West Africa (GCP)",
                  "High-income countries", "International transport",
                  "Kuwaiti Oil Fires (GCP)",
                  "Leeward Islands (GCP)", "Low-income countries",
                  "Lower-middle-income countries", "Middle East (GCP)",
                  "Non-OECD (GCP)", "North America", "North America (GCP)",
                  "North America (excl. USA)", "OECD (GCP)", "Oceania",
                  "Oceania (GCP)", "Panama Canal Zone (GCP)",
                  "Ryukyu Islands (GCP)", "South America",
                  "South America (GCP)", "St. Kitts-Nevis-Anguilla (GCP)",
                  "Upper-middle-income countries", "World")

# What is the average value of co2 per capita across all the countries
# (in the current year)?
avg_co2_per_capita_2021 <- co2_data %>% 
  filter(year == 2021) %>% 
  filter(!(country %in% noncountries)) %>% 
  summarize(avg_co2_per_capita = mean(co2_per_capita, na.rm = TRUE)) %>% 
  pull(avg_co2_per_capita) %>% 
  round(2)

# What is the mean value of co2 per capita across all the countries
# (in the current year)?
median_co2_per_capita_2021 <- co2_data %>% 
  filter(year == 2021) %>% 
  filter(!(country %in% noncountries)) %>% 
  summarize(median_co2_per_capita = median(co2_per_capita, na.rm = TRUE)) %>%
  pull(median_co2_per_capita) %>% 
  round(2)

#   Where is highest share of global co2?
highest_share_co2_country_2021 <- co2_data %>%
  filter(year == 2021) %>%
  filter(!(country %in% noncountries)) %>%
  filter(share_global_co2 == max(share_global_co2, na.rm = TRUE)) %>%
  select(country)

# Their % share
highest_share_co2_2021_num <- co2_data %>%
  filter(year == 2021) %>%
  filter(!(country %in% noncountries)) %>%
  filter(share_global_co2 == max(share_global_co2, na.rm = TRUE)) %>%
  select(share_global_co2)

#   How much has co2 per capita over the last 20 years?
co2_per_cap_change_value <- co2_data %>% 
  filter(year == 2021 | year == 2001) %>% 
  filter(!(country %in% noncountries)) %>%
  group_by(year) %>% 
  summarize(total_co2_per_cap = sum(co2_per_capita, na.rm = TRUE))

# percentage change
co2_per_cap_change_perc <- ((co2_per_cap_change_value[2, 2] -
                             co2_per_cap_change_value[1, 2]) /
                             co2_per_cap_change_value[1, 2] * 100)
co2_per_cap_change_perc <- round(co2_per_cap_change_perc, 2)

server <- function(input, output) {
  
  output$intro <- renderUI({
    p("Climate change is a real issue. With climate change comes effects that
      include but are not limited to, more extreme weather, more drought,
      rising sea levels, and loss of biodiversity. One of the reasons for
      this phenomenon is our production and consumption of greenhouse gases
      in the atmosphere. Now, while we as a species drive this phenomenon,
      all of the countries in this world do not emit greenhouse gases equally;
      Some emit more greenhouse gases than others. This application will use
      data from", em("Our World in Data on CO2"), "and greenhouse gas emissions to
      examine what countries seem to be emitting the most and what countries
      emit the least in the years. Specifically, this application will focus
      on", strong("wealthy countries vs poor countries"), "in relation to
      their", strong("CO2 emissions per capita and their share of produced
      global CO2 emissions in percentage"), ". As for some quick values of
      interest, the country that has the highest share of global CO2 is",
      highest_share_co2_country_2021, "with", highest_share_co2_2021_num,
      "percent. As for CO2 per capita, in 2021, the average CO2 per
      capita was", avg_co2_per_capita_2021, "tonnes per person. The median
      was", median_co2_per_capita_2021, "tonnes per person. Finally, the
      percentage change in CO2 per capita over the last 20 years for all
      of the countries was", co2_per_cap_change_perc, "percent.")
  })
  
  # select y variable to graph 
  output$select_var <- renderUI({
    selectInput(
      inputId = "y_var",
      label = "Select Variable to Graph",
      choices = var_list
    )
  })
  
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
  
  # select years
  output$select_year <- renderUI({
    sliderInput(
      inputId = "year",
      label = "Select Year Range",
      min = 1900,
      max = max(co2_years),
      value = c(1950, 2020),
      sep = ""
    )
  })
  
  #linechart work
  linechart_plot <- reactive({
    # combine countries
    combine_countries <- c(input$country_continents1,
                           input$country_continents2,
                           input$country_continents3)
    
    # filter needed data
    linechart_data <- co2_data %>% 
      filter(country %in% combine_countries) %>% 
      filter(year >= input$year[1] & year <= input$year[2])
    
    # plot the data
    linechart_plot <- ggplot(data = linechart_data) +
      geom_line(aes_string(x = "year", y = input$y_var, color = "country")) +
      scale_y_continuous(labels = scales::comma) +
      labs(title = paste0(input$y_var, " for ", input$country_continents1,
                          ", ", input$country_continents2, ", and ",
                         input$country_continents3, " from ", input$year[1],
                         " to ", input$year[2]),
           x = "Year", color = "Country/Continent")
    linechart_plot
  })
  
  # display plotly linechart
  output$linechart <- renderPlotly({
    linechart_plot()
  })
}