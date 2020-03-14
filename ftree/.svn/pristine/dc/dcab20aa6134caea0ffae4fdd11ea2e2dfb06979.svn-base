## prob2lam.R
# copyright 2015-2017, openreliability.org
#
#	A simplistic helper function for converting fixed probability to a fail rate using known exposure time
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


prob2lam<-function(prob) {
if(!exists("mission_time")) {
stop("mission_time not set")
}
exposure<-"mission_time"
Tao <- eval((parse(text = exposure)))
lam<-(-1)*log(1-prob)/Tao
}
