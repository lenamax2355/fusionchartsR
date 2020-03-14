#' Create new charts
#'
#' Main function to make interactive charts
#'
#' @import htmlwidgets
#' @import jsonlite
#'
#' @param data Default dataset to use
#' @param type Chart type. Available charts can be found at \url{https://www.fusioncharts.com/dev/chart-guide/list-of-charts}
#' @param width,height Size of the chart. Must be a valid CSS unit (like \code{'100\%'}, \code{'400px'}, \code{'600'})
#' @param numberSuffix Specify the suffix for all the Y-axis values on the chart
#' @param exportEnabled Enable chart exporting
#' 
#'
#' @export
fusionPlot <- function(data, type = "column2d", width = "100%", height = "100%", numberSuffix = NULL, exportEnabled = FALSE) {
  
  singleSeriesChart <- c("column2d", "column3d", "line", "area2d", "bar2d", "bar3d", "pie2d", "pie3d", "doughnut2d", "doughnut3d")
  
  if(is.null(data)){
    stop("Provide non empty data")
  }
  
  if(type %in% singleSeriesChart){
    data <- jsonlite::toJSON(x = data, pretty = TRUE)
  } 
  else {
    stop('Please select one of the following chartType: "column2d", "column3d", "line", "area2d", "bar2d", "bar3d", "pie2d", "pie3d", "doughnut2d", "doughnut3d"')
  }
  
#' @examples
#' library(fusionchartsR)
#' 
#'  df <- data.frame(label = c("Venezuela", "Saudi", "Canada", "Russia"), value = c(290, 260,180, 115))
#' fusionPlot(data = df, type = 'pie2d') %>%
#'  fusionCaption() %>%
#'    fusionSubcaption() %>%
#'    fusionBackground() %>%
#'    fusionCanvas() %>%
#'    fusionAxis() %>%
#'    fusionCustomAxis() %>%
#'    fusionLegend() %>%
#'    fusionCustomLegend() %>%
#'    fusionPalette() %>%
#'    fusionAnchors() %>%
#'    fusionTrendline() %>%
#'    fusionDiv() %>%
#'    fusionTooltip() %>%
#'    fusionLogo()
#'   

  if(isTRUE(grepl("px", height))){
    height <- strsplit(x = height, split = "px")[[1]]
  }
  else {
    height <- height
  }
  
  if(isTRUE(grepl("px", width))){
    width <- strsplit(x = width, split = "px")[[1]]
  }
  else {
    width <- width
  }
  
  # forward options using x
  x = list(
    data = data,
    type = type,
    width = width,
    height = height,
    numberSuffix = numberSuffix,
    exportEnabled = as.numeric(exportEnabled)
    )

  # create widget
  widgets <- htmlwidgets::createWidget(
    name = 'fusionPlot',
    x = x,
    width = NULL,
    height = NULL,
    package = 'fusionchartsR',
    elementId = NULL
  )
  
  widgets %>%
  fusionCaption() %>%
    fusionSubcaption() %>%
    fusionBackground() %>%
    fusionCanvas() %>%
    fusionAxis() %>%
    fusionCustomAxis() %>%
    fusionLegend() %>%
    fusionCustomLegend() %>%
    fusionPalette() %>%
    fusionAnchors() %>%
    fusionTrendline() %>%
    fusionDiv() %>%
    fusionTooltip() %>%
    fusionLogo() %>%
    fusionTheme()
  
}


#' Shiny bindings for fusionPlot
#'
#' Output and render functions for using fusionPlot within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a fusionPlot
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'   
#' @name fusionPlotOutput
#' @aliases renderfusionPlot
#'
#' @export
fusionPlotOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'fusionPlot', width, height, package = 'fusionchartsR')
}

#' @rdname fusionPlotOutput
#' @export
renderfusionPlot <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, fusionPlotOutput, env, quoted = TRUE)
}