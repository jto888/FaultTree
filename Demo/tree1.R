if(exists("mission_time")) rm(mission_time)
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

ftree2html(tree1, write_file=TRUE)
browseURL("tree1.html") 