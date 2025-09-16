# Package ----
library(shiny)
library(dplyr) # traitement des données
library(readr) # chargement des fichier ( date automatique )
library(readxl) # pour du xl
library(ggplot2)
library(forcats)
library(plotly)
library(lubridate)

# data ----
data_allocine <- readr::read_csv2("data/data_allocine.csv")
correspondance <- readxl::read_excel("data/correspondances_allocine.xlsx")

allo_cine <- data_allocine %>% 
  left_join(correspondance, by = c("nationalite"="nationalité"))