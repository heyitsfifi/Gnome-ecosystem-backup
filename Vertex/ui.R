library(igraph)
options(shiny.maxRequestSize=-1)

shinyUI(fluidPage(
  titlePanel("Finding most influential vertex in a network"),
  
  sidebarLayout(
    sidebarPanel(
     
      fileInput("graph", label = h4("Pajek file")),
      
      downloadButton("downloadData", "Download")
     
     
    ),
    mainPanel( uiOutput("tb")             
               )                        
  )
))