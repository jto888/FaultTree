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

ftree.calc<-function(DF)  {				
	if(length(names(DF))!=19)   stop("first argument must be a fault tree")
	ftree_test<-NULL
	for(nm in 1:19) {ftree_test<-c(ftree_test,names(DF)[nm]==FT_FIELDS[nm])}
	if(!all(ftree_test))   stop("first argument must be a fault tree")
						
		NDX<-order(DF$Level)		
		sDF<-DF[NDX,]		
				
				
for(row in dim(sDF)[1]:1)  {				
				
	if(sDF$Type[row] > 9)  {			
## Build the siblingDF starting with first child				
		children<-which(sDF[row, 8:12]>0)		
		if(!length(children)>0)  stop(paste0("empty gate found at ID ", as.character(sDF$ID[row])))		
	thisChild<-which(sDF$ID==sDF$Child1[row])
	siblingDF<-data.frame(ID=sDF$ID[thisChild],
		CFR=sDF$CFR[thisChild],
		PBF=sDF$PBF[thisChild],
		CRT=sDF$CRT[thisChild],
		Type=sDF$Type[thisChild],
		PHF=sDF$PHF[thisChild]
		)				
	if(length(children)>1)  {		
				
		for(child in 2:length(children))  {
		thisChild<-which(sDF$ID==sDF[ row, (7+children[child])])
		DFrow<-data.frame(ID=sDF$ID[thisChild],
			CFR=sDF$CFR[thisChild],
			PBF=sDF$PBF[thisChild],
			CRT=sDF$CRT[thisChild],
			Type=sDF$Type[thisChild],
			PHF=sDF$PHF[thisChild]
			)

		siblingDF<-rbind(siblingDF,DFrow)
		}
	}else{
		if(sDF$Type[row]>10) {
## less than 2 feeds to other than OR calc
		stop(paste0("insufficient feeds at gate ", sDF$ID[row]))
		}
	}


	## OR gate calculation
	if(sDF$Type[row]==10)  {
	resultDF<-ORcalc(siblingDF)
	}

	## AND gate calculation
	if(sDF$Type[row]==11)  {
	resultDF<-ANDcalc(siblingDF)
	}

	if(sDF$Type[row]>11)  {
## first feed must have probability of failure for remaining combination gates
		if(siblingDF$PBF[1]<=0)  {
			stop(paste0("first feed must have prob of failure at gate ", sDF$ID[row]))
		}
	}

	## INHIBIT gate calculation
	if(sDF$Type[row]==12)  {
	resultDF<-INHIBITcalc(siblingDF)
	}

	if(sDF$Type[row]>12)  {
## second feed must have demand for remaining combination gates
		if(siblingDF$CFR[1]<=0)  {
			stop(paste0("second feed must have demand at gate ", sDF$ID[row]))
		}
	}

	## ALARM gate calculation
	if(sDF$Type[row]==13)  {
	resultDF<-ALARMcalc(siblingDF, sDF$PHF[row])
	}

	## COND gate calculation
	if(sDF$Type[row]==14)  {
## repairable condition must have repair time
		if(sDF$Repairable[row]==TRUE && siblingDF$CRT[1]<=0)  {
			stop(paste0("repairable condition at gate ", sDF$ID[row]), " must have repair time")
		}
## Test whether Latent condition has been misplaced
		if(siblingDF$Type[1]==1 && siblingDF$Type[2]==2) {
			stop(paste0("Active set as condition for Latent component at gate ", sDF$ID[row]))
		}

	resultDF<-CONDcalc(siblingDF, sDF$Repairable[row])
	}


## Fill the sDF with results of calculations
	sDF$CFR[row]<- resultDF$CFR[1]
	sDF$PBF[row]<-resultDF$PBF[1]
	sDF$CRT[row]<-resultDF$CRT[1]

	}  ## close logic type check
}  ## next row

	## reorder by ID
	NDX<-order(sDF$ID)
	DF<-sDF[NDX,]


	DF
}				
