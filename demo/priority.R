#require(magrittr)
if(exists("mission_time")) rm(mission_time)
surge3<-ftree.make(type="priority", name="Surge Tank", name2="Overpressure Failure")
#surge3<-surge3 %>%
#addLogic(., at=1, type="or",
surge3<-addLogic(surge3, at=1, type="or",
name="Pressure Relief Fails", name2="to Open at Design Pt") #%>%
surge3<-addLatent (surge3, at=2, mttf=300, inspect=3,
name="Pressure Relief", name2="set too high") #%>%
surge3<-addLatent(surge3, at=2, mttf=300, inspect=3,
name="Pressure Relief Unable", name2="to Open at Design Pt") #%>%
surge3<-addLogic(surge3, at=1, type="priority", reversible_cond=TRUE,
name="Vent Control Failed", name2="On Overpressure") #%>%
surge3<-addLogic(surge3, at=5, type="or", name="Vent Control", name2="Fails Closed") #%>%
surge3<-addLogic(surge3, at=5, type="or", name="Supply Control", name2="Fails Open") #%>%
surge3<-addLatent(surge3, at=6, mttf=25, mttr=8/8760, inspect=1, name="PV2", name2="Fails Closed") #%>%
surge3<-addLatent(surge3, at=6, mttf=100, mttr=8/8760, inspect=1,
name="PC2 Forces", name2="PV2 Closed") #%>%
surge3<-addLatent(surge3, at=6, mttf=100, mttr=8/8760, inspect=1,
name="PT2", name2="Fails Low") #%>%
surge3<-addActive(surge3, at=7, mttf=25, mttr=8/8760, name="PV1", name2="Fails Open") #%>%
surge3<-addActive (surge3, at=7, mttf=100, mttr=8/8760, name="PC1 Forces", name2="PV1 Open") #%>%
surge3<-addActive (surge3, at=7, mttf=100, mttr=8/8760, name="PT1", name2="Fails Low") #%>%
ftree.calc(surge3)
 
#ftree2html(surge3, write_file=TRUE)
#browseURL("surge3.html") 

ftree.display(surge3)