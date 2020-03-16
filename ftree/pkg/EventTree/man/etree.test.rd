\name{etree.test}
\alias{etree.test}

\title{ Event Tree Object Test }

\description{etree.test compares dataframe column names with those of an etree object.
}

\usage{
etree.test(DF)
}

\arguments{
\item{DF}{ An EventTree dataframe object}
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
mytree <- etree.make(name="conveyor belt fire")
etree.test(mytree)
}

\keyword{ logic, risk, failure }