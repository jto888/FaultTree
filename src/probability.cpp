#include "FaultTree.h"
#include "include/Ite.h"
#include "include/Ftree.h"
#include "include/Table1.h"
#include "include/Table2.h"



SEXP get_probability(SEXP chars_in, SEXP ints_in, SEXP nums_in, SEXP ft__node) {			
	std::unique_ptr<Ftree>  FT(new Ftree(chars_in, ints_in, nums_in)); 		
	std::unique_ptr<Table1> T1(new Table1());		
	std::unique_ptr<Table2> T2(new Table2());		
			
	int ft_node=Rcpp::as<int>(ft__node);		
			
	Ite res = FT2BDD(FT, T1, ft_node);		
	std::string bdd = res.tx();		
			
	double prob = BDD_probability(FT, T2, bdd);		
			
	return Rcpp::wrap(prob);		
}			


double BDD_probability(std::unique_ptr<Ftree>& FT, std::unique_ptr<Table2>& T2, std::string bdd)  { 				
	double bdd_prob = 0.0;			
				
	if(bdd == "0")  {			
		bdd_prob = 0.0;		
	}else{			
		if(bdd == "1")  {		
			bdd_prob = 1.0;	
		}else{		
			double test_result = T2->match(bdd);	
// Prof Brian Ripley <ripley@stats.ox.ac.uk>
// CRAN packages with -Wlogical-not-parentheses warnings  
// Please remove the warnings before 2020-05-12 to safely retain your package on CRAN. 
// note: add parentheses around left hand side expression to silence this warning
			if( (!test_result) < 0.0 )  {	
				bdd_prob = test_result;
			}else{	
				Ite Z(bdd);
				
				double node_prob = FT->get_prob(Z.node());
				
				double LHS = node_prob * BDD_probability(FT, T2, Z.X1());
				double RHS = (1-node_prob) * BDD_probability(FT, T2, Z.X0());
				bdd_prob = LHS + RHS;
				
				T2->add_bdd(bdd, bdd_prob);
			}	
		}		
	}			
				
	return bdd_prob;			
}				
				
