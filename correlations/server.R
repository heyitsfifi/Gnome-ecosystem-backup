library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  # Read a CSV file
  
  filedata <- reactive({
    infile <- input$datafile
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    read.csv(infile$datapath)
  })
  
  output$fromCol <- renderUI({
    df <-filedata()
    if (is.null(df)) return(NULL)
    
    items=names(df)
    selectInput("from", "First Var:",items)
  })
  
  output$toCol <- renderUI({
    df <-filedata()
    if (is.null(df)) return(NULL)
    
    items=names(df)  
    selectInput("to", "Second Var:",items)
  })
  
  
#View the overview of the data from the csv file
 
 output$view <- renderTable({
   
  filedata()
    
  }) 

#Show the CSV file columns in two drop down lists. Let the user select one column from each list.  

  output$data <- renderTable({
  
    df=filedata()
    fr=input$from
    to=input$to
    
    firstVar = as.vector(df[[fr]])
    secondVar = as.vector(df[[to]])
    data = data.frame(firstVar,secondVar,stringsAsFactors=F)
    cbind(data)
    
  })
 
 # Correlation coefficient
output$cor <- renderPrint({
  
  df=filedata()
  fr=input$from
  to=input$to
  
  firstVar = as.vector(df[[fr]])
  secondVar = as.vector(df[[to]])
  data = data.frame(firstVar,secondVar,stringsAsFactors=F)
  first=data$firstVar
  second=data$secondVar
  
  # Calculate both the Pearson and Spearman correlation coefficients between the two columns selected by the user 
  pearson <- cor(first, second, method="pearson")
  p <- paste("Pearson:", pearson)
  print(p)
  spearman <- cor(first, second, method="spearman")
  s <- paste("Spearman:", spearman)
  print(s)
  
})
 
 
 # Draw a scatterplot of the two columns selected by the user
 output$plot <- renderPlot({
   df = filedata()
   fr=input$from
   to=input$to
   
   firstVar = as.vector(df[[fr]])
   secondVar = as.vector(df[[to]])
   data = data.frame(firstVar,secondVar,stringsAsFactors=F)
  p <- ggplot(data, aes(x=firstVar,y=secondVar)) + geom_point() + xlab(input$from) + ylab(input$to)
  print(p)
 })
  
})