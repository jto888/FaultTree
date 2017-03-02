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

 addExposed<-function (DF, at, mttf, exposure=NULL, dist="exponential", param=NULL,
		display_under=NULL, tag="", name="",name2="", description="")  {
		
	if (is.null(exposure)) {
		if(exists("mission_time")) {
			Tao<-mission_time
		}else{
			stop("mission_time not avaliable, exposed component must have exposure entry")
		}
	}else{
		if (is.character(exposure)) {
			if (exists("exposure")) {
			Tao <- eval((parse(text = exposure)))
			}else {
				stop("exposure object does not exist")
			}
		}else {
			Tao = exposure
		}
	}
	
  	tp <-5

	info<-test.basic(DF, at,  display_under, tag)
	thisID<-info[1]
	parent<-info[2]
	gp<-info[3]
	condition<-info[4]

	if(any(DF$Type<4)|| any(DF$Type>12)) {
		stop("non-repairable system event called for in repairable model")
	}

	if (is.null(mttf)) {
	stop("exposed component must have mttf")
	}

## The EType needs to be numerically assigned. ########
	etype<-switch(dist,
		exponential = 1,
#		weibull = 2,
#		glm = 3,
#		inspected =4,
		stop("exposed type not recognized")
	)
	if(etype == 1)  {
		pf<-1 - exp(-(1/mttf) * Tao)
	}

## Avoid conflicts with default tag names	
	if(length(tag)>2){
		if(substr(tag,1,2)=="E_" || substr(tag,1,2)=="G_" ) {
		stop("tag prefixes E_ and G_ are reserved for MEF defaults")
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
		P1 = -1,
		P2 = Tao,
		Tag_Obj = tag,
		Name = name,
		Name2 = name2,
		Description = description,
		UType=	0	,
		UP1=	-1	,
		UP2=	-1	
	)

	DF <- rbind(DF, Dfrow)
	DF
	}
