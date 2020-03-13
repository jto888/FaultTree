probability<-function(DF, ft_node=1, method="bdd")  {		
	ftree.validate(DF)	
		
	if(DF$Type[which(DF$ID==ft_node)] < 10)  stop("ft_node must be a gate")	
##	if(DF$Type[which(DF$ID==ft_node)] < 10) browser()
	
	chars_in<-DF$Tag	
	ints_in<-c(DF$ID, DF$Type, DF$CParent, DF$MOE, DF$EType)	
	nums_in<-c( DF$PBF, DF$P1, DF$P2)
	if(!tolower(method) %in% c("bdd", "mcub")) stop(paste0("method ", method, " is not recognized"))
	if(method=="bdd")  {	
		prob<-.Call( "probability", chars_in, ints_in, nums_in, ft_node, PACKAGE = "FaultTree" )
	}else{	
## leaving logical space for eventual mcub calculation		
		ret_list<-.Call( "mocus", chars_in, ints_in, nums_in, ft_node, 1,PACKAGE = "FaultTree" )
		prob<-ret_list[[3]]
	}	
prob		
}		
