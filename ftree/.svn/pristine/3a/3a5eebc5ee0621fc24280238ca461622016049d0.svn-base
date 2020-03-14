# etree.make.R
# copyright 2015, openreliability.org
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

etree.make<-function(name="initiating event", severity=1, description="")  {				
				
	DF<-data.frame(			
		ID=	1	,
		Level=	1	,
		Name=	name	,
		Type= "initiator"		,
		ParentID=	-1	,
		Prob=	1	,
		Freq=	1	,
		Severity=	severity	,
		Child1=	NA	,
		Child2=	NA	,
		Child3=	NA	,
		Child4=	NA	,
		Child5=	NA	,
		Description=	description	,
		stringsAsFactors = FALSE		
		)		
DF				
}				
				
				
ET_FIELDS<-c("ID",
	"Level",
	"Name",
	"Type",
	"ParentID",
	"Prob",
	"Freq",
	"Severity",
	"Child1",
	"Child2",
	"Child3",
	"Child4",
	"Child5",
	"Description"
)

	

etree.test<-function(DF) {		
	if(class(DF)!="data.frame") {	
		return(FALSE)
	}else{	
	if(length(names(DF))!=14)  { 	
		return(FALSE)
	}else{	
		etree_test<-NULL
		for(nm in 1:14) {etree_test<-c(etree_test,names(DF)[nm]==ET_FIELDS[nm])}
		if(!all(etree_test)) {
				return(FALSE)
			}else{
			return(TRUE)
			}
		}
	}
}