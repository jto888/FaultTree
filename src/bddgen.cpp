// bddgen.cpp
// this file contains a series of functions that all work together to generate a bdd
// from a given ftree object node.
// functuons include:
//	FT2BDD, BDD_apply, BDD_txapply1, and BDD_txapply2
// classes include:
//  Ftree, Ite, Table1

#include "FaultTree.h"
#include "include/Ite.h"

// These other includes are all in ft2.h, not needed here
//#include "Ftree.h"
// the std library for memory management required for smart pointers (utilizing new?)
//#include <memory>


std::string bddgen(std::unique_ptr<Ftree>& FT, std::unique_ptr<Table1>& T1, int ft_node)  { 	
	Ite res=FT2BDD(FT, T1, ft_node);
	return res.tx();
}	


Ite FT2BDD(std::unique_ptr<Ftree>& FT, std::unique_ptr<Table1>& T1, int ft_node)  {	
//arma::colvec FT2BDD(std::unique_ptr<Ftree>& FT, int ft_node)  {	
    Ite ResultObject;
	std::string op;
	arma::colvec basic_child_a;
	arma::colvec gate_child_a;
//	bool ResultFound=false;
	bool ChildrenFound=false;
	bool GateResultFound=false;
//	while(!ResultFound && !ChildrenFound)  {
	bool LoopContinue=true;
	while(LoopContinue)  {
		if(FT->get_type(ft_node) < 10)  {
	// Process the basic event into the ResultObj using the mod method
			ResultObject.mod(FT->get_tag(ft_node), "1", "0");
			//ResultFound=true;
			LoopContinue=false;
		}else{
			op=(FT->get_type(ft_node) == 10)? "or" : "and";
	// get the children of this gate at ft_node		
			Rcpp::List L=FT->get_children(ft_node);
			Rcpp::IntegerVector basic_child_v=L("basic_child_v");
			Rcpp::IntegerVector gate_child_v=L("gate_child_v");
			int numChildren = basic_child_v.size() + gate_child_v.size();
			if(numChildren == 1)  {
				ft_node=(basic_child_v.size()==1)? basic_child_v[0] : gate_child_v[0];
			}else{
				ChildrenFound=true;
				LoopContinue=false;
				if(basic_child_v.size() > 0 )  {
					basic_child_a=Rcpp::as<arma::colvec>(basic_child_v);
				}
				if(gate_child_v.size() > 0 )  {	
					gate_child_a=Rcpp::as<arma::colvec>(gate_child_v);
				}
			}
			
		}
	}

	
	if(ChildrenFound) {
// defining a vector that I can push_back gate objects onto
		std::vector<Ite> GateObjects;
		
		if(gate_child_a.size()>0)  {													
// define and build out an NDX vector, knowing its size in advance							
			arma::colvec gNDX(gate_child_a.size());					
			for(unsigned int index=0; index<gate_child_a.size(); index++)  {			
				if(FT->get_moe(gate_child_a[index]) > 0)  {			
					gNDX[index]=FT->get_moe(gate_child_a[index]);			
				}else{				
					gNDX[index]= gate_child_a[index];			
				}				
			}					
								
// build out the GateObjects vector 							
//destroying gate_child_a and gNDX vectors progressively							
								
			while(gNDX.size()>0)  {					
				int max_gNDX_pos = arma::as_scalar(arma::find(gNDX==gNDX.max()));				
				int thisGft_node=gate_child_a[max_gNDX_pos];				
				Ite TempObj=FT2BDD(FT, T1, thisGft_node);				
				GateObjects.push_back(TempObj);				
				gate_child_a.shed_row(max_gNDX_pos);				
				gNDX.shed_row(max_gNDX_pos);				
			}					
								
								
			ResultObject=GateObjects[0];					
								
			if(GateObjects.size()>1)  {					
								
				for(unsigned int pos=1; pos<GateObjects.size(); pos++)  {				
								
					Ite Gobj=GateObjects[pos];			
								
					ResultObject=BDD_apply(FT, T1, Gobj, ResultObject, op);			
				}				
			}					
								
			GateResultFound=true;					
		}			

// defining a vector that I can push_back basic objects onto
		std::vector<Ite> BasicObjects;
					
		if(basic_child_a.size()>0)  {	
		//process remaining gate nodes
			
	// define and build out an NDX vector, knowing its size in advance	
			arma::colvec NDX(basic_child_a.size());		
			for(unsigned int index=0; index<basic_child_a.size(); index++)  {		
				if(FT->get_moe(basic_child_a[index]) > 0)  {	
					NDX[index]=FT->get_moe(basic_child_a[index]);
				}else{	
					NDX[index]= basic_child_a[index];
				}	
			}
			
	// build out the BasicObjects vector 
	//destroying basic_child_a and NDX vectors progressively
			while(NDX.size()>0)  {	
				int max_NDX_pos = arma::as_scalar(arma::find(NDX==NDX.max()));
				int thisBft_node=basic_child_a[max_NDX_pos];
				Ite TempObj=FT2BDD(FT, T1, thisBft_node);
//				ResultObject=TempObj;

				BasicObjects.push_back(TempObj);
				basic_child_a.shed_row(max_NDX_pos);
				NDX.shed_row(max_NDX_pos);
			}	

			Ite Bobj=BasicObjects[0];

			
			if(GateResultFound)  {
// order now changed so basic element is before gates				
				ResultObject=BDD_apply(FT, T1, Bobj, ResultObject, op);	
			}else{		
				ResultObject=Bobj;	
			}		
					
			if(BasicObjects.size()>1)  {		
				for(unsigned int pos=1; pos<BasicObjects.size(); pos++)  {	
//		unsigned int pos=1;
					Bobj=BasicObjects[pos];
// order now changed so lesser index is before greater			
					ResultObject=BDD_apply(FT, T1, Bobj, ResultObject, op);
				}	
			}

// Now close the processing of remaining basic children			
		}
// Close the children found block		
	}
	
return ResultObject;

}


Ite BDD_apply(std::unique_ptr<Ftree>& FT, std::unique_ptr<Table1>& T1, Ite F, Ite G, std::string op)  {			
	Ite ResultObject;
	std::string this_operation = F.tx()+":"+G.tx()+":"+op;
if(F.tx()== G.tx())  {
		ResultObject=F;
}else{
// test for inclusion in table here, then nest one more else block					
// the return off of the table needs to be parsed back to an Ite dataframe object	
	std::string test_result = T1->match(this_operation);	
	// if(test_result.size() > 0)  {
	if(!test_result.empty())  {
			Ite temp_obj(test_result);
		ResultObject = temp_obj;
	// The closure for this else block must by-pass the T1 entry code	
	}else{	

		int Findex = FT->get_index(F.node());		
		int Gindex = FT->get_index(G.node());
	//  Object swap is required here to assure strict ordering
	//  Basic objects should always preceed gates in tree formation
		if(Gindex<Findex) {		
			Ite storeF = F;	
			F = G;	
			G = storeF;	
		}		

				
	// test for two terminal nodes			
		if(F.X1() =="1" && F.X0() =="0" && G.X1() == "1" && G.X0() == "0") {		
			if(op=="and") {	
				ResultObject.mod(F.node(), G.tx(), "0" );
			}else{
				ResultObject.mod(F.node(), "1", G.tx());
			}	
		}		
				
		else{				
					
						
						
				if(Findex == Gindex) {		
					std::string X1 = BDD_txapply2(FT, T1,  F.X1(), G.X1(), op);	
					std::string X0 = BDD_txapply2(FT, T1,  F.X0(), G.X0(), op);	
					ResultObject.mod(F.node(), X1, X0);	
						
						
				}else {	
				
					std::string X1 = BDD_txapply1(FT, T1,  F.X1(), G, op);	
					std::string X0 = BDD_txapply1(FT, T1,  F.X0(), G, op);	
					ResultObject.mod(F.node(), X1, X0);	
				}		
			}						
	//store F.tx(), G.tx(), op and ResultObject.tx() in a table so not to repeat recursive calls
		T1->add_op(this_operation, ResultObject.tx());
	}					
}				
	return ResultObject;				
}	


std::string BDD_txapply1(std::unique_ptr<Ftree>& FT, std::unique_ptr<Table1>& T1, std::string txt, Ite H, std::string op)  {					
	std::string ResultText;
if(txt==H.tx())  {
		ResultText=txt;
}else{
	if(txt.size() == 1)  {
		if(op=="and") {	
			if(txt=="0") ResultText="0"; else ResultText =  H.tx();	
		}else{			
			if(txt=="1") ResultText="1"; else ResultText =  H.tx();		
		}			
	}else{				
// parse txt as an Ite data frame object					
		Ite G(txt);			
		int Gindex = FT->get_index(G.node());			
		int Hindex = FT->get_index(H.node());			
// assure that INDX(G$node) < INDX(H$node)					
		if(Gindex < Hindex)  {			
			Ite TempObj = BDD_apply(FT, T1, G, H, op);		
			ResultText = TempObj.tx();		
		}else{			
			Ite TempObj = BDD_apply(FT, T1, H, G, op);		
			ResultText = TempObj.tx();		
		}			
	}
}	
	return ResultText;				
}


std::string BDD_txapply2(std::unique_ptr<Ftree>& FT, std::unique_ptr<Table1>& T1, std::string txt1, std::string txt2, std::string op)  {						
	std::string ResultText;
if(txt1==txt2)  {
		ResultText=txt1;
}else{
	Ite F;					
	Ite G;					
// parse any BDD text to Ite data frame						
	if(txt1.size()>1)  { 
		Ite temp1(txt1);
		F = temp1;
	}
	if(txt2.size()>1)  {
		Ite temp2(txt2);
		G = temp2;
	}					
	if(txt1.size() == 1 && txt2.size()>1) {	
		if(op=="and") {
			if(txt1=="0") ResultText ="0"; else  ResultText = G.tx();				
		}else{			
			if(txt1=="1") ResultText ="1"; else  ResultText = G.tx();					
		}				
	}					
						
	if(txt2.size()==1 && txt1.size()>1) {
		if(op=="and") {
			if(txt2=="0") ResultText ="0"; else  ResultText = F.tx();			
		}else{				
			if(txt2=="1") ResultText ="1"; else  ResultText = F.tx();						
		}				
	}					
						
	if(txt1.size()==1 && txt2.size()==1) {
		if(op=="and") {
			if(txt1=="1" && txt2=="1") ResultText ="1"; else  ResultText = "0";			
		}else{				
			if(txt1=="1" || txt2=="1") ResultText ="1"; else  ResultText = "0";						
		}				
	}					
						
	if(txt1.size() > 1 && txt2.size()>1) {					
// It is unnecessary to verify the index order here, it will be done in BDD_apply
						
		ResultText = BDD_apply(FT, T1, F, G, op).tx();				
	}
}	
	return ResultText;					
}	


					
	