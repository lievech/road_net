#!/bin/bash
set -e

cd build

SKIP_TESTS="dummy"

if [[ "${blas_impl}" == "blis" ]]; then
  # conda-build can't install a correct environment for testing
  exit 0
fi

if [[ "$(uname)" != "Darwin" ]]; then
  ulimit -s unlimited
fi

if [[ "$(uname)" == "Darwin" ]]; then
  # testing with shared libraries does not work. skip them.
  # to test that program exits if wrong parameters are given, what the testsuite
  # do is that the symbol xerbla (xerbla logs the error and exits) is overriden
  # by the test program's own version which reports to the test program that
  # xerbla was called. This does not work with dylibs on osx and dlls on windows
  SKIP_TESTS="${SKIP_TESTS}|x*cblat2|x*cblat3"
fi

if [[ "${blas_impl}" == "mkl" ]]; then
  # These tests fail even when linked directly against mkl_rt. Skip for now
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstz_sep_in|LAPACK-xeigtstz_zsb_in|LAPACK-xeigtstz_se2_in|LAPACK-xlintstrfz_ztest_rfp_in|LAPACK-xlintstz_ztest_in"
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xlintstc_ctest_in|LAPACK-xlintstrfc_ctest_rfp_in|LAPACK-xeigtstc_sep_in|LAPACK-xeigtstc_se2_in|LAPACK-xeigtstc_ced_in"
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstc_csb_in|LAPACK-xeigtstc_csg_in|LAPACK-xeigtstz_zed_in|LAPACK-xeigtstz_zsg_in|LAPACK-xlintstzc_zctest_in"
  SKIP_TESTS="${SKIP_TESTS}|BLAS-xblat1c|BLAS-xblat1z"

  if [[ $(uname) == "Linux" ]]; then
    SKIP_TESTS="${SKIP_TESTS}|example_DGELS_rowmajor|example_DGELS_colmajor"
  fi
fi

if [[ "${blas_impl}" == "openblas" && "$(uname)" == MINGW* ]]; then
  # I'm not sure why these fail only on Windows. Skip for now.
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtsts_sgd_in|LAPACK-xeigtsts_glm_in|LAPACK-xeigtsts_gsv_in|LAPACK-xeigtsts_lse_in|LAPACK-xeigtstd_dgd_in"
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstd_glm_in|LAPACK-xeigtstd_gsv_in|LAPACK-xeigtstd_lse_in|LAPACK-xlintstc_ctest_in|LAPACK-xlintstrfc_ctest_rfp_in"
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstc_sep_in|LAPACK-xeigtstc_se2_in|LAPACK-xeigtstc_ced_in|LAPACK-xeigtstc_cgd_in|LAPACK-xeigtstc_csb_in"
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstc_csg_in|LAPACK-xeigtstc_glm_in|LAPACK-xeigtstc_gsv_in|LAPACK-xeigtstc_lse_in|LAPACK-xeigtstz_zgd_in"
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstz_glm_in|LAPACK-xeigtstz_gsv_in|LAPACK-xeigtstz_lse_in|BLAS-xblat1c"
fi

if [[ ! "$(uname -m)" == "x86_64" ]]; then
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstz"
fi

ctest --output-on-failure -E "${SKIP_TESTS}"
