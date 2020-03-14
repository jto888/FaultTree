\name{ftree2table}
\alias{ftree2table}

\title{ Fault Tree Tabular Subview }

\description{Delivers an informative subview from an ftree dataframe with condensed output.
}

\usage{
ftree2table(DF)
}

\arguments{
\item{DF}{ A fault tree dataframe object.}
}

\value{
Returns a new condensed dataframe that is a subview of the ftree object.
}

\references{
  Nicholls, David [Editor] (2005) System Reliability Toolkit  Reliability information Analysis 
  Center
  
  O'Connor, Patrick D.T. (1991) Practical Reliability Engineering  John Wiley & Sons
}

\examples{
mytree <- ftree.make(type="or", name="site power loss")
ftree2table(mytree)
}

\keyword{ logic, risk, failure }

