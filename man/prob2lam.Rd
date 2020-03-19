\name{prob2lam}
\alias{prob2lam}

\title{ reverse calculation of exponential lambda from probability }

\description{A simplistic helper function for converting fixed probability to a fail rate using known exposure time.
}

\usage{
prob2lam(prob)		
}

\arguments{
\item{prob}{ A fixed probability value that is to be converted to fail rate for exposed element entry.
}
}

\value{
Returns the lambda value that will produce the fixed probability with environment object mission_time.
}

\references{
  Nicholls, David [Editor] (2005) System Reliability Toolkit  Reliability information Analysis 
  Center
  
  O'Connor, Patrick D.T. (1991) Practical Reliability Engineering  John Wiley & Sons
  
  Ericson II, Clifton A. (2011) Fault Tree Analysis Primer CreateSpace Inc.
}

\examples{
mission_time<-8760
mttf=1/prob2lam(.6)
}
