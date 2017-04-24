cool<-ftree.make(type="or", name="Coolant Flow", name2="Insufficient")
cool<-addLogic(cool, at= 1, type="and", name="Pumps Fail", name2="Independently")
cool<-addLogic(cool, at=1, type="or", name="Common Cause", name2="Pumping Failure")
cool<-addLogic(cool, at=2, type="or", name="Pump 1", name2="Failure")
cool<-addActive(cool, at=4, mttf=30, mttr=24/8760, tag="P1", name="Pump Impeller", name2="Fails")
cool<-addActive(cool, at=4, mttf=10, mttr=24/8760, tag="P1a", display_under=5,
name="Pump Bearings", name2="Fail")
cool<-addActive(cool, at=4, mttf=6, mttr=12/8760, tag="P1b", display_under=6,
name="Pump Seal", name2="Fails")
cool<-addActive(cool, at=4, mttf=10, mttr=24/8760, tag="M1", display_under=7,
name="Pump Motor", name2="Fails")
cool<-addActive(cool, at=4, mttf=25, mttr=8/8760, tag="B1", display_under=8,
name="Pump Motor Control", name2="Breaker Opens")
cool<-addLogic(cool, at=2, type="or", name="Pump 2", name2="Failure")
cool<-addActive(cool, at=10, mttf=30, mttr=24/8760, tag="P2",
name="Pump Impeller", name2="Fails")
cool<-addActive(cool, at=10, mttf=10, mttr=24/8760, tag="P2a", display_under=11,
name="Pump Bearings", name2="Fail")
cool<-addActive(cool, at=10, mttf=6, mttr=12/8760, tag="P2b", display_under=12,
name="Pump Seal", name2="Fails")
cool<-addActive(cool, at=10, mttf=10, mttr=24/8760, tag="M2", display_under=13,
name="Pump Motor", name2="Fails")
cool<-addActive(cool, at=10, mttf=25, mttr=8/8760, tag="B2", display_under=14,
name="Pump Motor Control", name2="Breaker Opens")
cool<-addLogic(cool, at=3, type="or", name="Flow Control", name2="Restricts Flow")
cool<-addActive(cool, at=16, mttf=25, mttr=8/8760, tag="FV", name="Flow Valve Closed",
name2="By Positioner")
cool<-addActive(cool, at=16, mttf=100, mttr=8/8760, tag="FC", display_under=17,
name="Flow Valve Closed", name2="By Flow Controller")
cool<-addActive(cool, at=16, mttf=100, mttr=8/8760, tag="FT", display_under=18,
name="Flow Valve Closed", name2="By Flow Transmitter")
cool<-addLogic(cool, at=3, type="or", name="Flow Recycles Through", name2="Failed Check Valve")
cool<-addLogic(cool, at=20, type="inhibit", name="Pump 1 Stops", name2="with CV1 Failed")
cool<-addProbability(cool, at=21, prob= .01, tag="CV1",
name="Check Valve", name2="Fails on Demand")
cool<-addDuplicate(cool, at=21, dup_id=4)
cool<-addLogic(cool, at=20, type="inhibit", name="Pump 2 Stops", name2="with CV2 Failed")
cool<-addProbability(cool, at=29, prob= .01, tag="CV2",
name="Check Valve", name2="Fails on Demand")
cool<-addDuplicate(cool, at=29, dup_id=10)
cool<-addLogic(cool, at=3, type="or", name="Power Interrupted", name2="To all Pumps")
cool<-addActive(cool, at=37, mttf=25, mttr=12/8760, tag="B3", name="MCC Breaker", name2="Opens")
cool<-addActive(cool, at=37, mttf=25, mttr=12/8760, tag="B4", display_under=38,
name="Transformer Breaker", name2="Opens")
cool<-addActive(cool, at=37, mttf=300, mttr=72/8760, tag="TX", display_under=39, name="Transformer", name2="Fails")
cool<-ftree.calc(cool)

print(ftree2table(cool)[,-9])
