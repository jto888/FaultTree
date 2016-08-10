\name{addExposed}
\alias{addExposed}

\title{ Add a Pure Probability }

\description{Adds a basic component event to a fault tree in which probability of failure 
 is defined by fail rate and exposure time.}

\usage{
addExposed(DF, at, mttf, exposure=NULL, dist="exponential", p2=NULL,
		display_under=NULL, tag="", name="",name2="", description="")
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{at}{ The ID of the parent node for this addition.}
\item{mttf}{The mean time to failure.  It is the user's responsibility to maintain constant units of time.}
\item{exposure}{The mission time over which a system is exposed to failure.}
\item{dist}{The probabilty distribution to be used for defining probability of failure from mttf, and a possible extra parameter. Default is "exponential", expected implementation of "weibull" to follow.}
\item{p2}{A placeholder for a second parameter for 2-parameter failure distribution, such as "weibull". Not yet implemented.}
\item{display_under}{Optionally, the ID of a sibling event under an OR gate for vertical alignment of the component node in the graphic display.}
\item{tag}{ A very short identifying string (typically 5 characters or less) uniquely identifying a basic event for minimal cutset evaluation}
\item{name}{ A short identifying string  (typically less than 24 characters)}
\item{name2}{ A second line, if needed for the identifying string label}
\item{description}{ An optional string providing more detail for this probability.}
}

\value{
Returns the input fault tree dataframe appended with an entry row for the defined failure event.
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
mytree <-ftree.make(type="or", name="6-month task", name2="incomplete")
mytree <- addExposed(mytree,  at=1, mttf=3, exposure=0.5, name="pump fails",
   name2="before completion")
}

\keyword{ logic, risk, failure }

