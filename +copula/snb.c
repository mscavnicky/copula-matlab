#include <math.h>

#include "mex.h"
#include "matrix.h"

#define MAX(x, y) (((x) > (y)) ? (x) : (y))

/**
 * Computes SnB test statistics given data transformed by Rosenblatt's 
 * transform.
 */

double snbStat(double* e,mwSize n, mwSize d)
{
    double t1, t2, t3;
    int i, j, k;
    double prod;
    
    t1 = n / pow(3, d);
    
    t2 = 0;
    for (i=0; i<n; i++)
    {
        prod = 1;
        for (k=0; k<d; k++)
            prod *= 1 - (e[k*n + i] * e[k*n + i]);
        t2 += prod;
    }    
    t2 = t2 / pow(2, d-1);    

    t3 = 0;
    for (i=0; i<n; i++)
    {
        for (j=0; j<n; j++)
        {
            prod = 1;
            for (k=0; k<d; k++)
            {
                prod *= 1 - MAX(e[k*n + i], e[k*n + j]);                
            }
            t3 += prod;
        }
    }    
    t3 = t3 / n;

    return t1 - t2 + t3;
}

void mexFunction( int nlhs, mxArray *plhs[], int rlhs, const mxArray *prhs[])
{
    double *e;
    mwSize n;
    mwSize d;
    double t;
    
    /* Read input data. */
    e = mxGetPr(prhs[0]);
    n = mxGetM(prhs[0]);
    d = mxGetN(prhs[0]);
        
    t = snbStat(e, n, d);
    
    /* Prepare output data. */
    plhs[0] = mxCreateDoubleScalar(t);    
}