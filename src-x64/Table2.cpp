#include "FaultTree.h"		
#include "include/Table2.h"		
		
		
void Table2::add_bdd(std::string bdd_in, double probability_in)  {		
	bdd.push_back(bdd_in);	
	probability.push_back(probability_in);	
}		
		
double Table2::match(std::string bdd_test)  {		
	double ret = -1.0;	
		if(bdd.size() > 0) {
		auto it = std::find(bdd.begin(), bdd.end(), bdd_test);
		if (it != bdd.end()) {
	// string found! now get position to grab same position in result	
		auto pos=std::distance(bdd.begin(), it);
		ret=probability[pos];
		}
	}	
	return ret;	
}		
		
int Table2::nrow()  {		
	return bdd.size();	
}		
