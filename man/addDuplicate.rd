\name{addDuplicate}
\alias{addDuplicate}

\title{ Add a duplicated (repeated) event or entire branch to a fault tree. }

\description{Modifies an existing fault tree with the addition of the repeated nodes.}

\usage{
addDuplicate(DF, at, dup_id, display_under=NULL) 
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{at}{ The ID of the parent node for this addition.}
\item{dup_id}{The ID of a component event or root node of a branch to be repeated in a fault tree.}
\item{display_under}{Optionally, the ID of a sibling event under an OR gate for vertical alignment of
 only component nodes (MOE, not MOB) in the graphic display.}
}

\value{
Returns the input fault tree dataframe appended with a entry row(s) for the defined component event.
}

\details{
 This function is used to replicate the source event(s), not just copy for a similar item.
 Both the source and replicated nodes are notated in a MOE column of the fault tree dataframe.
 This notation will be used by future minimal cut set determination. Additionally, future
 editing functions can be notified and likely blocked on these items. 
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
}

\keyword{ reliability, risk, failure }

