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

main_ui = fluidPage(theme = shinythemes::shinytheme("cerulean"),
                    tags$link(rel='stylesheet', type='text/css', href='style.css'),
                    actionButton("settings_button", label = NULL, icon = icon("cog")),
                    div(id = "main",
                        navbarPage("",
                                   id = "Main_Page",
                                   tabPanel("Medical Profile",
                                            mainPanel(
                                                    h3("Personal information"),
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
                                            leafletOutput("providers_map", height = 800)),
                                   # tabPanel("Show Credentials",
                                   #          checkboxInput("credentials", "check to show credentials"),
                                   #          tableOutput("cred")
                                   # )
                        ))
)

################################################################################################
