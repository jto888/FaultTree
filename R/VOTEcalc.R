COMBcalc<-function(df, comb)  {
## input is a single element
## input must have probability value to avoid div by zero error already checked but just to be sure. . .
	if(!df$PBF[1]>0) {
		stop("combination calculation attempted with non-positive probability")
		}
## if only df$PBF has pos value (df$CFR<0) then CFR and CRT will automatically be -1 at end of calculations
## if input has latency (not active), then CRT will be input CRT at end of calculations
## integer vector - comb[1] must be less than comb[2]		
		
## solve for the Binomial Coefficient		
	BC<-factorial(comb[2])/(factorial(comb[1])*factorial(comb[2]-comb[1]))	
		
		
## start progressive calculations of FR only if input CFR>0
if(df$CFR[1]>0)  {
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
			}
		}
## finalize using Binomial Coefficient		
	CFR<-pFR*BC	
	

}else{
CFR<-(-1)
CRT<-(-1)
}
		
##  PB calc
	pPF<-df$PBF[1]^comb[1]
## finalize using Binomial Coefficient
	PBF<- 1-(1-pPF)^BC
		
## identify active events for CRT calculation, else just return input CRT
## note division by zeo prevented at start of function as input PBF cannot equal 0
	CRT=df$CRT[1]
	if(df$CRT[1]>0 && df$CFR[1]>0)  {
		if(abs(df$CRT[1]-1/(df$CFR[1]*(1/df$PBF[1]-1))) < df$CRT[1]*10e-5)  {
			pAct=TRUE
			CRT=1/(CFR*(1/PBF-1))
			}
		
	outDF<-data.frame(	
		CFR=CFR,
		PBF=PBF,
		CRT=CRT
		)
		
	outDF	
}		
