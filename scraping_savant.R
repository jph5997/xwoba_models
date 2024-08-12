# Code to read savant data into csvs
# Function to fetch data in weekly chunks
library(baseballr)
library(dplyr)

fetch_statcast_data <- function(start_date, end_date) {
  all_data <- data.frame()
  current_start <- start_date
  
  while (current_start <= end_date) {
    current_end <- min(current_start + weeks(1) - days(1), end_date)
    message("Fetching data from ", current_start, " to ", current_end)
    
    try({
      chunk <- statcast_search(start_date = as.character(current_start), 
                               end_date = as.character(current_end))
      all_data <- bind_rows(all_data, chunk)
    }, silent = TRUE)
    
    current_start <- current_end + days(1)
  }
  
  return(all_data)
}

# Fetch data for 2020 season in weekly chunks
data_2020 <- fetch_statcast_data(as.Date("2020-07-23"), as.Date("2020-09-27"))

# Fetch data for 2021 season in weekly chunks
data_2021 <- fetch_statcast_data(as.Date("2021-04-01"), as.Date("2021-10-03"))

# Fetch data for 2022 season in weekly chunks
data_2022 <- fetch_statcast_data(as.Date("2022-04-07"), as.Date("2022-10-05"))

# Fetch data for 2023 season in weekly chunks
data_2023 <- fetch_statcast_data(as.Date("2023-03-30"), as.Date("2023-10-01"))

# Combine data for 2020-2022
training_testing_data <- bind_rows(data_2020, data_2021, data_2022)

# now transfer them into csvs that we can use
write.csv(data_2020, file = "statcast_2020.csv")
write.csv(data_2021, file = "statcast_2021.csv")
write.csv(data_2022, file = "statcast_2022.csv")
write.csv(data_2023, file = "statcast_2023.csv")