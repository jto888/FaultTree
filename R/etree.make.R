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
		ParentID=	-1	,
		Prob=	1	,
		Freq=	1	,
		Severity=	severity	,
		Child1=	-1	,
		Child2=	-1	,
		Child3=	-1	,
		Child4=	-1	,
		Child5=	-1	,
		Description=	description	,
		stringsAsFactors = FALSE		
		)		
DF				
}				
				
				
ET_FIELDS<-c("ID",
	"Level",
	"Name",
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