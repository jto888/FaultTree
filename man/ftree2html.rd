\name{ftree2html}
\alias{ftree2html}

\title{ Fault Tree Rendered in HTML }

\description{Prepares a web page from an ftree dataframe for a visualization of the data.
}

\details{This function is deprecated. Use \code{ftree.display()} instead.  The original
\code{ftree2html} implementation wrote files into the user's working directory which
violates current CRAN policies. The package now provides \code{ftree.display} which
writes the temporary HTML file into \code{tempdir()} and opens it in the user's
browser. The lower-level function \code{ftree2html2} is used internally by
\code{ftree.display} and is not intended for direct use by typical users.}

\usage{
ftree2html(DF,dir="", write_file=TRUE)
}

\arguments{
\item{DF}{ A fault tree dataframe object.}
\item{dir}{A character string for an absolute directory in which R can read and write.}
\item{write_file}{A logical controlling whether to perform the write operation.}
}

\value{
Returns a character vector with escaped quote characters, suitable for writing to disk.
Optionally, this vector will be written to a file taking the name of the object passed in as DF and appending '.html'.
}

\examples{
mytree <- ftree.make(type="or", name="site power loss")
## Deprecated: use ftree.display to show the tree in a browser
\dontrun{
	ftree.display(mytree)
	}
}


