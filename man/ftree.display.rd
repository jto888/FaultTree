\name{ftree.display}
\alias{ftree.display}

\title{Display a Fault Tree in the Web Browser}

\description{Writes an interactive HTML representation of an ftree to a temporary
file and opens it in the user's default web browser.}

\usage{
ftree.display(DF)
}

\arguments{
\item{DF}{An ftree data frame object produced by the package (see \code{ftree.make}).}
}

\value{This function is called for its side effect. It writes an HTML file into
\code{tempdir()} and launches the user's browser via \code{browseURL()}. It does not
return a value.}

\details{Use \code{ftree.display} to view fault trees interactively. Internally this
function calls \code{ftree2html2()} to construct the HTML content; typical package
users should not call \code{ftree2html2} directly.}

\seealso{\code{ftree2html}, \code{ftree2html2}, \code{ftree.make}}

\examples{
mytree <- ftree.make(type="or", name="site power loss")
ftree.display(mytree)
}
