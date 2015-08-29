\name{addDemand}
\alias{addDemand}

\title{ Add a Pure Demand Event }

\description{Modifies an existing fault tree with the addition of a pure demand event.}

\usage{
addDemand(DF, at, demand_rate, name="", description="")
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{at}{ The ID of the parent node for this addition.}
\item{demand_rate}{The reciprocal of time to event.  It is the user's responsibility to maintain constant units of time.}
\item{name}{ A short identifying string }
\item{description}{ An optional string providing more detail for the resultant event.}
}

\value{
Returns the input fault tree dataframe appended with an entry row for the defined component event. Note that when a pure demand is used in combination under an AND gate, the result will contain only a conditional fail rate.
}

\references{
  Nicholls, David [Editor] (2005) System Reliability Toolkit  Reliability information Analysis 
  Center
  
  O'Connor, Patrick D.T. (1991) Practical Reliability Engineering  John Wiley & Sons
  
  Vesely, W.E., Goldberg, F.F., Roberts, N.H., Haasl, D.F. (1981)  Fault Tree Handbook
  U.S.  Nuclear Regulatory Commission 
  
  Vesely, W.E., Stamatelato, M., Dugan, J., Fragola, J., Minarick, J., Railsback, J. (2002)
  Fault Tree Handbook with Aerospace Applications   NASA
}

\examples{
mytree <-ftree.make(type="and")
mytree <- addDemand(mytree,  at=1, demand_rate=1, name="power interruption")
}

\keyword{ logic, risk, failure }

