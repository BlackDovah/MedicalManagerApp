tagList(
        tags$head(tags$script(HTML("
    Shiny.addCustomMessageHandler('reload', function(message) {
      location.reload();
    });
    Shiny.addCustomMessageHandler('checkReload', function(message) {
      if (localStorage.getItem('reloaded') === 'true') {
        Shiny.setInputValue('show_reload_message', true, {priority: 'event'});
        localStorage.removeItem('reloaded');
      }
    });
  "))),
        fluidPage(theme = shinythemes::shinytheme("simplex"),
                  # div(id = "reload_message", style = "color: red; font-weight: bold;"),
                  titlePanel("Welcome to MedHub!"),
                  div(id = "sign",
                      navbarPage("", 
                                 id = "signIn/Up",
                                 tabPanel("Login",
                                          sidebarPanel("Welcome to your comprehensive medical reference."),
                                          mainPanel(
                                                  textInput("email", "Email"),
                                                  passwordInput("password", "Password"),
                                                  textOutput("account_exists"),
                                                  actionButton("logi_but", "Login"),
                                          ) # mainPanel
                                          # )
                                          # )
                                 ), # tabPanel-login
                                 
                                 tabPanel("Create Account",
                                          sidebarPanel("Welcome to your comprehensive medical reference."),
                                          mainPanel(
                                                  textInput("new_user", "Email"),
                                                  passwordInput("new_password", "Password"),
                                                  selectInput("Account_type",
                                                              "Please select an account type",
                                                              c("Patient" = "Patient",
                                                                "Physician" = "Physician",
                                                                "Medical Laboratory" = "Medical Laboratory"),
                                                  ),
                                                  actionButton("create_account", "Create Account"),
                                                  verbatimTextOutput("creation_status"),
                                                  textOutput("Email_availability"),
                                                  textOutput("type")
                                          )
                                          # )
                                          # )
                                 ) # tabPanel-account
                      )), # nav
                  uiOutput("main_ui"),
        ))