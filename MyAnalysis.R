
#��ȡ����
algae = read.table('~/R/dm_1/Analysis.txt',
col.names=c('season','size','speed','mxPH','mnO2','Cl','NO3','NH4','oPO4','PO4','Chla',
	'a1','a2','a3','a4','a5','a6','a7'),
na.string=c('XXXXXXX'))

#����ժҪ
summary(algae)

#���ݿ��ӻ�
library(car)

#����ֱ��ͼ
hist(algae$mxPH)
#����QQͼ
qqPlot(algae$mxPH,main='Norm QQ Plot of mxPH')

#���ƺ�ͼ
#ylabΪ����y����⣻
#rug�������Ʊ�����ʵ��ֵ��side=4��ʾ������ͼ���Ҳࣨ1���·���2����࣬3���Ϸ�����
#abline��������ˮƽ�ߣ�mean��ʾ��ֵ��na.rm=Tָ����ʱ������NAֵ��lty=2��������Ϊ���ߡ�
boxplot(algae$mxPH,ylab='mxPH')
rug(algae$mxPH,side=4)
abline(h=mean(algae$mxPH,na.rm=T),lty=2)

hist(algae$mnO2)
qqPlot(algae$mnO2,main='Norm QQ Plot of mnO2')
boxplot(algae$mnO2,ylab='mnO2')
rug(algae$mnO2,side=4)
abline(h=mean(algae$mnO2,na.rm=T),lty=2)

hist(algae$Cl)
qqPlot(algae$Cl,main='Norm QQ Plot of Cl')
boxplot(algae$Cl,ylab='Cl')
rug(algae$Cl,side=4)
abline(h=mean(algae$Cl,na.rm=T),lty=2)

hist(algae$NO3)
qqPlot(algae$NO3,main='Norm QQ Plot of NO3')
boxplot(algae$NO3,ylab='NO3')
rug(algae$NO3,side=4)
abline(h=mean(algae$NO3,na.rm=T),lty=2)

hist(algae$NH4)
qqPlot(algae$NH4,main='Norm QQ Plot of NH4')
boxplot(algae$NH4,ylab='NH4')
rug(algae$NH4,side=4)
abline(h=mean(algae$NH4,na.rm=T),lty=2)

hist(algae$oPO4)
qqPlot(algae$oPO4,main='Norm QQ Plot of oPO4')
boxplot(algae$oPO4,ylab='oPO4')
rug(algae$oPO4,side=4)
abline(h=mean(algae$oPO4,na.rm=T),lty=2)

hist(algae$PO4)
qqPlot(algae$PO4,main='Norm QQ Plot of PO4')
boxplot(algae$PO4,ylab='PO4')
rug(algae$PO4,side=4)
abline(h=mean(algae$PO4,na.rm=T),lty=2)

hist(algae$Chla)
qqPlot(algae$Chla,main='Norm QQ Plot of Chla')
boxplot(algae$Chla,ylab='Chla')
rug(algae$Chla,side=4)
abline(h=mean(algae$Chla,na.rm=T),lty=2)

#����������ͼ
library(lattice)
bwplot(size~a1,data=algae,ylab='River Size',xlab='a1')

bwplot(size~a2,data=algae,ylab='River Size',xlab='a2')
bwplot(size~a3,data=algae,ylab='River Size',xlab='a3')
bwplot(size~a4,data=algae,ylab='River Size',xlab='a4')
bwplot(size~a5,data=algae,ylab='River Size',xlab='a5')
bwplot(size~a6,data=algae,ylab='River Size',xlab='a6')
bwplot(size~a7,data=algae,ylab='River Size',xlab='a7')

#ȱʧ���ݴ���

#�޳�ȱʧ����
omitdata = na.omit(algae)
write.table(omitdata,'~/R/dm_1/OmitedData.txt',
	col.names = F,row.names = F, quote = F)

#ʹ�ø�Ƶ�����滻
library(DMwR)
preprocess2 = algae[-manyNAs(algae),]
preprocess2 = centralImputation(preprocess2)
write.table(preprocess2,'~/R/dm_1/CentralImputationData.txt',
col.names = F,row.names = F, quote = F)

#ͨ������������ȱʧֵ
symnum(cor(algae[,4:18],use='complete.obs'))
lm(formula=PO4~oPO4, data=algae)
preprocess3 = algae[-manyNAs(algae),]
fillPO4 <- function(oP){
	if(is.na(oP))
		return(NA)
	else return (42.897 + 1.293 * oP)
}
preprocess3[is.na(preprocess3$PO4),'PO4'] <- sapply(preprocess3[is.na(preprocess3$PO4),'oPO4'],fillPO4)
write.table(preprocess3,'~/R/dm_1/linearDefaultData.txt',
col.names = F,row.names = F, quote = F)

#ͨ�����ݶ���֮������������ȱʧֵ
preprocess4 = knnImputation(algae,k=10)
write.table(preprocess4,'~/R/dm_1/knnImputationData.txt',
col.names = F,row.names = F, quote = F)