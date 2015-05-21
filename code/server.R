library(ggplot2)

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

# Returns a vector multiplying all funFactors and dividing funDenominators
calcFun <- function(cars, funFactors, funDenominators) {
  fun <- cars[,funFactors[1]]
  if (length(funFactors) >= 2) { 
    for (i in 2:length(funFactors)) {
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

    title <- paste0("fun = (", paste(input$funFactors, collapse=" \u00D7 "), ")")
    if (length(input$funDenominators) > 0) {
      title <- paste0(title, "/(", paste(input$funDenominators, collapse=" \u00D7 "), ")")
    }
    title <- paste(title, "vs.", input$xcol)

    p <- ggplot(cars, aes_string(x=input$xcol, y="fun")) +
            ggtitle(title) +
            geom_point()

    p <- p + geom_smooth(method="lm")
    
    p <- p + geom_text(hjust=0,
                       angle=-30,
                       size=4,
                       aes(label=rownames(cars)))

#    p <- ggplot(mtcars, aes(x=wt, y=mpg, label=rownames(mtcars)))
#    p <- p + geom_text()

#   p <- ggplot(cars, aes_string(x=input$xcol, y="fun"), aes(label=rownames(mtcars)))
#    p <- p + geom_text()

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
