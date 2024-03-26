knitr::opts_chunk$set(warnings = FALSE, message = FALSE)

library(tidyverse)
library(shiny)
library(plotly)

data <- read_csv("https://go.wisc.edu/2284o1") |>
  arrange(AcceptedCmpOverall)

ui <- fluidPage(
  titlePanel(title = "Affect of Web History on Campaign Acceptance"),
  sliderInput("income", "Yearly Household Income ($)", 1730, 113734, c(1730, 113734)),
  plotlyOutput("bar_plot", width="800px", height="500px")
)

server <- function(input, output) {
  output$bar_plot <- renderPlotly({
    data |>
      filter(
        Income >= input$income[1] & Income <= input$income[2]
        ) |>
      plot_ly(x=~NumWebVisitsMonth, y=~NumWebPurchases, type="bar", marker=list(colorbar=list(title="# of Campaigns Before Acceptance"), color=~AcceptedCmpOverall, colorscale = list(c(0, 1), c("#0cebb0", "#1F27FF")), showscale = TRUE),
     hovertext= ~paste("# of Purchases:",NumWebPurchases,"<br> # of Web Visits:",NumWebVisitsMonth,"<br> # of Campaigns before Acceptance:",AcceptedCmpOverall)) |>
      layout(autosize=F, xaxis = list(title="Number of Web Visits Per Month",range=list(0,11)), title="Web Visits vs Web Purchases", yaxis=list(title="Number of Web Purchases"))
  })
}

shinyApp(ui, server)
