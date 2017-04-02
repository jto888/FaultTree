\name{addHouse}
\alias{addHouse}

\title{ Add a Given Condition }

\description{Modifies an existing fault tree with the addition of a 'house' element. 
House elements signify some underlying condition and can only have probability of 1 (True) or 0 (False.
They have traditionally been added to fault trees for clarity of presentation only.}

\usage{
addHouse(DF, at, prob=1, tag="", name="", name2="", description="") 
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{at}{ The ID of the parent node for this addition.}
\item{prob}{A probability value of 1 or 0}
\item{tag}{ A very short identifying string (typically 5 characters or less) uniquely identifying a basic event for minimal cutset evaluation}
\item{name}{ A short identifying string  (typically less than 24 characters)}
\item{name2}{ A second line, if needed for the identifying string label}
\item{description}{ An optional string providing more detail for this condition.}
}

\value{
Returns the input fault tree dataframe appended with an entry row for the defined house element.
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
mytree <-ftree.make(type="and", name="Pump Function", name2="Failed")
mytree<-addActive(mytree,at=1,mttf=3,mttr=12/8760, name="Pump")
mytree <- addHouse(mytree, at=1, prob=1, name="Pump Function", name2="Required")
}

\keyword{ logic, risk, failure }

