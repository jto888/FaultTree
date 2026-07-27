ftree2html<-function(DF,dir="", write_file=TRUE){
	long_text1 <- "NOTE: Original example code presented for about a decade utilizing a combination of ftree2html followed by browseURL has been depreciated. The original ftree2html function wrote its file to the user workspace; a violationof CRAN policy." 
	long_text2 <- "The current approach is to call ftree.display. This new function appropriately writes to and reads from the tempdir, which is generated upon each R session."
	wrapped_text1 <- strwrap(long_text1, width = 60)
	print(wrapped_text1)
	print("")
	wrapped_text2 <- strwrap(long_text2, width = 60)
	print(wrapped_text2)
}

