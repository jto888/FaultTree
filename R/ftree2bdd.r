ftree2bdd<-function(DF, ft_node=1)  {
	ftree.validate(DF)	

if(DF$Type[ft_node] < 10)  stop("ft_node must be a gate")

				
chars_in<-DF$Tag										
ints_in<-c(DF$ID, DF$Type, DF$CParent, DF$MOE, DF$EType)				
nums_in<-c( DF$PBF, DF$P1, DF$P2)	
  
##ret<-.Call( "get_bdd", chars_in, ints_in, nums_in, ft_node=1, PACKAGE = "FaultTree" )
ret<-.Call( get_bdd, chars_in, ints_in, nums_in, ft_node=1)

ret
}
