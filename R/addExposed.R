 addExposed<-	function (DF, at, mttf, exposure=NULL, dist="exponential", p2=NULL,
		display_under=NULL, tag="", name="",name2="", description="")  {

	if (!ftree.test(DF))  stop("first argument must be a fault tree")

	tp <-5
	parent <- which(DF$ID == at)
	if (length(parent) == 0) {
	stop("connection reference not valid")
	}
	thisID <- max(DF$ID) + 1
	if (DF$Type[parent] < 10) {
	stop("non-gate connection requested")
	}
	if (!DF$MOE[parent] == 0) {
	stop("connection cannot be made to duplicate nor source of duplication")
	}
	
	if(any(DF$Type<4)|| any(DF$Type>12)) {
		stop("non-repairable system event called for in repairable model")
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
	condition = 0
	if (DF$Type[parent] > 11) {
		if (length(which(DF$CParent == at)) == 0) {
			condition = 1
		}else {
			if (length(which(DF$CParent == at)) > 1) {
			stop("connection slot not available")
			}
		}
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
		Repairable = 0,
		Interval = Tao,
		Tag_Obj = tag,
		Name = name,
		Name2 = name2,
		Description = description,
		Unused1 = "",
		Unused2 = "")

	DF <- rbind(DF, Dfrow)
	DF
	}
