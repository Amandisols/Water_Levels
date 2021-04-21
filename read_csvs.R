#Loop for bringing in files.

library(tidyverse)
library(lubridate)
library(data.table)

#Convert all raw .hobo files in HOBO software to .csv through batch export. Save in "Raw" under date the files were downloaded.
csv_dir <- "~/Documents/VT/Data/MyData/Code/Water_Levels/Raw/csv"
out_dir <- "~/Documents/VT/Data/MyData/Code/Water_Levels/Processed"

#Download date, determines csv folder within "Raw"
dl_date = "2019_06_18"


###### Download options #######


#OPTION 1: function for one well at a time

download_fxn <-function(path, dl_date, well){
  DATA <- read_csv(paste(path, dl_date, well, sep = "/"), skip = 1, col_types = list(`Date Time, GMT-04:00` = col_datetime(format = "%m/%d/%y %H:%M:%S %p")))

  names(DATA)[1]<-"Id"
  names(DATA)[2]<-"DateTime"
  names(DATA)[3]<-"Pressure_kPa"
  names(DATA)[4]<-"Temp_C"

  DATA %>% select("Id", "DateTime", "Pressure_kPa", "Temp_C")
}




#OPTION 2: Loop for adding in a whole folder, each csv within a list.
file_paths <- fs::dir_ls(paste(csv_dir, dl_date, sep = "/"))
file_contents <- list()

for (i in seq_along(file_paths)) {
  file_contents[[i]] <- read_csv(file = file_paths[[i]], 
                                 skip = 1, 
                                 col_types = list(`Date Time, GMT-04:00` = col_datetime(format = "%m/%d/%y %H:%M:%S %p")))

}



file_contents <- set_names(file_contents, file_paths)




#OPTION 3: PURR option, brings in all csvs as list.

file_paths <- fs::dir_ls(paste(csv_dir, dl_date, sep = "/"))

allPT <- file_paths %>%
  map(function (path) {
    read_csv(path, 
             skip = 1, 
             col_types = list(`Date Time, GMT-04:00` = col_datetime(format = "%m/%d/%y %H:%M:%S %p")))
  })


#rename
colnames <- c("Id", "DateTime", "Pressure_kPa", "Temp_C") 
allPT<- lapply(allPT, setNames, colnames)


```
