#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
# #install rgdl & Leaflet library for polygons 
# #install.packages("rgdal")
library(rgdal)
# #install.packages("leaflet")
library(leaflet)
# #install.packages("dplyr")
library(dplyr)
# #install.packages("colorRamps")
library(colorRamps)
# #install.packages("graphics")
library(graphics)
# #install.packages("RColorBrewer")
library(RColorBrewer)
# #install.packages("foreign")
library(foreign)
# #install.packages("maptools")
library(maptools)
# #install.packages("ggplot2")
library(ggplot2)




##load shape file 

SLA <- readOGR(dsn= "/Users/robertj9/L.Projects/L.Uncert.spatialmap/Qld.shape files",
               layer = "SLA_QLD_06", verbose = FALSE)


#load file with estimates 
data <- read.csv("/Users/robertj9/L.Projects/L.Uncert.spatialmap/est.datafile.10feb2016.csv")


#add SIR values to data.frame? 
SLA$estimate <- data$est



##SLA$estimate <- data$est
SLA$ci.u <- data$ci.u
SLA$ci.l <- data$ci.l
SLA$ci.length <- data$ci.length


#Legend labels 
legend.lab <- c("Very High"," ", "High"," ",  "Average", " ",  "Low", " ", "Very Low")

#create a colour palette _______________________________________
pal1 <- colorBin( c("#CCCC00","#FFFFFF", "#993399"), SLA$estimate, bins = c( 0.0, 0.7, 0.8, 0.9, 1.1, 1.2, 1.3, 2.06), pretty = FALSE) 



pal2 <- colorQuantile("Blues", SLA$estimate, n=5)


#_____________________
#draw map 

leaflet(SLA) %>%
  addPolygons( 
    stroke = FALSE, fillOpacity = 1, smoothFactor = 0.2,
    color = ~pal1(SLA$estimate)
  ) %>%
  addLegend("bottomleft", values = SLA$estimate, title = "Spatial Health Map", colors= c( "#993399", "#B970B6", "#D6A9D3", "#F2E2F0", "#FFFFFF","#FBF7E1", "#EFE8A4", "#E0DA66", "#CCCC00" ), labels = legend.lab, opacity = 1)



