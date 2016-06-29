CONDcalc<-function(df, repairable)  {
## already have validated that df has two rows
## must have validated the siblingDF for first feed probability before this call
## sequential event must have demand
## must validate that repariable condition has CRT>0
	CFRout<-df$PBF[1]*df$CFR[2]
## special case of non-repairable condition
	if(repairable==0) {
		PBFout= -1
		CRTout= -1
	}else{
## identify latency
		if(df$PBF[1]>df$CRT[1]/(df$CRT[1]+1/df$CFR[1]))  {
			validCRT<-NULL
			for(n in 1:2) {
				if(df$CRT[n]>0) validCRT<-c(validCRT,df$CRT[n])
			}
			if(length(validCRT)>0) {
				CRTout<-min(validCRT)
				PBFout<- CRTout/(CRTout+1/CFRout)
			}else{
				CRTout<- -1
				PBFout<- -1
			}
		}else{
## this is the convolution solution
			if(df$CRT[1]<=df$CRT[2]) {
				CRTout<-df$CRT[1]/2
			}else{
				CRTout<-df$CRT[2]-(1/2)*df$CRT[2]*df$CRT[2]/df$CRT[1]
			}
			PBFout<- CRTout/(CRTout+1/CFRout)
		}
	}
	
	outDF<-data.frame(
		CFR=CFRout,
		PBF=PBFout,
		CRT=CRTout
		)

	outDF
}
