\name{addDemand}
\alias{addDemand}

\title{ Add a Pure Demand Event }

\description{Modifies an existing fault tree with the addition of a pure demand event.}

\usage{
addDemand(DF, at, mttf, name="", name2="", description="")
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{at}{ The ID of the parent node for this addition.}
\item{mttf}{The mean time interval to events.  It is the user's responsibility to maintain constant units of time.}
\item{name}{ A short identifying string  (typically less than 24 characters)}
\item{name2}{ A second line, if needed for the identifying string label}
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
  
  Doelp, L.C., Lee, G.K., Linney, R.E., Ormsby R.W. (1984) Quantitative fault tree analysis: Gate-by-gate method Plant/Operations Progress
Volume 3, Issue 4 American Institute of Chemical Engineers  
}

\examples{
mytree <-ftree.make(type="and")
mytree <- addDemand(mytree,  at=1, mttf=1, name="power interruption")
}

\keyword{ logic, risk, failure }

