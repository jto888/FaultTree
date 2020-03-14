\name{addLogic}
\alias{addLogic}

\title{ Add a Logic Gate }

\description{Modifies an existing fault tree with the addition of a logic gate.}

\usage{
addLogic(DF, type, at, reversible_cond=FALSE, cond_first=TRUE, human_pbf=NULL,
		vote_par=NULL, tag="", label="", name="", name2="", description="") 
}

\arguments{
\item{DF}{A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{type}{A string signifying the type of logic to be applied. Implemented gate types "or","and","inhibit","conditional" (or "cond"), and "alarm" have been implemented.}
\item{at}{The ID or tag name of the parent node for this addition.}
\item{reversible_cond}{A boolean value used only by the conditional gate type indicating whether repair of the input condition is viable to the model.}
\item{cond_first}{A boolean signifying whether the first child to an INHIBIT, ALARM, or PRIORITY logic gate should be taken as the condition.
 Alternatively, if FALSE, the second child will be taken as a condition.  This is primarily a graphic display issue.}
\item{human_pbf}{A probability of failure for a human to respond as needed to an alarm. This value is only used by the alarm gate.}
\item{vote_par}{ A vector of vote parameters as c(k,n) for k of n voting.}
\item{tag}{ A very short identifying string (typically 5 characters or less) uniquely identifying a basic event for minimal cutset evaluation}
\item{label}{An identifying string for the logic gate. Use of label in ftree.make defines the convention for rest of tree construction.}
\item{name}{A short identifying string (typically less than 24 characters)}
\item{name2}{ A second line, if needed for the identifying string label}
\item{description}{ An optional string providing more detail for the resultant event.}
}

\value{
Returns the input fault tree dataframe appended with an entry row to accept the result of the logic calculation.
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
mytree <-ftree.make(type="cond", reversible_cond=TRUE, name="power outage")
mytree<-addLogic(mytree, at=1, type="and", name="neither emergency", name2="generator operable")
mytree<-addLatent(mytree, at=2, mttf=5,mttr=12/8760,inspect=1/26, name="e-gen set fails")
mytree<-addLatent(mytree, at=2, mttf=5,mttr=12/8760,inspect=1/26, name="e-gen set fails")
mytree <- addDemand(mytree,  at=1, mttf=1, name="incomming power", name2="interruption")
}

\keyword{ logic, risk, failure }

