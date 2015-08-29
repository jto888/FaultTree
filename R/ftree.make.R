# ftree.make.R
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


ftree.make<-function(type, name="top event", description="")  {				
	tp<-switch(type,			
		or = 10,		
		and = 11,		
		conditional =12,		
		stop("gate type not recognized")		
	)			
				
	DF<-data.frame(			
		ID=	1	,
		Level=	1	,
		Name=	name	,
		ParentID=	-1	,
		Type=	tp	,
		CFR=	-1	,
		PBF=	-1	,
		Child1=	-1	,
		Child2=	-1	,
		Child3=	-1	,
		Child4=	-1	,
		Child5=	-1	,
		ProbabilityEntry=	-1	,
		MTTF=	-1	,
		MTTR=	-1	,
		inspectionInterval=	-1	,
		InspectIonObject=	""	,
		Description=	description	,
		stringsAsFactors = FALSE
		)		
DF
}

FT_FIELDS<-c("ID",
	"Level",
	"Name",
	"ParentID",
	"Type",
	"CFR",
	"PBF",
	"Child1",
	"Child2",
	"Child3",
	"Child4",
	"Child5",
	"ProbabilityEntry",
	"MTTF",
	"MTTR",
	"inspectionInterval",
	"InspectIonObject",
	"Description"
	)

