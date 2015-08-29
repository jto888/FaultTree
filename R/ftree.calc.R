# ftree.calc.R
# copyright 2015, openreliability.org
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
	if(length(names(DF))!=18)   stop("first argument must be a fault tree")
	ftree_test<-NULL
	for(nm in 1:18) {ftree_test<-c(ftree_test,names(DF)[nm]==FT_FIELDS[nm])}
	if(!all(ftree_test))   stop("first argument must be a fault tree")
						
		NDX<-order(DF$Level)		
		sDF<-DF[NDX,]		
				
				
for(row in dim(sDF)[1]:1)  {				
				
	if(sDF$Type[row] > 9)  {			
				
		children<-which(sDF[row, 8:12]>0)		
		if(!length(children)>0)  {stop("empty OR gate found")}		
		pFR<-sDF$CFR[which(sDF$ID==sDF$Child1[row])]		
		pPF<-sDF$PBF[which(sDF$ID==sDF$Child1[row])]		
				
		if(length(children)>1)  {		
				
		## OR gate calculation		
		if(sDF$Type[row]==10)  {		
		for(comb in 2:length(children))  {		
			cFR<-sDF$CFR[which(sDF$ID==sDF[ row, (7+children[comb])])]	
			cPF<-sDF$PBF[which(sDF$ID==sDF[ row, (7+children[comb])])]	
			if(pFR<0) {pFR<-0}	
			if(pPF<0) {pPF<-0}	
			if(cFR<0) {cFR<-0}	
			if(cPF<0) {cPF<-0}	
		## the progressing OR calculation 2x2 (non-entries are zero thus have no effect)		
			pFR<-pFR+cFR	
			pPF<-1-(1-pPF)*(1-cPF)	
		## return any non-entries to -1 indication		
			if(pFR==0) {pFR<- (-1)}	
			if(pPF==0)  {pPF<- (-1)}	
		}		
		}  ## close OR gate calculation		
				
				
		## AND gate calculation		
		if(sDF$Type[row]==11)  {		
		for(comb in 2:length(children))  {		
			cFR<-sDF$CFR[which(sDF$ID==sDF[ row, (7+children[comb])])]	
			cPF<-sDF$PBF[which(sDF$ID==sDF[ row, (7+children[comb])])]	
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
		}  ## next child, if any		
		}  ## close AND gate calculation		
				
		}  ## close more than one child check		
				
			sDF$CFR[row]<-pFR	
			sDF$PBF[row]<-pPF	
				
	}  ## close logic type check			
}  ## next row				
				
		## reorder by ID		
		NDX<-order(sDF$ID)		
		DF<-sDF[NDX,]		
				
				
		DF		
}				
