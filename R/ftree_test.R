ftree_test<-function(DF) {
	if(class(DF)!="data.frame") {
		return(FALSE)
	}else{
	if(length(names(DF))!=19)  {
		return(FALSE)
		}else{
			ftreetest<-NULL
			for(nm in 1:19) {ftreetest<-c(ftree_test,names(DF)[nm]==FT_FIELDS[nm])}
			if(!all(ftreetest)) {
				return(FALSE)
			}else{
				return(TRUE)
			}
		}
	}
}
