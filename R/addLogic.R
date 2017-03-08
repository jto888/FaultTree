# addLogic.R
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

addLogic<-function(DF, type, at, reversible_cond=FALSE, cond_first=TRUE, human_pbf=NULL, 
		vote_par=NULL, name="", name2="", description="")  {

	if(!test.ftree(DF)) stop("first argument must be a fault tree")
	
	if(type=="atleast") {
		stop("atleast must be added through FaultTree.SCRAM::addAtLeast")
	}
	
	tp<-switch(type,
		or = 10,
		and = 11,
		inhibit=12,
		alarm=13,
		cond=14,
		conditional =14,
		priority=14,
		comb=15,
		vote=15,
		## atleast=16, # not allowed by addLogic
		stop("gate type not recognized")
	)

## model test
	if(type>12 && type<16) {		
## This proposed addition will be RAM model		
		if(any(DF$Type==5) || any(DF$Type==16)) {	
			stop("RAM system event event called for in PRA model")
		}	
	}
	
	
	parent<-which(DF$ID== at)
	if(length(parent)==0) {stop("connection reference not valid")}
	thisID<-max(DF$ID)+1
	if(DF$Type[parent]<10) {stop("non-gate connection requested")}

	if(!DF$MOE[parent]==0) {
		stop("connection cannot be made to duplicate nor source of duplication")
	}
	
	if(DF$Type[parent]==15) {
		if(length(which(DF$CParent==at))>0) {
			stop("connection slot not available")
		}
		if(tp!=10) {
			stop("only OR or basic event can connect to priority gate")
		}
	}

	condition=0
	if(DF$Type[parent]>11&& DF$Type[parent]!=15 )  {
		if(length(which(DF$CParent==at))>1)  {
		stop("connection slot not available")
		}
		if( length(which(DF$CParent==at))==0)  {
			if(DF$Cond_Code[parent]<10)  {
				condition=1
			}
		}else{
##  length(which(DF$CParent==at))==1
			if(DF$Cond_Code[parent]>9)  {
				condition=1
			}
		}
	}


## default is non-reversible, so
	reversible=0
	if(reversible_cond==TRUE)  {
		reversible=1
		if(tp!=14) {
			reversible=0
			warning(paste0("reversible_cond entry ignored at gate ",as.character(thisID)))
		}
	}

	## resolve whether condition is first or second child
		cond_second=0
		if(cond_first == FALSE)  {
			cond_second=1
			if(tp<12 || tp>14) {
				cond_second=0
				warning(paste0("cond_first entry ignored at gate ",as.character(thisID)))
				}
		}

		cond_code<-reversible+10*cond_second

	p1=-1
	p2=-1
	if(tp == 13) {
		if(human_pbf < 0 || human_pbf >1) {
			stop(paste0("alarm gate at ID ", as.character(thisID), " requires human failure probability value"))
		}
		p1<-human_pbf
	}else{
		if(!is.null(human_pbf)) {
			warning(paste0("human failure probability for  non-alarm gate at ID ",as.character(thisID), " has been ignored"))
		}
	}


	if(tp==15) {
		if(length(vote_par)==2) {
			if(vote_par[1]<vote_par[2]) {
				p1<-vote_par[1]
				p2<-vote_par[2]
			}else{
				stop("validation error with vote parameters")
			}
		}else{
			stop("must provide k of n vote parameters c(k,n)")
		}	
	}

	Dfrow<-data.frame(
		ID=	thisID	,
		GParent=	at	,
		CParent=	at	,
		Level=	DF$Level[parent]+1	,
		Type=	tp	,
		CFR=	-1	,
		PBF=	-1	,
		CRT=	-1	,
		MOE=	0	,
		Condition=	condition,
		Cond_Code=	cond_code	,
		EType=	0	,
		P1=	p1	,
		P2=	p2	,
		Tag_Obj=	""	,
		Name=	name	,
		Name2=	name2	,
		Description=	description	,
		UType=	0	,
		UP1=	-1	,
		UP2=	-1	
	)


	DF<-rbind(DF, Dfrow)

	DF
}
