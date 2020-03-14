#include "FaultTree.h"

// These other includes are all in FaultTreeBDD.h, not needed here
//#include "include/Ftree.h"
// the std library for memory management required for smart pointers (utilizing new?)
//#include <memory>


SEXP get_bdd(SEXP chars_in, SEXP ints_in, SEXP nums_in, SEXP ft__node) {
// FT holds the ftree columns of interest
	std::unique_ptr<Ftree> FT(new Ftree(chars_in,  ints_in, nums_in));	
// T1 and Imp objects are created and owned by prime_implicants to facilitate debugging.
	std::unique_ptr<Table1> T1(new Table1());

	int ft_node=Rcpp::as<int>(ft__node);

	return Rcpp::wrap(bddgen(FT, T1, ft_node));
}