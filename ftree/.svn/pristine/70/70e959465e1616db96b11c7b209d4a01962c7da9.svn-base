ANDcalc<-function(df)  {
## start progressive calculations of FR and PF, identify latency
	pFR<-df$CFR[1]
	pPF<-df$PBF[1]
	pAct=FALSE
## identify active events
	if(df$PBF[1]>0 && df$CRT[1]>0)  {
		if(abs(df$CRT[1]-1/(df$CFR[1]*(1/df$PBF[1]-1))) < df$CRT[1]*10e-5)  {
			pAct=TRUE
		}
	}

## collect positive RT values
	RTvec<-NULL
	if(df$CRT[1]>0)  RTvec<-c(RTvec, df$CRT[1])

	for(sib in 2:dim(df)[1])  {
## single combination calculations
		cFR<-df$CFR[sib]
		cPF<-df$PBF[sib]
## collect positive RT values
	if(df$CRT[sib]>0)  RTvec<-c(RTvec, df$CRT[sib])
	cAct=FALSE
## identify active events
	if(df$PBF[sib]>0 && df$CRT[sib]>0)  {
		if(abs(df$CRT[sib]-1/(df$CFR[sib]*(1/df$PBF[sib]-1))) < df$CRT[sib]*10e-5)  {
			cAct=TRUE
		}
	}

		x1FR<-pPF*cFR
		if(x1FR<0)  {x1FR<-0}
		x2FR<-cPF*pFR
		if(x2FR<0)  {x2FR<-0}
		pFR<-x1FR+x2FR
		pPF<-pPF*cPF


	## return any non-entries to -1 indication
		if(pPF<0) {
			pPF<- (-1)
		}else{
	## second order fail rate adjustment often negligable
			if(x1FR>0&&x2FR>0)  {
			pFR<-pFR-(x2FR/cPF+cFR)*pPF
			}

		}
		if(!pFR>0)  {pFR<- (-1)}

		if(pAct && cAct ){
	## calculate progressive RT for combination of two actives
			pRT<- pPF/pFR
			RTvec<-c(RTvec, pRT)
		}else{
	## CRT will simply be minimum of any positive RT's
			pAct=FALSE
			if(pFR>0 && pPF>0) {
	## just in case an implied RT is the  minimum here (not really expected to ever be used)
	## on second thought, don't do this

				pRT<-min(RTvec)
				if(pAct || cAct) {
					warning("Active component combined with Latent in an AND gate")
				}

			}else{
				pRT<--1
			}
		}


	}  ## next child, if any






## prepare results as output
	outDF<-data.frame(
		CFR=pFR,
		PBF=pPF,
		CRT=pRT
		)

	outDF
}
