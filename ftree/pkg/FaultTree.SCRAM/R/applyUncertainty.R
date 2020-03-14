# applyUncertainty.R
# copyright 2017, openreliability.org
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

applyUncertainty<-function(DF, on , what="prob", deviate, param)  {

	if(!test.ftree(DF)) stop("first argument must be a fault tree")
	
	on <- tagconnect(DF, on)

	if(DF$Type[which(DF$ID==on)]==1 && !DF$EType[which(DF$ID==on)]==3) {
		stop("Uncertainty cannot be applied to Active event without mission_time")
		}
	if(DF$Type[which(DF$ID==on)]==2 && !DF$EType[which(DF$ID==on)]==4) {
		stop("Uncertainty cannot be applied to Latent event without mission_time")
		}
	if(!DF$EType[which(DF$ID==on)]>0 && !DF$Type[which(DF$ID==on)]==4){
		stop("Uncertainty can be applied to only Probability or Exposed elements")
	}

## Validity checking on what argument
	if(what=="prob" && (DF$Type[which(DF$ID==on)]==5 || DF$Type[which(DF$ID==on)]==1))  {
		warning("SCRAM will process a probability event for uncertainty evaluation")
	}
	if(what=="lambda" && DF$Type[which(DF$ID==on)]==4)  {
		stop("fixed probability entry has no lambda parameter")
	}
	if(what=="lambda" && DF$EType[which(DF$ID==on)]==2)  {
		stop("weibull exposed entry has no lambda parameter")
	}
	if(what=="scale" && (!DF$EType[which(DF$ID==on)]==2)) {
		stop("scale parameter only applies to weibull exposed basic-event")
	}
############  Any more checks on what argument required? #######

	utp<-0 ## no deviate applied
	utp<-switch(deviate,
		uniform = 1,
		normal = 2,
		lognormal=3,
##		gamma=4,
##		beta=5,
		stop("deviate type not recognized")
	)
	
##  Adjust UType for what argument
	wtp<-switch(what,
		prob=0,
		lambda=1,
		wscale=2,
		scale=2,		# must convert mean value using "meanw2scale" in ftree2mef
## The parameters below seem somewhat pointless for uncertainty application
## Implementation is not a priority
	##	shape=3,		# P1 to hold wshape for weibull (not yet implemented)
	##	mu=4,		# repair rate for glm
	##	tao=5,		# test interval P2 for periodic_inspection
		stop("what argument not recognized")
	)

## The UType can now be encoded and set
	DF$UType[which(DF$ID==on)]<-utp + 10*wtp

## flag to avoid deep nesting of if-else blocks
wtp_done=FALSE

## pre-set UP1 to zero for later tests that a value is present
## lognormal mu may well be a negative value
DF$UP1[which(DF$ID==on)]<-0

## Validity checking and UP1/UP2 parameter setting below
	if(wtp==0 && wtp_done==FALSE)  {
		wtp_done=TRUE
		static_mean<-DF$PBF[which(DF$ID==on)]
		if(utp==1) { # uniform-variate on probability
			range_value<-param[1]
			if(length(param)>1) {
				range_value<-param[2]-param[1]
			}
			if( range_value > static_mean )  {
				warning(paste0("range_value may be unrealistic at ID ", on))
			}
			if(!range_value<2*static_mean) {
				stop(paste0("range_value too high at ID ", on))
			}
			DF$UP1[which(DF$ID==on)]<-static_mean-range_value/2
			DF$UP2[which(DF$ID==on)]<-static_mean+range_value/2
		}
		if(utp==2) { # normal-variate on probability
			if(param[1] > static_mean/6) {
				warning(paste0("normal-deviate sigma likely too high at ID ", on))
			}
			DF$UP1[which(DF$ID==on)]<-static_mean
			DF$UP2[which(DF$ID==on)]<-param[1]
		}
		if(utp==3) { # lognormal-variate on probability
			meanln<-DF$PBF[which(DF$ID==on)]
			#Lmu<-log(meanln)+Lsigma^2
			sigma<-param[1]
			if(length(param)>1) {
				sigma<-log(param[1]/qnorm(param[2]))
			}
			mu<-log(meanln)+sigma^2
			if(sigma > abs(mu)/6) {
				warning(paste0("lognormal-deviate sigma likely too high at ID ", on))
			}
			DF$UP1[which(DF$ID==on)]<-mu
			DF$UP2[which(DF$ID==on)]<-sigma
		}
	}

	if(wtp==1 && wtp_done==FALSE) {
		wtp_done=TRUE
		mean_lambda<-DF$CFR[which(DF$ID==on)]
		if(utp==1) {  # uniform-variate on lambda
			range_value<-param[1]
			if(length(param)>1) {
				range_value<-param[2]-param[1]
			}
			if( range_value > mean_lambda)  {
				warning(paste0("range_value may be unrealistic at ID ", on))
			}
			if(!range_value<2*mean_lambda) {
				stop(paste0("range_value too high at ID ", on))
			}
			DF$UP1[which(DF$ID==on)]<-mean_lambda-range_value/2
			DF$UP2[which(DF$ID==on)]<-mean_lambda+range_value/2
		}
		if(utp==2) {  # normal-variate on lambda
			if(param[1] > mean_lambda/6) {
				warning(paste0("normal-deviate sigma likely too high at ID ", on))
			}
			DF$UP1[which(DF$ID==on)]<-mean_lambda
			DF$UP2[which(DF$ID==on)]<-param[1]
		}
		if(utp==3) {  # lognormal-variate on lambda
			meanln<-DF$CFR[which(DF$ID==on)]
			sigma<-param[1]
			if(length(param)>1) {
				sigma<-log(param[1]/qnorm(param[2]))
			}
			mu<-log(meanln)+sigma^2
			if(sigma > abs(mu)/6) {
				warning(paste0("lognormal-deviate sigma likely too high at ID ", on))
			}
			DF$UP1[which(DF$ID==on)]<-mu
			DF$UP2[which(DF$ID==on)]<-sigma
		}
	}


	if(wtp==2 && wtp_done==FALSE)  {
		wtp_done=TRUE
		meanw<-1/DF$CFR[which(DF$ID==on)]
		wshape<-DF$P1[which(DF$ID==on)]
		tzero<-DF$P2[which(DF$ID==on)]
		wscale<-(meanw-tzero)/gamma(1+1/wshape)
		if(utp==1) {  # uniform-variate on weibull scale
		range_value<-param[1]
		if(length(param)>1) {
				range_value<-param[2]-param[1]
			}
			if( range_value > wscale)  {
				warning(paste0("range_value may be unrealistic at ID ", on))
			}
			if(!range_value<2*wscale) {
				stop(paste0("range_value too high at ID ", on))
			}
			DF$UP1[which(DF$ID==on)]<-wscale-range_value/2
			DF$UP2[which(DF$ID==on)]<-wscale+range_value/2
		}
		if(utp==2) {  # normal-variate on weibull scale
			if(param[1] > wscale/6) {
				warning(paste0("normal-deviate sigma likely too high at ID ", on))
			}
			DF$UP1[which(DF$ID==on)]<-wscale
			DF$UP2[which(DF$ID==on)]<-param[1]
		}
		if(utp==3) {  # lognormal-variate on weibull scale
			meanln<-wscale
			sigma<-param[1]
			if(length(param)>1) {
				sigma<-log(param[1]/qnorm(param[2]))
			}
			mu<-log(meanln)+sigma^2
			if(sigma > abs(mu)/6) {
				warning(paste0("lognormal-deviate sigma likely too high at ID ", on))
			}
			DF$UP1[which(DF$ID==on)]<-mu
			DF$UP2[which(DF$ID==on)]<-sigma
		}
	}

	DF
}
