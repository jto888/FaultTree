\name{etree2html}
\alias{etree2html}

\title{ Event Tree Creation }

\description{Prepares a web page from an etree dataframe for a view of the data.
}

\usage{
etree2html(DF,SVGwidth=1000,SVGheight=500,SVGleft_margin=100,
 SVGright_margin=250,dir="", write_file=FALSE)
}

\arguments{
\item{DF}{ An EventTree dataframe object.}
\item{SVGwidth}{width in pixels for the SVG display.}
\item{SVGheight}{height in pixels for the SVG display.}
\item{SVGleft_margin}{placement of the first node of event tree display from left in pixels.}
\item{SVGright_margin}{placement of the last node of event tree display from right in pixels.}
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
mytree <- etree.make(name="conveyor belt fire")
etree2html(mytree)
}

\keyword{ logic, risk, failure }

