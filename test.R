library(shiny)

ui <- fluidPage(
        tagList(
        tags$html(
                tags$head(
                        tags$title("html page in shiny")
                ),
                tags$body(h1('H1'),
                          p("writing a paragraph"),
                          tags$ul(
                                  tags$li("a list"),
                                  tags$li("another one"),
                                  tags$li("a nested list will live here",
                                          tags$ol(
                                                  tags$li("nested list")
                                          )
                                  ))
                )
        )
)
)


server <- function(input, output) {
}

shinyApp(ui, server)
