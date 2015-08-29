# addDormant.R
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

addDormant<-function(DF, at, mttf=NULL, mttr=NULL, prob="repair", inspect=NULL, name="",description="")  {				
	if(length(names(DF))!=18)   stop("first argument must be a fault tree")
	ftree_test<-NULL
	for(nm in 1:18) {ftree_test<-c(ftree_test,names(DF)[nm]==FT_FIELDS[nm])}
	if(!all(ftree_test))   stop("first argument must be a fault tree")
						
	tp<-2			
	parent<-which(DF$ID== at)			
	if(length(parent)==0) {stop("connection reference not valid")}			
	thisID<-max(DF$ID)+1			
	if(DF$Type[parent]<10) {stop("non-gate connection requested")}			
	## ***Caution Child positions in DF may change ***			
	availableconn<-which(DF[parent,8:12]<1)			
	if(length(availableconn)>3) {			
		DF[parent,(7+availableconn[1])]<-thisID		
	}else{			
		if((DF$Type[parent]==10||DF$Type[parent]==11)&&length(availableconn)>0)  {		
			DF[parent,(7+availableconn[1])]<-thisID	
		}else{		
			stop("connection slot not available")	
		}		
	}			
				
				
	## if(tp==2)  {  ##  type condition removed			
	if(is.null(mttf))  {stop("dormant component must have mttf")}			
	if(is.null(mttr)) { mttr<- (-1)}			
				
	if(is.null(inspect))  {stop("dormant component must have inspection entry")}			
				
	if(is.null(prob)) {prob<- (-1)}			
	if(is.character(inspect))  {			
		if(exists("inspect")) {		
			T<-eval((parse(text=inspect)))	
		}else{		
			stop("inspection interval object does not exist")	
		}		
	}else{			
		T=inspect		
	}			
				
	## default Pzero handling			
	if(prob=="repair")  {			
		if(!mttr>0)  {stop("mttr required for probability entry")}		
		prob=mttr/(mttf+mttr)		
	}			
				
	## fractional downtime method			
	pf<-1-1/((1/mttf)*T)*(1-exp(-(1/mttf)*T))			
	if(is.numeric(prob))  {			
		if(prob>0 && prob<1) {		
			pf<- 1-(1-pf)*(1-prob)	
		}else{ stop("probability entry must be between zero and one")}		
	}			
				
	Dfrow<-data.frame(			
		ID=	thisID	,
		Level=	DF$Level[parent]+1	,
		Name=	name	,
		ParentID=	at	,
		Type=	tp	,
		CFR=	1/mttf	,
		PBF=	pf	,
		Child1=	-1	,
		Child2=	-1	,
		Child3=	-1	,
		Child4=	-1	,
		Child5=	-1	,
		ProbabilityEntry=	-1	,
		MTTF=	mttf	,
		MTTR=	mttr	,
		inspectionInterval=	T	,
		InspectIonObject=	""	,
		Description=	description	
		)		
	## }  ## type condition removed			
	DF<-rbind(DF, Dfrow)			
	DF			
}				
