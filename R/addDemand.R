# addDemand.R
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

addDemand<-function(DF, at, mttf, name="", name2="", description="")  {				
	if(!ftree.test(DF)) stop("first argument must be a fault tree")	
						
 	tp=4			
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
				
			
	if(!mttf>0)  {stop("demand interval must be greater than zero")}			
								
	Dfrow<-data.frame(			
		ID=	thisID	,
		Name=	name	,
		Parent=	at	,
		Type=	tp	,
		CFR=	1/mttf	,
		PBF=	-1	,
		CRT=    -1  ,
		Child1=	-1	,
		Child2=	-1	,
		Child3=	-1	,
		Child4=	-1	,
		Child5=	-1	,
		Level=	DF$Level[parent]+1	,
		Independent=    TRUE    ,
		PHF_PZ=    -1  ,
		Repairable= FALSE   ,
		Interval=	-1	,
		Name2=	name2	,
		Description=	description	
		)		

		
	DF<-rbind(DF, Dfrow)			
	DF			
}				
