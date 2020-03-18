\name{applyCollapse}
\alias{applyCollapse}

\title{ Set a gate node for collapsed state on initial rendering. }

\description{Modifies an existing fault tree by setting the Collapse field of the selected node to 1.}

\usage{
applyCollapse(DF, on)
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{on}{ The ID of the basic element node to be defined uncertain.}
}

\value{
Returns the input fault tree dataframe amended with an entry defining collapsed initial state for the  selected node.
}

\references{
  Rauzy, Antoine, et. al.  (2013) Open PSA Model Exchange Format v2.0 open-psa.org
  
  Limnios, Nikolaos (2007) Fault Trees ISTE Ltd.
  
  Nicholls, David [Editor] (2005) System Reliability Toolkit  Reliability information Analysis 
  Center
  
  O'Connor, Patrick D.T. (1991) Practical Reliability Engineering  John Wiley & Sons
  
  Vesely, W.E., Goldberg, F.F., Roberts, N.H., Haasl, D.F. (1981)  Fault Tree Handbook
  U.S.  Nuclear Regulatory Commission 
  
  Vesely, W.E., Stamatelato, M., Dugan, J., Fragola, J., Minarick, J., Railsback, J. (2002)
  Fault Tree Handbook with Aerospace Applications   NASA
  
  Doelp, L.C., Lee, G.K., Linney, R.E., Ormsby R.W. (1984) Quantitative fault tree analysis: Gate-by-gate method Plant/Operations Progress
  Volume 3, Issue 4 American Institute of Chemical Engineers
  
  Ericson II, Clifton A. (2011) Fault Tree Analysis Primer CreateSpace Inc.
}

\examples{
mytree <-ftree.make(type="or")
mytree <- addLogic(mytree, at=1, type= "and", name="A and B failed")
mytree <- addProbability(mytree, at=2, prob=.01, name="switch A failure")
mytree <- addProbability(mytree, at=2, prob=.01, name="switch B failure")
mytree <- addLogic(mytree, at=1, type= "and", name="A and C failed")
mytree <- addDuplicate(mytree, at=5, dup_id=3)
mytree <- addProbability(mytree, at=5, prob=.01, name="switch C failure")
mytree <- applyCollapse(mytree, on=5)
}

