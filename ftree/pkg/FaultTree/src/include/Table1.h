	
#ifndef _Table1_H	
#define _Table1_H	
	
	
class Table1  {	
	
	std::vector<std::string> bdd_operation;
	std::vector<std::string> op_result;

	
public:	
	void add_op(std::string opstrg, std::string res);
	std::string match(std::string opstrg);
	int nrow();
	
};	
	
#endif	
