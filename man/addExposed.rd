\name{addExposed}
\alias{addExposed}

\title{ Add a Time Dependant, Non-Repairable, Event }

\description{Adds a basic component event to a fault tree in which probability of failure 
 is defined by a probability distribution and exposure time.}

\usage{
addExposed(DF, at, mttf, dist="exponential", param=NULL, display_under=NULL,
		tag="", exposure=NULL, label="", name="",name2="", description="")
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{at}{ The ID or tag name of the parent node for this addition.}
\item{mttf}{The mean time to failure.  It is the user's responsibility to maintain constant units of time.}
\item{dist}{The probabilty distribution to be used for defining probability of failure from mttf, and a possible extra parameter. Options for "exponential" and "weibull" have been implemented.}
\item{param}{A vector containing shape and time_shift for weibull exposed events in that order.}
\item{display_under}{Optionally, the ID of a sibling event under an OR gate for vertical alignment of the component node in the graphic display.}
\item{tag}{ A very short identifying string (typically 5 characters or less) uniquely identifying a basic event for minimal cutset evaluation}
\item{exposure}{This is to be a seldom-used override of system mission time applicable only to exponentially exposed events.}
\item{label}{An identifying string for the logic gate. Use of label in ftree.make defines the convention for rest of tree construction.}
\item{name}{ A short identifying string  (typically less than 24 characters)}
\item{name2}{ A second line, if needed for the identifying string label}
\item{description}{ An optional string providing more detail for this probability.}
}

\value{
Returns the input fault tree dataframe appended with an entry row for the defined failure event.
}

\details{
The lambda for exponential definition is taken as 1/mttf, which is the value stored in CFR for the tree node.
Weibull distributions have a mean, which differs from the classical scale parameter by a factor determined as gamma(1+1/shape).
The weibull scale is determined from the value stored in CFR (as 1/mttf) for the tree node. Additional parameters to fully define
the specific distribution of expected failure times are the shape and any time_shift.
}

\references{
  Ericson, Clifton A. II (2011) Fault Tree Analysis Primer  CreateSpace Inc.
  
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
mission_time<-0.5
mytree <-ftree.make(type="or", name="6-month task", name2="incomplete")
mytree <- addExposed(mytree,  at=1, mttf=3, name="pump fails",
   name2="before completion")
}


