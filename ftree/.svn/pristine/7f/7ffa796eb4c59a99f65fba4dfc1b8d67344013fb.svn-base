\name{readSCRAMprobability}
\alias{readSCRAMprobability}

\title{ Parse SCRAM output files to extract probability result }

\description{Line-by-line text parsing of a known XML presentation format.
}

\usage{
readSCRAMprobability(x, dir="")
}

\arguments{
\item{x}{ The local file name of SCRAM output of interest.}
\item{dir}{A character string for an absolute directory in which R can read and write.}
}

\value{
Returns a list object consisting of [[1]] a scalar vector (single value) which is the exact probability calculation via BDD analysis and [[2]] 
a dataframe of minimal cutsets (padded with NA as appropriate) with the probability product of each set.
}

\details{
SCRAM produces a consistently formated report for probability analysis. This is parsed on a line-by-line basis to extract the probability result.
}

\references{
  Rauzy, Antoine, et. al.  (2013) Open PSA Model Exchange Format v2.0 open-psa.org
  
  Limnios, Nikolaos (2007) Fault Trees ISTE Ltd.

  Nicholls, David [Editor] (2005) System Reliability Toolkit  Reliability information Analysis 
  Center
  
  O'Connor, Patrick D.T. (1991) Practical Reliability Engineering  John Wiley & Sons
}

\examples{
## This function is completely device dependent.
}

\keyword{ logic, risk, failure }