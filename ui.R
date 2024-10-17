shinyUI(fluidPage(

    # Application title
    titlePanel("Google Location Data Timeline"),
    
    fluidRow( #row for the main map and side graphs/options

        column(8,     #column for the main map (left)
               
                 leafletOutput(outputId = "location",
                               width = '100%',
                               height = 550)
               ),
        
        column(4,     #column for the graphs/options(right)
               
               selectInput("select", label = h3("Side Measurements"), 
                           choices = list("Cumulative Mileage" = 1, "Animal Profile (in progress)" = 2, "(More coming soon...)" = 3), 
                           selected = 1),
               
               conditionalPanel(condition = "input.select == 1",    #opens up a plotly graph
                                plotlyOutput("overalls")
                                )
               ,
               # conditionalPanel(condition = "input.select == 2",  #opens up a pie chart
               #                  
               #                  plotOutput("animals"),
               #                  
               #                  selectInput(inputId = "state",
               #                              label = "Select State/Province",
               #                              choices = anm$State,
               #                              selected = "Virginia")
               #                  
               #                  ),

               # conditionalPanel(condition = "input.select == 3",  #opens up a something
               #                  otherOutput("NULLA")
               #                  )

              )
    ),
    
    fluidRow(   #row for the timeline at the bottom
        
        column(8,     #this chunk has a width of 12 and sits at the bottom of the page

          sliderInput("time_stamp",
                      label = h3("Date/Time Range"),
                      min = date_start, 
                      max = date_end,
                      value = c(date_start,tripdata$timestamp2[765]),
                      width = '100%',
                      timezone = "GMT",
                      step = 1,
                      round = F)
                      # animate =
                      #   animationOptions(interval = 300)
        ),
        
        column(2,
            checkboxInput("linestring", label = "Route Line", value = F),
        )
              
    )
))
