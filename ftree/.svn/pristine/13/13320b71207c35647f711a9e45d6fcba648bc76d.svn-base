\name{cutsets}
\alias{cutsets}

\title{ Fault Tree Minimal Cut Set Determination}

\description{Determines minimal cutsets by various methods.
}

\usage{
cutsets(DF, ft_node=1, method="mocus", by="tag")  
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{ft_node}{A gate node ID treated as top of (sub)tree to be calculated.}
\item{method}{The method for calculation either 'mocus' or 'prime-implicants'}
\item{by}{Selection of identifier for each element of the cutset either 'tag' or 'id'}
}
\value{
Returns a list of matrices for each of cut set lengths found. Each element is defined by its unique ID assigned in the fault tree
or by its unique Tag applied by the user.
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

  Rauzy, Antoine (1993) "New algorithms for fault trees analysis"
   Reliabiity Engineering System Safety, volume 40
   
  Limnios, Nikolaos (2007) Fault Trees ISTE,Ltd.
}

\examples{
minex2<-ftree.make(type="and")
minex2<-addProbability(minex2, at="top", prob=.01, tag="X1", name="X1")
minex2<-addLogic(minex2, at="top", type="or", tag="G1", name="G1")
minex2<-addProbability(minex2, at="G1", prob=.02, tag="X2", name="X2")
minex2<-addProbability(minex2, at="G1", prob=.03, tag="X3", name="X3")
minex2<-addLogic(minex2, at="top", type="or", tag="G2", name="G2")
minex2<-addDuplicate(minex2, at="G2", dup_of="X3")
minex2<-addProbability(minex2, at="G2", prob=.04, tag="X4", name="X4")
minex2_cs<-cutsets(minex2)
}

\keyword{ logic, risk, failure }

