library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

# intro page
intro_page <- tabPanel(
  title = "Introduction",
  h1("Analyzing CO2 Emission Trends"),
  h2("by Daria Manguling"),
  uiOutput("intro")
)

# variables to add to lineplot
linegraph_var <- sidebarPanel(
  uiOutput("select_var"),
  uiOutput("select_country_continents1"),
  uiOutput("select_country_continents2"),
  uiOutput("select_country_continents3"),
  uiOutput("select_year")
)

# line plot itself
linegraph <- mainPanel(plotlyOutput("linechart"))

# linegraph page
linegraph_page <- tabPanel(
  title = "Line Graph",
  sidebarLayout(
    linegraph_var,
    linegraph
  ),
  p("This line chart was made to see the trends over the years and compare
    countries and continent stats together. From exploring this line chart,
    what caught my eye when looking at the data for high-income countries vs
    upper-middle-income countries vs low-income countries’ CO2 emissions per
    capita is that high-income countries produce much more CO2 emissions per
    capita than the two. In 2020, for low-income countries, it was 0.103
    tonnes per person. For upper-middle-income countries, it was 5.674 tonnes
    per person, and for high-income countries, it was 11.037 tonnes per person.
    However, looking at the years, even though high-income countries were the
    highest, their line is slowly decreasing while the upper-middle-income
    countries are slowly rising. When looking at the global share of CO2
    production, it was surprising that high-income countries started off the
    highest, but became 2nd place around 2010 when their percentage decreased
    while upper-middle-income countries increased. Low-income countries were
    relatively stagnant with their percentage being less than 1 percent.
    Seeing how much high-income countries and upper-middle-income
    countries produce CO2 emissions in comparison to low-income countries was
    eye-catching becausethose countries’ actions impact everyone, especially
    low-income countries.While the introduction does state that CO2 emissions
    per capita and the global share of CO2 production will be the main focus,
    other variables were included just for interest’s sake.")
)


# Define UI for application that draws a histogram
ui <- navbarPage(
  theme = shinythemes::shinytheme("flatly"),
  title = "CO2 Data",
  intro_page,
  linegraph_page
)