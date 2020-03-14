#include "FaultTree.h"
#include "include/Ite.h"
#include <vector>
#include <string.h>

std::vector<int> Ite::positions(std::string string2find, std::string sample)  {
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
    return string_positions;	
}

Ite::Ite(std::string bdd)  {
	std::vector<int>commas = positions(",", bdd);
	sv.push_back(bdd.substr(1, commas[0]-1));
	std::string last3 = bdd.substr(bdd.size()-3, 3);
	int X1start;
	int X1end;
	int X0start;
	int X0end;
//	std::string X1;
//	std::string X0;
// X1 start and X0end are same for all	
	X1start = commas[0]+1;
	X0end = bdd.size()-1;
	
	if(last3 == ",0>")  {
// X0 is just "0", so we simply identify X1 in the middle
		X1end = bdd.size() - 3;
		sv.push_back(bdd.substr(X1start, X1end-X1start));
		sv.push_back("0");
	}
	else if(commas[1]-commas[0]==2) {
//  X0 is an ite, but is X1 is just "1"
// simpler code than searching for ite_opens, because X1 must be "1"		
		sv.push_back("1");
		X0start = commas[1]+1;		
		sv.push_back(bdd.substr(X0start, X0end-X0start));
	}	
	else {
//both X1 and X0 must be ite's  so we can find the ite closure before X0 starts
		std::vector<int>opens = positions("<", bdd);
		std::vector<int>closes = positions(">", bdd);
		std::vector<int>ite_closes = positions(">,<", bdd);
		
		unsigned int icls_pos=0;
		for(icls_pos=0; icls_pos < ite_closes.size(); icls_pos++)  {
// count opens before this ite_close
			auto opens_it = std::upper_bound (opens.begin(), opens.end(), ite_closes[icls_pos]); 
			auto opens_to_this_ite_close = std::distance(opens.begin(), opens_it);
// count closes up to and including this ite_close
			auto closes_it = std::upper_bound (closes.begin(), closes.end(), ite_closes[icls_pos]); 
			auto closes_to_this_ite_close = std::distance(closes.begin(), closes_it);
// compare the counts deleting one open to account for the first, string enclosing, open
			if(opens_to_this_ite_close-1 == closes_to_this_ite_close)  break;
		}
		X1end = ite_closes[icls_pos]+1;
		sv.push_back(bdd.substr(X1start, X1end-X1start));
		X0start = X1end+1;
		sv.push_back(bdd.substr(X0start, X0end-X0start));
	}
}

	

void Ite::mod(std::string node, std::string X1, std::string X0)  {	
	sv.resize(3);
	sv[0]=node;
	sv[1]=X1;
	sv[2]=X0;
}	
	
std::string Ite::tx()  {	
	std::string bdd= "<"+sv[0]+","+sv[1]+","+sv[2]+">";
return bdd;		
}	

std::string Ite::node() {
	return sv[0];
}

std::string Ite::X1() {
	return sv[1];
}

std::string Ite::X0() {
	return sv[2];
}

