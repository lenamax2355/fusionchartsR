#' List of available charts in fusionchartsR
#'   
#' @examples
#' library(fusionchartsR)
#' available_charts()
#'
#' @export
available_charts <- function () {
  list1 <- c("column2d","column3d","line","area2d","bar2d","bar3d","pie2d","pie3d","doughnut2d", "doughnut3d","pareto2d","funnel", "boxandwhisker2d", "confusionMatrix")
  list2 <- c("mscolumn2d","stackedcolumn2d","mscolumn3d","stackedcolumn3d","msline","mssplinearea","msbar2d","stackedbar2d","msbar3d","stackedbar3d","overlappedcolumn2d","msstepline")
  df.list <- list(list1, list2)
  names(df.list) <- c("Charts with empty col argument", "Charts using col argument")
  return(df.list)
}

