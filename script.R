# packages
library(tidyverse)
library(sf)
library(terra)
library(readxl)
library(landscapetools)
library(landscapemetrics)

# import
mapbioas1985 <- terra::rast("brasil_coverage_1985.tif")
mapbioas2020 <- terra::rast("brasil_coverage_2020.tif")

mapbioas1985_flo <- mapbioas1985 == 3
mapbioas2020_flo <- mapbioas2020 == 3

po_f <- readxl::read_excel("Atlantic_forest_frugivory_data_points.xlsx") %>%
    sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
po_f

po_p <- readxl::read_excel("Atlantic_forest_floral_visitor_data_points.xlsx") %>% 
    sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
po_p

clas <- readxl::read_excel("MAPBIOMAS_Col6_Legenda_Cores.xlsx") %>% 
    janitor::clean_names() %>% 
    dplyr::select(layer= id, classe = colecao_5)
clas

# buffers
df1985 <- show_shareplot(mapbioas1985, po_f, 500, 5000, return_df = TRUE) %>% 
    .[[2]] %>% 
    dplyr::mutate(layer = as.numeric(layer)) %>% 
    dplyr::left_join(clas)
df1985

df2020 <- show_shareplot(mapbioas2020, po_f, 500, 5000, return_df = TRUE) %>% 
    .[[2]] %>% 
    dplyr::mutate(layer = as.numeric(layer)) %>% 
    dplyr::left_join(clas)
df2020

# export
readr::write_csv(df1985, "df1985.csv")
readr::write_csv(df2020, "df2020.csv")
