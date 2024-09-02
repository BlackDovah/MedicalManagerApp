function(input, output, session) {
        con <- dbConnect(RMariaDB::MariaDB(), group = "credentials")
        credentials = loginServer(
                id = "login",
                data = dbGetQuery(con, "select * from credentials"),
                user_col = user,
                pwd_col = password,
                sodium_hashed = TRUE,
        )
        
        # UI
        
        observe({
                req(credentials()$user)
                removeUI(selector = "#LoginTab")
                removeUI(selector = "#CreateAccountTab")
                removeUI(selector = "#Selector")
                output$main_ui = renderUI({
                        fluidPage(theme = shinythemes::shinytheme("united"),
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
                                             tabPanel("Edit Personal Details",
                                                      sidebarPanel(
                                                              tags$h3("Personal information:"),
                                                              textInput("Name", "Name:"),
                                                              textInput("Gender", "Gender:"),
                                                              textInput("BloodType", "Blood Type:")
                                                      )
                                                      
                                             ),
                                             tabPanel("Show Credentials",
                                                      checkboxInput("credentials", "check to show credentials"),
                                                      tableOutput("cred")
                                             )
                                  )
                        )
                }) # Output
        }) # Observe
        
        # End of UI
        
        output$Name = renderText({
                input$Name
        })
        output$Gender = renderText({
                input$Gender
        })
        output$BloodType = renderText({
                input$BloodType
        })
        observeEvent(input$credentials,if(input$credentials == FALSE){
                output$cred = renderText({""})
        } else{
                output$cred = renderTable({dbReadTable(con, "credentials")
                })
        })
        observeEvent(input$create_account, {
                if(input$new_user %in% dbGetQuery(con, "select * from credentials")$user) {
                        output$Email_availability = renderText({"This email already exists"})
                } else {
                        hashed_password = password_store(input$new_password)
                        dbExecute(con, "INSERT INTO credentials (user, password) VALUES (?, ?)", 
                                  params = list(input$new_user, hashed_password))
                        session$sendCustomMessage(type = 'reload', message = list())
                }
        })
        # observe({
        #         session$sendCustomMessage(type = 'checkReload', message = list())
        # })
        # observeEvent(input$show_reload_message, {
        #         shinyjs::html("reload_message", "Account created successfully, please login")
        # })
        session$onSessionEnded(function() {
                dbDisconnect(con)
        })
}