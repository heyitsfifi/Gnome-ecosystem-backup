library(igraph)
options(shiny.maxRequestSize=-1) 

shinyServer(
  function(input, output) {
    
    filedata <- reactive({
      inFile = input$graph
      if (!is.null(inFile))
      read.graph(file=inFile$datapath, format="pajek")
     
    })
    
    Data <- reactive({
        
      df <- filedata()
      vorder <-order(degree(df), decreasing=TRUE)
      DF <- data.frame(ID=as.numeric(V(df)[vorder]), degree=degree(df)[vorder])
      
    })
    
    output$tb <- renderUI({
      if(is.null(filedata()))
      h2("Please select Pajek file..")
    else
      tabsetPanel(type = "tabs", 
                  tabPanel("Table", tableOutput("view")) ) 
      
    }      
      )
    output$view <- renderTable({
    
      Data()
      
    })
    
       output$downloadData <- downloadHandler(
      
       filename = function() {
        paste("degree", '.csv', sep='')
      },
      

      content = function(file) {
    
      write.csv(Data(), file)
      }
      
    )
    
    
    })