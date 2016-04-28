\name{ftree.test}
\alias{ftree.test}

\title{ Fault Tree Object Test }

\description{etree.test compares dataframe column names with those of an ftree object.
}

\usage{
ftree.test(DF)
}

\arguments{
\item{DF}{ A FaultTree dataframe object}
}

\value{
Returns True for object match, else False.
}

\references{
  Nicholls, David [Editor] (2005) System Reliability Toolkit  Reliability information Analysis 
  Center
  
  O'Connor, Patrick D.T. (1991) Practical Reliability Engineering  John Wiley & Sons
}

\examples{
mytree <- ftree.make(type="or", name="site power loss")
ftree.test(mytree)
}

\keyword{ logic, risk, failure }