# ######################################################
# ### examining the relationship between the returns ###
# ### attenpt to group the data into sectors ###########
# ######################################################
#
# ### from long to wide
#
# dt7 = dcast (dt6,Date~Ticker , value.var = 'Returns' )
# dim(dt7)
# #########################################################
# ### calculate the correlation matrix on complete data ###
# #########################################################
# dt8 = na.omit(dt7[,!'Date'])
# c1 = cor(dt8)
# dim(c1)
#
# ######################################################################################################
# ### reorder the correlation matrix using a clustering method, arbitrarily cut tree into 10 custers ###
# ### method is slow due to printing the heatmap, set to false to run quicklty #########################
# ######################################################################################################
# out =reorder_cor_mat (corM=c1, n_clusters = 10,method = 'ward.D2')
# setkey(dt6,Ticker)
# dt6a = out$sectors[dt6]
#
# ############################################
# ### use word frequency to guess a sector ###
# ############################################
# tm::findMostFreqTerms(tm::termFreq(unique(dt6a[sector==1]$Company.Name)),14L) ### health
# tm::findMostFreqTerms(tm::termFreq(unique(dt6a[sector==2]$Company.Name)),14L)  #### banking
# tm::findMostFreqTerms(tm::termFreq(unique(dt6a[sector==3]$Company.Name)),14L)  #### ????
# tm::findMostFreqTerms(tm::termFreq(unique(dt6a[sector==4]$Company.Name)),14L)  #### technology
# tm::findMostFreqTerms(tm::termFreq(unique(dt6a[sector==5]$Company.Name)),14L)  #### industrial
# tm::findMostFreqTerms(tm::termFreq(unique(dt6a[sector==6]$Company.Name)),14L)  #### energy
# tm::findMostFreqTerms(tm::termFreq(unique(dt6a[sector==7]$Company.Name)),14L)  #### fintech
# tm::findMostFreqTerms(tm::termFreq(unique(dt6a[sector==8]$Company.Name)),14L)  #### properties
# tm::findMostFreqTerms(tm::termFreq(unique(dt6a[sector==9]$Company.Name)),14L)  #### energy2
# tm::findMostFreqTerms(tm::termFreq(unique(dt6a[sector==10]$Company.Name)),14L)  #### education
#
# ### does not work very well, could try different clustering algos and number of clusters
