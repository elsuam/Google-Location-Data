#SERVER LOGIC

shinyServer(function(input, output) {
  
  #reactive to call data from ui
  ts <- reactive({ tripdata %>%
      filter(timestamp2 >= input$time_stamp[1],
             timestamp2 <= input$time_stamp[2]) })
  
  
  #-------output panel for selectInput option 1-------
  
  output$overalls <- renderPlotly({
    
    f <-  ts() %>%
      ggplot(aes(x=timestamp, y=cumul_distance,
                 group = 1,
                 text = paste(timestamp, "<br>",
                              round(cumul_distance,2), " miles", sep="" ))) +
      geom_line(col = 'darkorange') +
      labs(y = "Miles", x="Date Range") +
      ggtitle("Cumulative Driving Mileage to Date") +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5))
      tooltip = c("text", "num")

    ggplotly(f, tooltip = c("text", "num"))
    
  })
  
  
  #-------output panel for selectInput option 2-------
  
  # output$animals <- renderPlot({
  #   
  #   # ggplot(anm[anm$State == input$state,], aes(x="", y=Animals, fill = Animals)) +
  #   #   geom_bar(stat="identity", width=1) +
  #   #   coord_polar("y", start=0)
  #   
  #   
  # })
  
  
  #-------output panel for selectInput option 3-------
  #
  #
  #
  
  
  
  #sets the stage of the map
  output$location <- renderLeaflet({   
    leaflet() %>% 
      addTiles(options = providerTileOptions(maxZoom = 10)) %>%
      addProviderTiles("Esri.WorldStreetMap",
                       group = "Esri.WorldStreetMap",
                       options = providerTileOptions(maxZoom = 10)) %>%
      addProviderTiles("Esri.WorldImagery",
                       group = "Esri.WorldImagery",
                       options = providerTileOptions(maxZoom = 10)) %>% 
      # addProviderTiles("Stamen.Watercolor") %>%
      # addTiles(urlTemplate = "https://tiles.stadiamaps.com/tiles/{variant}/{z}/{x}/{y}{r}.jpg?api_key={apikey}",
      #          options = tileOptions(variant='stamen_watercolor',
      #                                apikey = 'c7e2e9c9-c998-409b-902b-b92a519d866e')) %>%
      setView( lng = -98.5816684
               , lat = 45.8283459
               , zoom = 3.5) %>% 
      addLayersControl(
        baseGroups = c("OpenStreetMap", "Esri.WorldStreetMap", "Esri.WorldImagery"),
        options = layersControlOptions(maxZoom = 10),
        position = "topleft")
  })
  


  observe({       

    
    if (input$linestring == T){   # -- display route as linestring rather than points
      
      stringy <- reactive({  # ---- one solid travel route line that ignores the flight portion of hawaii ----
        
        routeline1 <- tripdata1 %>%
          filter(timestamp2 >= input$time_stamp[1],
                 timestamp2 <= input$time_stamp[2]) %>%
          select(geometry) %>%
          st_combine() %>%
          st_cast("LINESTRING")
        
        routeline2 <- tripdata2 %>%
          filter(timestamp2 >= input$time_stamp[1],
                 timestamp2 <= input$time_stamp[2]) %>%
          select(geometry) %>%
          st_combine() %>%
          st_cast("LINESTRING")
        
        routeline3 <- tripdata3 %>%
          filter(timestamp2 >= input$time_stamp[1],
                 timestamp2 <= input$time_stamp[2]) %>%
          select(geometry) %>%
          st_combine() %>%
          st_cast("LINESTRING") 
        
        st_sfc(routeline1[[1]], routeline2[[1]], routeline3[[1]]) %>% st_combine()
        
        })
      
        
    leafletProxy("location", data = stringy()) %>%
      clearShapes() %>%
      clearMarkers() %>% 
      addPolylines(color = "purple", opacity = .75)
    }
    
    if (input$linestring == F){   # -- DEFAULT: circle markers

    leafletProxy("location", data = ts()) %>%
      clearShapes() %>% 
      clearMarkers() %>%
      addCircleMarkers(lng = ~lng,
                 lat = ~lat,
                 popup = ~as.character(paste0('<br><strong>Date and Time: (local)</strong> ', timestamp_local,
                                              '<br><strong>Cumulative Distance</strong> ', round(cumul_distance,3), ' miles')),
                 color = 'darkgreen', radius = 5,
                 opacity = .9, weight = 1.5,
                 fillColor = "gold", fillOpacity = .9
                 )
      
    }
  })
  
  
  
  
  # observe({   #this proxy controls the 'Notable Points' markers based on if the box is checked or not
  #   if (input$newpts == T){
  #     
  #     leafletProxy("location", data = ns) %>%
  #       clearMarkers() %>%
  #       addMarkers(lng = ~lng,
  #                  lat = ~lat,
  #                  popup = ~as.character(paste0(attr,
  #                                               '<br>', round(timestamp, units = 'days') ) )
  #                  )
  #   }
  #   
  #   if (input$newpts == F){
  #     
  #     leafletProxy("location", data = ns) %>%
  #       clearMarkers()
  #   }
  #   
  # })
  
  
})







