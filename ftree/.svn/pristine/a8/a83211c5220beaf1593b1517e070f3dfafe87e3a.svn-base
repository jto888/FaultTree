#ifndef _FaultTree_H
#define _FaultTree_H

#ifdef __cplusplus

#include <RcppArmadillo.h>
#include <memory>
#include "include/Ftree.h"
#include "include/Table1.h"
#include "include/Table2.h"
#include "include/Ite.h"
#include "include/ImpPaths.h"
#include "include/cuts.h"

RcppExport SEXP get_bdd( SEXP, SEXP, SEXP, SEXP);

// implementations found in file bddgen.cpp
std::string bddgen(std::unique_ptr<Ftree>& FT, std::unique_ptr<Table1>& T1, int ft_node);
Ite FT2BDD(std::unique_ptr<Ftree>& FT, std::unique_ptr<Table1>& T1, int ft_node);
Ite BDD_apply(std::unique_ptr<Ftree>& FT, std::unique_ptr<Table1>& T1, Ite F, Ite G, std::string op);
std::string BDD_txapply1(std::unique_ptr<Ftree>& FT, std::unique_ptr<Table1>& T1, std::string txt, Ite H, std::string op);
std::string BDD_txapply2(std::unique_ptr<Ftree>& FT, std::unique_ptr<Table1>& T1, std::string txt1, std::string txt2, std::string op);					

// implementations found in file mocus.cpp
RcppExport SEXP mocus( SEXP, SEXP, SEXP, SEXP, SEXP);
std::vector<arma::Row<int>>  get_unique_paths(std::unique_ptr<Ftree>& FT, int ft_node);
std::vector<arma::Mat<int>>  generate_path_list(std::vector<arma::Row<int>> unique_paths, unsigned int max_order);
SEXP mcub(std::unique_ptr<Ftree>& FT, std::vector<arma::Mat<int>> cs_list);

// implementations found in file extractmin.cpp (common to mocus and prime_implicants)
std::vector<arma::Mat<int>> extract_minimals(std::vector<arma::Mat<int>> cs_list);
void pack_cs(std::unique_ptr<Ftree>& FT, std::vector<arma::Mat<int>> cs_list,
	std::unique_ptr<Cuts>& cuts, int out_form);

// implementations found in file prmeimp.cpp
RcppExport SEXP prime_implicants( SEXP, SEXP, SEXP, SEXP, SEXP out__form);
void solutions(std::unique_ptr<Ftree>& FT, std::unique_ptr<ImpPaths>& Imp,			
		std::string F_bdd,  std::string sigma);
std::vector<arma::Mat<int>>  bdd_path_list(std::unique_ptr<Ftree>& FT, std::unique_ptr<ImpPaths>& Imp);	

// implementations found in file probabiity.cpp
RcppExport SEXP get_probability( SEXP, SEXP, SEXP, SEXP);
double BDD_probability(std::unique_ptr<Ftree>& FT, std::unique_ptr<Table2>& T2, std::string bdd);


#endif
#endif
