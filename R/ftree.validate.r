ftree.validate<-function(DF, analysis="mocus", ft_node=1) {					
## initial validation code suitable for cutsets and bdd calls on C++			

## this test could be commented out for testing without FaultTree package installed					
  if(!FaultTree::test.ftree(DF)) stop("first argument must be a fault tree")					
					
## test that there are no empty gates, all tree leaves must be basic component events					
## Identify gates and events by ID					
	gids<-DF$ID[which(DF$Type>9)]				
	pids<-DF$CParent				
	if(length(setdiff(gids, pids))>0) {				
	stop(paste0("no children at gate(s) ID= ", setdiff(gids, pids)))				
	}				
					
	if(!ft_node %in% gids) stop("ft_node is not a gate")				

	if(	analysis=="scram")  {
		if(any(DF$Type==13) || any(DF$Type==15)) {				
		stop("ALARM, and VOTE gates are not implemented for scram calls")				
		}				
	}else{
		if(any(DF$Type==13) || any(DF$Type==15) || any(DF$Type==16)) {				
		stop("ALARM, VOTE, and atLeast gates are not implemented for cutsets calls")				
		}
	}	
	if(any(DF$Type==14) ) {				
	warning("PRIORITY gates are implemented as AND gates in cutsets calls")				
	}				
	if(any(DF$Type==3)) {				
	stop("Pure Demand event not implemented for cutsets calls")				
	}				
##  issue warning if default tags must be issued.					
	if(any(DF$Tag[which(DF$Type<9)]=="")) {				
	warning("Not all basic-events have tags, defaults applied")				
	}				

					
## mission time validation is only applicable to SCRAM processing	
if(analysis=="scram") {		
## Validate mission_time setting for application of Active or Latent events			

	mt<-DF$P2[which(DF$ID==min(DF$ID))]		
	if(!mt>0 && (any(DF$Type==1) || any(DF$Type==2))) {		
		warning("mission_time not avaliable for application on Active or Latent events,  continuous RAM has been assumed")	
	}		
## This warning should never be seen Note: DF$Type==5 with DF$EType==1 might have exposure time override			
	if(!mt>0 && any(DF$Type==5)) {		
		warning("mission_time not avaliable for exposed events, default 10,000 has been applied")	
	}		
}		
					
## must assure that all tags are filled with unique strings					
## MOE/MOB elements and gates must use source tags 					
	if(any(DF$Tag=="")) {					
		blank_tags<-which(DF$Tag=="")				
		for(df_row in blank_tags) {				
## MOE sources are designated -1, while no MOE involvement designated as 0					
			if(DF$MOE[df_row]<1) {			
				if(DF$Type[df_row]>9) {		
					DF$Tag[df_row]=paste0("G_",DF$ID[df_row])	
				}else{		
					if(DF$Type[df_row]==9) {	
						DF$Tag[df_row]=paste0("H_",DF$ID[df_row])
					}else{	
						DF$Tag[df_row]=paste0("E_",DF$ID[df_row])
					}	
				}		
			}else{			
## now need the else block for MOE/MOB					
				DF$Tag[df_row]=DF$Tag[which(DF$ID==DF$MOE[df_row])]		
			}			
		}				
	}
}					
