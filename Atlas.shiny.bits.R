#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


library(shiny)


##install rgdl & Leaflet library for polygons 
# install.packages("rgdal")
library(rgdal)
# install.packages("leaflet")
library(leaflet)
# install.packages("dplyr")
library(dplyr)
# install.packages("colorRamps")
library(colorRamps)
# install.packages("graphics")
library(graphics)
# install.packages("RColorBrewer")
library(RColorBrewer)
# install.packages("foreign")
library(foreign)
library(colorspace)


mydata <- read.dta("c:/mydata.dta")

##load shape file 

SLA <- readOGR(dsn= "C:/Users/robertj9/RDirectory/Catlas1.27jan16/Qld.shape files",
               layer = "SLA_QLD_06", verbose = FALSE)

##laod SIR data 
mydata <- read.dta(file.choose())

##add attribute to shape file 
SLA$new.att <- 1:nrow(SLA)

#create dataframe of SLA
data.frame(SLA)


#load file with estimates 
data <- read.csv(file.choose())

#create variable of sir values 
sir.value <- (select(data, SIR))


#add SIR values to data.frame? 
SLA$sir <- sir.value

#create character vector from est.SIR



mutate(data, RISk = ifelse(est.SIR %in% 0.0:0.69, "Very Low", 
           ifelse(est.SIR %in% 0.7:0.89, 
              ifelse(est.SIR %in% 0.9:1.09, "Average", 
                 ifelse(est.SIR %in% 1.1:1.29, "High", 
                      ifelse(est.SIR %in% 1.3:2.06, "Very High", "Very High"))))))

      

ata %>%
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


#create a colour palette _______________________________________
pal1 <- colorBin( c("#CCCC00","#FFFFFF", "#993399"), SLA$SIR, bins = c( 0.0, 0.7, 0.8, 0.9, 1.1, 1.2, 1.3, 2.06), pretty = FALSE) 

pal2 <- colorRamps::blue2yellow(5)

pal3 <- colorNumeric( palette = c("#E5E600", "#FFFFFF", "#660066"  ), domain = SLA$SIR, 5)


pal4 <- choose_palette()

pal5 <- diverge_hcl(5, h = c(260, 0), c = 80, l = c(30, 90), power = 1.5, 
                    fixup = TRUE, gamma = NULL, alpha = 1)

pal6 <- colorQuantile("Blues", SLA$SIR, n=5)

pal7 <- colorFactor(c("#993399","#FFFFFF", "#CCCC00"), domain = SLA$Risk.label, ordered =TRUE, na.color = "#808080", alpha = FALSE)

legend.lab <- c("Very High"," ", "High"," ",  "Average", " ",  "Low", " ", "Very Low")

#_____________________
#draw map 

leaflet(SLA) %>%
  addPolygons( 
    stroke = FALSE, fillOpacity = 1, smoothFactor = 0.2,
    color = ~pal1(SLA$SIR)
  ) %>%
  addLegend("bottomleft", values = SLA$SIR, title = "Lung Cancer Risk", colors= c( "#993399", "#B970B6", "#D6A9D3", "#F2E2F0", "#FFFFFF","#FBF7E1", "#EFE8A4", "#E0DA66", "#CCCC00" ), labels = legend.lab, opacity = 1)





#__________________________________________

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
