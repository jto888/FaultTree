## test.basic
# copyright 2016, openreliability.org
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

## this function will remain internal to the FaultTree package
## it performs a uniform set of tests for all basic component events
## and sets some informational variables
## the information is returned as a vector to the  calling function

test.basic<-function(DF, at,  display_under, tag)  {

	if(!ftree.test(DF)) stop("first argument must be a fault tree")

	parent<-which(DF$ID== at)
	if(length(parent)==0) {stop("connection reference not valid")}
	thisID<-max(DF$ID)+1
	if(DF$Type[parent]<10) {stop("non-gate connection requested")}

	if(!DF$MOE[parent]==0) {
		stop("connection cannot be made to duplicate nor source of duplication")
	}

	if(tag!="")  {
		if (length(which(DF$Tag == tag) != 0)) {
		stop("tag is not unique")
		}
	}


## There is no need to limit connections to OR gates for calculation reasons
## Since AND gates are calculated in binary fashion, these too should not
## require a connection limit, practicality suggests 3 is a good limit.
## All specialty gates must be limited to binary feeds only

	if(DF$Type[parent]==11 && length(which(DF$Parent==at))>2) {
		warning("More than 3 connections to AND gate.")
	}

	condition=0
	if(DF$Type[parent]>11 )  {
		if(length(which(DF$CParent==at))>1)  {
		stop("connection slot not available")
		}
		if( length(which(DF$CParent==at))==0)  {
			if(DF$Cond_Code[parent]<10)  {
				condition=1
			}
		}else{
##  length(which(DF$CParent==at))==1
			if(DF$Cond_Code[parent]>9)  {
				condition=1
			}
		}
	}

	gp<-at
	if(length(display_under)!=0)  {
		if(DF$Type[parent]!=10) {stop("Component stacking only permitted under OR gate")}
		if(DF$CParent[display_under]!=at) {stop("Must stack at component under same parent")}
		if(length(which(DF$GParent==display_under))>0 )  {
			stop("display under connection not available")
		}else{
			gp<-display_under
		}
	}
	
	info_vec<-c(thisID, parent, gp, condition)

info_vec
}
