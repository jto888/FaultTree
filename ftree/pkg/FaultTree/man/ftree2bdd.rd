\name{ftree2bdd}
\alias{ftree2bdd}

\title{ Generation of Binary Decision Diagram }

\description{Prepares a BDD string in if-then-else form '<tag,if,else>'}

\usage{
ftree2bdd(DF, ft_node=1)
}

\arguments{
\item{DF}{ A fault tree dataframe object.}
\item{ft_node}{A gate node ID treated as top of (sub)tree to be calculated.}
}

\references{
  Rauzy, Antoine (1993) "New algorithms for fault trees analysis"
   Reliabiity Engineering System Safety, volume 40
   
  Limnios, Nikolaos (2007) Fault Trees ISTE,Ltd.
}