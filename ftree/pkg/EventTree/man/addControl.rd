\name{addControl}
\alias{addControl}

\title{ Add a Mitigating Control an Event Tree }

\description{Modifies an existing event tree with the addition of a mitigating control node.}

\usage{
addControl(DF, at, prob, severity, name="", description="", overwrite=FALSE) 
}

\arguments{
\item{DF}{ An event tree dataframe such as returned from etree.make or subsequent addCtrl functions.}
\item{at}{ The ID of the parent node for this addition.}
\item{prob}{The probability of success for this mitigating control}
\item{severity}{Severity level upon successful outcome of this control. Severity does not enter into any calculation, but will be passed down to complimentary hazard states.}
\item{name}{ A short identifying string }
\item{description}{ An optional string providing more detail for the mitigating control action.}
\item{overwrite}{A logical entry indicating whether this control should overwrite the 'hazard' outcome it is connecting to.}
}

\value{
Returns the input event tree dataframe appended with entry rows for the defined control and its complimentary hazard state.
}
 
\references{
  
  O'Connor, Patrick D.T. (1991) Practical Reliability Engineering  John Wiley & Sons
  
}

\examples{
mytree <- etree.make(name="conveyor belt fire")
mytree <-addControl(mytree,at=1, prob=.99, severity=.9, name="heat sensor detects")
}

\keyword{ logic, risk, failure }

