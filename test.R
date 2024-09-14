library(shiny)
library(shinydashboard)
library(mailR) 
ui <- dashboardPage(
        header = dashboardHeader(title = "head"),
        sidebar = dashboardSidebar("hello"),
        body = fluidRow(
                column(3, wellPanel(
                        textInput("email", "Email"),
                        actionButton("submitResetBtn","Request Password Reset")))),
        br() 
)
footer = dashboardFooter()



server <- function(input, output) {
        observeEvent(input$submitResetBtn,{
                send_mass_mail("admin@example.com", 
                               recipients = input$email %>% unique()) 
        })
}

shinyApp(ui, server)
