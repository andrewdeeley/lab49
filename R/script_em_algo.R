#
# ##################
# ### EM algo ######
# ##################
#
# dt6b = dt6a[Ticker=='A']
# ### the sales growth number looks to be calculated once a year then filled forward, this is not correct for the EM algo,
# ### what we want is the 1 year recalculated every month
# ### will fill with NA values the fill fwds and let EM calc expected values
# dt6b[,tp3:=shift(Sales.Growth.1Y, type='lag'), by = Ticker]
# dt6b[,sg1y:=Sales.Growth.1Y]
# dt6b[,sg1y:=NA]
# dt6b[tp3!=Sales.Growth.1Y,sg1y:=Sales.Growth.1Y]
# dt6b[1,sg1y:=Sales.Growth.1Y]
#
# dt6b[,tp3:=shift(Sales.Growth.5Y, type='lag'), by = Ticker]
# dt6b[,sg5y:=Sales.Growth.5Y]
# dt6b[,sg5y:=as.numeric(NA)]
# dt6b[tp3!=Sales.Growth.5Y,sg5y:=Sales.Growth.5Y]
# dt6b[1,sg5y:=Sales.Growth.5Y]
# dt6b[,tp3:=NULL]
#
# ### 1 step ahead forecast using 84 data points to fit the EM algo
# start_pt = 85
# ### training data
# dt_train = dt6b[1:start_pt,c('Returns', 'FCF.Yield','Momentum','EPS.Revision','sg1y','sg5y')]
# ### set the last last row all to NA so that the algo produces a forecast
# dt_train[start_pt,]=NA
# ### test data
# dt_test = dt6b[(start_pt),c('Returns', 'FCF.Yield','Momentum','EPS.Revision','sg1y','sg5y')]
# ### normalise the  variables i.e z-scores (NB we are scaling the  training data without the knowledge of the test data)
# lsData = scale_training_data(dt_train)
#
# ### run the algo on the scaled data
# em2 = run_EM_algo(lsData=lsData)
# ### Fron the output you can see the algo cannot fit the defined model to the data, more work would need to be done to the input data e.g. different scaling method
# ### or transforming the data to make it wide sense stationary, or define a different model
# ### worst case the assumptions about the some factors driving the data is incorrect and the EM algo is a bad choice
#
#
# ### as the algo is given the scaling parameters, after producing the forecast it then inverses the scaling to put the forecast in the desired scale
# cbind(em2$Returns,lsData$raw_train_data$Returns)
# em2$last_returns
# dt_test$Returns
#
# ### create a loop to iterate through 1 step ahead forecasting
# start_pt = 85
# out = list()
# repeat{
#   if(start_pt>nrow(dt6b)) break
#   dt_train = dt6b[1:start_pt,c('Returns', 'FCF.Yield','Momentum','EPS.Revision','sg1y','sg5y')]
#   dt_train[start_pt,]=NA
#   dt_test = dt6b[(start_pt),c('Returns', 'FCF.Yield','Momentum','EPS.Revision','sg1y','sg5y')]
#   ### normalise the  variables i.e z-scores
#   lsData = scale_training_data(dt_train)
#   em2 = run_EM_algo(lsData=lsData)
#   out = rbind(out,c(dt_test$Returns,em2$last_returns)  )
#   start_pt =start_pt +1
#   print(out)
# }
#
#
# mse(out)
# ### the mean square error for this model and test data is 47.67702
#
# ### one of the advantages of the EM algo is that if some of the monthly data was released before the end of the month
# ### or if another model could forecast any of these variables then the EM algo provides a method to transfer this information onto the Returns vector and
# ### improve the its forecast accuracy
#
# ### e.g. lets assume we have a suite of different models that accurately forecast FCF.Yield, Momentum, EPS.Revision,Sales.Growth.1Y and Sales.Growth.5Y
#
# start_pt = 85
# out1 = list()
# repeat{
#   if(start_pt>nrow(dt6b)) break
#   dt_train = dt6b[1:start_pt,c('Returns', 'FCF.Yield','Momentum','EPS.Revision','sg1y','sg5y')]
#   dt_train[start_pt,Returns:=NA]
#   dt_test = dt6b[(start_pt),c('Returns', 'FCF.Yield','Momentum','EPS.Revision','sg1y','sg5y')]
#   ### normalise the  variables i.e z-scores
#   lsData = scale_training_data(dt_train)
#   em2 = run_EM_algo(lsData=lsData)
#   out1 = rbind(out1,c(dt_test$Returns,em2$last_returns)  )
#   start_pt =start_pt +1
#   print(out1)
# }
#
# mse(out1)
# ### the mean square error for this model and test data is 41.85172 The information contained in the other variables has improved forecast return accuracy
