\name{scram.importance}
\alias{scram.importance}

\title{ Fault Tree Importance Factor Determination Acquired from SCRAM }

\description{Interconnection with SCRAM by transferred XML files permits advanced calculation of importance factors for cut sets.
}

\usage{
scram.importance(DF)
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions. 
Fault tree basic elements must be either probability or exposed types, INHIBIT gates will be converted to AND. 
Fault tree shall not contain PRIORITY, ALARM nor VOTE gates, voting is [to be] handled by the atleast gate type.}
}

\value{
Returns a dataframe containing the importance value for each basic-event obtained by 5 different measures.
}

\details{
"And one ring to bind them all ..." This function calls ftree2mef, callSCRAM, and readSCRAMimportance
 appropriately for the entered ftree object. Temporary files for SCRAM input and output are produced in the process.
 Measures returned are: Fussel-Vesely Diagnosis Importance Factor (DIF), Birnbaum Marginal Importance Factor (MIF),
 Critical Importance Factor (CIF), Risk Reduction Worth (RRW), and Risk Achievement Worth (RAW).
}

\references{
  Rauzy, Antoine, et. al.  (2013) Open PSA Model Exchange Format v2.0 open-psa.org
  
  Dutuit,Y. and Rauzy, A. (2001) "Efficient algorithms to assess component and gate importance in fault tree analysis" IEEE Trans. Reliab. Eng. Sysl Saf, vol.72, no, 2001
  
  Limnios, Nikolaos (2007) Fault Trees ISTE Ltd.

  Nicholls, David [Editor] (2005) System Reliability Toolkit  Reliability information Analysis 
  Center
  
  O'Connor, Patrick D.T. (1991) Practical Reliability Engineering  John Wiley & Sons
  
  Fussell, J., Vesely, W.E. (1972) A New Method for Obtaining Cut Sets for Fault Trees  Transactions ANS, No. 15
  
  Ericson, Clifton A. II (2011) Fault Tree Analysis Primer  CreateSpace Inc.
    
  Vesely, W.E., Goldberg, F.F., Roberts, N.H., Haasl, D.F. (1981)  Fault Tree Handbook
  U.S.  Nuclear Regulatory Commission 
  
  Vesely, W.E., Stamatelato, M., Dugan, J., Fragola, J., Minarick, J., Railsback, J. (2002)
  Fault Tree Handbook with Aerospace Applications   NASA
  
  Doelp, L.C., Lee, G.K., Linney, R.E., Ormsby R.W. (1984) Quantitative fault tree analysis: Gate-by-gate method Plant/Operations Progress
   Volume 3, Issue 4 American Institute of Chemical Engineers

}

\examples{
## This function is completely device dependent.
}

\keyword{ logic, risk, failure }

