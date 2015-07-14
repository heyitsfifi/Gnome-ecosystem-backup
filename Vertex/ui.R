library(igraph)
options(shiny.maxRequestSize=-1)

shinyUI(fluidPage(
  titlePanel("Finding most influential vertex in a network"),
  
  sidebarLayout(
    sidebarPanel(
     
      fileInput("graph", label = h4("Pajek file")),
      radioButtons("radio", "Type of centrality:", c("Degree" ="sorted-degree" , "Betweenness" = "sorted-betweenness", "Transitivity" = "sorted-transitivity")),
      downloadButton("downloadData", "Download")     
    ),
    mainPanel( uiOutput("tb")             
               )                        
  )
))