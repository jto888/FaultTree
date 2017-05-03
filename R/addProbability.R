# addProbability.R
# copyright 2015-2017, openreliability.org
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

addProbability<-function(DF, at, prob, display_under=NULL, tag="", name="", name2="", description="")  {

	at <- tagconnect(DF, at)

## display_under to be interpreted within test.basic
##		if(!is.null(display_under))  {
##		display_under<-tagconnect(DF,display_under)
##	}}

 	tp=4

	info<-test.basic(DF, at,  display_under, tag)
	thisID<-info[1]
	parent<-info[2]
	gp<-info[3]
	condition<-info[4]

	if(prob<0 || prob>1)  {stop("probability entry must be between zero and one")}

## Avoid conflicts with default tag names
# This test is covered in test.basic above
#  if(length(tag)>2){
#    if(substr(tag,1,2)=="E_" || substr(tag,1,2)=="G_" ) {
#      stop("tag prefixes E_ and G_ are reserved for MEF defaults")
#    }
#  }

	Dfrow<-data.frame(
		ID=	thisID	,
		GParent=	gp	,
		CParent=	at	,
		Level=	DF$Level[parent]+1	,
		Type=	tp	,
		CFR=	-1	,
		PBF=	prob	,
		CRT=	-1	,
		MOE=	0	,
		Condition=	condition,
		Cond_Code=	0,
		EType=	0	,
		P1=	-1	,
		P2=	-1	,
		Tag_Obj=	tag	,
		Name=	name	,
		Name2=	name2	,
		Description=	description	,
		UType=	0	,
		UP1=	0	,
		UP2=	0
	)


	DF<-rbind(DF, Dfrow)
	DF
}
