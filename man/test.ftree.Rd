\name{test.ftree}
\alias{test.ftree}

\title{ Fault Tree Object Test }

\description{test.ftree compares dataframe column names with those of an ftree object.
}

\usage{
test.ftree(DF)
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
test.ftree(mytree)
}

\keyword{ logic, risk, failure }