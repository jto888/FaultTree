# FaultTree
fault tree back office prototype

This R package is used to build a fault tree as a dataframe object. 
A tree is constructed by an initial ftree.make() call.  Subsequent addition of 
add... functions build up the tree.  The logic gates of a fault tree are calculated from bottom to top
in a batch fashion.

There is no GUI associated with this package, yet. A user is expected to code scripts defining the tree as a final version. 
Minimal cutsets are not yet determined with this package, a study of algorithm candidates is underway.
Logic gate calculations are performed using booleanalgebra and cross-multiplication of demands (conditional fail rates) 
with failed state probability values. Dormant component events assume exponential fail rates for calculation of fractional downtime values.

It is possible to augment this package with the solution of Markov models, but this is a subject for
further development. As is, the presentation of simple results is believed to be more powerful for practical
purposes than seeking a more complex approach.

Output is can be read as a sub-view of the dataframe object holding the tree. Alternatively, a graphical output
is available from a generated html file loaded into a browser with internet connectivity (for access of the D3 javascript library via cdn). 

Example Scripts:

## load library once per session
library(FaultTree)

## example 1
tree1<-ftree.make(type="cond",repairable_cond=TRUE, name="Site power loss")

tree1<-addLogic(tree1, at=1, type="or", name="neither emergency", name2="generator operable")

tree1<-addLogic(tree1, at=2, type="and", name="Independent failure", name2="of generators")

tree1<-addLatent(tree1, at=3, mttf=5,mttr=12/8760,inspect=1/26, name="e-gen set fails")

tree1<-addLatent(tree1, at=3, mttf=5,mttr=12/8760,inspect=1/26, name="e-gen set fails")

tree1<-addLogic(tree1, at=2, type="inhibit", name="Common cause", name2="failure of generators")

tree1<-addProbability(tree1, at=6, prob=.05, name="Common cause", name2="beta factor")

tree1<-addLatent(tree1, at=6, mttf=5,mttr=12/8760,inspect=1/26, name="e-gen set fails")

tree1<-addDemand(tree1, at=1, mttf=1.0, name="External power", name2="interruption")

tree1<-ftree.calc(tree1)

tree1[,1:7]

## The tree can be displayed in the browser using the following commands:

ftree2html(tree1, write_file=TRUE)
browseURL('tree1.html')
		
## example 2
tree2<-ftree.make(type="or")

tree2<-addLogic(tree2, type= "and", at= 1, name="2oo2 Active Pumps Fail")

tree2<-addLogic(tree2, type= "or", at= 2, name="Pump A fails")

tree2<-addActive(tree2,at=3,mttf=3,mttr=12/8760, name="Pump")

tree2<-addLogic(tree2, type= "or", at= 2, name="Pump B fails")

tree2<-addActive(tree2,at=5,mttf=3,mttr=12/8760, name="Pump")

tree2<- ftree.calc(tree2)

tree2[,1:7]


ftree2html(tree2, write_file=TRUE)
browseURL('tree2.html')
