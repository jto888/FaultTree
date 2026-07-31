\name{ftree2html2}
\alias{ftree2html2}

\title{Low-level HTML generator for Fault Trees}

\description{Constructs the HTML content used to render an ftree as an interactive
D3-based web page. This function is primarily intended for internal or
diagnostic use; typical users should call \code{ftree.display()} instead.}

\usage{
ftree2html2(DF, DFname = "", write_file = TRUE)
}

\arguments{
\item{DF}{An ftree data frame object produced by the package (see \code{ftree.make}).}
\item{DFname}{Optional character string used as the base file name when writing
the output. If empty the deparsed name of \code{DF} will be used.}
\item{write_file}{Logical; if \code{TRUE} the HTML is written to a file in
\code{tempdir()} and the path is returned invisibly. If \code{FALSE} the
function prints (and returns) the HTML character vector for inspection.}
}

\value{When \code{write_file = FALSE} the function returns a character vector
containing the HTML document. When \code{write_file = TRUE} the function writes
the HTML to a temporary file and returns the full path invisibly.}

\details{The generated HTML includes embedded copies of the package's bundled
JavaScript assets (jQuery and D3) so the page works without external network
requests. Because this is a low-level helper, behaviour and output format may
change between package versions. Use \code{ftree.display()} for the stable,
user-facing behaviour.}

\seealso{\code{ftree.display}, \code{ftree2html}, \code{ftree.make}}

\examples{
mytree <- ftree.make(type = "or", name = "site power loss")
## Inspect the raw HTML string without writing a file
html_vec <- ftree2html2(mytree, DFname = "mytree", write_file = FALSE)
cat(substr(html_vec, 1, 500), "\n")
}
