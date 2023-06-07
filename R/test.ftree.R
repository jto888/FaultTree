test.ftree<-function(DF) {
	if(!inherits(DF,"data.frame")) {
		return(FALSE)
	}else{
	if(length(names(DF))!=23)  {
		return(FALSE)
		}else{
			ftreetest<-NULL
			for(nm in 1:21) {ftreetest<-c(ftreetest,names(DF)[nm]==FT_FIELDS[nm])}
			if(!all(ftreetest)) {
				return(FALSE)
			}else{
				return(TRUE)
			}
		}
	}
}
