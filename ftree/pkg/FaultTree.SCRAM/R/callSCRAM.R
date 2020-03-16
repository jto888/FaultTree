## callSCRAM
# Copyright 2017 OpenReliability.org
#
# A wrapper function for creating a call to the SCRAM program http://scram-pra.org/
# tests are made for the presence of scram on the system, and the existence of
# an appropriate input file for the named object.
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
callSCRAM<-function(DFname, scram_arg="mocus", arg2="", arg3="")  {
##callSCRAM<-function(DFname, input_string="", scram_arg="mocus")  {

scram.test<-Sys.which("scram")
if(!nchar(scram.test)>0) {
  stop("scram is not installed on this system")
}

## it is unlikely that a string can be handled directly and not a file name in the scram call
##if(input_string=="") {
  input_file<-paste0(DFname,"_mef.xml")
##}


if(file.exists(input_file)) {
call_strg<-paste0('scram ',input_file,' --',scram_arg, arg2, arg3, ' -o ',DFname,'_scram_',scram_arg, '.xml')
system(call_strg)
}else{
  stop(paste0("mef file ",input_file," does not exist"))
}

}