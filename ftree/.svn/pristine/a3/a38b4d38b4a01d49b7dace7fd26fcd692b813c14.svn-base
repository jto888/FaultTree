\name{etree2json}
\alias{etree2json}

\title{ Event Tree Creation }

\description{Converts data from the tabular etree dataframe to a recursive json tree structure
 suitable for passing to D3 objects.
}

\usage{
etree2json(DF, data.col=c(3), dir="", write_file=FALSE )
}

\arguments{
\item{DF}{ An EventTree dataframe object.}
\item{data.col}{ A vector of column numbers from the EvenTree dataframe to be passed as json data.}
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
}

\examples{
mytree <- etree.make(name="conveyor belt fire")
etree2json(mytree)
}

\keyword{ logic, risk, failure }

