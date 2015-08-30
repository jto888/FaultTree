\name{ftree.make}
\alias{ftree.make}

\title{ Fault Tree Creation }

\description{ftree.make prepares an initial, single row, dataframe, which will be built upon as the tree is developed.
}

\usage{
ftree.make(type, name="top event", description="")
}

\arguments{
\item{type}{ The logic type for the top gate. Currently only "or" and "and" are implemented.}
\item{name}{ An identifying string for the logic gate}
\item{description}{ An optional string providing more detail for the resultant event.}
}

\value{
Returns a dataframe containing 18 columns for holding data, results, and connection information.
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
mytree <- ftree.make(type="and", name="a specific undesired event")
}

\keyword{ logic, risk, failure }

