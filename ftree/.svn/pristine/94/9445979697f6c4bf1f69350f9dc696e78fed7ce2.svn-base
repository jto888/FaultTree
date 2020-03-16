\name{scram.uncertainty}
\alias{scram.uncertainty}

\title{ Fault Tree Uncertainty Analysis Acquired from SCRAM }

\description{Interconnection with SCRAM by transferred XML files permits stochastic calculation of uncertainty factors for cut sets.
}

\usage{
scram.uncertainty(DF, ntrials=1000, nbin=20, show=c(FALSE, FALSE))
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions. 
Fault tree basic elements must be either probability or exposed types, INHIBIT gates will be converted to AND. 
Fault tree shall not contain PRIORITY, ALARM nor VOTE gates, voting is [to be] handled by the atleast gate type.}
\item{ntrials}{The quantity of stochastic trials to be run for analysis.}
\item{nbin}{The number of histogram bins to accumulate output results. This specification will also set the number of quantiles calculated.}
\item{show}{A logigal vector determining whether to display [1] a histogram or [2] a plot of upper and lower bounds by quantile obtained from uncertainty analysis.}
}

\value{
Returns a list containing $probability, $quantiles, and $histogram data from uncertainty analysis.
}

\details{
"And one ring to bind them all ..." This function calls ftree2mef, callSCRAM, and readSCRAMuncertainty
 appropriately for the entered ftree object. Temporary files for SCRAM input and output are produced in the process.
 Graphical output is generated from readSCRAMuncertainty. For larger models with extensive trials additional graphics
 calls should be more efficiently made on readSCRAMuncertainty directly.
}

\references{
  Rauzy, Antoine, et. al.  (2013) Open PSA Model Exchange Format v2.0 open-psa.org
  
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

