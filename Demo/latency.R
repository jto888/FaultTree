rv_test<-c(3,3,3,2,1,2,1)
pi_test<-c(3,1,1/12,1/12,1/12,1/52,1/52)
walkby<-c(3,1/12,1/52,1/52,1/52,1/52,1/52)
 
cases<-cbind(rv_test,pi_test,walkby)

mttf<-NULL
CFRat14<-NULL
for(case in 1:dim(cases)[1]) {
 
rv_test<-cases[case,1]
pi_test<-cases[case,2]
walkby<-cases[case,3]
 
hf<-ftree.make(type="or", name="HF Vaporizer", name2="Rupture")
hf<-addLogic(hf, at=1, type="inhibit", name="Overpressure", name2="Unrelieved")
hf<-addDemand(hf, at=1, mttf=1e6, name= "Vaporizer Rupture", name2="Due to Stress/Fatigue")
hf<-addLogic(hf, at=2, type="or", name="Pressure Relief System", name2="in Failed State")
hf<-addLogic(hf, at=2, type="or", name="Overpressure", name2="Occurs")
hf<-addLogic(hf, at=4, type="or", name="Pressure Relief", name2="Isolated")
hf<-addLatent(hf, at=6, mttf=10, pzero=0, inspect=walkby,
name="Valve 20", name2="Left Closed")
hf<-addLatent(hf, at=6, mttf=10, pzero=0, inspect=walkby, display_under=7,
name="Valve 21", name2="Left Closed")
hf<-addLogic(hf, at=4, type="or", name="Rupture Disk Fails", name2="to Open at Design Pt.")
hf<-addLogic(hf, at=9, type="or", name="Installation/Mfr", name2="Errors")
hf<-addProbability(hf, at=10, prob=.001, name="Rupture Disk", name2="Installed Upside Down")
hf<-addProbability(hf, at=10, prob=.001, display_under=11,
name="Wrong Rupture Disk", name2="Installed")
hf<-addProbability(hf, at=10, prob=.001, display_under=12,
name="Rupture Disk", name2="Manuf. Error")
hf<-addLogic(hf, at=9, type="or", name="Pressure Between Disk", name2="and Relief Valve")
hf<-addLogic(hf, at=14, type="inhibit", name="Pressure NOT" , name2="Detectable by PI")
hf<-addLatent(hf, at=15, mttf=10, pzero=0, inspect=pi_test,
name="Pressure Gage", name2="Failed Low Position")
hf<-addLatent(hf, at=15, mttf=10, pzero=0, inspect=pi_test,
name="Rupture Disk Leak", name2="Undetected")
hf<-addLogic(hf, at=14, type="inhibit", name="Pressure" , name2="Detectable by PI")
hf<-addProbability(hf, at=18, prob=(1-hf$PBF[16]),
name="Pressure Gage", name2="Detects Pressure")
hf<-addLatent(hf, at=18, mttf=10, pzero=0, inspect=walkby,
name="Rupture Disk Leak", name2="Detectable")
hf<-addLogic(hf, at=4, type="or",
name="Pressure Relief Fails", name2=" to Open at Design Pt")
hf<-addLatent(hf, at=21, mttf=300, pzero=0, inspect=rv_test,
name="Pressure Relief", name2="set too high")
hf<-addLatent(hf, at=21, mttf=300, pzero=0, inspect=rv_test,
name="Pressure Relief Unable", name2="to Open at Design Pt")
hf<-addDemand(hf, at=5, mttf=10, name= "High Pressure", name2="Feed to Vaporizer")
hf<-addDemand(hf, at=5, mttf=10, name= "Vaporizer Heating", name2="Runaway")
 
hf<-ftree.calc(hf)
mttf<-c(mttf,1/ hf$CFR[1])
CFRat14<-c(CFRat14, hf$CFR[14])
}
 
cases<-cbind(cases, mttf, CFRat14) 

print(cases)