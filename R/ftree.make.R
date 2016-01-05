# ftree.make.R
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


ftree.make<-function(type, name="top event", repairable_cond=FALSE, human_pbf=-1, description="")  {			
	tp<-switch(type,			
		or = 10,		
		and = 11,		
		inhibit=12,
		alarm=13,
		cond=14,
		conditional =14,		
		stop("gate type not recognized")		
	)			

## Must place this test here before tp==13 test, since alarm gate is being assigned FALSE repairability
	if(repairable_cond==FALSE && tp!=14) {
		warning(paste0("repairable_cond entry ignored at gate ",as.character(thisID)))
	}

	if(tp == 13) {
		repairable_cond=FALSE
		if(human_pbf < 0 || human_pbf >1) {
			stop(paste0("alarm gate at ID ", as.character(thisID), " requires human failure probability value"))
		}
	}else{
		if(human_pbf!=-1) {
			warning(paste0("human failure probability for  non-alarm gate at ID ",as.character(thisID), " has been ignored"))
			human_pbf=-1
		}
	}				
	DF<-data.frame(			
		ID=	1	,
		Name=	name	,
		Parent=	-1	,
		Type=	tp	,
		CFR=	-1	,
		PBF=	-1	,
		CRT=    -1  ,
		Child1=	-1	,
		Child2=	-1	,
		Child3=	-1	,
		Child4=	-1	,
		Child5=	-1	,
		Level=  1   ,
		Independent=    TRUE  ,
		PHF=    human_pbf  ,
		Repairable= repairable_cond  ,
		inspectionInterval=	-1	,
		InspectIonObject=	""	,
		Description=	description	,
		stringsAsFactors = FALSE
		)		
DF
}

FT_FIELDS<-c("ID",
	"Name",
	"Parent",
	"Type",
	"CFR",
	"PBF",
	"CRT",	
	"Child1",
	"Child2",
	"Child3",
	"Child4",
	"Child5",
	"Level",
	"Independent",
	"PHF",
	"Repairable",
	"inspectionInterval",
	"InspectIonObject",
	"Description"
	)

