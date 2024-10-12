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
    });"
        ))),

        tags$link(rel='stylesheet', type='text/css', href='style.css'),
        fluidPage(theme = shinythemes::shinytheme("cerulean"),
                  div(id = "reload_message", style = "color: red; font-weight: bold;"),
                  div(id = "title",
                      style = "display: inline-block; vertical-align: middle;",
                      h1("MedHub", style = "font-size: 200%; display: inline;"),
                  img(src = "image.png",
                      width = 100, hight = 100)),
                  
                  div(id = "sign",
                      navbarPage("", 
                                 id = "signIn/Up",
                                 tabPanel("Login",
                                          div(id = "login", style = "margin-left: 110px;",
                                              mainPanel(
                                                      textInput("email", "Email"),
                                                      passwordInput("password", "Password"),
                                                      textOutput("account_exists"),
                                                      tags$a(id = "login_but",
                                                          actionButton("logi_but", "Login")),
                                              ) # mainPanel
                                          ) # div
                                          
                                 ), # tabPanel-login
                                 
                                 tabPanel("Create Account",
                                          div(id = "create", style = "margin-left: 110px;",
                                              mainPanel(
                                                      textInput("new_user", "Email"),
                                                      passwordInput("new_password", "Password"),
                                                      selectInput("Account_type",
                                                                  "Please select an account type",
                                                                  c("Patient" = "Patient",
                                                                    "Physician" = "Physician",
                                                                    "Medical Laboratory" = "Medical Laboratory"),
                                                      ),
                                                      tags$a(id = "create_but",
                                                          actionButton("create_account", "Create Account")),
                                                      verbatimTextOutput("creation_status"),
                                                      textOutput("Email_availability"),
                                                      textOutput("type")
                                              ) # mainPanel
                                          ) # div
                                 ) # tabPanel-account
                      )), # nav
                  uiOutput("main_ui"),
        ))