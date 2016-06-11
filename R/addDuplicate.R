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
					
	## separate the MOB case from MOE				
	if(DF$Type[dup_row]>9)  {				
					
	parent_row<-dup_row				
	child_col<-8				
					
	while(length(parent_row)>0)  {				
	## establish the ID value of the last parent_row and child_col  entries				
		this_dup_id<-DF[parent_row[length(parent_row)], child_col[length(child_col)]]			
					
		if(this_dup_id>0)   {			
					
	##  the row holding this ID is next to be copied				
			this_dup_row<-which(DF$ID==this_dup_id)		
			rows2copy<-c(rows2copy, this_dup_row)		
					
	## The last child_col entry needs to be incremented for next time this parent is evaluated for children.				
			child_col[length(child_col)]<-child_col[length(child_col)]+1		
					
			parent_row<-c(parent_row, this_dup_row)		
			child_col<-c(child_col, 8)		
					
		}else{			
	## This is the end of children for this parent or it was just an event.				
					
	## place a stop if an empty gate has been detected				
		if(child_col[length(child_col)]==8 && DF$Type[parent_row[length(parent_row)]]>9)  {			
			stop("Attempted copy of branch with empty gate ")		
		}			
					
	## delete the last parent_row and child_col entries				
			parent_row<-parent_row[-length(parent_row)]		
			child_col<-child_col[-length(child_col)]		
					
		}			
	## close the while loop				
	}
## The search algorithm for child nodes in a branch can reorder nodes from their
## original input order, although not necessarily thier graphic position order.
## During development it was  necessary to sort the nodes 2copy vector due to bugs
## in the original ftree2json code that depended on rows same as ID's (due only to confusion).
## this has been corrected in both ftree2json and specifically in hierarchyDF2json
## but it may still be found wise to sort at this location in the future.
#	rows2copy<-rows2copy[order(rows2copy)]

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
## These Child column manipulations are all to disappear					
	if(DF$Child1[dup_row] > 0) {				
		child1<-DF$Child1[dup_row]-id_offset			
	}else{	child1<- -1  }			
	if(DF$Child2[dup_row] > 0) {				
		child2<-DF$Child2[dup_row]-id_offset			
	}else{	child2<- -1  }			
	if(DF$Child3[dup_row] > 0) {				
		child3<-DF$Child3[dup_row]-id_offset			
	}else{	child3<- -1  }			
	if(DF$Child4[dup_row] > 0) {				
		child4<-DF$Child4[dup_row]-id_offset			
	}else{	child4<- -1  }			
	if(DF$Child5[dup_row] > 0) {				
		child5<-DF$Child5[dup_row]-id_offset			
	}else{	child5<- -1  }			
					
		Dfrow<-data.frame(			
			ID=	thisID	,
			Name=	DF$Name[dup_row]	,
			Parent=	parent_id	,
			Type=	DF$Type[dup_row]	,
			CFR=	DF$CFR[dup_row]	,
			PBF=	DF$PBF[dup_row]	,
			CRT=	DF$CRT[dup_row]	,
			Child1=	child1	,
			Child2=	child2	,
			Child3=	child3	,
			Child4=	child4	,
			Child5=	child5	,
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
					
	thisID<-thisID+1				
	## close the for loop				
	}				
					
return(DF)					
}					
