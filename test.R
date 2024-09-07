library(shiny)
library(leaflet)

ui <- fluidPage(
        # Inline CSS to style the settings button and icon color
        tags$style(HTML("
    #settings_button {
      position: absolute;
      top: 20px;
      right: 20px;
      background-color: #4CAF50;  /* Green background color */
      border: none;
      padding: 10px;
      border-radius: 50%;  /* Make it circular */
      color: white;        /* Set icon color to white */
    }
    #settings_button i {
      font-size: 24px;
    }
    #settings_button:hover {
      background-color: #45a049; /* Darker green when hovered */
    }
  ")),
        
        # Application title
        titlePanel("Shiny App with Leaflet Map in Settings Modal"),
        
        # Settings icon as an action button
        actionButton("settings_button", label = NULL, icon = icon("cog")),
        
        # Placeholder for the rest of the app content
        mainPanel(
                h3("App Content Here")
        )
)

server <- function(input, output, session) {
        # Show modal dialog with tabs when settings button is clicked
        observeEvent(input$settings_button, {
                showModal(modalDialog(
                        title = "Settings",
                        
                        # Tabset panel inside the modal
                        tabsetPanel(
                                tabPanel("General Settings",
                                         checkboxInput("setting1", "Enable Feature 1", value = TRUE),
                                         sliderInput("setting2", "Adjust Feature 2", min = 0, max = 100, value = 50)
                                ),
                                tabPanel("Map",
                                         h3("Interactive Map"),
                                         leafletOutput("mymap", height = 400)  # Adding leaflet map output
                                ),
                                tabPanel("About",
                                         h3("About This Application"),
                                         p("This is a sample Shiny app with a settings modal and tabs.")
                                )
                        ),
                        
                        easyClose = TRUE,
                        footer = tagList(
                                modalButton("Close"),
                                actionButton("save_settings", "Save Settings")
                        )
                ))
        })
        
        # Render the Leaflet map
        output$mymap <- renderLeaflet({
                leaflet() %>%
                        addTiles() %>%  # Default OpenStreetMap tiles
                        setView(lng = -122.4194, lat = 37.7749, zoom = 10)  # Center the map on San Francisco
        })
}

# Run the application 
shinyApp(ui = ui, server = server)
