\name{ftree2mef}
\alias{ftree2mef}

\title{ Translate fault tree object to Model Exchange Format }

\description{Prepares an xml file suitable for reading into open-psa programs such as SCRAM
}

\usage{
ftree2mef(DF, DFname="", dir="", write_file=FALSE)
}

\arguments{
\item{DF}{ A fault tree dataframe object.}
\item{DFname}{A string of the underlying ftree dataframe, intended for use when calling (using do.call) inside function environments where this name information has been lost}
\item{dir}{A character string for an absolute directory in which R can read and write.}
\item{write_file}{A logical controlling whether to perform the write operation.}
}

\value{
Returns a character vector with escaped quote characters, suitable for writing to disk.
Optionally, this vector will be written to a file taking the name of the object passed
 in as DF (over-ridden by name that may be provided in DFname) and appending '_mef.xml'.
}

\details{
Only coherent fault trees are handled. Fault trees incorporating  ALARM, or VOTE
 gates are excluded, as are fault trees incorporating Demand type basic elements.
 INHIBIT and PRIORITY gates are converted to AND.
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
# note write-file argument has default FALSE
ftree2mef(N)
}

\keyword{ logic, risk, failure }

