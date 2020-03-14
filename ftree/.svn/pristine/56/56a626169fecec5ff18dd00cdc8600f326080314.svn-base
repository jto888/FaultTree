ALARMcalc<-function(df, humanPBF)  {
## already have validated that df has two rows
## must have validated the siblingDF for first feed probability before this call
## secondary feed must have CFR

	outDF<-data.frame(
	## this was first test that tested close to APTree, but it violates proper sum of probabilities
		##CFR=df$PBF[1]*df$CFR[2]+humanPBF*df$CFR[2],
		##PBF=(1-(df$PBF[1]*df$PBF[2]-1)*(humanPBF*df$PBF[2]-1)),
		CFR=(1-(df$PBF[1]-1)*(humanPBF-1))*df$CFR[2],
		PBF=(1-(df$PBF[1]-1)*(humanPBF-1))*df$PBF[2],
		CRT= -1
		)

	outDF
}

