# addAtLeast.R
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

 addAtLeast<-function (DF, at, atleast, tag="", label="", name="",name2="", description="")  {
	if(!test.ftree(DF)) stop("first argument must be a fault tree")

	at <- tagconnect(DF, at)

	if(label!="")  {
		if(any(DF$Name!="") || any(DF$Name2!="")) {
			stop("Cannot use label once name convention has been established.")
		}
	}
	if(any(DF$Label!="")) {
		if(name!="" || name2!="") {
			stop("Cannot use name convention once label has been established.")
		}
	}
	
	if(tag!="")  {
		if (length(which(DF$Tag == tag) != 0)) {
			stop("tag is not unique")
		}
		prefix<-substr(tag,1,2)
		if(prefix=="E_" || prefix=="G_" || prefix=="H_") {
			stop("Prefixes 'E_', 'G_', and 'H_' are reserved for auto-generated tags.")
		}
	}

## Model test
	if(any(DF$Type==3)|| any(DF$Type==13) || any(DF$Type==15)) {
		stop("PRA system event called for in RAM model")
	}

	tp <-16
	
	parent<-which(DF$ID== at)
	if(length(parent)==0) {stop("connection reference not valid")}
	thisID<-max(DF$ID)+1
	if(DF$Type[parent]<10) {stop("non-gate connection requested")}

	if(!DF$MOE[parent]==0) {
		stop("connection cannot be made to duplicate nor source of duplication")
	}

	
	p1<-floor(atleast[1])
	if(!p1>1) {
		stop("atleast argument must be greater than 1")
	}
	
	
		Dfrow<-data.frame(
		ID=	thisID	,
		GParent=	at	,
		Tag=	tag	,
		Type=	tp	,
		CFR=	-1	,
		PBF=	-1	,
		CRT=	-1	,
		MOE=	0	,
		Condition=	0,
		Cond_Code=	0	,
		EType=	0	,
		P1=	p1	,
		P2=	-1	,
		Collapse=	0	,
		Label=	label	,
		Name=	name	,
		Name2=	name2	,
		CParent=	at	,
		Level=	DF$Level[parent]+1	,
		Description=	description	,
		UType=	0	,
		UP1=	0	,
		UP2=	0	
	)


	DF<-rbind(DF, Dfrow)

	DF
}
	
