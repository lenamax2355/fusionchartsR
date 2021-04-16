#' Create new charts
#'
#' Main function to make interactive charts.
#' Check all charts at \url{https://www.fusioncharts.com/charts}
#'
#'
#' @import htmlwidgets
#' @import jsonlite
#' @importFrom caret confusionMatrix
#'
#'
#' @param data Default dataset to use
#' @param x,y character name of variable
#' @param col character name of color variable (only available to Multiple chart)
#' @param type See details.
#' @param width,height Size of the chart. Must be a valid CSS unit (like \code{'100\%'}, \code{'400px'}, \code{'600'})
#' @param numberSuffix Specify the suffix for all the Y-axis values on the chart
#'
#'
#' @export
fusionPlot <- function(data,x, y,col = NULL, type = "column2d", numberSuffix = NULL) {

  charts <- available_charts()


  if(type %in% charts[[1]][-c(13,14)]){

    # Canceled Multiple series charts components
    drawcrossline <- "0"
    category <- NULL
    dataset <- NULL
    showmean <- "0"
    showalloutliers <- NULL
    columns <- NULL
    rows <- NULL
    colorrange <- NULL
    mapbycategory <- "0"

    new.data <- data.frame(
      label = factor(data[,x]),
      value = data[,y]
    )

    data <- toJSON(x = new.data, pretty = TRUE)

  }
  else if(type %in% charts[[2]]) {

    # Activated components
    drawcrossline <-  "1"
    showmean <- "0"
    showalloutliers <- NULL
    columns <- NULL
    rows <- NULL
    colorrange <- NULL
    mapbycategory <- "0"

    # X-axis values
    xaxis <- factor(data[,x])
    df <- list(
      category = data.frame(
        label = as.character(levels(xaxis))
      )
    )

    category <- toJSON(x = df, pretty = TRUE)

    n <- levels(factor(data[,col]))
    df.list <- lapply(1:length(n), function(x){
      list(
        seriesname = n[x],
        data = data.frame(
          value = as.character(data[data[,col] == n[x],y])
        )
      )
    })

    dataset <- toJSON(x = df.list, pretty = TRUE, auto_unbox = TRUE)

  }
  else if(type == "boxandwhisker2d"){

    showmean <- "1"
    drawcrossline <-  "0"
    columns <- NULL
    rows <- NULL
    colorrange <- NULL
    mapbycategory <- "0"

    xaxis <- factor(data[,x])

    df <- list(
      category = data.frame(
        label = as.character(levels(xaxis))
      )
    )

    category <- toJSON(x = df, pretty = TRUE)

    n <- unique(levels(xaxis))
    df.list <- lapply(1:length(n), function(i){
      yaxis <- data[data[,x] == n[i],y]
      stats <- boxplot.stats(yaxis)
      if(length(stats$out) >= 1){
        list(
          value = toString(yaxis[! yaxis %in% unique(stats$out)]),
          outliers = toString(unique(stats$out))
        )
      }
      else {
        list(
          value = toString(yaxis)
        )
      }
    })

    if(length(grep(pattern = "outliers", x = df.list)) > 0){
      showalloutliers <- 1
    }
    else {
      showalloutliers <- 0
    }

    newlist <- list(
      list(
      seriesname = y,
      data = df.list
    )
  )

    dataset <- toJSON(x = newlist, pretty = TRUE, auto_unbox = TRUE)
  }
  else if(type == "confusionMatrix"){
    
    type <- "heatmap"
    
    drawcrossline <-  "0"
    showmean <- "0"
    showalloutliers <- NULL
    category <- NULL
    mapbycategory <- "1"
    
    color <- list(
      gradient = "0",
      color = data.frame(
        code = c("#6da81e", "#e24b1a"),
        minvalue = c("0", "0"),
        maxvalue = c("Infinity", "Infinity"),
        label = c("Good", "Bad")
      )
    )
    
    colorrange <- toJSON(x = color, pretty = TRUE, auto_unbox = TRUE)
    
    column01 <- list(
      column = data.frame(
        id = c("Pos", "Neg"),
        label = c("Positive", "Negative")
      )
    )
    
    columns <- toJSON(x = column01, pretty = TRUE)
    
    row01 <- list(
      row = data.frame(
        id = c("tr","fa"),
        label = c("Positive", "Negative")
      )
    )
    
    rows <- toJSON(x = row01, pretty = TRUE)
    
    # Dataset
    truth <- data[,x]
    pred <- data[,y]
    xtab <- table(pred, truth)
    mtx <- confusionMatrix(xtab)
    
    data01 <- list(
      list(
        data = data.frame(
          rowid = c("tr","tr", "fa", "fa"),
          columnid = c("Pos", "Neg", "Pos", "Neg"),
          displayvalue = as.character(c(mtx$table[1,], mtx$table[2,])),
          colorrangelabel = c("Good", "Bad","Bad", "Good")
        )
      )
    )
    
    dataset <- toJSON(x = data01, pretty = TRUE, auto_unbox = TRUE)

  }
  else {
    stop("Please select available charts. See `available_charts()`")
  }


#' @examples
#' library(fusionchartsR)
#'
#' # Single
#' df <- data.frame(label = c("Venezuela", "Saudi", "Canada", "Russia"), value = c(290, 260,180, 115))
#' df %>%
#' fusionPlot(x = "label", y = "value", type = "pie2d") %>%
#' fusionTheme(theme = "fusion")
#'
#' # Multiple
#' new.data <- data.frame(
#' label = rep(x = c(2012:2016), times = 2),
#' seriesname = c(rep("iOS App Store", 5), rep("Google Play Store", 5)),
#' values = c(1:10)
#' )
#'
#' new.data %>%
#' fusionPlot(
#' x = "label",
#' y = "values",
#' col = "seriesname",
#' type = "mscolumn2d",
#' ) %>%
#' fusionTheme(theme = "fusion")
#'

  # forward options using x
  x <- list(
    data = data,
    categories = category,
    dataset = dataset,
    type = type,
    numberSuffix = numberSuffix,
    showmean = showmean,
    drawcrossline = drawcrossline,
    showalloutliers = showalloutliers,
    columns = columns,
    rows = rows,
    colorrange = colorrange,
    mapbycategory = mapbycategory
    )

  # create widget
  widgets <- htmlwidgets::createWidget(
    name = 'fusionPlot',
    x = x,
    package = 'fusionchartsR'
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
