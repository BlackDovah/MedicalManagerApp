library(shiny)
library(shinyjs)
library(shinythemes)
library(RMariaDB)
library(DBI)
library(sodium)
library(leaflet)
library(RSQLite)

options(shiny.reactlog = TRUE)
shiny::reactiveConsole(TRUE)


#  main_ui ###################################################################################

main_ui = fluidPage(theme = shinythemes::shinytheme("united"),
                    tags$style(HTML("
  #settings_button {
    position: absolute;
    top: 20px;
    right: 20px;
    background-color: transparent;
    border: none;
    color: grey;
  }
  #settings_button i {
    font-size: 16px;
  }
")),
                    actionButton("settings_button", label = NULL, icon = icon("cog")),
                    navbarPage("",
                               id = "Main_Page",
                               tabPanel("Medical Profile",
                                        mainPanel(
                                                tags$h3("Personal information"),
                                                div(style = "display: flex; align-items: center;",
                                                    h4("Name:", style = "margin-right: 10px;"),
                                                    textOutput("Name")
                                                ),
                                                div(style = "display: flex; align-items: center;",
                                                    h4("Gender: ", style = "margin-right: 10px;"),
                                                    textOutput("Gender")
                                                ),
                                                div(style = "display: flex; align-items: center;",
                                                    h4("Blood Type: ", style = "margin-right: 10px;"),
                                                    textOutput("BloodType")
                                                )
                                        ),
                                        
                               ),
                               tabPanel("Diagnosis history", "This panel is intentionally left blank"),
                               tabPanel("Lab analysis history", "This panel is intentionally left blank"),
                               tabPanel("Medication", "This panel is intentionally left blank"),
                               tabPanel("Medical Providers",
                                        leafletOutput("providers_map", height = 400)),
                               # tabPanel("Show Credentials",
                               #          checkboxInput("credentials", "check to show credentials"),
                               #          tableOutput("cred")
                               # )
                    )
)

################################################################################################
