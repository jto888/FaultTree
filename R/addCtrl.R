# addCtrl.R
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

addCtrl<-function(DF, at, prob, severity, name="", description="")  {					
	if(length(names(DF))!=13)   stop("first argument must be a fault tree")				
	etree_test<-NULL				
	for(nm in 1:13) {etree_test<-c(etree_test,names(DF)[nm]==ET_FIELDS[nm])}				
	if(!all(etree_test))   stop("first argument must be a fault tree")				
	if(!(prob>0 && prob<1))  {stop("probability entry error")}				
					
	parent<-which(DF$ID== at)				
	if(length(parent)==0) {stop("connection reference not valid")}				
	if(!(severity<DF[parent,7])) {warning("A mitigating control has not reduced severity")}				
					
					
	availableconn<-which(DF[parent,8:12]<1)				
	if(length(availableconn)==5) {				
		thisID<-max(DF$ID)+1			
		DF[parent,(7+availableconn[1])]<-thisID			
		hazID<-thisID+1			
		DF[parent,(8+availableconn[1])]<-hazID			
		hazprob<-1-prob			
					
## write out the controled case here, hazard case after close of conditional					
				 	
		Dfrow<-data.frame(			
			ID=	thisID	,
			Level=	DF$Level[parent]+1	,
			Name=	name	,
			ParentID=	at	,
			Prob=	prob	,
			Freq=	DF$Freq[parent]*prob	,
			Severity=	severity	,
			Child1=	-1	,
			Child2=	-1	,
			Child3=	-1	,
			Child4=	-1	,
			Child5=	-1	,
			Description=	description	
			)		
					
		DF<-rbind(DF,Dfrow)			
					
					
	}else{				
		if(length(availableconn)>0) {			
## calculate cumulative probability of mitigating controls					
			cumprob<-prob		
			prev_cases<-4-length(availableconn)		
					
		for(case in 1:prev_cases)  {			
			caseID<-DF[parent, (7+case)]		
			case_row<-which(DF$ID==caseID)		
			case_prob<-DF[case_row, 5]		
			cumprob<-cumprob+case_prob		
		}			
			if(!(cumprob>0 && cumprob<1))  {stop("cumulative probability entry error")}		
			hazprob<-1-cumprob		
					
## over-write the last hazard line entry with this new case					
			thisID<-DF[parent, (7+prev_cases+1)]		
			row_num<-which(DF$ID==thisID)		
			## ID, Level, ParentID and Child# entries are already correct in DF[rownum,]		
			DF$Name[row_num]<-name		
			DF$Prob[row_num]<-prob		
			DF$Freq[row_num]<-DF$Freq[parent]*prob		
			DF$Severity[row_num]<-severity		
			DF$Description[row_num]<-description		
					
			hazID<-max(DF$ID)+1		
					
		}else{			
			stop("no available connections")		
		}			
				
	}				
										
## now build the hazard case for this control entry					
					
		Dfrow<-data.frame(			
			ID=	hazID	,
			Level=	DF$Level[parent]+1	,
			Name=	"hazard"	,
			ParentID=	at	,
			Prob=	hazprob	,
			Freq=	DF$Freq[parent]*hazprob	,
			Severity=	DF$Severity[parent]	,
			Child1=	-1	,
			Child2=	-1	,
			Child3=	-1	,
			Child4=	-1	,
			Child5=	-1	,
			Description=	description	
			)		
					
		DF<-rbind(DF,Dfrow)			
					
	DF				
}					
