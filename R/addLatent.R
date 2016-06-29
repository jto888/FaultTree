# addLatent.R
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

addLatent<-function(DF, at, mttf, mttr=NULL, pzero="repair", inspect=NULL, tag="", name="",name2="", description="")  {
	if(!ftree.test(DF)) stop("first argument must be a fault tree")

	tp<-2
	parent<-which(DF$ID== at)
	if(length(parent)==0) {stop("connection reference not valid")}
	thisID<-max(DF$ID)+1
	if(DF$Type[parent]<10) {stop("non-gate connection requested")}

	if(!DF$MOE[parent]==0) {
		stop("connection cannot be made to duplicate nor source of duplication")
	}


## There is no need to limit connections to OR gates for calculation reasons
## Since AND gates are calculated in binary fashion, these too should not require a connection limit
## All specialty gates must be limited to binary feeds only

##	if(DF$Type[parent]>11 && length(which(DF$Parent==at))>1) {
##		stop("connection slot not available")
#3	}

	condition=0
	if(DF$Type[parent]>11 )  {
		if( length(which(DF$Parent==at))==0)  {
			condition=1
		}else{
			if(length(which(DF$Parent==at))>1)  {
				stop("connection slot not available")
			}
		}
	}




	## if(tp==2)  {  ##  type condition removed
	if(is.null(mttf))  {stop("dormant component must have mttf")}
	if(is.null(mttr)) { mttr<- (-1)}

	if(is.null(inspect))  {stop("dormant component must have inspection entry")}

	if(is.null(pzero)) {pzero<- (-1)}
	if(is.character(inspect))  {
		if(exists("inspect")) {
			Tao<-eval((parse(text=inspect)))
		}else{
			stop("inspection interval object does not exist")
		}
	}else{
		Tao=inspect
	}

	## default Pzero handling
	if(pzero=="repair")  {
		if(!mttr>0)  {stop("mttr required for pzero calculation")}
		pzero=mttr/(mttf+mttr)
	}

	## fractional downtime method
	pf<-1-1/((1/mttf)*Tao)*(1-exp(-(1/mttf)*Tao))
	if(is.numeric(pzero))  {
		if(pzero>=0 && pzero<1) {
			pf<- 1-(1-pf)*(1-pzero)
		}else{ stop("pzero entry must be zero to one")}
	}

	Dfrow<-data.frame(
		ID=	thisID	,
		GParent=	at	,
		CParent=	at	,
		Level=	DF$Level[parent]+1	,
		Type=	tp	,
		CFR=	1/mttf	,
		PBF=	pf	,
		CRT=	mttr	,
		MOE=	0	,
		PHF_PZ=	pzero	,
		Condition=	condition,
		Repairable=	0,
		Interval=	Tao	,
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
