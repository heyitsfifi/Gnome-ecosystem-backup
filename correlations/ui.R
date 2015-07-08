library(shiny)
shinyUI(fluidPage(
  
  titlePanel("analysis"),
  
  sidebarLayout(
    sidebarPanel(
               
               fileInput('datafile', 'Choose CSV File',
                         accept=c('text/csv', 
                                  'text/comma-separated-values,text/plain', 
                                  '.csv')),
               uiOutput("fromCol"), # fromCol is coming from renderUI in server.r
               uiOutput("toCol") #toCol is coming from renderUI in server.r
               
               
      
      
      ),
    
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Overview", tableOutput("view")),
                  tabPanel("Data", tableOutput("data")),
                  tabPanel("Correlation", verbatimTextOutput("cor")),
                  tabPanel("Plot", plotOutput("plot"))
                  
              
      )
      
      
   
    
    
    )
  )
))
