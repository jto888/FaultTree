# addActive.R
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

addActive<-function(DF, at, mttf, mttr, display_under=NULL, tag="", label="", name="",name2="",description="")  {

	at <- tagconnect(DF, at)

	if(label!="")  {
		if(any(DF$name!="") || any(DF$name2!="")) {
			stop("Cannot use label once name convention has been established.")
		}
	}
	if(any(DF$label!="")) {
		if(name!="" || name2!="") {
			stop("Cannot use name convention once label has been established.")
		}
	}

	tp<-1

	info<-test.basic(DF, at,  display_under, tag)
	thisID<-info[1]
	parent<-info[2]
	gp<-info[3]
	condition<-info[4]

## default settings for RAM model Active event only
	etp<-0
	pbf<-mttr/(mttf+mttr)
##  exposure time can only be mission_time identified as P2 in top event.
	mt<-DF$P2[which(DF$ID==min(DF$ID))]
	if(mt>0)  {
## process this Active event as a GLM
		etp<-3
## parameters for GLM calculation
		G<-0  # always, don't even know what this was supposed to be
		L<-1/mttf
		M<-1/mttr
		T<-mt
		pbf<- pbf - (L-G*(L+M))/(L+M)*exp(-(L+M)*T)
	}


	Dfrow<-data.frame(
		ID=	thisID	,
		GParent=	gp	,
		Tag=	tag	,
		Type=	tp	,
		CFR=	1/mttf	,
		PBF=	pbf	,
		CRT=	mttr	,
		MOE=	0	,
		Condition=	condition,
		Cond_Code=	0,
		EType=	etp	,
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
