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

addActive<-function(DF, at, mttf=NULL, mttr=NULL, display_under=NULL, tag="", name="",name2="",description="")  {

	if(!ftree.test(DF)) stop("first argument must be a fault tree")

	tp<-1
	parent<-which(DF$ID== at)
	if(length(parent)==0) {stop("connection reference not valid")}
	thisID<-max(DF$ID)+1
	if(DF$Type[parent]<10) {stop("non-gate connection requested")}

	if(!DF$MOE[parent]==0) {
		stop("connection cannot be made to duplicate nor source of duplication")
	}

	if(any(DF$Type==5)) {
		stop("repairable system event event called for in non-repairable model")
	}

		if(tag!="")  {
		if (length(which(DF$Tag == tag) != 0)) {
		stop("tag is not unique")
		}
	}


## There is no need to limit connections to OR gates for calculation reasons
## Since AND gates are calculated in binary fashion, these too should not
## require a connection limit, practicality suggests 3 is a good limit.
## All specialty gates must be limited to binary feeds only

	if(DF$Type[parent]==11 && length(which(DF$Parent==at))>2) {
		warning("More than 3 connections to AND gate.")
	}

	condition=0
	if(DF$Type[parent]>11 )  {
		if( length(which(DF$CParent==at))==0)  {
			condition=1
		}else{
			if(length(which(DF$CParent==at))>1)  {
				stop("connection slot not available")
			}
		}
	}



	if(is.null(mttf))  {stop("active component must have mttf")}
	if(is.null(mttr))  {stop("active component must have mttr")}

	gp<-at
	if(length(display_under)!=0)  {
		if(DF$Type[parent]!=10) {stop("Component stacking only permitted under OR gate")}
		if(DF$CParent[display_under]!=at) {stop("Must stack at component under same parent")}
		if(length(which(DF$GParent==display_under))>0 )  {
			stop("display under connection not available")
		}else{
			gp<-display_under
		}
	}


	Dfrow<-data.frame(
		ID=	thisID	,
		GParent=	gp	,
		CParent=	at	,
		Level=	DF$Level[parent]+1	,
		Type=	tp	,
		CFR=	1/mttf	,
		PBF=	mttr/(mttf+mttr)	,
		CRT=	mttr	,
		MOE=	0	,
		PHF_PZ=	-1	,
		Condition=	condition,
		Repairable=	0,
		Interval=	-1	,
		Tag_Obj=	tag	,
		Name=	name	,
		Name2=	name2	,
		Description=	description	,
		Unused1=	""	,
		Unused2=	""
	)

	DF<-rbind(DF, Dfrow)
	DF
}
