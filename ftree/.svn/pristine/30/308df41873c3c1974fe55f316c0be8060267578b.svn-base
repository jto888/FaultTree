## readSCRAMimportance.R
# Copyright 2017 OpenReliability.org
#
# A line-by-line parser of the output files from importance analysis
# from SCRAM http://scram-pra.org/ returning a dataframe containing five
# importance measures for each basic-event tag.
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

readSCRAMimportance<-function(x, dir="")  {

	fileName<-paste0(dir,x)
## check that fileName provided is indeed for cutsets and indeed exists	
	
	conn <- file(fileName,open="r")
	on.exit(close(conn))
	
	importance<-FALSE
	outDF<-NULL

## intended for use with line by line feeding	
##	i=1
	while ( TRUE ) {
		linn = readLines(conn, n = 1)
		if ( length(linn) == 0 ) {
			break
		}
		t_imp<-length(grep("<importance name*",linn[1]))>0
		if(t_imp) {
			importance<-TRUE
## get another line, because we are done with this one			
			next
		}
		
		if(importance) {
		t_end<-length(grep("</importance>",linn[1]))>0
			if(t_end) {
				break
			}else{
## these lines after importance identified until t_end contain the importance data	
			in_string<-as.character(linn[1])
			f_tag<-regexpr('name=', linn[1])+5

			mif<-regexpr('MIF=', linn[1])
			cif<-regexpr('CIF=', linn[1])
			dif<-regexpr('DIF=', linn[1])
			raw<-regexpr('RAW=', linn[1])
			rrw<-regexpr('RRW=', linn[1])

			f_mif<-mif+5
			f_cif<-cif+5
			f_dif<-dif+5
			f_raw<-raw+5
			f_rrw<-rrw+5

			l_tag<-mif-1
			l_mif<-cif-3
			l_cif<-dif-3
			l_dif<-raw-3
			l_raw<-rrw-3
			l_rrw<-nchar(in_string)-3

			tag_s <- substr(in_string, f_tag, l_tag)
			MIF<-as.numeric(substr(in_string, f_mif, l_mif))
			CIF<-as.numeric(substr(in_string, f_cif, l_cif))
			DIF<-as.numeric(substr(in_string, f_dif, l_dif))
			RAW<-as.numeric(substr(in_string, f_raw, l_raw))
			RRW<-as.numeric(substr(in_string, f_rrw, l_rrw))

			DFline<-data.frame(tag=tag_s,MIF,CIF,DIF,RAW,RRW)
			outDF<-rbind(outDF,DFline)
			
			}			
		}
			
	}
	
	outDF
}
		
