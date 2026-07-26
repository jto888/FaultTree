ftree.display<-function(DF) {
	DFname<-paste(deparse(substitute(DF)))
	file_name<-paste0(DFname,".html")	
	target_path <- file.path(tempdir(), file_name)
## NEED TO TRAP ERROR THAT FILE DOES NOT EXIST	
	if(file.exists(target_path) {
		utils::browseURL(target_path)
	}else{
		stop(paste0("html file has not been created for ",DFname)
	}
}
