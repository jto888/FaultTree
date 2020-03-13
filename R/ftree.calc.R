# ftree.calc.R
# copyright 2015-2016, openreliability.org
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


ftree.calc<-function(DF, use.bdd=FALSE)  {					
## ftree.validate is used to check for ability to calculate by BDD					
	if(use.bdd == TRUE)  {				
		ftree.validate(DF)			
	}				
					
	if(!test.ftree(DF)) stop("first argument must be a fault tree")				
					
	 if(any(DF$Type==16)) {				
		stop("atleast gate requires SCRAM calculation")			
	 }				
					
					
		NDX<-order(DF$Level)			
		sDF<-DF[NDX,]			
					
## note the for loop starts at bottom working up					
for(row in dim(sDF)[1]:1)  {					
## only calculating gate nodes					
	if(sDF$Type[row] > 9)  {				
## Build the siblingDF starting with first child					
		child_rows<-which(sDF$CParent==sDF$ID[row])			
		if(!length(child_rows)>0)  stop(paste0("empty gate found at ID ", as.character(sDF$ID[row])))			
## the first child is of course at child-rows[1]					
	siblingDF<-data.frame(ID=sDF$ID[child_rows[1]],				
		CFR=sDF$CFR[child_rows[1]],			
		PBF=sDF$PBF[child_rows[1]],			
		CRT=sDF$CRT[child_rows[1]],			
		Type=sDF$Type[child_rows[1]],			
		P1=sDF$P1[child_rows[1]]			
		)			
## Fail rate for exposed type does not pass upward in calculations					
		if(siblingDF$Type[1]==5) {siblingDF$CFR[1]<- (-1) }			
					
	if(length(child_rows)>1)  {				
		if(sDF$Type[row]==15) {			
			stop("more than one feed to vote")		
		}			
					
		for(child in 2:length(child_rows))  {			
## thisChild is now at child_rows[child] in the sDF					
		DFrow<-data.frame(ID=sDF$ID[child_rows[child]],			
			CFR=sDF$CFR[child_rows[child]],		
			PBF=sDF$PBF[child_rows[child]],		
			CRT=sDF$CRT[child_rows[child]],		
			Type=sDF$Type[child_rows[child]],		
			P1=sDF$P1[child_rows[child]]		
			)		
## Fail rate for exposed type does not pass upward in calculations					
			if(DFrow$Type[1]==5) {DFrow$CFR[1]<- (-1) }		
					
			siblingDF<-rbind(siblingDF,DFrow)		
		}			
	}else{				
		if(sDF$Type[row]>10 && sDF$Type[row]!=15) {			
## less than 2 feeds to other than OR calc					
		stop(paste0("insufficient feeds at gate ", sDF$ID[row]))			
		}			
	}				
					
	## VOTE gate calculation				
	if(sDF$Type[row]==15)  {				
	resultDF<-VOTEcalc(siblingDF, c(sDF$P1[row],sDF$P2[row]))				
	}				
					
	## OR gate calculation				## The gate node is identified as sDF$ID[row]
	if(sDF$Type[row]==10)  {				
	resultDF<-ORcalc(siblingDF)				
	}				
					
	## AND gate calculation				
	if(sDF$Type[row]==11)  {				
	resultDF<-ANDcalc(siblingDF)				
	}				
					
	if(sDF$Type[row]>11 && sDF$Type[row]!=15)  {				
## Code is required in addXXX to assign the first entry as Condition==1)					
					
## test the Condition setting for the first child					
		##firstSib_DFrow<-which(DF$ID==siblingDF$ID[1] )			
		##secondSib_DFrow<-which(DF$ID==siblingDF$ID[2] )			
		Cond1<-DF$Condition[which(DF$ID==siblingDF$ID[1] )]			
		Cond2<-DF$Condition[which(DF$ID==siblingDF$ID[2] )]			
		if( !(Cond1 + Cond2) == 1 )  {			
			stop(paste0("No indication of Condition at ID", as.character(sDF$ID[row])))		
		}			
		if(Cond1==0)  {			
## re-order the siblingDF rows making sure new row names apply					
			siblingDF<-siblingDF[c(2,1),]		
			row.names(siblingsDF)<-c(1,2)		
		}			
## first feed must have probability of failure for remaining combination gates					
		if(siblingDF$PBF[1]<=0)  {			
			stop(paste0("first feed must have prob of failure at gate ", sDF$ID[row]))		
		}			
					
## with this code repairable does not need to be in json					
## cfr print does not have to be suppressed on conditional					
## eliminate fail rate (cfr) values (set to -1) for the conditional feed to advanced gates					
		sDF$CFR[which(sDF$ID==siblingDF$ID[1])]<- (-1)			
## eliminate repair time (crt) values (set to -1) for the conditional feed EXCEPT repairable condition					
		if (sDF$Cond_Code[row]%%10 == 0) {			
			sDF$CRT[which(sDF$ID==siblingDF$ID[1])]<- (-1)		
		}			
					
	}				
					
	## INHIBIT gate calculation				
	if(sDF$Type[row]==12)  {				
	resultDF<-INHIBITcalc(siblingDF)				
	}				
					
	if(sDF$Type[row]>12 && sDF$Type[row]<15)  {				
## second feed must have demand for remaining combination gates					
		if(siblingDF$CFR[1]<=0)  {			
			stop(paste0("second feed must have demand at gate ", sDF$ID[row]))		
		}			
	}				
					
	## ALARM gate calculation				
	if(sDF$Type[row]==13)  {				
	resultDF<-ALARMcalc(siblingDF, sDF$P1[row])				
	}				
					
	## COND gate calculation				
	if(sDF$Type[row]==14)  {				
## reversible condition must have repair time					
		if(sDF$Cond_Code[row]%%10==1 && siblingDF$CRT[1]<=0)  {			
			stop(paste0("reversible condition at gate ", sDF$ID[row]), " must have repair time")		
		}			
## Test whether Latent condition has been misplaced					
		if(siblingDF$Type[1]==1 && siblingDF$Type[2]==2) {			
			stop(paste0("Active set as condition for Latent component at gate ", sDF$ID[row]))		
		}			
					
	resultDF<-PRIORITYcalc(siblingDF, sDF$Cond_Code[row]%%10)				
	}				
					
					
## Fill the sDF with results of calculations					
	sDF$CFR[row]<- resultDF$CFR[1]				
	sDF$PBF[row]<-resultDF$PBF[1]				
	sDF$CRT[row]<-resultDF$CRT[1]				
					
## The gate node is identified as sDF$ID[row]					
	if(use.bdd == TRUE)  {	
##if(sDF$Type[row] < 10) browser()	
	sDF$PBF[row]<-probability(DF, method="bdd", ft_node=sDF$ID[row])				
	}				
					
					
	}  ## close logic type check				
}  ## next row					
					
	## reorder by ID				
	NDX<-order(sDF$ID)				
	DF<-sDF[NDX,]				
					
					
	DF				
}					
