\name{ftree2html}
\alias{ftree2html}

\title{ Fault Tree Display }

\description{Prepares a web page from an ftree dataframe for a visualization of the data.
}

\usage{
ftree2html(DF,dir="", write_file=FALSE)
}

\arguments{
\item{DF}{ A fault tree dataframe object.}
\item{dir}{A character string for an absolute directory in which R can read and write.}
\item{write_file}{A logical controlling whether to perform the write operation.}
}

\value{
Returns a character vector with escaped quote characters, suitable for writing to disk.
Optionally, this vector will be written to a file taking the name of the object passed in as DF and appending '.html'.
}

\references{
  Nicholls, David [Editor] (2005) System Reliability Toolkit  Reliability information Analysis 
  Center
  
  O'Connor, Patrick D.T. (1991) Practical Reliability Engineering  John Wiley & Sons
}

\examples{
mytree <- ftree.make(type="or", name="site power loss")
ftree2html(mytree)
}

\keyword{ logic, risk, failure }

