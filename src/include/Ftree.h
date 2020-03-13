#ifndef _Ftree_H
#define _Ftree_H


//    using namespace Rcpp ;		
class Ftree{		
		
	Rcpp::StringVector tag_v;	
		
	arma::colvec id_a;	
	Rcpp::IntegerVector type_v;	
	arma::colvec cparent_a;	
	Rcpp::IntegerVector moe_v;	

		
	Rcpp::NumericVector pbf_v;	
	Rcpp::IntegerVector etype_v;	
	Rcpp::NumericVector p1_v;	
	Rcpp::NumericVector p2_v;
		
	double  mission_time;
	unsigned int max_order;
		
public:	
	Ftree(SEXP chars_in, SEXP ints_in, SEXP nums_in);
	int get_type(int ft_node);
	std::string get_tag(int ft_node);
	int get_moe(int ft_node);
	Rcpp::List get_children(int ft_node);
	int get_index(std::string tag_in);
	unsigned int get_AND_count();
	unsigned int get_max_order();
	void set_max_order(unsigned int mo);
	double get_prob(std::string tag_in);
	double get_prob(int id_in);
};	
	
#endif