## tagconnect
# copyright 2017, openreliability.org
# Contributed by Danylo Malyuta
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

# Add functionality to refer to the tag attribute from the at attribute
# for connecting the fault tree elements

tagconnect <- function(DF, at) {
  # If at argument is a string, it means that the user wants to connect to the tag of another tree
  # element. Search for this tag and, if it exists in the tree, overwrite at argument with the
  # corresponding ID of the element with this tag; otherwise, throw an error about non-existent tag!
  if (is.character(at) & length(at) == 1) {
    # at argument is a string
    corresponding_element = DF[which(DF$Tag == at),]
    number_of_elements = nrow(corresponding_element)
    if (number_of_elements == 0) {
      stop(paste("no element with tag=",at,"found",sep = " "))
    } else if (number_of_elements > 1) {
      stop(paste("more than one (",number_of_elements,") element with tag=",at,"was found",sep = " "))
    } else {
      # set the at argument to the ID of the unique element in the fault tree which has the tag
      # originally passed by user for the at argument
      return(corresponding_element$ID)
    }
  } else {
    # at argument is a number, return it directly (treat it as directly the data frame ID that the
    # user passed in)
    return(at)
  }
}