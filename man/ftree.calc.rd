\name{ftree.calc}
\alias{ftree.calc}

\title{ Fault Tree Calculation }

\description{ftree.calc performs gate calculations from bottom to top of fault tree.
}

\usage{
ftree.calc(DF) 
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
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

