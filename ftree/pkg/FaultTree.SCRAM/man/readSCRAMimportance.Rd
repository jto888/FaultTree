\name{readSCRAMimportance}
\alias{readSCRAMimportance}

\title{ Parse SCRAM output files to extract importance results }

\description{Line-by-line text parsing of a known XML presentation format.
}

\usage{
readSCRAMimportance(x, dir="")
}

\arguments{
\item{x}{ The local file name of SCRAM output of interest.}
\item{dir}{A character string for an absolute directory in which R can read and write.}
}

\value{
Returns a dataframe containing the importance value for each basic-event obtained by 5 different measures.
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