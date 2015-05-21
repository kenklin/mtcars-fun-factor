library(ggplot2)

# Returns a vector multiplying all funFactors and dividing funDenominators
calcFun <- function(cars, funFactors, funDenominators) {
  fun <- seq(1, length=nrow(cars), by=0) # all 1s
  if (length(funFactors) > 0) { 
    for (i in 1:length(funFactors)) {
      fun <- fun * cars[,funFactors[i]]
    }
  }
  if (length(funDenominators) > 0) {
    for (i in 1:length(funDenominators)) {
      fun <- fun / cars[,funDenominators[i]]      
    }
  }
  return(fun)
}

# Server
shinyServer(function(input, output, session) {
  
  # Recalculates an mtcars dataframe with `fun` variable
  recalcCars <- reactive({
    cars <- mtcars
    cars$cyl <- as.integer(cars$cyl)
    cars$vs <- as.integer(cars$vs)
    cars$am <- as.integer(cars$am)
    cars$gear <- as.integer(cars$gear)
    cars$carb <- as.integer(cars$carb)
    cars$fun <- calcFun(cars, input$funFactors, input$funDenominators)
    return(cars)
  })

  # Plot
  output$plot1 <- renderPlot({
    cars <- recalcCars()
    
    par(mar = c(5.1, 4.1, 0, 1))

    title1 <- "fun = "
    if (length(input$funFactors) > 0) {
      title1 <- paste0(title1, "(", paste(input$funFactors, collapse=" \u00D7 "), ")")
    } else {
      title1 <- paste0(title1, "1")
    }
    if (length(input$funDenominators) > 0) {
      title1 <- paste0(title1, "/(", paste(input$funDenominators, collapse=" \u00D7 "), ")")
    }
    title2 <- paste("\nvs.", input$xcol)

    p <- ggplot(cars, aes_string(x=input$xcol, y="fun"), environment=environment()) +
            ggtitle(paste0(title1, title2)) +
            theme(plot.title=element_text(size=18, lineheight=.6, face="bold", color="#48ca3b")) +
            geom_point()

    p <- p + geom_smooth(method="lm")
    
    p <- p + geom_text(hjust=0, angle=-30, size=4, color="red",
                       aes(label=rownames(cars)))

    # Facet?
    if (input$facet != "(none)") {
      p <- p + facet_grid(reformulate(".", input$facet), # input$facet ~ .
                          scales="free_y")
    }

    print(p)
  })
  
  # Table
  output$table1 = renderTable({
    # Relevant column names
    cols <- c("fun", input$funFactors, input$funDenominators, input$xcol)
    if (input$facet != "(none)") {
      cols <- c(cols, input$facet)
    }
    
    cars <- recalcCars()
    cars <- cars[, cols]
    return(cars)
  })
})
