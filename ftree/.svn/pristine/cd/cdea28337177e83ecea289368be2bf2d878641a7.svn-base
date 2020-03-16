/*
library(tools)
package_native_routine_registration_skeleton("C:/Repositories/Fault Tree/pkg/FaultTree")
*/

//> package_native_routine_registration_skeleton("C:/Repositories/Fault Tree/pkg/FaultTree")
#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP get_bdd(SEXP, SEXP, SEXP, SEXP);
extern SEXP mocus(SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP prime_implicants(SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP get_probability(SEXP, SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"get_bdd",          (DL_FUNC) &get_bdd,          4},
    {"mocus",            (DL_FUNC) &mocus,            5},
    {"prime_implicants", (DL_FUNC) &prime_implicants, 5},
    {"get_probability",      (DL_FUNC) &get_probability,      4},
    {NULL, NULL, 0}
};

void R_init_FaultTree(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
