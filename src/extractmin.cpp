#include "FaultTree.h"


std::vector<arma::Mat<int>> extract_minimals(std::vector<arma::Mat<int>> cs_list)  {	
	unsigned int max_index = cs_list.size();
	arma::Mat<int> null_mat(1,1);
	null_mat.fill(0);

// the 4 nested loop algorithm for extracting minimals from a vector of integer matrices	
	for(unsigned int smat = 0; smat < max_index-1; smat++)  {		
		if(cs_list[smat](0,0)>0)  {	
			for(unsigned int source = 0; source<cs_list[smat].n_rows; source++) {
				for(unsigned int tmat = smat+1; tmat < max_index; tmat++)  {	
					if(cs_list[tmat](0,0) > 0)  {
						unsigned int target = 0;
						while( target < cs_list[tmat].n_rows )  {		
							arma::Row<int> C = intersect(cs_list[smat].row(source), cs_list[tmat].row(target));	
							if( C.n_cols == smat+1 )  {	
								if(cs_list[tmat].n_rows > 1)  {	
									cs_list[tmat].shed_row(target);
								}else{	
									cs_list[tmat] = null_mat;
									break;
								}	
							}else{	
								target++;
							}	
						}
					}
				}
			}
		}
	}
	
// final clean-up of excess order items
	int index = cs_list.size()-1;	
	while(cs_list[index](0,0) == 0 )  {	
		cs_list.erase(cs_list.begin()+index);
		index = index - 1;
	}
	
return cs_list;
}


void pack_cs(std::unique_ptr<Ftree>& FT, std::vector<arma::Mat<int>> cs_list,
		std::unique_ptr<Cuts>& cuts, int out_form)  {
 
	unsigned int max_index = cs_list.size();

// prepare final matrix as ID integers			
	arma::Mat<int> final_mat;		
	arma::Mat<int> padded_mat;		
			
	for(unsigned int Li=0; Li < max_index; Li++)  {		
	if(arma::as_scalar(cs_list[Li](0,0)) != 0) {		
		arma::Mat<int> pad_mat(cs_list[Li].n_rows, max_index-cs_list[Li].n_cols);	
		pad_mat.fill(0);	
		padded_mat = join_rows(cs_list[Li], pad_mat);	
		if(final_mat.is_empty() )  {	
			final_mat = padded_mat;
		}else{	
			final_mat = join_cols(final_mat, padded_mat);
		}	
	}		
	}		

// redefine the output matrix as a StringMatrix of tags
Rcpp::StringMatrix	out_mat(final_mat.n_rows, final_mat.n_cols);
Rcpp::IntegerVector orders(final_mat.n_rows);
for(unsigned int i=0; i < final_mat.n_rows; i++)  {
	orders[i] = (int) 0;
		for(unsigned int j=0; j < final_mat.n_cols; j++)  {
			if(final_mat(i,j)>0) {
				out_mat(i,j)=FT->get_tag(final_mat(i,j));
				orders[i] = (int) orders[i]+1;
			}else{
				out_mat(i,j) = "";
			}
		}
}

//return Rcpp::List::create(out_mat, orders);	
// set output members the cuts object		
	if(out_form==0)  {	
		cuts->packed_mat = Rcpp::wrap(final_mat);
	}else{	
		cuts->packed_mat = out_mat;
	}	
	cuts->orders = orders;

}
