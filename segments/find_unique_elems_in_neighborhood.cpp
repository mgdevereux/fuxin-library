#include <algorithm>
#include <mex.h>

const int NHOOD_SIZE = 8;

// Note: only works up to 65536 * 65536 image (should be enough...)
void find_unique_elems_in_neighborhood(const unsigned long *Image, const unsigned long width, const unsigned long height, unsigned long *locs, unsigned long *unique_elems)
{
	const short delta_x[] = {-1,-1,-1,0,0,1,1,1};
	const short delta_y[] = {-1,0,1,-1,1,-1,0,1};
	short counter = 0;
	for(unsigned long pointer=0;pointer <= width * height;pointer++)
	{
		if(Image[pointer])
			continue;
		long i,j;
		short counter2 = 0;
		locs[counter] = pointer + 1;
		i = pointer / height;
		j = pointer % height;
		for(short k=0;k<NHOOD_SIZE;k++)
		{
			short ii;
			if (i + delta_x[k] >= 0 && i + delta_x[k] < width && j + delta_y[k] >= 0 && j + delta_y[k] < height)
			{
				long to_check = Image[(i + delta_x[k]) * height + j + delta_y[k]];
				// Don't check if it's still a boundary
				if (to_check==0)
					continue;
				for (ii = 0;ii<counter2;ii++)
				{
					if (unique_elems[counter*NHOOD_SIZE + ii] == to_check)
						break;
				}
				if (ii==counter2)
				{
					unique_elems[counter*NHOOD_SIZE + counter2] = to_check;
					counter2++;
				}
			}
		}
		// Sort in ascending order
		std::sort(&unique_elems[counter*NHOOD_SIZE],&unique_elems[counter*NHOOD_SIZE+counter2]);
		counter++;
	}
}

unsigned long count_zeros(const unsigned long *image, const long width, const long height)
{
	unsigned long counter = 0;
	for(unsigned long pointer = 0;pointer < width*height;pointer++)
		if(image[pointer] == 0)
			counter++;
	return counter;
}

void mexFunction(int nargout, mxArray *out[], int nargin, const mxArray *in[])
{
    mwSize width, height, nsegms;
	mwSize *sizes;
	unsigned long *image, *o1, *o2, num_elems;
	    /* check argument */
    if (nargin<1) {
        mexErrMsgTxt("One input argument required ( the image in row * column form with the class uint32)");
    }
    if (nargout>2) {
        mexErrMsgTxt("Too many output arguments");
    }    
	sizes = (mwSize *)mxGetDimensions(in[0]);
    height = sizes[0];
    width = sizes[1];

	if (!mxIsClass(in[0],"uint32")) {
        mexErrMsgTxt("Usage: image must be a 2-dimensional uint32 matrix");
    }
	image = (unsigned long *) mxGetData(in[0]);
	unsigned long n_elems = count_zeros(image, width, height);
    out[0] = mxCreateNumericMatrix(n_elems, 1 ,mxUINT32_CLASS, mxREAL);
    out[1] = mxCreateNumericMatrix(NHOOD_SIZE,n_elems,mxUINT32_CLASS, mxREAL);
    if (out[0]==NULL || out[1]==NULL) {
	    mexErrMsgTxt("Not enough memory for the output matrix");
    }
    o1 = (unsigned long *) mxGetPr(out[0]);
    o2 = (unsigned long *) mxGetPr(out[1]);

    find_unique_elems_in_neighborhood(image, width, height, o1, o2);
}