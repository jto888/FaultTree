#ifndef _Table2_H		
#define _Table2_H		
		
		
class Table2  {		
		
	std::vector<std::string> bdd;	
	std::vector<double> probability;	
		
		
public:		
	void add_bdd(std::string bdd_in, double probability_in);	
	double match(std::string bdd_test);	
	int nrow();	
		
};		
		
#endif		
