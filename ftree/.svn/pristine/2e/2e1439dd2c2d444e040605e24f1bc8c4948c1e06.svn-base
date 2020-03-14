etree2json<-function(DF, data.col=c(3), dir="", write_file=FALSE )  {					
	if(!etree.test(DF)) stop("first argument must be an event tree")				
					
		outstring<-list_data(DF,row_num=1, data.col)			
	if(dim(DF)[1]>1) {				
		children<-DF[,9:13]			
					
		parent_row=1			
		## new parents start children at last one entered,to place on top or right of tree			
		num_children<-length(children[parent_row,!is.na(children[parent_row,])])			
		child_col=num_children			
					
	while(length(parent_row>0) ) {				
		this_row<-which(DF$ID==parent_row[length(parent_row)])			
			num_children<-5-length(children[this_row,is.na(children[this_row,])])		
			##num_children<-length(children[this_row,!is.na(children[this_row,])])		
			this_col<-child_col[length(child_col)]		
					
					
			if(this_col>0 ) {		
				## remove the the last child_col for this current parent	
				child_col[length(child_col)]<-this_col-1	
					
				if(num_children>0 && this_col==num_children ) {	
				outstring<-paste0(outstring,'"children":[')	
					
				}	
				child_ptr<-which(DF$ID==children[this_row,this_col])	
				outstring<-paste0(outstring,list_data(DF,row_num=child_ptr, data.col))	
					
					
				## add elements to the parent_row and child_col vectors for this new potential parent	
				parent_row<-c(parent_row,children[this_row,this_col])	
				## new parents always start children at last one entered	
				num_children<-5-length(children[parent_row[length(parent_row)],is.na(children[parent_row[length(parent_row)],])])	
				child_col<-c(child_col,num_children)	
					
			}else{		
				## we have come to the end of a data entry that has no children or no more children	
				## remove the last comma	
				## only if a comma was there	
				testchar<-substring(outstring,nchar(outstring))	
				if(testchar=="," )  {	
				outstring<-substring(outstring, 1, nchar(outstring)-1)	
				}	
					
				## reduce parent_row  and child_col vectors by one element	
				## to establish completion tests and in preparation for next pass of loop	
				parent_row<-parent_row[-length(parent_row)]	
				child_col<-child_col[-length(child_col)]	
					
				## this loop completion test prevents failure of child array test	
				if(length(child_col)>0 )  {	
					if(child_col[length(child_col)] >0 )  {
					## close data item only
					outstring<-paste0(outstring, "},")
					}else{
					## close the child and children array
					outstring<-paste0(outstring, "}]")
					}
				}	
			}		
					
					
	## end of while loop				
	}				
	## close multiple row test				
	}else{				
		## remove the last comma only if a comma was there			
		## required for single row case only			
		testchar<-substring(outstring,nchar(outstring))			
		if(testchar=="," )  {			
		outstring<-substring(outstring, 1, nchar(outstring)-1)			
		}			
	}				
					
	outstring<-paste0(outstring, "}")				
					
	if(write_file==TRUE)  {				
		DFname<-paste(deparse(substitute(DF)))			
					
		file_name<-paste0(dir,DFname,".json")			
					
		eval(parse(text=paste0('write(outstring,"',file_name,'")')))			
					
	}				
					
					
	outstring				
}					


list_data<-function(DF, row_num, columns)  {				
 	outstring<-"{"	
for( i in 1:length(columns))  {			
	outstring<-paste0(outstring,'"',tolower(names(DF)[columns[i]]),'":')	
	if(is.numeric(DF[row_num,columns[i]])) {	
		outstring<-paste0(outstring,DF[row_num,columns[i]])
	}else{	
		outstring<-paste0(outstring,'"',DF[row_num,columns[i]],'"')
	}	
## always add the comma, delete when found to be at end of json elements		
	outstring<-paste0(outstring, ",")	
}		
outstring		
}		
