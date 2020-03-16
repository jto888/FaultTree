\name{addAtLeast}
\alias{addAtLeast}

\title{ Add a type of vote gate to a PRA model }

\description{Modifies an existing fault tree with the addition of an atleast gate, specifically for SCRAM processing.}

\usage{
addAtLeast(DF, at, atleast, tag="", label="", name="",name2="", description="")
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{at}{ The ID or tag name of the parent node for this addition.}
\item{atleast}{A value for the minimum combination size for consideration. }
\item{tag}{ A very short identifying string (typically 5 characters or less) uniquely identifying a basic event for minimal cutset evaluation}
\item{label}{An identifying string for the logic gate. Use of label in ftree.make defines the convention for rest of tree construction.}
\item{name}{ A short identifying string  (typically less than 24 characters)}
\item{name2}{ A second line, if needed for the identifying string label}
\item{description}{ An optional string providing more detail for this event.}
}

\value{
Returns the input fault tree dataframe appended with an entry row for the defined atleast gate
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
test_gate<-ftree.make(type="or", name="test")
test_gate<-addAtLeast(test_gate, at=1, atleast=2, name="atleast test")
# R-Forge check fails for Linux due to earlier FaultTree version on server
#test_gate<-addProbability(test_gate, at=2, prob=.5, tag="e1", name="test probability")
#test_gate<-addProbability(test_gate, at=2, prob=.5, tag="e2", name="test probability")
#test_gate<-addProbability(test_gate, at=2, prob=.5, tag="e3", name="test probability")
}

\keyword{ logic, risk, failure }

