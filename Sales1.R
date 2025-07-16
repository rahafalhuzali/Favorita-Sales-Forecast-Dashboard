# Make sure to install these packages if not already installed:
# install.packages(c("shiny", "dplyr", "ggplot2", "lubridate", "prophet", "readr", "data.table"))




library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(prophet)
library(readr)
library(data.table)
library(prophet)


# Set your working directory to the folder where your CSV files are located
# setwd("C:/Users/Delll/Documents")  # <-- change this path if needed

# Try loading the data, and stop with a helpful message if any file is missing
tryCatch({
  sales <- fread("train.csv") %>% mutate(date = ymd(date))
  stores <- fread("stores.csv")
  holidays <- fread("holidays_events.csv") %>%
    filter(type == "Holiday") %>%
    transmute(ds = ymd(date), holiday = locale)
  
  # Join store information into the sales dataset
  sales <- sales %>% left_join(stores, by = "store_nbr")
}, error = function(e) {
  stop("??? Make sure 'train.csv', 'stores.csv', and 'holidays_events.csv' are in your working directory: ", getwd())
})

# Define the user interface (UI)
ui <- fluidPage(
  titlePanel("??????? Favorita Sales Forecast Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("store_sel", "Select Store:", choices = unique(sales$store_nbr)),
      selectInput("fam_sel", "Select Product Family:", choices = unique(sales$family)),
      sliderInput("horizon", "Forecast Days:", min = 7, max = 90, value = 30),
      actionButton("go", "Generate Forecast")
    ),
    mainPanel(
      plotOutput("hist_plot"),   # Plot for historical sales
      plotOutput("fc_plot")      # Plot for forecast
    )
  )
)

# Define the server logic
server <- function(input, output, session) {
  
  # Create filtered dataset based on selected store and family
  df_sel <- eventReactive(input$go, {
    sales %>%
      filter(store_nbr == input$store_sel, family == input$fam_sel) %>%
      group_by(date) %>%
      summarize(sales = sum(sales), .groups = "drop") %>%
      arrange(date)
  })
  
  # Plot historical sales data
  output$hist_plot <- renderPlot({
    df <- df_sel()
    ggplot(df, aes(date, sales)) +
      geom_line(color = "steelblue", size = 1) +
      labs(title = "???? Historical Sales", x = "Date", y = "Total Sales")
  })
  
  # Plot forecasted sales using Prophet
  output$fc_plot <- renderPlot({
    df <- df_sel()
    if (nrow(df) < 30) {
      plot.new()
      title("??? Not enough data to generate forecast")
    } else {
      df_prophet <- df %>% rename(ds = date, y = sales)
      
      m <- prophet(df_prophet,
                   holidays = holidays,
                   yearly.seasonality = TRUE,
                   weekly.seasonality = TRUE,
                   daily.seasonality = FALSE)
      
      future <- make_future_dataframe(m, periods = input$horizon)
      fc <- predict(m, future)
      
      plot(m, fc) + ggtitle(paste("???? Forecast for next", input$horizon, "days"))
    }
  })
}

# Launch the Shiny app
shinyApp(ui = ui, server = server)
