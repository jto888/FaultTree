 addExposed<-	function (DF, at, mttf, exposure=NULL, dist="exponential", p2=NULL,
		display_under=NULL, tag="", name="",name2="", description="")  {

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

	if (is.null(exposure)) {
		stop("exposed component must have exposure entry")
	}

	if (is.character(exposure)) {
		if (exists("exposure")) {
		Tao <- eval((parse(text = exposure)))
		}else {
			stop("exposure object does not exist")
		}
	}else {
		Tao = exposure
	}

	if(dist=="exponential")  {
		pf<-1 - exp(-(1/mttf) * Tao)
	}else {
		stop("only exponential implemented at this time")
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
		PHF_PZ = -1,
		Condition = condition,
		Cond_Code=	0	,
		Interval = Tao,
		Tag_Obj = tag,
		Name = name,
		Name2 = name2,
		Description = description,
		EType=	0	,
		UType=	0	,
		UP1=	-1	,
		UP2=	-1	
	)

	DF <- rbind(DF, Dfrow)
	DF
	}
