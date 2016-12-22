cutsets<-function(DF)  {
	max_len<-length(which(DF$Type>10))

	cs_lists<-list(NULL)
	for(len in 2:max_len)  {
		cs_lists<-c(cs_lists, list(NULL))
	}



	child_rows<-which(DF$CParent==DF$ID[1])

# test for empty node gate
	if(length(child_rows)==0)  {
		stop("empty root node")
	}

## initialize a CS found list for future collection
	cs_found<-NULL

## initiate the algorithm by evaluation of root node type
	if(DF$Type[1]<10)  {
		stop("root node is not a gate")
	}

	if(DF$Type[1]==10)  {

## initiate the CS test list using this first child_rows vector
		cs_test<-as.list(child_rows)

	}else{
		cs_test<-list(child_rows)
	}

	eval_item<-1
	eval_pos<-1


	while(!eval_item>length(cs_test))  {


		while(eval_pos<=length(cs_test[[eval_item]]))  {

## This time if we find an element 'leaf' of tree we will do nothing
## Action is taken only on gates as found
			if(DF$Type[cs_test[[eval_item]][eval_pos] ] == 10)  {
				child_rows<-which(DF$CParent==DF$ID[cs_test[[eval_item]][eval_pos] ])
					if(length(child_rows)==0)  {
						stop(paste0("empty gate found at", as.character(DF$ID[cs_test[[eval_item]][eval_pos] ])))

					}

## remove the gate row we just found from the eval_item vector
				cs_vec<-cs_test[[eval_item]][-eval_pos]
##create new vectors to add as list items to cs
				for(item in 1:length(child_rows)) {
					cs_test<-c(cs_test, list(c(cs_vec, child_rows[item])))
				}
## delete the current eval_item (since it has been replaced on cs list with new items)
				cs_test<-cs_test[-eval_item]
## reset eval_pos back to 1, because same eval_item will now be a different vector
				eval_pos<-1
			}else{
				if(DF$Type[cs_test[[eval_item]][eval_pos] ] > 10)  {
					child_rows<-which(DF$CParent==DF$ID[cs_test[[eval_item]][eval_pos] ])
						if(length(child_rows)==0)  {
							stop(paste0("empty gate found at", as.character(DF$ID[cs_test[[eval_item]][eval_pos] ])))

						}

				## and gate elements must replace the cs_test[[eval_item]] [pos]
					cs_vec<-cs_test[[eval_item]][-eval_pos]
					cs_vec<-c(cs_vec, child_rows)
					cs_test[[eval_item]]<-cs_vec



				## eval_pos stays the same for next pass of loop

				}else{
## advance the eval_pos, we just passed a leaf element and might end the item while loop
					eval_pos<-eval_pos+1
				}
			}


		}
## we have just gotten to the end of an item vector that must all be components,

## use this opportunity in an existing loop to eliminate any duplicate factors in this vector
## Need to get the MOE or ID for each element of vector first then get unique
		id_vec<-NULL

## Need to get the MOE or ID for each element of vector
		for(item in 1:length(cs_test[[eval_item]]))  {
			if(DF$MOE[cs_test[[eval_item]][item]]>0) {
				id_vec<-c(id_vec, DF$MOE[cs_test[[eval_item]][item]])
			}else{
				id_vec<-c(id_vec, DF$ID[cs_test[[eval_item]][item]])
			}
		}
##  then get unique vectors, eliminating any duplication within the vector
		id_vec<-unique(id_vec)
## sort the vector as an aid to future algorithms
		id_vec<-id_vec[order(id_vec)]

		len<-length(id_vec)

		if(is.null(cs_lists[[len]])) {
			cs_lists[[len]]<-id_vec
		}else{
			cs_lists[[len]]<-rbind(cs_lists[[len]], id_vec)
		}


##  increment the eval_item, or move this item to a new object
		eval_item<-eval_item+1
## reset eval_pos to 1
		eval_pos<-1

## return to main while loop
	}


## reduce raw cut sets by unique vectors
	for(mat in 1:max_len)  {
		if(!is.null(cs_lists[[mat]]))  {
## sorting is likely unnecessary here, aided development
## but the matrix must have more than one column!
		if(length(mat)>1) {
			cs_lists[[mat]]<-sort.by.cols(cs_lists[[mat]])
		}
			cs_lists[[mat]]<-unique(cs_lists[[mat]])
		}
	}


## this is the generalized brute force algorithm  with 4 nested loops
	for(smat in 1:(max_len-1))  {
		if(!is.null(cs_lists[[smat]]))  {
		for( tmat in (smat+1):max_len)  {
			if(!is.null(cs_lists[[tmat]]))  {
				if(is.vector(cs_lists[[smat]]))  {
					smat_rows<-1
				}else{
					smat_rows<-dim(cs_lists[[smat]])[1]
				}

				for(source in 1:smat_rows)  {
				elim_rows<-NULL
## **************** edge cases error here if cs_lists[[tmat]] or cs_lists[[smat]] is a vector (dim will return NULL)
					if(is.vector(cs_lists[[tmat]])) {
						if(is.vector(cs_lists[[smat]]))  {
							if(length(intersect(cs_lists[[smat]][source], cs_lists[[tmat]][1]))==smat)  {
								cs_lists[[tmat]]<-c(0)
								break
							}
						}else{
							if(length(intersect(cs_lists[[smat]][source,], cs_lists[[tmat]][1]))==smat)  {
								cs_lists[[tmat]]<-c(0)
								break
							}
						}
					}else{
						for(target in 1:dim(cs_lists[[tmat]])[1])  {
							if(is.vector(cs_lists[[smat]]))  {
								if(length(intersect(cs_lists[[smat]][source], cs_lists[[tmat]][target,]))==smat)  {
									elim_rows<-c(elim_rows, target)
								}
							}else{
								if(length(intersect(cs_lists[[smat]][source,], cs_lists[[tmat]][target,]))==smat)  {
									elim_rows<-c(elim_rows, target)
								}
							}
						}

## the tmat can now be reduced for future iteration through source(s)
						if(length(elim_rows)>0)  {
							if(length(elim_rows)==length(cs_lists[[tmat]][1,]))  {
									 cs_lists[[tmat]]<-c(0)
							}else{
										elim_rows<- (-1)*elim_rows
										cs_lists[[tmat]]<-cs_lists[[tmat]][elim_rows,]
							}
						}
					}

## ready for next source item
				}
## Can't figure out why this only impacted last matrix
##				row.names(cs_lists[[tmat]])<-as.character(1:dim(cs_lists[[tmat]])[1])
			}
		}
		}
	}
	
## row names are all 'id_vec' at this point, so here is fix



	for(list_item in 1:length(cs_lists)) {
		if(!is.null(cs_lists[[list_item]]))  {
			len<-dim(cs_lists[[list_item]])[1]
			rchrs<-as.character(1:len)
			matrnms<-NULL
			for(nm in 1:len)  {
				thisnm<-paste0("[",rchrs[nm],",]")
				matrnms<-c(matrnms, thisnm)
			}

			row.names(cs_lists[[list_item]])<-matrnms
		}
	}

cs_lists
}
