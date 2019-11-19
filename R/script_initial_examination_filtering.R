# # #########################################
# # ### initial examination and filtering ###
# # #########################################
# #
# length(unique(dt1$Company.Name))
# #5846 different companies
# length(unique(dt1$Ticker))
# #5495 unique tickers ???????
# #Q1 why have some companies Tickers changed?
# #Q2 TRUE is dangerous Ticker name can we change??
# ### find which companies have mult Tickers
# dt1[,tp1:=length(unique(Ticker)),by = 'Company.Name']
# unique(dt1[tp1>1]$Company.Name)
# unique(dt1[Company.Name==unique(dt1[tp1>1]$Company.Name)[1]]$Ticker)
# ### find which Tickers have mult company names
# dt1[,tp2:=length(unique(Company.Name)),by = 'Ticker']
# unique(dt1[tp2>1]$Ticker)
# unique(dt1[Ticker==unique(dt1[tp2>1]$Ticker)[17]  ]$Company.Name)
# unique(dt1[Ticker==unique(dt1[tp2>1]$Ticker)[23]  ]$Company.Name)
# ### some look like company renameing e.g "Apple Computer Inc." "Apple Inc."
# ### others look completely different e.g. "Cambium Learning Group, Inc." "ProQuest Company"
# ###
#
# ### for simplicity filter companies that only have a unique comepnay name and ticker
# dt2 = dt1[tp1==1 & tp2==1]
# dim(dt2)
# length(unique(dt2$Company.Name))
# ### 343542 rows and 5122 companes
#
# #### size of data by Ticker
# dt2[,count:=.N, by = 'Ticker']
# #### filter out company data where there is too little historical data to run analysis
# dt3 = dt2[count>100]
# dim(dt3)
# length(unique(dt3$Ticker))
# ### 215240 rows 1735 different Tickers/companies
#
# ### check freq of data by ticker
# dt3[, DateL1 := shift(Date, type='lead'), by = 'Ticker' ]
# dt3[,diffdays:=difftime(DateL1, Date, units = c("days")), by = Ticker]
# length(unique(dt3[diffdays>35]$Ticker))
# #dt3[Ticker==unique(dt3[diffdays>35]$Ticker)[2]][1:100]
# ### using 35 days as the boundary we have 110 companies that have periods of missing data e.g Accenture Plc Class
# dt3[,maxdiffDays:=max(diffdays,na.rm=T),by = Ticker]
#
# ### filter out companies that have periods of missing data
# dt4 = dt3[maxdiffDays<35]
# dim(dt4)
# length(unique(dt4$Ticker))
# ### 203001 rows 1625 different Tickers/companies
# setkeyv(dt4,c('Ticker','Date'))
#
#
# ### check for NAs in the return column
# dt4[is.na(Returns)]
# dt4[Ticker =='WPP']
# ### each of these NAs are at the end of the time series
#
# ### filter out rows that NA values in the return column (we could do something with Kalhman filtering/smoothing or the expectation maximisation
# ###algo to get an expected value for these )
# dt5 = dt4[!is.na(Returns)]
# dt5[, DateL1a := shift(Date, type='lead'), by = 'Ticker' ]
# dt5[,diffdays1:=difftime(DateL1a, Date, units = c("days")), by = Ticker]
# dt5[,maxdiffDays:=max(diffdays1,na.rm=T),by = Ticker]
# dt5[maxdiffDays>35]
# ### by removing the NA values I have not introduced any breaks into the time series, i.e. they are all still regular
#
# rm(list =c('dt2','dt3','dt4'))
#
