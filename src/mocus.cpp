#include "FaultTree.h"
#include "include/cuts.h"

// These other includes are all in ft2.h, not needed here
//#include "Ftree.h"
// the std library for memory management required for smart pointers (utilizing new?)
//#include <memory>


SEXP mocus(SEXP chars_in, SEXP ints_in, SEXP nums_in, SEXP ft__node, SEXP out__form) {	
	std::unique_ptr<Ftree> FT(new Ftree(chars_in,  ints_in, nums_in));	
	int ft_node=Rcpp::as<int>(ft__node);
	int out_form=Rcpp::as<int>(out__form);
	std::unique_ptr<Cuts>cuts(new Cuts());
	
		
// out of abundance of caution set the approximate max_order member of FT		
	FT->set_max_order(FT->get_AND_count() +1);	
		
// get_unique_paths will establish the correct max_order member of FT for later cs_list creation		
	std::vector<arma::Row<int>> UniquePaths = get_unique_paths(FT, ft_node);			
//	return Rcpp::List::create(Rcpp::wrap(FT->get_max_order()),	
//	 Rcpp::wrap(UniquePaths) );

// generate the path list	
	std::vector<arma::Mat<int>> PathList = generate_path_list(UniquePaths, FT->get_max_order());
//	return Rcpp::wrap(PathList);

	int out_control=0;
	std::vector<arma::Mat<int>> MinCutSets;
	if(FT->get_max_order() > 1)  {	
		MinCutSets = extract_minimals(PathList);
		out_control=1;
	}else{
		MinCutSets = PathList;
	}
//	return Rcpp::wrap(MinCutSets);
	
//	return pack_cs(FT, MinCutSets, cuts, out_form);
	
	//return mcub(FT, MinCutSets);
// pack_cs places output SEXP objects into cuts			
	pack_cs(FT, MinCutSets, cuts, out_form);		
			
	return Rcpp::List::create(
		Rcpp::wrap(out_control),
		cuts->packed_mat,	
		cuts->orders,	
		mcub(FT, MinCutSets));	

}	

std::vector<arma::Row<int>>  get_unique_paths(std::unique_ptr<Ftree>& FT, int ft_node) {						
						
// initialize a std::vector<arma::Row<int>>to hold the output						
	std::vector<arma::Row<int>> upath_list;
	std::vector<std::string> upath_str_list;	
// declare an arma row_vector to hold the path_test[eval_item] for modification and application to the unique_paths_list						
		arma::Row<int> upath_item;
		
// get the child ID's of ft_node in an arma row vector						
		Rcpp::List child_list = FT->get_children(ft_node);				
		arma::Row<int> b_children = Rcpp::as<arma::Row<int>>(child_list["basic_child_v"]);				
		arma::Row<int> g_children = Rcpp::as<arma::Row<int>>(child_list["gate_child_v"]);				
		arma::Row<int> child_ids = arma::join_rows(b_children, g_children);
		
// set FT->max_order to a low value prior to adjustment						
		FT->set_max_order(1);				
												
		unsigned int eval_item = 0;				
		unsigned int eval_pos = 0;				
// declare a temporary vector that will be re-used within inner loop						
		arma::Row<int> path_vec;				
						
// initialize path_test with the child ID's of ft_node according to its type						
		std::vector<arma::Row<int>> path_test;				
		if(FT->get_type(ft_node) == 10)  {				
			for(unsigned int child_id = 0; child_id < child_ids.n_cols; child_id++)  {			
				path_test.push_back(child_ids.col(child_id));		
			}			
		}else{				
			path_test.push_back(child_ids);			
		}				
					
// use a nested loop to determine all element paths to top event						
		while(eval_item < path_test.size() )  {				
			while(eval_pos < path_test[eval_item].n_cols )  {			
// no action is taken on basic elements in this loop						
				if(FT->get_type(path_test[eval_item](eval_pos)) < 10 )  {		
					eval_pos++;	
				}else{		
// get the children for this gate re-using objects that have already been declared						
					child_list = FT->get_children(path_test[eval_item](eval_pos));	
					b_children = Rcpp::as<arma::Row<int>>(child_list["basic_child_v"]);	
					g_children = Rcpp::as<arma::Row<int>>(child_list["gate_child_v"]);	
					child_ids = arma::join_rows(b_children, g_children);	
// remove this gate id from the current eval_item vector						
					path_vec = path_test[eval_item];	
					path_vec.shed_col(eval_pos);	
// gate nodes are expanded by their children according to type						
					if(FT->get_type(path_test[eval_item](eval_pos)) == 10)  {	
						for(unsigned int child_id = 0; child_id < child_ids.n_cols; child_id++)  {
							path_test.push_back(join_rows(path_vec, child_ids.col(child_id) ));
						}
				// delete the current eval_item (since it has been replaced on cs list with new items)		
						path_test.erase(path_test.begin()+eval_item);
				// reset eval_pos back to 0, because same eval_item will now point to a different vector		
						eval_pos = 0;
					}else{	
				// "and" gate elements just replace the path_test[eval_item]		
						path_vec = join_rows(path_vec, child_ids);
						path_test[eval_item] = path_vec;
				// eval_pos remains the same for next pass of inner loop		
					}	
				}		
			}			
						
			upath_item = path_test[eval_item];			
			
// convert moe events to source ID (called index in bdd developement)						
			for(unsigned int item=0; item < upath_item.n_cols; item++)  {			
				upath_item(item)= FT->get_index(FT->get_tag(upath_item(item)));		
			}			
// eliminate duplicates and sort						
			upath_item = unique(upath_item);			
// since the previous line may have changed the size of upath_item we now have a  size to compare								
			if(upath_item.n_cols > FT->get_max_order())FT->set_max_order(upath_item.n_cols);			
						
// bug here because did not confirm upath_item was unique to the upath_list						
			//upath_list.push_back(upath_item);			
			std::string upath_str = "";				
			for(unsigned int cs_el=0; cs_el<upath_item.n_cols; cs_el++)  {				
				upath_str = upath_str + std::to_string(upath_item[cs_el])+ " ";			
				}			
			if(upath_str_list.size() > 0)  {				
				auto it = std::find(upath_str_list.begin(), upath_str_list.end(), upath_str);			
				if(it == upath_str_list.end())  {			
					upath_list.push_back(upath_item);		
					upath_str_list.push_back(upath_str);		
				}			
			// nothing is done if upath_item is not unique				
			}else{				
				upath_list.push_back(upath_item);			
				upath_str_list.push_back(upath_str);			
			}							
						
			// advance the eval_item for next pass of outer loop and re-set eval_pos			
			eval_item++;			
			eval_pos = 0;			
		}				
						
	return upath_list;					
}						


std::vector<arma::Mat<int>>  generate_path_list(std::vector<arma::Row<int>> unique_paths, unsigned int max_order) {			
			
// declare the cs_list and fill with null_mat			
	std::vector<arma::Mat<int>> cs_list;		
	arma::Mat<int> null_mat(1,1);		
	null_mat.fill(0);		
	for(unsigned int order = 0; order < max_order; order++)  {		
		cs_list.push_back(null_mat);	
	}		
			
// initialize with meaningless value to avoid compiler warning			
	int cs_order = 1;		
// now loop through the unique_paths to fill the cs_list			
	for(unsigned int path = 0; path < unique_paths.size() ; path++)  {		
		cs_order = (int) unique_paths[path]. n_cols;	
		if(cs_list[cs_order-1](0,0)==0)  {		
			cs_list[cs_order-1] = unique_paths[path];
		}else{	
			
			cs_list[cs_order-1] = join_cols(cs_list[cs_order-1], unique_paths[path]);
		}	
	}		
			
	return cs_list;		
}			
	
SEXP mcub(std::unique_ptr<Ftree>& FT, std::vector<arma::Mat<int>> cs_list)  {				
				
	unsigned int max_index = cs_list.size();			
	double oneminusprob = 1.0;						
	for(unsigned int Li=0; Li < max_index; Li++)  {			
	if(arma::as_scalar(cs_list[Li](0,0)) != 0) {			
		for(unsigned int cs_row=0; cs_row<cs_list[Li].n_rows; cs_row++)  {		
			double row_prob = 1.0;	
			for(unsigned int cs_el=0; cs_el<cs_list[Li].n_cols; cs_el++)  {	
				row_prob = row_prob * FT->get_prob(cs_list[Li](cs_row,cs_el));
			}	
			oneminusprob = oneminusprob * (1.0-row_prob);	
		}		
	}			
	}			
				
	return Rcpp::wrap(1-oneminusprob);
}				
