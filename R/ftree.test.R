ftree.test<-function(DF) {			
	if(class(DF)!="data.frame") {		
		return(FALSE)	
	}else{		
	if(length(names(DF))!=19)  { 		
		return(FALSE)	
		}else{		
			ftree_test<-NULL	
			for(nm in 1:19) {ftree_test<-c(ftree_test,names(DF)[nm]==FT_FIELDS[nm])}	
			if(!all(ftree_test)) {	
				return(FALSE)
			}else{	
				return(TRUE)
			}	
		}	
	}		
}			
			
