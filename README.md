# ftree
fault tree and event tree back office prototype

This R package is used to build a fault tree (or alternatively an event tree) as a dataframe object. 
A tree is constructed by an initial ftree.make() or etree.make() call.  Subsequent addition of 
add... functions build up the tree.  The logic gates of a fault tree are calculated from bottom to top
in a batch fashion.  Event trees are much simpler and calculations proceed during the tree construction.

There is no GUI associated with this package, nor is one expected in the R environment. A user is expected
to code scripts defining the tree as a final version. Minimal cutsets are not determined with this package
since the tree to be built assumes this to be a final tree. Logic gate calculations are performed using boolean
algebra and cross-multiplication of demands with unreliability values. Dormant component events assume
exponential fail rates for calculation of fractional downtime values.

It is possible to augment this package with the solution of Markov models, but this is a subject for
further development. As is, the presentation of simple results is believed to be more powerful for practical
purposes than seeking a more scholarly approach.
