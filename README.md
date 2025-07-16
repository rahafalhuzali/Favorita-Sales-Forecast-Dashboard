# Favorita Sales Forecast Dashboard

An interactive sales forecasting dashboard for the Favorita dataset, built using R and Shiny.  
This project enables users to explore historical sales and generate forecasts for specific stores and product families, leveraging Facebook Prophet for time series forecasting.

## Features

- **Interactive UI**: Select store and product family to analyze.
- **Historical Visualization**: View sales history with dynamic plots.
- **Forecasting**: Generate sales forecasts (7–90 days) using Prophet.
- **Holiday Effects**: Incorporates national holidays into forecasts.
- **User-Friendly**: Simple, intuitive dashboard interface.

## Dataset Requirements

Place these CSV files in your app working directory:
- `train.csv` – Sales transaction data (must include `date`, `store_nbr`, `family`, `sales`)
- `stores.csv` – Store metadata (`store_nbr`, etc.)
- `holidays_events.csv` – Holiday/event information (`date`, `type`, `locale`)

## How It Works

1. **Data Loading & Preprocessing**
    - Loads sales, stores, and holidays data.
    - Joins store info and filters for holiday events.
2. **Interactive Filtering**
    - User selects store, product family, and forecast horizon.
3. **Visualization**
    - Plots historical sales data.
    - Fits Prophet model and visualizes forecast with holiday effects.
4. **Error Handling**
    - Alerts if data is missing or insufficient for forecasting.

## Getting Started

1. **Install required packages:**
    ```r
    install.packages(c("shiny", "dplyr", "ggplot2", "lubridate", "prophet", "readr", "data.table"))
    ```
2. **Run the app:**
    - Save `Sales1.R` in your working directory.
    - Place the CSV files as noted above.
    - In R, run:
      ```r
      source("Sales1.R")
      ```
    - The Shiny dashboard will launch in your browser.

## Screenshots

*(Add screenshots of your app here for better presentation.)*

## Project Structure

- `Sales1.R` – Main Shiny app script

## Acknowledgements

- [Facebook Prophet](https://facebook.github.io/prophet/) for time series forecasting
- [Shiny](https://shiny.rstudio.com/) for the interactive dashboard

---

**Contact:**  
For questions or collaboration, feel free to connect via [LinkedIn](https://linkedin.com/in/rahafalhuzali).
