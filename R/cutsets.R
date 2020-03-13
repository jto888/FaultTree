cutsets<-function(DF, ft_node=1, method="mocus", by="tag")  {				
				
	 if(any(DF$Type==16)) {			
		stop("useer must expand 'atleast' gate in ftree model")		
	}			
## pre-processing should be considered to expand 'atleast' gates automatically				
## pre-processing should resolve vote and alarm gates as modules				
## no warning should be necessary for inhibit and priority gates				
				
	ftree.validate(DF)			
				
				
if(DF$Type[ft_node] < 10)  stop("ft_node must be a gate")				
				
chars_in<-DF$Tag				
## DF$MOE now provided for cpp import, uncertainty removed				
ints_in<-c(DF$ID, DF$Type, DF$CParent, DF$MOE, DF$EType)				
## DF$CFR & DF$CRT removed from import				
nums_in<-c( DF$PBF, DF$P1, DF$P2)				
 				
if(tolower(by)%in% c("tag","tags")) {				
	out_form<-1 			
}else{				
if(tolower(by)%in% c("id","ids")) {				
	out_form<-0			
}else{				
	stop(paste0("'by' argument ", by, " is not recognized"))			
}}				
				
if(tolower(method)=="mocus")  {				
##ret<-.Call( "mocus", chars_in, ints_in, nums_in, ft_node, out_form, PACKAGE = "FaultTree" )	
ret<-.Call( mocus, chars_in, ints_in, nums_in, ft_node, out_form)				
}else{				
if(tolower(method)=="prime-implicants")  {				
##ret<-.Call( "prime_implicants", chars_in, ints_in, nums_in, ft_node, out_form, PACKAGE = "FaultTree" )		
ret<-.Call( prime_implicants, chars_in, ints_in, nums_in, ft_node, out_form)		
}else{				
stop(paste0("method ", method, " not recognized"))				
}}				
				
	if(class(ret)=="list" && class(ret[[1]])=="matrix" && is.vector(ret[[2]]) && nrow(ret[[1]])==length(ret[[2]]) ) {			
## ret will be a list with single matrix of tag strings and a vector  of order values 				
		tagmat<-ret[[1]]		
		orders<-ret[[2]]		
## create an empty list at size of max(orders)				
		cs_list<-list(NULL)		
		if(max(orders)>1)  {		
			for(len in 2:max(orders))  {	
				cs_list<-c(cs_list, list(NULL))
			}	
		}		
## unpack the returned  matrix into the cs_list				
		for(cs_order in 1:max(orders) )  {		
			ov<-which(orders == cs_order)	
			if(length(ov)>0)  {	
				cs_list[[cs_order]]<-tagmat[ov, 1:cs_order]
			}	
		}		
		return(cs_list) 		
	}else{			
		return(ret)		
	}			
}				
