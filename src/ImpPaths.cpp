#include "FaultTree.h"
#include "include/ImpPaths.h"


Rcpp::IntegerVector ImpPaths::positions(std::string string2find, std::string sample)  {				
	std::string test = string2find;			
	std::vector<int> string_positions;			
	unsigned int endScan= sample.size()-string2find.size()+1;			
    for(unsigned int i =0; i < endScan; i++)  {				
		for(unsigned int j=0; j < string2find.size(); j++)  {		
			test[j]=sample[i+j];	
		}		
        if(test == string2find)				
            string_positions.push_back(i);				
	}
	Rcpp::IntegerVector string_positions_IV(Rcpp::wrap(string_positions));

    return string_positions_IV;				
}				


void ImpPaths::add_sigma(std::string sigma)  {	
		Rcpp::IntegerVector sep = positions(":", sigma);
		if(imp.size() > 0) {
			auto it = std::find(imp.begin(), imp.end(), sigma);
			if (it == imp.end()) {
				imp.push_back(sigma);
				seps.push_back(sep);
			// test for update of max_order here
				if(sep.size() > max_order) max_order = sep.size();
			}
		// nothing is done if sigma is not unique			
		}else{
			imp.push_back(sigma);
			seps.push_back(sep);
		// get an initial value for max_order here
			max_order = sep.size();
		}
}

std::vector<std::string> ImpPaths::get_imp()  {		
	return imp;	
}		
		
std::vector<Rcpp::IntegerVector> ImpPaths::get_seps()  {		
	return seps;	
}		
		
int ImpPaths::get_max_order()  {		
	return max_order;	
}		

