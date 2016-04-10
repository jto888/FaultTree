COMBcalc<-function(df, comb)  {		
## must have single active element (required to have both mttf and mttr)		
## integer vector - comb[1] must be less than comb[2]		
		
## solve for the Binomial Coefficient		
	BC<-factorial(comb[2])/(factorial(comb[1])*factorial(comb[2]-comb[1]))	
		
		
## start progressive calculations of FR and PF		
	pFR<-df$CFR[1]	
	pPF<-df$PBF[1]	
		
	if(comb[1] >1)  {	
	for(k in 2:comb[1])  {	
		cFR<-df$CFR[1]
		cPF<-df$PBF[1]
		
		
## cross multiply LB1*P2 + LB2*P1 for first order fail rate		
##  minus second order fail rate adjustment  - (LB1+LB2) * P1*P2		
## - (LB1+LB2) * P1*P2		
		pFR<-(pPF*cFR + cPF*pFR) - (pFR+cFR) * pPF*cPF
		
		
## progressive PB calc		
		pPF<- pPF*cPF
	}	
	}	
		
## finalize using Binomial Coefficient		
	CFR<-pFR*BC	
	PBF<- 1-(1-pPF)^BC	
		
		
	outDF<-data.frame(	
		CFR=CFR,
		PBF=PBF,
		CRT=1/(CFR*(1/PBF-1))
		)
		
	outDF	
}		
