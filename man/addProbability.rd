\name{addProbability}
\alias{addProbability}

\title{ Add a Pure Probability }

\description{Modifies an existing fault tree with the addition of a pure probability.}

\usage{
addProbability(DF, at, prob, name="", description="")
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{at}{ The ID of the parent node for this addition.}
\item{prob}{A probability value >0 && <1}
\item{name}{ A short identifying string }
\item{description}{ An optional string providing more detail for this probability.}
}

\value{
Returns the input fault tree dataframe appended with an entry row for the defined probability.
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
mytree <-ftree.make(type="and", name="common cause failure of redundant pumps")
mytree<-addActive(mytree,at=1,mttf=3,mttr=12/8760, name="Pump")
mytree <- addProbability(mytree,  at=1, prob=.05, name="common cause beta factor")
}

\keyword{ logic, risk, failure }

