## ftree2widget.R
## handle data with optional SVG parameters and prepare as list for htmlwidgets::createWidget function call
ftree2widget<-function(DF, height = NULL, width = NULL)  {
	if(!test.ftree(DF)) stop("first argument must be a fault tree")	

## Convert json formatted data to list format (so it can be converted back by htmlwidgets)
 root1 <- jsonlite::fromJSON(hierarchyDF2json(DF,data.col=c(1:14,16:17)), simplifyDataFrame = FALSE)
 root2 <- jsonlite::fromJSON(hierarchyDF2json(DF,data.col=c(1:15)), simplifyDataFrame = FALSE)
# * checking dependencies in R code ... WARNING
# '::' or ':::' import not declared from: 'jsonlite'
## root <- fromJSON(hierarchyDF2json(DF,data.col=c(1,5:10,13:17)), simplifyDataFrame = FALSE)
#* checking R code for possible problems ... NOTE
# ftree2widget: no visible global function definition for 'fromJSON'
## removed NOTE and WARNING from check --as-cran by importing jsonlite in DESCRIPTION (although it is 
## imported by htmlwidgets) and adding import(jsonlite,fromJSON) to NAMESPACE
## without re-importing jsonlite in DESCRIPTION the import in NAMESPACE  creates an ERROR
	if(any(DF$Name!="" || DF$Name2!="")) {
		# create widget1
		htmlwidgets::createWidget(
			name = "ftree_widget1",
			x = list(root=root1),
			width = width,
			height = height,
			htmlwidgets::sizingPolicy(padding = 10, browser.fill = TRUE),
			package = "FaultTree.widget"
		)
	}else{
		# create widget2
		htmlwidgets::createWidget(
			name = "ftree_widget2",
			x = list(root=root2),
			width = width,
			height = height,
			htmlwidgets::sizingPolicy(padding = 10, browser.fill = TRUE),
			package = "FaultTree.widget"
		)
	}	
}