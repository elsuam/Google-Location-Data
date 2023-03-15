#SERVER LOGIC

shinyServer(function(input, output) {
  
  #reactive to call data from ui
  ts <- reactive({ df %>%
      filter(timestamp >= input$time_stamp[1],
             timestamp <= input$time_stamp[2]) })
  
  
  #-------output panel for selectInput option 1-------
  
  output$overalls <- renderPlotly({
    
    f <-  ts() %>% 
      ggplot(aes(x=timestamp, y=cumul_distance, group = 1, text = paste(timestamp, "<br>",
                                                                        round(cumul_distance,2), " miles",
                                                                        sep="" ))) +
      geom_line(col = 'darkorange') +
      labs(y = "Miles", x="Date Range") +
      ggtitle("Cumulative Driving Mileage to Date") +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5))
    tooltip = c("text", "num")
    
    ggplotly(f, tooltip = c("text", "num"))
    
  })
  
  
  #-------output panel for selectInput option 2-------
  
  output$animals <- renderPlot({
    
    # ggplot(anm[anm$State == input$state,], aes(x="", y=Animals, fill = Animals)) +
    #   geom_bar(stat="identity", width=1) +
    #   coord_polar("y", start=0)
    
    
  })
  
  
  #-------output panel for selectInput option 3-------
  #
  #
  #
  
  
  
  #sets the stage of the map
  output$location <- renderLeaflet({   
    leaflet() %>% 
      addTiles(options = providerTileOptions(maxZoom = 10)) %>% 
      setView( lng = -98.5816684
               , lat = 45.8283459
               , zoom = 3.5)
  })
  
  #sets the points of the map (map stays the same and does not re-render)
  observe({         
    leafletProxy("location", data = ts()) %>%
      clearShapes() %>%
      addCircles(lng = ~lng,
                 lat = ~lat,
                 popup = ~as.character(paste0('<br><strong>Date and Time:</strong> ', timestamp,
                                              '<br><strong>Cumulative Distance</strong> ', round(cumul_distance,3), ' miles')),
                 color = 'blue'
                 )
  })
  
  
  
  
  observe({   #this proxy controls the 'Notable Points' markers based on if the box is checked or not
    if (input$newpts == T){
      
      leafletProxy("location", data = ns) %>%
        clearMarkers() %>%
        addMarkers(lng = ~lng,
                   lat = ~lat,
                   popup = ~as.character(paste0(attr,
                                                '<br>', round(timestamp, units = 'days') ) )
                   )
    }
    
    if (input$newpts == F){
      
      leafletProxy("location", data = ns) %>%
        clearMarkers()
    }
    
  })
  
  
})







