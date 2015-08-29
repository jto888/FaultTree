\name{etree.make}
\alias{etree.make}

\title{ Event Tree Creation }

\description{etree.make prepares an initial, single row, dataframe, which will be built upon as the tree is developed.
}

\usage{
etree.make(name="initiating event", severity=1, description="")
}

\arguments{
\item{name}{ An identifying string for the initiating event}
\item{description}{ An optional string providing more detail for the event.}
}

\value{
Returns a dataframe containing 13 columns for holding data, results, and connection information.
}

\references{

}

\examples{
mytree <- etree.make(name="conveyor belt fire")
}

\keyword{ logic, risk, failure }

