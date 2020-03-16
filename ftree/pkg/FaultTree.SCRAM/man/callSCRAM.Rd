\name{callSCRAM}
\alias{callSCRAM}

\title{ A wrapper function for creating a call to the SCRAM program }

\description{Prepares an xml file suitable for reading into open-psa programs such as SCRAM
}

\usage{
callSCRAM(DFname, scram_arg="mocus", arg2="", arg3="")
}

\arguments{
\item{DFname}{A string of the underlying ftree dataframe, intended for use when calling (using do.call) inside function environments where this name information has been lost}
\item{scram_arg}{One of several documented arguments (following --) as listed in scram --help.}
\item{arg2}{A second argument, usually a positive boolean (yes, 1, true) as required by certain SCRAM calls.}
\item{arg3}{A third argument, typically used for added control over certain SCRAM analyses.}

}

\value{
No value is returned. Given the appropriate arguments SCRAM will write output to disk.
}

\details{
SCRAM is a free and open source probabilistic risk analysis tool that supports the Open-PSA Model Exchange Format.
For SCRAM installation reference:  https://scram-pra.org/doc/installation.html  Assure that the SCRAM executable is on the environment PATH.
It is expected that all analysis arguments provided are applicable to the fault tree model delivered via mef. No checking has been provided.
}

\references{
  Rauzy, Antoine, et. al.  (2013) Open PSA Model Exchange Format v2.0 open-psa.org
  
  Limnios, Nikolaos (2007) Fault Trees ISTE Ltd.

  Nicholls, David [Editor] (2005) System Reliability Toolkit  Reliability information Analysis 
  Center
  
  O'Connor, Patrick D.T. (1991) Practical Reliability Engineering  John Wiley & Sons
}

\examples{
N<-ftree.make(type="or", name=" no Functionality ", name2=" at N5")
N<-addProbability(N, at=1, prob= 0.7, name="Failure Probability", name2="of N5", tag="N5")
N<-addLogic(N, at=1, type="and", name="no Functionality", name2="from Externalities of N5")
N<-addLogic(N, at=3, type="or", name="no Functionality", name2="of N3")
N<-addLogic(N, at=3, type="or", name="no Functionality", name2="of N4")
N<-addProbability (N, at=4, prob= 0.8, name="Failure Probability", name2="of N3", tag="N3")
N<-addProbability (N, at=4, prob= 0.9, name="Failure Probability", name2="of N1", tag="N1")
N<-addProbability (N, at=5, prob= 0.6, name="Failure Probability", name2="of N4", tag="N4")
N<-addLogic(N, at=5, type="and", name="no Functionality", name2="from Externalities of N4")
N<-addDuplicate( N, at=9, dup_id=7)
N<-addProbability (N, at=9, prob= 0.5, name="Failure Probability", name2="of N2", tag="N2")

ftree2mef(N)
\dontrun{
callSCRAM(N)
}
}

\keyword{ logic, risk, failure }

