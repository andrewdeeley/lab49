#' @export scale_training_data

scale_training_data = function(dt_train){
  out = list()
  sigma = sqrt(apply(dt_train, 2, var, na.rm=TRUE))
  mu = apply(dt_train, 2, mean, na.rm=TRUE)
  dt_train[, Returns_norm := scale(Returns, center = TRUE, scale = TRUE)]
  dt_train[, FCF.Yield_norm := scale(FCF.Yield, center = TRUE, scale = TRUE)]
  dt_train[, Momentum_norm := scale(Momentum, center = TRUE, scale = TRUE)]
  dt_train[,tp:=shift(EPS.Revision,type = 'lag')]
  dt_train[,tp1:= EPS.Revision - tp]
  dt_train[, EPS.Revision_norm := scale(tp1, center = TRUE, scale = TRUE)]
  dt_train[,tp:=NULL]
  dt_train[,tp1:=NULL]
  dt_train[, sg1y_norm := scale(sg1y, center = TRUE, scale = TRUE)]
  dt_train[, sg5y_norm := scale(sg5y, center = TRUE, scale = TRUE)]
  out$raw_train_data = copy(dt_train[,1:6])
  out$scaled_train_data=copy(dt_train[,7:12])
  out$sigma = sigma
  out$mu = mu
  out
}
