addDuplicate<-function(DF, at, dup_id=NULL, dup_of=NULL, display_under=NULL)  {
	if(!test.ftree(DF)) stop("first argument must be a fault tree")

	at <- tagconnect(DF, at)
	
## tagconnect does not address problems of display_under an MOE
#		if(!is.null(display_under))  {
#		display_under<-tagconnect(DF,display_under)
#	}

## introducing a slight language hint for tag based node identification
	if(is.null(dup_id) && is.null(dup_of)) {
	stop("must identify source node of duplication.")
	}
	if(!is.null(dup_id))  {
		dup_id<-tagconnect(DF, dup_id, source=TRUE)
	}else{
# The entry must have been made using the dup_of argument
		dup_id<-tagconnect(DF, dup_of, source=TRUE)
	}

## parent qualification test only required once
	parent<-which(DF$ID== at)
	if(length(parent)==0) {stop("connection reference not valid")}
	dup_row<-which(DF$ID==dup_id)
	if(length(dup_row)==0) {stop("duplication  reference not valid")}
	thisID<-max(DF$ID)+1
	if(DF$Type[parent]<10) {stop("non-gate connection requested")}

	if(!DF$MOE[parent]==0) {
		stop("connection cannot be made to duplicate nor source of duplication")
	}

	if(DF$Type[parent]==15) {
	stop("duplicate not allowed as Combination Gate feed")
	}


## There is no need to limit connections to OR gates for calculation reasons
## Since AND gates are calculated in binary fashion, these too should not require a connection limit
## All specialty gates must be limited to binary feeds only

	condition=0
	if(DF$Type[parent]>11&& DF$Type[parent]<15 )  {
		if(length(which(DF$CParent==at))>1)  {
		stop("connection slot not available")
		}
		if( length(which(DF$CParent==at))==0)  {
			if(DF$Cond_Code[parent]<10)  {
				condition=1
			}
		}else{
##  length(which(DF$CParent==at))==1
			if(DF$Cond_Code[parent]>9)  {
				condition=1
			}
		}
	}

	dup_row<-which(DF$ID==dup_id)
	rows2copy<-dup_row
	nodes2check<-dup_row
	## separate the MOB case from MOE
	if(DF$Type[dup_row]>9)  {

	while(length(nodes2check) >0)  {

		child_nodes<- which(DF$CParent==DF$ID[nodes2check[1]])
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
#	offset_base<-DF$CParent[rows2copy[1]]
	id_offset<-thisID-dup_id

	for(x in 1:length(rows2copy))  {
		dup_row<-rows2copy[x]
		if(x==1) {
			cparent_id<- at
			cond_val<-condition
			gparent_id<- at
## It would take considerable testing to determine that this duplicate
## as a single entry should be displayed under a previous duplicate
## because the duplicated entry was also displayed under this same sibling
###########################################################################
## Let's try anyhow, if this is MOE only
			if(length(rows2copy)==1)  {
				if(length(display_under)!=0)  {
					if(DF$Type[parent]!=10) {stop("Component stacking only permitted under OR gate")}
					## test for a character object in display under and interpret here
					if (is.character(display_under) & length(display_under) == 1) {
						# display_under argument is a string
						siblingDF<-DF[which(DF$CParent==DF$ID[parent]),]
						display_under<-siblingDF$ID[which(siblingDF$Tag_Obj==display_under)]
					}
					if(!is.numeric(display_under)) {
					stop("display under request not found")
					}


## now resume rest of original display under code with display_under interpreted as an ID
					if(DF$CParent[which(DF$ID==display_under)]!=at) {stop("Must stack at component under same parent")}
					if(length(which(DF$GParent==display_under))>0 )  {
						stop("display under connection not available")
					}else{
						gparent_id<-display_under
					}
				}			
			}
##########################################################################			
			
		}else{
			cparent_id<-DF$CParent[dup_row]+id_offset
			gparent_id<-DF$GParent[dup_row]+id_offset
			cond_val<-DF$Condition[dup_row]
		}
## Using modifier on parent_row label, since it was unfortunately used before
##		this_parent_row<-which(DF$ID==cparent_id)


	## just in case we are duplicating a previously duplicated item
	if(DF$MOE[dup_row]>0) {
		moe<-DF$MOE[dup_row]
	}else{
		moe<-DF$ID[dup_row]
	}


		Dfrow<-data.frame(
			ID=	DF$ID[dup_row]+id_offset	,
			GParent=	gparent_id	,
			CParent=	cparent_id	,
			Level=	DF$Level[parent]+1	,
			Type=	DF$Type[dup_row]	,
			CFR=	DF$CFR[dup_row]	,
			PBF=	DF$PBF[dup_row]	,
			CRT=	DF$CRT[dup_row]	,
			MOE=	moe	,
			Condition=	cond_val,
			Cond_Code=	DF$Cond_Code[dup_row]	,
			EType=	DF$EType[dup_row]	,			
			P1=	DF$P1[dup_row]	,
			P2=	DF$P2[dup_row]	,
			Tag_Obj=	DF$Tag_Obj[dup_row]	,
			Name=	DF$Name[dup_row]	,
			Name2=	DF$Name2[dup_row]	,
			Description=	DF$Description[dup_row]	,
			UType=	DF$UType[dup_row]	,
			UP1=	DF$UP1[dup_row]  ,
			UP2=	DF$UP2[dup_row]	
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
