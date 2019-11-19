### from csv file
# df1  = read.csv(file= '~/Documents/data/equity_data.csv')
# library(data.table)
# dt1 = as.data.table(df1)
# rm('df1')
# dt1[,Date:=as.Date(Date,format='%m/%d/%Y')]

# ### from aws public DB
# con = RMySQL::dbConnect(RMySQL::MySQL(),dbname = 'lab49', host = 'publicdb.csacsgevznv1.eu-west-1.rds.amazonaws.com',user = 'user2',password = 'z0rr0Pl8n')
# msg = try(DBI::dbGetQuery(con,'SELECT * FROM equitydata'),silent = T)
# dt1 = as.data.table( msg)
# dt1[,Date:=as.Date(Date)]

### need to update DBTools
#dt1 = DBTools::adDBGetQuery(DB ='lab49',cmd='SELECT * FROM equitydata',user = 'user2',pwd = 'z0rr0Pl8n',
#                        DBType='MySQL',
#                        host = 'publicdb.csacsgevznv1.eu-west-1.rds.amazonaws.com')
#dbDisconnect(con)


# ### format data.table

# dt1[,Date:=as.POSIXct(Date)]
# dt1[,Returns:=as.numeric(Returns)]
# dt1[,Capitalization:=as.numeric(Capitalization)]
# dt1[,Mkt.Cap:=as.numeric(Mkt.Cap)]
# dt1[,FCF.Yield:=as.numeric(FCF.Yield)]
# dt1[,Momentum:=as.numeric(Momentum)]
# dt1[,Sales.Growth.1Y:=as.numeric(Sales.Growth.1Y)]
# dt1[,Sales.Growth.5Y:=as.numeric(Sales.Growth.5Y)]
# dt1[,EPS.Revision:=as.numeric(EPS.Revision)]


