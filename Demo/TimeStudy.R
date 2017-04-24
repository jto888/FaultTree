TimeStudy<-data.frame(Exposure_Time=NULL, Prob_of_Failure=NULL)
for(power in seq(0,7, by=.1)) {
mission_time<-10^power
arm2<-ftree.make(type="or", name="Warhead Armed", name2="Inadvertently")
arm2<-addLogic(arm2, at= 1, type="and", name="Arm Circuit", name2="Relays Closed")
arm2<-addExposed(arm2, at= 2, mttf=1/1.1e-6, tag="E1",
name="Relay 1", name2="Fails Closed")
arm2<-addExposed(arm2, at= 2, mttf=1/1.1e-6, tag="E2",
name="Relay 2", name2="Fails Closed")
arm2<-addLogic(arm2, at= 1, type="inhibit", name="Arm Power", name2="Is Present")
arm2<-addProbability(arm2, at= 5, prob=1, tag="W1", name="Battery Power", name2="Is Available")
arm2<-addLogic(arm2, at= 5, type="or", name="Arm Circuit Closed", name2="By Computer")
arm2<-addExposed(arm2, at= 7, mttf=1/1.1e-6, tag="E3",
name="CPU", name2="Failure")
arm2<-addExposed(arm2, at= 7, mttf=1/1.1e-6, tag="E4", name="Software", name2="Failure")
arm2<-ftree.calc(arm2)
study_row<-data.frame(Exposure_Time=mission_time, Prob_of_Failure=arm2$PBF[1])
TimeStudy<-rbind(TimeStudy, study_row)
}

plot(TimeStudy, log="x", type="l") 
 
