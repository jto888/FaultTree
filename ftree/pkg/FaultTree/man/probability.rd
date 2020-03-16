\name{probability}
\alias{probability}

\title{ Probability Calculstion by BDD or mcub }

\description{Performs a calculation at a selected fault tree gate node.}

\usage{
probability(DF, ft_node=1, method="bdd") 
}

\arguments{
\item{DF}{A fault tree dataframe object.}
\item{ft_node}{A gate node ID treated as top of (sub)tree to be calculated.}
\item{method}{The method for calculation either 'bdd' or 'mcub'}
}

\details{For BDD probability a binary decision diagram is generated on which
a recusive algorithm is operated to generate the exact probablility. For mcub
(minimal cutset upper bound) the mocus algorithm is run to determine minimal cutsets.
The upper bound estimate for probability is calculated by a probabilistic sum of 
the individual cutset probabilities.}

\references{
  Ericson, Clifton A. II (2011) Fault Tree Analysis Primer  CreateSpace Inc.

  Rauzy, Antoine (1993) "New algorithms for fault trees analysis"
   Reliabiity Engineering System Safety, volume 40
   
  Limnios, Nikolaos (2007) Fault Trees ISTE,Ltd.
}