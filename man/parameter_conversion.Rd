\name{parameter_conversion}
\alias{parameter_conversion}

\title{ Parameter Conversion Helper Functions }

\description{Access to a set of functions performing paramter conversions applicable to FaultTree scripting needs,
}

\usage{
parameter_conversion(conv, param)
}

\arguments{
\item{conv}{A string holding the name of a cnversion function, or its assigned numerical equivalent.}
\item{param}{A vector holding values appropriate for the requested conversion. See Details below.}
}

\value{
Returns a value according to the conversion requested.
}

\details{
Conversion functions and their expected arguments are listed as follows:

    conv                param[1]    param[2]    param[3]
    1   "prob2lam"      prob
    2   "prob2meanw"    prob        wshape      time_shift
    3   "wscale2mean"   wscale      wshape      time_shift
    4   "meanw2scale"   wmean       wshape      time_shift
    5   "sigma2ef"      sigma       conf_limit
    6   "ef2sigma"      ErrFunc     conf_limit
    7   "meanln2mu"     meanln      sigma

}

\references{
  Fussell, J., Vesely, W.E. (1972) A New Method for Obtaining Cut Sets for Fault Trees  Transactions ANS, No. 15

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
mission_time=20
mttf<-1/parameter_conversion("prob2lam", .2)
}


