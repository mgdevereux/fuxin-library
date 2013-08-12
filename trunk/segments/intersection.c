/* Copyright (C) 2010 Joao Carreira

 This code is part of the extended implementation of the paper:
 
 J. Carreira, C. Sminchisescu, Constrained Parametric Min-Cuts for Automatic Object Segmentation, IEEE CVPR 2010
 */

#include <omp.h>
#include <mex.h>

void intersection(unsigned int *intersections, mxLogical *segms, int nc, int nr) {
    int i, j, index_ij, index_ik, index_jk, k, cint;

    {
#pragma omp parallel for private(index_ik, index_jk, index_ij, i, j, k)
        for(i=0; i<nc; i++) { /* for each segment */
        {
            index_ij = i*(nc + 1);
            for(j=i+1; j<nc; j++) { /* go through the others with j>i */
                index_ij++;
                index_ik = i * nr;
                index_jk = j * nr;
                cint = 0;
                for( k=0; k<nr; k++) { /* compute intersections */
                    cint += (segms[index_ik] * segms[index_jk]);  
                    index_ik++;
                    index_jk++;   
                }
                intersections[index_ij] = cint;
            }
        }
    }
    return;
}
