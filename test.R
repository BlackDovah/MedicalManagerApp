library(shiny)
library(shinyjs)

ui <- tagList(
        useShinyjs(),
        tags$head(tags$script(HTML("
    Shiny.addCustomMessageHandler('reload', function(message) {
      localStorage.setItem('reloaded', 'true');
      location.reload();
    });

    Shiny.addCustomMessageHandler('checkReload', function(message) {
      if (localStorage.getItem('reloaded') === 'true') {
        Shiny.setInputValue('show_reload_message', true, {priority: 'event'});
        localStorage.removeItem('reloaded');
      }
    });
  "))),
        fluidPage(
                titlePanel("Reload Message Example"),
                sidebarLayout(
                        sidebarPanel(
                                actionButton("reload_btn", "Reload Session")
                        ),
                        mainPanel(
                                div(id = "reload_message", style = "color: red; font-weight: bold;")
                        )
                )
        )
)

server <- function(input, output, session) {
        output$text <- renderText({
                paste("The time is:", Sys.time())
        })
        
        observeEvent(input$reload_btn, {
                session$sendCustomMessage(type = 'reload', message = list())
        })
        
        observe({
                session$sendCustomMessage(type = 'checkReload', message = list())
        })
        
        observeEvent(input$show_reload_message, {
                shinyjs::html("reload_message", "The app has been reloaded.")
        })
}

shinyApp(ui, server)