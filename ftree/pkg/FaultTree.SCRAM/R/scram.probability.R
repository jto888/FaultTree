## scram.probability
# Copyright 2017 OpenReliability.org
#
# Acquisition of exact probability calculation from SCRAM program http://scram-pra.org/
# by means of temporary writing of SCRAM input and output files.
# 
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##
scram.probability<-function(DF, method="bdd", list_out=FALSE)  {
  if(!FaultTree::test.ftree(DF)) stop("first argument must be a fault tree")
  
  DFname<-paste(deparse(substitute(DF)))
 
	arg3<-""
	mt<-DF$P2[which(DF$ID==min(DF$ID))]
	if(!mt>0 && (any(DF$Type==1) || any(DF$Type==2))) {
			stop("mission_time not avaliable for application on Active or Latent events")
	}
	if(mt>0) {
		arg3<-paste0(" --mission-time ", mt)
	}

  

  ## test for gates alarm, vote, fail for now as not implemnted  
  ## test for pure demand fail if found
  ## test that there are no empty gates, all tree leaves must be basic component events
  ## Identify gates and events by ID
	gids<-DF$ID[which(DF$Type>9)]
	pids<-DF$CParent
	if(length(setdiff(gids, pids))>0) {
	stop(paste0("no children at gate(s) ID= ", setdiff(gids, pids)))
	}
  ## test for gates priority, alarm, vote, fail for now as not implemnted
   if(any(DF$Type==13) || any(DF$Type==15)) {
  stop("ALARM, and VOTE gates are not supported in SCRAM calls")
  }
  ## test for pure Demand
  if( any(DF$Type==3)) {
  stop("Pure Demand event type is not supported in SCRAM calls")
  } 
  ## test for PBF value in all basic component events (except Dynamic) - fail if not all >0
  ## ASSUME THAT DYNAMIC EVENTS WILL BE TYPE= 9
  event_probs<-DF$PBF[which(DF$Type<9)]
  if(any(event_probs<=0)) {
	stop("incomplete basic-event probability data in model")
   }
  
  ## it is possible that Dynamic components will have probability generated within SCRAM
    #ToDo??
  ## test for inhibit and warn about conversion to and

  do.call("ftree2mef",list(DF,DFname,"",TRUE))
  

    
  mef_file<-paste0(DFname,'_mef.xml')
if(file.exists(mef_file)) {
  do.call("callSCRAM",list(DFname,"probability", " 1", arg3))
}else{
  stop(paste0("mef file does not exist for object ",DFname))
}

  scram_file<-paste0(DFname,'_scram_probability.xml')
  if(file.exists(scram_file)) {
    prob_list<-readSCRAMprobability(scram_file)
  }else{
    stop(paste0(scram_file, " does not exist"))
  }
  
if(!tolower(method) %in% c("bdd", "mcub"))  stop(paste0("method ", method, " is not recognized"))
if(method == "mcub")  {  
mcub = 1-(prod(1-prob_list[[2]][4]))
 if(list_out==TRUE) {
	prob_list[[1]]<-mcub
	return(prob_list)
 }else{
	return(mcub)
 }
}else{ 

 if(list_out==TRUE) {
	return(prob_list)
 }else{
	return(prob_list[[1]])
 } 
} 

}