	
#ifndef _ImpPaths_H	
#define _ImpPaths_H	
	
	
class ImpPaths  {	
	std::vector<std::string> imp;
	std::vector<Rcpp::IntegerVector> seps;
	int max_order;
	Rcpp::IntegerVector positions(std::string string2find, std::string sample);

public:	
	void add_sigma(std::string sigma);
	std::vector<std::string> get_imp();
	std::vector<Rcpp::IntegerVector> get_seps();
	int get_max_order();

};	
	
#endif	
