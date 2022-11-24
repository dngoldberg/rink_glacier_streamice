function [im_mean,im_conv,count,NaNcount] = fct_convNaN(im_in, filter, SHAPE, maxNan)
% [im_mean,im_conv,count,NaNcount] = fct_convNaN(im_in, filter, SHAPE, maxNan)
%
% Convolute the image by a filter without propagating all the nans in
% the input image
%
% Inputs:
%   im_in: the inital image that can contain NaN
%   filter: the kernel of the filter to be convoluted with the image. Can't
%   contain NaN
%   SHAPE: the SHAPE parameter of the conv2 fonction. Can be 'full', 'same'
%   or 'valid'
%   maxNan: the maximum number of NaN's in the filter (it depends of the
%   weight in the filter)
%
% Outputs:
%   im_mean: the mean of 
%   im_conv: the convolution
%   count: the number of valid pixel in the filter
%   NaNcount: the number of NaN's in the filter for each pixel
%
% F Weissgerber - 2017-10-27

denom = ones(size(im_in));
denom(isnan(im_in)) = 0;
num = im_in;
num(isnan(im_in)) = 0;
im_conv = conv2(num, filter, SHAPE);

count = conv2(denom,filter,SHAPE);
im_mean = conv2(num, filter, SHAPE)./count;

mask = 1-denom;
NaNcount = conv2(mask,filter,SHAPE);

im_mean(NaNcount>maxNan)=NaN;
im_conv(NaNcount>maxNan)=NaN;

end