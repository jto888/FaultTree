pwr<-ftree.make(type="or", name="insufficient", name2="Electrical Power")
pwr<-addLogic(pwr, at=1, type="and", name="No Output", name2="G1, G2, G3")
pwr<-addLogic(pwr, at=2, type="or", name="No Power", name2="From G1")
pwr<-addLogic(pwr, at=3, type="or", name="No Output", name2="From G1")
pwr<-addProbability(pwr, at=3, prob=1e-4, tag="G1A", name="G1 Conn Open")
pwr<-addProbability(pwr, at=4, prob=1e-3, tag="G1", name="Generator G1", name2="Fails")
pwr<-addLogic(pwr, at=4, type="or", name="No Input", name2="To G1")
pwr<-addProbability(pwr, at=7, prob=1e-3, tag="E1", name="Engine E1", name2="Fails")
pwr<-addProbability(pwr, at=7, prob=1e-4, tag="G1B", name="Bleed Air To", name2="G1 Fails")
pwr<-addLogic(pwr, at=2, type="or", name="No Power", name2="From G2")
pwr<-addProbability(pwr, at=10, prob=1e-4, tag="G2A", name="G2 Conn Open")
pwr<-addLogic(pwr, at=10, type="or", name="No Output", name2="From G2")
pwr<-addLogic(pwr, at=12, type="or", name="No Input", name2="To G2")
pwr<-addDuplicate( pwr, at=13, dup_id=8)
pwr<-addProbability(pwr, at=13, prob=1e-4, tag="G2B", name="Bleed Air To", name2="G2 Fails")
pwr<-addProbability(pwr, at=12, prob=1e-3, tag="G2", name="Generator G2", name2="Fails")
pwr<-addLogic(pwr, at=12, type="or", name="Switch To", name2="G2 Fails")
pwr<-addProbability(pwr, at=17, prob=1e-4, tag="M1", name="Monitor M1", name2="Fails")
pwr<-addProbability(pwr, at=17, prob=1e-4, tag="S1", name="Switching S1", name2="Fails")
pwr<-addLogic(pwr, at=2, type="or", name="No Power", name2="From G3")
pwr<-addLogic(pwr, at=20, type="or", name="No Output", name2="From G3")
pwr<-addProbability(pwr, at=20, prob=1e-4, tag="G3A", name="G3 Conn Open")
pwr<-addProbability(pwr, at=21, prob=1e-3, tag="G3", name="Generator G3", name2="Fails")
pwr<-addLogic(pwr, at=21, type="or", name="No Input", name2="To G3")
pwr<-addProbability(pwr, at=24, prob=1e-3, tag="E2", name="Engine E2", name2="Fails")
pwr<-addProbability(pwr, at=24, prob=1e-4, tag="G3B", name="Bleed Air To", name2="G2 Fails")
pwr<-addLogic(pwr, at=1, type="and", name="No Output", name2="G1, G2, G4")
pwr<-addDuplicate( pwr, at=27, dup_id=3)
pwr<-addDuplicate( pwr, at=27, dup_id=10)
pwr<-addLogic(pwr, at=27, type="or", name="No Power", name2="From G4")
pwr<-addProbability(pwr, at=45, prob=1e-4, tag="G4A", name="G4 Conn Open")
pwr<-addLogic(pwr, at=45, type="or", name="No Output", name2="From G4")
pwr<-addLogic(pwr, at=47, type="or", name="No Input", name2="To G4")
pwr<-addDuplicate( pwr, at=48, dup_id=25)
pwr<-addProbability(pwr, at=48, prob=1e-3, tag="G4", name="Generator G4", name2="Fails")
pwr<-addProbability(pwr, at=47, prob=1e-4, tag="G4B", name="Bleed Air To", name2="G4 Fails")
pwr<-addLogic(pwr, at=47, type="or", name="Switch To", name2="G4 Fails")
pwr<-addDuplicate( pwr, at=52, dup_id=18)
pwr<-addDuplicate( pwr, at=52, dup_id=19)
pwr<-addLogic(pwr, at=1, type="and", name="No Output", name2="G1, G3, G4")
pwr<-addDuplicate( pwr, at=55, dup_id=3)
pwr<-addDuplicate( pwr, at=55, dup_id=20)
pwr<-addDuplicate( pwr, at=55, dup_id=45)
pwr<-addLogic(pwr, at=1, type="and", name="No Output", name2="G2, G3, G4")
pwr<-addDuplicate( pwr, at=80, dup_id=10)
pwr<-addDuplicate( pwr, at=80, dup_id=20)
pwr<-addDuplicate( pwr, at=80, dup_id=45) 

pwr_cs<-cutsets(pwr) 

## get the tags for each element of the cut sets enter the following code
cs_tags2<-apply(pwr_cs[[2]], c(1,2),function(x) pwr$Tag[which(pwr$ID==x)])
cs_tags3<-apply(pwr_cs[[3]], c(1,2),function(x) pwr$Tag[which(pwr$ID==x)]) 

## Similarly, get the probability values for each of the elements of the cut sets
cs_probs2<-apply(pwr_cs[[2]], c(1,2),function(x) pwr$PBF[which(pwr$ID==x)])
cs_probs3<-apply(pwr_cs[[3]], c(1,2),function(x) pwr$PBF[which(pwr$ID==x)]) 

## Since each row of the cut set represents a single probability resulting from
## the product of its elements, it is possible to build a probability column
## to add to the cut set tags now as a dataframe.
cs_tags2<-cbind(cs_tags2, data.frame('prob'=apply(cs_probs2, 1, function(x) prod(x))))
cs_tags3<-cbind(cs_tags3, data.frame('prob'=apply(cs_probs3, 1, function(x) prod(x)))) 

## Finally the two objects can be combined to one and sorted (ordered). Lastly, the rows are re-numbered for ascetics.
nas<-rep(NA,length(cs_tags2[,1]))
cs_tags2<-cbind(cs_tags2[,1:2],nas, cs_tags2[,3])
names(cs_tags2)<-names(cs_tags3)
all_cs<-rbind(cs_tags2, cs_tags3)
all_cs<-all_cs[order(-all_cs[,4],all_cs[,1], all_cs[,2], all_cs[,3],na.last=FALSE), ]
row.names(all_cs)<-as.character(1:length(all_cs[,1])) 

print(all_cs)



