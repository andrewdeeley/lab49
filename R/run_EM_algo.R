#' @export run_EM_algo
run_EM_algo = function(lsData){
  ### transpose data
  dt_train_t = t(lsData$scaled_train_data)
  ### number of variables
  N = 6
  ### number of latent variables
  N1 = 3
  ### set Zmatrix
  Z1.vals = list(
    "z11", 0 , 0 ,
    "z21","z22", 0 ,
    "z31","z32","z33",
    "z41","z42","z43",
    "z51","z52","z53",
    "z61","z62","z63")
  Z1 = matrix(Z1.vals, nrow=N, ncol=N1, byrow=TRUE)
  ### set Q and B matrix
  Q1 = B1 = diag(1,N1)
  ### set R matrix
  R1.vals = list(
    "r11",0,0,0,0,0,
    0,"r22",0,0,0,0,
    0,0,"r33",0,0,0,
    0,0,0,"r44",0,0,
    0,0,0,0,"r55",0,
    0,0,0,0,0,"r66")
  R1 = matrix(R1.vals, nrow=N, ncol=N, byrow=TRUE)
  ### set x) and U matrix
  x01 = U1 = matrix(0, nrow=N1, ncol=1)
  ### set A1 matrix
  A1 = matrix(0, nrow=N, ncol=1)
  V01 = diag(N,N1)
  dfa.model1 = list(Z=Z1, A=A1, R=R1, B=B1, U=U1, Q=Q1, x0=x01, V0=V01)
  cntl.list = list(maxit=1000)
  em1 = MARSS::MARSS(dt_train_t, model=dfa.model1, control=cntl.list)
  rownames(em1$ytT) = rownames(dt_train_t)
  ### reverse normalise return data
  em1$Returns = (em1$ytT['Returns_norm',]*lsData$sigma['Returns']) + lsData$mu['Returns']
  em1$last_returns = last(  (em1$ytT['Returns_norm',]*lsData$sigma['Returns']) + lsData$mu['Returns'])
  em1
}
