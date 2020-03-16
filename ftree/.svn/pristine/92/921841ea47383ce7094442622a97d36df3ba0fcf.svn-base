// Ftree.cpp implementation of Ftree class
#include "FaultTree.h"
#include "include/Ftree.h"

Ftree::Ftree(SEXP chars_in, SEXP ints_in, SEXP nums_in)  {				
	tag_v=chars_in;			
	int df_rows = tag_v.size();			
	Rcpp::IntegerVector ints_v=ints_in;			
	Rcpp::NumericVector nums_v=nums_in;			
				
	Rcpp::IntegerVector id_v(ints_v.begin(), std::next(ints_v.begin(), df_rows));	
		id_a=Rcpp::as<arma::colvec>(id_v);
	Rcpp::IntegerVector type(ints_v.begin()+df_rows, std::next(ints_v.begin()+df_rows, df_rows));	
		type_v=type;
	Rcpp::IntegerVector cparent_v(ints_v.begin()+2*df_rows, std::next(ints_v.begin()+2*df_rows, df_rows));
		cparent_a=Rcpp::as<arma::colvec>(cparent_v);	
	Rcpp::IntegerVector moe(ints_v.begin()+3*df_rows, std::next(ints_v.begin()+3*df_rows, df_rows));
		moe_v=moe;
	Rcpp::IntegerVector etype(ints_v.begin()+4*df_rows, std::next(ints_v.begin()+4*df_rows, df_rows));			
		etype_v=etype;
	Rcpp::NumericVector pbf(nums_v.begin(), std::next(nums_v.begin(), df_rows));
		pbf_v=pbf;
	Rcpp::NumericVector p1(nums_v.begin()+df_rows, std::next(nums_v.begin()+df_rows, df_rows));
		p1_v=p1;
	Rcpp::NumericVector p2(nums_v.begin()+2*df_rows, std::next(nums_v.begin()+2*df_rows, df_rows));
		p2_v=p2;
				
	if(p2_v[0]>0)  {			
		mission_time=p2_v[0];		
	}else{			
		mission_time=10000;		
	}			

}	

int Ftree::get_type(int ft_node)  {
// Using Armadillo to find the vector position of a given tree id
//	arma::colvec id_a=Rcpp::as<arma::colvec>(id_v);
	int vpos = arma::as_scalar(arma::find(id_a == ft_node));
	int type=type_v(vpos);
return type;
}	

std::string Ftree::get_tag(int ft_node)  {	
// Using Armadillo to find the vector position of a given tree id	
//	arma::colvec id_a=Rcpp::as<arma::colvec>(id_v);
	int vpos = arma::as_scalar(arma::find(id_a == ft_node));
	std::string tag=Rcpp::as<std::string>(tag_v[vpos]);
	return tag;
}

int Ftree::get_moe(int ft_node)  {	
// Using Armadillo to find the vector position of a given tree id	
//	arma::colvec id_a=Rcpp::as<arma::colvec>(id_v);
	int vpos = arma::as_scalar(arma::find(id_a == ft_node));
	int moe = moe_v[vpos];
	return moe;
}

Rcpp::List Ftree::get_children(int ft_node)  {			
// Using Armadillo to find the vector position of a given tree id			
//	arma::colvec id_a=Rcpp::as<arma::colvec>(id_v);		
	int vpos = arma::as_scalar(arma::find(id_a == ft_node));		
//	arma::colvec cparent_a=Rcpp::as<arma::colvec>(cparent_v);		
			
	Rcpp::IntegerVector g_child_v ;		
	Rcpp::IntegerVector b_child_v ;		
			
			
	arma::uvec chpos_a=arma::find(cparent_a==id_a[vpos]);		
	Rcpp::IntegerVector chpos(chpos_a.begin(), chpos_a.end());		
	for( int k=0; k<chpos.size(); k++)  {		
		if(this->get_type(id_a(chpos(k)))<10)  {	
			b_child_v.push_back(id_a[chpos(k)]);
		}else{	
			g_child_v.push_back(id_a[chpos(k)]);
		}	
	}		
// now prepare these on an Rcpp::List			
			return Rcpp::List::create(			
	Rcpp::Named("basic_child_v") = b_child_v,		
	 Rcpp::Named("gate_child_v") = g_child_v);		
}

int Ftree::get_index(std::string tag_in)  {	
// don't know the size before hand so set a fixed large size that it could never exceed
	arma::colvec tag_id(tag_v.size());
	int	tag_index = 0;
		for(unsigned int index=0; index<id_a.size(); index++)  {	
			if(tag_v[index] == tag_in)  {
				tag_id[tag_index]=id_a[index];
				tag_index++;
			}
		}
// resize to now known size to avoid random interference with min() determination
	tag_id.resize(tag_index);
	return tag_id.min();	
}	
			
unsigned int Ftree::get_AND_count() {
	unsigned int count=0;
	for(int index=0; index<type_v.size(); index++)  {
		if(type_v[index] > 10)  count++;
	}
	return count;
}

unsigned int Ftree::get_max_order()  {
	return(max_order);
}

void Ftree::set_max_order(unsigned int mo)  {
	max_order = mo;
}

double Ftree::get_prob(std::string tag_in)  {	
	double ret = 0.0 ;
	auto it = std::find(tag_v.begin(), tag_v.end(), tag_in);
	if (it != tag_v.end()) {
// string found! now get position to grab same position in pbf_v for result	
	auto pos=std::distance(tag_v.begin(), it);
	ret=pbf_v[pos];
	}
	return ret;
}	

double Ftree::get_prob(int id_in)  {	
	arma::uvec pos=arma::find(id_a==id_in);
	double ret=pbf_v[(int) pos(0)];
	return ret;
}	
	
