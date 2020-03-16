# hierarchyDF2json.R
# Author: Jacob Ormerod
# Copyright (c) OpenReliability.org 2016

# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 3, or (at your option) any
# later version.
#
# These functions are distributed in the hope that they will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, a copy is available at
#  http://www.r-project.org/Licenses/
#
# The function hierarchyDF2json provides a generalized conversion of a flat-table dataframe
# holding hierarchal data to a nested json formatted string. Considerable attention was given
# to making this as flexible as possible, while providing a robust solution.


hierarchyDF2json<-function(DF,id.col=1, parent.col=2, data.col=NULL,
	  children.key="children", keys.tolower=TRUE, reverse_child_order=FALSE,
	dir="", write_file=FALSE )  {

## Must capture the DF name before it may be altered
	DFname<-paste(deparse(substitute(DF)))

## handle certain arguments right away
	if(is.character(id.col)) {
		if(length(which(names(DF)==id.col))!=1) {
			stop("id.col invalid")  }
		id.col<-which(names(DF)==id.col)
	}
	if(is.character(parent.col)) {
		if(length(which(names(DF)==parent.col))!=1) {
			stop("parent.col invalid")  }
		parent.col<-which(names(DF)==parent.col)
	}

	if(length(data.col)==0) { data.col<-c(1:dim(DF)[2]) }
	if(keys.tolower==TRUE) { names(DF)<-tolower(names(DF)) }

## validate id's and parents
	if(length(unique(DF[,id.col]))!=length(DF[,id.col])) {
		stop("id.col not unique")  }
	if(length(intersect(DF[,id.col], unique(DF[-1,parent.col])))!=length(unique(DF[-1,parent.col])))  {
		stop("all parents beyond root are not in id.col")  }

## the DF passed in could be a subview or result of some kind of special odering
## we need row numbers to progressively ascend from 1
	row.names(DF)<-c(1:dim(DF)[1])

## Build the children object as a list of vectors holding the row numbers of children for each node
## leaf nodes, having no children, must appear as NULL list items, having zero length.
	children<-list(NULL)
	for(node in 1:dim(DF)[1])  {
		if(length(which(DF[,parent.col]==DF[node,id.col]))>0)  {
			children<-c(children,list(which(DF[,parent.col]==DF[node,id.col])))
		}else{
			children<-c(children,list(NULL))
		}
	}
## remove the initializer element
	children<-children[-1]

## reverse the order of children, if called for
	if(reverse_child_order==TRUE)  {
		for(node in 1:length(children)) {
			if(!is.null(children[[node]]))  {
			children[[node]]<-rev(children[[node]])
			}
		}
	}

## This is the main json builder algorithm
## start by writing out the root node
## Column name would be lost if only passing single element DF, hence key names are passed separately here
	outstring<-node_data(DF[1,data.col], names(DF)[data.col])
## a single node is done now, stop evaluation otherwise it would break code
	if(dim(DF)[1]>1) {
## initialize the evaluation pointer
	eval<-data.frame(node=1, pos=1)

## The loop termnates when there are no more nodes to evaluate
while(length(eval[,1])>0)  {
## evaluation proceeds with the last pointer
	this_eval<-dim(eval)[1]
## as long as there is a child here we are in  business
	if(eval$pos[this_eval]<=length(children[[eval$node[this_eval]]]))  {

## if this is the first child handled for this node, provide the children key
	if(eval$pos[this_eval]==1)  {
		outstring<-paste0(outstring,'"',children.key,'":[')
	}
## provide the data for this child node
	child_node<-children[[ eval$node[this_eval] ]] [eval$pos[this_eval]]
	outstring<-paste0(outstring, node_data(DF[child_node, data.col],names(DF)[data.col]))


## increment the child position for  the next evaluation on this node
	eval$pos[this_eval]<-eval$pos[this_eval]+1
## add this child  node to the evaluation dataframe as a new potential parent
	eval<-rbind(eval, data.frame(node=child_node, pos=1))





	}else{
## we have come to the end of a node that has no children or no more children

## remove the last comma, if there
		testchar<-substring(outstring,nchar(outstring))
		if(testchar=="," )  {
		  	 outstring <- substring(outstring, 1, nchar(outstring) - 1)
		}


## remove the last row of the  evaluation dataframe
		eval<-eval[-dim(eval)[1],]


## as long as the loop hass not been completed, there are closing notations to apply
		if(length(eval[,1])>0)  {
## peek ahead at next evaluation
			next_eval<-dim(eval)[1]
## if the last entry was not the last child, close the child only
			if(eval$pos[next_eval]<=length(children[[eval$node[next_eval]]]))  {
			outstring<-paste0(outstring, "},")
			}else{
## else, close the child and children array
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

## the DFname had to be captured early in code, before any alterations to DF
	if(write_file==TRUE)  {
		##DFname<-paste(deparse(substitute(DF)))

		file_name<-paste0(dir,DFname,".json")

		eval(parse(text=paste0('write(outstring,"',file_name,'")')))

	}


	outstring
}



## The 'key' argument is required since a single element dataframe or list will lose name information

node_data<-function(node, key)  {
 	nodestring<-"{"

if(length(node)==1)  {
	nodestring<-paste0(nodestring,'"',key[1],'":')
	if(is.numeric(node)) {
		nodestring<-paste0(nodestring, node)
	}else{
		nodestring<-paste0(nodestring,'"', node,'"')
	}
## always add the comma, delete when found to be at end of json elements
	nodestring<-paste0(nodestring, ",")


}else{
for( i in 1:length(node))  {
	nodestring<-paste0(nodestring,'"',key[i],'":')
	if(is.numeric(node[1,i])) {
		nodestring<-paste0(nodestring, node[1,i])
	}else{
		nodestring<-paste0(nodestring,'"', node[1,i],'"')
	}
## always add the comma, delete when found to be at end of json elements
	nodestring<-paste0(nodestring, ",")
}
}
nodestring
}

