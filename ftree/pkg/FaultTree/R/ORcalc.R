ORcalc<-function(df)  {
	pFR<-df$CFR[1]
	pPF<-df$PBF[1]
	pRT<-df$CRT[1]
	FRaa<-NULL
	AVaa<-NULL
## get active analog availability for first component
	if(pFR>0 && pRT>0) {
		AVaa<-c(AVaa, (1-pRT/(1/pFR+pRT)))
		FRaa<-c(FRaa, pFR)
	}else{
		AVaa<-c(AVaa, 1)
		FRaa<-c(FRaa, 0)
	}
## exclude special case where OR has single child
	if(dim(df)[1]==1)  {
		outDF<-data.frame(
			CFR=pFR,
			PBF=pPF,
			CRT=pRT
		)
	}else{
		for(sib in 2:dim(df)[1])  {
			cFR<-df$CFR[sib]
			cPF<-df$PBF[sib]
			cRT<-df$CRT[sib]

## get active analog availability vector for rest of components
		if(cFR>0 && cRT>0) {
			AVaa<-c(AVaa, (1-cRT/(1/cFR+cRT)))
			FRaa<-c(FRaa, cFR)
		}else{
			AVaa<-c(AVaa, 1)
		}
## zero out any non-entries prior to calculations
		if(pFR<0) {pFR<-0}
		if(pPF<0) {pPF<-0}
		if(cFR<0) {cFR<-0}
		if(cPF<0) {cPF<-0}
## the progressing OR calculation 2x2 (non-entries are zero thus have no effect)
		pFR<-pFR+cFR
		pPF<-1-(1-pPF)*(1-cPF)
## return any non-entries to -1 indication for final or next iteration
		if(pFR==0) {pFR<- (-1)}
		if(pPF==0)  {pPF<- (-1)}
		}


## prepare the CRT based on active analog values for an operating line
		TAVaa<-prod(AVaa)
		TFRaa<-sum(FRaa)
		if(TAVaa<1)  {
			crt<-1/(TFRaa*(1/(1-TAVaa) -1))
		}else{
			crt<- -1
		}


## prepare results as output
	outDF<-data.frame(
		CFR=pFR,
		PBF=pPF,
		CRT=crt
		)
	}

	outDF
}
