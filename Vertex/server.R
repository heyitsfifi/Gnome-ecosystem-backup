library(igraph)
options(shiny.maxRequestSize=-1) 

shinyServer(
  function(input, output) {
    
    filedata <- reactive({
      inFile = input$graph
      if (!is.null(inFile))
      read.graph(file=inFile$datapath, format="pajek")
     
    })
    
    DataDeg <- reactive({
        
      df <- filedata()
      vorder <-order(degree(df), decreasing=TRUE)
      DF <- data.frame(ID=as.numeric(V(df)[vorder]), degree=degree(df)[vorder])
      
    })
    DataBtwn <- reactive({
      df <- filedata()
      vorder <- order(betweenness(df), decreasing = TRUE)
      DF <- data.frame(ID=as.numeric(V(df)[vorder]), betweenness=betweenness(df)[vorder])
      
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
     if(input$radio == "sorted-degree"){
      DataDeg()
     } else if(input$radio == "sorted-betweenness"){
       DataBtwn()
     }
      
    })
    
       output$downloadData <- downloadHandler(
      
       filename = function() {
        paste(input$radio, '.csv', sep='')
      },
      

      content = function(file) {
      if(input$radio == "sorted-degree"){
      write.csv(DataDeg(), file) }
      else
      write.csv(DataBtwn(), file)
      }
      
    )
    
    
    })