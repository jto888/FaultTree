\name{tagconnect}
\alias{tagconnect}

\title{ Interpretation of Node ID by tag Name }

\description{Enables tree building improvement by allowing reference to nodes by tag.}

\usage{
tagconnect(DF, at, source=FALSE)
}

\arguments{
\item{DF}{ A fault tree dataframe such as returned from ftree.make or related add... functions.}
\item{at}{ An ID value or tag name for reference to a node.}
\item{source}{ A logical indicating whether to evaluate multiple occurences of the tag to identify the
 source of duplication. Default of FALSE will cause the function to fail in case of multiple occurence of tag provided as 'at'.}
}

\value{
Returns the ID value for the node whether it is a tag string or the actual ID value.
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
mytree <-ftree.make(type="and", name="common cause failure", name2="of redundant pumps")
mytree<-addActive(mytree,at="top",mttf=3,mttr=12/8760, tag="p1", name="Pump")
mytree <- addProbability(mytree,  at="top", prob=.05, name="common cause", name2="beta factor")
pumpIDvalue<-tagconnect(mytree, at="p1")
}


