# FaultTree
## Fault Tree Analysis on R

This R package is used to build a fault tree as a dataframe object. There is no GUI associated with this package. 
A tree is constructed by building a script with an initial ftree.make() call.  Subsequent addition of 
add... functions build up the tree.  

The logic gates of a fault tree are calculated from bottom to top
in a batch fashion. Logic gate calculations are performed using boolean algebra and cross-multiplication of demands (conditional fail rates) 
with failed state probability values. Latent component events assume exponential fail rates for calculation of fractional downtime values. It is possible to augment this package with the solution of Markov models, but this is a subject for
further development. As is, the presentation of simple results is believed to be more powerful for practical
purposes than seeking a more complex approach.

Output can be read as a sub-view of the dataframe object holding the tree. Alternatively, a graphical output
is available from a generated html file loaded into a browser with internet connectivity (for access to the D3 javascript library via cdn). This package can also be treated as an htmlwidget using the reverse-depend package FaultTree.widget at github/jto888/FaulTree.widget.
Eventual release to CRAN is expected to include the widget generation.

Minimal cut sets are now determined by the top-down MOCUS algorithm. This is a candidate for future C++ conversion using RcppArmadillo.

Those new to R and/or fault tree analysis are referred to http://www.openreliability.org/faulttree-users-tutorial/ for comprehensive installation and use instructions.

### Experienced R User Installation 
```r
# Install from this repo in GitHub
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools") }
devtools::install_github("jto888/FaultTree")
```
```r
## Load library once per session
library(FaultTree) 
```
**Example Scripts**  
### Example 1  
```r
tree1 <- ftree.make(type="priority",reversible_cond=TRUE, name="Site power loss")
tree1 <- addLogic(tree1, at=1, type="or", name="neither emergency", name2="generator operable")
tree1 <- addLogic(tree1, at=2, type="and", name="Independent failure", name2="of generators")
tree1 <- addLatent(tree1, at=3, mttf=5,mttr=12/8760,inspect=1/26, name="e-gen set fails")
tree1 <- addLatent(tree1, at=3, mttf=5,mttr=12/8760,inspect=1/26, name="e-gen set fails")
tree1 <- addLogic(tree1, at=2, type="inhibit", name="Common cause", name2="failure of generators")
tree1 <- addProbability(tree1, at=6, prob=.05, name="Common cause", name2="beta factor")
tree1 <- addLatent(tree1, at=6, mttf=5,mttr=12/8760,inspect=1/26, name="e-gen set fails")
tree1 <- addDemand(tree1, at=1, mttf=1.0, name="External power", name2="interruption")

tree1 <- ftree.calc(tree1)

tree1[,1:8]

## The tree can be displayed in the browser using the following commands:
ftree2html(tree1, write_file=TRUE)
browseURL('tree1.html')
```		
### Example 2
```r
tree2 <- ftree.make(type="or")
tree2 <- addLogic(tree2, type= "and", at= 1, name="2oo2 Active Pumps Fail")
tree2 <- addLogic(tree2, type= "or", at= 2, name="Pump A fails")
tree2 <- addActive(tree2,at=3,mttf=3,mttr=12/8760, name="Pump")
tree2 <- addLogic(tree2, type= "or", at= 2, name="Pump B fails")
tree2 <- addActive(tree2,at=5,mttf=3,mttr=12/8760, name="Pump")
tree2 <- ftree.calc(tree2)

tree2[,1:7]

# Visualization
ftree2html(tree2, write_file=TRUE)
browseURL('tree2.html')
```

### Example 3  **Minimal Cut Set Generation**
Based on an example described by *Clifton A. Ericson II* in Fault Tree Analysis Primer, *(2011) CreateSpace Inc.*
```r
pwr <- ftree.make(type="or", name="insufficient", name2="Electrical Power")
pwr <- addLogic(pwr, at=1, type="and", name="No Output", name2="G1, G2, G3")
pwr <- addLogic(pwr, at=2, type="or", name="No Power", name2="From G1")
pwr <- addLogic(pwr, at=3, type="or", name="No Output", name2="From G1")
pwr <- addProbability(pwr, at=3, prob=1, name="G1 Conn Open")
pwr <- addProbability(pwr, at=4, prob=1, name="Generator G1", name2="Fails")
pwr <- addLogic(pwr, at=4, type="or", name="No Input", name2="To G1")
pwr <- addProbability(pwr, at=7, prob=1, name="Engine E1", name2="Fails")
pwr <- addProbability(pwr, at=7, prob=1, name="Bleed Air To", name2="G1 Fails")
pwr <- addLogic(pwr, at=2, type="or", name="No Power", name2="From G2")
pwr <- addProbability(pwr, at=10, prob=1, name="G2 Conn Open")
pwr <- addLogic(pwr, at=10, type="or", name="No Output", name2="From G2")
pwr <- addLogic(pwr, at=12, type="or", name="No Input", name2="To G2")
pwr <- addDuplicate( pwr, at=13, dup_id=8)
pwr <- addProbability(pwr, at=13, prob=1, name="Bleed Air To", name2="G2 Fails")
pwr <- addProbability(pwr, at=12, prob=1, name="Generator G2", name2="Fails")
pwr <- addLogic(pwr, at=12, type="or", name="Switch To", name2="G2 Fails")
pwr <- addProbability(pwr, at=17, prob=1, name="Monitor M1", name2="Fails")
pwr <- addProbability(pwr, at=17, prob=1, name="Switching S1", name2="Fails")
pwr <- addLogic(pwr, at=2, type="or", name="No Power", name2="From G3")
pwr <- addLogic(pwr, at=20, type="or", name="No Output", name2="From G3")
pwr <- addProbability(pwr, at=20, prob=1, name="G3 Conn Open")
pwr <- addProbability(pwr, at=21, prob=1, name="Generator G3", name2="Fails")
pwr <- addLogic(pwr, at=21, type="or", name="No Input", name2="To G3")
pwr <- addProbability(pwr, at=24, prob=1, name="Engine E2", name2="Fails")
pwr <- addProbability(pwr, at=24, prob=1, name="Bleed Air To", name2="G2 Fails")
pwr <- addLogic(pwr, at=1, type="and", name="No Output", name2="G1, G2, G4")
pwr <- addDuplicate( pwr, at=27, dup_id=3)
pwr <- addDuplicate( pwr, at=27, dup_id=10)
pwr <- addLogic(pwr, at=27, type="or", name="No Power", name2="From G4")
pwr <- addProbability(pwr, at=45, prob=1, name="G4 Conn Open")
pwr <- addLogic(pwr, at=45, type="or", name="No Output", name2="From G4")
pwr <- addLogic(pwr, at=47, type="or", name="No Input", name2="To G4")
pwr <- addDuplicate( pwr, at=48, dup_id=25)
pwr <- addProbability(pwr, at=48, prob=1, name="Bleed Air To", name2="G4 Fails")
pwr <- addProbability(pwr, at=47, prob=1, name="Generator G4", name2="Fails")
pwr <- addLogic(pwr, at=47, type="or", name="Switch To", name2="G4 Fails")
pwr <- addDuplicate( pwr, at=52, dup_id=18)
pwr <- addDuplicate( pwr, at=52, dup_id=19)
pwr <- addLogic(pwr, at=1, type="and", name="No Output", name2="G1, G3, G4")
pwr <- addDuplicate( pwr, at=55, dup_id=3)
pwr <- addDuplicate( pwr, at=55, dup_id=20)
pwr <- addDuplicate( pwr, at=55, dup_id=45)
pwr <- addLogic(pwr, at=1, type="and", name="No Output", name2="G2, G3, G4")
pwr <- addDuplicate( pwr, at=80, dup_id=10)
pwr <- addDuplicate( pwr, at=80, dup_id=20)
pwr <- addDuplicate( pwr, at=80, dup_id=45) 
cutsets(pwr)

# Visualization
ftree2html(pwr, write_file=TRUE)
browseURL('pwr.html')

```