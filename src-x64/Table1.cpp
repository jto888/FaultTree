#include "FaultTree.h"
#include "include/Table1.h"


void Table1::add_op(std::string opstrg, std::string res)  {	
	bdd_operation.push_back(opstrg);
	op_result.push_back(res);
}	
	
std::string Table1::match(std::string opstrg)  {	
	std::string ret;
		if(bdd_operation.size() > 0) {
		auto it = std::find(bdd_operation.begin(), bdd_operation.end(), opstrg);
		if (it != bdd_operation.end()) {
			// string found! now get position to grab same position in result
		auto pos=std::distance(bdd_operation.begin(), it);
		ret=op_result[pos];
		}
	}
	return ret;
}	

int Table1::nrow()  {
	return bdd_operation.size();
}