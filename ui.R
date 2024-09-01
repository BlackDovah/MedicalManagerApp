tagList(
        tags$head(tags$script(HTML("
    Shiny.addCustomMessageHandler('reload', function(message) {
      location.reload();
    });
    # Shiny.addCustomMessageHandler('checkReload', function(message) {
    #   if (localStorage.getItem('reloaded') === 'true') {
    #     Shiny.setInputValue('show_reload_message', true, {priority: 'event'});
    #     localStorage.removeItem('reloaded');
    #   }
    # });
  "))),
        fluidPage(theme = shinythemes::shinytheme("united"),
                  # div(id = "reload_message", style = "color: red; font-weight: bold;"),
                  titlePanel("Welcome to MedHub!"),
                  div(id = "Selector",
                      selectInput("Login_Signup",
                                  "Please login, or create an account",
                                  c(Login = "Login", 'Create Account' = "Create Account")
                      )
                  ),
                  conditionalPanel(condition = "input.Login_Signup == 'Login'",
                                   div(id = "LoginTab",
                                       tabPanel("Login page",
                                                loginUI(id = "login")
                                       )
                                   )
                  ),
                  
                  
                  conditionalPanel(condition = "input.Login_Signup == 'Create Account'",
                                   div(id = "CreateAccountTab",
                                       tabPanel("Account creation",
                                                sidebarPanel("Welcome to your comprehensive medical reference."),
                                                mainPanel(
                                                        textInput("new_user", "Email"),
                                                        passwordInput("new_password", "Password"),
                                                        actionButton("create_account", "Create Account"),
                                                        verbatimTextOutput("creation_status"),
                                                        textOutput("Email_availability")
                                                )
                                       )
                                   )
                  ),
                  uiOutput("main_ui"),
        ))