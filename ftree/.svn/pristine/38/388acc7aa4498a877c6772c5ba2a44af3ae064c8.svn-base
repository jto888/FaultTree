addControl<-function(DF, at, prob, severity, name="", description="", overwrite=FALSE)  {					
	if(!etree.test(DF)) stop("first argument must be an event tree")				
					
	if(!(prob>0 && prob<1))  {stop("probability entry error")}				
	parent<-which(DF$ID== at)				
	if(length(parent)==0) {stop("connection reference not valid")}				
	##if(!(prob<1&&severity<DF[parent,8])) {warning("A mitigating control has not reduced severity")}				
	if(!(severity<DF[parent,8])) {warning("A mitigating control has not reduced severity")}				
## available connections may yet become a validation test					
	availableconn<-which(is.na(DF[parent,9:13]))				
					
					
	if(!overwrite) {				
		thisID<-max(DF$ID)+1			
		DF[parent,(8+availableconn[1])]<-thisID			
## some variables for the hazard outcome generation					
		hazID<-thisID+1			
		hazprob<-1-prob			
		thisLevel<-DF$Level[parent]+1			
		parent_freq<-DF$Freq[parent]			
		parent_severity<-DF$Severity[parent]			
					
## write out the controlled case here, hazard case after close of conditional					
				 	
		Dfrow<-data.frame(			
			ID=	thisID	,
			Level=	thisLevel	,
			Name=	name	,
			Type=	"control"	,
			ParentID=	at	,
			Prob=	prob	,
			Freq=	DF$Freq[parent]*prob	,
			Severity=	severity	,
			Child1=	hazID	,
			Child2=	NA	,
			Child3=	NA	,
			Child4=	NA	,
			Child5=	NA	,
			Description=	description	
			)		
					
		DF<-rbind(DF,Dfrow)			
	}else{				
					
					
		if(DF[parent,3] != "hazard" && DF[parent,4] !="outcome") {			
			stop("overwrite only permitted on hazard outcome")		
		}			
## over-write the last hazard line entry with this new control case					
		row_num<-parent			
		thisID<-DF$ID[row_num]			
## set some variables for the hazard outcome entry					
		hazID<-max(DF$ID)+1			
		thisLevel<-DF$Level[row_num]			
		hazprob<-1-prob			
## these could be done more concisely, but let's avoid confusion here					
		parent_freq<-DF$Freq[row_num]			
		parent_severity<-DF$Severity[row_num]			
					
		## ID, Level, and ParentID  entries are already correct in DF[rownum,]			
		DF$Name[row_num]<-name			
		if(prob<1)  {			
			DF$Type[row_num]<-"control"		
		}			
		DF$Prob[row_num]<-prob			
		DF$Freq[row_num]<-parent_freq*prob			
		DF$Severity[row_num]<-severity			
		DF$Child1[row_num]<-hazID			
		DF$Description[row_num]<-description			
					
	}				
					
					
					
## now build the hazard outcome for this fractional outcome entry					
					
					
		Dfrow<-data.frame(			
			ID=	hazID	,
			Level=	thisLevel	,
			Name=	"hazard"	,
			Type=	"outcome"	,
			ParentID=	at	,
			Prob=	hazprob	,
			Freq=	parent_freq*hazprob	,
			Severity=	parent_severity	,
			Child1=	NA	,
			Child2=	NA	,
			Child3=	NA	,
			Child4=	NA	,
			Child5=	NA	,
			Description=	description	
			)		
					
		DF<-rbind(DF,Dfrow)			
					
					
					
	DF				
}					
