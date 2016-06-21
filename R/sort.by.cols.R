sort.by.cols<-function(x, cols=NULL, na.last = FALSE, decreasing = FALSE) {		
		
	if(length(dim(x))<2)  {	
		stop("must provide a dataframe or matrix with more than one column")
	}	
		
	if(length(cols)==0)  {	
		cols<-seq(1:dim(x)[2])
	}	
	
			
	col_arg<-NULL	
	for(col in cols)  {	
		col_arg<-paste0(col_arg, paste0("x[,",col,"],"))
	}	
		
sort_string<-paste0("x[order(", col_arg, "na.last=",na.last,",decreasing=",decreasing,"),]" )		
		
	x.sorted<-eval(parse(text=sort_string))	
x.sorted
}		
