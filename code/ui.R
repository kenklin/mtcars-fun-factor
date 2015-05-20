shinyUI(fluidPage(
  tags$head(
    tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
      body {
        background-color: #F4A460;
      }
      h1, strong {
        font-family: 'Lobster', cursive;
        font-weight: 500;
        line-height: 1.1;
        color: #48ca3b;
      }
      shiny-html-output, table, th, td {
        border: 1px solid lightgray;
        border-collapse: collapse;
      }
      shiny-html-output, th, td {
        padding: 0px;
      }
    "))
  ),

  headerPanel('1974 Cars Fun Factor'),

  sidebarPanel(
    h3("How would you define a car's fun factor?")
    ,p("Explore and create your fun factor formula for 1974 cars.")
    
    ,p(("The"), strong("fun")
      ,("factor (y axis) is computed by multiplying the numerators you supply below and dividing by the denominators.")
    )
    ,p(("To create high"), strong("fun"), ("factor formulas, use")
      ,br(), ("- \"bigger is better\" numerators.")
      ,br(), ("- \"smaller is better\" denominators.")
    )
    
    ,h3("y axis")
    ,selectInput('funFactors', 'Fun factor numerators', names(mtcars),
                 multiple=TRUE, selected='hp')
    ,selectInput('funDenominators', 'Fun factor denominators', names(mtcars),
                 multiple=TRUE, selected='qsec')

    ,h3("x axis")
    ,selectInput('xcol', NA, choices=names(mtcars), selected='wt')
    
    ,h3("split plot by")
    ,selectInput('facet', NA, choices=c('(none)', 'cyl', 'vs', 'am', 'gear', 'carb'), selected='(none)')
    
    ,("The dataset used is ")
    ,a("mtcars", href="http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html")
    ,(".")
    ,p(HTML("<table>"
            ,"<tr><th>var</th><th>description</th></tr>"
            ,"<tr><td>fun</td><td>Your <strong>fun</strong> factor value</td></tr>"
            ,"<tr><td>mpg</td><td>Miles/(US) gallon</td></tr>"
            ,"<tr><td>cyl</td><td>Number of cylinders</td></tr>"
            ,"<tr><td>disp</td><td>Displacement (cu.in.)</td></tr>"
            ,"<tr><td>hp</td><td>Gross horsepower</td></tr>"
            ,"<tr><td>drat</td><td>Rear axle ratio</td></tr>"
            ,"<tr><td>wt</td><td>Weight (lb/1000)</td></tr>"
            ,"<tr><td>qsec</td><td>1/4 mile time</td></tr>"
            ,"<tr><td>vs</td><td>Engine (0=V, 1=Straight)</td></tr>"
            ,"<tr><td>am</td><td>Transmission (0=automatic, 1=manual)</td></tr>"
            ,"<tr><td>gear</td><td>Number of forward gears</td></tr>"
            ,"<tr><td>carb</td><td>Number of carburetors</td></tr>"  
            ,"</table>"))
  ),

  mainPanel(
    plotOutput('plot1'),
    tableOutput('table1')
  )
))
