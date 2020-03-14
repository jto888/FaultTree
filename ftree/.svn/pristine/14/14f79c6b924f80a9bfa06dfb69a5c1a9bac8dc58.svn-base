## scram.uncertainty
# Copyright 2017 OpenReliability.org
#
# Acquisition of uncertainty analysis results from SCRAM program http://scram-pra.org/
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
scram.uncertainty<-function(DF, ntrials=1000, nbin=20, show=c(FALSE, FALSE))  {
  if(!FaultTree::test.ftree(DF)) stop("first argument must be a fault tree")
  
## Test that uncertainty exists
  if(sum(DF$UType)==0) {
  stop("No uncertainty definition has been applied")
  }

  DFname<-paste(deparse(substitute(DF)))
  
	arg3<-""
	mt<-DF$P2[which(DF$ID==min(DF$ID))]
	if(!mt>0 && (any(DF$Type==1) || any(DF$Type==2) || any(DF$EType==2))) {
			stop("mission_time not avaliable for application on Weibull, Active or Latent events")
	}
	mtime<-""
	if(mt>0) {
		mtime<-paste0(" --mission-time ",mt)
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
  ## test for INHIBIT and warn about conversion to AND
  
  trials<-paste0(" --num-trials ",ntrials)
  bins<-paste0("  --num-bins ", nbin," --num-quantiles ", nbin)
  arg3<-paste0(trials,bins,mtime)

  do.call("ftree2mef",list(DF,DFname,"",TRUE))
    
  mef_file<-paste0(DFname,'_mef.xml')
if(file.exists(mef_file)) {
  do.call("callSCRAM",list(DFname,"uncertainty", " 1", arg3))
}else{
  stop(paste0("mef file does not exist for object ",DFname))
}

  scram_file<-paste0(DFname,'_scram_uncertainty.xml')
  if(file.exists(scram_file)) {
    outList<-readSCRAMuncertainty(scram_file, show=show)
  }else{
    stop(paste0(scram_file, " does not exist"))
  }
  
  
  	outList
}