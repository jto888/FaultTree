# addExposed.R
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

 addExposed<-function (DF, at, mttf, dist="exponential", param=NULL,
		display_under=NULL, tag="", exposure=NULL, name="",name2="", description="")  {

	at <- tagconnect(DF, at)
		if(!is.null(display_under))  {
		display_under<-tagconnect(DF,display_under)
	}

  	tp <-5

	info<-test.basic(DF, at,  display_under, tag)
	thisID<-info[1]
	parent<-info[2]
	gp<-info[3]
	condition<-info[4]

## Model test - use of Demand type  or gate types ALARM or VOTE negates PRA processing
	if(any(DF$Type==3) || any(DF$Type==13) || any(DF$Type==15)){
		warning("exposed system event called for in RAM model")
	}

	if (is.null(mttf)) {
	stop("exposed component must have mttf")
	}

## p1 
	p1=-1
	p2=-1
## The EType needs to be numerically assigned. ########
	etype<-switch(dist,
		exponential = 1,
		weibull = 2,
		stop("exposed type not recognized")
	) 
	
	
## weibull exposure time can only be mission_time identified at P2 in top event.
if(is.null(exposure) || etype==2)  {
	mt_top<-DF$P2[which(DF$ID==min(DF$ID))]
	mt<-mt_top
}else{
## This is to be a seldom used over-ride of system mission time 
## applicable only to exponentially exposed events
	if(!is.null(exposure) ) {
		mt<-exposure
	}
}
if( !mt>0) {
	stop("exposed event must have defined mission_time or exposure")
}


	if(etype == 1)  {
	
		pf<-signif(1 - exp(-(1/mttf) * mt),5)
## assignment of p2 here controls graphics for Exponential exposure
## only want to display mission_time override
		if(mt!=mt_top) {
			p2<-mt
		}
	}


	if(etype==2)  {
		tzero<-0
		if(length(param)>1) {
			tzero<-param[2]
		}
		shape<-param[1]
		if((mt-tzero)<0) {
			pf<-0
			warning("weibull time_shift is greater than mission_time, SCRAM will not process.")
		}else{
			if((mttf-tzero)<0) {stop("negative weibull scale not permitted")}
			scale<-(mttf-tzero)/gamma(1+1/shape)
			pf<-signif(1-exp(-((mt-tzero)/scale)^shape),5)
		}
 
		p1<-shape
		p2<-tzero
	}



## Avoid conflicts with default tag names
	if(tag=="top") {stop("'top' is a reserved tag name")}
	if(length(tag)>2){
		if(substr(tag,1,2)=="E_" || substr(tag,1,2)=="G_" || substr(tag,1,2)=="H_") {
		stop("tag prefixes E_, G_ and H_ are reserved for MEF defaults")
		}
	}

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

	Dfrow <- data.frame(
		ID = thisID,
		GParent = gp,
		CParent = at,
		Level = DF$Level[parent] + 1,
		Type = tp,
		CFR = 1/mttf,
		PBF = pf,
		CRT = -1,
		MOE = 0,
		Condition = condition,
		Cond_Code=	0	,
		EType=	etype	,
		P1 = p1,
		P2 = p2,
		Tag_Obj = tag,
		Name = name,
		Name2 = name2,
		Description = description,
		UType=	0	,
		UP1=	0	,
		UP2=	0
	)

	DF <- rbind(DF, Dfrow)
	DF
	}
