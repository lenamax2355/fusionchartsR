#' Fusioncharts Demo
#'
#' Running Shiny App 
#'
#' @import htmlwidgets
#'
#' 
#' @examples
#' library(fusionchartsR)
#' library(shiny)
#' runDemo()
#'
#' @export
runDemo <- function(){
  ui <- fluidPage(
    tags$br(),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "input01", 
          label = "Select a type chart", 
          choices = c("column2d","column3d", "line", "area2d", "bar2d", "bar3d", 
                      "pie2d", "pie3d", "doughnut2d", "doughnut3d")
        ),
        textInput(
          inputId = "input02", 
          label = "Change the caption title", 
          value = "Caption"
        ),
        textInput(
          inputId = "input03", 
          label = "Change the subcaption title", 
          value = "Subcaption"
        ),
        textInput(
          inputId = "input04", 
          label = "Change the X-axis title", 
          value = "X-axis"
        ),
        textInput(
          inputId = "input05", 
          label = "Change the Y-axis title", 
          value = "Y-axis"
        ),
        selectInput(
          inputId = "input06", 
          label = "Choose a theme",  
          choices = c("fusion", "gammel", "candy", "zune", "ocean", 
                      "carbon", "umber")
        )
      ),
      mainPanel(
        fusionPlotOutput(outputId = "plot", width = "100%", height = "500px")
      )
    )
  )
  
  server <- function(input, output, session){
    output$plot <- renderfusionPlot({
      df <- data.frame(label = c("Venezuela", "Saudi", "Canada", "Russia"), value = c(290, 260,180, 115))
      fusionPlot(data = df, type = input$input01) %>%
        fusionCaption(caption = input$input02) %>%
        fusionSubcaption(subcaption = input$input03) %>%
        fusionAxis(xAxisName = input$input04, yAxisName = input$input05) %>%
        fusionTheme(theme = input$input06)
    })
  }
  
  shinyApp(ui = ui, server = server)
}