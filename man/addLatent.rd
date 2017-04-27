\name{addLatent}
\alias{addLatent}

\title{ Add a Latent Component Event }

\description{Modifies an existing fault tree with the addition of a latent component event.}

\usage{
addLatent(DF, at, mttf, mttr=NULL, inspect=NULL, display_under=NULL,
		tag="", name="", name2="", description="")
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{at}{ The ID of the parent node for this addition.}
\item{mttf}{The mean time to failure.  It is the user's responsibility to maintain constant units of time.}
\item{mttr}{The mean time to repair (restore).  This should only be provided when system remains at risk, while repair is in progress, as it modifies probability by factor "pzero". It is the user's responsibility to maintain constant units of time.}
\item{inspect}{The time interval between inspections for the dormant component. (It will be possible upon future development to enter the string for the named inspection dataframe object.  In this case the inspection object will be read to get the inspection interval. An inspection object must be a dataframe with interval and duration columns. If a positive duration value other than zero is found it is taken that the system is at risk during the time of inspection. An unavailable probability calculated as duration/(interval+duration) will be added to the fractional downtime.}
\item{display_under}{Optionally, the ID of a sibling event under an OR gate for vertical alignment of the component node in the graphic display.}
\item{tag}{ A very short identifying string (typically 5 characters or less) uniquely identifying a basic event for minimal cutset evaluation}
\item{name}{ A short identifying string  (typically less than 24 characters)}
\item{name2}{ A second line, if needed for the identifying string label}
\item{description}{ An optional string providing more detail for the basic event.}
}

\value{
Returns the input fault tree dataframe appended with an entry row for the defined component event.
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
mytree <-ftree.make(type="and")
mytree <- addLatent(mytree, at=1, mttf=5,mttr=12/8760,inspect=1/26, name="e-gen set fails")
}

\keyword{ logic, risk, failure }

