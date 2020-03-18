#include "FaultTree.h"

// These other includes are all in FaultTreeBDD.h, not needed here
//#include "Ftree.h"
// the std library for memory management required for smart pointers (utilizing new?)
//#include <memory>


SEXP prime_implicants(SEXP chars_in, SEXP ints_in, SEXP nums_in, SEXP ft__node, SEXP out__form) {
// FT holds the ftree columns of interest
	std::unique_ptr<Ftree> FT(new Ftree(chars_in,  ints_in, nums_in));	
// T1 and Imp objects are created and owned by prime_implicants to facilitate debugging.
	std::unique_ptr<Table1> T1(new Table1());
	std::unique_ptr<ImpPaths> Imp(new ImpPaths());
	int ft_node=Rcpp::as<int>(ft__node);
	int out_form=Rcpp::as<int>(out__form);
	std::unique_ptr<Cuts>cuts(new Cuts());
	
	std::string bdd = bddgen(FT, T1, ft_node);
//	return Rcpp::List::create(Rcpp::Named("bdd") = Rcpp::wrap(bdd),
//	Rcpp::Named("nrow_T1") =Rcpp::wrap(T1->nrow()));

	solutions(FT, Imp, bdd, "");
//	return Rcpp::List::create(Rcpp::wrap(Imp->get_imp()),
//				Rcpp::wrap(Imp->get_seps()),
//				Rcpp::wrap(Imp->get_max_order())
//	);

// generate the path list	
	std::vector<arma::Mat<int>> PathList = bdd_path_list(FT, Imp);
//	return Rcpp::wrap(PathList);

	int out_control=0;
	std::vector<arma::Mat<int>> PrimeImplicants;
	if(Imp->get_max_order() > 1)  {	
		PrimeImplicants = extract_minimals(PathList);
		out_control=1;
	}else{
		PrimeImplicants = PathList;
	}
//	return Rcpp::wrap(PrimeImplicants);
	
	//return pack_cs(FT, PrimeImplicants);
	// pack_cs places output SEXP objects into cuts			
	pack_cs(FT, PrimeImplicants, cuts, out_form);		
			
	return Rcpp::List::create(	
		Rcpp::wrap(out_control),
		cuts->packed_mat,	
		cuts->orders	
		);	
}



void solutions(std::unique_ptr<Ftree>& FT, std::unique_ptr<ImpPaths>& Imp,			
		std::string F_bdd,  std::string sigma)  {	
	if(F_bdd=="1") {		
		Imp->add_sigma(sigma);	
	}else{		
		if(F_bdd!="0") {	
			Ite F_obj(F_bdd);
			std::string x = F_obj.node();
			std::string F1_bdd = F_obj.X1();
			std::string F2_bdd = F_obj.X0();
			solutions(FT, Imp, F1_bdd, sigma + x + ":");
			solutions(FT, Imp, F2_bdd, sigma);
		}	
	}		
}			


std::vector<arma::Mat<int>>  bdd_path_list(std::unique_ptr<Ftree>& FT, std::unique_ptr<ImpPaths>& Imp)  {				
				
// declare the cs_list and fill with null_mat				
	std::vector<arma::Mat<int>> cs_list;			
	arma::Mat<int> null_mat(1,1);			
	null_mat.fill(0);			
	for( int order = 0; order < Imp->get_max_order(); order++)  {			
		cs_list.push_back(null_mat);		
	}			
				
// declare  several variables, some with meaningless initialization to avoid compiler warning				
	int cs_order = 1;			
	int begin_pos = 0;			
	int node_len = 1;			
	std::string path_str = "";			
	std::string node_str = "";			
				
				
// now loop through the imp vector to fill the cs_list				
	for(unsigned int path = 0; path < Imp->get_imp().size() ; path++)  {			
		Rcpp::IntegerVector seps =  Imp->get_seps()[path];		
		cs_order = seps.size();		
		path_str = Imp->get_imp()[path];		
// parse the path string on the Imp vector				
		arma::Row<int> imp_vec(cs_order);		
		begin_pos = 0;		
				
				
		for( int node = 0; node < cs_order; node++)  {		
			node_len = seps[node] - begin_pos;	
			node_str = path_str.substr(begin_pos, node_len);	
			imp_vec[node] = FT->get_index(node_str);	
			begin_pos = begin_pos + node_len + 1;	
		}		
				
		if(cs_list[cs_order-1](0,0)==0)  {		
			cs_list[cs_order-1] = arma::sort(imp_vec);	
		}else{		
			cs_list[cs_order-1] = arma::join_cols(cs_list[cs_order-1], arma::sort(imp_vec));	
		}		
	}	

	return cs_list;
}

