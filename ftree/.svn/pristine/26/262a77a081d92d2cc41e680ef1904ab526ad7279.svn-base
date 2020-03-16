## ftree2mef
# Copyright 2017 OpenReliability.org
#
# Conversion of FaultTree data to Model Exchange Format in XML
# to enable input to packages conforming to the open-PRA initiative
# with specific interest in SCRAM http://scram-pra.org/
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

ftree2mef<-function(DF, DFname="", dir="", write_file=FALSE)  {
  if(!FaultTree::test.ftree(DF)) stop("first argument must be a fault tree")

## test that there are no empty gates, all tree leaves must be basic component events
## Identify gates and events by ID
	gids<-DF$ID[which(DF$Type>9)]
	pids<-DF$CParent
	if(length(setdiff(gids, pids))>0) {
	stop(paste0("no children at gate(s) ID= ", setdiff(gids, pids)))
	}

	if(any(DF$Type==13) || any(DF$Type==15)) {
	stop("ALARM, and VOTE gates are not implemented for SCRAM calls")
	}
	if(any(DF$Type==14) ) {
	warning("PRIORITY gates are implemented as AND gates in SCRAM calls")
	}
	if(any(DF$Type==3)) {
	stop("Pure Demand event not implemented for SCRAM calls")
	}
##  issue warning if default tags must be issued.
	if(any(DF$Tag[which(DF$Type<9)]=="")) {
	warning("Not all basic-events have tags, defaults applied")
	}

## Validate mission_time setting for application of Active or Latent events
	mt<-DF$P2[which(DF$ID==min(DF$ID))]
	if(!mt>0 && (any(DF$Type==1) || any(DF$Type==2))) {
		warning("mission_time not avaliable for application on Active or Latent events, SCRAM default has been applied")
	}
## This warning should never be seen Note: DF$Type==5 with DF$EType==1 might have exposure time override
	if(!mt>0 && any(DF$Type==5)) {
		warning("mission_time not avaliable for exposed events, SCRAM default has been applied")
	}

##  DF might be the DF object within the scram.cutsets environment
## in that event the DFname must be provided
 hold_name<-paste(deparse(substitute(DF)))
  if(DFname=="") {
## test and fail if hold_name=="DF" while no DFname provided
    if(hold_name=="DF"){
      stop("must provide DFname as an argument in any do.call function as done in scram.cutsets")
    }else{
        DFname<-hold_name
    }
  }

lb<-"\n"

## eids<-DF$ID[which(DF$Type<10)]
types<-NULL
for(gate in 1:length(gids)) {
	if(DF$Type[which(DF$ID==gids[gate])]==10) {
		chids<-DF$ID[which(DF$CParent==gids[gate])]
		if(length(chids)==1)  {
			types<-c(types,"passthrough")
		}else{	
			types<-c(types, "or")
		}
	}else{
		if(DF$Type[which(DF$ID==gids[gate])]==16) {
			types=c(types, "atleast")
		}else{
			types=c(types, "and")
		}
	}
}


	treeXML=""

	for(gate in 1:length(gids)) {
## cannot replicate MOB tags in mef, else get redifine gate error from scram
		if(DF$MOE[which(DF$ID==gids[gate])]<1)  {
		
## tagname at DF[which(DF$ID==min(DF$ID)),] is already set to "top"
## gates might now have tags issued.
#		if(gate==1) {
#			tagname="top"
#		}else{
			tagname<-DF$Tag[which(DF$ID==gids[gate])]
			if(tagname=="")  {
				tagname<-paste0("G_", gids[gate])
			}

			treeXML<-paste0(treeXML,'<define-gate name="',tagname, '">',lb)

			if(DF$Type[which(DF$ID==gids[gate])]==16) {
				p1<-DF$P1[which(DF$ID==gids[gate])]
				treeXML<-paste0(treeXML,'<',types[gate],' min="',p1,'">',lb)
			}else{
				if(types[gate]!="passthrough") {
					treeXML<-paste0(treeXML,'<',types[gate],'>',lb)
				}
			}

	## Define the children of this gate applying default tag names where needed
			chids<-DF$ID[which(DF$CParent==gids[gate])]

			for(child in 1:length(chids)) {
				tagname<-DF$Tag[which(DF$ID==chids[child])]
				if(DF$Type[which(DF$ID==chids[child])]>9) {
					if(tagname=="")  {
	## must use source ID for MOE when assigning default tagname to events
						if(DF$MOE[which(DF$ID==chids[child])]<1)  {
							tagname<-paste0("G_", chids[child])
						}else{
							tagname<-paste0("G_", DF$MOE[which(DF$ID==chids[child])])
						}
					}
					treeXML<-paste0(treeXML,'<gate name="',tagname,'"/>',lb)
				}else{
	#  house events should not come with tags
					if(DF$Type[which(DF$ID==chids[child])]==9) {
						if(tagname=="")  {
							tagname<-paste0("H_", chids[child])
						}
						treeXML<-paste0(treeXML,'<house-event name="',tagname,'"/>',lb)
					}else{
						if(tagname=="")  {
	## must use source ID for MOE when assigning default tagname to events
							if(DF$MOE[which(DF$ID==chids[child])]<1)  {
								tagname<-paste0("E_", chids[child])
							}else{
								tagname<-paste0("E_", DF$MOE[which(DF$ID==chids[child])])
							}
						}
						treeXML<-paste0(treeXML,'<basic-event name="',tagname,'"/>',lb)
					} ## added else block closure due to house tag code
				}
			}
			if(types[gate]!="passthrough") {
				treeXML<-paste0(treeXML, ' </',types[gate],'>',lb)
			}
			treeXML<-paste0(treeXML,'</define-gate>',lb)
		}
	}

	treeXML<-paste0(treeXML,'</define-fault-tree>',lb)

	modelXML<-paste0('<model-data>',lb)

## start of eventXML generation
	eids<-DF$ID[which(DF$Type<9)]



	eventXML<-""

	for(event in 1:length(eids)) {
## cannot replicate MOE tags in mef, else get redifine basic-event error from scram
		if(DF$MOE[which(DF$ID==eids[event])]<1)  {
			tagname<-DF$Tag[which(DF$ID==eids[event])]
			if(tagname=="")  {
				tagname<-paste0("E_", eids[event])
			}

			eventXML<-paste0(eventXML, '<define-basic-event name="', tagname, '">',lb)
			## using thie flag saves nesting else clauses
			event_entry_done=FALSE

## This is the location to determine which distribution and deviate should be applied
## Any exposed event from FaultTree, could be handled as a fixed probability with deviate applied.
		etype<-DF$EType[which(DF$ID==eids[event])]
		utype<-DF$UType[which(DF$ID==eids[event])]
		dev_param<-floor(utype/10)
		deviate<-utype-10*dev_param


######################################################################################
########   basic-event having fixed probability entry with deviate, if applicable ####
######################################################################################
		if(etype==0 || (deviate>0&&dev_param==0))  {
		event_entry_done=TRUE  ## no other event case will be entered

			if(deviate>0) {
				eventXML<-define_deviate(DF, eventXML, eids[event], deviate)
			}else{
########   basic-event having fixed probability entry without deviate #######
				if(DF$PBF[which(DF$ID==eids[event])]>0) {
					eventXML<-paste0(eventXML, '<float value="', DF$PBF[which(DF$ID==eids[event])], '"/>',lb)
				}else{
					stop(paste0("must have probability at DF$PBF[",which(DF$ID==eids[event]),"]"))
				}
			}
			eventXML<-paste0(eventXML, '</define-basic-event>',lb)
}
#############################################################################
## end of fixed probability basic-event and any applicable deviate entry   ##
#############################################################################




######################################################################################
########   exponential  basic-event entry with lambda deviate, as applicable       ####
######################################################################################


		if(event_entry_done==FALSE && etype==1)  {
		event_entry_done=TRUE
			eventXML<-paste0(eventXML, '<exponential>',lb)

			if(deviate>0) {
				eventXML<-define_deviate(DF, eventXML, eids[event], deviate)
			}else{
				if(DF$CFR[which(DF$ID==eids[event])]>0) {
					eventXML<-paste0(eventXML, '<float value="', DF$CFR[which(DF$ID==eids[event])], '"/>',lb)
				}else{
					stop(paste0("must have fail rate at DF$CFR[",which(DF$ID==eids[event]),"]"))
				}
			}

## it is possible to have an overridden mission_time 
## for exponentially exposed events only.
	mt_top<-DF$P2[which(DF$ID==min(DF$ID))]
	mt<-mt_top
	exposure<-DF$P2[which(DF$ID==eids[event])]
	if(exposure>0) {mt<-exposure}
	if(!mt>0) {stop("system_mission_time not set for exponentially exposed events")}


		if(!exposure>0)  {
			eventXML<-paste0(eventXML, '<system-mission-time/>',lb)
		}else{
			eventXML<-paste0(eventXML, '<float value="', exposure , '"/>',lb)
		}

		eventXML<-paste0(eventXML, '</exponential>',lb)
		eventXML<-paste0(eventXML, '</define-basic-event>',lb)
		}
############################################################################
## end of exponential basic-event and applicable deviate on 'lambda'  ####
############################################################################


######################################################################################
########   Weibull exposed basic-event entry with scale deviate, as applicable       ####
######################################################################################

		if(event_entry_done==FALSE && etype==2)  {
		event_entry_done=TRUE
			eventXML<-paste0(eventXML, '<Weibull>',lb)
			if(deviate>0) {
				eventXML<-define_deviate(DF, eventXML, eids[event], deviate)
			}else{
				if(DF$CFR[which(DF$ID==eids[event])]>0) {
					eventXML<-paste0(eventXML, '<float value="', 1/DF$CFR[which(DF$ID==eids[event])], '"/>',lb)
				}else{
					stop(paste0("must have fail rate at DF$CFR[",which(DF$ID==eids[event]),"]"))
				}
			}

## need to add shape and time_shift values
		eventXML<-paste0(eventXML, '<float value="', DF$P1[which(DF$ID==eids[event])], '"/>',lb)
		eventXML<-paste0(eventXML, '<float value="', DF$P2[which(DF$ID==eids[event])], '"/>',lb)

## P2 cannot hold an exposure time override, P2 is assigned to time_shift for Weibull
#		if(DF$P2[which(DF$ID==eids[event])]==MT)  {
			eventXML<-paste0(eventXML, '<system-mission-time/>',lb)
#		}else{
#			eventXML<-paste0(eventXML, '<float value="', DF$P2[which(DF$ID==eids[event])] , '"/>',lb)
#		}
		eventXML<-paste0(eventXML, '</Weibull>',lb)
		eventXML<-paste0(eventXML, '</define-basic-event>',lb)
		}
############################################################################
## end of Weibull exposed basic-event and applicable deviate on 'scale'  ####
############################################################################


######################################################################################
########   GLM (Active)  basic-event entry with lambda deviate, as applicable       ####
######################################################################################


		if(event_entry_done==FALSE && etype==3)  {
		event_entry_done=TRUE
			eventXML<-paste0(eventXML, '<GLM>',lb)

## The G in GLM should always be zero. We don't even know what this was supposed to be.
			eventXML<-paste0(eventXML,'<float value="0"/>',lb)

			if(deviate>0) {
				eventXML<-define_deviate(DF, eventXML, eids[event], deviate)
			}else{
				if(DF$CFR[which(DF$ID==eids[event])]>0) {
					eventXML<-paste0(eventXML, '<float value="', DF$CFR[which(DF$ID==eids[event])], '"/>',lb)
				}else{
					stop(paste0("must have fail rate at DF$CFR[",which(DF$ID==eids[event]),"]"))
				}
			}
## GLM puts repair rate, mu (1/CRT), here.
				if(DF$CRT[which(DF$ID==eids[event])]>0) {
					eventXML<-paste0(eventXML, '<float value="', 1/DF$CRT[which(DF$ID==eids[event])], '"/>',lb)
				}else{
					stop(paste0("must have mttr at DF$CFR[",which(DF$ID==eids[event]),"]"))
				}
				
	MT<-DF$P2[which(DF$ID==min(DF$ID))]
		if(!MT>0) {stop("system_mission_time not set for exposed events")}

## There is no alternative, the mission_time must be set to pass in Active as GLM
#		if(DF$P2[which(DF$ID==eids[event])]==MT)  {
			eventXML<-paste0(eventXML, '<system-mission-time/>',lb)
#		}else{
#			eventXML<-paste0(eventXML, '<float value="', DF$P2[which(DF$ID==eids[event])] , '"/>',lb)
#		}

		eventXML<-paste0(eventXML, '</GLM>',lb)
		eventXML<-paste0(eventXML, '</define-basic-event>',lb)
		}
############################################################################
## end of GLM basic-event and applicable deviate on 'lambda'  ####
############################################################################

######################################################################################
####   periodic-test (Latent)  basic-event entry with lambda deviate, as applicable  ####
######################################################################################

		if(event_entry_done==FALSE && etype==4)  {
			event_entry_done=TRUE
			eventXML<-paste0(eventXML, '<periodic-test>',lb)

## as with Exponential Lambda is always first and might have a deviate applied
			if(deviate>0) {
				eventXML<-define_deviate(DF, eventXML, eids[event], deviate)
			}else{
				if(DF$CFR[which(DF$ID==eids[event])]>0) {
				eventXML<-paste0(eventXML, '<float value="', DF$CFR[which(DF$ID==eids[event])], '"/>',lb)
				}else{
					stop(paste0("must have fail rate at DF$CFR[",which(DF$ID==eids[event]),"]"))
				}
			}
## for periodic-test the aplication of repair rate, mu (1/CRT), 
## is the difference between 4 and 5 parameter representations.
			if(DF$CRT[which(DF$ID==eids[event])]>0) {
				eventXML<-paste0(eventXML, '<float value="', 1/DF$CRT[which(DF$ID==eids[event])], '"/>',lb)
			}

## The next two parameter entries are the inspection interval and time to  first inspection
## I don't kmow why one would feel they had to set first inspection different than rest
## This implementation will set them equal.
			if(DF$P2[which(DF$ID==eids[event])]>0) {
				eventXML<-paste0(eventXML, '<float value="', DF$P2[which(DF$ID==eids[event])], '"/>',lb)
				eventXML<-paste0(eventXML, '<float value="', DF$P2[which(DF$ID==eids[event])], '"/>',lb)
			}else{
				stop(paste0("must have inspection interval at DF$P2[",which(DF$ID==eids[event]),"]"))
			}

## There is no alternative, the mission_time must be set to pass in Latent as periodic-test

			MT<-DF$P2[which(DF$ID==min(DF$ID))]
				if(!MT>0) {stop("system_mission_time not set for exposed events")
			}
			eventXML<-paste0(eventXML, '<system-mission-time/>',lb)

			eventXML<-paste0(eventXML, '</periodic-test>',lb)
			eventXML<-paste0(eventXML, '</define-basic-event>',lb)
			}
##################################################################################
## end of periodic-test basic-event and applicable deviate on 'lambda'  ####
##################################################################################


		}  #Close MOE skip over
	}
## end of eventXML generation

## start of houseXML generation
	hids<-DF$ID[which(DF$Type==9)]
	houseXML<-""
	if(length(hids>0))  {
		for(hevent in 1:length(hids))  {
			tagname<-DF$Tag[which(DF$ID==hids[hevent])]
			if(tagname=="")  {
				tagname<-paste0("H_", hids[hevent])
			}
			houseXML<-paste0(houseXML, '<define-house-event name="', tagname, '">',lb)
			hval="true"
			if(DF$PBF[which(DF$ID==hids[hevent])]==0)  { hval="false" }
			houseXML<-paste0(houseXML, '<constant value="', hval, '"/>',lb)
			houseXML<-paste0(houseXML, '</define-house-event>',lb)
		}
	}


	XMLhead<-paste0('<!DOCTYPE opsa-mef>',lb,
	'<opsa-mef>',lb,
	'<define-fault-tree name="',
	DFname, '">',lb)


	XMLfoot<-paste0('</model-data>',lb,'</opsa-mef>',lb)


	outstring<-paste0(XMLhead, treeXML, modelXML, eventXML, houseXML, XMLfoot)

	if(write_file==TRUE)  {
		file_name<-paste0(dir,DFname,"_mef.xml")
		eval(parse(text=paste0('write(outstring,"',file_name,'")')))
	}

	outstring
}


deviate_parameters<-function(DF, eventXML, eid) {
	lb<-"\n"

	if(DF$UP1[which(DF$ID==eid)]!=0) {
	eventXML<-paste0(eventXML, '<float value="',DF$UP1[which(DF$ID==eid)], '"/>',lb)
	}else{
	stop(paste0("uncertainty parameter expected at DF$UP1[",which(DF$ID==eid),"]"))
	}
	if(DF$UP2[which(DF$ID==eid)]>0) {
	eventXML<-paste0(eventXML, '<float value="',DF$UP2[which(DF$ID==eid)], '"/>',lb)
	}else{
	stop(paste0("uncertainty parameter expected at DF$UP2[",which(DF$ID==eid),"]"))
	}

	eventXML
}

define_deviate<-function(DF, eventXML, eid, deviate) {
	lb<-"\n"

	if(deviate==1) {
		eventXML<-paste0(eventXML, '<uniform-deviate>',lb)
		eventXML<-deviate_parameters(DF, eventXML, eid)
		eventXML<-paste0(eventXML, '</uniform-deviate>',lb)
	}

	if(deviate==2) {
		eventXML<-paste0(eventXML, '<normal-deviate>',lb)
		eventXML<-deviate_parameters(DF, eventXML, eid)
		eventXML<-paste0(eventXML, '</normal-deviate>',lb)
	}

	if(deviate==3) {
		eventXML<-paste0(eventXML, '<lognormal-deviate>',lb)
		eventXML<-deviate_parameters(DF, eventXML, eid)
		eventXML<-paste0(eventXML, '</lognormal-deviate>',lb)
	}
	if(deviate>3) {
		stop(paste0("uncertainty deviate type ",deviate," has not been defined" ))
	}
	
	eventXML
}