# # div(id = "reload_message", style = "color: red; font-weight: bold;"),
# titlePanel("Welcome to MedHub!"),
#           div(id = "Selector",
#               selectInput("Login_Signup",
#                           "Please login, or create an account",
#                           c(Login = "Login", 'Create Account' = "Create Account")
#               )
#           ),
#           conditionalPanel(condition = "input.Login_Signup == 'Login'",
#                            div(id = "LoginTab",
#                                tabPanel("Login page",
#                                         # loginUI(id = "login")
#                                         sidebarPanel("Welcome to your comprehensive medical reference."),
#                                         mainPanel(
#                                                 textInput("email", "Email"),
#                                                 passwordInput("password", "Password"),
#                                                 textOutput("account_exists"),
#                                                 actionButton("logi_but", "Login"),
#                                         )
#                                )
#                            )
#           ),
# 
# 
#           conditionalPanel(condition = "input.Login_Signup == 'Create Account'",
#                            div(id = "CreateAccountTab",
#                                tabPanel("Account creation",
#                                         sidebarPanel("Welcome to your comprehensive medical reference."),
#                                         mainPanel(
#                                                 textInput("new_user", "Email"),
#                                                 passwordInput("new_password", "Password"),
#                                                 selectInput("Account_type",
#                                                             "Please select an account type",
#                                                             c("Patient" = "Patient",
#                                                               "Physician" = "Physician",
#                                                               "Medical Laboratory" = "Medical Laboratory"),
#                                                 ),
#                                                 actionButton("create_account", "Create Account"),
#                                                 verbatimTextOutput("creation_status"),
#                                                 textOutput("Email_availability"),
#                                                 textOutput("type")
#                                         )
#                                )
#                            )
#           ),
#           uiOutput("main_ui"),
# ))

# server = function(input, output, session) {
#         # con <- dbConnect(RMariaDB::MariaDB(), group = "credentials")
#         con = dbConnect(RSQLite::SQLite(), "Users.sqlite")
#         
#         ## UI/Login
#         
#         observeEvent(input$logi_but, {
#                 
#                 ## Credentials check
#                 
#                 pass_status = FALSE
#                 email = input$email
#                 password = input$password
#                 
#                 if(email %in% dbGetQuery(con, "select * from credentials")$user && 
#                    password_verify(dbGetQuery(con, "select * from credentials where user = ?", 
#                                               params = email)$password, password)
#                 ) {pass_status = TRUE} 
#                 
#                 ## Render UI if user and pass are correct
#                 
#                 if(pass_status == TRUE){
#                         removeUI(selector = "#sign")
#                         # removeUI(selector = "#LoginTab")
#                         # removeUI(selector = "#CreateAccountTab")
#                         # removeUI(selector = "#Selector")
#                         output$main_ui = renderUI({
#                                 main_ui
#                         }) # Output
#                 } else {output$account_exists = 
#                         renderText("Your email or password is incorrect")}
#         }) # Observe
#         
#         ### End of UI/Login
#         
#         ## Main page logic
#         
#         output$Name = renderText({
#                 input$Name
#         })
#         output$Gender = renderText({
#                 input$Gender
#         })
#         output$BloodType = renderText({
#                 input$BloodType
#         })
#         observeEvent(input$credentials,if(input$credentials == FALSE){
#                 output$cred = renderText({""})
#         } else{
#                 output$cred = renderTable({dbReadTable(con, "credentials")
#                 })
#         })
#         
#         ### End of main page logic
#         
#         ## Account creation logic
#         
#         observeEvent(input$create_account, {
#                 if(input$new_user %in% dbGetQuery(con, "select * from credentials")$user) {
#                         output$Email_availability = renderText({"This email already exists"})
#                 } else {
#                         hashed_password = password_store(input$new_password)
#                         type = 0
#                         if(input$Account_type == "Patient") {
#                                 type = 0
#                         } else if(input$Account_type == "Physician") {
#                                 type = 1
#                         } else if(input$Account_type == "Medical Laboratory") {
#                                 type = 2
#                         }
#                         # output$type = renderText({type})
#                         dbExecute(con, "INSERT INTO credentials (user, password,type) VALUES (?, ?, ?)",
#                                   params = list(input$new_user, hashed_password, type))
#                         session$sendCustomMessage(type = 'reload', message = list())
#                 }
#         })
#         
#         ### End of account creation logic
#         
#         # observe({
#         #         session$sendCustomMessage(type = 'checkReload', message = list())
#         # })
#         # observeEvent(input$show_reload_message, {
#         #         shinyjs::html("reload_message", "Account created successfully, please login")
#         # })
#         
#         ## Settings button UI
#         
#         observeEvent(input$settings_button, {
#                 showModal(modalDialog(
#                         title = "Settings",
#                         tabsetPanel(
#                                 tabPanel("Edit Personal Details",
#                                          tags$h3("Personal information:"),
#                                          textInput("Name", "Name:"),
#                                          textInput("Gender", "Gender:"),
#                                          textInput("BloodType", "Blood Type:")
#                                 )
#                                 
#                         ), # tabsetPanel
#                         easyClose = TRUE,
#                         footer = tagList(
#                                 modalButton("Close"),
#                                 actionButton("save_settings", "Save Settings")
#                         ) # tagList
#                 ) # modalDialog
#                 ) # showModal
#         }) # observeEvent
#         
#         ### End of settings button UI
#         
#         ## ProvidersMap
#         
#         output$providers_map <- renderLeaflet({
#                 leaflet() %>%
#                         addTiles() %>%  # Default OpenStreetMap tiles
#                         setView(lng = -122.4194, lat = 37.7749, zoom = 10)  # Center the map on San Francisco
#         }) # renderLeaflet
#         
#         ### End of ProvidersMap
#         
#         ## Disconnect from db
#         
#         session$onSessionEnded(function() {
#                 dbDisconnect(con)
#         })
# }