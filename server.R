function(input, output, session) {
        con <- dbConnect(RMariaDB::MariaDB(), group = "credentials")
        credentials = loginServer(
                id = "login",
                data = dbGetQuery(con, "select * from credentials"),
                user_col = user,
                pwd_col = password,
                sodium_hashed = TRUE,
        ) # credentials
        
        ## UI
        
        observe({
                req(credentials()$user)
                removeUI(selector = "#LoginTab")
                removeUI(selector = "#CreateAccountTab")
                removeUI(selector = "#Selector")
                output$main_ui = renderUI({
                        main_ui
                }) # Output
        }) # Observe
        
        ### End of UI
        
        ## Main page logic
        
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
        
        ### End of main page logic
        
        ## Account creation logic
        
        observeEvent(input$create_account, {
                if(input$new_user %in% dbGetQuery(con, "select * from credentials")$user) {
                        output$Email_availability = renderText({"This email already exists"})
                } else {
                        hashed_password = password_store(input$new_password)
                        type = 0
                        if(input$Account_type == "Patient") {
                                type = 0
                        } else if(input$Account_type == "Physician") {
                                type = 1
                        } else if(input$Account_type == "Medical Laboratory") {
                                type = 2
                        }
                        # output$type = renderText({type})
                        dbExecute(con, "INSERT INTO credentials (user, password,type) VALUES (?, ?, ?)",
                                  params = list(input$new_user, hashed_password, type))
                        session$sendCustomMessage(type = 'reload', message = list())
                }
        })
        
        ### End of account creation logic
        
        # observe({
        #         session$sendCustomMessage(type = 'checkReload', message = list())
        # })
        # observeEvent(input$show_reload_message, {
        #         shinyjs::html("reload_message", "Account created successfully, please login")
        # })
        
        ## Settings button UI
        
        observeEvent(input$settings_button, {
                showModal(modalDialog(
                        title = "Settings",
                        tabsetPanel(
                                tabPanel("Edit Personal Details",
                                         tags$h3("Personal information:"),
                                         textInput("Name", "Name:"),
                                         textInput("Gender", "Gender:"),
                                         textInput("BloodType", "Blood Type:")
                                )
                                
                        ), # tabsetPanel
                        easyClose = TRUE,
                        footer = tagList(
                                modalButton("Close"),
                                actionButton("save_settings", "Save Settings")
                        ) # tagList
                ) # modalDialog
                ) # showModal
        }) # observeEvent
        
        ### End of settings button UI
        
        ## ProvidersMap
        
        output$providers_map <- renderLeaflet({
                leaflet() %>%
                        addTiles() %>%  # Default OpenStreetMap tiles
                        setView(lng = -122.4194, lat = 37.7749, zoom = 10)  # Center the map on San Francisco
        }) # renderLeaglet
        
        ### End of ProvidersMap
        
        ## Disconnect from db
        
        session$onSessionEnded(function() {
                dbDisconnect(con)
        })
}