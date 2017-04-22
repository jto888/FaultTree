# ftree.make.R
# copyright 2015-2017, openreliability.org
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


ftree.make<-function(type, reversible_cond=FALSE, cond_first=TRUE, 
		human_pbf=NULL, start_id=1, system_mission_time=NULL,
		name="top event", name2="",description="")  {

	thisID<-start_id

## note p2 will hold system_mission_time at top gate, if it is set at all.
## p1 is used by ALARM gate to hold probability of human failure, 
	p1=-1
	p2=-1
	if(!is.null(system_mission_time)) {
		p2<-system_mission_time
		if(exists("mission_time")) {
			warning("The system_mission_time argument has overridden global 'mission_time'")
		}
	}else{
		if(exists("mission_time")) {
			smt<-"mission_time"
			p2<-eval((parse(text = smt)))
		}
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
		atleast=16,
		stop("gate type not recognized")
	)
## vote gate requires access to P2, which holds mission_time value at top gate.
## atleast gate is specific to SCRAM PRA, cannot be implemented in FaultTree alone.
## disallow vote and atleast from top event, simply place as single child under OR
if(tp==15)  {stop("vote gate not permitted as top event, place as single child under OR")}
if(tp==16)  {stop("atleast gate requires FaultTree.SCRAM and connot be top event")}

## default is irreversible, so
	reversible=0
	if(reversible_cond==TRUE)  {
		reversible=1
		if(tp!=14) {
			reversible=0
			warning("reversible_cond entry ignored at top gate")
		}
	}

## resolve whether condition is first or second child
	cond_second=0
	if(cond_first == FALSE)  {
		cond_second=1
		if(tp<12) {
			cond_second=0
			warning(paste0("cond_first entry ignored at gate ",as.character(thisID)))
			}
		}

	cond_code<-reversible+10*cond_second


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

## vote gate requires access to P2, which holds mission_time value at top gate.
## vote gate has been disallowed as top event.
#	if(tp==15) {
#		if(length(vote_par)==2) {
#			if(vote_par[1]<vote_par[2]) {
#				p1<-vote_par[1]
#				p2<-vote_par[2]
#			}else{
#				stop("validation error with vote parameters")
#			}
#		}else{
#			stop("must provide k of n vote parameters c(k,n)")
#		}	
#	}

	DF<-data.frame(
		ID=	thisID	,
		GParent=	-1	,
		CParent=	-1	,
		Level=	1	,
		Type=	tp	,
		CFR=	-1	,
		PBF=	-1	,
		CRT=	-1	,
		MOE=	0	,
		Condition=	0,
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
		UP2=	-1	,		
		stringsAsFactors = FALSE
	)
DF
}

FT_FIELDS<-c("ID",
	"GParent",
	"CParent",
	"Level",
	"Type",
	"CFR",
	"PBF",
	"CRT",
	"MOE",
	"Condition",
	"Cond_Code",
	"EType",
	"P1",
	"P2",
	"Tag_Obj",
	"Name",
	"Name2",
	"Description",
	"UType",
	"UP1",
	"UP2"	
	)

