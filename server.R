#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
#install rgdl & Leaflet library for polygons 
install.packages("rgdal")
library(rgdal)
install.packages("leaflet")
library(leaflet)
install.packages("dplyr")
library(dplyr)
install.packages("colorRamps")
library(colorRamps)
install.packages("graphics")
library(graphics)
install.packages("RColorBrewer")
library(RColorBrewer)
install.packages("foreign")
library(foreign)



##load shape file 


SLA <- readOGR(dsn= "__insert shape file location__",
               layer = "SLA_QLD_06", verbose = FALSE)

##add est.SIR & CI bounds to shape file 
data <- read.csv("C:/Users/___insert data file location")

  
##add SIR and CI values to shape file 

SLA$SIR <- data$est.SIR
SLA$ci.u <- data$ci.u
SLA$ci.l <- data$ci.l
SLA$ci.length <- data$ci.length

#create legend labels as character vector and add to Shape File 
ata <- data %>%
  mutate(Risk = ifelse(est.SIR < 0.7,
        yes = "Very Low",
        no = ifelse(est.SIR < 0.9,
             yes = "Low",
             no = ifelse(est.SIR < 1.1, 
                 yes = "Average", 
                 no = ifelse(est.SIR <1.3, 
                     yes = "High", 
                     no = ifelse(est.SIR >1.31, 
                       yes = "Very High",
                       no = "na"))))))        

SLA$Risk.label <- ata$Risk

#create a colour palette 
pal1 <- colorBin( c("#CCCC00","#FFFFFF", "#993399"), SLA$SIR, bins = c(0.0, 0.7, 0.8, 0.9, 1.1, 1.2, 1.3, 2.06), pretty = FALSE) 

legend.lab <- c("Very High"," ", "High"," ",  "Average", " ",  "Low", " ", "Very Low")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$mymap <- renderLeaflet({
      leaflet(SLA) %>%
      addPolygons( 
        stroke = FALSE, fillOpacity = 1, smoothFactor = 0.2,
        color = ~pal1(SLA$SIR)
      ) %>%
      addLegend("bottomleft", values = SLA$SIR, title = "Lung Cancer Risk", colors= c( "#993399", "#B970B6", "#D6A9D3", "#F2E2F0", "#FFFFFF","#FBF7E1", "#EFE8A4", "#E0DA66", "#CCCC00" ), labels = legend.lab, opacity = 1)
    
  })
  
})
