INHIBITcalc<-function(df)  {
## already have validated that df has two rows
## must have validated the siblingDF for first feed probability before this call
## it is possible to combine two probabilities as an AND here, but why would one do this?
	if(df$CFR[2]>0) {
		CFRout<-df$PBF[1]*df$CFR[2]
	}else{
		CFRout<- -1
	}

	if( df$PBF[2]>0) {
		PBFout<-df$PBF[1]*df$PBF[2]
	}else{
		PBFout<- -1
	}


	outDF<-data.frame(
		CFR=CFRout,
		PBF=PBFout,
		CRT=df$CRT[2]
		)

	outDF
}

