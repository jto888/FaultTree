addDuplicate<-function(DF, at, dup_id)  {					
	if(!ftree.test(DF)) stop("first argument must be a fault tree")				
					
## parent qualification test only required once					
	parent<-which(DF$ID== at)				
	if(length(parent)==0) {stop("connection reference not valid")}				
	dup_row<-which(DF$ID==dup_id)				
	if(length(dup_row)==0) {stop("duplication  reference not valid")}				
	thisID<-max(DF$ID)+1				
	if(DF$Type[parent]<10) {stop("non-gate connection requested")}				
					
#	availableconn<-which(DF[parent,8:12]<1)				
#	if(length(availableconn)>3) {				
#		DF[parent,(7+availableconn[1])]<-thisID			
#	}else{				
#		if((DF$Type[parent]==10||DF$Type[parent]==11)&&length(availableconn)>0)  {			
#			DF[parent,(7+availableconn[1])]<-thisID		
#		}else{			
#			stop("connection slot not available")		
#		}			
#	}				
					
## There is no need to limit connections to OR gates for calculation reasons					
## Since AND gates are calculated in binary fashion, these too should not require a connection limit					
## All specialty gates must be limited to binary feeds only					
					
	if(DF$Type[parent]>11 && length(which(DF$Parent==at))>1) {				
		stop("connection slot not available")			
	}				
					
					
	dup_row<-which(DF$ID==dup_id)				
	rows2copy<-dup_row				
	nodes2check<-dup_row				
	## separate the MOB case from MOE				
	if(DF$Type[dup_row]>9)  {				
					
	while(length(nodes2check) >0)  {				
					
		child_nodes<- which(DF$Parent==DF$ID[nodes2check[1]])			
		if(length(child_nodes)>0) {			
			rows2copy<-c(rows2copy, child_nodes)		
			nodes2check<-c(nodes2check, child_nodes)		
		}else{			
			if( DF$Type[nodes2check[1]]>9)  {		
				stop("Attempted duplication of branch with empty gate ")	
			}		
		}			
	#  remove last checked node from nodes2check vector				
		nodes2check<-nodes2check[-1]			
					
	## close the while loop				
	}				
			
					
		## close the MOB case			
	}				
					
	## prepare an offset for relative node determinations				
#	offset_base<-DF$Parent[rows2copy[1]]				
	id_offset<-thisID-dup_id				
					
	for(x in 1:length(rows2copy))  {				
		dup_row<-rows2copy[x]			
		if(x==1) {			
			parent_id<- at		
		}else{			
			parent_id<-DF$Parent[dup_row]+id_offset		
		}			
## Using modifier on parent_row label, since it was unfortunately used before					
		this_parent_row<-which(DF$ID==parent_id)			
					
					
	## just in case we are duplicating a previously duplicated item				
	if(DF$MOE[dup_row]>0) {				
		moe<-DF$MOE[dup_row]			
	}else{				
		moe<-DF$ID[dup_row]			
	}				
		
					
		Dfrow<-data.frame(			
			ID=	DF$ID[dup_row]+id_offset	,
			Name=	DF$Name[dup_row]	,
			Parent=	parent_id	,
			Type=	DF$Type[dup_row]	,
			CFR=	DF$CFR[dup_row]	,
			PBF=	DF$PBF[dup_row]	,
			CRT=	DF$CRT[dup_row]	,
			Child1=	-1	,
			Child2=	-1	,
			Child3=	-1	,
			Child4=	-1	,
			Child5=	-1	,
			Level=	DF$Level[parent]+1	,
			MOE=	moe	,
			PHF_PZ=	DF$PHF_PZ[dup_row]	,
			Repairable=	DF$Repairable[dup_row]	,
			Interval=	DF$Interval[dup_row]	,
			Name2=	DF$Name2[dup_row]	,
			Description=	DF$Description[dup_row]	
			)		
					
		DF<-rbind(DF, Dfrow)			
					
					
	## set a flag indicating source of duplication				
	if(DF$MOE[dup_row]==0) {				
		DF$MOE[dup_row]<- -1			
	}				
					
					
	## close the for loop				
	}				
					
return(DF)					
}					
