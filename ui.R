#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/


###This runs when I highlight and press run. But not when I press the "run app" button above. 





#define UI

shinyUI(fluidPage(
    #Application Title 
    titlePanel("Spatial Map"),
    
    #insert sidebar later
    
     leafletOutput("my.map")
   ))
 

#shinyApp(ui, server)
 
 
# 


#__________________________________________

# Define UI for application that draws a histogram
#shinyUI(fluidPage(
  
  # Application title
  #titlePanel("Spatial Health Map"),
  
  # Sidebar with a slider input for number of bins 
  # sidebarLayout(
  #   sidebarPanel(
  #      sliderInput("bins",
  #                  "Number of bins:",
  #                  min = 1,
  #                  max = 50,
  #                  value = 30)
   # ),
    
#     # Show map
# 
#     mainPanel(
#       leafletOutput("map")
#     )
#   )
# )
