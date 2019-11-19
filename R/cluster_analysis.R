# ########################
# ### cluster analysis ###
# ########################
#
# dtc1 = dt6[,c('Ticker','Returns','Mkt.Cap', 'FCF.Yield', 'Momentum', 'Sales.Growth.1Y', 'Sales.Growth.5Y','EPS.Revision')]
# dtc2 = na.omit(dtc1)
# setDT(dtc2)[, id := .GRP, by = Ticker]
# dtc2[,id:=id+1000]
# dtc3 = dtc2[,!'Ticker']
# unique(dtc3$id)
#
# dist1 = dist(dtc3,method="man") # method="man" # is a bit better
# hc_equity = hclust(dist1, method = "ward.D2")
# dtc3[,sector:=cutree(hc_equity,4)]
# rm('dist1')
#
#
#
# library(dendextend)
# dend1 = as.dendrogram(hc_equity)
# ### arbitrarily chose 10, there are more systematic metods to cut the tree
# dend1 = color_branches(dend1, k=8)
# plot(dend1)
#
# dtc4 = t(dtc3)
#
# dist2 = dist(dtc4,method="man") # method="man" # is a bit better
# hc_equity2 = hclust(dist2, method = "ward.D2")
# rm('dist2')
#
#
#
# library(dendextend)
# dend2 = as.dendrogram(hc_equity2)
# ### arbitrarily chose 10, there are more systematic metods to cut the tree
# dend2 = color_branches(dend2, k=4)
# plot(dend2)
