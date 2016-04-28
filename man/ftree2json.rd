\name{ftree2json}
\alias{ftree2json}

\title{ JSON format for Fault Tree data }

\description{Converts data from the tabular ftree dataframe to a recursive json structure
 suitable for passing to D3 heirarchy objects.
}

\usage{
ftree2json(DF, data.col=c(2), dir="", write_file=FALSE )
}

\arguments{
\item{DF}{ A FaultTree dataframe object.}
\item{data.col}{ A vector of column numbers from the FaultTree dataframe to be passed as json data.}
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
mytree <- ftree.make(type="or", name="conveyor belt fire")
ftree2json(mytree)
}

\keyword{ logic, risk, failure }

