ftree2table<-function(DF){
ID<-DF$ID
Cond<-DF$Condition
Parent<-DF$CParent
outDF<-cbind(ID,Parent,DF[,c(5:8)],Cond,DF[,c(15,16)])
outDF
}