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

addDemand<-function(DF, at, mttf, tag="", label="", name="", name2="", description="")  {

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

	tp=3

## Model test
	if(any(DF$Type==5) || any(DF$Type==16)) {
		stop("Pure Demand event event not permitted in PRA model")
	}

	display_under<-NULL

	info<-test.basic(DF, at,  display_under, tag)
	thisID<-info[1]
	parent<-info[2]
	gp<-info[3]
	condition<-info[4]

## apply default tag names if not specified
	if(tag=="")  {
		tag<-paste0("E_", thisID)
	}

	if(!mttf>0)  {stop("demand interval must be greater than zero")}

	Dfrow<-data.frame(
		ID=	thisID	,
		GParent=	at	,
		Tag=	tag	,
		Type=	tp	,
		CFR=	1/mttf	,
		PBF=	-1	,
		CRT=	-1	,
		MOE=	0	,
		Condition=	condition,
		Cond_Code=	0,
		EType=	0	,
		P1=	-1	,
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
