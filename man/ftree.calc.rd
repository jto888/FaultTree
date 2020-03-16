\name{ftree.calc}
\alias{ftree.calc}

\title{ Fault Tree Calculation }

\description{ftree.calc performs gate-by-gate calculations from bottom to top of fault tree.
}

\usage{
ftree.calc(DF, use.bdd=FALSE)  
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{use.bdd}{A logical determining whether to use the bdd for probability calculations rather than simple solutions.}
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
  
  Doelp, L.C., Lee, G.K., Linney, R.E., Ormsby R.W. (1984) Quantitative fault tree analysis: Gate-by-gate method Plant/Operations Progress
 Volume 3, Issue 4 American Institute of Chemical Engineers
 
  Rauzy, Antoine (1993) "New algorithms for fault trees analysis" Reliabiity Engineering System Safety, volume 40
   
  Limnios, Nikolaos (2007) Fault Trees ISTE,Ltd.
  
  Bedford, Tim, Cooke, Roger (2012) Probabilistic Risk Analysis Foundations and Methods Cambridge University Press
}

\examples{
minex2<-ftree.make(type="and")
minex2<-addProbability(minex2, at="top", prob=.01, tag="X1", name="X1")
minex2<-addLogic(minex2, at="top", type="or", tag="G1", name="G1")
minex2<-addProbability(minex2, at="G1", prob=.02, tag="X2", name="X2")
minex2<-addProbability(minex2, at="G1", prob=.03, tag="X3", name="X3")
minex2<-addLogic(minex2, at="top", type="or", tag="G2", name="G2")
minex2<-addDuplicate(minex2, at="G2", dup_of="X3")
minex2<-addProbability(minex2, at="G2", prob=.04, tag="X4", name="X4")
minex2<-ftree.calc(minex2, use.bdd=TRUE)
}

\keyword{ logic, risk, failure }

