#' @export mse
mse = function(out){
  sum(( unlist(out[,1])-unlist(out[,2]) )^2)/nrow(out)
}
