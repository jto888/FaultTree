\name{hierarchyDF2json}
\alias{hierarchyDF2json}

\title{ JSON formatting for tabular hierarchy data }

\description{Converts data from a flat-table dataframe to a recursive json structure
 suitable for passing to D3 heirarchy objects.
}

\usage{
hierarchyDF2json(DF,id.col=1, parent.col=2, data.col=NULL,  			
	children.key="children", keys.tolower=TRUE, reverse_child_order=FALSE, 		
	dir="", write_file=FALSE )		
}

\arguments{
\item{DF}{ A dataframe object with unique identification column and a column containing parent node identifications. The first row must contain the root node of the hierarchy.}
\item{id.col}{ The name or number of the column  holding unique identifiers, default is 1.}
\item{parent.col}{ The name or number of the column holding parent node identifications, default is 2. Entry in row one of this column will be ignored.}
\item{data.col}{ A vector of column numbers from the dataframe to be passed as json data, default is all columns.}
\item{children.key}{A string to be used as the key for children entries.}
\item{keys.tolower}{A logical indicating whether to convert column names of the input dataframe to lower case, when passing keys to the json format.}
\item{reverse_child_order}{ A logical indicating whether to reverse the order of child nodes under each parent. This is useful when desiring nodes to form from top to bottom in a horizontal tree structure.}
\item{dir}{A character string for an absolute directory in which R can read and write.}
\item{write_file}{A logical controlling whether to perform the write operation.}
}

\value{
Returns a character vector with escaped quote characters, suitable for writing to disk.
Optionally, this vector will be written to a file taking the name of the object passed in as DF and appending '.json'.
}

\references{
  Nicholls, David [Editor] (2005) System Reliability Toolkit  Reliability information Analysis 
  Center
  
  O'Connor, Patrick D.T. (1991) Practical Reliability Engineering  John Wiley & Sons
  
  Ericson II, Clifton A. (2011) Fault Tree Analysis Primer CreateSpace Inc.
}

\examples{
mytree <- ftree.make(type="or", name="conveyor belt fire")
hierarchyDF2json(mytree, id.col=1, parent.col=2, data.col=c(1,2))
}

\keyword{ logic, risk, failure }

