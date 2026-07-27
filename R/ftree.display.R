ftree.display<-function(DF) {
	if(!test.ftree(DF)) stop("first argument must be a fault tree")
	DFname<-paste(deparse(substitute(DF)))
	ftree2html2(DF, DFname=DFname, write_file=TRUE)
	
	
	file_name<-paste0(DFname,".html")
#browser()	
	target_path <- file.path(tempdir(), file_name)

	utils::browseURL(target_path)

}
