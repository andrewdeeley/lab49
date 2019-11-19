#
# ###################################
# ### looking at the returns data ###
# ###################################
#
# summary(dt5$Returns)
#
# ### max value is 333.33 and min value is -95.44 these do not look like % returns
# dt5[Returns==333.33]
# dt5[Ticker=='PLAB'][1:100]
#
# #### find companies whose returns are normally distributed without any jumps in the diffusion process, normality assumed if p> 0.05
# dt5[,shaprioTest:=shapiro.test(Returns)$p.value,by = Ticker]
# dt6 = dt5[shaprioTest>0.05]
# dim(dt6)
# length(unique(dt6$Ticker))
# ### 67593 rows and 541 unique companies with complete data whose returns are normally distribiuted
#
#
# #### deeper dive into the returns distribution with graphics ###
# Ticker1 = 'AAON'
# ### normality assumed if p> 0.05
# tp =shapiro.test(dt5[Ticker==Ticker1]$Returns)
# tp
#
# hist(dt5[Ticker==Ticker1]$Returns,probability=T, main=paste0("Histogram of return data Ticker ",Ticker1),xlab="Approximately normally distributed data")
#
# ggplot2::ggplot(dt5[Ticker==Ticker1,c('Date','Returns','Ticker')],ggplot2::aes(x = Date, y = Returns, col = Ticker))+ ggplot2::geom_line()
