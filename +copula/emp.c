#include "mex.h"
#include "matrix.h"

void emp(double* x, double* y, mwSize n, mwSize d)
{
    int i, j, k;
    int count, res;    
    
	for (i = 0; i < n; i++)
	{
		count = 0;
		for (j = 0; j < n; j++) 
		{
			 res = 1;
			 for (k = 0; k < d; k++)
			   res *= (x[k * n + j] <= x[k * n + i]);
			 count += res;
		}
		y[i] = (double) count / n;
	}
}

void mexFunction( int nlhs, mxArray *plhs[], int rlhs, const mxArray *prhs[])
{
    double *x;
    mwSize n;
    mwSize d;
    double *y;
    
    /* Read input data. */
    x = mxGetPr(prhs[0]);
    n = mxGetM(prhs[0]);
    d = mxGetN(prhs[0]);
    
    /* Prepare output data. */
    plhs[0] = mxCreateDoubleMatrix(n, 1, mxREAL);
    y = mxGetPr(plhs[0]);
    
    emp(x, y, n, d);
}